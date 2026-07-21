# dotdart

[![CI](https://github.com/Cataqui/dotdart/actions/workflows/ci.yml/badge.svg)](https://github.com/Cataqui/dotdart/actions/workflows/ci.yml)
[![GitHub release](https://img.shields.io/github/v/release/Cataqui/dotdart)](https://github.com/Cataqui/dotdart/releases)
[![MIT license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/Cataqui/dotdart/blob/main/LICENSE)

Type-safe Flutter asset access, generated as optimized Dart code.

dotdart compiles supported SVG, Lottie, images, and GIFs into strongly named
Flutter widgets such as `$Icons.cross()`, `$Lotties.pulse()`, and
`$Images.cataqui()`. Asset mistakes fail during generation instead of becoming
runtime surprises.

## Why dotdart?

- **Typed access:** rename or remove an asset and Dart analysis finds every stale
  call site.
- **No SVG or Lottie runtime renderer:** supported vectors and animations become
  ordinary `CustomPainter` code.
- **Low-resource image defaults:** generated image and GIF widgets include decode sizing,
  intrinsic metadata, a thumbhash placeholder, and sequential precaching.
- **Build-time validation:** malformed configuration, unsupported content,
  duplicate inputs, naming collisions, and unsafe output paths fail early.
- **Self-contained output:** generated libraries depend on Flutter, not dotdart.

## Install

Until the first pub.dev release, depend on the immutable GitHub release tag:

```yaml
dev_dependencies:
  build_runner: ^2.15.0
  dotdart:
    git:
      url: https://github.com/Cataqui/dotdart.git
      ref: v0.6.0
```

After dotdart is published, the Git dependency can be replaced with:

```bash
flutter pub add --dev dotdart build_runner
```

## Quick start

Configure the inputs and output in your package's `pubspec.yaml`:

```yaml
dotdart:
  output: lib/gen/
  svg:
    - assets/icons/
  lottie:
    - assets/lotties/
  image:
    - assets/images/

flutter:
  assets:
    - assets/images/
```

Images and GIFs remain Flutter assets because their generated widgets use
`Image.asset`. SVG and Lottie inputs are compiled into Dart and do not need to
be listed under `flutter.assets`.

Generate the libraries:

```bash
dart run build_runner build
```

Import and use the namespace generated from each source folder:

```dart
import 'package:my_app/gen/icons.g.dart';
import 'package:my_app/gen/images.g.dart';
import 'package:my_app/gen/lotties.g.dart';

final closeIcon = $Icons.close(width: 24);
final pulse = $Lotties.pulse(width: 96);
final image = $Images.profile(width: 160);
```

## Generated output

| Input                        | Generated API          | Runtime implementation          |
| ---------------------------- | ---------------------- | ------------------------------- |
| `assets/icons/close.svg`     | `$Icons.close(...)`    | Dependency-free `CustomPainter` |
| `assets/lotties/pulse.json`  | `$Lotties.pulse(...)`  | Lifecycle-aware `CustomPainter` |
| `assets/images/profile.webp` | `$Images.profile(...)` | Optimized `Image.asset`         |

Assets are grouped by their parent folder. Mixed asset types in
`assets/status/` share one `lib/gen/status.g.dart` library and one
`$Status` namespace.

Generated widget classes are private. Consume assets through their public
namespace methods and do not edit generated files by hand.

## Documentation

- [Configuration reference](https://github.com/Cataqui/dotdart/blob/main/doc/configuration.md)
- [Supported SVG, Lottie, image, and GIF features](https://github.com/Cataqui/dotdart/blob/main/doc/asset-support.md)
- [Performance model](https://github.com/Cataqui/dotdart/blob/main/doc/performance.md)
- [Troubleshooting](https://github.com/Cataqui/dotdart/blob/main/doc/troubleshooting.md)
- [Runnable example](https://github.com/Cataqui/dotdart/tree/main/example)

## Requirements

- Dart `>=3.12.0 <4.0.0`
- Flutter `3.44.0` for development in this repository
- `build_runner >=2.15.0` for the post-process builder flow

## Status

dotdart is pre-1.0. Breaking changes can occur in minor releases and will be
documented with migration guidance in the changelog.
