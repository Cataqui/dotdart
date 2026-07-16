Build-time Flutter asset compiler that turns visual assets into dependency-free
Dart widget code.

`dotdart` is for Flutter apps that want asset output as normal Dart source
instead of runtime asset interpreters. It reads supported asset formats during
`build_runner`, generates Flutter widget code, and leaves your app with only
Flutter SDK runtime code. Lottie and SVG are the currently supported formats.

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
  lottie:
    - assets/lottie/
    - assets/onboarding/swipe_up.json
  svg:
    - assets/icons/
    - assets/logos/brand.svg
```

Then run code generation.

```bash
dart run build_runner build
```

In this monorepo, use the workspace script instead:

```bash
melos gen:all
```

## Use the generated Lottie widget

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

## Use the generated SVG widget

If `assets/icons/cross.svg` is configured, dotdart generates
`lib/gen/cross.g.dart` with a widget named `Cross`.

```dart
import 'package:flutter/material.dart';
import 'package:my_app/gen/cross.g.dart';

class MyCloseButton extends StatelessWidget {
  const MyCloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Cross(
      width: 24,
      color1: Color(0xFFFF0000),
    );
  }
}
```

Generated SVG widgets are `StatelessWidget` + `CustomPainter` — no runtime
XML parsing, no picture cache, no `flutter_svg` dependency. All geometry is
precompiled to `static final Path` fields. Two reusable `Paint` objects are
shared across all draw operations.

## Configuration Reference

```yaml
dotdart:
  output: lib/gen/ # output directory, defaults to lib/gen/
  lottie: # Lottie JSON files
    - assets/lottie/ # folder: scans JSON files directly inside it
    - assets/intro.json # file: generates one widget
  svg: # SVG files
    - assets/icons/ # folder: scans .svg files directly inside it
    - assets/logo.svg # file: generates one widget
```

Each asset type gets its own key under `dotdart:`. All configured paths must be
relative to the package root. Absolute paths and paths containing `..` are
rejected so generated files stay inside the package.

## Asset Types

`dotdart` is designed around independent asset pipelines. Each supported format
has its own parser, generator, and configuration key:

- `lottie:` is supported.
- `svg:` is supported.
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

## Supported SVG Features

- **Elements:** `<path>`, `<rect>`, `<circle>`, `<ellipse>`, `<line>`,
  `<polyline>`, `<polygon>`, `<g>` (groups).
- **Path commands:** `M`/`m`, `L`/`l`, `H`/`h`, `V`/`v`, `C`/`c`, `S`/`s`,
  `Q`/`q`, `T`/`t`, `Z`/`z` — all resolved to absolute coordinates
  at build time.
- **Presentation attributes:** `fill`, `fill-opacity`, `fill-rule`, `stroke`,
  `stroke-width`, `stroke-linecap`, `stroke-linejoin`, `stroke-opacity`,
  `opacity`, `transform`.
- **Colors:** `#rgb`, `#rrggbb`, `#rrggbbaa`, `rgb()`, `rgba()`, named colors,
  `none`.
- **`viewBox`** with min-x/min-y offset.
- **Style inheritance:** attributes on `<g>` propagate to children.
- **`clip-rule`:** silently ignored (no-op without `<clipPath>`).
- **Fail-fast on:** gradients, `use`/`symbol`/`defs` references, text, images,
  filters, masks, clip-paths, `<style>` CSS blocks, `matrix()`/`skewX()`/`skewY()`
  transforms.
- **Skip-with-warning:** unknown elements and negligible cosmetic attributes
  (e.g. `stroke-dasharray`).

## Not Yet Supported (SVG)

- Animated SVG (SMIL/CSS animations)
- Gradients (`<linearGradient>`, `<radialGradient>`)
- `<use>`, `<symbol>`, `<defs>` references
- `<text>`, `<tspan>`, `<image>`
- Filters, masks, `<clipPath>`, `<pattern>`
- CSS `<style>` blocks
- `matrix()`, `skewX()`, `skewY()` transforms
- Arc path commands (`A`/`a`)
- `stroke-dasharray`, `stroke-dashoffset`
- `currentColor` as a separate theme slot (currently treated as black)

## Not Yet Supported (Lottie)

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
