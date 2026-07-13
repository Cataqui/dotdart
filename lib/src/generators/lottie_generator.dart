// StringBuffer.writeln returns void. Cascading void calls is valid Dart but
// makes the code harder to read. This is a known false positive.
// ignore_for_file: cascade_invocations

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

  List<_CurveEntry> _extractCurves() {
    final curves = <_CurveEntry>[];
    final seen = <String>{};

    for (final layer in animation.layers) {
      final properties = [layer.opacity, layer.rotation, layer.positionX, layer.positionY, layer.scaleX, layer.scaleY];
      for (final property in properties) {
        if (property == null || !_hasAnimatedValue(property)) continue;
        for (var index = 0; index < property.keyframes.length - 1; index++) {
          final keyframe = property.keyframes[index];
          final next = property.keyframes[index + 1];
          final end = keyframe.end ?? next.start;
          if (keyframe.hold || end == keyframe.start) continue;
          if (keyframe.outX == null || keyframe.outY == null || keyframe.inX == null || keyframe.inY == null) {
            continue;
          }
          final key = '${keyframe.outX},${keyframe.outY},${keyframe.inX},${keyframe.inY}';
          if (!seen.add(key)) continue;
          curves.add(
            _CurveEntry(
              index: curves.length,
              outX: keyframe.outX!,
              outY: keyframe.outY!,
              inX: keyframe.inX!,
              inY: keyframe.inY!,
            ),
          );
        }
      }
    }

    return curves;
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
    b.writeln('    this.progress,');
    b.writeln('    this.respectDisableAnimations = true,');

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
    b.writeln('  /// Width in logical pixels.');
    b.writeln('  ///');
    b.writeln('  /// When only [width] is set, [height] is derived from the Lottie');
    b.writeln('  /// aspect ratio. Explicit sizes are painted at the requested size,');
    b.writeln('  /// even when that overflows tighter parent constraints.');
    b.writeln('  final double? width;');
    b.writeln();
    b.writeln('  /// Height in logical pixels.');
    b.writeln('  ///');
    b.writeln('  /// When only [height] is set, [width] is derived from the Lottie');
    b.writeln('  /// aspect ratio. Explicit sizes are painted at the requested size,');
    b.writeln('  /// even when that overflows tighter parent constraints.');
    b.writeln('  final double? height;');
    b.writeln();
    b.writeln('  /// Fixed animation progress from 0 to 1.');
    b.writeln('  ///');
    b.writeln('  /// When null, the generated widget loops automatically. When supplied,');
    b.writeln('  /// playback stops and the painter renders exactly this timeline position.');
    b.writeln('  /// Values outside 0 to 1 are clamped before painting.');
    b.writeln('  final double? progress;');
    b.writeln();
    b.writeln('  /// Whether platform reduced-motion settings should pause playback.');
    b.writeln('  final bool respectDisableAnimations;');
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
    b.writeln('  bool _canAnimateForLifecycle = true;');
    b.writeln();
    b.writeln('  bool _shouldAnimate() {');
    b.writeln(
      '    final disableAnimations = widget.respectDisableAnimations && (MediaQuery.maybeDisableAnimationsOf(context) ?? false);',
    );
    b.writeln('    return widget.progress == null && _canAnimateForLifecycle && !disableAnimations;');
    b.writeln('  }');
    b.writeln();
    b.writeln('  void _syncController() {');
    b.writeln('    if (_shouldAnimate()) {');
    b.writeln('      if (!_controller.isAnimating) _controller.repeat();');
    b.writeln('      return;');
    b.writeln('    }');
    b.writeln('    _controller.stop();');
    b.writeln('  }');
    b.writeln();
    b.writeln('  Size _defaultSizeFor(BoxConstraints constraints) {');
    b.writeln('    final lottieAspect = $className._lottieHeight / $className._lottieWidth;');
    b.writeln('    var width = $className._lottieWidth;');
    b.writeln('    if (constraints.hasBoundedWidth) {');
    b.writeln('      width = math.min(width, constraints.maxWidth);');
    b.writeln('    }');
    b.writeln('    if (constraints.hasBoundedHeight) {');
    b.writeln('      width = math.min(width, constraints.maxHeight / lottieAspect);');
    b.writeln('    }');
    b.writeln('    return Size(width, width * lottieAspect);');
    b.writeln('  }');
    b.writeln();
    b.writeln('  Widget _buildPainter({required double width, required double height}) {');
    b.writeln('    return SizedBox.fromSize(');
    b.writeln('      size: Size(width, height),');
    b.writeln('      child: RepaintBoundary(');
    b.writeln('        child: CustomPaint(');
    b.writeln('          painter: _${className}Painter(');
    b.writeln('            animationProgress: _shouldAnimate() ? _controller : null,');
    b.writeln('            fixedProgress: (widget.progress ?? 0).clamp(0, 1).toDouble(),');

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
    b.writeln();
    b.writeln('  @override');
    b.writeln('  void initState() {');
    b.writeln('    super.initState();');
    b.writeln('    _controller = AnimationController(');
    b.writeln('      vsync: this,');
    b.writeln('      duration: $className._loopDuration,');
    b.writeln('    );');
    b.writeln('    WidgetsBinding.instance.addObserver(this);');
    b.writeln('  }');
    b.writeln();
    b.writeln('  @override');
    b.writeln('  void didChangeDependencies() {');
    b.writeln('    super.didChangeDependencies();');
    b.writeln('    _syncController();');
    b.writeln('  }');
    b.writeln();
    b.writeln('  @override');
    b.writeln('  void didUpdateWidget($className oldWidget) {');
    b.writeln('    super.didUpdateWidget(oldWidget);');
    b.writeln('    _syncController();');
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
    b.writeln('    _canAnimateForLifecycle = state == AppLifecycleState.resumed;');
    b.writeln('    _syncController();');
    b.writeln('  }');
    b.writeln();
    b.writeln('  @override');
    b.writeln('  Widget build(BuildContext context) {');
    b.writeln('    final hasExplicitSize = widget.width != null || widget.height != null;');
    b.writeln('    final lottieAspect = $className._lottieHeight / $className._lottieWidth;');
    b.writeln(
      '    final width = widget.width ?? (widget.height != null ? widget.height! / lottieAspect : $className._lottieWidth);',
    );
    b.writeln('    final height = widget.height ?? width * lottieAspect;');
    b.writeln();
    b.writeln('    if (!hasExplicitSize) {');
    b.writeln('      return LayoutBuilder(');
    b.writeln('        builder: (context, constraints) {');
    b.writeln('          final size = _defaultSizeFor(constraints);');
    b.writeln('          return _buildPainter(width: size.width, height: size.height);');
    b.writeln('        },');
    b.writeln('      );');
    b.writeln('    }');
    b.writeln();
    b.writeln('    return OverflowBox(');
    b.writeln('      alignment: Alignment.topLeft,');
    b.writeln('      minWidth: width,');
    b.writeln('      maxWidth: width,');
    b.writeln('      minHeight: height,');
    b.writeln('      maxHeight: height,');
    b.writeln('      child: _buildPainter(width: width, height: height),');
    b.writeln('    );');
    b.writeln('  }');
    b.writeln('}');
    b.writeln();
  }

  // ── Painter class ──

  void _writePainterClass(StringBuffer b, List<_ColorEntry> colors) {
    final className = widgetClassName;
    final curves = _extractCurves();
    b.writeln('class _${className}Painter extends CustomPainter {');
    b.writeln('  _${className}Painter({');
    b.writeln('    required double fixedProgress,');
    b.writeln('    Animation<double>? animationProgress,');

    for (final color in colors) {
      b.writeln('    required this.color${color.index},');
    }

    b.writeln('  })  : _fixedProgress = fixedProgress,');
    b.writeln('        _animationProgress = animationProgress,');
    b.writeln('        super(repaint: animationProgress);');
    b.writeln();

    b.writeln('  final double _fixedProgress;');
    b.writeln('  final Animation<double>? _animationProgress;');
    b.writeln();

    // Color fields
    for (final color in colors) {
      b.writeln('  final Color color${color.index};');
    }
    b.writeln();
    b.writeln('  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;');
    b.writeln('  final Paint _strokePaint = Paint()..style = PaintingStyle.stroke;');
    b.writeln();

    // ── Keyframe data ──
    _writeKeyframeData(b, curves);

    // ── Path data ──
    _writeGeometryData(b);
    _writePathData(b);

    // ── Keyframe evaluation helpers ──
    _writeEvalHelpers(b, curves);

    // ── Paint method ──
    b.writeln('  @override');
    b.writeln('  void paint(Canvas canvas, Size size) {');
    b.writeln('    final progress = _animationProgress?.value ?? _fixedProgress;');
    b.writeln('    final frame = progress * $className._totalFrames;');
    b.writeln('    final scaleX = size.width / $className._lottieWidth;');
    b.writeln('    final scaleY = size.height / $className._lottieHeight;');
    b.writeln();
    b.writeln('    canvas..save()..scale(scaleX, scaleY);');
    b.writeln();

    for (var i = animation.layers.length - 1; i >= 0; i--) {
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
    b.writeln('    return oldDelegate._fixedProgress != _fixedProgress');
    b.writeln('        || oldDelegate._animationProgress != _animationProgress');

    for (final color in colors) {
      b.writeln('        || oldDelegate.color${color.index} != color${color.index}');
    }

    b.writeln(';');
    b.writeln('  }');
    b.writeln('}');
    b.writeln();
  }

  // ── Keyframe data emission ──

  void _writeKeyframeData(StringBuffer b, List<_CurveEntry> curves) {
    for (var i = 0; i < animation.layers.length; i++) {
      final layer = animation.layers[i];
      final prefix = '_kf$i';

      _writeScalarKeyframes(b, '${prefix}_opacity', layer.opacity, curves);
      _writeScalarKeyframes(b, '${prefix}_rotation', layer.rotation, curves);
      _writeScalarKeyframes(b, '${prefix}_posX', layer.positionX, curves);
      _writeScalarKeyframes(b, '${prefix}_posY', layer.positionY, curves);
      _writeScalarKeyframes(b, '${prefix}_scaleX', layer.scaleX, curves);
      _writeScalarKeyframes(b, '${prefix}_scaleY', layer.scaleY, curves);
    }
  }

  void _writeScalarKeyframes(StringBuffer b, String name, LottieAnimatedScalar? anim, List<_CurveEntry> curves) {
    if (anim == null || !_hasAnimatedValue(anim)) return;

    final keyframes = anim.keyframes;
    b.writeln('  double $name(double frame) {');
    if (keyframes.length == 1) {
      b.writeln('    return ${_fmt(keyframes.single.start)};');
      b.writeln('  }');
      b.writeln();
      return;
    }

    final first = keyframes.first;
    final last = keyframes.last;
    b.writeln('    if (frame <= ${_fmt(first.time)}) return ${_fmt(first.start)};');
    b.writeln('    if (frame >= ${_fmt(last.time)}) return ${_fmt(last.start)};');

    for (var index = 0; index < keyframes.length - 1; index++) {
      final current = keyframes[index];
      final next = keyframes[index + 1];
      b.writeln('    if (frame < ${_fmt(next.time)}) {');
      final end = current.end ?? next.start;
      if (current.hold || end == current.start) {
        b.writeln('      return ${_fmt(current.start)};');
        b.writeln('    }');
        continue;
      }

      final duration = next.time - current.time;
      final frameOffset = current.time == 0 ? 'frame' : '(frame - ${_fmt(current.time)})';
      b.writeln('      final t = $frameOffset / ${_fmt(duration)};');
      final hasCompleteCurve =
          current.outX != null && current.outY != null && current.inX != null && current.inY != null;
      if (hasCompleteCurve) {
        final curveIndex = _curveIndexFor(
          curves,
          outX: current.outX!,
          outY: current.outY!,
          inX: current.inX!,
          inY: current.inY!,
        );
        b.writeln('      final eased = _transformCurve$curveIndex(t);');
      } else {
        b.writeln('      final eased = t;');
      }
      b.writeln('      return ${_fmt(current.start)} + ${_fmt(end - current.start)} * eased;');
      b.writeln('    }');
    }
    b.writeln('    return ${_fmt(last.start)};');
    b.writeln('  }');
    b.writeln();
  }

  // ── Path data emission ──

  void _writeGeometryData(StringBuffer b) {
    for (var layerIndex = 0; layerIndex < animation.layers.length; layerIndex++) {
      final layer = animation.layers[layerIndex];
      for (var groupIndex = 0; groupIndex < layer.shapeGroups.length; groupIndex++) {
        final parts = _groupParts(layer.shapeGroups[groupIndex]);
        final compoundFill = parts.fill != null && parts.fill!.fillRule == 2;
        final compoundStroke = _canUseCompoundStroke(fill: parts.fill, stroke: parts.stroke, shapes: parts.shapes);
        if ((compoundFill || parts.fill == null) && (compoundStroke || parts.stroke == null)) continue;

        final shapes = parts.shapes;
        for (var shapeIndex = 0; shapeIndex < shapes.length; shapeIndex++) {
          final shape = shapes[shapeIndex];
          if (shape is LottieRect) {
            b.writeln(
              '  static final RRect _rrect${layerIndex}_${groupIndex}_$shapeIndex = ${_rrectExpression(shape)};',
            );
          } else if (shape is LottieEllipse) {
            b.writeln(
              '  static final Rect _ellipseRect${layerIndex}_${groupIndex}_$shapeIndex = '
              '${_ellipseRectExpression(shape)};',
            );
          }
        }
      }
    }
    b.writeln();
  }

  void _writePathData(StringBuffer b) {
    for (var layerIdx = 0; layerIdx < animation.layers.length; layerIdx++) {
      final layer = animation.layers[layerIdx];
      for (var groupIdx = 0; groupIdx < layer.shapeGroups.length; groupIdx++) {
        final group = layer.shapeGroups[groupIdx];
        var shapeIndex = 0;
        for (final item in group.items) {
          if (item is LottiePath) {
            _writeSinglePath(b, layerIdx, groupIdx, shapeIndex, item);
          }
          if (item is! LottieFill && item is! LottieStroke && item is! LottieGroupTransform) {
            shapeIndex++;
          }
        }
      }
    }

    _writeCompoundPathData(b);
  }

  void _writeSinglePath(StringBuffer b, int layerIdx, int groupIdx, int itemIdx, LottiePath path) {
    final name = '_path${layerIdx}_${groupIdx}_$itemIdx';
    final vertices = path.vertices;
    final inTangents = path.inTangents;
    final outTangents = path.outTangents;
    b
      ..writeln('  static final Path _$name = Path()')
      ..writeln('    ..moveTo(${_fmt(vertices.first[0])}, ${_fmt(vertices.first[1])})');

    for (var index = 1; index < vertices.length; index++) {
      _writeCubicPathSegment(
        b,
        from: vertices[index - 1],
        to: vertices[index],
        outTangent: outTangents[index - 1],
        inTangent: inTangents[index],
      );
    }
    if (path.closed) {
      _writeCubicPathSegment(
        b,
        from: vertices.last,
        to: vertices.first,
        outTangent: outTangents.last,
        inTangent: inTangents.first,
      );
      b.writeln('    ..close();');
    } else {
      b.writeln('  ;');
    }
    b.writeln();
  }

  void _writeCubicPathSegment(
    StringBuffer b, {
    required List<double> from,
    required List<double> to,
    required List<double> outTangent,
    required List<double> inTangent,
  }) {
    b.writeln(
      '    ..cubicTo(${_sumFormatted(from[0], outTangent[0])}, ${_sumFormatted(from[1], outTangent[1])}, '
      '${_sumFormatted(to[0], inTangent[0])}, ${_sumFormatted(to[1], inTangent[1])}, '
      '${_fmt(to[0])}, ${_fmt(to[1])})',
    );
  }

  void _writeCompoundPathData(StringBuffer b) {
    for (var layerIndex = 0; layerIndex < animation.layers.length; layerIndex++) {
      final layer = animation.layers[layerIndex];
      for (var groupIndex = 0; groupIndex < layer.shapeGroups.length; groupIndex++) {
        final parts = _groupParts(layer.shapeGroups[groupIndex]);
        final compoundFill = parts.fill != null && parts.fill!.fillRule == 2;
        final compoundStroke = _canUseCompoundStroke(fill: parts.fill, stroke: parts.stroke, shapes: parts.shapes);
        if (compoundFill) {
          _writeStaticCompoundPath(
            b,
            name: '_compoundFillPath${layerIndex}_$groupIndex',
            shapes: parts.shapes,
            layerIndex: layerIndex,
            groupIndex: groupIndex,
            evenOdd: true,
          );
        }
        if (compoundStroke) {
          _writeStaticCompoundPath(
            b,
            name: '_compoundStrokePath${layerIndex}_$groupIndex',
            shapes: parts.shapes,
            layerIndex: layerIndex,
            groupIndex: groupIndex,
            evenOdd: false,
          );
        }
      }
    }
  }

  void _writeStaticCompoundPath(
    StringBuffer b, {
    required String name,
    required List<LottieShape> shapes,
    required int layerIndex,
    required int groupIndex,
    required bool evenOdd,
  }) {
    b.writeln('  static final Path $name = Path()');
    if (evenOdd) {
      b.writeln('    ..fillType = PathFillType.evenOdd');
    }
    for (var shapeIndex = 0; shapeIndex < shapes.length; shapeIndex++) {
      final shape = shapes[shapeIndex];
      if (shape is LottieRect) {
        b.writeln('    ..addRRect(${_rrectExpression(shape)})');
      } else if (shape is LottieEllipse) {
        b.writeln('    ..addOval(${_ellipseRectExpression(shape)})');
      } else if (shape is LottiePath) {
        b.writeln('    ..addPath(__path${layerIndex}_${groupIndex}_$shapeIndex, Offset.zero)');
      }
    }
    b.writeln('  ;');
    b.writeln();
  }

  // ── Keyframe evaluation helpers ──

  void _writeEvalHelpers(StringBuffer b, List<_CurveEntry> curves) {
    for (final curve in curves) {
      b.writeln('  double _curve${curve.index}T = double.nan;');
      b.writeln('  double _curve${curve.index}Value = 0;');
      b.writeln();
      b.writeln('  double _transformCurve${curve.index}(double t) {');
      b.writeln('    if (t == _curve${curve.index}T) return _curve${curve.index}Value;');
      b.writeln('    _curve${curve.index}T = t;');
      b.writeln(
        '    return _curve${curve.index}Value = const Cubic(${_fmt(curve.outX)}, ${_fmt(curve.outY)}, '
        '${_fmt(curve.inX)}, ${_fmt(curve.inY)}).transform(t);',
      );
      b.writeln('  }');
      b.writeln();
    }

    b.writeln('  static Color _applyOpacity(Color color, double opacity) {');
    b.writeln('    if (opacity == 1) return color;');
    b.writeln('    return color.withValues(alpha: math.min(1.0, math.max(0.0, color.a * opacity)));');
    b.writeln('  }');
    b.writeln();
  }

  // ── Draw method per layer ──

  void _writeDrawMethod(StringBuffer b, LottieLayer layer, int index, List<_ColorEntry> colors) {
    final methodName = _sanitizeMethodName('draw_${layer.name}_$index');
    b.writeln('  void _$methodName(Canvas canvas, double frame) {');

    // Evaluate animated properties
    final hasOpacity = _hasAnimatedValue(layer.opacity);
    final hasRotation = _hasAnimatedValue(layer.rotation);
    final hasPosX = _hasAnimatedValue(layer.positionX);
    final hasPosY = _hasAnimatedValue(layer.positionY);
    final hasScaleX = _hasAnimatedValue(layer.scaleX);
    final hasScaleY = _hasAnimatedValue(layer.scaleY);

    final staticOpacity = _fmt(_staticScalarValue(layer.opacity, fallback: 100) / 100);
    if (hasOpacity) {
      b.writeln('    final layerOpacity = _kf${index}_opacity(frame) / 100;');
    } else {
      b.writeln('    const double layerOpacity = $staticOpacity;');
    }
    b.writeln('    if (layerOpacity <= 0) return;');

    if (hasRotation) {
      b.writeln('    final rotation = _kf${index}_rotation(frame);');
    }
    if (hasPosX) {
      b.writeln('    final posX = _kf${index}_posX(frame);');
    }
    if (hasPosY) {
      b.writeln('    final posY = _kf${index}_posY(frame);');
    }
    if (hasScaleX) {
      b.writeln('    final scaleX = _kf${index}_scaleX(frame) / 100;');
    }
    if (hasScaleY) {
      b.writeln('    final scaleY = _kf${index}_scaleY(frame) / 100;');
    }

    // Apply transform
    final posX = hasPosX ? 'posX' : _staticOrZero(layer.positionX);
    final posY = hasPosY ? 'posY' : _staticOrZero(layer.positionY);
    final hasTranslation =
        hasPosX ||
        hasPosY ||
        _staticScalarValue(layer.positionX, fallback: 0) != 0 ||
        _staticScalarValue(layer.positionY, fallback: 0) != 0;
    final hasStaticRotation = _staticScalarValue(layer.rotation, fallback: 0) != 0;
    final hasScale =
        hasScaleX ||
        hasScaleY ||
        _staticScalarValue(layer.scaleX, fallback: 100) != 100 ||
        _staticScalarValue(layer.scaleY, fallback: 100) != 100;
    final hasAnchor = (layer.anchorX ?? 0) != 0 || (layer.anchorY ?? 0) != 0;
    final hasTransform = hasTranslation || hasRotation || hasStaticRotation || hasScale || hasAnchor;
    if (hasTransform) {
      b.writeln('    canvas.save();');
    }
    if (hasTranslation) {
      b.writeln('    canvas.translate($posX, $posY);');
    }

    if (hasRotation) {
      b.writeln('    canvas.rotate(rotation * math.pi / 180);');
    } else if (hasStaticRotation) {
      b.writeln('    canvas.rotate(${_fmt(_staticScalarValue(layer.rotation, fallback: 0))} * math.pi / 180);');
    }

    final scaleX = hasScaleX ? 'scaleX' : _staticScaleOrOne(layer.scaleX);
    final scaleY = hasScaleY ? 'scaleY' : _staticScaleOrOne(layer.scaleY);
    if (hasScale) {
      b.writeln('    canvas.scale($scaleX, $scaleY);');
    }

    if (hasAnchor) {
      b.writeln('    canvas.translate(${_fmt(-(layer.anchorX ?? 0))}, ${_fmt(-(layer.anchorY ?? 0))});');
    }

    // Draw shape groups
    for (var groupIndex = 0; groupIndex < layer.shapeGroups.length; groupIndex++) {
      _writeDrawGroup(b, layer.shapeGroups[groupIndex], index, groupIndex, colors);
    }

    if (hasTransform) {
      b.writeln('    canvas.restore();');
    }
    b.writeln('  }');
    b.writeln();
  }

  void _writeDrawGroup(StringBuffer b, LottieGroup group, int layerIndex, int groupIndex, List<_ColorEntry> colors) {
    final parts = _groupParts(group);
    final fill = parts.fill;
    final stroke = parts.stroke;
    final transform = parts.transform;
    final shapes = parts.shapes;

    if (shapes.isEmpty) return;
    if (transform != null && transform.opacity <= 0) return;

    b.writeln('    // Group: ${group.name}');
    final hasTransform =
        transform != null &&
        (transform.positionX != 0 ||
            transform.positionY != 0 ||
            transform.rotation != 0 ||
            transform.scaleX != 100 ||
            transform.scaleY != 100 ||
            transform.anchorX != 0 ||
            transform.anchorY != 0);
    if (hasTransform) {
      b.writeln('    canvas.save();');
    }

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

    final groupOpacity = (transform?.opacity ?? 100) / 100;
    final compoundFill = fill != null && fill.fillRule == 2;
    final compoundStroke = _canUseCompoundStroke(fill: fill, stroke: stroke, shapes: shapes);
    if (compoundFill) {
      _writeDrawCompoundFillPath(b, layerIndex, groupIndex, fill, colors, groupOpacity);
    }
    if (compoundStroke) {
      _writeDrawCompoundStrokePath(b, layerIndex, groupIndex, stroke!, colors, groupOpacity);
    }

    for (var shapeIndex = 0; shapeIndex < shapes.length; shapeIndex++) {
      final shape = shapes[shapeIndex];
      final shapeFill = compoundFill ? null : fill;
      final shapeStroke = compoundStroke ? null : stroke;
      if (shape is LottieRect) {
        _writeDrawRect(b, layerIndex, groupIndex, shapeIndex, shapeFill, shapeStroke, colors, groupOpacity);
      } else if (shape is LottieEllipse) {
        _writeDrawEllipse(b, layerIndex, groupIndex, shapeIndex, shapeFill, shapeStroke, colors, groupOpacity);
      } else if (shape is LottiePath) {
        _writeDrawPath(b, layerIndex, groupIndex, shapeIndex, shapeFill, shapeStroke, colors, groupOpacity);
      }
    }

    if (hasTransform) {
      b.writeln('    canvas.restore();');
    }
  }

  ({LottieFill? fill, LottieStroke? stroke, LottieGroupTransform? transform, List<LottieShape> shapes}) _groupParts(
    LottieGroup group,
  ) {
    LottieFill? fill;
    LottieStroke? stroke;
    LottieGroupTransform? transform;
    final shapes = <LottieShape>[];

    for (final item in group.items) {
      if (item is LottieFill) {
        fill = item;
      } else if (item is LottieStroke) {
        stroke = item;
      } else if (item is LottieGroupTransform) {
        transform = item;
      } else {
        shapes.add(item);
      }
    }

    return (fill: fill, stroke: stroke, transform: transform, shapes: shapes);
  }

  bool _canUseCompoundStroke({
    required LottieFill? fill,
    required LottieStroke? stroke,
    required List<LottieShape> shapes,
  }) {
    return fill == null && stroke != null && shapes.length > 1 && shapes.every((shape) => shape is LottiePath);
  }

  void _writeDrawCompoundFillPath(
    StringBuffer b,
    int layerIndex,
    int groupIndex,
    LottieFill fill,
    List<_ColorEntry> colors,
    double groupOpacity,
  ) {
    final pathName = '_compoundFillPath${layerIndex}_$groupIndex';
    final paintName = 'compoundFillPaint$groupIndex';
    final colorIdx = _colorIndexForFill(fill, colors);
    final opacity = _fmt(fill.opacity / 100 * groupOpacity);
    final colorRef = '_applyOpacity(color$colorIdx, layerOpacity * $opacity)';

    b.writeln('    final $paintName = _fillPaint..color = $colorRef;');

    b.writeln('    canvas.drawPath($pathName, $paintName);');
  }

  void _writeDrawCompoundStrokePath(
    StringBuffer b,
    int layerIndex,
    int groupIndex,
    LottieStroke stroke,
    List<_ColorEntry> colors,
    double groupOpacity,
  ) {
    final pathName = '_compoundStrokePath${layerIndex}_$groupIndex';
    final paintName = 'compoundStrokePaint$groupIndex';
    final colorIdx = _colorIndexForStroke(stroke, colors);
    final cap = _lineCap(stroke.lineCap);
    final join = _lineJoin(stroke.lineJoin);
    final opacity = _fmt(stroke.opacity / 100 * groupOpacity);
    final colorRef = '_applyOpacity(color$colorIdx, layerOpacity * $opacity)';

    b.writeln(
      '    final $paintName = _strokePaint..color = $colorRef..strokeWidth = ${_fmt(stroke.width)}..strokeCap = $cap..strokeJoin = $join;',
    );

    b.writeln('    canvas.drawPath($pathName, $paintName);');
  }

  void _writeDrawRect(
    StringBuffer b,
    int layerIndex,
    int groupIndex,
    int shapeIndex,
    LottieFill? fill,
    LottieStroke? stroke,
    List<_ColorEntry> colors,
    double groupOpacity,
  ) {
    if (fill == null && stroke == null) return;

    final suffix = '${groupIndex}_$shapeIndex';
    final bodyName = '_rrect${layerIndex}_${groupIndex}_$shapeIndex';
    final fillPaintName = 'fillPaint$suffix';
    final strokePaintName = 'strokePaint$suffix';

    if (fill != null) {
      final colorIdx = _colorIndexForFill(fill, colors);
      final opacity = _fmt(fill.opacity / 100 * groupOpacity);
      final colorRef = '_applyOpacity(color$colorIdx, layerOpacity * $opacity)';
      b
        ..writeln('    final $fillPaintName = _fillPaint..color = $colorRef;')
        ..writeln('    canvas.drawRRect($bodyName, $fillPaintName);');
    }

    if (stroke != null) {
      final colorIdx = _colorIndexForStroke(stroke, colors);
      final cap = _lineCap(stroke.lineCap);
      final join = _lineJoin(stroke.lineJoin);
      final opacity = _fmt(stroke.opacity / 100 * groupOpacity);
      final colorRef = '_applyOpacity(color$colorIdx, layerOpacity * $opacity)';
      b
        ..writeln(
          '    final $strokePaintName = _strokePaint..color = $colorRef..strokeWidth = ${_fmt(stroke.width)}..strokeCap = $cap..strokeJoin = $join;',
        )
        ..writeln('    canvas.drawRRect($bodyName, $strokePaintName);');
    }
  }

  void _writeDrawEllipse(
    StringBuffer b,
    int layerIndex,
    int groupIndex,
    int shapeIndex,
    LottieFill? fill,
    LottieStroke? stroke,
    List<_ColorEntry> colors,
    double groupOpacity,
  ) {
    if (fill == null && stroke == null) return;

    final suffix = '${groupIndex}_$shapeIndex';
    final rectName = '_ellipseRect${layerIndex}_${groupIndex}_$shapeIndex';
    final fillPaintName = 'fillPaint$suffix';
    final strokePaintName = 'strokePaint$suffix';
    if (fill != null) {
      final colorIdx = _colorIndexForFill(fill, colors);
      final opacity = _fmt(fill.opacity / 100 * groupOpacity);
      final colorRef = '_applyOpacity(color$colorIdx, layerOpacity * $opacity)';
      b
        ..writeln('    final $fillPaintName = _fillPaint..color = $colorRef;')
        ..writeln('    canvas.drawOval($rectName, $fillPaintName);');
    }

    if (stroke != null) {
      final colorIdx = _colorIndexForStroke(stroke, colors);
      final cap = _lineCap(stroke.lineCap);
      final join = _lineJoin(stroke.lineJoin);
      final opacity = _fmt(stroke.opacity / 100 * groupOpacity);
      final colorRef = '_applyOpacity(color$colorIdx, layerOpacity * $opacity)';
      b
        ..writeln(
          '    final $strokePaintName = _strokePaint..color = $colorRef..strokeWidth = ${_fmt(stroke.width)}..strokeCap = $cap..strokeJoin = $join;',
        )
        ..writeln('    canvas.drawOval($rectName, $strokePaintName);');
    }
  }

  void _writeDrawPath(
    StringBuffer b,
    int layerIndex,
    int groupIndex,
    int shapeIndex,
    LottieFill? fill,
    LottieStroke? stroke,
    List<_ColorEntry> colors,
    double groupOpacity,
  ) {
    if (fill == null && stroke == null) return;

    final suffix = '${groupIndex}_$shapeIndex';
    final pathName = '_path${layerIndex}_${groupIndex}_$shapeIndex';
    final fillPaintName = 'fillPaint$suffix';
    final strokePaintName = 'strokePaint$suffix';
    final evenOddPathName = 'path$suffix';

    if (fill != null) {
      final colorIdx = _colorIndexForFill(fill, colors);
      final opacity = _fmt(fill.opacity / 100 * groupOpacity);
      final colorRef = '_applyOpacity(color$colorIdx, layerOpacity * $opacity)';
      b.writeln('    final $fillPaintName = _fillPaint..color = $colorRef;');
      if (fill.fillRule == 2) {
        b
          ..writeln('    $fillPaintName.style = PaintingStyle.fill;')
          ..writeln('    final $evenOddPathName = Path.from(_$pathName);')
          ..writeln('    $evenOddPathName.fillType = PathFillType.evenOdd;')
          ..writeln('    canvas.drawPath($evenOddPathName, $fillPaintName);');
      } else {
        b.writeln('    canvas.drawPath(_$pathName, $fillPaintName);');
      }
    }

    if (stroke != null) {
      final colorIdx = _colorIndexForStroke(stroke, colors);
      final cap = _lineCap(stroke.lineCap);
      final join = _lineJoin(stroke.lineJoin);
      final opacity = _fmt(stroke.opacity / 100 * groupOpacity);
      final colorRef = '_applyOpacity(color$colorIdx, layerOpacity * $opacity)';
      b
        ..writeln(
          '    final $strokePaintName = _strokePaint..color = $colorRef..strokeWidth = ${_fmt(stroke.width)}..strokeCap = $cap..strokeJoin = $join;',
        )
        ..writeln('    canvas.drawPath(_$pathName, $strokePaintName);');
    }
  }

  // ── Helpers ──

  String _rrectExpression(LottieRect rect) {
    return 'RRect.fromRectAndRadius('
        '${_rectExpression(positionX: rect.positionX, positionY: rect.positionY, width: rect.width, height: rect.height)}, '
        'const Radius.circular(${_fmt(rect.cornerRadius)}))';
  }

  String _ellipseRectExpression(LottieEllipse ellipse) {
    return _rectExpression(
      positionX: ellipse.positionX,
      positionY: ellipse.positionY,
      width: ellipse.width,
      height: ellipse.height,
    );
  }

  String _rectExpression({
    required double positionX,
    required double positionY,
    required double width,
    required double height,
  }) {
    return 'Rect.fromCenter(center: const Offset(${_fmt(positionX)}, ${_fmt(positionY)}), '
        'width: ${_fmt(width)}, height: ${_fmt(height)})';
  }

  String _colorToHex(double r, double g, double b, double a) {
    final ri = (r * 255).round().clamp(0, 255);
    final gi = (g * 255).round().clamp(0, 255);
    final bi = (b * 255).round().clamp(0, 255);
    final ai = (a * 255).round().clamp(0, 255);
    return '0x${ai.toRadixString(16).padLeft(2, '0')}${ri.toRadixString(16).padLeft(2, '0')}${gi.toRadixString(16).padLeft(2, '0')}${bi.toRadixString(16).padLeft(2, '0')}';
  }

  int _curveIndexFor(
    List<_CurveEntry> curves, {
    required double outX,
    required double outY,
    required double inX,
    required double inY,
  }) {
    for (final curve in curves) {
      if (curve.outX == outX && curve.outY == outY && curve.inX == inX && curve.inY == inY) {
        return curve.index;
      }
    }
    throw StateError('Missing extracted Lottie easing curve.');
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

  String _sumFormatted(double first, double second) {
    return _fmt(double.parse(_fmt(first)) + double.parse(_fmt(second)));
  }

  bool _hasAnimatedValue(LottieAnimatedScalar? animation) {
    if (animation == null || !animation.animated || animation.keyframes.isEmpty) return false;

    final value = animation.keyframes.first.start;
    for (final keyframe in animation.keyframes) {
      if (keyframe.start != value || (keyframe.end != null && keyframe.end != value)) return true;
    }
    return false;
  }

  double _staticScalarValue(LottieAnimatedScalar? animation, {required double fallback}) {
    if (animation == null) return fallback;
    if (!animation.animated || animation.keyframes.isEmpty) return animation.staticValue;
    return animation.keyframes.first.start;
  }

  String _staticOrZero(LottieAnimatedScalar? anim) {
    if (_hasAnimatedValue(anim)) return '0';
    return _fmt(_staticScalarValue(anim, fallback: 0));
  }

  String _staticScaleOrOne(LottieAnimatedScalar? anim) {
    if (_hasAnimatedValue(anim)) return '1';
    return _fmt(_staticScalarValue(anim, fallback: 100) / 100);
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

class _CurveEntry {
  const _CurveEntry({
    required this.index,
    required this.outX,
    required this.outY,
    required this.inX,
    required this.inY,
  });

  final int index;
  final double outX;
  final double outY;
  final double inX;
  final double inY;
}
