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

  static final RegExp _identifierWord = RegExp(r'[A-Z]+(?=[A-Z][a-z]|[0-9]|$)|[A-Z]?[a-z]+|[0-9]+');

  final SvgDocument document;
  final String sourcePath;

  /// Returns the constructor parameters of the generated SVG widget.
  ///
  /// Used by `NamespaceAssembler` to emit matching accessor methods.
  List<AccessorParam> get params => _paramsFor(_buildColorPlan().colors);

  List<AccessorParam> _paramsFor(List<_ColorEntry> colors) {
    final result = <AccessorParam>[
      const AccessorParam(name: 'key', type: 'Key?'),
      const AccessorParam(name: 'width', type: 'double?', documentation: 'Width in logical pixels.'),
      const AccessorParam(name: 'height', type: 'double?', documentation: 'Height in logical pixels.'),
      const AccessorParam(
        name: 'maintainAspectRatio',
        type: 'bool',
        defaultValue: 'true',
        documentation:
            'When true (default), keeps the native aspect ratio using the larger '
            'requested value as the reference. When false, both dimensions are applied as-is and '
            'the asset may distort.',
      ),
    ];
    for (final color in colors) {
      final sourceDescription = color.sourceId == null
          ? 'Color ${color.name.substring('color'.length)}'
          : 'Color from SVG id `${color.sourceId}`';
      result.add(
        AccessorParam(
          name: color.name,
          type: 'Color?',
          documentation: '$sourceDescription — defaults to ${_colorToHex(color.r, color.g, color.b, color.a)}.',
        ),
      );
    }
    return result;
  }

  /// Generates the widget class (and painter) source fragment (no header/imports).
  ///
  /// The returned string is not Dart-formatted — the caller (`NamespaceAssembler`)
  /// formats the combined file.
  String generateWidgetClass() {
    final b = StringBuffer();
    final colorPlan = _buildColorPlan();
    _writeWidgetClass(b, colorPlan.colors);
    _writePainterClass(b, colorPlan);
    return b.toString();
  }

  String get widgetClassName => '_${Naming.widgetClassName(sourcePath)}';

  /// The PascalCase name without the private `_` prefix — used for inner classes.
  String get _baseName => Naming.widgetClassName(sourcePath);

  // ── Color extraction ──

  ({List<_ColorEntry> colors, Map<SvgElement, ({int? fill, int? stroke})> colorsByElement}) _buildColorPlan() {
    final colors = <_ColorEntry>[];
    final colorIndexByScopeAndValue = <(String?, String), int>{};
    final colorsByElement = <SvgElement, ({int? fill, int? stroke})>{};

    int? add((double, double, double, double)? color, String? sourceId) {
      if (color == null) return null;
      final key = (sourceId, _colorKey(color));
      final existing = colorIndexByScopeAndValue[key];
      if (existing != null) return existing;
      final index = colors.length;
      final (r, g, b, a) = color;
      colors.add(_ColorEntry(name: '', sourceId: sourceId, r: r, g: g, b: b, a: a));
      colorIndexByScopeAndValue[key] = index;
      return index;
    }

    void walk(List<SvgElement> elements, String? ancestorGroupId) {
      for (final element in elements) {
        if (element case SvgGroup(:final children)) {
          walk(children, element.id ?? ancestorGroupId);
          continue;
        }
        final sourceId = element.id ?? ancestorGroupId;
        colorsByElement[element] = (
          fill: add(element.style.fillColor, sourceId),
          stroke: add(element.style.strokeColor, sourceId),
        );
      }
    }

    walk(document.children, null);

    final countBySourceId = <String, int>{};
    for (final color in colors) {
      final sourceId = color.sourceId;
      if (sourceId != null) countBySourceId.update(sourceId, (count) => count + 1, ifAbsent: () => 1);
    }
    final ordinalBySourceId = <String, int>{};
    final usedNames = {'key', 'width', 'height', 'maintainAspectRatio'};
    var anonymousOrdinal = 0;
    final namedColors = <_ColorEntry>[];
    for (final color in colors) {
      final sourceId = color.sourceId;
      String proposedName;
      if (sourceId == null) {
        anonymousOrdinal++;
        proposedName = 'color$anonymousOrdinal';
      } else {
        final ordinal = ordinalBySourceId.update(sourceId, (value) => value + 1, ifAbsent: () => 1);
        final base = _semanticColorBase(sourceId);
        proposedName = countBySourceId[sourceId] == 1 ? base : '$base$ordinal';
      }
      var name = proposedName;
      var suffix = 2;
      while (!usedNames.add(name)) {
        name = '$proposedName$suffix';
        suffix++;
      }
      namedColors.add(color.withName(name));
    }
    return (colors: namedColors, colorsByElement: colorsByElement);
  }

  String _semanticColorBase(String id) {
    final words = _identifierWord.allMatches(id).map((match) => match.group(0)!).toList();
    if (words.isEmpty || RegExp('^[0-9]').hasMatch(words.first)) {
      return 'svgIdColor';
    }
    final identifier =
        words.first.toLowerCase() +
        words.skip(1).map((word) => '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}').join();
    return identifier.toLowerCase().endsWith('color') ? identifier : '${identifier}Color';
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
    final widgetParams = _paramsFor(colors);
    for (final param in widgetParams) {
      b.writeln('    ${param.constructorInitializer},');
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
    for (final param in widgetParams) {
      final fieldDeclaration = param.fieldDeclaration;
      if (fieldDeclaration == null) continue;
      b.write(fieldDeclaration);
      b.writeln();
    }

    b.writeln('  @override');
    b.writeln('  double? get svgWidgetWidth => width;');
    b.writeln();
    b.writeln('  @override');
    b.writeln('  double? get svgWidgetHeight => height;');
    b.writeln();
    b.writeln('  @override');
    b.writeln('  bool get svgMaintainAspectRatio => maintainAspectRatio;');
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
        b.writeln('            ${color.name}: ${color.name} ?? const Color($hex),');
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

  void _writePainterClass(
    StringBuffer b,
    ({List<_ColorEntry> colors, Map<SvgElement, ({int? fill, int? stroke})> colorsByElement}) colorPlan,
  ) {
    final name = _baseName;
    final colors = colorPlan.colors;

    b.writeln('class _$name' + 'Painter extends CustomPainter {');
    if (colors.isNotEmpty) {
      b.writeln('  _$name' + 'Painter({');
      for (final color in colors) {
        b.writeln('    required this.${color.name},');
      }
      b.writeln('  });');
    } else {
      b.writeln('  _$name' + 'Painter();');
    }
    b.writeln();

    for (final color in colors) {
      b.writeln('  final Color ${color.name};');
    }
    if (colors.isNotEmpty) b.writeln();
    if (_usesFill(document.children)) {
      b.writeln('  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;');
    }
    if (_usesStroke(document.children)) {
      b.writeln('  final Paint _strokePaint = Paint()..style = PaintingStyle.stroke;');
    }
    b.writeln();

    // ── Geometry emission (walk, emit static fields) ──

    var pathIdx = 0;
    var rrectIdx = 0;
    var ellipseRectIdx = 0;
    var lineIdx = 0;
    var polyIdx = 0;
    final geometryFieldByElement = <SvgElement, String>{};

    void emitGeometry(List<SvgElement> elements) {
      for (final element in elements) {
        switch (element) {
          case final SvgPath element:
            final SvgPath(:commands, :style) = element;
            _emitPathField(b, pathIdx, commands, style.fillRule);
            geometryFieldByElement[element] = '__path$pathIdx';
            pathIdx++;
          case final SvgRect element:
            final SvgRect(:x, :y, :width, :height, :rx, :ry) = element;
            _emitRectField(b, rrectIdx, x, y, width, height, rx, ry);
            geometryFieldByElement[element] = rx > 0 || ry > 0 ? '_rrect$rrectIdx' : '_rect$rrectIdx';
            rrectIdx++;
          case final SvgCircle element:
            final SvgCircle(:cx, :cy, :r) = element;
            b.writeln(
              '  static const Rect _ellipseRect$ellipseRectIdx = Rect.fromCircle(center: Offset(${_fmt(cx)}, ${_fmt(cy)}), radius: ${_fmt(r)});',
            );
            b.writeln();
            geometryFieldByElement[element] = '_ellipseRect$ellipseRectIdx';
            ellipseRectIdx++;
          case final SvgEllipse element:
            final SvgEllipse(:cx, :cy, :rx, :ry) = element;
            b.writeln(
              '  static const Rect _ellipseRect$ellipseRectIdx = Rect.fromCenter(center: Offset(${_fmt(cx)}, ${_fmt(cy)}), width: ${_fmt(rx * 2)}, height: ${_fmt(ry * 2)});',
            );
            b.writeln();
            geometryFieldByElement[element] = '_ellipseRect$ellipseRectIdx';
            ellipseRectIdx++;
          case final SvgLine l:
            _emitLineField(b, lineIdx, l);
            geometryFieldByElement[l] = '__linePath$lineIdx';
            lineIdx++;
          case final SvgPolyline element:
            final SvgPolyline(:points) = element;
            _emitPolyPathField(b, polyIdx, points, false);
            geometryFieldByElement[element] = '__polyPath$polyIdx';
            polyIdx++;
          case final SvgPolygon element:
            final SvgPolygon(:points) = element;
            _emitPolyPathField(b, polyIdx, points, true);
            geometryFieldByElement[element] = '__polyPath$polyIdx';
            polyIdx++;
          case SvgGroup(:final children):
            emitGeometry(children); // recurse — groups don't have their own geometry
        }
      }
    }

    emitGeometry(document.children);

    // ── Clip path geometry emission ──

    var clipIdx = 0;
    final clipPathFieldNames = <String, String>{};
    for (final entry in document.clipPaths.entries) {
      final fieldName = '__clip$clipIdx';
      clipPathFieldNames[entry.key] = fieldName;
      _emitClipPathField(b, clipIdx, entry.value);
      clipIdx++;
    }

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

    _emitDrawCalls(
      b,
      document.children,
      colors,
      colorPlan.colorsByElement,
      geometryFieldByElement,
      clipPathFieldNames,
    );

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
        b.writeln('        oldDelegate.${color.name} != ${color.name}');
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
    List<_ColorEntry> colors,
    Map<SvgElement, ({int? fill, int? stroke})> colorsByElement,
    Map<SvgElement, String> geometryFieldByElement,
    Map<String, String> clipPathFieldNames,
  ) {
    for (final element in elements) {
      switch (element) {
        case SvgGroup(:final style, :final transform, :final children):
          final hasTransform = transform != null && transform.isNotEmpty;
          final clipField = clipPathFieldNames[style.clipPathId];
          final hasClip = clipField != null;
          if (hasTransform || hasClip) b.writeln('    canvas.save();');
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
          if (hasClip) {
            b.writeln('    canvas.clipPath($clipField);');
          }
          _emitDrawCalls(b, children, colors, colorsByElement, geometryFieldByElement, clipPathFieldNames);
          if (hasTransform || hasClip) b.writeln('    canvas.restore();');
        case SvgPath(:final style):
          _emitClippedDraw(
            b,
            style,
            () => _emitPathDraw(b, style, geometryFieldByElement[element]!, colors, colorsByElement[element]!),
            clipPathFieldNames,
          );
        case SvgRect(:final style, :final rx, :final ry):
          _emitClippedDraw(
            b,
            style,
            () => _emitRectDraw(
              b,
              style,
              geometryFieldByElement[element]!,
              colors,
              colorsByElement[element]!,
              rx > 0 || ry > 0,
            ),
            clipPathFieldNames,
          );
        case SvgCircle(:final style):
        case SvgEllipse(:final style):
          _emitClippedDraw(
            b,
            style,
            () => _emitEllipseDraw(b, style, geometryFieldByElement[element]!, colors, colorsByElement[element]!),
            clipPathFieldNames,
          );
        case SvgLine(:final style):
          _emitClippedDraw(
            b,
            style,
            () => _emitLineDraw(b, style, geometryFieldByElement[element]!, colors, colorsByElement[element]!),
            clipPathFieldNames,
          );
        case SvgPolyline(:final style):
        case SvgPolygon(:final style):
          _emitClippedDraw(
            b,
            style,
            () => _emitPolyDraw(b, style, geometryFieldByElement[element]!, colors, colorsByElement[element]!),
            clipPathFieldNames,
          );
      }
    }
  }

  void _emitClippedDraw(
    StringBuffer b,
    SvgStyle style,
    void Function() emitDraw,
    Map<String, String> clipPathFieldNames,
  ) {
    final clipField = clipPathFieldNames[style.clipPathId];
    if (clipField != null) {
      b.writeln('    canvas.save();');
      b.writeln('    canvas.clipPath($clipField);');
      emitDraw();
      b.writeln('    canvas.restore();');
    } else {
      emitDraw();
    }
  }

  void _emitPathDraw(
    StringBuffer b,
    SvgStyle style,
    String fieldName,
    List<_ColorEntry> colors,
    ({int? fill, int? stroke}) colorIndices,
  ) {
    final hasFill = style.fillColor != null && style.fillOpacity > 0 && style.opacity > 0;
    final hasStroke = style.strokeColor != null && style.strokeOpacity > 0 && style.opacity > 0;
    if (!hasFill && !hasStroke) return;

    if (hasFill) {
      final opacity = _fmt(style.fillOpacity * style.opacity);
      b.writeln(
        '    canvas.drawPath($fieldName, ${_colorRef(colors[colorIndices.fill!].name, opacity, '_fillPaint')});',
      );
    }
    if (hasStroke) {
      final opacity = _fmt(style.strokeOpacity * style.opacity);
      final cap = _lineCap(style.strokeLineCap);
      final join = _lineJoin(style.strokeLineJoin);
      b.writeln(
        '    canvas.drawPath($fieldName, ${_strokeColorRef(colors[colorIndices.stroke!].name, opacity, style.strokeWidth, cap, join)});',
      );
    }
  }

  void _emitRectDraw(
    StringBuffer b,
    SvgStyle style,
    String fieldName,
    List<_ColorEntry> colors,
    ({int? fill, int? stroke}) colorIndices,
    bool rounded,
  ) {
    final hasFill = style.fillColor != null && style.fillOpacity > 0 && style.opacity > 0;
    final hasStroke = style.strokeColor != null && style.strokeOpacity > 0 && style.opacity > 0;
    if (!hasFill && !hasStroke) return;

    if (hasFill) {
      final opacity = _fmt(style.fillOpacity * style.opacity);
      if (rounded) {
        b.writeln(
          '    canvas.drawRRect($fieldName, ${_colorRef(colors[colorIndices.fill!].name, opacity, '_fillPaint')});',
        );
      } else {
        b.writeln(
          '    canvas.drawRect($fieldName, ${_colorRef(colors[colorIndices.fill!].name, opacity, '_fillPaint')});',
        );
      }
    }
    if (hasStroke) {
      final opacity = _fmt(style.strokeOpacity * style.opacity);
      final cap = _lineCap(style.strokeLineCap);
      final join = _lineJoin(style.strokeLineJoin);
      if (rounded) {
        b.writeln(
          '    canvas.drawRRect($fieldName, ${_strokeColorRef(colors[colorIndices.stroke!].name, opacity, style.strokeWidth, cap, join)});',
        );
      } else {
        b.writeln(
          '    canvas.drawRect($fieldName, ${_strokeColorRef(colors[colorIndices.stroke!].name, opacity, style.strokeWidth, cap, join)});',
        );
      }
    }
  }

  void _emitEllipseDraw(
    StringBuffer b,
    SvgStyle style,
    String fieldName,
    List<_ColorEntry> colors,
    ({int? fill, int? stroke}) colorIndices,
  ) {
    final hasFill = style.fillColor != null && style.fillOpacity > 0 && style.opacity > 0;
    final hasStroke = style.strokeColor != null && style.strokeOpacity > 0 && style.opacity > 0;
    if (!hasFill && !hasStroke) return;

    if (hasFill) {
      final opacity = _fmt(style.fillOpacity * style.opacity);
      b.writeln(
        '    canvas.drawOval($fieldName, ${_colorRef(colors[colorIndices.fill!].name, opacity, '_fillPaint')});',
      );
    }
    if (hasStroke) {
      final opacity = _fmt(style.strokeOpacity * style.opacity);
      final cap = _lineCap(style.strokeLineCap);
      final join = _lineJoin(style.strokeLineJoin);
      b.writeln(
        '    canvas.drawOval($fieldName, ${_strokeColorRef(colors[colorIndices.stroke!].name, opacity, style.strokeWidth, cap, join)});',
      );
    }
  }

  void _emitLineDraw(
    StringBuffer b,
    SvgStyle style,
    String fieldName,
    List<_ColorEntry> colors,
    ({int? fill, int? stroke}) colorIndices,
  ) {
    if (style.strokeColor == null || style.strokeOpacity <= 0 || style.opacity <= 0) return;
    final opacity = _fmt(style.strokeOpacity * style.opacity);
    final cap = _lineCap(style.strokeLineCap);
    final join = _lineJoin(style.strokeLineJoin);
    b.writeln(
      '    canvas.drawPath($fieldName, ${_strokeColorRef(colors[colorIndices.stroke!].name, opacity, style.strokeWidth, cap, join)});',
    );
  }

  void _emitPolyDraw(
    StringBuffer b,
    SvgStyle style,
    String fieldName,
    List<_ColorEntry> colors,
    ({int? fill, int? stroke}) colorIndices,
  ) {
    final hasFill = style.fillColor != null && style.fillOpacity > 0 && style.opacity > 0;
    final hasStroke = style.strokeColor != null && style.strokeOpacity > 0 && style.opacity > 0;
    if (!hasFill && !hasStroke) return;

    if (hasFill) {
      final opacity = _fmt(style.fillOpacity * style.opacity);
      b.writeln(
        '    canvas.drawPath($fieldName, ${_colorRef(colors[colorIndices.fill!].name, opacity, '_fillPaint')});',
      );
    }
    if (hasStroke) {
      final opacity = _fmt(style.strokeOpacity * style.opacity);
      final cap = _lineCap(style.strokeLineCap);
      final join = _lineJoin(style.strokeLineJoin);
      b.writeln(
        '    canvas.drawPath($fieldName, ${_strokeColorRef(colors[colorIndices.stroke!].name, opacity, style.strokeWidth, cap, join)});',
      );
    }
  }

  // ── Field emission helpers ──

  void _emitPathField(StringBuffer b, int idx, List<SvgPathCommand> commands, SvgFillRule fillRule) {
    b.writeln('  static final Path __path$idx = Path()');
    if (fillRule == SvgFillRule.evenodd) {
      b.writeln('    ..fillType = PathFillType.evenOdd');
    }
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
      b.writeln('    Rect.fromLTWH(${_fmt(x)}, ${_fmt(y)}, ${_fmt(w)}, ${_fmt(h)}),');
      b.writeln('    const Radius.circular(${_fmt(rx > ry ? rx : ry)}),');
      b.writeln('  );');
    } else {
      b.writeln('  static const Rect _rect$idx =');
      b.writeln('      Rect.fromLTWH(${_fmt(x)}, ${_fmt(y)}, ${_fmt(w)}, ${_fmt(h)});');
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

  // ── Clip path field emission ──

  void _emitClipPathField(StringBuffer b, int idx, SvgClipPath clipPath) {
    b.writeln('  static final Path __clip$idx = Path()');
    if (clipPath.clipRule == SvgFillRule.evenodd) {
      b.writeln('    ..fillType = PathFillType.evenOdd');
    }
    _emitClipPathShapes(b, clipPath.children);
    b.writeln('  ;');
    b.writeln();
  }

  void _emitClipPathShapes(StringBuffer b, List<SvgElement> shapes) {
    for (final shape in shapes) {
      switch (shape) {
        case SvgPath(:final commands):
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
        case SvgRect(:final x, :final y, :final width, :final height, :final rx, :final ry):
          if (rx > 0 || ry > 0) {
            b.writeln('    ..addRRect(RRect.fromRectAndRadius(');
            b.writeln('      Rect.fromLTWH(${_fmt(x)}, ${_fmt(y)}, ${_fmt(width)}, ${_fmt(height)}),');
            b.writeln('      const Radius.circular(${_fmt(rx > ry ? rx : ry)}),');
            b.writeln('    ))');
          } else {
            b.writeln('    ..addRect(const Rect.fromLTWH(${_fmt(x)}, ${_fmt(y)}, ${_fmt(width)}, ${_fmt(height)}))');
          }
        case SvgCircle(:final cx, :final cy, :final r):
          b.writeln(
            '    ..addOval(const Rect.fromCircle(center: Offset(${_fmt(cx)}, ${_fmt(cy)}), radius: ${_fmt(r)}))',
          );
        case SvgEllipse(:final cx, :final cy, :final rx, :final ry):
          b.writeln(
            '    ..addOval(const Rect.fromCenter(center: Offset(${_fmt(cx)}, ${_fmt(cy)}), width: ${_fmt(rx * 2)}, height: ${_fmt(ry * 2)}))',
          );
        case SvgLine():
          break;
        case SvgPolyline(:final points):
          for (var i = 0; i < points.length; i++) {
            final (px, py) = points[i];
            if (i == 0) {
              b.writeln('    ..moveTo(${_fmt(px)}, ${_fmt(py)})');
            } else {
              b.writeln('    ..lineTo(${_fmt(px)}, ${_fmt(py)})');
            }
          }
        case SvgPolygon(:final points):
          for (var i = 0; i < points.length; i++) {
            final (px, py) = points[i];
            if (i == 0) {
              b.writeln('    ..moveTo(${_fmt(px)}, ${_fmt(py)})');
            } else {
              b.writeln('    ..lineTo(${_fmt(px)}, ${_fmt(py)})');
            }
          }
          b.writeln('    ..close()');
        case SvgGroup(:final children):
          _emitClipPathShapes(b, children);
      }
    }
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

  bool _usesFill(List<SvgElement> elements) {
    for (final element in elements) {
      if (element is SvgGroup) {
        if (_usesFill(element.children)) return true;
        continue;
      }
      if (element.style.fillColor != null) return true;
    }
    return false;
  }

  bool _usesStroke(List<SvgElement> elements) {
    for (final element in elements) {
      if (element is SvgGroup) {
        if (_usesStroke(element.children)) return true;
        continue;
      }
      if (element.style.strokeColor != null) return true;
    }
    return false;
  }
}

class _ColorEntry {
  const _ColorEntry({
    required this.name,
    required this.sourceId,
    required this.r,
    required this.g,
    required this.b,
    required this.a,
  });

  final String name;
  final String? sourceId;
  final double r;
  final double g;
  final double b;
  final double a;

  _ColorEntry withName(String name) {
    return _ColorEntry(name: name, sourceId: sourceId, r: r, g: g, b: b, a: a);
  }
}
