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
- Generated widgets: `StatefulWidget` + `CustomPainter`, lifecycle-aware, `animated` prop, per-color props.
- Optimize generated animation hot paths with reusable paints, prebuilt static
  geometry and compound paths, specialized scalar evaluators, exact bezier
  result reuse, constant transform folding, and redundant transform removal.
- Keep supported translucent compound strokes visually unified without using
  `saveLayer`.
- PostProcessBuilder pattern (like `flutter_gen_runner`) for configurable output directory.
