Build-time Flutter asset compiler that makes visual assets accessible in Dart
with maximum out-of-the-box optimization — `$Icons.cross()`, `$Lottie.swipeUp()`,
`$Images.cat()`.

`dotdart` reads supported asset formats during `build_runner`, generates
optimized Flutter widget code, and leaves your app with only Flutter SDK
runtime code. Lottie and SVG compile to dependency-free `CustomPainter`
widgets. Raster images compile to `Image.asset` accessors with built-in
downsampling, instant thumbhash placeholders, and coordinated precaching —
optimizations that runtime packages cannot provide because they rely on
build-time metadata that only a codegen tool can know.

## Why dotdart?

- **SVG & Lottie:** Generates self-contained `CustomPainter` widgets — no
  `flutter_svg` or Lottie runtime dependency in your app.
- **Raster images:** Generates `Image.asset` accessors with build-time
  metadata, decode-time downsampling, and instant thumbhash placeholders —
  strictly more optimal than any runtime-only image package.
- **Zero runtime dependency:** Generated code imports only `dart:math`,
  `dart:convert`, and Flutter SDK. No `dotdart` import in generated files.
- **Lifecycle-aware animations:** Lottie widgets pause when the app is not
  resumed and respect reduced-motion settings.
- **Themeable colors:** Generated SVG and Lottie widgets expose distinct colors
  as named parameters so apps can theme assets without editing the source file.

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
  image:
    - assets/three_d/
    - assets/photos/hero.webp
```

Then run code generation.

```bash
dart run build_runner build
```

In this monorepo, use the workspace script instead:

```bash
melos gen:all
```

## Use the generated namespace

All generated widgets are grouped by their source folder into a namespace file.
Each folder produces one flat `<folder>.g.dart` file (e.g. `lib/gen/icons.g.dart`)
with an `abstract final class $FolderName` exposing one static method per asset.
Widget classes are library-private — consumers interact exclusively through the
namespace accessors.

### SVG icons example

Assets in `assets/icons/` are accessed via `$Icons` from `lib/gen/icons.g.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:my_app/gen/icons.g.dart';

class MyCloseButton extends StatelessWidget {
  const MyCloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return $Icons.cross(width: 24, color1: Color(0xFFFF0000));
  }
}
```

### Lottie animation example

Assets in `assets/lottie/` are accessed via `$Lottie` from `lib/gen/lottie.g.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:my_app/gen/lottie.g.dart';

class OnboardingHint extends StatelessWidget {
  const OnboardingHint({super.key});

  @override
  Widget build(BuildContext context) {
    return $Lottie.swipeUpOnboarding(
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
$Lottie.swipeUpOnboarding(width: 160, progress: 0.5);
```

Generated Lottie widgets respect platform reduced-motion settings by default.
Pass `respectDisableAnimations: false` when a specific animation should keep
playing even if the device is configured to disable animations.

```dart
$Lottie.swipeUpOnboarding(width: 160, respectDisableAnimations: false);
```

### Image example

Assets in `assets/three_d/` are accessed via `$ThreeD` from `lib/gen/three_d.g.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:my_app/gen/three_d.g.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return $ThreeD.emptyCitySaoPaulo(width: 200);
  }
}
```

Each generated image accessor embeds intrinsic dimensions, format, dominant
color, and a thumbhash placeholder at build time. The generated widget decodes
the image at `displaySize × devicePixelRatio` for minimal memory, sets
`gaplessPlayback: true`, and wraps in `RepaintBoundary`. All of these
optimizations are baked in — the caller just supplies `width` and `height`.

To warm the image cache at app start:

```dart
// In your bootstrap:
await $ThreeD.precache(context);
```

To evict a specific image from the cache (e.g. when navigating away from a
screen):

```dart
PaintingBinding.instance.imageCache.evict($ThreeD.emptyCitySaoPauloCacheKey);
```

Generated SVG widgets are `StatelessWidget` + `CustomPainter` — no runtime
XML parsing, no picture cache, no `flutter_svg` dependency. All geometry is
precompiled to `static final Path` fields. Two reusable `Paint` objects are
shared across all draw operations.

### Accessor naming

Each asset's accessor name is derived from the filename in lowerCamelCase:

| Source file                       | Accessor method               |
| --------------------------------- | ----------------------------- |
| `assets/icons/cross.svg`          | `$Icons.cross(...)`           |
| `assets/icons/arrow_left.svg`     | `$Icons.arrowLeft(...)`       |
| `assets/lottie/swipe_up.json`     | `$Lottie.swipeUp(...)`        |
| `assets/three_d/empty_city.webp`  | `$ThreeD.emptyCity(...)`      |

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
  image: # Raster image files (WebP, PNG, JPEG, GIF)
    - assets/three_d/ # folder: scans .webp/.png/.jpg/.jpeg/.gif files directly inside
    - assets/hero.webp # file: generates one widget
```

Each asset type gets its own key under `dotdart:`. All configured paths must be
relative to the package root. Absolute paths and paths containing `..` are
rejected so generated files stay inside the package.

## Asset Types

`dotdart` is designed around independent asset pipelines. Each supported format
has its own parser, generator, and configuration key:

- `lottie:` Lottie JSON animations → `CustomPainter` widgets.
- `svg:` SVG vector images → `CustomPainter` widgets.
- `image:` Raster images (WebP, PNG, JPEG, GIF) → optimized `Image.asset` accessors
  with build-time metadata, decode-time downsampling, and embedded thumbhash
  placeholders.

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

## Namespace Accessors

Generated widgets are grouped by their source folder into a single namespace
file per folder. For example, if a `svg:` entry lists `assets/icons/`, all
icons in that folder produce a combined `lib/gen/icons.g.dart` file.

The namespace class is `abstract final` with a private constructor and one
`static` method per asset. Each method returns `Widget` and constructs a
library-private widget class (prefixed with `_`). Consumers never reference
the widget class directly — they call `$Icons.cross(...)` and get back a
`Widget`. In tests, find generated widgets via
`find.byWidgetPredicate((w) => w.runtimeType.toString() == '_ClassName')`.

### Stale file cleanup

The post-process builder automatically deletes `.g.dart` files from previous
runs that are no longer in the current output set. You do not need to manually
remove old files after renaming or removing an asset.

### Generated Code Notes

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
