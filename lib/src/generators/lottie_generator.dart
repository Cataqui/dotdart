import 'package:dart_style/dart_style.dart';

import '../models/lottie_animation.dart';
import '../models/lottie_layer.dart';
import '../models/lottie_shape.dart';

/// Generates a self-contained Dart widget file from a [LottieAnimation] model.
class LottieGenerator {
  LottieGenerator(this.animation, this.sourcePath);

  /// The parsed Lottie animation.
  final LottieAnimation animation;

  /// The original asset path (e.g. `assets/lottie/swipe_up_onboarding.json`).
  final String sourcePath;

  /// Generates the Dart source code for the widget.
  String generate() {
    final b = StringBuffer();
    final colors = _extractColors();

    _writeHeader(b);
    _writeImports(b);
    _writeWidgetClass(b, colors);
    _writeStateClass(b, colors);
    _writePainterClass(b, colors);

    return DartFormatter(languageVersion: DartFormatter.latestLanguageVersion).format(b.toString());
  }

  /// Widget class name derived from the source file.
  String get widgetClassName {
    final name = sourcePath.split('/').last.split('.').first;
    return name
        .split(RegExp(r'[_\s-]+'))
        .map((s) => s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : '')
        .join();
  }

  // ── Color extraction ──

  List<_ColorEntry> _extractColors() {
    final seen = <String>{};
    final colors = <_ColorEntry>[];
    var index = 0;

    void add(double r, double g, double b, double a) {
      final key = '$r,$g,$b,$a';
      if (seen.contains(key)) return;
      seen.add(key);
      index++;
      colors.add(_ColorEntry(index: index, r: r, g: g, b: b, a: a));
    }

    for (final layer in animation.layers) {
      for (final group in layer.shapeGroups) {
        for (final item in group.items) {
          if (item is LottieFill) {
            add(item.colorR, item.colorG, item.colorB, item.colorA);
          } else if (item is LottieStroke) {
            add(item.colorR, item.colorG, item.colorB, item.colorA);
          }
        }
      }
    }

    return colors;
  }

  // ── Header ──

  void _writeHeader(StringBuffer b) {
    b.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
    b.writeln('// *****************************************************');
    b.writeln('//  dotdart');
    b.writeln('// *****************************************************');
    b.writeln();
    b.writeln('// coverage:ignore-file');
    b.writeln('// ignore_for_file: type=lint, unused_import, unused_element, unused_element_parameter');
    b.writeln();
  }

  // ── Imports ──

  void _writeImports(StringBuffer b) {
    b.writeln("import 'dart:math' as math;");
    b.writeln("import 'package:flutter/material.dart';");
    b.writeln();
  }

  // ── Widget class ──

  void _writeWidgetClass(StringBuffer b, List<_ColorEntry> colors) {
    final className = widgetClassName;
    b.writeln('/// A dotdart-generated animated widget from `$sourcePath`.');
    b.writeln('///');
    b.writeln('/// Renders a ${animation.durationMs}ms looping animation');
    b.writeln('/// (${animation.totalFrames} frames at ${animation.frameRate}Hz)');
    b.writeln('/// on a ${animation.width}×${animation.height} canvas.');
    b.writeln('/// No Lottie runtime dependency — the animation is drawn');
    b.writeln('/// entirely via [CustomPainter].');
    b.writeln('class $className extends StatefulWidget {');
    b.writeln('  const $className({');
    b.writeln('    super.key,');
    b.writeln('    this.width,');
    b.writeln('    this.height,');
    b.writeln('    this.animated = true,');

    for (final color in colors) {
      b.writeln('    this.color${color.index},');
    }

    b.writeln('  });');
    b.writeln();
    b.writeln('  static const double _lottieWidth = ${animation.width};');
    b.writeln('  static const double _lottieHeight = ${animation.height};');
    b.writeln('  static const int _totalFrames = ${animation.totalFrames};');
    b.writeln('  static const Duration _loopDuration = Duration(milliseconds: ${animation.durationMs});');
    b.writeln();
    b.writeln('  /// Width in logical pixels. When null, uses the Lottie native width.');
    b.writeln('  final double? width;');
    b.writeln();
    b.writeln('  /// Height in logical pixels. When null, uses the Lottie native height.');
    b.writeln('  final double? height;');
    b.writeln();
    b.writeln('  /// Whether the animation should play. When false, renders a static frame.');
    b.writeln('  final bool animated;');
    b.writeln();

    for (final color in colors) {
      final hex = _colorToHex(color.r, color.g, color.b, color.a);
      b.writeln('  /// Color ${color.index} — defaults to $hex.');
      b.writeln('  final Color? color${color.index};');
      b.writeln();
    }

    b.writeln('  @override');
    b.writeln('  State<$className> createState() => _${className}State();');
    b.writeln('}');
    b.writeln();
  }

  // ── State class ──

  void _writeStateClass(StringBuffer b, List<_ColorEntry> colors) {
    final className = widgetClassName;
    b.writeln('class _${className}State extends State<$className>');
    b.writeln('    with SingleTickerProviderStateMixin, WidgetsBindingObserver {');
    b.writeln('  late final AnimationController _controller;');
    b.writeln();
    b.writeln('  @override');
    b.writeln('  void initState() {');
    b.writeln('    super.initState();');
    b.writeln('    _controller = AnimationController(');
    b.writeln('      vsync: this,');
    b.writeln('      duration: $className._loopDuration,');
    b.writeln('    );');
    b.writeln('    if (widget.animated) _controller.repeat();');
    b.writeln('    WidgetsBinding.instance.addObserver(this);');
    b.writeln('  }');
    b.writeln();
    b.writeln('  @override');
    b.writeln('  void didUpdateWidget($className oldWidget) {');
    b.writeln('    super.didUpdateWidget(oldWidget);');
    b.writeln('    if (oldWidget.animated != widget.animated) {');
    b.writeln('      if (widget.animated) {');
    b.writeln('        _controller.repeat();');
    b.writeln('      } else {');
    b.writeln('        _controller.stop();');
    b.writeln('      }');
    b.writeln('    }');
    b.writeln('  }');
    b.writeln();
    b.writeln('  @override');
    b.writeln('  void dispose() {');
    b.writeln('    WidgetsBinding.instance.removeObserver(this);');
    b.writeln('    _controller.dispose();');
    b.writeln('    super.dispose();');
    b.writeln('  }');
    b.writeln();
    b.writeln('  @override');
    b.writeln('  void didChangeAppLifecycleState(AppLifecycleState state) {');
    b.writeln('    if (state == AppLifecycleState.paused) {');
    b.writeln('      _controller.stop();');
    b.writeln('    } else if (state == AppLifecycleState.resumed && widget.animated) {');
    b.writeln('      _controller.repeat();');
    b.writeln('    }');
    b.writeln('  }');
    b.writeln();
    b.writeln('  @override');
    b.writeln('  Widget build(BuildContext context) {');
    b.writeln('    final lottieAspect = $className._lottieHeight / $className._lottieWidth;');
    b.writeln(
      '    final width = widget.width ?? (widget.height != null ? widget.height! / lottieAspect : $className._lottieWidth);',
    );
    b.writeln('    final height = widget.height ?? width * lottieAspect;');
    b.writeln();
    b.writeln('    return SizedBox.fromSize(');
    b.writeln('      size: Size(width, height),');
    b.writeln('      child: RepaintBoundary(');
    b.writeln('        child: CustomPaint(');
    b.writeln('          painter: _${className}Painter(');
    b.writeln('            progress: widget.animated ? _controller : null,');

    for (final color in colors) {
      final hex = _colorToHex(color.r, color.g, color.b, color.a);
      b.writeln('            color${color.index}: widget.color${color.index} ?? const Color($hex),');
    }

    b.writeln('          ),');
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
    final className = widgetClassName;
    b.writeln('class _${className}Painter extends CustomPainter {');
    b.writeln('  _${className}Painter({');
    b.writeln('    Animation<double>? progress,');

    for (final color in colors) {
      b.writeln('    required this.color${color.index},');
    }

    b.writeln('  })  : _progress = progress,');
    b.writeln('        super(repaint: progress);');
    b.writeln();

    b.writeln('  final Animation<double>? _progress;');
    b.writeln();

    // Color fields
    for (final color in colors) {
      b.writeln('  final Color color${color.index};');
    }
    b.writeln();

    // ── Keyframe data ──
    _writeKeyframeData(b);

    // ── Path data ──
    _writePathData(b);

    // ── Keyframe evaluation helpers ──
    _writeEvalHelpers(b);

    // ── Paint method ──
    b.writeln('  @override');
    b.writeln('  void paint(Canvas canvas, Size size) {');
    b.writeln('    final frame = (_progress?.value ?? 0) * $className._totalFrames;');
    b.writeln('    final scaleX = size.width / $className._lottieWidth;');
    b.writeln('    final scaleY = size.height / $className._lottieHeight;');
    b.writeln();
    b.writeln('    canvas..save()..scale(scaleX, scaleY);');
    b.writeln();

    for (var i = 0; i < animation.layers.length; i++) {
      final layer = animation.layers[i];
      final methodName = _sanitizeMethodName('draw_${layer.name}_$i');
      b.writeln('    _$methodName(canvas, frame);');
    }

    b.writeln();
    b.writeln('    canvas.restore();');
    b.writeln('  }');
    b.writeln();

    // ── Draw methods per layer ──
    for (var i = 0; i < animation.layers.length; i++) {
      _writeDrawMethod(b, animation.layers[i], i, colors);
    }

    // ── shouldRepaint ──
    b.writeln('  @override');
    b.writeln('  bool shouldRepaint(covariant _${className}Painter oldDelegate) {');
    b.writeln('    return oldDelegate._progress != _progress');

    for (final color in colors) {
      b.writeln('        || oldDelegate.color${color.index} != color${color.index}');
    }

    b.writeln(';');
    b.writeln('  }');
    b.writeln('}');
    b.writeln();

    // ── Keyframe helper class ──
    b.writeln('class _DotdartScalarKeyframe {');
    b.writeln('  const _DotdartScalarKeyframe({');
    b.writeln('    required this.time,');
    b.writeln('    required this.start,');
    b.writeln('    this.end,');
    b.writeln('    this.curve,');
    b.writeln('    this.hold = false,');
    b.writeln('  });');
    b.writeln();
    b.writeln('  final double time;');
    b.writeln('  final double start;');
    b.writeln('  final double? end;');
    b.writeln('  final Cubic? curve;');
    b.writeln('  final bool hold;');
    b.writeln('}');
    b.writeln();
  }

  // ── Keyframe data emission ──

  void _writeKeyframeData(StringBuffer b) {
    for (var i = 0; i < animation.layers.length; i++) {
      final layer = animation.layers[i];
      final prefix = '_kf$i';

      _writeScalarKeyframes(b, '${prefix}_opacity', layer.opacity);
      _writeScalarKeyframes(b, '${prefix}_rotation', layer.rotation);
      _writeScalarKeyframes(b, '${prefix}_posX', layer.positionX);
      _writeScalarKeyframes(b, '${prefix}_posY', layer.positionY);
      _writeScalarKeyframes(b, '${prefix}_scaleX', layer.scaleX);
      _writeScalarKeyframes(b, '${prefix}_scaleY', layer.scaleY);
    }
  }

  void _writeScalarKeyframes(StringBuffer b, String name, LottieAnimatedScalar? anim) {
    if (anim == null || !anim.animated) return;

    b.writeln('  static const List<_DotdartScalarKeyframe> $name = [');
    for (final kf in anim.keyframes) {
      final curve = kf.outX != null
          ? 'Cubic(${_fmt(kf.outX!)}, ${_fmt(kf.outY!)}, ${_fmt(kf.inX!)}, ${_fmt(kf.inY!)})'
          : null;
      b.writeln('    _DotdartScalarKeyframe(');
      b.writeln('      time: ${_fmt(kf.time)},');
      b.writeln('      start: ${_fmt(kf.start)},');
      if (kf.end != null) {
        b.writeln('      end: ${_fmt(kf.end!)},');
      }
      if (curve != null) {
        b.writeln('      curve: $curve,');
      }
      if (kf.hold) {
        b.writeln('      hold: true,');
      }
      b.writeln('    ),');
    }
    b.writeln('  ];');
    b.writeln();
  }

  // ── Path data emission ──

  void _writePathData(StringBuffer b) {
    for (var layerIdx = 0; layerIdx < animation.layers.length; layerIdx++) {
      final layer = animation.layers[layerIdx];
      for (var groupIdx = 0; groupIdx < layer.shapeGroups.length; groupIdx++) {
        final group = layer.shapeGroups[groupIdx];
        for (var itemIdx = 0; itemIdx < group.items.length; itemIdx++) {
          final item = group.items[itemIdx];
          if (item is LottiePath) {
            _writeSinglePath(b, layerIdx, groupIdx, itemIdx, item);
          }
        }
      }
    }
  }

  void _writeSinglePath(StringBuffer b, int layerIdx, int groupIdx, int itemIdx, LottiePath path) {
    final name = '_path${layerIdx}_${groupIdx}_$itemIdx';
    final cacheName = '_cached$name';
    final getterName = '_$name';

    b.writeln('  static const List<Offset> ${name}Vertices = [');
    for (final v in path.vertices) {
      b.writeln('    Offset(${_fmt(v[0])}, ${_fmt(v[1])}),');
    }
    b.writeln('  ];');
    b.writeln();

    b.writeln('  static const List<Offset> ${name}InTangents = [');
    for (final t in path.inTangents) {
      b.writeln('    Offset(${_fmt(t[0])}, ${_fmt(t[1])}),');
    }
    b.writeln('  ];');
    b.writeln();

    b.writeln('  static const List<Offset> ${name}OutTangents = [');
    for (final t in path.outTangents) {
      b.writeln('    Offset(${_fmt(t[0])}, ${_fmt(t[1])}),');
    }
    b.writeln('  ];');
    b.writeln();

    b.writeln('  static Path? $cacheName;');
    b.writeln();
    b.writeln('  static Path get $getterName {');
    b.writeln('    if ($cacheName != null) return $cacheName!;');
    b.writeln('    final path = Path();');
    b.writeln('    const v = ${name}Vertices;');
    b.writeln('    const i = ${name}InTangents;');
    b.writeln('    const o = ${name}OutTangents;');
    b.writeln('    final n = v.length;');
    b.writeln();
    b.writeln('    path.moveTo(v[0].dx, v[0].dy);');
    b.writeln('    for (var k = 1; k < n; k++) {');
    b.writeln('      final c1 = v[k - 1] + o[k - 1];');
    b.writeln('      final c2 = v[k] + i[k];');
    b.writeln('      path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, v[k].dx, v[k].dy);');
    b.writeln('    }');
    b.writeln('    final c1 = v[n - 1] + o[n - 1];');
    b.writeln('    final c2 = v[0] + i[0];');
    b.writeln('    path');
    b.writeln('      ..cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, v[0].dx, v[0].dy)');
    b.writeln('      ..close();');
    b.writeln('    $cacheName = path;');
    b.writeln('    return path;');
    b.writeln('  }');
    b.writeln();
  }

  // ── Keyframe evaluation helpers ──

  void _writeEvalHelpers(StringBuffer b) {
    b.writeln('  static double _evalScalar(List<_DotdartScalarKeyframe> kfs, double frame) {');
    b.writeln('    if (kfs.isEmpty) return 0;');
    b.writeln('    if (frame <= kfs.first.time) return kfs.first.start;');
    b.writeln('    if (frame >= kfs.last.time) return kfs.last.start;');
    b.writeln();
    b.writeln('    for (var i = 0; i < kfs.length - 1; i++) {');
    b.writeln('      final cur = kfs[i];');
    b.writeln('      final next = kfs[i + 1];');
    b.writeln('      if (frame < next.time) {');
    b.writeln('        if (cur.hold) return cur.start;');
    b.writeln('        final t = (frame - cur.time) / (next.time - cur.time);');
    b.writeln('        final eased = cur.curve?.transform(t) ?? t;');
    b.writeln('        final end = cur.end ?? next.start;');
    b.writeln('        return cur.start + (end - cur.start) * eased;');
    b.writeln('      }');
    b.writeln('    }');
    b.writeln('    return kfs.last.start;');
    b.writeln('  }');
    b.writeln();
  }

  // ── Draw method per layer ──

  void _writeDrawMethod(StringBuffer b, LottieLayer layer, int index, List<_ColorEntry> colors) {
    final methodName = _sanitizeMethodName('draw_${layer.name}_$index');
    b.writeln('  void _$methodName(Canvas canvas, double frame) {');

    // Evaluate animated properties
    final hasOpacity = layer.opacity?.animated ?? false;
    final hasRotation = layer.rotation?.animated ?? false;
    final hasPosX = layer.positionX?.animated ?? false;
    final hasPosY = layer.positionY?.animated ?? false;
    final hasScaleX = layer.scaleX?.animated ?? false;
    final hasScaleY = layer.scaleY?.animated ?? false;

    if (hasOpacity) {
      b.writeln('    final opacity = _evalScalar(_kf${index}_opacity, frame) / 100;');
      b.writeln('    if (opacity <= 0) return;');
    }

    if (hasRotation) {
      b.writeln('    final rotation = _evalScalar(_kf${index}_rotation, frame);');
    }
    if (hasPosX) {
      b.writeln('    final posX = _evalScalar(_kf${index}_posX, frame);');
    }
    if (hasPosY) {
      b.writeln('    final posY = _evalScalar(_kf${index}_posY, frame);');
    }
    if (hasScaleX) {
      b.writeln('    final scaleX = _evalScalar(_kf${index}_scaleX, frame) / 100;');
    }
    if (hasScaleY) {
      b.writeln('    final scaleY = _evalScalar(_kf${index}_scaleY, frame) / 100;');
    }

    b.writeln('    canvas.save();');

    // Apply transform
    final posX = hasPosX ? 'posX' : _staticOrZero(layer.positionX);
    final posY = hasPosY ? 'posY' : _staticOrZero(layer.positionY);
    b.writeln('    canvas.translate($posX, $posY);');

    if (hasRotation) {
      b.writeln('    canvas.rotate(rotation * math.pi / 180);');
    } else if ((layer.rotation?.staticValue ?? 0) != 0) {
      b.writeln('    canvas.rotate(${_fmt(layer.rotation!.staticValue)} * math.pi / 180);');
    }

    final scaleX = hasScaleX ? 'scaleX' : _staticScaleOrOne(layer.scaleX);
    final scaleY = hasScaleY ? 'scaleY' : _staticScaleOrOne(layer.scaleY);
    b.writeln('    canvas.scale($scaleX, $scaleY);');

    if ((layer.anchorX ?? 0) != 0 || (layer.anchorY ?? 0) != 0) {
      b.writeln('    canvas.translate(${_fmt(-(layer.anchorX ?? 0))}, ${_fmt(-(layer.anchorY ?? 0))});');
    }

    // Draw shape groups
    for (final group in layer.shapeGroups) {
      _writeDrawGroup(b, group, colors, hasOpacity);
    }

    b.writeln('    canvas.restore();');
    b.writeln('  }');
    b.writeln();
  }

  void _writeDrawGroup(StringBuffer b, LottieGroup group, List<_ColorEntry> colors, bool hasLayerOpacity) {
    // Find fill, stroke, and transform
    LottieFill? fill;
    LottieStroke? stroke;
    LottieGroupTransform? transform;
    final shapes = <LottieShape>[];

    for (final item in group.items) {
      if (item is LottieFill)
        fill = item;
      else if (item is LottieStroke)
        stroke = item;
      else if (item is LottieGroupTransform)
        transform = item;
      else
        shapes.add(item);
    }

    if (shapes.isEmpty) return;

    b.writeln('    // Group: ${group.name}');
    b.writeln('    canvas.save();');

    if (transform != null) {
      if (transform.positionX != 0 || transform.positionY != 0) {
        b.writeln('    canvas.translate(${_fmt(transform.positionX)}, ${_fmt(transform.positionY)});');
      }
      if (transform.rotation != 0) {
        b.writeln('    canvas.rotate(${_fmt(transform.rotation)} * math.pi / 180);');
      }
      if (transform.scaleX != 100 || transform.scaleY != 100) {
        b.writeln('    canvas.scale(${_fmt(transform.scaleX / 100)}, ${_fmt(transform.scaleY / 100)});');
      }
      if (transform.anchorX != 0 || transform.anchorY != 0) {
        b.writeln('    canvas.translate(${_fmt(-transform.anchorX)}, ${_fmt(-transform.anchorY)});');
      }
    }

    // Draw each shape
    for (final shape in shapes) {
      if (shape is LottieRect) {
        _writeDrawRect(b, shape, fill, stroke, colors, hasLayerOpacity);
      } else if (shape is LottieEllipse) {
        _writeDrawEllipse(b, shape, fill, stroke, colors, hasLayerOpacity);
      } else if (shape is LottiePath) {
        _writeDrawPath(b, shape, fill, stroke, colors, hasLayerOpacity);
      }
    }

    b.writeln('    canvas.restore();');
  }

  void _writeDrawRect(
    StringBuffer b,
    LottieRect rect,
    LottieFill? fill,
    LottieStroke? stroke,
    List<_ColorEntry> colors,
    bool hasLayerOpacity,
  ) {
    final bodyRect =
        'Rect.fromCenter(center: const Offset(${_fmt(rect.positionX)}, ${_fmt(rect.positionY)}), width: ${_fmt(rect.width)}, height: ${_fmt(rect.height)})';
    b.writeln('    final bodyRect = $bodyRect;');
    b.writeln('    final body = RRect.fromRectAndRadius(bodyRect, const Radius.circular(${_fmt(rect.cornerRadius)}));');

    if (fill != null) {
      final colorIdx = _colorIndexForFill(fill, colors);
      final colorRef = hasLayerOpacity
          ? 'color$colorIdx'
          : 'color$colorIdx.withValues(alpha: ${_fmt(fill.opacity / 100)})';
      b.writeln('    final fillPaint = Paint()..color = $colorRef..style = PaintingStyle.fill;');
      b.writeln('    canvas.drawRRect(body, fillPaint);');
    }

    if (stroke != null) {
      final colorIdx = _colorIndexForStroke(stroke, colors);
      final cap = _lineCap(stroke.lineCap);
      final join = _lineJoin(stroke.lineJoin);
      final colorRef = hasLayerOpacity
          ? 'color$colorIdx'
          : 'color$colorIdx.withValues(alpha: ${_fmt(stroke.opacity / 100)})';
      b.writeln(
        '    final strokePaint = Paint()..color = $colorRef..style = PaintingStyle.stroke..strokeWidth = ${_fmt(stroke.width)}..strokeCap = $cap..strokeJoin = $join;',
      );
      b.writeln('    canvas.drawRRect(body, strokePaint);');
    }
  }

  void _writeDrawEllipse(
    StringBuffer b,
    LottieEllipse ellipse,
    LottieFill? fill,
    LottieStroke? stroke,
    List<_ColorEntry> colors,
    bool hasLayerOpacity,
  ) {
    final rect =
        'Rect.fromCenter(center: const Offset(${_fmt(ellipse.positionX)}, ${_fmt(ellipse.positionY)}), width: ${_fmt(ellipse.width)}, height: ${_fmt(ellipse.height)})';
    b.writeln('    final rect = $rect;');

    if (fill != null) {
      final colorIdx = _colorIndexForFill(fill, colors);
      final colorRef = hasLayerOpacity
          ? 'color$colorIdx'
          : 'color$colorIdx.withValues(alpha: ${_fmt(fill.opacity / 100)})';
      b.writeln('    final fillPaint = Paint()..color = $colorRef..style = PaintingStyle.fill;');
      b.writeln('    canvas.drawOval(rect, fillPaint);');
    }

    if (stroke != null) {
      final colorIdx = _colorIndexForStroke(stroke, colors);
      final cap = _lineCap(stroke.lineCap);
      final join = _lineJoin(stroke.lineJoin);
      final colorRef = hasLayerOpacity
          ? 'color$colorIdx'
          : 'color$colorIdx.withValues(alpha: ${_fmt(stroke.opacity / 100)})';
      b.writeln(
        '    final strokePaint = Paint()..color = $colorRef..style = PaintingStyle.stroke..strokeWidth = ${_fmt(stroke.width)}..strokeCap = $cap..strokeJoin = $join;',
      );
      b.writeln('    canvas.drawOval(rect, strokePaint);');
    }
  }

  void _writeDrawPath(
    StringBuffer b,
    LottiePath path,
    LottieFill? fill,
    LottieStroke? stroke,
    List<_ColorEntry> colors,
    bool hasLayerOpacity,
  ) {
    // Find the path index
    int? pathIdx;
    int? groupIdx;
    int? itemIdx;
    for (var li = 0; li < animation.layers.length && pathIdx == null; li++) {
      for (var gi = 0; gi < animation.layers[li].shapeGroups.length && pathIdx == null; gi++) {
        for (var ii = 0; ii < animation.layers[li].shapeGroups[gi].items.length; ii++) {
          if (identical(animation.layers[li].shapeGroups[gi].items[ii], path)) {
            pathIdx = ii;
            groupIdx = gi;
            itemIdx = ii;
            break;
          }
        }
      }
    }

    final pathName = '_path${pathIdx ?? 0}_${groupIdx ?? 0}_${itemIdx ?? 0}';

    if (fill != null) {
      final colorIdx = _colorIndexForFill(fill, colors);
      final colorRef = hasLayerOpacity
          ? 'color$colorIdx'
          : 'color$colorIdx.withValues(alpha: ${_fmt(fill.opacity / 100)})';
      b.writeln('    final fillPaint = Paint()..color = $colorRef..style = PaintingStyle.fill;');
      if (fill.fillRule == 2) {
        b.writeln('    fillPaint.style = PaintingStyle.fill;');
        b.writeln('    final path = Path.from(_$pathName);');
        b.writeln('    path.fillType = PathFillType.evenOdd;');
        b.writeln('    canvas.drawPath(path, fillPaint);');
      } else {
        b.writeln('    canvas.drawPath(_$pathName, fillPaint);');
      }
    }

    if (stroke != null) {
      final colorIdx = _colorIndexForStroke(stroke, colors);
      final cap = _lineCap(stroke.lineCap);
      final join = _lineJoin(stroke.lineJoin);
      final colorRef = hasLayerOpacity
          ? 'color$colorIdx'
          : 'color$colorIdx.withValues(alpha: ${_fmt(stroke.opacity / 100)})';
      b.writeln(
        '    final strokePaint = Paint()..color = $colorRef..style = PaintingStyle.stroke..strokeWidth = ${_fmt(stroke.width)}..strokeCap = $cap..strokeJoin = $join;',
      );
      b.writeln('    canvas.drawPath(_$pathName, strokePaint);');
    }
  }

  // ── Helpers ──

  String _colorToHex(double r, double g, double b, double a) {
    final ri = (r * 255).round().clamp(0, 255);
    final gi = (g * 255).round().clamp(0, 255);
    final bi = (b * 255).round().clamp(0, 255);
    final ai = (a * 255).round().clamp(0, 255);
    return '0x${ai.toRadixString(16).padLeft(2, '0')}${ri.toRadixString(16).padLeft(2, '0')}${gi.toRadixString(16).padLeft(2, '0')}${bi.toRadixString(16).padLeft(2, '0')}';
  }

  int _colorIndexForFill(LottieFill fill, List<_ColorEntry> colors) {
    final key = '${fill.colorR},${fill.colorG},${fill.colorB},${fill.colorA}';
    for (final c in colors) {
      if ('${c.r},${c.g},${c.b},${c.a}' == key) return c.index;
    }
    return 1;
  }

  int _colorIndexForStroke(LottieStroke stroke, List<_ColorEntry> colors) {
    final key = '${stroke.colorR},${stroke.colorG},${stroke.colorB},${stroke.colorA}';
    for (final c in colors) {
      if ('${c.r},${c.g},${c.b},${c.a}' == key) return c.index;
    }
    return 1;
  }

  String _lineCap(int lc) {
    switch (lc) {
      case 1:
        return 'StrokeCap.butt';
      case 2:
        return 'StrokeCap.round';
      case 3:
        return 'StrokeCap.square';
      default:
        return 'StrokeCap.butt';
    }
  }

  String _lineJoin(int lj) {
    switch (lj) {
      case 1:
        return 'StrokeJoin.miter';
      case 2:
        return 'StrokeJoin.round';
      case 3:
        return 'StrokeJoin.bevel';
      default:
        return 'StrokeJoin.miter';
    }
  }

  String _sanitizeMethodName(String name) {
    return name.replaceAll(RegExp('[^a-zA-Z0-9_]'), '_').replaceAll(RegExp('_+'), '_').replaceAll(RegExp(r'^_|_$'), '');
  }

  String _fmt(double v) {
    if (v == v.roundToDouble() && v.abs() < 1e10) {
      return v.toInt().toString();
    }
    return v.toStringAsFixed(4).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }

  String _staticOrZero(LottieAnimatedScalar? anim) {
    if (anim == null || anim.animated) return '0';
    return _fmt(anim.staticValue);
  }

  String _staticScaleOrOne(LottieAnimatedScalar? anim) {
    if (anim == null || anim.animated) return '1';
    return _fmt(anim.staticValue / 100);
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
