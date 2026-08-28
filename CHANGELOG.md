## 0.10.2

- Fixed `translate`, `scale`, and `rotate` transforms being silently ignored on
  drawable SVG shapes and shapes inside clip paths. Transformed geometry now
  preserves nested transform order and rotation pivots in generated painters.
- Fixed generated SVG circles and ellipses using non-constant Flutter
  constructors in `const` fields or clip path expressions, and kept rounded
  rectangle geometry warning-free under strict Dart analysis.

## 0.10.1

- Fixed generated SVGs with rounded rectangles using a non-constant Flutter
  constructor in a `const` field or clip path expression, which prevented the
  generated library from analyzing or compiling.

## 0.10.0

- **BREAKING:** Generated SVG color parameters now use the drawable element's
  `id`, or its nearest ancestor group `id`, before falling back to `color1`,
  `color2`, and later names. For example, `id="outline"` produces
  `outlineColor`. Equal default colors under different IDs remain independently
  customizable. Regenerate with build_runner, then update analyzer-reported
  call sites to the new generated names; deprecated aliases are not emitted.
- SVG IDs must now be non-empty, valid standalone XML IDs, and unique across
  the document. Distinct IDs that sanitize to the same Dart name receive stable
  source-order suffixes, with the original SVG ID retained in generated
  documentation.
- Fixed SVGs with a UTF-8 byte order mark or a standard leading XML declaration
  being rejected as though their root element were not `<svg>`. Malformed and
  unterminated declarations now fail generation explicitly.
- Fixed nested and sibling SVG groups reusing earlier geometry fields instead
  of drawing their own paths and shapes. Generated painters now preserve the
  source geometry, draw order, transforms, clipping, and opacity across nested
  groups.
- Stopped generating color controls from group-only presentation attributes
  that no drawable uses. Anonymous color numbering can therefore change after
  regeneration.

## 0.9.0

- **BREAKING:** Generated Lotties now play once by default and keep their final
  frame visible. Pass `playback: LottiePlayback.loop` to retain the previous
  continuous-loop behavior. Lottie namespace libraries re-export the shared
  enum from the generated `dotdart.g.dart` file.
- Fixed completed one-time playback and `progress: 1` rendering a blank frame
  by holding the final visible position before the Lottie out-point.
- Added `delay` and `duration` to generated Lottie accessors. `delay` waits
  once before automatic playback starts, while `duration` can make the full
  animation play faster or slower without changing its internal timing.
- Added static and animated Lottie trim paths for paths, rectangles, and
  ellipses, including start, end, offset, wraparound, and parallel or
  sequential handling of multiple shapes in the default drawing direction.
- Generated trim-path painters use Flutter's native path metrics and remain
  self-contained without a Lottie runtime dependency.
- Reduced generated Lottie frame work by reusing laid-out text painters,
  compacting adjacent constant keyframes, and caching sequential trim-path
  lengths outside the paint loop.
- Moved thumbhash decoding entirely to generation time. Generated image and GIF
  widgets now contain precomputed placeholder colors and reuse one frame
  builder, avoiding base64 and inverse-DCT work during their first render.

## 0.8.0

- **BREAKING:** Replaced namespace-wide image and GIF precaching with generated
  per-asset cache classes. Use
  `$ImagesCache.precacheProfile(context, width: 160)` before rendering
  `$Images.profile(width: 160)`, then call
  `$ImagesCache.removeProfile(context, width: 160)` when that decoded image is
  no longer needed. Omitting both dimensions uses the generated widget's
  default display size, and removal preserves an image that is still live.

## 0.7.0

- Updated package metadata, documentation, contribution, support links, and
  example application identifiers for the transfer to the Ventairy
  organization.
- Added Lottie precomposition layers, static editable text layers, and static
  additive masks.
- Added parented Lottie layer transforms and null controller layers, preserving
  orbit and other hierarchical motion from the source animation.
- Generated Lottie accessors now expose nullable `String` fields for text
  layers through a generated `overrides` object. Passing a value replaces the
  text stored in the Lottie document.
- Repeated named Lottie layers now receive numbered override fields instead of
  sharing one override, so each layer can be customized independently.
- Corrected Lottie shape-group stacking so background shapes no longer cover
  map and illustration groups above them.
- Added a `clip` parameter to generated Lottie accessors. It defaults to `true`
  to clip painting to the Lottie canvas; pass `false` to allow overflow.
- Reduced generated Lottie frame work by omitting non-rendering controller
  layers, sharing safe timeline guards, and precomputing canvas geometry and
  text paint offsets outside the paint loop.
- Fixed automatic Lottie playback resuming after app lifecycle or
  reduced-motion pauses by keeping the painter attached to its stopped
  controller.
- Hardened Lottie generation by rejecting duplicate or cyclic precompositions,
  invalid non-composition references, unsupported time remapping and mask
  transfer values, and by safely escaping source-breaking layer and text
  content.
- Combined multiple fully opaque additive masks before clipping instead of
  intersecting them one at a time.
- **BREAKING:** Lottie text and color values now live under each accessor's
  generated `overrides` object. Named text fields end in `Text`, such as
  `jobTitleText` and `jobTitleTextColor`; names already ending in `Text` are not
  changed twice. Other named fields include values such as
  `miamiArtworkColor1`. Unnamed layers retain predictable `text1`, `color1`,
  and later fallbacks. Move old direct arguments into the generated overrides
  class using the field shown by Dart analysis or generated API completion.

## 0.6.2

- Stopped committing the package lockfile so dependency-range compatibility is
  validated while keeping the example application reproducible.
- Made CI run the pinned Dart and Flutter release commands directly.

## 0.6.1

- Improved consumer documentation and package guidance for supported images and
  GIFs.
- Added complete Flutter platform runners to the example and an animated Lottie
  fixture with deterministic regression coverage.
- Updated generated Lottie animation startup for strict analysis with
  `very_good_analysis` 10.x.
- Added the release checklist and tag-triggered trusted-publishing workflow for
  future releases.

## 0.6.0

- Extracted dotdart into its own public repository with standalone FVM,
  Makefile, CI, package documentation, and a runnable three-pipeline example.
- **Added `<defs>`, `<clipPath>`, and `clip-path="url(#id)"` support for SVG.**
  SVGs with `<defs>` blocks containing `<clipPath>` definitions now parse and
  generate correctly. The clip path geometry is emitted as a `static final Path`
  field and applied via `canvas.clipPath()` in the generated `CustomPainter`.
  `clip-rule` on `<clipPath>` elements is respected (evenodd / nonzero).
  Non-existent `clip-path` references produce a build warning and are treated
  as no-ops per the SVG spec. `<use>` and `<symbol>` remain unsupported.
- Omit unused reusable paint fields from generated Lottie painters so
  fill-only and stroke-only animations remain warning-free under strict
  analysis.
- Raise the minimum `glob` version to `2.1.3` so minimum-dependency test
  resolutions use a Dart 3-compatible `package:file` implementation.
- Use the Flutter SDK batch launchers in generated-consumer integration tests
  so the full suite runs on Windows as well as macOS and Linux.

## 0.5.0

- **Added `maintainAspectRatio` (default `true`) to generated SVG and Lottie widgets.**
  When a caller passes both `width` and `height`, the widget now keeps the native aspect
  ratio by default, using the larger requested value as the reference dimension and
  recomputing the other. Set `maintainAspectRatio: false` to apply both dimensions
  directly (the previous behavior, which could distort). Image widgets are unaffected —
  they continue to use the `fit` parameter.

## 0.4.1

- Fixed image and GIF aspect-ratio calculations for width-only and height-only sizing.
- Fixed cold thumbhash placeholder decoding by preserving the complete AC coefficient payload.
- Replaced duplicate thumbhash runtime emitters with one canonical generated source.
- Changed namespace precaching to decode images sequentially for safer memory use on low-end devices.
- Restricted stale cleanup to files with dotdart's exact ownership header and added path, traversal, and symlink guards.
- Added strict configuration, identifier, reserved-word, duplicate-input, and generated-symbol validation.
- Added path-aware malformed Lottie errors and source-path context for asset parser failures.
- Centralized generated asset and parameter contracts across widget constructors and namespace accessors.
- Removed blanket generated-code lint suppression and added a real build_runner consumer fixture that analyzes and renders
  generated SVG, Lottie, static images, portrait images, landscape images, animated GIFs, and thumbhash output.

## 0.4.0

- **Added image pipeline:** `image:` config key in `pubspec.yaml` for images and
  GIFs (WebP, PNG, JPEG, GIF). Generates optimized `$Namespace.assetName()`
  accessors returning `Image.asset` with decode-time downsampling, embedded
  thumbhash placeholders, dominant color, and `RepaintBoundary` wrapping.
- **Added build-time metadata embedding:** intrinsic dimensions, format,
  animated flag, dominant color, and thumbhash are probed at build time and
  emitted as `static const` fields in the generated widget — zero runtime
  dimension probing.
- **Added thumbhash instant placeholders:** every generated image and GIF widget
  renders a blurry thumbhash placeholder in frame 1 (before the real image
  decodes) via a shared `_dotdartImageFrameBuilder`. No flash of empty.
- **Added `_dotdartImageFrameBuilder`** shared function + `_DotdartThumbhashDecoder`
  - `_DotdartThumbhashPainter` emitted once per namespace file.
- **Added `precache` method and `cacheKey` constants** to image and GIF namespaces
  for per-screen image memory management and coordinated cache warming.
- **Added `image` build-time dependency** (`^4.8.0`) for pixel decoding,
  dominant color extraction, and thumbhash generation. Never imported by
  generated code.
- Added an internal image/GIF asset type to the namespace enum.
- **Documentation:** README updated with image support section, quick-start
  example, and reframed purpose. AGENTS.md architecture tree updated.
- **Tests:** 22 new tests across models, parsers, thumbhash encoder,
  generator, and widget levels.

## 0.3.0

- **BREAKING:** Generated output is now grouped by source folder into namespace
  classes. Each folder produces one flat `<folder>.g.dart` file (e.g.
  `lib/gen/icons.g.dart`) containing an `abstract final class $NamespaceName`
  with one static method per asset.
  - Before: `lib/gen/cross.g.dart` → `const Cross(width: 24)`.
  - After: `lib/gen/icons.g.dart` → `$Icons.cross(width: 24)`.
- **BREAKING:** Widget classes are now library-private (prefixed with `_`).
  Consumers must use the `$Namespace.assetName(...)` accessor methods, which
  return `Widget`. Direct construction or `find.byType` with the generated class
  is no longer possible from outside the generated file.
- **BREAKING:** The old flat per-asset `.g.dart` files are no longer generated.
  Existing flat files are deleted on the first build after upgrading.
- Added: shared mixins in generated files — `_DotdartSvgSizing` for SVG widgets
  and `_DotdartLottieAnimationState<T>` for Lottie widgets — eliminating
  duplicated `build()`, `_defaultSizeFor()`, `_applyOpacity()`, and lifecycle
  methods across all generated classes in a file.
- Added: `DotdartNamespaceCollisionException` thrown when two assets in the
  same folder produce identical widget class names.
- Added: `NamespaceAssembler` that produces the combined namespace file
  with shared header, imports, mixins, and all widget classes.
- Added: `AccessorParam` model and `Naming` helper for deriving accessor/method
  names from file paths (camelCase for methods, PascalCase for classes).
- Added: stale file cleanup — the post-process builder deletes `.g.dart` files
  from previous runs that are no longer in the current output set.
- Fixed: SVG generator no longer emits `widget.width`/`widget.height` inside
  `StatelessWidget.build()` — `StatelessWidget` has no `widget` property.
  This was masked by `.g.dart` analysis exclusion.
- Migration: update import paths from `package:<app>/gen/<asset>.g.dart` to
  `package:<app>/gen/<folder>.g.dart` and replace direct widget construction
  with `$Namespace.assetName(...)`. In tests, find widgets via
  `find.byWidgetPredicate((w) => w.runtimeType.toString() == '_ClassName')`
  instead of `find.byType(ClassName)`.

## 0.2.0

- Add **SVG pipeline**: `<path>`, `<rect>`, `<circle>`, `<ellipse>`, `<line>`,
  `<polyline>`, `<polygon>` elements with groups and transforms.
- Presentation attributes: `fill`, `fill-opacity`, `fill-rule`, `stroke`,
  `stroke-width`, `stroke-linecap`, `stroke-linejoin`, `opacity`.
- Color theming: distinct fill/stroke colors become `color1`, `color2`, …
  props (deduplicated), mirroring the Lottie color API.
- Precompiled geometry: all SVG paths are converted to `static final Path`
  at build time — no runtime XML parsing, no picture cache allocation.
- Generated widgets are `StatelessWidget` (no animation machinery).
- Sizing and layout mirror the Lottie widget pattern: aspect from viewBox,
  `LayoutBuilder`/`OverflowBox` for fluid or explicit sizing.
- `viewBox` support, including `min-x`/`min-y` canvas offset.
- `transform` attribute: `translate()`, `scale()`, `rotate()`.
- Style inheritance: attributes on `<g>` propagate to children.
- Built-in minimal XML parser (no external `xml` dependency needed).

## 0.1.0

- Initial release.
- Introduce the asset-to-Dart compiler architecture for turning supported visual
  asset formats into pure Dart widget code at build time.
- Ship the first asset pipeline with **Lottie support**: shape layers,
  rect/ellipse/path shapes, fills, strokes, groups, transforms, animated
  keyframes with bezier easing, hold keyframes, spatial tangents.
- Design the package for multiple asset types — each type gets its own parser
  and generator.
- Configuration via `dotdart:` section in `pubspec.yaml` with type-keyed entries (`lottie:`, future `svg:`).
- Generated widgets: `StatefulWidget` + `CustomPainter`, lifecycle-aware, nullable `progress` prop for
  manual timeline control, per-color props.
- Optimize generated animation hot paths with reusable paints, prebuilt static
  geometry and compound paths, specialized scalar evaluators, exact bezier
  result reuse, constant transform folding, and redundant transform removal.
- Keep supported translucent compound strokes visually unified without using
  `saveLayer`.
- PostProcessBuilder pattern (like `flutter_gen_runner`) for configurable output directory.
