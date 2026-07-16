import 'svg_style.dart';

/// A visual element in an SVG document tree.
///
/// Every element carries its fully resolved [style] — inheritance from parent
/// `<g>` elements is already folded in by the parser.
sealed class SvgElement {
  const SvgElement({required this.style});

  /// Resolved presentation attributes for this element.
  final SvgStyle style;
}

/// A single `<path>` element.
class SvgPath extends SvgElement {
  const SvgPath({required super.style, required this.commands});

  /// Absolute path commands for this path's `d` attribute.
  final List<SvgPathCommand> commands;
}

/// A `<rect>` element.
class SvgRect extends SvgElement {
  const SvgRect({
    required super.style,
    required this.width,
    required this.height,
    this.x = 0,
    this.y = 0,
    this.rx = 0,
    this.ry = 0,
  });

  final double x;
  final double y;
  final double width;
  final double height;

  /// Corner radii. `0` means no rounding.
  final double rx;
  final double ry;
}

/// A `<circle>` element.
class SvgCircle extends SvgElement {
  const SvgCircle({required super.style, required this.r, this.cx = 0, this.cy = 0});

  final double cx;
  final double cy;
  final double r;
}

/// An `<ellipse>` element.
class SvgEllipse extends SvgElement {
  const SvgEllipse({required super.style, required this.rx, required this.ry, this.cx = 0, this.cy = 0});

  final double cx;
  final double cy;
  final double rx;
  final double ry;
}

/// A `<line>` element.
class SvgLine extends SvgElement {
  const SvgLine({required super.style, this.x1 = 0, this.y1 = 0, this.x2 = 0, this.y2 = 0});

  final double x1;
  final double y1;
  final double x2;
  final double y2;
}

/// A `<polyline>` element.
class SvgPolyline extends SvgElement {
  const SvgPolyline({required super.style, required this.points});

  /// Absolute point coordinates `(x, y)`.
  final List<(double, double)> points;
}

/// A `<polygon>` element.
class SvgPolygon extends SvgElement {
  const SvgPolygon({required super.style, required this.points});

  /// Absolute point coordinates `(x, y)`, automatically closed.
  final List<(double, double)> points;
}

/// A `<g>` group element.
class SvgGroup extends SvgElement {
  const SvgGroup({required super.style, required this.children, this.transform});

  /// Ordered list of transform operations, or `null` when identity.
  final List<SvgTransformOp>? transform;

  /// Child elements rendered in order (bottom to top).
  final List<SvgElement> children;
}

/// A single absolute path command in an SVG `d` attribute.
///
/// All relative commands, smooth variants, and arcs are resolved to absolute
/// cubics / quads / lines at parse time, so the generator only needs to emit
/// basic Flutter `Path` method calls.
sealed class SvgPathCommand {
  const SvgPathCommand();
}

/// Absolute moveto (`M`).
class SvgMoveTo extends SvgPathCommand {
  const SvgMoveTo({required this.x, required this.y});
  final double x;
  final double y;
}

/// Absolute lineto (`L`).
class SvgLineTo extends SvgPathCommand {
  const SvgLineTo({required this.x, required this.y});
  final double x;
  final double y;
}

/// Absolute cubic bezier (`C`).
class SvgCubicTo extends SvgPathCommand {
  const SvgCubicTo({
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
    required this.x,
    required this.y,
  });

  final double x1;
  final double y1;
  final double x2;
  final double y2;
  final double x;
  final double y;
}

/// Absolute quadratic bezier (`Q`).
class SvgQuadTo extends SvgPathCommand {
  const SvgQuadTo({required this.x1, required this.y1, required this.x, required this.y});
  final double x1;
  final double y1;
  final double x;
  final double y;
}

/// Close path (`Z` or `z`).
class SvgClosePath extends SvgPathCommand {
  const SvgClosePath();
}

/// A single SVG transform operation.
///
/// SVG concatenates transforms left-to-right, which applies rightmost-first
/// to coordinates (post-multiplication semantics). The generator emits canvas
/// ops in the same left-to-right order as the SVG value.
sealed class SvgTransformOp {
  const SvgTransformOp();
}

/// `translate(tx, ty)`.
class SvgTranslate extends SvgTransformOp {
  const SvgTranslate({required this.tx, this.ty = 0});
  final double tx;
  final double ty;
}

/// `scale(sx, sy)`.
class SvgScale extends SvgTransformOp {
  const SvgScale({required this.sx, required this.sy});
  final double sx;
  final double sy;
}

/// `rotate(angle, cx?, cy?)`.
class SvgRotate extends SvgTransformOp {
  const SvgRotate({required this.angle, this.cx, this.cy});

  /// Angle in degrees.
  final double angle;

  /// Optional rotation center. When both are `null` the pivot is origin.
  final double? cx;
  final double? cy;
}
