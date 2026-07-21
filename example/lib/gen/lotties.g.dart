// GENERATED CODE - DO NOT MODIFY BY HAND
// *****************************************************
//  dotdart
// *****************************************************

// coverage:ignore-file
// Generated canvas and paint sequences intentionally use repeated receiver calls.
// ignore_for_file: cascade_invocations, unused_element, unused_element_parameter

import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show OverflowBoxFit;

Color _dotdartApplyOpacity(Color color, double opacity) {
  if (opacity == 1) return color;
  return color.withValues(alpha: math.min(1, math.max(0, color.a * opacity)));
}

mixin _DotdartLottieAnimationState<T extends StatefulWidget>
    on State<T>, SingleTickerProviderStateMixin<T>, WidgetsBindingObserver {
  double? get lottieWidgetWidth;
  double? get lottieWidgetHeight;
  double? get lottieProgress;
  bool get lottieRespectDisableAnimations;
  bool get lottieMaintainAspectRatio;
  Duration get lottieLoopDuration;
  double get lottieCanvasWidth;
  double get lottieCanvasHeight;

  Widget buildPainter({required double width, required double height});

  late final AnimationController _controller;
  bool _canAnimateForLifecycle = true;

  bool _shouldAnimate() {
    final disableAnimations =
        lottieRespectDisableAnimations &&
        (MediaQuery.maybeDisableAnimationsOf(context) ?? false);
    return lottieProgress == null &&
        _canAnimateForLifecycle &&
        !disableAnimations;
  }

  void _syncController() {
    if (_shouldAnimate()) {
      if (!_controller.isAnimating) unawaited(_controller.repeat());
      return;
    }
    _controller.stop();
  }

  Size _defaultSizeFor(BoxConstraints constraints) {
    final aspect = lottieCanvasHeight / lottieCanvasWidth;
    var w = lottieCanvasWidth;
    if (constraints.hasBoundedWidth) {
      w = math.min(w, constraints.maxWidth);
    }
    if (constraints.hasBoundedHeight) {
      w = math.min(w, constraints.maxHeight / aspect);
    }
    return Size(w, w * aspect);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: lottieLoopDuration,
    );
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncController();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncController();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _canAnimateForLifecycle = state == AppLifecycleState.resumed;
    _syncController();
  }

  Size _resolveSize(double aspect) {
    if (lottieWidgetWidth != null && lottieWidgetHeight != null) {
      if (!lottieMaintainAspectRatio) {
        return Size(lottieWidgetWidth!, lottieWidgetHeight!);
      }
      return lottieWidgetWidth! >= lottieWidgetHeight!
          ? Size(lottieWidgetWidth!, lottieWidgetWidth! * aspect)
          : Size(lottieWidgetHeight! / aspect, lottieWidgetHeight!);
    }

    final w = lottieWidgetWidth ?? lottieWidgetHeight! / aspect;
    return Size(w, lottieWidgetHeight ?? w * aspect);
  }

  @override
  Widget build(BuildContext context) {
    final hasExplicitSize =
        lottieWidgetWidth != null || lottieWidgetHeight != null;

    if (!hasExplicitSize) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final size = _defaultSizeFor(constraints);
          return buildPainter(width: size.width, height: size.height);
        },
      );
    }

    final aspect = lottieCanvasHeight / lottieCanvasWidth;
    final size = _resolveSize(aspect);

    return OverflowBox(
      alignment: Alignment.topLeft,
      fit: OverflowBoxFit.deferToChild,
      minWidth: size.width,
      maxWidth: size.width,
      minHeight: size.height,
      maxHeight: size.height,
      child: buildPainter(width: size.width, height: size.height),
    );
  }
}

/// Namespace for dotdart-generated widgets from `lotties/`.
///
/// Call a method named after each asset to render it:
///
/// ```dart
/// $Lotties.pulse(<params>);
/// ```
abstract final class $Lotties {
  $Lotties._();

  /// Builds the `Pulse` widget from `pulse.json`.
  static Widget pulse({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    double? progress,
    bool respectDisableAnimations = true,
    Color? color1,
  }) => _Pulse(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    progress: progress,
    respectDisableAnimations: respectDisableAnimations,
    color1: color1,
  );
}

/// A dotdart-generated animated widget from `assets/lotties/pulse.json`.
///
/// Renders a 1000ms looping animation
/// (30 frames at 30.0Hz)
/// on a 100×100 canvas.
/// No Lottie runtime dependency — the animation is drawn
/// entirely via [CustomPainter].
class _Pulse extends StatefulWidget {
  const _Pulse({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.progress,
    this.respectDisableAnimations = true,
    this.color1,
  });

  static const double _lottieWidth = 100;
  static const double _lottieHeight = 100;
  static const int _totalFrames = 30;
  static const Duration _loopDuration = Duration(milliseconds: 1000);

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Fixed animation progress from 0 to 1.
  final double? progress;

  /// Whether reduced-motion settings pause playback.
  final bool respectDisableAnimations;

  /// Color 1 — defaults to 0xffff4a4a.
  final Color? color1;

  @override
  State<_Pulse> createState() => _PulseState();
}

class _PulseState extends State<_Pulse>
    with
        SingleTickerProviderStateMixin,
        WidgetsBindingObserver,
        _DotdartLottieAnimationState<_Pulse> {
  @override
  double? get lottieWidgetWidth => widget.width;

  @override
  double? get lottieWidgetHeight => widget.height;

  @override
  bool get lottieMaintainAspectRatio => widget.maintainAspectRatio;

  @override
  double? get lottieProgress => widget.progress;

  @override
  bool get lottieRespectDisableAnimations => widget.respectDisableAnimations;

  @override
  Duration get lottieLoopDuration => _Pulse._loopDuration;

  @override
  double get lottieCanvasWidth => _Pulse._lottieWidth;

  @override
  double get lottieCanvasHeight => _Pulse._lottieHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _PulsePainter(
            animationProgress: _shouldAnimate() ? _controller : null,
            fixedProgress: (widget.progress ?? 0).clamp(0, 1).toDouble(),
            color1: widget.color1 ?? const Color(0xffff4a4a),
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _PulsePainter extends CustomPainter {
  _PulsePainter({
    required this._fixedProgress,
    required this.color1,
    this._animationProgress,
  }) : super(repaint: _animationProgress);

  final double _fixedProgress;
  final Animation<double>? _animationProgress;

  final Color color1;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;

  double _keyframes0Opacity(double frame) {
    if (frame <= 0) return 55;
    if (frame >= 30) return 55;
    if (frame < 15) {
      final t = frame / 15;
      final eased = _transformCurve0(t);
      return 55 + 45 * eased;
    }
    if (frame < 30) {
      final t = (frame - 15) / 15;
      final eased = _transformCurve0(t);
      return 100 + -45 * eased;
    }
    return 55;
  }

  double _keyframes0ScaleX(double frame) {
    if (frame <= 0) return 75;
    if (frame >= 30) return 75;
    if (frame < 15) {
      final t = frame / 15;
      final eased = _transformCurve0(t);
      return 75 + 35 * eased;
    }
    if (frame < 30) {
      final t = (frame - 15) / 15;
      final eased = _transformCurve0(t);
      return 110 + -35 * eased;
    }
    return 75;
  }

  double _keyframes0ScaleY(double frame) {
    if (frame <= 0) return 75;
    if (frame >= 30) return 75;
    if (frame < 15) {
      final t = frame / 15;
      final eased = _transformCurve0(t);
      return 75 + 35 * eased;
    }
    if (frame < 30) {
      final t = (frame - 15) / 15;
      final eased = _transformCurve0(t);
      return 110 + -35 * eased;
    }
    return 75;
  }

  static final RRect _rrect0_0_0 = RRect.fromRectAndRadius(
    Rect.fromCenter(center: const Offset(50, 50), width: 50, height: 50),
    const Radius.circular(8),
  );

  double _curve0T = double.nan;
  double _curve0Value = 0;

  double _transformCurve0(double t) {
    if (t == _curve0T) return _curve0Value;
    _curve0T = t;
    return _curve0Value = const Cubic(0.42, 0, 0.58, 1).transform(t);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final progress = _animationProgress?.value ?? _fixedProgress;
    final frame = progress * _Pulse._totalFrames;
    final scaleX = size.width / _Pulse._lottieWidth;
    final scaleY = size.height / _Pulse._lottieHeight;

    canvas
      ..save()
      ..scale(scaleX, scaleY);

    _drawFixture0(canvas, frame);

    canvas.restore();
  }

  void _drawFixture0(Canvas canvas, double frame) {
    final layerOpacity = _keyframes0Opacity(frame) / 100;
    if (layerOpacity <= 0) return;
    final scaleX = _keyframes0ScaleX(frame) / 100;
    final scaleY = _keyframes0ScaleY(frame) / 100;
    canvas.save();
    canvas.translate(50, 50);
    canvas.scale(scaleX, scaleY);
    canvas.translate(-50, -50);
    // Group: shape
    final fillPaint0_0 = _fillPaint
      ..color = _dotdartApplyOpacity(color1, layerOpacity * 1);
    canvas.drawRRect(_rrect0_0_0, fillPaint0_0);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PulsePainter oldDelegate) {
    return oldDelegate._fixedProgress != _fixedProgress ||
        oldDelegate._animationProgress != _animationProgress ||
        oldDelegate.color1 != color1;
  }
}
