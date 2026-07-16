# dotdart

Type-safe Flutter asset access, generated as optimized Dart code.

`dotdart` turns supported visual assets into strongly named Flutter widgets:
`$Icons.cross()`, `$Lottie.swipeUp()`, `$Images.cat()`. Instead of passing
string paths into runtime renderers, dotdart reads your SVG, Lottie, and raster
image files during `build_runner` and writes the Dart widgets your app uses to
display them.

The short version:

- You configure assets once in `pubspec.yaml`.
- dotdart generates namespace files such as `lib/gen/icons.g.dart`.
- Your app imports those files and calls typed accessors.
- Renamed, missing, duplicated, invalid, or unsupported assets fail during
  generation instead of turning into quiet runtime surprises.

## What dotdart Means

The package name is the promise: the asset becomes Dart.

SVG files become Dart `Path` and `CustomPainter` code. Lottie shape animations
become lifecycle-aware `CustomPainter` widgets. Raster images become optimized
`Image.asset` widgets with build-time metadata such as intrinsic size, aspect
ratio, dominant color, and thumbhash placeholder data baked in.

Because the generated widget is ordinary Dart, it is easier to type-check,
theme, test, inspect, and optimize than a runtime renderer that keeps most
behavior hidden behind asset parsing.

## Why Use It?

Most Flutter apps start with asset strings:

```dart
Image.asset('assets/images/cat.png');
```

That works, but it has sharp edges:

- the string can be mistyped;
- renaming the file does not automatically update call sites;
- the caller has to remember sizing and cache behavior;
- SVG and Lottie usually need runtime parser or renderer packages;
- changing asset names can become a search-and-replace chore.

dotdart replaces that with generated Dart access:

```dart
$Images.cat(width: 120);
$Icons.close(color1: Theme.of(context).colorScheme.primary);
$Lottie.swipeUp(progress: 0.5);
```

That gives you:

- **Type-safe asset names:** generated methods fail at analysis time when an
  asset is renamed or removed.
- **Better default performance:** raster widgets decode near the displayed size,
  use thumbhash placeholders, and support sequential namespace precaching.
- **Manipulable generated widgets:** supported SVG and Lottie colors, sizes,
  animation progress, and animation behavior become typed Dart parameters.
- **No runtime renderer dependency:** generated SVG and Lottie widgets do not
  import `flutter_svg`, `lottie`, or `dotdart` at runtime.
- **Build-time validation:** invalid config, missing inputs, duplicate assets,
  name collisions, malformed Lottie JSON, and unsupported content fail early
  with actionable paths.

## What Gets Generated?

| Input asset                    | Generated access        | Runtime widget                            |
| ------------------------------ | ----------------------- | ----------------------------------------- |
| `assets/icons/cross.svg`       | `$Icons.cross(...)`     | Dependency-free `CustomPainter` widget    |
| `assets/lotties/swipe_up.json` | `$Lotties.swipeUp(...)` | Lifecycle-aware `CustomPainter` animation |
| `assets/images/cat.webp`       | `$Images.cat(...)`      | Optimized `Image.asset` widget            |

Generated files are grouped by the asset's parent folder. For example:

| Source file                      | Generated file           | Namespace call           |
| -------------------------------- | ------------------------ | ------------------------ |
| `assets/icons/cross.svg`         | `lib/gen/icons.g.dart`   | `$Icons.cross(...)`      |
| `assets/icons/arrow_left.svg`    | `lib/gen/icons.g.dart`   | `$Icons.arrowLeft(...)`  |
| `assets/icons/spinner.json`      | `lib/gen/icons.g.dart`   | `$Icons.spinner(...)`    |
| `assets/lotties/swipe_up.json`   | `lib/gen/lotties.g.dart` | `$Lotties.swipeUp(...)`  |
| `assets/three_d/empty_city.webp` | `lib/gen/three_d.g.dart` | `$ThreeD.emptyCity(...)` |

The generated widget classes are private. Consumers should only use the public
namespace methods.

Different asset types can share the same folder. If `assets/icons/` contains
`cross.svg`, `spinner.json`, and `badge.png`, dotdart generates one
`lib/gen/icons.g.dart` file with `$Icons.cross(...)`, `$Icons.spinner(...)`,
and `$Icons.badge(...)`. This is intentional: the namespace belongs to the
folder, not to the asset type.

## Install

Add dotdart and build_runner as development dependencies:

```bash
flutter pub add --dev dotdart build_runner
```

If your project already uses `build_runner`, only add `dotdart`:

```bash
flutter pub add --dev dotdart
```

## Configure

Add a `dotdart:` section to the app or package `pubspec.yaml`.

```yaml
dotdart:
  output: lib/gen/
  svg:
    - assets/icons/
    - assets/logos/brand.svg
  lottie:
    - assets/lotties/
    - assets/onboarding/swipe_up.json
  image:
    - assets/images/
    - assets/photos/hero.webp
```

### Configuration Rules

- `output` is optional and defaults to `lib/gen/`.
- `svg`, `lottie`, and `image` are lists of package-relative file or directory
  paths.
- Directory inputs scan files directly inside that directory. They are not
  recursive.
- Paths must stay inside the package. Absolute paths and `..` are rejected.
- Duplicate inputs are rejected.
- Unknown `dotdart:` keys are rejected.
- A configured directory must produce at least one matching asset.
- An explicitly configured file must exist and match its declared asset type.

### Raster Images Must Also Be Flutter Assets

SVG and Lottie inputs are compiled into Dart, so they are build inputs.

Raster images are different: generated raster widgets still call `Image.asset`
for the original image file. That means raster folders must also be listed under
Flutter `assets:`.

```yaml
dotdart:
  output: lib/gen/
  image:
    - assets/images/

flutter:
  assets:
    - assets/images/
```

If a generated image widget cannot find the asset at runtime, check the Flutter
`assets:` section first.

## Generate

Run build_runner:

```bash
dart run build_runner build --delete-conflicting-outputs
```

For continuous development, you can watch instead:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

After generation, import the generated namespace files from `lib/gen/`.

```dart
import 'package:my_app/gen/icons.g.dart';
import 'package:my_app/gen/lotties.g.dart';
import 'package:my_app/gen/images.g.dart';
```

Generated `.g.dart` files are source output. Commit them if your project commits
generated code, and never edit them by hand.

## Use SVG Assets

Given this config:

```yaml
dotdart:
  output: lib/gen/
  svg:
    - assets/icons/
```

and this file:

```text
assets/icons/close.svg
```

dotdart generates:

```text
lib/gen/icons.g.dart
```

Use it like this:

```dart
import 'package:flutter/material.dart';
import 'package:my_app/gen/icons.g.dart';

class CloseButtonIcon extends StatelessWidget {
  const CloseButtonIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return $Icons.close(
      width: 24,
      height: 24,
      color1: Theme.of(context).colorScheme.primary,
    );
  }
}
```

Generated SVG widgets are `StatelessWidget` plus `CustomPainter`. They do not
parse XML at runtime and do not import `flutter_svg`. Supported colors are
exposed as `color1`, `color2`, and so on, depending on the source asset.

By default, passing both `width` and `height` will **not** distort the asset — the
larger value wins and the other is derived from the native aspect ratio:

```dart
$Icons.close(width: 120, height: 200); // renders 200×200 for a square asset
```

Pass `maintainAspectRatio: false` to apply both dimensions literally (this may distort
the asset if the dimensions differ from the native aspect ratio).

## Use Lottie Assets

Given this config:

```yaml
dotdart:
  output: lib/gen/
  lottie:
    - assets/lotties/
```

and this file:

```text
assets/lotties/swipe_up.json
```

dotdart generates:

```text
lib/gen/lotties.g.dart
```

Use it like this:

```dart
import 'package:flutter/material.dart';
import 'package:my_app/gen/lotties.g.dart';

class SwipeHint extends StatelessWidget {
  const SwipeHint({super.key});

  @override
  Widget build(BuildContext context) {
    return $Lotties.swipeUp(
      width: 160,
      color1: Theme.of(context).colorScheme.primary,
    );
  }
}
```

Generated Lottie widgets play automatically by default. They pause when the app
is not resumed and respect platform reduced-motion settings.

As with SVG widgets, passing both `width` and `height` preserves the native aspect
ratio by default using the larger requested value as the reference. Pass
`maintainAspectRatio: false` to apply both dimensions directly.

To drive the animation yourself, pass `progress`. Progress uses the full
normalized timeline: `0` is the first frame and `1` is the last frame.

```dart
$Lotties.swipeUp(width: 160, progress: 0.5);
```

When `progress` is supplied, automatic playback stops.

To keep a specific animation playing even when the platform asks for reduced
motion, pass:

```dart
$Lotties.swipeUp(
  width: 160,
  respectDisableAnimations: false,
);
```

## Use Raster Images

Given this config:

```yaml
dotdart:
  output: lib/gen/
  image:
    - assets/images/

flutter:
  assets:
    - assets/images/
```

and this file:

```text
assets/images/cat.webp
```

dotdart generates:

```text
lib/gen/images.g.dart
```

Use it like this:

```dart
import 'package:flutter/material.dart';
import 'package:my_app/gen/images.g.dart';

class CatAvatar extends StatelessWidget {
  const CatAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return $Images.cat(width: 96);
  }
}
```

Each generated image accessor embeds metadata discovered at build time:

- intrinsic width and height;
- aspect ratio;
- image format;
- dominant color;
- thumbhash placeholder.

At runtime the widget:

- preserves the intrinsic aspect ratio when only `width` or only `height` is
  provided;
- requests decode-cache sizing near `displaySize x devicePixelRatio`;
- shows a thumbhash placeholder before the real image is decoded;
- uses `gaplessPlayback: true`;
- wraps the image in a `RepaintBoundary`.

The caller usually only needs to pass `width`, `height`, `fit`, or alignment
parameters.

### Precache Raster Namespaces

Raster namespaces expose a `precache(BuildContext)` helper:

```dart
await $Images.precache(context);
```

Precache only the namespace needed by the next screen. dotdart precaches images
sequentially to avoid decoding an entire namespace at once on low-memory
devices.

## Accessor Naming

dotdart derives names from the source filename:

| File name         | Accessor                   |
| ----------------- | -------------------------- |
| `close.svg`       | `close`                    |
| `arrow_left.svg`  | `arrowLeft`                |
| `empty-city.webp` | `emptyCity`                |
| `123_bad.svg`     | rejected before generation |
| `class.svg`       | rejected before generation |

Generated names must be valid Dart identifiers. dotdart rejects:

- empty names;
- names starting with digits;
- Dart reserved words;
- duplicate normalized names;
- duplicate accessors across asset types in the same folder, such as
  `assets/icons/box.svg` and `assets/icons/box.json`;
- collisions with namespace helpers such as `precache`;
- collisions between private generated widget classes.

## Supported Asset Types

dotdart intentionally supports a focused subset of each visual
format. The goal is not to render every possible SVG or Lottie file. The goal
is to compile common production assets into Dart code that is fast to show,
easy to theme, and safe to change.

| Config key | Input                                    | Output                            |
| ---------- | ---------------------------------------- | --------------------------------- |
| `svg`      | `.svg`                                   | `CustomPainter` widgets           |
| `lottie`   | `.json` Lottie files                     | `CustomPainter` animation widgets |
| `image`    | `.webp`, `.png`, `.jpg`, `.jpeg`, `.gif` | Optimized `Image.asset` widgets   |

## Supported SVG Features

- Elements: `<path>`, `<rect>`, `<circle>`, `<ellipse>`, `<line>`,
  `<polyline>`, `<polygon>`, and `<g>`.
- Path commands: `M`/`m`, `L`/`l`, `H`/`h`, `V`/`v`, `C`/`c`, `S`/`s`,
  `Q`/`q`, `T`/`t`, and `Z`/`z`.
- Presentation attributes: `fill`, `fill-opacity`, `fill-rule`, `stroke`,
  `stroke-width`, `stroke-linecap`, `stroke-linejoin`, `stroke-opacity`,
  `opacity`, and `transform`.
- Colors: `#rgb`, `#rrggbb`, `#rrggbbaa`, `rgb()`, `rgba()`, named colors,
  and `none`.
- `viewBox` with min-x/min-y offset.
- Style inheritance from `<g>` to children.

Unsupported SVG features fail fast when they would change rendering
semantics. Unknown cosmetic attributes that do not affect generated output may
be skipped with warnings.

## Not Yet Supported For SVG

- Animated SVG with SMIL or CSS animations.
- Gradients.
- `<use>`, `<symbol>`, and `<defs>` references.
- `<text>`, `<tspan>`, and `<image>`.
- Filters, masks, `<clipPath>`, and `<pattern>`.
- CSS `<style>` blocks.
- `matrix()`, `skewX()`, and `skewY()` transforms.
- Arc path commands, `A` and `a`.
- `stroke-dasharray` and `stroke-dashoffset`.
- `currentColor` as a separate theme slot.

## Supported Lottie Features

- Shape layers.
- Shape groups.
- Rectangles, ellipses, and bezier paths.
- Solid fills and strokes.
- Static group transforms.
- Static and keyframed layer opacity, rotation, position, and scale.
- Hold keyframes.
- Bezier easing for scalar keyframes.

Unsupported Lottie shape or layer types are skipped with build warnings when
safe. Malformed Lottie files fail generation with path-aware parser errors.

## Not Yet Supported For Lottie

- Gradients.
- Masks and mattes.
- Trim paths, repeaters, merge paths, offset paths, pucker/bloat, and zigzag.
- Text, image, audio, video, and 3D layers.
- Expressions.
- Nested groups deeper than the currently supported shape-group structure.

## Generated Code Notes

Generated files:

- import Flutter SDK libraries and `dart:math`;
- do not import `dotdart`;
- do not import `flutter_svg`;
- do not import a Lottie runtime package;
- contain a dotdart ownership header;
- should not be edited by hand.

Generated SVG and Lottie painters avoid runtime parsing and avoid walking a
format model on every frame. Static paths are constructed once, paint objects
are reused, and animation ticks repaint the painter without rebuilding the
widget tree.

These optimizations reduce runtime work. They do not make GPU drawing free:
large paths, many translucent overlaps, and complex future features can still
be expensive.

## Stale Output Cleanup

When assets are removed or renamed, run generation again:

```bash
dart run build_runner build --delete-conflicting-outputs
```

dotdart removes stale files only when they carry dotdart's exact generated
ownership header. It does not delete unrelated `.g.dart` files from other
generators sharing the same output directory.

## Troubleshooting

### The generated file does not exist

Check that:

- `dotdart:` exists in the same package's `pubspec.yaml`;
- the asset path is package-relative;
- the configured directory contains matching files directly inside it;
- you ran `dart run build_runner build --delete-conflicting-outputs`.

### The generated image widget renders nothing

For raster images, also declare the image folder under Flutter `assets:`.
dotdart can generate the accessor, but Flutter still needs the original image
in the asset bundle.

### The accessor name is not what you expected

dotdart converts filenames to lowerCamelCase:

```text
arrow_left.svg -> arrowLeft
empty-city.webp -> emptyCity
```

If two files normalize to the same accessor name, generation fails so you can
rename one of them.

### A Lottie or SVG file fails generation

dotdart does not try to support every feature of the source formats. If an
asset uses unsupported features, simplify or export the asset using the
supported subset listed above.

### A directory input matches no files

Directory inputs are not recursive. Configure the exact directory that directly
contains the assets, or add explicit file paths.

## For Maintainers and Agents

This section is intentionally explicit so automated agents can modify dotdart
without guessing the package contract.

- Keep the README consumer-first. Explain what users get before explaining
  internals.
- Preserve the core meaning: type-safe Flutter asset access generated as
  optimized Dart code.
- Do not document generated private widget classes as public API.
- Do not expose raw image-cache identifiers. Prefer behavior that is hard to
  misuse, such as namespace-level `precache(BuildContext)`.
- If raster generation changes, document whether Flutter `assets:` is still
  required.
- If supported SVG or Lottie features change, update the supported and
  not-yet-supported lists in this README.
- If config validation changes, update the configuration rules and
  troubleshooting sections.
- After generator changes, verify generated consumers with build_runner,
  analyzer, and widget tests.

In this repository, use FVM for Dart and Flutter commands. A good local package
check is:

```bash
fvm dart format --output=none --set-exit-if-changed lib test
fvm dart analyze
fvm flutter test
```
