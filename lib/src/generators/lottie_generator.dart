// StringBuffer.writeln returns void. Cascading void calls is valid Dart but
// makes the code harder to read. This is a known false positive.
// String concatenation with '+' is needed for interpolated class names.
// ignore_for_file: cascade_invocations, prefer_adjacent_string_concatenation

import '../models/lottie_animation.dart';
import '../models/lottie_keyframe.dart';
import '../models/lottie_layer.dart';
import '../models/lottie_shape.dart';
import '../models/lottie_shape_enums.dart';

import 'accessor_param.dart';
import 'naming.dart';

/// Generates a self-contained Dart widget file from a [LottieAnimation] model.
class LottieGenerator {
  LottieGenerator(this.animation, this.sourcePath);

  /// The parsed Lottie animation.
  final LottieAnimation animation;

  /// The original asset path (e.g. `assets/lottie/swipe_up_onboarding.json`).
  final String sourcePath;

  /// Returns the constructor parameters of the generated widget.
  ///
  /// Used by `NamespaceAssembler` to emit matching accessor methods.
  List<AccessorParam> get params => _paramsFor(_customizations());

  List<AccessorParam> _paramsFor(_CustomizationPlan customizations) {
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
      const AccessorParam(
        name: 'clip',
        type: 'bool',
        defaultValue: 'true',
        documentation: 'Whether painting is clipped to the Lottie canvas bounds.',
      ),
      const AccessorParam(name: 'progress', type: 'double?', documentation: 'Fixed animation progress from 0 to 1.'),
      const AccessorParam(
        name: 'delay',
        type: 'Duration',
        defaultValue: 'Duration.zero',
        documentation: 'Non-negative time to wait once before automatic playback starts.',
      ),
      const AccessorParam(
        name: 'duration',
        type: 'Duration?',
        documentation: 'Positive total playback time. When null, uses the duration from the Lottie file.',
      ),
      const AccessorParam(
        name: 'playback',
        type: 'LottiePlayback',
        defaultValue: 'LottiePlayback.once',
        documentation: 'Whether automatic playback runs once or loops continuously.',
      ),
      const AccessorParam(
        name: 'respectDisableAnimations',
        type: 'bool',
        defaultValue: 'true',
        documentation: 'Whether reduced-motion settings pause playback.',
      ),
    ];
    if (_hasOverrides(customizations)) {
      result.add(
        AccessorParam(
          name: 'overrides',
          type: _overridesClassName,
          defaultValue: 'const $_overridesClassName()',
          documentation: 'Text and color values that replace defaults from the Lottie file.',
        ),
      );
    }
    return result;
  }

  /// Generates the widget class (and state/painter) source fragment (no header/imports).
  ///
  /// The returned string is not Dart-formatted — the caller (`NamespaceAssembler`)
  /// formats the combined file.
  String generateWidgetClass() {
    final b = StringBuffer();
    final customizations = _customizations();
    _writeOverridesClass(b, customizations);
    _writeWidgetClass(b, customizations);
    _writeStateClass(b, customizations);
    _writePainterClass(b, customizations);
    return b.toString();
  }

  /// Widget class name derived from the source file.
  String get widgetClassName => '_${Naming.widgetClassName(sourcePath)}';

  /// Whether the generated painter uses Flutter path metrics.
  bool get requiresPathMetrics => _usesShape<LottieTrimPath>();

  /// The PascalCase name without the private `_` prefix — used for inner classes.
  String get _baseName => Naming.widgetClassName(sourcePath);

  String get _overridesClassName => '${_baseName}Overrides';

  // ── Layer and customization extraction ──

  List<_LayerEntry> get _layers {
    final result = <_LayerEntry>[];
    for (final layer in animation.layers) {
      result.add((index: result.length, layer: layer, compositionId: null));
    }
    for (final composition in animation.compositions.values) {
      for (final layer in composition.layers) {
        result.add(
          (
            index: result.length,
            layer: layer,
            compositionId: composition.id,
          ),
        );
      }
    }
    return result;
  }

  List<_LayerEntry> _parentEntries(_LayerEntry entry) {
    final scopedLayers = _layers.where((candidate) => candidate.compositionId == entry.compositionId);
    final layersBySourceIndex = <int, _LayerEntry>{
      for (final candidate in scopedLayers)
        if (candidate.layer.layerIndex != null) candidate.layer.layerIndex!: candidate,
    };
    final parents = <_LayerEntry>[];
    var parentIndex = entry.layer.parentIndex;
    while (parentIndex != null) {
      final parent = layersBySourceIndex[parentIndex];
      if (parent == null) {
        throw StateError('Missing parsed Lottie parent layer $parentIndex for "${entry.layer.name}".');
      }
      parents.add(parent);
      parentIndex = parent.layer.parentIndex;
    }
    return parents.reversed.toList();
  }

  _CustomizationPlan _customizations() {
    final textParams = <_TextParam>[];
    final colorParams = <_ColorParam>[];
    final textByLayer = <int, _TextParam>{};
    final colorByShape = <LottieShape, _ColorParam>{};
    final colorByTextLayer = <int, _ColorParam>{};
    final usedNames = <String>{
      'key',
      'width',
      'height',
      'maintainAspectRatio',
      'clip',
      'progress',
      'delay',
      'duration',
      'playback',
      'respectDisableAnimations',
      'overrides',
    };
    var genericTextIndex = 0;
    var genericColorIndex = 0;

    for (final entry in _layers) {
      final text = entry.layer.text;
      if (text == null) continue;
      final named = _textParameterName(entry.layer.name);
      final candidate = named ?? 'text${++genericTextIndex}';
      final param = (
        name: _availableName(candidate, usedNames),
        layerName: entry.layer.name.isEmpty ? 'unnamed text' : entry.layer.name,
      );
      textParams.add(param);
      textByLayer[entry.index] = param;
    }

    for (final entry in _layers) {
      final layer = entry.layer;
      final text = layer.text;
      if (text != null) {
        final textParam = textByLayer[entry.index]!;
        final hasNamedLayer = _parameterName(layer.name) != null;
        final candidate = hasNamedLayer ? '${textParam.name}Color' : 'color${++genericColorIndex}';
        final param = (
          name: _availableName(candidate, usedNames),
          layerName: layer.name.isEmpty ? 'unnamed text' : layer.name,
        );
        colorParams.add(param);
        colorByTextLayer[entry.index] = param;
      }

      final coloredShapes = <String, List<LottieShape>>{};
      for (final group in layer.shapeGroups) {
        for (final item in group.items) {
          final key = switch (item) {
            LottieFill() => '${item.colorR},${item.colorG},${item.colorB},${item.colorA}',
            LottieStroke() => '${item.colorR},${item.colorG},${item.colorB},${item.colorA}',
            _ => null,
          };
          if (key != null) coloredShapes.putIfAbsent(key, () => []).add(item);
        }
      }
      final layerName = _parameterName(layer.name);
      final shapeColorGroups = coloredShapes.values.toList();
      for (var index = 0; index < shapeColorGroups.length; index++) {
        final shapes = shapeColorGroups[index];
        final candidate = layerName == null
            ? 'color${++genericColorIndex}'
            : '$layerName'
                  'Color${shapeColorGroups.length == 1 ? '' : index + 1}';
        final param = (
          name: _availableName(candidate, usedNames),
          layerName: layer.name.isEmpty ? 'unnamed shape' : layer.name,
        );
        colorParams.add(param);
        for (final shape in shapes) {
          colorByShape[shape] = param;
        }
      }
    }

    return (
      textParams: textParams,
      colorParams: colorParams,
      textByLayer: textByLayer,
      colorByShape: colorByShape,
      colorByTextLayer: colorByTextLayer,
    );
  }

  String? _parameterName(String layerName) {
    final words = layerName.split(RegExp('[^A-Za-z0-9]+')).where((word) => word.isNotEmpty).toList();
    if (words.isEmpty || RegExp('^[0-9]').hasMatch(words.first)) return null;
    final name =
        words.first.toLowerCase() +
        words.skip(1).map((word) => '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}').join();
    if (_dartReservedWords.contains(name)) return null;
    return name;
  }

  String? _textParameterName(String layerName) {
    final name = _parameterName(layerName);
    if (name == null || name.toLowerCase().endsWith('text')) return name;
    return '${name}Text';
  }

  bool _hasOverrides(_CustomizationPlan customizations) {
    return customizations.textParams.isNotEmpty || customizations.colorParams.isNotEmpty;
  }

  bool _hasPainterResources(_CustomizationPlan customizations) {
    return customizations.textByLayer.isNotEmpty;
  }

  String _availableName(String candidate, Set<String> usedNames) {
    if (usedNames.add(candidate)) return candidate;
    var suffix = 2;
    while (!usedNames.add('$candidate$suffix')) {
      suffix++;
    }
    return '$candidate$suffix';
  }

  List<_CurveEntry> _extractCurves() {
    final curves = <_CurveEntry>[];
    final seen = <String>{};

    for (final entry in _layers) {
      final layer = entry.layer;
      final properties = <LottieAnimatedScalar?>[
        layer.opacity,
        layer.rotation,
        layer.positionX,
        layer.positionY,
        layer.scaleX,
        layer.scaleY,
        for (final group in layer.shapeGroups)
          for (final item in group.items)
            if (item case final LottieTrimPath trim) ...[trim.start, trim.end, trim.offset],
      ];
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
            (
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

  bool _usesShape<T extends LottieShape>() {
    for (final entry in _layers) {
      final layer = entry.layer;
      for (final group in layer.shapeGroups) {
        for (final item in group.items) {
          if (item is T) return true;
        }
      }
    }

    return false;
  }

  // ── Widget class ──

  void _writeOverridesClass(StringBuffer b, _CustomizationPlan customizations) {
    if (!_hasOverrides(customizations)) return;

    b.writeln('/// Text and color values that replace defaults in `${_dartDocText(sourcePath.split('/').last)}`.');
    b.writeln('final class $_overridesClassName {');
    b.writeln('  /// Creates Lottie value overrides.');
    b.writeln('  const $_overridesClassName({');
    for (final text in customizations.textParams) {
      b.writeln('    this.${text.name},');
    }
    for (final color in customizations.colorParams) {
      b.writeln('    this.${color.name},');
    }
    b.writeln('  });');
    b.writeln();
    for (final text in customizations.textParams) {
      b.writeln('  /// Replacement text for the `${_dartDocText(text.layerName)}` Lottie layer.');
      b.writeln('  final String? ${text.name};');
      b.writeln();
    }
    for (final color in customizations.colorParams) {
      b.writeln('  /// Replacement color for the `${_dartDocText(color.layerName)}` Lottie layer.');
      b.writeln('  final Color? ${color.name};');
      b.writeln();
    }
    b.writeln('}');
    b.writeln();
  }

  void _writeWidgetClass(StringBuffer b, _CustomizationPlan customizations) {
    final className = widgetClassName;
    b.writeln('/// A dotdart-generated animated widget from `${_dartDocText(sourcePath)}`.');
    b.writeln('///');
    b.writeln('/// Renders a ${animation.durationMs}ms animation');
    b.writeln('/// (${animation.totalFrames} frames at ${animation.frameRate}Hz)');
    b.writeln('/// on a ${animation.width}×${animation.height} canvas.');
    b.writeln('/// No Lottie runtime dependency — the animation is drawn');
    b.writeln('/// entirely via [CustomPainter].');
    b.writeln('class $className extends StatefulWidget {');
    b.writeln('  const $className({');
    final widgetParams = _paramsFor(customizations);
    for (final param in widgetParams) {
      b.writeln('    ${param.constructorInitializer},');
    }

    b.writeln('  });');
    b.writeln();
    b.writeln('  static const double _lottieWidth = ${animation.width};');
    b.writeln('  static const double _lottieHeight = ${animation.height};');
    b.writeln('  static const int _totalFrames = ${animation.totalFrames};');
    b.writeln('  static const Duration _nativeDuration = Duration(milliseconds: ${animation.durationMs});');
    b.writeln();
    for (final param in widgetParams) {
      final fieldDeclaration = param.fieldDeclaration;
      if (fieldDeclaration == null) continue;
      b.write(fieldDeclaration);
      b.writeln();
    }

    b.writeln('  @override');
    b.writeln('  State<$className> createState() => _${_baseName}State();');
    b.writeln('}');
    b.writeln();
  }

  // ── State class ──

  void _writeStateClass(StringBuffer b, _CustomizationPlan customizations) {
    final className = widgetClassName;
    final baseName = _baseName;
    final hasPainterResources = _hasPainterResources(customizations);
    b.writeln('class _$baseName' + 'State extends State<$className>');
    b.writeln('    with SingleTickerProviderStateMixin, WidgetsBindingObserver,');
    b.writeln('        _DotdartLottieAnimationState<$className> {');
    b.writeln();
    if (hasPainterResources) {
      b.writeln('  _$baseName' + 'Painter? _painter;');
      b.writeln();
    }
    b.writeln('  @override');
    b.writeln('  double? get lottieWidgetWidth => widget.width;');
    b.writeln();
    b.writeln('  @override');
    b.writeln('  double? get lottieWidgetHeight => widget.height;');
    b.writeln();
    b.writeln('  @override');
    b.writeln('  bool get lottieMaintainAspectRatio => widget.maintainAspectRatio;');
    b.writeln();
    b.writeln('  @override');
    b.writeln('  double? get lottieProgress => widget.progress;');
    b.writeln();
    b.writeln('  @override');
    b.writeln('  Duration get lottieDelay => widget.delay;');
    b.writeln();
    b.writeln('  @override');
    b.writeln('  Duration? get lottieDuration => widget.duration;');
    b.writeln();
    b.writeln('  @override');
    b.writeln('  LottiePlayback get lottiePlayback => widget.playback;');
    b.writeln();
    b.writeln('  @override');
    b.writeln('  bool get lottieRespectDisableAnimations => widget.respectDisableAnimations;');
    b.writeln();
    b.writeln('  @override');
    b.writeln('  Duration get lottieNativeDuration => $className._nativeDuration;');
    b.writeln();
    b.writeln('  @override');
    b.writeln('  double get lottieCanvasWidth => $className._lottieWidth;');
    b.writeln();
    b.writeln('  @override');
    b.writeln('  double get lottieCanvasHeight => $className._lottieHeight;');
    b.writeln();

    b.writeln('  @override');
    b.writeln('  Widget buildPainter({required double width, required double height}) {');
    final painterIndent = hasPainterResources ? '    ' : '          ';
    if (!hasPainterResources) {
      b.writeln('    return SizedBox.fromSize(');
      b.writeln('      size: Size(width, height),');
      b.writeln('      child: RepaintBoundary(');
      b.writeln('        child: CustomPaint(');
      b.writeln('          painter: _$baseName' + 'Painter(');
    } else {
      b.writeln('    final painter = _$baseName' + 'Painter(');
    }
    b.writeln('$painterIndent  animationProgress: widget.progress == null ? _controller : null,');
    b.writeln('$painterIndent  fixedProgress: (widget.progress ?? 0).clamp(0, 1).toDouble(),');
    b.writeln('$painterIndent  canvasScaleX: width / $className._lottieWidth,');
    b.writeln('$painterIndent  canvasScaleY: height / $className._lottieHeight,');
    b.writeln('$painterIndent  canvasRect: Rect.fromLTWH(0, 0, width, height),');
    b.writeln('$painterIndent  clip: widget.clip,');
    if (_hasOverrides(customizations)) {
      b.writeln('$painterIndent  overrides: widget.overrides,');
    }

    if (!hasPainterResources) {
      b.writeln('          ),');
    } else {
      b.writeln('    );');
      b.writeln('    _painter?.disposeResources();');
      b.writeln('    _painter = painter;');
      b.writeln('    return SizedBox.fromSize(');
      b.writeln('      size: Size(width, height),');
      b.writeln('      child: RepaintBoundary(');
      b.writeln('        child: CustomPaint(');
      b.writeln('          painter: painter,');
    }
    b.writeln('          size: Size(width, height),');
    b.writeln('        ),');
    b.writeln('      ),');
    b.writeln('    );');
    b.writeln('  }');
    if (hasPainterResources) {
      b.writeln();
      b.writeln('  @override');
      b.writeln('  void dispose() {');
      b.writeln('    _painter?.disposeResources();');
      b.writeln('    super.dispose();');
      b.writeln('  }');
    }
    b.writeln('}');
    b.writeln();
  }

  // ── Painter class ──

  void _writePainterClass(StringBuffer b, _CustomizationPlan customizations) {
    final className = widgetClassName;
    final baseName = _baseName;
    final curves = _extractCurves();
    b.writeln('class _$baseName' + 'Painter extends CustomPainter {');
    b.writeln('  _$baseName' + 'Painter({');
    b.writeln('    required this._fixedProgress,');
    b.writeln('    required this._canvasScaleX,');
    b.writeln('    required this._canvasScaleY,');
    b.writeln('    required this._canvasRect,');
    b.writeln('    required this.clip,');
    if (_hasOverrides(customizations)) {
      b.writeln('    required this.overrides,');
    }
    b.writeln('    this._animationProgress,');
    b.writeln('  }) : super(repaint: _animationProgress);');
    b.writeln();

    b.writeln('  final double _fixedProgress;');
    b.writeln('  final double _canvasScaleX;');
    b.writeln('  final double _canvasScaleY;');
    b.writeln('  final Rect _canvasRect;');
    b.writeln('  final Animation<double>? _animationProgress;');
    b.writeln();
    b.writeln('  final bool clip;');
    b.writeln();
    if (_hasOverrides(customizations)) {
      b.writeln('  final $_overridesClassName overrides;');
      b.writeln();
    }
    if (_usesShape<LottieFill>()) {
      b.writeln('  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;');
    }
    if (_usesShape<LottieStroke>()) {
      b.writeln('  final Paint _strokePaint = Paint()..style = PaintingStyle.stroke;');
    }
    b.writeln();

    // ── Keyframe data ──
    _writeKeyframeData(b, curves);

    // ── Path data ──
    _writeGeometryData(b);
    _writePathData(b);
    _writeTextPainterData(b, customizations);

    // ── Keyframe evaluation helpers ──
    _writeEvalHelpers(b, curves);
    if (_usesShape<LottieTrimPath>()) {
      _writeTrimPathHelpers(b);
    }

    // ── Paint method ──
    b.writeln('  @override');
    b.writeln('  void paint(Canvas canvas, Size size) {');
    b.writeln('    final progress = _animationProgress?.value ?? _fixedProgress;');
    final frameExpression = animation.inPoint == 0
        ? 'progress * $className._totalFrames'
        : '${animation.inPoint} + progress * $className._totalFrames';
    final lastVisibleFrame = (animation.outPoint - 0.000001).toString();
    b.writeln('    final frame = math.min($lastVisibleFrame, $frameExpression);');
    b.writeln();
    b.writeln('    canvas.save();');
    b.writeln('    if (clip) canvas.clipRect(_canvasRect);');
    b.writeln('    canvas.scale(_canvasScaleX, _canvasScaleY);');
    b.writeln();

    final rootLayers = _layers
        .where((entry) => entry.compositionId == null && _isRenderableLayer(entry.layer))
        .toList();
    for (var i = rootLayers.length - 1; i >= 0; i--) {
      final entry = rootLayers[i];
      final layer = entry.layer;
      final methodName = _sanitizeMethodName('draw_${layer.name}_${entry.index}');
      b.writeln('    _$methodName(canvas, frame, 1);');
    }

    b.writeln();
    b.writeln('    canvas.restore();');
    b.writeln('  }');
    b.writeln();

    // ── Draw methods per layer ──
    for (final entry in _layers.where((entry) => _isRenderableLayer(entry.layer))) {
      _writeDrawMethod(b, entry, customizations);
    }

    // ── shouldRepaint ──
    b.writeln('  @override');
    b.writeln('  bool shouldRepaint(covariant _$baseName' + 'Painter oldDelegate) {');
    b.writeln('    return oldDelegate._fixedProgress != _fixedProgress');
    b.writeln('        || oldDelegate._canvasScaleX != _canvasScaleX');
    b.writeln('        || oldDelegate._canvasScaleY != _canvasScaleY');
    b.writeln('        || oldDelegate._canvasRect != _canvasRect');
    b.writeln('        || oldDelegate._animationProgress != _animationProgress');
    b.writeln('        || oldDelegate.clip != clip');
    if (_hasOverrides(customizations)) {
      b.writeln('        || oldDelegate.overrides != overrides');
    }

    b.writeln(';');
    b.writeln('  }');
    if (_hasPainterResources(customizations)) {
      b.writeln();
      b.writeln('  void disposeResources() {');
      for (final layerIndex in customizations.textByLayer.keys) {
        b.writeln('    _textPainter$layerIndex?.dispose();');
      }
      b.writeln('  }');
    }
    b.writeln('}');
    b.writeln();
  }

  // ── Keyframe data emission ──

  void _writeKeyframeData(StringBuffer b, List<_CurveEntry> curves) {
    for (final entry in _layers) {
      final i = entry.index;
      final layer = entry.layer;
      final prefix = '_keyframes$i';

      _writeScalarKeyframes(b, '${prefix}Opacity', layer.opacity, curves);
      _writeScalarKeyframes(b, '${prefix}Rotation', layer.rotation, curves);
      _writeScalarKeyframes(b, '${prefix}PositionX', layer.positionX, curves);
      _writeScalarKeyframes(b, '${prefix}PositionY', layer.positionY, curves);
      _writeScalarKeyframes(b, '${prefix}ScaleX', layer.scaleX, curves);
      _writeScalarKeyframes(b, '${prefix}ScaleY', layer.scaleY, curves);
      for (var groupIndex = 0; groupIndex < layer.shapeGroups.length; groupIndex++) {
        final trim = _groupParts(layer.shapeGroups[groupIndex]).trim;
        if (trim == null) continue;
        final trimPrefix = '_keyframes${i}Trim$groupIndex';
        _writeScalarKeyframes(b, '${trimPrefix}Start', trim.start, curves);
        _writeScalarKeyframes(b, '${trimPrefix}End', trim.end, curves);
        _writeScalarKeyframes(b, '${trimPrefix}Offset', trim.offset, curves);
      }
    }
  }

  void _writeScalarKeyframes(StringBuffer b, String name, LottieAnimatedScalar? anim, List<_CurveEntry> curves) {
    if (anim == null || !_hasAnimatedValue(anim)) return;

    final keyframes = _compactScalarKeyframes(anim.keyframes);
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

  List<LottieScalarKeyframe> _compactScalarKeyframes(List<LottieScalarKeyframe> keyframes) {
    if (keyframes.length < 3) return keyframes;

    final compacted = <LottieScalarKeyframe>[keyframes.first];
    for (var index = 1; index < keyframes.length - 1; index++) {
      final previous = compacted.last;
      final current = keyframes[index];
      final next = keyframes[index + 1];
      final previousEnd = previous.end ?? current.start;
      final currentEnd = current.end ?? next.start;
      final previousIsConstant = previous.hold || previousEnd == previous.start;
      final currentIsConstant = current.hold || currentEnd == current.start;
      if (previousIsConstant && currentIsConstant && previous.start == current.start) continue;
      compacted.add(current);
    }
    compacted.add(keyframes.last);
    return compacted;
  }

  // ── Path data emission ──

  void _writeGeometryData(StringBuffer b) {
    for (final entry in _layers) {
      final layerIndex = entry.index;
      final layer = entry.layer;
      for (var groupIndex = 0; groupIndex < layer.shapeGroups.length; groupIndex++) {
        final parts = _groupParts(layer.shapeGroups[groupIndex]);
        final compoundFill = _canUseCompoundFill(fill: parts.fill, shapes: parts.shapes);
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
    for (final entry in _layers) {
      final layerIdx = entry.index;
      final layer = entry.layer;
      for (var groupIdx = 0; groupIdx < layer.shapeGroups.length; groupIdx++) {
        final group = layer.shapeGroups[groupIdx];
        var shapeIndex = 0;
        for (final item in group.items) {
          if (item is LottiePath) {
            _writeSinglePath(b, layerIdx, groupIdx, shapeIndex, item);
          }
          if (item is! LottieFill &&
              item is! LottieStroke &&
              item is! LottieTrimPath &&
              item is! LottieGroupTransform) {
            shapeIndex++;
          }
        }
      }
      for (var maskIndex = 0; maskIndex < layer.masks.length; maskIndex++) {
        _writePathDeclaration(
          b,
          '_maskPath${layerIdx}_$maskIndex',
          layer.masks[maskIndex],
        );
      }
      if (layer.masks.length > 1) {
        var combinedPath = '__maskPath${layerIdx}_0';
        for (var maskIndex = 1; maskIndex < layer.masks.length; maskIndex++) {
          combinedPath = 'Path.combine(PathOperation.union, $combinedPath, __maskPath${layerIdx}_$maskIndex)';
        }
        b.writeln('  static final Path __maskPath$layerIdx = $combinedPath;');
        b.writeln();
      }
    }

    _writeCompoundPathData(b);
  }

  void _writeTextPainterData(
    StringBuffer b,
    _CustomizationPlan customizations,
  ) {
    for (final entry in _layers) {
      final text = entry.layer.text;
      if (text == null) continue;
      final textParam = customizations.textByLayer[entry.index]!;
      final maxLines = text.boxHeight == null ? null : (text.boxHeight! / text.lineHeight).floor().clamp(1, 1000000);
      b.writeln('  TextPainter? _textPainter${entry.index};');
      b.writeln('  Color? _textPainter${entry.index}Color;');
      if (text.boxHeight == null) {
        b.writeln('  Offset _textPainter${entry.index}Offset = Offset.zero;');
      }
      b.writeln();
      b.writeln('  TextSpan _textSpanFor${entry.index}(Color color) {');
      b.writeln('    return TextSpan(');
      b.writeln('      text: overrides.${textParam.name} ?? ${_dartString(text.value)},');
      b.writeln('      style: TextStyle(');
      b.writeln('        color: color,');
      b.writeln('        fontFamily: ${_dartString(text.fontFamily)},');
      b.writeln('        fontSize: ${_fmt(text.fontSize)},');
      b.writeln('        fontWeight: FontWeight.w${text.fontWeight},');
      if (text.italic) {
        b.writeln('        fontStyle: FontStyle.italic,');
      }
      if (text.lineHeight != text.fontSize) {
        b.writeln('        height: ${_fmt(text.lineHeight / text.fontSize)},');
      }
      if (text.tracking != 0) {
        b.writeln('        letterSpacing: ${_fmt(text.tracking / 1000 * text.fontSize)},');
      }
      b.writeln('      ),');
      b.writeln('    );');
      b.writeln('  }');
      b.writeln();
      b.writeln('  TextPainter _textPainterFor${entry.index}(Color color) {');
      b.writeln('    final cached = _textPainter${entry.index};');
      b.writeln('    if (cached != null) {');
      b.writeln('      if (_textPainter${entry.index}Color != color) {');
      b.writeln('        _textPainter${entry.index}Color = color;');
      b.writeln('        cached.text = _textSpanFor${entry.index}(color);');
      b.writeln('      }');
      b.writeln('      return cached;');
      b.writeln('    }');
      b.writeln('    _textPainter${entry.index}Color = color;');
      b.writeln('    final painter = TextPainter(');
      b.writeln('      text: _textSpanFor${entry.index}(color),');
      b.writeln('      textDirection: TextDirection.ltr,');
      b.writeln('      textAlign: ${_textAlign(text.justification)},');
      if (maxLines != null) b.writeln('      maxLines: $maxLines,');
      b.writeln('    )..layout(maxWidth: ${text.boxWidth == null ? 'double.infinity' : _fmt(text.boxWidth!)});');
      if (text.boxHeight == null) {
        b.writeln(
          '    _textPainter${entry.index}Offset = '
          'Offset(0, -painter.computeDistanceToActualBaseline(TextBaseline.alphabetic));',
        );
      }
      b.writeln('    return _textPainter${entry.index} = painter;');
      b.writeln('  }');
      b.writeln();
    }
  }

  void _writeSinglePath(StringBuffer b, int layerIdx, int groupIdx, int itemIdx, LottiePath path) {
    final name = '_path${layerIdx}_${groupIdx}_$itemIdx';
    _writePathDeclaration(b, name, path);
  }

  void _writePathDeclaration(StringBuffer b, String name, LottiePath path) {
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
    for (final entry in _layers) {
      final layerIndex = entry.index;
      final layer = entry.layer;
      for (var groupIndex = 0; groupIndex < layer.shapeGroups.length; groupIndex++) {
        final parts = _groupParts(layer.shapeGroups[groupIndex]);
        final compoundFill = _canUseCompoundFill(fill: parts.fill, shapes: parts.shapes);
        final compoundStroke = _canUseCompoundStroke(fill: parts.fill, stroke: parts.stroke, shapes: parts.shapes);
        if (parts.trim != null) {
          _writeStaticCompoundPath(
            b,
            name: '_trimSourcePath${layerIndex}_$groupIndex',
            shapes: parts.shapes,
            layerIndex: layerIndex,
            groupIndex: groupIndex,
            evenOdd: parts.fill?.fillRule == 2,
          );
          b.writeln(
            '  static final List<PathMetric> _trimMetrics${layerIndex}_$groupIndex = '
            '_trimSourcePath${layerIndex}_$groupIndex.computeMetrics().toList(growable: false);',
          );
          if (parts.trim!.mode == LottieTrimPathMode.sequential) {
            b.writeln(
              '  static final double _trimTotalLength${layerIndex}_$groupIndex = '
              '_trimMetrics${layerIndex}_$groupIndex.fold<double>(0, (total, metric) => total + metric.length);',
            );
          }
          b.writeln();
          continue;
        }
        if (compoundFill) {
          _writeStaticCompoundPath(
            b,
            name: '_compoundFillPath${layerIndex}_$groupIndex',
            shapes: parts.shapes,
            layerIndex: layerIndex,
            groupIndex: groupIndex,
            evenOdd: parts.fill!.fillRule == 2,
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
  }

  void _writeTrimPathHelpers(StringBuffer b) {
    b.writeln('  Path _trimPath(');
    b.writeln('    Path source,');
    b.writeln('    List<PathMetric> metrics,');
    b.writeln('    double totalLength,');
    b.writeln('    double start,');
    b.writeln('    double end,');
    b.writeln('    double offset, {');
    b.writeln('    required bool sequential,');
    b.writeln('  }) {');
    b.writeln('    final lower = math.min(start, end).clamp(0, 100).toDouble() / 100;');
    b.writeln('    final upper = math.max(start, end).clamp(0, 100).toDouble() / 100;');
    b.writeln('    final visibleFraction = upper - lower;');
    b.writeln('    if (visibleFraction <= 0) return Path();');
    b.writeln('    if (visibleFraction >= 1) return source;');
    b.writeln('    final normalizedStart = (lower + offset / 360) % 1;');
    b.writeln('    final normalizedEnd = normalizedStart + visibleFraction;');
    b.writeln('    final result = Path()..fillType = source.fillType;');
    b.writeln('    if (sequential) {');
    b.writeln('      if (totalLength <= 0) return result;');
    b.writeln(
      '      _appendTrimRange(result, metrics, normalizedStart * totalLength, math.min(1, normalizedEnd) * totalLength);',
    );
    b.writeln('      if (normalizedEnd > 1) {');
    b.writeln('        _appendTrimRange(result, metrics, 0, (normalizedEnd - 1) * totalLength);');
    b.writeln('      }');
    b.writeln('      return result;');
    b.writeln('    }');
    b.writeln('    for (final metric in metrics) {');
    b.writeln('      result.addPath(');
    b.writeln(
      '        metric.extractPath(normalizedStart * metric.length, math.min(1, normalizedEnd) * metric.length),',
    );
    b.writeln('        Offset.zero,');
    b.writeln('      );');
    b.writeln('      if (normalizedEnd > 1) {');
    b.writeln('        result.addPath(metric.extractPath(0, (normalizedEnd - 1) * metric.length), Offset.zero);');
    b.writeln('      }');
    b.writeln('    }');
    b.writeln('    return result;');
    b.writeln('  }');
    b.writeln();
    b.writeln('  void _appendTrimRange(');
    b.writeln('    Path destination,');
    b.writeln('    List<PathMetric> metrics,');
    b.writeln('    double start,');
    b.writeln('    double end,');
    b.writeln('  ) {');
    b.writeln('    var metricStart = 0.0;');
    b.writeln('    for (final metric in metrics) {');
    b.writeln('      final metricEnd = metricStart + metric.length;');
    b.writeln('      final overlapStart = math.max(start, metricStart);');
    b.writeln('      final overlapEnd = math.min(end, metricEnd);');
    b.writeln('      if (overlapStart < overlapEnd) {');
    b.writeln('        destination.addPath(');
    b.writeln('          metric.extractPath(overlapStart - metricStart, overlapEnd - metricStart),');
    b.writeln('          Offset.zero,');
    b.writeln('        );');
    b.writeln('      }');
    b.writeln('      metricStart = metricEnd;');
    b.writeln('    }');
    b.writeln('  }');
    b.writeln();
  }

  // ── Draw method per layer ──

  void _writeDrawMethod(
    StringBuffer b,
    _LayerEntry entry,
    _CustomizationPlan customizations,
  ) {
    final layer = entry.layer;
    final index = entry.index;
    final parents = _parentEntries(entry);
    final methodName = _sanitizeMethodName('draw_${layer.name}_$index');
    b.writeln('  void _$methodName(Canvas canvas, double frame, double inheritedOpacity) {');
    if (layer.outPoint > layer.inPoint && !_hasCoveringParentVisibilityGuard(entry)) {
      b.writeln('    if (frame < ${layer.inPoint} || frame >= ${layer.outPoint}) return;');
    }

    // Evaluate animated properties
    final hasOpacity = _hasAnimatedValue(layer.opacity);
    final hasRotation = _hasAnimatedValue(layer.rotation);
    final hasPosX = _hasAnimatedValue(layer.positionX);
    final hasPosY = _hasAnimatedValue(layer.positionY);
    final hasScaleX = _hasAnimatedValue(layer.scaleX);
    final hasScaleY = _hasAnimatedValue(layer.scaleY);

    final staticOpacity = _fmt(_staticScalarValue(layer.opacity, fallback: 100) / 100);
    if (hasOpacity) {
      b.writeln('    final layerOpacity = inheritedOpacity * _keyframes${index}Opacity(frame) / 100;');
    } else {
      b.writeln('    final layerOpacity = inheritedOpacity * $staticOpacity;');
    }
    b.writeln('    if (layerOpacity <= 0) return;');

    if (hasRotation) {
      b.writeln('    final rotation = _keyframes${index}Rotation(frame);');
    }
    if (hasPosX) {
      b.writeln('    final posX = _keyframes${index}PositionX(frame);');
    }
    if (hasPosY) {
      b.writeln('    final posY = _keyframes${index}PositionY(frame);');
    }
    if (hasScaleX) {
      b.writeln('    final scaleX = _keyframes${index}ScaleX(frame) / 100;');
    }
    if (hasScaleY) {
      b.writeln('    final scaleY = _keyframes${index}ScaleY(frame) / 100;');
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
    final needsRestore = parents.isNotEmpty || hasTransform || layer.masks.isNotEmpty || layer.referenceId != null;
    if (needsRestore) {
      b.writeln('    canvas.save();');
    }
    for (final parent in parents) {
      _writeParentTransform(b, parent);
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

    if (layer.masks.isNotEmpty) {
      final maskPath = layer.masks.length == 1 ? '__maskPath${index}_0' : '__maskPath$index';
      b.writeln('    canvas.clipPath($maskPath);');
    }

    final referenceId = layer.referenceId;
    if (referenceId != null) {
      final composition = animation.compositions[referenceId]!;
      b.writeln(
        '    canvas.clipRect(const Rect.fromLTWH(0, 0, ${composition.width}, ${composition.height}));',
      );
      final childFrame = layer.startTime == 0 && layer.stretch == 1
          ? 'frame'
          : '(frame - ${_fmt(layer.startTime)}) / ${_fmt(layer.stretch)}';
      final children = _layers
          .where((child) => child.compositionId == referenceId && _isRenderableLayer(child.layer))
          .toList();
      for (var childIndex = children.length - 1; childIndex >= 0; childIndex--) {
        final child = children[childIndex];
        final childMethod = _sanitizeMethodName('draw_${child.layer.name}_${child.index}');
        b.writeln('    _$childMethod(canvas, $childFrame, layerOpacity);');
      }
    } else if (layer.text != null) {
      _writeDrawText(b, entry, customizations);
    }

    _writeShapeGroups(b, layer, index, customizations);

    if (needsRestore) {
      b.writeln('    canvas.restore();');
    }
    b.writeln('  }');
    b.writeln();
  }

  void _writeShapeGroups(
    StringBuffer b,
    LottieLayer layer,
    int layerIndex,
    _CustomizationPlan customizations,
  ) {
    for (var groupIndex = layer.shapeGroups.length - 1; groupIndex >= 0; groupIndex--) {
      _writeDrawGroup(
        b,
        layer.shapeGroups[groupIndex],
        layerIndex,
        groupIndex,
        customizations,
      );
    }
  }

  void _writeParentTransform(StringBuffer b, _LayerEntry entry) {
    final layer = entry.layer;
    final index = entry.index;
    final positionX = _hasAnimatedValue(layer.positionX)
        ? '_keyframes${index}PositionX(frame)'
        : _staticOrZero(layer.positionX);
    final positionY = _hasAnimatedValue(layer.positionY)
        ? '_keyframes${index}PositionY(frame)'
        : _staticOrZero(layer.positionY);
    final rotation = _hasAnimatedValue(layer.rotation)
        ? '_keyframes${index}Rotation(frame)'
        : _fmt(_staticScalarValue(layer.rotation, fallback: 0));
    final scaleX = _hasAnimatedValue(layer.scaleX)
        ? '_keyframes${index}ScaleX(frame) / 100'
        : _staticScaleOrOne(layer.scaleX);
    final scaleY = _hasAnimatedValue(layer.scaleY)
        ? '_keyframes${index}ScaleY(frame) / 100'
        : _staticScaleOrOne(layer.scaleY);
    final hasTranslation = positionX != '0' || positionY != '0';
    final hasRotation = rotation != '0';
    final hasScale = scaleX != '1' || scaleY != '1';
    final hasAnchor = (layer.anchorX ?? 0) != 0 || (layer.anchorY ?? 0) != 0;

    b.writeln('    // Parent transform: ${_dartDocText(layer.name)}');
    if (hasTranslation) b.writeln('    canvas.translate($positionX, $positionY);');
    if (hasRotation) b.writeln('    canvas.rotate($rotation * math.pi / 180);');
    if (hasScale) b.writeln('    canvas.scale($scaleX, $scaleY);');
    if (hasAnchor) {
      b.writeln('    canvas.translate(${_fmt(-(layer.anchorX ?? 0))}, ${_fmt(-(layer.anchorY ?? 0))});');
    }
  }

  void _writeDrawText(
    StringBuffer b,
    _LayerEntry entry,
    _CustomizationPlan customizations,
  ) {
    final text = entry.layer.text!;
    final color = customizations.colorByTextLayer[entry.index]!;
    final defaultColor = _colorToHex(text.colorR, text.colorG, text.colorB, text.colorA);
    b.writeln(
      '    final textColor = _dotdartApplyOpacity(overrides.${color.name} ?? const Color($defaultColor), layerOpacity);',
    );
    b.writeln('    final textPainter = _textPainterFor${entry.index}(textColor);');
    if (text.boxWidth != null && text.boxHeight != null) {
      b.writeln('    canvas.save();');
      b.writeln(
        '    canvas.clipRect(const Rect.fromLTWH(0, 0, ${_fmt(text.boxWidth!)}, ${_fmt(text.boxHeight!)}));',
      );
      b.writeln('    textPainter.paint(canvas, Offset.zero);');
      b.writeln('    canvas.restore();');
      return;
    }
    b.writeln('    textPainter.paint(canvas, _textPainter${entry.index}Offset);');
  }

  void _writeDrawGroup(
    StringBuffer b,
    LottieGroup group,
    int layerIndex,
    int groupIndex,
    _CustomizationPlan customizations,
  ) {
    final parts = _groupParts(group);
    final fill = parts.fill;
    final stroke = parts.stroke;
    final trim = parts.trim;
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
    if (trim != null) {
      _writeDrawTrimmedGroup(
        b,
        layerIndex: layerIndex,
        groupIndex: groupIndex,
        fill: fill,
        stroke: stroke,
        trim: trim,
        customizations: customizations,
        groupOpacity: groupOpacity,
      );
      if (hasTransform) {
        b.writeln('    canvas.restore();');
      }
      return;
    }
    final compoundFill = _canUseCompoundFill(fill: fill, shapes: shapes);
    final compoundStroke = _canUseCompoundStroke(fill: fill, stroke: stroke, shapes: shapes);
    if (compoundFill) {
      _writeDrawCompoundFillPath(b, layerIndex, groupIndex, fill!, customizations, groupOpacity);
    }
    if (compoundStroke) {
      _writeDrawCompoundStrokePath(b, layerIndex, groupIndex, stroke!, customizations, groupOpacity);
    }

    for (var shapeIndex = 0; shapeIndex < shapes.length; shapeIndex++) {
      final shape = shapes[shapeIndex];
      final shapeFill = compoundFill ? null : fill;
      final shapeStroke = compoundStroke ? null : stroke;
      if (shape is LottieRect) {
        _writeDrawRect(b, layerIndex, groupIndex, shapeIndex, shapeFill, shapeStroke, customizations, groupOpacity);
      } else if (shape is LottieEllipse) {
        _writeDrawEllipse(b, layerIndex, groupIndex, shapeIndex, shapeFill, shapeStroke, customizations, groupOpacity);
      } else if (shape is LottiePath) {
        _writeDrawPath(b, layerIndex, groupIndex, shapeIndex, shapeFill, shapeStroke, customizations, groupOpacity);
      }
    }

    if (hasTransform) {
      b.writeln('    canvas.restore();');
    }
  }

  ({
    LottieFill? fill,
    LottieStroke? stroke,
    LottieTrimPath? trim,
    LottieGroupTransform? transform,
    List<LottieShape> shapes,
  })
  _groupParts(
    LottieGroup group,
  ) {
    LottieFill? fill;
    LottieStroke? stroke;
    LottieTrimPath? trim;
    LottieGroupTransform? transform;
    final shapes = <LottieShape>[];

    for (final item in group.items) {
      if (item is LottieFill) {
        fill = item;
      } else if (item is LottieStroke) {
        stroke = item;
      } else if (item is LottieTrimPath) {
        trim = item;
      } else if (item is LottieGroupTransform) {
        transform = item;
      } else {
        shapes.add(item);
      }
    }

    return (fill: fill, stroke: stroke, trim: trim, transform: transform, shapes: shapes);
  }

  bool _canUseCompoundStroke({
    required LottieFill? fill,
    required LottieStroke? stroke,
    required List<LottieShape> shapes,
  }) {
    return fill == null && stroke != null && shapes.length > 1 && shapes.every((shape) => shape is LottiePath);
  }

  void _writeDrawTrimmedGroup(
    StringBuffer b, {
    required int layerIndex,
    required int groupIndex,
    required LottieFill? fill,
    required LottieStroke? stroke,
    required LottieTrimPath trim,
    required _CustomizationPlan customizations,
    required double groupOpacity,
  }) {
    if (fill == null && stroke == null) return;

    final trimPrefix = '_keyframes${layerIndex}Trim$groupIndex';
    final start = _hasAnimatedValue(trim.start)
        ? '${trimPrefix}Start(frame)'
        : _fmt(_staticScalarValue(trim.start, fallback: 0));
    final end = _hasAnimatedValue(trim.end)
        ? '${trimPrefix}End(frame)'
        : _fmt(_staticScalarValue(trim.end, fallback: 100));
    final offset = _hasAnimatedValue(trim.offset)
        ? '${trimPrefix}Offset(frame)'
        : _fmt(_staticScalarValue(trim.offset, fallback: 0));
    final sequential = switch (trim.mode) {
      LottieTrimPathMode.parallel => 'false',
      LottieTrimPathMode.sequential => 'true',
    };
    final suffix = '${layerIndex}_$groupIndex';
    final totalLength = switch (trim.mode) {
      LottieTrimPathMode.parallel => '0',
      LottieTrimPathMode.sequential => '_trimTotalLength$suffix',
    };
    final pathName = 'trimmedPath$suffix';
    b.write('    final $pathName = _trimPath(');
    b.writeln(
      '_trimSourcePath$suffix, _trimMetrics$suffix, $totalLength, $start, $end, $offset, '
      'sequential: $sequential);',
    );

    if (fill != null) {
      final opacity = _fmt(fill.opacity / 100 * groupOpacity);
      final colorRef = _colorReference(fill, customizations, 'layerOpacity * $opacity');
      b
        ..writeln('    final trimFillPaint$suffix = _fillPaint..color = $colorRef;')
        ..writeln('    canvas.drawPath($pathName, trimFillPaint$suffix);');
    }
    if (stroke != null) {
      final cap = _lineCap(stroke.lineCap);
      final join = _lineJoin(stroke.lineJoin);
      final opacity = _fmt(stroke.opacity / 100 * groupOpacity);
      final colorRef = _colorReference(stroke, customizations, 'layerOpacity * $opacity');
      b
        ..writeln(
          '    final trimStrokePaint$suffix = _strokePaint..color = $colorRef'
          '..strokeWidth = ${_fmt(stroke.width)}..strokeCap = $cap..strokeJoin = $join;',
        )
        ..writeln('    canvas.drawPath($pathName, trimStrokePaint$suffix);');
    }
  }

  bool _canUseCompoundFill({required LottieFill? fill, required List<LottieShape> shapes}) {
    return fill != null && shapes.isNotEmpty && (fill.fillRule == 2 || shapes.length > 1);
  }

  void _writeDrawCompoundFillPath(
    StringBuffer b,
    int layerIndex,
    int groupIndex,
    LottieFill fill,
    _CustomizationPlan customizations,
    double groupOpacity,
  ) {
    final pathName = '_compoundFillPath${layerIndex}_$groupIndex';
    final paintName = 'compoundFillPaint$groupIndex';
    final opacity = _fmt(fill.opacity / 100 * groupOpacity);
    final colorRef = _colorReference(fill, customizations, 'layerOpacity * $opacity');

    b.writeln('    final $paintName = _fillPaint..color = $colorRef;');

    b.writeln('    canvas.drawPath($pathName, $paintName);');
  }

  void _writeDrawCompoundStrokePath(
    StringBuffer b,
    int layerIndex,
    int groupIndex,
    LottieStroke stroke,
    _CustomizationPlan customizations,
    double groupOpacity,
  ) {
    final pathName = '_compoundStrokePath${layerIndex}_$groupIndex';
    final paintName = 'compoundStrokePaint$groupIndex';
    final cap = _lineCap(stroke.lineCap);
    final join = _lineJoin(stroke.lineJoin);
    final opacity = _fmt(stroke.opacity / 100 * groupOpacity);
    final colorRef = _colorReference(stroke, customizations, 'layerOpacity * $opacity');

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
    _CustomizationPlan customizations,
    double groupOpacity,
  ) {
    if (fill == null && stroke == null) return;

    final suffix = '${groupIndex}_$shapeIndex';
    final bodyName = '_rrect${layerIndex}_${groupIndex}_$shapeIndex';
    final fillPaintName = 'fillPaint$suffix';
    final strokePaintName = 'strokePaint$suffix';

    if (fill != null) {
      final opacity = _fmt(fill.opacity / 100 * groupOpacity);
      final colorRef = _colorReference(fill, customizations, 'layerOpacity * $opacity');
      b
        ..writeln('    final $fillPaintName = _fillPaint..color = $colorRef;')
        ..writeln('    canvas.drawRRect($bodyName, $fillPaintName);');
    }

    if (stroke != null) {
      final cap = _lineCap(stroke.lineCap);
      final join = _lineJoin(stroke.lineJoin);
      final opacity = _fmt(stroke.opacity / 100 * groupOpacity);
      final colorRef = _colorReference(stroke, customizations, 'layerOpacity * $opacity');
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
    _CustomizationPlan customizations,
    double groupOpacity,
  ) {
    if (fill == null && stroke == null) return;

    final suffix = '${groupIndex}_$shapeIndex';
    final rectName = '_ellipseRect${layerIndex}_${groupIndex}_$shapeIndex';
    final fillPaintName = 'fillPaint$suffix';
    final strokePaintName = 'strokePaint$suffix';
    if (fill != null) {
      final opacity = _fmt(fill.opacity / 100 * groupOpacity);
      final colorRef = _colorReference(fill, customizations, 'layerOpacity * $opacity');
      b
        ..writeln('    final $fillPaintName = _fillPaint..color = $colorRef;')
        ..writeln('    canvas.drawOval($rectName, $fillPaintName);');
    }

    if (stroke != null) {
      final cap = _lineCap(stroke.lineCap);
      final join = _lineJoin(stroke.lineJoin);
      final opacity = _fmt(stroke.opacity / 100 * groupOpacity);
      final colorRef = _colorReference(stroke, customizations, 'layerOpacity * $opacity');
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
    _CustomizationPlan customizations,
    double groupOpacity,
  ) {
    if (fill == null && stroke == null) return;

    final suffix = '${groupIndex}_$shapeIndex';
    final pathName = '_path${layerIndex}_${groupIndex}_$shapeIndex';
    final fillPaintName = 'fillPaint$suffix';
    final strokePaintName = 'strokePaint$suffix';
    final evenOddPathName = 'path$suffix';

    if (fill != null) {
      final opacity = _fmt(fill.opacity / 100 * groupOpacity);
      final colorRef = _colorReference(fill, customizations, 'layerOpacity * $opacity');
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
      final cap = _lineCap(stroke.lineCap);
      final join = _lineJoin(stroke.lineJoin);
      final opacity = _fmt(stroke.opacity / 100 * groupOpacity);
      final colorRef = _colorReference(stroke, customizations, 'layerOpacity * $opacity');
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
    final center = positionX == 0 && positionY == 0
        ? 'Offset.zero'
        : 'const Offset(${_fmt(positionX)}, ${_fmt(positionY)})';
    return 'Rect.fromCenter(center: $center, '
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

  String _colorReference(
    LottieShape shape,
    _CustomizationPlan customizations,
    String opacity,
  ) {
    final color = customizations.colorByShape[shape]!;
    final (r, g, b, a) = switch (shape) {
      LottieFill() => (shape.colorR, shape.colorG, shape.colorB, shape.colorA),
      LottieStroke() => (shape.colorR, shape.colorG, shape.colorB, shape.colorA),
      _ => throw StateError('Only Lottie fills and strokes have customizable colors.'),
    };
    final defaultColor = _colorToHex(r, g, b, a);
    return '_dotdartApplyOpacity(overrides.${color.name} ?? const Color($defaultColor), $opacity)';
  }

  String _textAlign(int justification) {
    switch (justification) {
      case 0:
        return 'TextAlign.left';
      case 1:
        return 'TextAlign.right';
      case 2:
        return 'TextAlign.center';
      default:
        return 'TextAlign.left';
    }
  }

  String _dartString(String value) {
    final hasSourceLineBreak = value.runes.any(
      (rune) => rune == 0x0a || rune == 0x0d || rune == 0x2028 || rune == 0x2029,
    );
    if (value.contains(r'$') && !value.contains("'") && !hasSourceLineBreak) {
      return "r'$value'";
    }
    if (value.contains(r'$') && !value.contains('"') && !hasSourceLineBreak) {
      return 'r"$value"';
    }
    final escaped = StringBuffer("'");
    for (final rune in value.runes) {
      if (rune == 0x5c) {
        escaped.write(r'\\');
      } else if (rune == 0x27) {
        escaped.write(r"\'");
      } else if (rune == 0x24) {
        escaped.write(r'\$');
      } else if (rune < 0x20 || rune == 0x7f || rune == 0x2028 || rune == 0x2029) {
        if (rune <= 0xffff) {
          escaped.write('\\u${rune.toRadixString(16).padLeft(4, '0')}');
        } else {
          escaped.write('\\u{${rune.toRadixString(16)}}');
        }
      } else {
        escaped.writeCharCode(rune);
      }
    }
    escaped.write("'");
    return escaped.toString();
  }

  String _dartDocText(String value) {
    return value.replaceAll(RegExp(r'\s+'), ' ').replaceAll('`', r'\`').trim();
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
    final words = name.split(RegExp('[^A-Za-z0-9]+')).where((word) => word.isNotEmpty).toList();
    if (words.isEmpty) return 'drawLayer';
    return words.first.toLowerCase() +
        words.skip(1).map((word) => '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}').join();
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

  bool _isRenderableLayer(LottieLayer layer) {
    if (layer.referenceId != null || layer.text != null) return true;
    for (final group in layer.shapeGroups) {
      final parts = _groupParts(group);
      if (parts.transform != null && parts.transform!.opacity <= 0) continue;
      if (parts.shapes.isNotEmpty && (parts.fill != null || parts.stroke != null)) return true;
    }
    return false;
  }

  bool _hasCoveringParentVisibilityGuard(_LayerEntry entry) {
    final layer = entry.layer;
    if (entry.compositionId == null) {
      return layer.inPoint == animation.inPoint && layer.outPoint == animation.outPoint;
    }

    final references = _layers.where((candidate) => candidate.layer.referenceId == entry.compositionId).toList();
    if (references.isEmpty) return false;
    for (final reference in references) {
      final referenceLayer = reference.layer;
      if (referenceLayer.outPoint <= referenceLayer.inPoint || referenceLayer.stretch <= 0) return false;
      final firstChildFrame = (referenceLayer.inPoint - referenceLayer.startTime) / referenceLayer.stretch;
      final lastChildFrame = (referenceLayer.outPoint - referenceLayer.startTime) / referenceLayer.stretch;
      if (layer.inPoint > firstChildFrame || layer.outPoint < lastChildFrame) return false;
    }
    return true;
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

typedef _LayerEntry = ({int index, LottieLayer layer, String? compositionId});
typedef _TextParam = ({String name, String layerName});
typedef _ColorParam = ({String name, String layerName});
typedef _CustomizationPlan = ({
  List<_TextParam> textParams,
  List<_ColorParam> colorParams,
  Map<int, _TextParam> textByLayer,
  Map<LottieShape, _ColorParam> colorByShape,
  Map<int, _ColorParam> colorByTextLayer,
});
typedef _CurveEntry = ({int index, double outX, double outY, double inX, double inY});

const _dartReservedWords = {
  'abstract',
  'as',
  'assert',
  'async',
  'await',
  'base',
  'break',
  'case',
  'catch',
  'class',
  'const',
  'continue',
  'covariant',
  'default',
  'deferred',
  'do',
  'dynamic',
  'else',
  'enum',
  'export',
  'extends',
  'extension',
  'external',
  'factory',
  'false',
  'final',
  'finally',
  'for',
  'function',
  'get',
  'hide',
  'if',
  'implements',
  'import',
  'in',
  'interface',
  'is',
  'late',
  'library',
  'mixin',
  'new',
  'null',
  'of',
  'on',
  'operator',
  'part',
  'required',
  'rethrow',
  'return',
  'sealed',
  'set',
  'show',
  'static',
  'super',
  'switch',
  'sync',
  'this',
  'throw',
  'true',
  'try',
  'typedef',
  'var',
  'void',
  'when',
  'while',
  'with',
  'yield',
};
