## 0.1.0

- Initial release.
- Convert visual assets (Lottie, SVG, and more) to pure-Dart widget code at build time.
- **Lottie support**: shape layers, rect/ellipse/path shapes, fills, strokes, groups, transforms, animated keyframes with bezier easing, hold keyframes, spatial tangents.
- Architecture designed for multiple asset types — each type gets its own parser and generator.
- Configuration via `dotdart:` section in `pubspec.yaml` with type-keyed entries (`lottie:`, future `svg:`).
- Generated widgets: `StatefulWidget` + `CustomPainter`, lifecycle-aware, `animated` prop, per-color props.
- PostProcessBuilder pattern (like `flutter_gen_runner`) for configurable output directory.
