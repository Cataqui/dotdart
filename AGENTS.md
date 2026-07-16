# AGENTS.md — dotdart

## Purpose

`dotdart` is a build-time Flutter asset compiler for type-safe, optimized asset
access. Its purpose is to turn supported SVG, Lottie, and raster image files
into generated Dart widgets that do as little runtime work as practical when
displayed.

The package name is the product promise: the asset becomes Dart. SVG paths
become `Path` fields, Lottie shape animations become `CustomPainter` code, and
raster images become optimized `Image.asset` accessors with build-time metadata.
The generated code should be easier to type-check, theme, test, and maintain
than string-based asset paths or black-box runtime renderers.

Public docs and generated APIs must preserve this positioning:

- type-safe namespace access over repeated asset-path strings;
- generated Dart widgets over runtime SVG/Lottie rendering packages;
- low runtime memory pressure, especially for raster image decode sizing and
  namespace precaching;
- manipulable assets through typed parameters such as colors, progress, size,
  and animation behavior;
- no runtime dependency on `dotdart` after generation.

## Architecture

```
lib/
├── dotdart.dart              # Barrel — exports builder factories
└── src/
    ├── builders/
    │   └── dotdart_builder.dart  # build_runner Builder (PostProcessBuilder pattern)
    ├── generators/
    │   ├── accessor_param.dart    # Single source of truth for generated parameters
    │   ├── generated_asset_spec.dart # Immutable asset contract used across generation
    │   ├── image_generator.dart   # RasterImage model → optimized Image.asset widget class
    │   ├── naming.dart            # Naming helpers (widgetClassName, accessorName, namespaceNameFromFolder)
    │   ├── namespace_assembler.dart # Combines widget fragments into per-folder namespace files
    │   ├── shared_emit.dart       # Shared mixin/helper source emission (SVG sizing, Lottie lifecycle, opacity, thumbhash)
    │   ├── lottie_generator.dart  # Lottie model → widget-class fragment
    │   └── svg_generator.dart     # SvgDocument → widget-class fragment
    ├── models/
    │   ├── raster_image.dart      # Raster image metadata (dims, format, thumbhash, dominant color)
    │   ├── raster_image_enums.dart # RasterImageFormat enum (part)
    │   ├── lottie_animation.dart  # Top-level Lottie model
    │   ├── lottie_layer.dart     # Layer model
    │   ├── lottie_shape.dart     # Shape model (sealed class)
    │   ├── lottie_keyframe.dart  # Keyframe model
    │   ├── svg_document.dart     # SVG document model (viewBox, root elements)
    │   ├── svg_element.dart      # SVG element model (path/rect/circle/group, etc.)
    │   └── svg_style.dart        # Resolved SVG presentation attributes
    └── parsers/
        ├── lottie_parser.dart    # JSON → LottieAnimation
        ├── raster/
        │   ├── raster_parser.dart # Image bytes (via `image` pkg) → RasterImage
        │   └── thumbhash.dart     # Thumbhash encoder + decoder source emitter
        └── svg/
            ├── svg_parser.dart       # XML → SvgDocument (orchestrates the below)
            ├── svg_mini_xml.dart     # Minimal XML parser (no external dependency)
            ├── svg_path_data.dart    # SVG path d attribute parser
            └── svg_transform.dart    # SVG transform attribute parser
```

## Key Design Decisions

- **Namespace-grouped output**: Assets are grouped by their source folder. Each folder produces one flat `<folder>.g.dart` file (e.g. `lib/gen/icons.g.dart`) containing an `abstract final class $FolderName` with one static method per asset. Widget class names are PascalCase but library-private (prefixed with `_`); consumers use the accessor methods which return `Widget`.
- **Self-contained output**: Generated `.g.dart` files only import `dart:math` and Flutter SDK libraries. No `dotdart` import in generated code.
- **Shared mixins**: Each generated file deduplicates common logic into file-level mixins (`_DotdartSvgSizing`, `_DotdartLottieAnimationState<T>`) and a shared `_dotdartApplyOpacity` function. Generators emit only the asset-specific fields, getters, and `buildPainter()` override.
- **Low-resource raster defaults**: Raster accessors use build-time dimensions,
  aspect ratio, dominant color, thumbhash, decode-cache sizing, and sequential
  precaching so callers get efficient image behavior without remembering manual
  per-call optimizations.
- **Manipulable generated vectors**: SVG and Lottie pipelines expose supported
  colors, sizing, progress, and animation controls as typed parameters instead
  of forcing source-file edits or runtime renderer configuration.
- **Fail fast on unsupported features**: Parser throws `DotdartUnsupportedFeatureException` with a clear message.
- **Config**: Type-keyed folders/files under `dotdart:` in `pubspec.yaml`. Each key (e.g. `lottie:`, `svg:`) represents an asset type.
- **Content-based detection**: Each asset type is validated by inspecting file content, not extension alone.
- **PostProcessBuilder pattern**: Like `flutter_gen_runner`, the normal builder writes a manifest and a post-process builder materializes files to the configured output directory.
- **Stale file cleanup**: The post-process builder deletes only stale files carrying dotdart's exact ownership header. Shared output directories must preserve files from other generators.
- **Accessor naming**: Asset filenames are converted to lowerCamelCase accessor names (`arrow_left.svg` → `arrowLeft`). Namespace names are PascalCase from the folder name (`icons` → `Icons` → `$Icons`). Widget class names are PascalCase from the filename (`arrow_left.svg` → `ArrowLeft`).

## Documentation Rules

- Describe dotdart as type-safe, optimized Flutter asset access generated as
  Dart code.
- Keep the README consumer-first and pub.dev-friendly: start with what users get
  and why it is better than string paths or runtime renderers before explaining
  internals.
- Do not claim complete SVG or Lottie support. Be explicit that dotdart compiles
  a focused, mobile-friendly subset and fails fast for unsupported content.
- Do not expose raw cache keys as public API. Prefer generated behavior that is
  hard to misuse, such as namespace-level `precache(BuildContext)`.
- Keep low-end device behavior visible in docs whenever raster decoding,
  precaching, animation repainting, or runtime dependencies change.

## Adding a New Asset Type

1. Create a parser in `lib/src/parsers/<type>/` (e.g. `svg/svg_parser.dart`, `raster/raster_parser.dart`)
2. Create a generator in `lib/src/generators/` (e.g. `svg_generator.dart`, `image_generator.dart`).
   The generator must expose:
   - `generateWidgetClass()` → returns widget + painter source (no header/imports, unformatted)
   - `params` getter → returns `List<AccessorParam>` describing constructor parameters
   - `widgetClassName` → private PascalCase class name (prefixed with `_`) from the source path
3. Add the asset type to `DotdartAssetType`, including its configuration key, extensions, and documentation extension.
4. Add its parse/generate branch to the exhaustive asset-pipeline switch in `dotdart_builder.dart`.
5. If shared mixins/helpers are needed, add emission logic to `shared_emit.dart`
6. Route parsed models to the appropriate generator in the builder's `build` method.
   The builder automatically groups assets by parent folder and passes them to `NamespaceAssembler`.
7. Every namespace accessor returns `Widget`, including raster accessors. Raster
   namespaces additionally expose sequential `precache(BuildContext)` helpers.

## Testing

- Parser tests: feed known input → verify parsed model
- Generator tests: feed model → verify generated code string
- Widget tests: render generated widget in test harness
- Consumer fixture: run real build_runner, analyze the generated libraries, and
  pump every supported asset type through its public namespace accessor
