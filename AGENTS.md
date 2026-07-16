# AGENTS.md — dotdart

## Purpose

`dotdart` is a build-time code generator that converts visual assets (Lottie, SVG, and more) into pure-Dart `CustomPainter` widget code. No runtime dependency — the generated code is self-contained Flutter widgets.

## Architecture

```
lib/
├── dotdart.dart              # Barrel — exports builder factories
└── src/
    ├── builders/
    │   └── dotdart_builder.dart  # build_runner Builder (PostProcessBuilder pattern)
    ├── generators/
    │   ├── accessor_param.dart    # AccessorParam model for constructor params
    │   ├── naming.dart            # Naming helpers (widgetClassName, accessorName, namespaceNameFromFolder)
    │   ├── namespace_assembler.dart # Combines widget fragments into per-folder namespace files
    │   ├── shared_emit.dart       # Shared mixin/helper source emission (SVG sizing, Lottie lifecycle, opacity)
    │   ├── lottie_generator.dart  # Lottie model → widget-class fragment
    │   └── svg_generator.dart     # SvgDocument → widget-class fragment
    ├── models/
    │   ├── lottie_animation.dart  # Top-level Lottie model
    │   ├── lottie_layer.dart     # Layer model
    │   ├── lottie_shape.dart     # Shape model (sealed class)
    │   ├── lottie_keyframe.dart  # Keyframe model
    │   ├── svg_document.dart     # SVG document model (viewBox, root elements)
    │   ├── svg_element.dart      # SVG element model (path/rect/circle/group, etc.)
    │   └── svg_style.dart        # Resolved SVG presentation attributes
    └── parsers/
        ├── lottie_parser.dart    # JSON → LottieAnimation
        └── svg/
            ├── svg_parser.dart       # XML → SvgDocument (orchestrates the below)
            ├── svg_mini_xml.dart     # Minimal XML parser (no external dependency)
            ├── svg_path_data.dart    # SVG path d attribute parser
            └── svg_transform.dart    # SVG transform attribute parser
```

## Key Design Decisions

- **Namespace-grouped output**: Assets are grouped by their source folder. Each folder produces one flat `<folder>.g.dart` file (e.g. `lib/gen/icons.g.dart`) containing an `abstract final class $FolderName` with one static method per asset. Widget class names are PascalCase but library-private (prefixed with `_`); consumers use the accessor methods which return `Widget`.
- **Self-contained output**: Generated `.g.dart` files only import `dart:math` and `package:flutter/material.dart`. No `dotdart` import in generated code.
- **Shared mixins**: Each generated file deduplicates common logic into file-level mixins (`_DotdartSvgSizing`, `_DotdartLottieAnimationState<T>`) and a shared `_dotdartApplyOpacity` function. Generators emit only the asset-specific fields, getters, and `buildPainter()` override.
- **Fail fast on unsupported features**: Parser throws `DotdartUnsupportedFeatureException` with a clear message.
- **Config**: Type-keyed folders/files under `dotdart:` in `pubspec.yaml`. Each key (e.g. `lottie:`, `svg:`) represents an asset type.
- **Content-based detection**: Each asset type is validated by inspecting file content, not extension alone.
- **PostProcessBuilder pattern**: Like `flutter_gen_runner`, the normal builder writes a manifest and a post-process builder materializes files to the configured output directory.
- **Stale file cleanup**: The post-process builder scans the output directory for `.g.dart` files not in the current output set and deletes them.
- **Accessor naming**: Asset filenames are converted to lowerCamelCase accessor names (`arrow_left.svg` → `arrowLeft`). Namespace names are PascalCase from the folder name (`icons` → `Icons` → `$Icons`). Widget class names are PascalCase from the filename (`arrow_left.svg` → `ArrowLeft`).

## Adding a New Asset Type

1. Create a parser in `lib/src/parsers/<type>/` (e.g. `svg/svg_parser.dart`)
2. Create a generator in `lib/src/generators/` (e.g. `svg_generator.dart`).
   The generator must expose:
   - `generateWidgetClass()` → returns widget + painter source (no header/imports, unformatted)
   - `params` getter → returns `List<AccessorParam>` describing constructor parameters
   - `widgetClassName` → private PascalCase class name (prefixed with `_`) from the source path
3. Add the asset type key to the config parser in `dotdart_builder.dart`
4. Add the asset type to the `DotdartAssetType` enum in `namespace_assembler.dart`
5. If shared mixins are needed, add emission logic to `shared_emit.dart`
6. Route parsed models to the appropriate generator in the builder's `build` method.
   The builder automatically groups assets by parent folder and passes them to `NamespaceAssembler`.

## Testing

- Parser tests: feed known input → verify parsed model
- Generator tests: feed model → verify generated code string
- Widget tests: render generated widget in test harness
