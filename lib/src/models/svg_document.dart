import 'svg_element.dart';
import 'svg_style.dart';

/// Parsed SVG viewBox.
class SvgViewBox {
  const SvgViewBox({required this.minX, required this.minY, required this.width, required this.height});

  final double minX;
  final double minY;
  final double width;
  final double height;
}

/// A parsed `<clipPath>` definition, keyed by its `id` in [SvgDocument.clipPaths].
///
/// The [children] are the shapes that define the clip region. Their fill and
/// stroke colors are irrelevant — only their geometry matters for clipping.
class SvgClipPath {
  const SvgClipPath({required this.id, required this.children, this.clipRule = SvgFillRule.nonzero});

  /// The `id` attribute used by `clip-path="url(#id)"` references.
  final String id;

  /// Shapes defining the clip region (paths, rects, circles, etc.).
  final List<SvgElement> children;

  /// Fill rule ([SvgFillRule.evenodd] or [SvgFillRule.nonzero]) for the clip
  /// region, parsed from the `clip-rule` attribute on `<clipPath>`.
  final SvgFillRule clipRule;
}

/// A parsed SVG document ready for code generation.
class SvgDocument {
  const SvgDocument({
    required this.viewBox,
    required this.children,
    this.width,
    this.height,
    this.clipPaths = const {},
  });

  /// The `viewBox` attribute (`minX minY width height`).
  final SvgViewBox viewBox;

  /// The `width` attribute, if present (in user units).
  final double? width;

  /// The `height` attribute, if present (in user units).
  final double? height;

  /// Root-level child elements (groups, paths, etc.).
  final List<SvgElement> children;

  /// Registered `<clipPath>` definitions, keyed by `id`.
  ///
  /// Looked up by [SvgStyle.clipPathId] during code generation to resolve
  /// `clip-path="url(#id)"` presentation attributes.
  final Map<String, SvgClipPath> clipPaths;

  /// Computed width for the widget's native aspect: uses [width] when set,
  /// falls back to [viewBox] dimensions.
  double get nativeWidth => width ?? viewBox.width;

  /// Computed height for the widget's native aspect: uses [height] when set,
  /// falls back to [viewBox] dimensions.
  double get nativeHeight => height ?? viewBox.height;
}
