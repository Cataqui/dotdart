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
