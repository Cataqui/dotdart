/// Stroke line cap style.
enum SvgStrokeLineCap {
  butt,
  round,
  square;
}

/// Stroke line join style.
enum SvgStrokeLineJoin {
  miter,
  round,
  bevel;
}

/// Fill rule for paths.
enum SvgFillRule {
  nonzero,
  evenodd;
}

/// Resolved SVG presentation attributes for a single element.
class SvgStyle {
  const SvgStyle({
    this.fillColor,
    this.fillOpacity = 1,
    this.fillRule = SvgFillRule.nonzero,
    this.strokeColor,
    this.strokeOpacity = 1,
    this.strokeWidth = 1,
    this.strokeLineCap = SvgStrokeLineCap.butt,
    this.strokeLineJoin = SvgStrokeLineJoin.miter,
    this.opacity = 1,
  });

  final (double, double, double, double)? fillColor;
  final double fillOpacity;
  final SvgFillRule fillRule;
  final (double, double, double, double)? strokeColor;
  final double strokeOpacity;
  final double strokeWidth;
  final SvgStrokeLineCap strokeLineCap;
  final SvgStrokeLineJoin strokeLineJoin;
  final double opacity;
}
