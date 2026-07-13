Build-time Flutter asset compiler that turns visual assets into dependency-free
Dart widget code.

`dotdart` is for Flutter apps that want asset output as normal Dart source
instead of runtime asset interpreters. It reads supported asset formats during
`build_runner`, generates Flutter widget code, and leaves your app with only
Flutter SDK runtime code. Lottie is the first supported format; SVG and other
asset types are planned to follow the same asset-to-Dart pipeline.

## Why dotdart?

- Generates self-contained Dart widget code for supported asset formats.
- Avoids shipping format-specific runtime interpreters in the app bundle.
- Keeps animations lifecycle-aware and pauses work when the app is not resumed.
- Respects reduced-motion settings by rendering a static frame.
- Exposes generated color parameters so apps can theme assets without editing
  the source animation.

## Installation

```bash
flutter pub add --dev dotdart build_runner
```

## Configure

Add a `dotdart:` section to your app package's `pubspec.yaml`.

```yaml
dotdart:
  output: lib/gen/
  lottie: # first supported asset type
    - assets/lottie/
    - assets/onboarding/swipe_up.json
  # svg:                       # planned
  #   - assets/icons/
```

Then run code generation.

```bash
dart run build_runner build
```

In this monorepo, use the workspace script instead:

```bash
melos gen:all
```

## Use the generated widget

For the currently supported Lottie pipeline, if
`assets/lottie/swipe_up_onboarding.json` is configured, dotdart generates
`lib/gen/swipe_up_onboarding.g.dart` with a widget named
`SwipeUpOnboarding`.

```dart
import 'package:flutter/material.dart';
import 'package:my_app/gen/swipe_up_onboarding.g.dart';

class OnboardingHint extends StatelessWidget {
  const OnboardingHint({super.key});

  @override
  Widget build(BuildContext context) {
    return const SwipeUpOnboarding(
      width: 160,
      respectDisableAnimations: true,
      color1: Color(0xFFFF4A4B),
    );
  }
}
```

Pass `progress` when you want to drive or pin the animation yourself. Progress
uses the full normalized timeline: `0` is the first frame and `1` is the last
frame. When `progress` is supplied, automatic playback stops.

```dart
const SwipeUpOnboarding(
  width: 160,
  progress: 0.5,
)
```

Generated Lottie widgets respect platform reduced-motion settings by default.
Pass `respectDisableAnimations: false` when a specific animation should keep
playing even if the device is configured to disable animations.

```dart
const SwipeUpOnboarding(
  width: 160,
  respectDisableAnimations: false,
)
```

## Configuration Reference

```yaml
dotdart:
  output: lib/gen/ # output directory, defaults to lib/gen/
  lottie: # Lottie JSON files, currently supported
    - assets/lottie/ # folder: scans JSON files directly inside it
    - assets/intro.json # file: generates one widget
  # svg:                        # planned asset type
  #   - assets/icons/
```

Each asset type gets its own key under `dotdart:`. All configured paths must be
relative to the package root. Absolute paths and paths containing `..` are
rejected so generated files stay inside the package.

## Asset Types

`dotdart` is designed around independent asset pipelines. Each supported format
has its own parser, generator, and configuration key:

- `lottie:` is supported today.
- `svg:` is planned next.
- More visual asset formats can be added without changing the generated-code
  contract.

## Supported Lottie Features

Lottie is the first implementation of the broader dotdart asset-to-code model.
The first release intentionally supports a focused, production-safe subset:

- Shape layers (`ty: 4`)
- Shape groups
- Rectangles, ellipses, and bezier paths
- Solid fills and strokes
- Static group transforms
- Static and keyframed layer opacity, rotation, position, and scale
- Hold keyframes
- Bezier easing for scalar keyframes

Unsupported Lottie shape or layer types are skipped with build warnings when
safe. A malformed Lottie file fails the build with an actionable parser error.

## Not Yet Supported

- Gradients
- Masks and mattes
- Trim paths, repeaters, merge paths, offset paths, pucker/bloat, and zigzag
- Text, image, audio, video, and 3D layers
- Expressions
- Nested groups deeper than the currently supported shape-group structure

## Generated Code Notes

Generated files import only Flutter and `dart:math`. They do not import
`dotdart`, so your app does not need any dotdart runtime code after generation.

The generated Lottie painter is optimized for continuously animated UI:

- Animation ticks repaint the `CustomPainter` directly without rebuilding or
  laying out the widget tree.
- Static paths, rectangles, ellipses, and compound paths are constructed once
  and reused across frames.
- Each painter retains one fill paint and one stroke paint instead of allocating
  paint objects during every frame.
- Scalar keyframes compile to specialized Dart evaluators. Constant properties
  and constant keyframe segments are folded away, while identical bezier curves
  reuse the exact Flutter `Cubic` result for the same progress.
- Identity transforms and fully transparent static groups are removed during
  generation. Generated painters avoid `saveLayer` for the supported feature
  set.

These optimizations remove runtime JSON parsing, format-model traversal, and
avoidable frame allocations. They do not make GPU rasterization free: very
large paths, many overlapping translucent shapes, or future masks and effects
can still be expensive.

When removing or renaming an input asset, delete the old generated file or run a
clean build so stale source outputs do not remain in your app.
