# AGENTS.md — dotdart

## Purpose

`dotdart` is a build-time code generator that converts visual assets (Lottie, SVG, and more) into pure-Dart `CustomPainter` widget code. No runtime dependency — the generated code is self-contained Flutter widgets.

## Architecture

```
lib/
├── dotdart.dart              # Barrel — exports builder + runtime helpers
└── src/
    ├── builders/
    │   └── dotdart_builder.dart  # build_runner Builder (PostProcessBuilder pattern)
    ├── generators/
    │   └── lottie_generator.dart # Lottie model → Dart source string
    ├── models/
    │   ├── lottie_animation.dart  # Top-level Lottie model
    │   ├── lottie_layer.dart     # Layer model
    │   ├── lottie_shape.dart     # Shape model (sealed class)
    │   └── lottie_keyframe.dart  # Keyframe model
    └── parsers/
        └── lottie_parser.dart    # JSON → LottieAnimation
```

## Key Design Decisions

- **Self-contained output**: Generated `.g.dart` files only import `dart:math` and `package:flutter/material.dart`. No `dotdart` import in generated code.
- **Fail fast on unsupported features**: Parser throws `DotdartUnsupportedFeatureException` with a clear message.
- **Config**: Type-keyed folders/files under `dotdart:` in `pubspec.yaml`. Each key (e.g. `lottie:`, `svg:`) represents an asset type.
- **Content-based detection**: Each asset type is validated by inspecting file content, not extension alone.
- **PostProcessBuilder pattern**: Like `flutter_gen_runner`, the normal builder writes a manifest and a post-process builder materializes files to the configured output directory.

## Adding a New Asset Type

1. Create a parser in `lib/src/parsers/` (e.g. `svg_parser.dart`)
2. Create a generator in `lib/src/generators/` (e.g. `svg_generator.dart`)
3. Add the asset type key to the config parser in `dotdart_builder.dart`
4. Route parsed models to the appropriate generator in the builder's `build` method

## Testing

- Parser tests: feed known input → verify parsed model
- Generator tests: feed model → verify generated code string
- Widget tests: render generated widget in test harness
