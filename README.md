# dotdart

[![CI](https://github.com/Ventairy/dotdart/actions/workflows/ci.yml/badge.svg)](https://github.com/Ventairy/dotdart/actions/workflows/ci.yml)
[![GitHub release](https://img.shields.io/github/v/release/Ventairy/dotdart)](https://github.com/Ventairy/dotdart/releases)
[![MIT license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/Ventairy/dotdart/blob/main/LICENSE)

Type-safe Flutter asset access, generated as optimized Dart code.

dotdart compiles supported SVG, Lottie, images, and GIFs into strongly named
Flutter widgets such as `$Icons.cross()`, `$Lotties.pulse()`, and
`$Images.cataqui()`. Asset mistakes fail during generation instead of becoming
runtime surprises.

## Lottie performance

For the 978 KB job-card carousel in this repository's example, the generated
widget sustained 60.2 FPS while the
[`lottie` 3.5.1](https://pub.dev/packages/lottie/versions/3.5.1) player sustained
27.2 FPS:

| Renderer       | Frames in 10 seconds | Average UI time | Average raster time | Missed UI frames |
| -------------- | -------------------: | --------------: | ------------------: | ---------------: |
| dotdart output |                  602 |         0.434 ms |             4.62 ms |            0/602 |
| `lottie` 3.5.1 |                  272 |         32.04 ms |             3.33 ms |          271/272 |

That is about 74 times less UI-thread work and 7 times less combined UI and
raster time for this animation. The comparison used the same canvas and asset
for two 10-second profile-mode runs on the same macOS host. It demonstrates the
relative rendering cost of these implementations, not guaranteed frame rates on
every device; profile representative animations on target hardware before
shipping performance-critical experiences.

## Platform support

Generated widgets support Flutter on Android, iOS, Web, macOS, Windows, and
Linux, including Web's JavaScript and Wasm compilation targets.

dotdart itself runs on the development machine through `build_runner`. Keep it
in `dev_dependencies`; applications import the generated libraries rather than
dotdart at runtime.

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

Add dotdart and build_runner as development dependencies:

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
import 'package:flutter/material.dart';

final closeIcon = $Icons.close(width: 24);
final pulse = $Lotties.pulse(width: 96);
final jobCards = $Lotties.jobCards(
  width: 320,
  clip: false,
  overrides: const JobCardsOverrides(
    jobTitleText: 'Event server',
    payTextColor: Colors.green,
  ),
);
final image = $Images.profile(width: 160);
```

Supported Lottie text and colors become fields on the generated `overrides`
object.
Repeated names receive numbered suffixes, such as `jobTitleText2`, so each layer
remains independent. Unnamed layers use predictable `text1`, `color1`, and later
fallbacks.

Generated Lotties clip painting to their source canvas by default. Pass
`clip: false` when artwork should remain visible outside that boundary.

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

- [Configuration reference](https://github.com/Ventairy/dotdart/blob/main/doc/configuration.md)
- [Supported SVG, Lottie, image, and GIF features](https://github.com/Ventairy/dotdart/blob/main/doc/asset-support.md)
- [Performance model](https://github.com/Ventairy/dotdart/blob/main/doc/performance.md)
- [Troubleshooting](https://github.com/Ventairy/dotdart/blob/main/doc/troubleshooting.md)
- [Runnable example](https://github.com/Ventairy/dotdart/tree/main/example)

## Requirements

- Dart `>=3.12.0 <4.0.0`
- Flutter `3.44.0` for development in this repository
- `build_runner >=2.15.0` for the post-process builder flow

## Status

dotdart is pre-1.0. Breaking changes can occur in minor releases and will be
documented with migration guidance in the changelog.
