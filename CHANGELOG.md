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
