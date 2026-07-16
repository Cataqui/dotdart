// StringBuffer.writeln returns void. Cascading void calls is valid Dart but
// makes the code harder to read. This is a known false positive.
// ignore_for_file: cascade_invocations, prefer_adjacent_string_concatenation

import '../models/svg_document.dart';
import '../models/svg_element.dart';
import '../models/svg_style.dart';

import 'accessor_param.dart';
import 'naming.dart';

/// Generates a self-contained Dart `StatelessWidget` + `CustomPainter` from
/// a parsed [SvgDocument].
class SvgGenerator {
  SvgGenerator(this.document, this.sourcePath);

  final SvgDocument document;
  final String sourcePath;

  /// Returns the constructor parameters of the generated SVG widget.
  ///
  /// Used by `NamespaceAssembler` to emit matching accessor methods.
  List<AccessorParam> get params {
    final colors = _extractColors();
    final result = <AccessorParam>[
      const AccessorParam(name: 'key', type: 'Key?'),
      const AccessorParam(name: 'width', type: 'double?'),
      const AccessorParam(name: 'height', type: 'double?'),
    ];
    for (final color in colors) {
      result.add(AccessorParam(name: 'color${color.index}', type: 'Color?'));
    }
    return result;
  }

  /// Generates the widget class (and painter) source fragment (no header/imports).
  ///
  /// The returned string is not Dart-formatted — the caller (`NamespaceAssembler`)
  /// formats the combined file.
  String generateWidgetClass() {
    final b = StringBuffer();
    final colors = _extractColors();
    _writeWidgetClass(b, colors);
    _writePainterClass(b, colors);
    return b.toString();
  }

  String get widgetClassName => '_${Naming.widgetClassName(sourcePath)}';

  /// The PascalCase name without the private `_` prefix — used for inner classes.
  String get _baseName => Naming.widgetClassName(sourcePath);

  // ── Color extraction ──

  List<_ColorEntry> _extractColors() {
    final seen = <String>{};
    final result = <_ColorEntry>[];
    var index = 0;

    void add((double, double, double, double)? color) {
      if (color == null) return;
      final (r, g, b, a) = color;
      final key = '$r,$g,$b,$a';
      if (seen.contains(key)) return;
      seen.add(key);
      index++;
      result.add(_ColorEntry(index: index, r: r, g: g, b: b, a: a));
    }

    void walk(List<SvgElement> elements) {
      for (final element in elements) {
        add(element.style.fillColor);
        add(element.style.strokeColor);
        if (element is SvgGroup) walk(element.children);
      }
    }

    walk(document.children);
    return result;
  }

  // ── Widget class ──

  void _writeWidgetClass(StringBuffer b, List<_ColorEntry> colors) {
    final name = widgetClassName;
    b.writeln('/// A dotdart-generated SVG widget from `$sourcePath`.');
    b.writeln('///');
    b.writeln('/// Renders a ${document.viewBox.width}×${document.viewBox.height} SVG');
    b.writeln(
      '/// on a viewBox of ${document.viewBox.minX} ${document.viewBox.minY} '
      '${document.viewBox.width} ${document.viewBox.height}.',
    );
    b.writeln('/// No flutter_svg runtime dependency — drawn entirely via [CustomPainter].');
    b.writeln('class $name extends StatelessWidget with _DotdartSvgSizing {');
    b.writeln('  const $name({');
    b.writeln('    super.key,');
    b.writeln('    this.width,');
    b.writeln('    this.height,');

    for (final color in colors) {
      b.writeln('    this.color${color.index},');
    }

    b.writeln('  });');
    b.writeln();
    b.writeln('  static const double _svgWidth = ${_fmt(document.nativeWidth)};');
    b.writeln('  static const double _svgHeight = ${_fmt(document.nativeHeight)};');
    b.writeln('  static const double _viewBoxMinX = ${_fmt(document.viewBox.minX)};');
    b.writeln('  static const double _viewBoxMinY = ${_fmt(document.viewBox.minY)};');
    b.writeln('  static const double _viewBoxWidth = ${_fmt(document.viewBox.width)};');
    b.writeln('  static const double _viewBoxHeight = ${_fmt(document.viewBox.height)};');
    b.writeln();
    b.writeln('  /// Width in logical pixels.');
    b.writeln('  ///');
    b.writeln('  /// When only [width] is set, [height] is derived from the SVG viewBox');
    b.writeln('  /// aspect ratio. Explicit sizes are painted at the requested size,');
    b.writeln('  /// even when that overflows tighter parent constraints.');
    b.writeln('  final double? width;');
    b.writeln();
    b.writeln('  /// Height in logical pixels.');
    b.writeln('  ///');
    b.writeln('  /// When only [height] is set, [width] is derived from the SVG viewBox');
    b.writeln('  /// aspect ratio.');
    b.writeln('  final double? height;');
    b.writeln();

    for (final color in colors) {
      final hex = _colorToHex(color.r, color.g, color.b, color.a);
      b.writeln('  /// Color ${color.index} — defaults to $hex.');
      b.writeln('  final Color? color${color.index};');
      b.writeln();
    }

    b.writeln('  @override');
    b.writeln('  double? get svgWidgetWidth => width;');
    b.writeln();
    b.writeln('  @override');
    b.writeln('  double? get svgWidgetHeight => height;');
    b.writeln();
    b.writeln('  @override');
    b.writeln('  double get svgNativeWidth => $name._svgWidth;');
    b.writeln();
    b.writeln('  @override');
    b.writeln('  double get svgNativeHeight => $name._svgHeight;');
    b.writeln();
    b.writeln('  @override');
    b.writeln('  double get svgViewBoxWidth => $name._viewBoxWidth;');
    b.writeln();
    b.writeln('  @override');
    b.writeln('  double get svgViewBoxHeight => $name._viewBoxHeight;');
    b.writeln();

    b.writeln('  @override');
    b.writeln('  Widget buildPainter({required double width, required double height}) {');
    final painterName = _baseName;
    b.writeln('    return SizedBox.fromSize(');
    b.writeln('      size: Size(width, height),');
    b.writeln('      child: RepaintBoundary(');
    b.writeln('        child: CustomPaint(');
    if (colors.isNotEmpty) {
      b.writeln('          painter: _$painterName' + 'Painter(');
      for (final color in colors) {
        final hex = _colorToHex(color.r, color.g, color.b, color.a);
        b.writeln('            color${color.index}: this.color${color.index} ?? const Color($hex),');
      }
      b.writeln('          ),');
    } else {
      b.writeln('          painter: _$painterName' + 'Painter(),');
    }
    b.writeln('          size: Size(width, height),');
    b.writeln('        ),');
    b.writeln('      ),');
    b.writeln('    );');
    b.writeln('  }');
    b.writeln('}');
    b.writeln();
  }

  // ── Painter class ──

  void _writePainterClass(StringBuffer b, List<_ColorEntry> colors) {
    final name = _baseName;

    // Build color lookup: key → index
    final colorKeyToIndex = <String, int>{};
    for (final color in colors) {
      colorKeyToIndex['${color.r},${color.g},${color.b},${color.a}'] = color.index;
    }

    b.writeln('class _$name' + 'Painter extends CustomPainter {');
    if (colors.isNotEmpty) {
      b.writeln('  _$name' + 'Painter({');
      for (final color in colors) {
        b.writeln('    required this.color${color.index},');
      }
      b.writeln('  });');
    } else {
      b.writeln('  _$name' + 'Painter();');
    }
    b.writeln();

    for (final color in colors) {
      b.writeln('  final Color color${color.index};');
    }
    if (colors.isNotEmpty) b.writeln();
    b.writeln('  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;');
    b.writeln('  final Paint _strokePaint = Paint()..style = PaintingStyle.stroke;');
    b.writeln();

    // ── Geometry emission (walk, emit static fields) ──

    var pathIdx = 0;
    var rrectIdx = 0;
    var ellipseRectIdx = 0;
    var lineIdx = 0;
    var polyIdx = 0;

    void emitGeometry(List<SvgElement> elements) {
      for (final element in elements) {
        switch (element) {
          case SvgPath(:final commands):
            _emitPathField(b, pathIdx, commands);
            pathIdx++;
          case SvgRect(:final x, :final y, :final width, :final height, :final rx, :final ry):
            _emitRectField(b, rrectIdx, x, y, width, height, rx, ry);
            rrectIdx++;
          case SvgCircle(:final cx, :final cy, :final r):
            b.writeln(
              '  static final Rect _ellipseRect$ellipseRectIdx = Rect.fromCircle(center: const Offset(${_fmt(cx)}, ${_fmt(cy)}), radius: ${_fmt(r)});',
            );
            b.writeln();
            ellipseRectIdx++;
          case SvgEllipse(:final cx, :final cy, :final rx, :final ry):
            b.writeln(
              '  static final Rect _ellipseRect$ellipseRectIdx = Rect.fromCenter(center: const Offset(${_fmt(cx)}, ${_fmt(cy)}), width: ${_fmt(rx * 2)}, height: ${_fmt(ry * 2)});',
            );
            b.writeln();
            ellipseRectIdx++;
          case final SvgLine l:
            _emitLineField(b, lineIdx, l);
            lineIdx++;
          case SvgPolyline(:final points):
            _emitPolyPathField(b, polyIdx, points, false);
            polyIdx++;
          case SvgPolygon(:final points):
            _emitPolyPathField(b, polyIdx, points, true);
            polyIdx++;
          case SvgGroup(:final children):
            emitGeometry(children); // recurse — groups don't have their own geometry
        }
      }
    }

    emitGeometry(document.children);

    // ── Paint method ──

    final widgetName = widgetClassName;
    b.writeln('  @override');
    b.writeln('  void paint(Canvas canvas, Size size) {');
    b.writeln('    final scaleX = size.width / $widgetName._viewBoxWidth;');
    b.writeln('    final scaleY = size.height / $widgetName._viewBoxHeight;');
    b.writeln('    canvas');
    b.writeln('      ..save()');
    b.writeln('      ..scale(scaleX, scaleY)');
    b.writeln('      ..translate(-$widgetName._viewBoxMinX, -$widgetName._viewBoxMinY);');
    b.writeln();

    // Emit draw calls with matching counters
    pathIdx = 0;
    rrectIdx = 0;
    ellipseRectIdx = 0;
    lineIdx = 0;
    polyIdx = 0;
    _emitDrawCalls(b, document.children, colorKeyToIndex, pathIdx, rrectIdx, ellipseRectIdx, lineIdx, polyIdx);

    b.writeln('    canvas.restore();');
    b.writeln('  }');
    b.writeln();

    // ── shouldRepaint ──

    b.writeln('  @override');
    b.writeln('  bool shouldRepaint(covariant _$name' + 'Painter oldDelegate) {');
    if (colors.isNotEmpty) {
      b.writeln('    return');
      for (var i = 0; i < colors.length; i++) {
        final color = colors[i];
        if (i > 0) b.writeln('        ||');
        b.writeln('        oldDelegate.color${color.index} != color${color.index}');
      }
      b.writeln(';');
    } else {
      b.writeln('    return false;');
    }
    b.writeln('  }');
    b.writeln();
    b.writeln('}');
    b.writeln();
  }

  // ── Draw call emission ──

  void _emitDrawCalls(
    StringBuffer b,
    List<SvgElement> elements,
    Map<String, int> colorIndex,
    int pathIdx,
    int rrectIdx,
    int ellipseRectIdx,
    int lineIdx,
    int polyIdx,
  ) {
    var pIdx = pathIdx;
    var rIdx = rrectIdx;
    var eIdx = ellipseRectIdx;
    var lIdx = lineIdx;
    var p2Idx = polyIdx;

    for (final element in elements) {
      switch (element) {
        case SvgGroup(:final transform, :final children):
          final hasTransform = transform != null && transform.isNotEmpty;
          if (hasTransform) b.writeln('    canvas.save();');
          for (final op in transform ?? []) {
            switch (op) {
              case SvgTranslate(:final tx, :final ty):
                b.writeln('    canvas.translate(${_fmt(tx)}, ${_fmt(ty)});');
              case SvgScale(:final sx, :final sy):
                b.writeln('    canvas.scale(${_fmt(sx)}, ${_fmt(sy)});');
              case SvgRotate(:final angle, :final cx, :final cy):
                if (cx != null && cy != null) {
                  b.writeln(
                    '    canvas..translate(${_fmt(cx)}, ${_fmt(cy)})..rotate(${_fmt(angle)} * math.pi / 180)..translate(${_fmt(-cx)}, ${_fmt(-cy)});',
                  );
                } else {
                  b.writeln('    canvas.rotate(${_fmt(angle)} * math.pi / 180);');
                }
            }
          }
          _emitDrawCalls(b, children, colorIndex, pIdx, rIdx, eIdx, lIdx, p2Idx);
          if (hasTransform) b.writeln('    canvas.restore();');
        case SvgPath(:final style):
          _emitPathDraw(b, style, pIdx, colorIndex);
          pIdx++;
        case SvgRect(:final style, :final rx, :final ry):
          _emitRectDraw(b, style, rIdx, colorIndex, rx > 0 || ry > 0);
          rIdx++;
        case SvgCircle(:final style):
        case SvgEllipse(:final style):
          _emitEllipseDraw(b, style, eIdx, colorIndex);
          eIdx++;
        case SvgLine(:final style):
          _emitLineDraw(b, style, lIdx, colorIndex);
          lIdx++;
        case SvgPolyline(:final style):
        case SvgPolygon(:final style):
          _emitPolyDraw(b, style, p2Idx, colorIndex);
          p2Idx++;
      }
    }
  }

  void _emitPathDraw(StringBuffer b, SvgStyle style, int idx, Map<String, int> colorIndex) {
    final hasFill = style.fillColor != null && style.fillOpacity > 0 && style.opacity > 0;
    final hasStroke = style.strokeColor != null && style.strokeOpacity > 0 && style.opacity > 0;
    if (!hasFill && !hasStroke) return;

    if (hasFill) {
      final fi = colorIndex[_colorKey(style.fillColor!)]!;
      final opacity = _fmt(style.fillOpacity * style.opacity);
      b.writeln('    canvas.drawPath(__path$idx, ${_colorRef('color$fi', opacity, '_fillPaint')});');
    }
    if (hasStroke) {
      final si = colorIndex[_colorKey(style.strokeColor!)]!;
      final opacity = _fmt(style.strokeOpacity * style.opacity);
      final cap = _lineCap(style.strokeLineCap);
      final join = _lineJoin(style.strokeLineJoin);
      b.writeln(
        '    canvas.drawPath(__path$idx, ${_strokeColorRef('color$si', opacity, style.strokeWidth, cap, join)});',
      );
    }
  }

  void _emitRectDraw(StringBuffer b, SvgStyle style, int idx, Map<String, int> colorIndex, bool rounded) {
    final hasFill = style.fillColor != null && style.fillOpacity > 0 && style.opacity > 0;
    final hasStroke = style.strokeColor != null && style.strokeOpacity > 0 && style.opacity > 0;
    if (!hasFill && !hasStroke) return;

    if (hasFill) {
      final fi = colorIndex[_colorKey(style.fillColor!)]!;
      final opacity = _fmt(style.fillOpacity * style.opacity);
      if (rounded) {
        b.writeln('    canvas.drawRRect(_rrect$idx, ${_colorRef('color$fi', opacity, '_fillPaint')});');
      } else {
        b.writeln('    canvas.drawRect(_rect$idx, ${_colorRef('color$fi', opacity, '_fillPaint')});');
      }
    }
    if (hasStroke) {
      final si = colorIndex[_colorKey(style.strokeColor!)]!;
      final opacity = _fmt(style.strokeOpacity * style.opacity);
      final cap = _lineCap(style.strokeLineCap);
      final join = _lineJoin(style.strokeLineJoin);
      if (rounded) {
        b.writeln(
          '    canvas.drawRRect(_rrect$idx, ${_strokeColorRef('color$si', opacity, style.strokeWidth, cap, join)});',
        );
      } else {
        b.writeln(
          '    canvas.drawRect(_rect$idx, ${_strokeColorRef('color$si', opacity, style.strokeWidth, cap, join)});',
        );
      }
    }
  }

  void _emitEllipseDraw(StringBuffer b, SvgStyle style, int idx, Map<String, int> colorIndex) {
    final hasFill = style.fillColor != null && style.fillOpacity > 0 && style.opacity > 0;
    final hasStroke = style.strokeColor != null && style.strokeOpacity > 0 && style.opacity > 0;
    if (!hasFill && !hasStroke) return;

    if (hasFill) {
      final fi = colorIndex[_colorKey(style.fillColor!)]!;
      final opacity = _fmt(style.fillOpacity * style.opacity);
      b.writeln('    canvas.drawOval(_ellipseRect$idx, ${_colorRef('color$fi', opacity, '_fillPaint')});');
    }
    if (hasStroke) {
      final si = colorIndex[_colorKey(style.strokeColor!)]!;
      final opacity = _fmt(style.strokeOpacity * style.opacity);
      final cap = _lineCap(style.strokeLineCap);
      final join = _lineJoin(style.strokeLineJoin);
      b.writeln(
        '    canvas.drawOval(_ellipseRect$idx, ${_strokeColorRef('color$si', opacity, style.strokeWidth, cap, join)});',
      );
    }
  }

  void _emitLineDraw(StringBuffer b, SvgStyle style, int idx, Map<String, int> colorIndex) {
    if (style.strokeColor == null || style.strokeOpacity <= 0 || style.opacity <= 0) return;
    final si = colorIndex[_colorKey(style.strokeColor!)]!;
    final opacity = _fmt(style.strokeOpacity * style.opacity);
    final cap = _lineCap(style.strokeLineCap);
    final join = _lineJoin(style.strokeLineJoin);
    b.writeln(
      '    canvas.drawPath(__linePath$idx, ${_strokeColorRef('color$si', opacity, style.strokeWidth, cap, join)});',
    );
  }

  void _emitPolyDraw(StringBuffer b, SvgStyle style, int idx, Map<String, int> colorIndex) {
    final hasFill = style.fillColor != null && style.fillOpacity > 0 && style.opacity > 0;
    final hasStroke = style.strokeColor != null && style.strokeOpacity > 0 && style.opacity > 0;
    if (!hasFill && !hasStroke) return;

    if (hasFill) {
      final fi = colorIndex[_colorKey(style.fillColor!)]!;
      final opacity = _fmt(style.fillOpacity * style.opacity);
      b.writeln('    canvas.drawPath(__polyPath$idx, ${_colorRef('color$fi', opacity, '_fillPaint')});');
    }
    if (hasStroke) {
      final si = colorIndex[_colorKey(style.strokeColor!)]!;
      final opacity = _fmt(style.strokeOpacity * style.opacity);
      final cap = _lineCap(style.strokeLineCap);
      final join = _lineJoin(style.strokeLineJoin);
      b.writeln(
        '    canvas.drawPath(__polyPath$idx, ${_strokeColorRef('color$si', opacity, style.strokeWidth, cap, join)});',
      );
    }
  }

  // ── Field emission helpers ──

  void _emitPathField(StringBuffer b, int idx, List<SvgPathCommand> commands) {
    b.writeln('  static final Path __path$idx = Path()');
    for (final cmd in commands) {
      switch (cmd) {
        case SvgMoveTo(:final x, :final y):
          b.writeln('    ..moveTo(${_fmt(x)}, ${_fmt(y)})');
        case SvgLineTo(:final x, :final y):
          b.writeln('    ..lineTo(${_fmt(x)}, ${_fmt(y)})');
        case SvgCubicTo(:final x1, :final y1, :final x2, :final y2, :final x, :final y):
          b.writeln('    ..cubicTo(${_fmt(x1)}, ${_fmt(y1)}, ${_fmt(x2)}, ${_fmt(y2)}, ${_fmt(x)}, ${_fmt(y)})');
        case SvgQuadTo(:final x1, :final y1, :final x, :final y):
          b.writeln('    ..quadraticBezierTo(${_fmt(x1)}, ${_fmt(y1)}, ${_fmt(x)}, ${_fmt(y)})');
        case SvgClosePath():
          b.writeln('    ..close()');
      }
    }
    b.writeln('  ;');
    b.writeln();
  }

  void _emitRectField(StringBuffer b, int idx, double x, double y, double w, double h, double rx, double ry) {
    if (rx > 0 || ry > 0) {
      b.writeln('  static final RRect _rrect$idx = RRect.fromRectAndRadius(');
      b.writeln('    Rect.fromXYWH(${_fmt(x)}, ${_fmt(y)}, ${_fmt(w)}, ${_fmt(h)}),');
      b.writeln('    const Radius.circular(${_fmt(rx > ry ? rx : ry)}),');
      b.writeln('  );');
    } else {
      b.writeln('  static final Rect _rect$idx =');
      b.writeln('      Rect.fromXYWH(${_fmt(x)}, ${_fmt(y)}, ${_fmt(w)}, ${_fmt(h)});');
    }
    b.writeln();
  }

  void _emitLineField(StringBuffer b, int idx, SvgLine line) {
    b.writeln('  static final Path __linePath$idx = Path()');
    b.writeln('    ..moveTo(${_fmt(line.x1)}, ${_fmt(line.y1)})');
    b.writeln('    ..lineTo(${_fmt(line.x2)}, ${_fmt(line.y2)})');
    b.writeln('  ;');
    b.writeln();
  }

  void _emitPolyPathField(StringBuffer b, int idx, List<(double, double)> points, bool close) {
    b.writeln('  static final Path __polyPath$idx = Path()');
    for (var i = 0; i < points.length; i++) {
      final (x, y) = points[i];
      if (i == 0) {
        b.writeln('    ..moveTo(${_fmt(x)}, ${_fmt(y)})');
      } else {
        b.writeln('    ..lineTo(${_fmt(x)}, ${_fmt(y)})');
      }
    }
    if (close) b.writeln('    ..close()');
    b.writeln('  ;');
    b.writeln();
  }

  // ── Format helpers ──

  String _colorKey((double, double, double, double) color) {
    return '${color.$1},${color.$2},${color.$3},${color.$4}';
  }

  String _colorRef(String param, String opacity, String paintName) {
    if (opacity == '1') return '$paintName..color = $param';
    return '$paintName..color = _dotdartApplyOpacity($param, $opacity)';
  }

  String _strokeColorRef(String param, String opacity, double width, String cap, String join) {
    if (opacity == '1') {
      return '_strokePaint..color = $param..strokeWidth = ${_fmt(width)}..strokeCap = $cap..strokeJoin = $join';
    }
    return '_strokePaint..color = _dotdartApplyOpacity($param, $opacity)..strokeWidth = ${_fmt(width)}..strokeCap = $cap..strokeJoin = $join';
  }

  String _colorToHex(double r, double g, double b, double a) {
    final ri = (r * 255).round().clamp(0, 255);
    final gi = (g * 255).round().clamp(0, 255);
    final bi = (b * 255).round().clamp(0, 255);
    final ai = (a * 255).round().clamp(0, 255);
    return '0x${ai.toRadixString(16).padLeft(2, '0')}${ri.toRadixString(16).padLeft(2, '0')}${gi.toRadixString(16).padLeft(2, '0')}${bi.toRadixString(16).padLeft(2, '0')}';
  }

  String _fmt(double v) {
    if (v == v.roundToDouble() && v.abs() < 1e10) {
      return v.toInt().toString();
    }
    return v.toStringAsFixed(4).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }

  String _lineCap(SvgStrokeLineCap cap) {
    return switch (cap) {
      SvgStrokeLineCap.butt => 'StrokeCap.butt',
      SvgStrokeLineCap.round => 'StrokeCap.round',
      SvgStrokeLineCap.square => 'StrokeCap.square',
    };
  }

  String _lineJoin(SvgStrokeLineJoin join) {
    return switch (join) {
      SvgStrokeLineJoin.miter => 'StrokeJoin.miter',
      SvgStrokeLineJoin.round => 'StrokeJoin.round',
      SvgStrokeLineJoin.bevel => 'StrokeJoin.bevel',
    };
  }
}

class _ColorEntry {
  const _ColorEntry({required this.index, required this.r, required this.g, required this.b, required this.a});
  final int index;
  final double r;
  final double g;
  final double b;
  final double a;
}
