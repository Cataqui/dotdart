import 'svg_element.dart';

/// Parsed SVG viewBox.
class SvgViewBox {
  const SvgViewBox({required this.minX, required this.minY, required this.width, required this.height});

  final double minX;
  final double minY;
  final double width;
  final double height;
}

/// A parsed SVG document ready for code generation.
class SvgDocument {
  const SvgDocument({required this.viewBox, required this.children, this.width, this.height});

  /// The `viewBox` attribute (`minX minY width height`).
  final SvgViewBox viewBox;

  /// The `width` attribute, if present (in user units).
  final double? width;

  /// The `height` attribute, if present (in user units).
  final double? height;

  /// Root-level child elements (groups, paths, etc.).
  final List<SvgElement> children;

  /// Computed width for the widget's native aspect: uses [width] when set,
  /// falls back to [viewBox] dimensions.
  double get nativeWidth => width ?? viewBox.width;

  /// Computed height for the widget's native aspect: uses [height] when set,
  /// falls back to [viewBox] dimensions.
  double get nativeHeight => height ?? viewBox.height;
}
