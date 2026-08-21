// GENERATED CODE - DO NOT MODIFY BY HAND
// *****************************************************
//  dotdart
// *****************************************************

// coverage:ignore-file
// Generated canvas and paint sequences intentionally use repeated receiver calls.
// ignore_for_file: cascade_invocations, unused_element, unused_element_parameter

import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show PathMetric;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show OverflowBoxFit;
import 'dotdart.g.dart' show LottiePlayback;
export 'dotdart.g.dart' show LottiePlayback;

Color _dotdartApplyOpacity(Color color, double opacity) {
  if (opacity == 1) return color;
  return color.withValues(alpha: math.min(1, math.max(0, color.a * opacity)));
}

mixin _DotdartLottieAnimationState<T extends StatefulWidget>
    on State<T>, SingleTickerProviderStateMixin<T>, WidgetsBindingObserver {
  double? get lottieWidgetWidth;
  double? get lottieWidgetHeight;
  double? get lottieProgress;
  Duration get lottieDelay;
  Duration? get lottieDuration;
  LottiePlayback get lottiePlayback;
  bool get lottieRespectDisableAnimations;
  bool get lottieMaintainAspectRatio;
  Duration get lottieNativeDuration;
  double get lottieCanvasWidth;
  double get lottieCanvasHeight;

  Widget buildPainter({required double width, required double height});

  late final AnimationController _controller;
  Timer? _delayTimer;
  Duration? _scheduledDelay;
  Duration? _activeDuration;
  LottiePlayback? _activePlayback;
  bool _hasCompletedInitialDelay = false;
  bool _canAnimateForLifecycle = true;

  bool _shouldAnimate() {
    final disableAnimations =
        lottieRespectDisableAnimations &&
        (MediaQuery.maybeDisableAnimationsOf(context) ?? false);
    return lottieProgress == null &&
        _canAnimateForLifecycle &&
        !disableAnimations;
  }

  void _validateTiming() {
    if (lottieDelay.isNegative) {
      throw ArgumentError.value(lottieDelay, 'delay', 'must not be negative');
    }
    if (lottieDuration != null && lottieDuration! <= Duration.zero) {
      throw ArgumentError.value(
        lottieDuration,
        'duration',
        'must be greater than zero',
      );
    }
  }

  void _startPlayback() {
    final duration = lottieDuration ?? lottieNativeDuration;
    if (_controller.isAnimating &&
        _activeDuration == duration &&
        _activePlayback == lottiePlayback) {
      return;
    }
    _controller.stop();
    _controller.duration = duration;
    _activeDuration = duration;
    _activePlayback = lottiePlayback;
    switch (lottiePlayback) {
      case LottiePlayback.once:
        unawaited(_controller.forward());
      case LottiePlayback.loop:
        unawaited(_controller.repeat());
    }
  }

  void _syncController() {
    _validateTiming();
    if (!_shouldAnimate()) {
      _delayTimer?.cancel();
      _delayTimer = null;
      _scheduledDelay = null;
      _controller.stop();
      return;
    }

    if (_hasCompletedInitialDelay || lottieDelay == Duration.zero) {
      _hasCompletedInitialDelay = true;
      _delayTimer?.cancel();
      _delayTimer = null;
      _scheduledDelay = null;
      _startPlayback();
      return;
    }

    if ((_delayTimer?.isActive ?? false) && _scheduledDelay == lottieDelay) {
      return;
    }
    _delayTimer?.cancel();
    _scheduledDelay = lottieDelay;
    _delayTimer = Timer(lottieDelay, () {
      _delayTimer = null;
      _scheduledDelay = null;
      if (!_shouldAnimate()) return;
      _hasCompletedInitialDelay = true;
      _startPlayback();
    });
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
      duration: lottieNativeDuration,
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
    _delayTimer?.cancel();
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
/// $Lotties.cataquiJobCardsCarousel(<params>);
/// ```
/// ```dart
/// $Lotties.pulse(<params>);
/// ```
/// ```dart
/// $Lotties.trimPath(<params>);
/// ```
abstract final class $Lotties {
  $Lotties._();

  /// Builds the `CataquiJobCardsCarousel` widget from `cataquiJobCardsCarousel.json`.
  static Widget cataquiJobCardsCarousel({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    bool clip = true,
    double? progress,
    Duration delay = Duration.zero,
    Duration? duration,
    LottiePlayback playback = LottiePlayback.once,
    bool respectDisableAnimations = true,
    CataquiJobCardsCarouselOverrides overrides =
        const CataquiJobCardsCarouselOverrides(),
  }) => _CataquiJobCardsCarousel(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    clip: clip,
    progress: progress,
    delay: delay,
    duration: duration,
    playback: playback,
    respectDisableAnimations: respectDisableAnimations,
    overrides: overrides,
  );

  /// Builds the `Pulse` widget from `pulse.json`.
  static Widget pulse({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    bool clip = true,
    double? progress,
    Duration delay = Duration.zero,
    Duration? duration,
    LottiePlayback playback = LottiePlayback.once,
    bool respectDisableAnimations = true,
    PulseOverrides overrides = const PulseOverrides(),
  }) => _Pulse(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    clip: clip,
    progress: progress,
    delay: delay,
    duration: duration,
    playback: playback,
    respectDisableAnimations: respectDisableAnimations,
    overrides: overrides,
  );

  /// Builds the `TrimPath` widget from `trimPath.json`.
  static Widget trimPath({
    Key? key,
    double? width,
    double? height,
    bool maintainAspectRatio = true,
    bool clip = true,
    double? progress,
    Duration delay = Duration.zero,
    Duration? duration,
    LottiePlayback playback = LottiePlayback.once,
    bool respectDisableAnimations = true,
    TrimPathOverrides overrides = const TrimPathOverrides(),
  }) => _TrimPath(
    key: key,
    width: width,
    height: height,
    maintainAspectRatio: maintainAspectRatio,
    clip: clip,
    progress: progress,
    delay: delay,
    duration: duration,
    playback: playback,
    respectDisableAnimations: respectDisableAnimations,
    overrides: overrides,
  );
}

/// Text and color values that replace defaults in `cataqui_job_cards_carousel.json`.
final class CataquiJobCardsCarouselOverrides {
  /// Creates Lottie value overrides.
  const CataquiJobCardsCarouselOverrides({
    this.jobCard01TextPostedTimeText,
    this.jobCard01TextJobTitleText,
    this.jobCard01TextPayText,
    this.jobCard01TextDescriptionText,
    this.jobCard02TextPostedTimeText,
    this.jobCard02TextJobTitleText,
    this.jobCard02TextPayText,
    this.jobCard02TextDescriptionText,
    this.jobCard03TextPostedTimeText,
    this.jobCard03TextJobTitleText,
    this.jobCard03TextPayText,
    this.jobCard03TextDescriptionText,
    this.jobCard04TextPostedTimeText,
    this.jobCard04TextJobTitleText,
    this.jobCard04TextPayText,
    this.jobCard04TextDescriptionText,
    this.jobCard05TextPostedTimeText,
    this.jobCard05TextJobTitleText,
    this.jobCard05TextPayText,
    this.jobCard05TextDescriptionText,
    this.jobCard06TextPostedTimeText,
    this.jobCard06TextJobTitleText,
    this.jobCard06TextPayText,
    this.jobCard06TextDescriptionText,
    this.jobCard01TextPostedTimeTextColor,
    this.jobCard01TextJobTitleTextColor,
    this.jobCard01TextPayTextColor,
    this.jobCard01TextDescriptionTextColor,
    this.jobCard01ArtworkColor1,
    this.jobCard01ArtworkColor2,
    this.jobCard01ArtworkColor3,
    this.jobCard01ArtworkColor4,
    this.jobCard01ArtworkColor5,
    this.jobCard02TextPostedTimeTextColor,
    this.jobCard02TextJobTitleTextColor,
    this.jobCard02TextPayTextColor,
    this.jobCard02TextDescriptionTextColor,
    this.jobCard02ArtworkColor1,
    this.jobCard02ArtworkColor2,
    this.jobCard03TextPostedTimeTextColor,
    this.jobCard03TextJobTitleTextColor,
    this.jobCard03TextPayTextColor,
    this.jobCard03TextDescriptionTextColor,
    this.jobCard03ArtworkColor1,
    this.jobCard03ArtworkColor2,
    this.jobCard03ArtworkColor3,
    this.jobCard03ArtworkColor4,
    this.jobCard04TextPostedTimeTextColor,
    this.jobCard04TextJobTitleTextColor,
    this.jobCard04TextPayTextColor,
    this.jobCard04TextDescriptionTextColor,
    this.jobCard04ArtworkColor1,
    this.jobCard04ArtworkColor2,
    this.jobCard04ArtworkColor3,
    this.jobCard05TextPostedTimeTextColor,
    this.jobCard05TextJobTitleTextColor,
    this.jobCard05TextPayTextColor,
    this.jobCard05TextDescriptionTextColor,
    this.jobCard05ArtworkColor1,
    this.jobCard05ArtworkColor2,
    this.jobCard05ArtworkColor3,
    this.jobCard06TextPostedTimeTextColor,
    this.jobCard06TextJobTitleTextColor,
    this.jobCard06TextPayTextColor,
    this.jobCard06TextDescriptionTextColor,
    this.jobCard06ArtworkColor1,
    this.jobCard06ArtworkColor2,
    this.jobCard06ArtworkColor3,
    this.jobCard06ArtworkColor4,
    this.jobCard06ArtworkColor5,
  });

  /// Replacement text for the `Job Card 01 / Text / Posted Time` Lottie layer.
  final String? jobCard01TextPostedTimeText;

  /// Replacement text for the `Job Card 01 / Text / Job Title` Lottie layer.
  final String? jobCard01TextJobTitleText;

  /// Replacement text for the `Job Card 01 / Text / Pay` Lottie layer.
  final String? jobCard01TextPayText;

  /// Replacement text for the `Job Card 01 / Text / Description` Lottie layer.
  final String? jobCard01TextDescriptionText;

  /// Replacement text for the `Job Card 02 / Text / Posted Time` Lottie layer.
  final String? jobCard02TextPostedTimeText;

  /// Replacement text for the `Job Card 02 / Text / Job Title` Lottie layer.
  final String? jobCard02TextJobTitleText;

  /// Replacement text for the `Job Card 02 / Text / Pay` Lottie layer.
  final String? jobCard02TextPayText;

  /// Replacement text for the `Job Card 02 / Text / Description` Lottie layer.
  final String? jobCard02TextDescriptionText;

  /// Replacement text for the `Job Card 03 / Text / Posted Time` Lottie layer.
  final String? jobCard03TextPostedTimeText;

  /// Replacement text for the `Job Card 03 / Text / Job Title` Lottie layer.
  final String? jobCard03TextJobTitleText;

  /// Replacement text for the `Job Card 03 / Text / Pay` Lottie layer.
  final String? jobCard03TextPayText;

  /// Replacement text for the `Job Card 03 / Text / Description` Lottie layer.
  final String? jobCard03TextDescriptionText;

  /// Replacement text for the `Job Card 04 / Text / Posted Time` Lottie layer.
  final String? jobCard04TextPostedTimeText;

  /// Replacement text for the `Job Card 04 / Text / Job Title` Lottie layer.
  final String? jobCard04TextJobTitleText;

  /// Replacement text for the `Job Card 04 / Text / Pay` Lottie layer.
  final String? jobCard04TextPayText;

  /// Replacement text for the `Job Card 04 / Text / Description` Lottie layer.
  final String? jobCard04TextDescriptionText;

  /// Replacement text for the `Job Card 05 / Text / Posted Time` Lottie layer.
  final String? jobCard05TextPostedTimeText;

  /// Replacement text for the `Job Card 05 / Text / Job Title` Lottie layer.
  final String? jobCard05TextJobTitleText;

  /// Replacement text for the `Job Card 05 / Text / Pay` Lottie layer.
  final String? jobCard05TextPayText;

  /// Replacement text for the `Job Card 05 / Text / Description` Lottie layer.
  final String? jobCard05TextDescriptionText;

  /// Replacement text for the `Job Card 06 / Text / Posted Time` Lottie layer.
  final String? jobCard06TextPostedTimeText;

  /// Replacement text for the `Job Card 06 / Text / Job Title` Lottie layer.
  final String? jobCard06TextJobTitleText;

  /// Replacement text for the `Job Card 06 / Text / Pay` Lottie layer.
  final String? jobCard06TextPayText;

  /// Replacement text for the `Job Card 06 / Text / Description` Lottie layer.
  final String? jobCard06TextDescriptionText;

  /// Replacement color for the `Job Card 01 / Text / Posted Time` Lottie layer.
  final Color? jobCard01TextPostedTimeTextColor;

  /// Replacement color for the `Job Card 01 / Text / Job Title` Lottie layer.
  final Color? jobCard01TextJobTitleTextColor;

  /// Replacement color for the `Job Card 01 / Text / Pay` Lottie layer.
  final Color? jobCard01TextPayTextColor;

  /// Replacement color for the `Job Card 01 / Text / Description` Lottie layer.
  final Color? jobCard01TextDescriptionTextColor;

  /// Replacement color for the `Job Card 01 / Artwork` Lottie layer.
  final Color? jobCard01ArtworkColor1;

  /// Replacement color for the `Job Card 01 / Artwork` Lottie layer.
  final Color? jobCard01ArtworkColor2;

  /// Replacement color for the `Job Card 01 / Artwork` Lottie layer.
  final Color? jobCard01ArtworkColor3;

  /// Replacement color for the `Job Card 01 / Artwork` Lottie layer.
  final Color? jobCard01ArtworkColor4;

  /// Replacement color for the `Job Card 01 / Artwork` Lottie layer.
  final Color? jobCard01ArtworkColor5;

  /// Replacement color for the `Job Card 02 / Text / Posted Time` Lottie layer.
  final Color? jobCard02TextPostedTimeTextColor;

  /// Replacement color for the `Job Card 02 / Text / Job Title` Lottie layer.
  final Color? jobCard02TextJobTitleTextColor;

  /// Replacement color for the `Job Card 02 / Text / Pay` Lottie layer.
  final Color? jobCard02TextPayTextColor;

  /// Replacement color for the `Job Card 02 / Text / Description` Lottie layer.
  final Color? jobCard02TextDescriptionTextColor;

  /// Replacement color for the `Job Card 02 / Artwork` Lottie layer.
  final Color? jobCard02ArtworkColor1;

  /// Replacement color for the `Job Card 02 / Artwork` Lottie layer.
  final Color? jobCard02ArtworkColor2;

  /// Replacement color for the `Job Card 03 / Text / Posted Time` Lottie layer.
  final Color? jobCard03TextPostedTimeTextColor;

  /// Replacement color for the `Job Card 03 / Text / Job Title` Lottie layer.
  final Color? jobCard03TextJobTitleTextColor;

  /// Replacement color for the `Job Card 03 / Text / Pay` Lottie layer.
  final Color? jobCard03TextPayTextColor;

  /// Replacement color for the `Job Card 03 / Text / Description` Lottie layer.
  final Color? jobCard03TextDescriptionTextColor;

  /// Replacement color for the `Job Card 03 / Artwork` Lottie layer.
  final Color? jobCard03ArtworkColor1;

  /// Replacement color for the `Job Card 03 / Artwork` Lottie layer.
  final Color? jobCard03ArtworkColor2;

  /// Replacement color for the `Job Card 03 / Artwork` Lottie layer.
  final Color? jobCard03ArtworkColor3;

  /// Replacement color for the `Job Card 03 / Artwork` Lottie layer.
  final Color? jobCard03ArtworkColor4;

  /// Replacement color for the `Job Card 04 / Text / Posted Time` Lottie layer.
  final Color? jobCard04TextPostedTimeTextColor;

  /// Replacement color for the `Job Card 04 / Text / Job Title` Lottie layer.
  final Color? jobCard04TextJobTitleTextColor;

  /// Replacement color for the `Job Card 04 / Text / Pay` Lottie layer.
  final Color? jobCard04TextPayTextColor;

  /// Replacement color for the `Job Card 04 / Text / Description` Lottie layer.
  final Color? jobCard04TextDescriptionTextColor;

  /// Replacement color for the `Job Card 04 / Artwork` Lottie layer.
  final Color? jobCard04ArtworkColor1;

  /// Replacement color for the `Job Card 04 / Artwork` Lottie layer.
  final Color? jobCard04ArtworkColor2;

  /// Replacement color for the `Job Card 04 / Artwork` Lottie layer.
  final Color? jobCard04ArtworkColor3;

  /// Replacement color for the `Job Card 05 / Text / Posted Time` Lottie layer.
  final Color? jobCard05TextPostedTimeTextColor;

  /// Replacement color for the `Job Card 05 / Text / Job Title` Lottie layer.
  final Color? jobCard05TextJobTitleTextColor;

  /// Replacement color for the `Job Card 05 / Text / Pay` Lottie layer.
  final Color? jobCard05TextPayTextColor;

  /// Replacement color for the `Job Card 05 / Text / Description` Lottie layer.
  final Color? jobCard05TextDescriptionTextColor;

  /// Replacement color for the `Job Card 05 / Artwork` Lottie layer.
  final Color? jobCard05ArtworkColor1;

  /// Replacement color for the `Job Card 05 / Artwork` Lottie layer.
  final Color? jobCard05ArtworkColor2;

  /// Replacement color for the `Job Card 05 / Artwork` Lottie layer.
  final Color? jobCard05ArtworkColor3;

  /// Replacement color for the `Job Card 06 / Text / Posted Time` Lottie layer.
  final Color? jobCard06TextPostedTimeTextColor;

  /// Replacement color for the `Job Card 06 / Text / Job Title` Lottie layer.
  final Color? jobCard06TextJobTitleTextColor;

  /// Replacement color for the `Job Card 06 / Text / Pay` Lottie layer.
  final Color? jobCard06TextPayTextColor;

  /// Replacement color for the `Job Card 06 / Text / Description` Lottie layer.
  final Color? jobCard06TextDescriptionTextColor;

  /// Replacement color for the `Job Card 06 / Artwork` Lottie layer.
  final Color? jobCard06ArtworkColor1;

  /// Replacement color for the `Job Card 06 / Artwork` Lottie layer.
  final Color? jobCard06ArtworkColor2;

  /// Replacement color for the `Job Card 06 / Artwork` Lottie layer.
  final Color? jobCard06ArtworkColor3;

  /// Replacement color for the `Job Card 06 / Artwork` Lottie layer.
  final Color? jobCard06ArtworkColor4;

  /// Replacement color for the `Job Card 06 / Artwork` Lottie layer.
  final Color? jobCard06ArtworkColor5;
}

/// A dotdart-generated animated widget from `assets/lotties/cataqui_job_cards_carousel.json`.
///
/// Renders a 18000ms animation
/// (1080 frames at 60.0Hz)
/// on a 458×540 canvas.
/// No Lottie runtime dependency — the animation is drawn
/// entirely via [CustomPainter].
class _CataquiJobCardsCarousel extends StatefulWidget {
  const _CataquiJobCardsCarousel({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.clip = true,
    this.progress,
    this.delay = Duration.zero,
    this.duration,
    this.playback = LottiePlayback.once,
    this.respectDisableAnimations = true,
    this.overrides = const CataquiJobCardsCarouselOverrides(),
  });

  static const double _lottieWidth = 458;
  static const double _lottieHeight = 540;
  static const int _totalFrames = 1080;
  static const Duration _nativeDuration = Duration(milliseconds: 18000);

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Whether painting is clipped to the Lottie canvas bounds.
  final bool clip;

  /// Fixed animation progress from 0 to 1.
  final double? progress;

  /// Non-negative time to wait once before automatic playback starts.
  final Duration delay;

  /// Positive total playback time. When null, uses the duration from the Lottie file.
  final Duration? duration;

  /// Whether automatic playback runs once or loops continuously.
  final LottiePlayback playback;

  /// Whether reduced-motion settings pause playback.
  final bool respectDisableAnimations;

  /// Text and color values that replace defaults from the Lottie file.
  final CataquiJobCardsCarouselOverrides overrides;

  @override
  State<_CataquiJobCardsCarousel> createState() =>
      _CataquiJobCardsCarouselState();
}

class _CataquiJobCardsCarouselState extends State<_CataquiJobCardsCarousel>
    with
        SingleTickerProviderStateMixin,
        WidgetsBindingObserver,
        _DotdartLottieAnimationState<_CataquiJobCardsCarousel> {
  _CataquiJobCardsCarouselPainter? _painter;

  @override
  double? get lottieWidgetWidth => widget.width;

  @override
  double? get lottieWidgetHeight => widget.height;

  @override
  bool get lottieMaintainAspectRatio => widget.maintainAspectRatio;

  @override
  double? get lottieProgress => widget.progress;

  @override
  Duration get lottieDelay => widget.delay;

  @override
  Duration? get lottieDuration => widget.duration;

  @override
  LottiePlayback get lottiePlayback => widget.playback;

  @override
  bool get lottieRespectDisableAnimations => widget.respectDisableAnimations;

  @override
  Duration get lottieNativeDuration => _CataquiJobCardsCarousel._nativeDuration;

  @override
  double get lottieCanvasWidth => _CataquiJobCardsCarousel._lottieWidth;

  @override
  double get lottieCanvasHeight => _CataquiJobCardsCarousel._lottieHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    final painter = _CataquiJobCardsCarouselPainter(
      animationProgress: widget.progress == null ? _controller : null,
      fixedProgress: (widget.progress ?? 0).clamp(0, 1).toDouble(),
      canvasScaleX: width / _CataquiJobCardsCarousel._lottieWidth,
      canvasScaleY: height / _CataquiJobCardsCarousel._lottieHeight,
      canvasRect: Rect.fromLTWH(0, 0, width, height),
      clip: widget.clip,
      overrides: widget.overrides,
    );
    _painter?.disposeResources();
    _painter = painter;
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(painter: painter, size: Size(width, height)),
      ),
    );
  }

  @override
  void dispose() {
    _painter?.disposeResources();
    super.dispose();
  }
}

class _CataquiJobCardsCarouselPainter extends CustomPainter {
  _CataquiJobCardsCarouselPainter({
    required this._fixedProgress,
    required this._canvasScaleX,
    required this._canvasScaleY,
    required this._canvasRect,
    required this.clip,
    required this.overrides,
    this._animationProgress,
  }) : super(repaint: _animationProgress);

  final double _fixedProgress;
  final double _canvasScaleX;
  final double _canvasScaleY;
  final Rect _canvasRect;
  final Animation<double>? _animationProgress;

  final bool clip;

  final CataquiJobCardsCarouselOverrides overrides;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;
  final Paint _strokePaint = Paint()..style = PaintingStyle.stroke;

  double _keyframes0Opacity(double frame) {
    if (frame <= 0) return 100;
    if (frame >= 1080) return 100;
    if (frame < 90.01) {
      return 100;
    }
    if (frame < 990.01) {
      return 0;
    }
    if (frame < 1080) {
      return 100;
    }
    return 100;
  }

  double _keyframes0Rotation(double frame) {
    if (frame <= 0) return 0;
    if (frame >= 1080) return 360;
    if (frame < 45) {
      final t = frame / 45;
      final eased = t;
      return 0 + 9.8236 * eased;
    }
    if (frame < 90) {
      final t = (frame - 45) / 45;
      final eased = t;
      return 9.8236 + 10.1764 * eased;
    }
    if (frame < 135) {
      final t = (frame - 90) / 45;
      final eased = t;
      return 20 + 10.8579 * eased;
    }
    if (frame < 180) {
      final t = (frame - 135) / 45;
      final eased = t;
      return 30.8579 + 11.8216 * eased;
    }
    if (frame < 225) {
      final t = (frame - 180) / 45;
      final eased = t;
      return 42.6795 + 13.002 * eased;
    }
    if (frame < 270) {
      final t = (frame - 225) / 45;
      final eased = t;
      return 55.6815 + 14.3185 * eased;
    }
    if (frame < 315) {
      final t = (frame - 270) / 45;
      final eased = t;
      return 70 + 15.6815 * eased;
    }
    if (frame < 360) {
      final t = (frame - 315) / 45;
      final eased = t;
      return 85.6815 + 16.998 * eased;
    }
    if (frame < 405) {
      final t = (frame - 360) / 45;
      final eased = t;
      return 102.6795 + 18.1784 * eased;
    }
    if (frame < 450) {
      final t = (frame - 405) / 45;
      final eased = t;
      return 120.8579 + 19.1421 * eased;
    }
    if (frame < 495) {
      final t = (frame - 450) / 45;
      final eased = t;
      return 140 + 19.8236 * eased;
    }
    if (frame < 540) {
      final t = (frame - 495) / 45;
      final eased = t;
      return 159.8236 + 20.1764 * eased;
    }
    if (frame < 585) {
      final t = (frame - 540) / 45;
      final eased = t;
      return 180 + 20.1764 * eased;
    }
    if (frame < 630) {
      final t = (frame - 585) / 45;
      final eased = t;
      return 200.1764 + 19.8236 * eased;
    }
    if (frame < 675) {
      final t = (frame - 630) / 45;
      final eased = t;
      return 220 + 19.1421 * eased;
    }
    if (frame < 720) {
      final t = (frame - 675) / 45;
      final eased = t;
      return 239.1421 + 18.1784 * eased;
    }
    if (frame < 765) {
      final t = (frame - 720) / 45;
      final eased = t;
      return 257.3205 + 16.998 * eased;
    }
    if (frame < 810) {
      final t = (frame - 765) / 45;
      final eased = t;
      return 274.3185 + 15.6815 * eased;
    }
    if (frame < 855) {
      final t = (frame - 810) / 45;
      final eased = t;
      return 290 + 14.3185 * eased;
    }
    if (frame < 900) {
      final t = (frame - 855) / 45;
      final eased = t;
      return 304.3185 + 13.002 * eased;
    }
    if (frame < 945) {
      final t = (frame - 900) / 45;
      final eased = t;
      return 317.3205 + 11.8216 * eased;
    }
    if (frame < 990) {
      final t = (frame - 945) / 45;
      final eased = t;
      return 329.1421 + 10.8579 * eased;
    }
    if (frame < 1035) {
      final t = (frame - 990) / 45;
      final eased = t;
      return 340 + 10.1764 * eased;
    }
    if (frame < 1080) {
      final t = (frame - 1035) / 45;
      final eased = t;
      return 350.1764 + 9.8236 * eased;
    }
    return 360;
  }

  double _keyframes1Opacity(double frame) {
    if (frame <= 0) return 0;
    if (frame >= 1080) return 0;
    if (frame < 90.01) {
      return 0;
    }
    if (frame < 270.01) {
      return 100;
    }
    if (frame < 1080) {
      return 0;
    }
    return 0;
  }

  double _keyframes1Rotation(double frame) {
    if (frame <= 0) return -42.6795;
    if (frame >= 1080) return 317.3205;
    if (frame < 45) {
      final t = frame / 45;
      final eased = t;
      return -42.6795 + 11.8216 * eased;
    }
    if (frame < 90) {
      final t = (frame - 45) / 45;
      final eased = t;
      return -30.8579 + 10.8579 * eased;
    }
    if (frame < 135) {
      final t = (frame - 90) / 45;
      final eased = t;
      return -20 + 10.1764 * eased;
    }
    if (frame < 180) {
      final t = (frame - 135) / 45;
      final eased = t;
      return -9.8236 + 9.8236 * eased;
    }
    if (frame < 225) {
      final t = (frame - 180) / 45;
      final eased = t;
      return 0 + 9.8236 * eased;
    }
    if (frame < 270) {
      final t = (frame - 225) / 45;
      final eased = t;
      return 9.8236 + 10.1764 * eased;
    }
    if (frame < 315) {
      final t = (frame - 270) / 45;
      final eased = t;
      return 20 + 10.8579 * eased;
    }
    if (frame < 360) {
      final t = (frame - 315) / 45;
      final eased = t;
      return 30.8579 + 11.8216 * eased;
    }
    if (frame < 405) {
      final t = (frame - 360) / 45;
      final eased = t;
      return 42.6795 + 13.002 * eased;
    }
    if (frame < 450) {
      final t = (frame - 405) / 45;
      final eased = t;
      return 55.6815 + 14.3185 * eased;
    }
    if (frame < 495) {
      final t = (frame - 450) / 45;
      final eased = t;
      return 70 + 15.6815 * eased;
    }
    if (frame < 540) {
      final t = (frame - 495) / 45;
      final eased = t;
      return 85.6815 + 16.998 * eased;
    }
    if (frame < 585) {
      final t = (frame - 540) / 45;
      final eased = t;
      return 102.6795 + 18.1784 * eased;
    }
    if (frame < 630) {
      final t = (frame - 585) / 45;
      final eased = t;
      return 120.8579 + 19.1421 * eased;
    }
    if (frame < 675) {
      final t = (frame - 630) / 45;
      final eased = t;
      return 140 + 19.8236 * eased;
    }
    if (frame < 720) {
      final t = (frame - 675) / 45;
      final eased = t;
      return 159.8236 + 20.1764 * eased;
    }
    if (frame < 765) {
      final t = (frame - 720) / 45;
      final eased = t;
      return 180 + 20.1764 * eased;
    }
    if (frame < 810) {
      final t = (frame - 765) / 45;
      final eased = t;
      return 200.1764 + 19.8236 * eased;
    }
    if (frame < 855) {
      final t = (frame - 810) / 45;
      final eased = t;
      return 220 + 19.1421 * eased;
    }
    if (frame < 900) {
      final t = (frame - 855) / 45;
      final eased = t;
      return 239.1421 + 18.1784 * eased;
    }
    if (frame < 945) {
      final t = (frame - 900) / 45;
      final eased = t;
      return 257.3205 + 16.998 * eased;
    }
    if (frame < 990) {
      final t = (frame - 945) / 45;
      final eased = t;
      return 274.3185 + 15.6815 * eased;
    }
    if (frame < 1035) {
      final t = (frame - 990) / 45;
      final eased = t;
      return 290 + 14.3185 * eased;
    }
    if (frame < 1080) {
      final t = (frame - 1035) / 45;
      final eased = t;
      return 304.3185 + 13.002 * eased;
    }
    return 317.3205;
  }

  double _keyframes2Opacity(double frame) {
    if (frame <= 0) return 0;
    if (frame >= 1080) return 0;
    if (frame < 270.01) {
      return 0;
    }
    if (frame < 450.01) {
      return 100;
    }
    if (frame < 1080) {
      return 0;
    }
    return 0;
  }

  double _keyframes2Rotation(double frame) {
    if (frame <= 0) return -102.6795;
    if (frame >= 1080) return 257.3205;
    if (frame < 45) {
      final t = frame / 45;
      final eased = t;
      return -102.6795 + 16.998 * eased;
    }
    if (frame < 90) {
      final t = (frame - 45) / 45;
      final eased = t;
      return -85.6815 + 15.6815 * eased;
    }
    if (frame < 135) {
      final t = (frame - 90) / 45;
      final eased = t;
      return -70 + 14.3185 * eased;
    }
    if (frame < 180) {
      final t = (frame - 135) / 45;
      final eased = t;
      return -55.6815 + 13.002 * eased;
    }
    if (frame < 225) {
      final t = (frame - 180) / 45;
      final eased = t;
      return -42.6795 + 11.8216 * eased;
    }
    if (frame < 270) {
      final t = (frame - 225) / 45;
      final eased = t;
      return -30.8579 + 10.8579 * eased;
    }
    if (frame < 315) {
      final t = (frame - 270) / 45;
      final eased = t;
      return -20 + 10.1764 * eased;
    }
    if (frame < 360) {
      final t = (frame - 315) / 45;
      final eased = t;
      return -9.8236 + 9.8236 * eased;
    }
    if (frame < 405) {
      final t = (frame - 360) / 45;
      final eased = t;
      return 0 + 9.8236 * eased;
    }
    if (frame < 450) {
      final t = (frame - 405) / 45;
      final eased = t;
      return 9.8236 + 10.1764 * eased;
    }
    if (frame < 495) {
      final t = (frame - 450) / 45;
      final eased = t;
      return 20 + 10.8579 * eased;
    }
    if (frame < 540) {
      final t = (frame - 495) / 45;
      final eased = t;
      return 30.8579 + 11.8216 * eased;
    }
    if (frame < 585) {
      final t = (frame - 540) / 45;
      final eased = t;
      return 42.6795 + 13.002 * eased;
    }
    if (frame < 630) {
      final t = (frame - 585) / 45;
      final eased = t;
      return 55.6815 + 14.3185 * eased;
    }
    if (frame < 675) {
      final t = (frame - 630) / 45;
      final eased = t;
      return 70 + 15.6815 * eased;
    }
    if (frame < 720) {
      final t = (frame - 675) / 45;
      final eased = t;
      return 85.6815 + 16.998 * eased;
    }
    if (frame < 765) {
      final t = (frame - 720) / 45;
      final eased = t;
      return 102.6795 + 18.1784 * eased;
    }
    if (frame < 810) {
      final t = (frame - 765) / 45;
      final eased = t;
      return 120.8579 + 19.1421 * eased;
    }
    if (frame < 855) {
      final t = (frame - 810) / 45;
      final eased = t;
      return 140 + 19.8236 * eased;
    }
    if (frame < 900) {
      final t = (frame - 855) / 45;
      final eased = t;
      return 159.8236 + 20.1764 * eased;
    }
    if (frame < 945) {
      final t = (frame - 900) / 45;
      final eased = t;
      return 180 + 20.1764 * eased;
    }
    if (frame < 990) {
      final t = (frame - 945) / 45;
      final eased = t;
      return 200.1764 + 19.8236 * eased;
    }
    if (frame < 1035) {
      final t = (frame - 990) / 45;
      final eased = t;
      return 220 + 19.1421 * eased;
    }
    if (frame < 1080) {
      final t = (frame - 1035) / 45;
      final eased = t;
      return 239.1421 + 18.1784 * eased;
    }
    return 257.3205;
  }

  double _keyframes3Opacity(double frame) {
    if (frame <= 0) return 0;
    if (frame >= 1080) return 0;
    if (frame < 450.01) {
      return 0;
    }
    if (frame < 630.01) {
      return 100;
    }
    if (frame < 1080) {
      return 0;
    }
    return 0;
  }

  double _keyframes3Rotation(double frame) {
    if (frame <= 0) return -180;
    if (frame >= 1080) return 180;
    if (frame < 45) {
      final t = frame / 45;
      final eased = t;
      return -180 + 20.1764 * eased;
    }
    if (frame < 90) {
      final t = (frame - 45) / 45;
      final eased = t;
      return -159.8236 + 19.8236 * eased;
    }
    if (frame < 135) {
      final t = (frame - 90) / 45;
      final eased = t;
      return -140 + 19.1421 * eased;
    }
    if (frame < 180) {
      final t = (frame - 135) / 45;
      final eased = t;
      return -120.8579 + 18.1784 * eased;
    }
    if (frame < 225) {
      final t = (frame - 180) / 45;
      final eased = t;
      return -102.6795 + 16.998 * eased;
    }
    if (frame < 270) {
      final t = (frame - 225) / 45;
      final eased = t;
      return -85.6815 + 15.6815 * eased;
    }
    if (frame < 315) {
      final t = (frame - 270) / 45;
      final eased = t;
      return -70 + 14.3185 * eased;
    }
    if (frame < 360) {
      final t = (frame - 315) / 45;
      final eased = t;
      return -55.6815 + 13.002 * eased;
    }
    if (frame < 405) {
      final t = (frame - 360) / 45;
      final eased = t;
      return -42.6795 + 11.8216 * eased;
    }
    if (frame < 450) {
      final t = (frame - 405) / 45;
      final eased = t;
      return -30.8579 + 10.8579 * eased;
    }
    if (frame < 495) {
      final t = (frame - 450) / 45;
      final eased = t;
      return -20 + 10.1764 * eased;
    }
    if (frame < 540) {
      final t = (frame - 495) / 45;
      final eased = t;
      return -9.8236 + 9.8236 * eased;
    }
    if (frame < 585) {
      final t = (frame - 540) / 45;
      final eased = t;
      return 0 + 9.8236 * eased;
    }
    if (frame < 630) {
      final t = (frame - 585) / 45;
      final eased = t;
      return 9.8236 + 10.1764 * eased;
    }
    if (frame < 675) {
      final t = (frame - 630) / 45;
      final eased = t;
      return 20 + 10.8579 * eased;
    }
    if (frame < 720) {
      final t = (frame - 675) / 45;
      final eased = t;
      return 30.8579 + 11.8216 * eased;
    }
    if (frame < 765) {
      final t = (frame - 720) / 45;
      final eased = t;
      return 42.6795 + 13.002 * eased;
    }
    if (frame < 810) {
      final t = (frame - 765) / 45;
      final eased = t;
      return 55.6815 + 14.3185 * eased;
    }
    if (frame < 855) {
      final t = (frame - 810) / 45;
      final eased = t;
      return 70 + 15.6815 * eased;
    }
    if (frame < 900) {
      final t = (frame - 855) / 45;
      final eased = t;
      return 85.6815 + 16.998 * eased;
    }
    if (frame < 945) {
      final t = (frame - 900) / 45;
      final eased = t;
      return 102.6795 + 18.1784 * eased;
    }
    if (frame < 990) {
      final t = (frame - 945) / 45;
      final eased = t;
      return 120.8579 + 19.1421 * eased;
    }
    if (frame < 1035) {
      final t = (frame - 990) / 45;
      final eased = t;
      return 140 + 19.8236 * eased;
    }
    if (frame < 1080) {
      final t = (frame - 1035) / 45;
      final eased = t;
      return 159.8236 + 20.1764 * eased;
    }
    return 180;
  }

  double _keyframes4Opacity(double frame) {
    if (frame <= 0) return 0;
    if (frame >= 1080) return 0;
    if (frame < 630.01) {
      return 0;
    }
    if (frame < 810.01) {
      return 100;
    }
    if (frame < 1080) {
      return 0;
    }
    return 0;
  }

  double _keyframes4Rotation(double frame) {
    if (frame <= 0) return -257.3205;
    if (frame >= 1080) return 102.6795;
    if (frame < 45) {
      final t = frame / 45;
      final eased = t;
      return -257.3205 + 18.1784 * eased;
    }
    if (frame < 90) {
      final t = (frame - 45) / 45;
      final eased = t;
      return -239.1421 + 19.1421 * eased;
    }
    if (frame < 135) {
      final t = (frame - 90) / 45;
      final eased = t;
      return -220 + 19.8236 * eased;
    }
    if (frame < 180) {
      final t = (frame - 135) / 45;
      final eased = t;
      return -200.1764 + 20.1764 * eased;
    }
    if (frame < 225) {
      final t = (frame - 180) / 45;
      final eased = t;
      return -180 + 20.1764 * eased;
    }
    if (frame < 270) {
      final t = (frame - 225) / 45;
      final eased = t;
      return -159.8236 + 19.8236 * eased;
    }
    if (frame < 315) {
      final t = (frame - 270) / 45;
      final eased = t;
      return -140 + 19.1421 * eased;
    }
    if (frame < 360) {
      final t = (frame - 315) / 45;
      final eased = t;
      return -120.8579 + 18.1784 * eased;
    }
    if (frame < 405) {
      final t = (frame - 360) / 45;
      final eased = t;
      return -102.6795 + 16.998 * eased;
    }
    if (frame < 450) {
      final t = (frame - 405) / 45;
      final eased = t;
      return -85.6815 + 15.6815 * eased;
    }
    if (frame < 495) {
      final t = (frame - 450) / 45;
      final eased = t;
      return -70 + 14.3185 * eased;
    }
    if (frame < 540) {
      final t = (frame - 495) / 45;
      final eased = t;
      return -55.6815 + 13.002 * eased;
    }
    if (frame < 585) {
      final t = (frame - 540) / 45;
      final eased = t;
      return -42.6795 + 11.8216 * eased;
    }
    if (frame < 630) {
      final t = (frame - 585) / 45;
      final eased = t;
      return -30.8579 + 10.8579 * eased;
    }
    if (frame < 675) {
      final t = (frame - 630) / 45;
      final eased = t;
      return -20 + 10.1764 * eased;
    }
    if (frame < 720) {
      final t = (frame - 675) / 45;
      final eased = t;
      return -9.8236 + 9.8236 * eased;
    }
    if (frame < 765) {
      final t = (frame - 720) / 45;
      final eased = t;
      return 0 + 9.8236 * eased;
    }
    if (frame < 810) {
      final t = (frame - 765) / 45;
      final eased = t;
      return 9.8236 + 10.1764 * eased;
    }
    if (frame < 855) {
      final t = (frame - 810) / 45;
      final eased = t;
      return 20 + 10.8579 * eased;
    }
    if (frame < 900) {
      final t = (frame - 855) / 45;
      final eased = t;
      return 30.8579 + 11.8216 * eased;
    }
    if (frame < 945) {
      final t = (frame - 900) / 45;
      final eased = t;
      return 42.6795 + 13.002 * eased;
    }
    if (frame < 990) {
      final t = (frame - 945) / 45;
      final eased = t;
      return 55.6815 + 14.3185 * eased;
    }
    if (frame < 1035) {
      final t = (frame - 990) / 45;
      final eased = t;
      return 70 + 15.6815 * eased;
    }
    if (frame < 1080) {
      final t = (frame - 1035) / 45;
      final eased = t;
      return 85.6815 + 16.998 * eased;
    }
    return 102.6795;
  }

  double _keyframes5Opacity(double frame) {
    if (frame <= 0) return 0;
    if (frame >= 1080) return 0;
    if (frame < 810.01) {
      return 0;
    }
    if (frame < 990.01) {
      return 100;
    }
    if (frame < 1080) {
      return 0;
    }
    return 0;
  }

  double _keyframes5Rotation(double frame) {
    if (frame <= 0) return -317.3205;
    if (frame >= 1080) return 42.6795;
    if (frame < 45) {
      final t = frame / 45;
      final eased = t;
      return -317.3205 + 13.002 * eased;
    }
    if (frame < 90) {
      final t = (frame - 45) / 45;
      final eased = t;
      return -304.3185 + 14.3185 * eased;
    }
    if (frame < 135) {
      final t = (frame - 90) / 45;
      final eased = t;
      return -290 + 15.6815 * eased;
    }
    if (frame < 180) {
      final t = (frame - 135) / 45;
      final eased = t;
      return -274.3185 + 16.998 * eased;
    }
    if (frame < 225) {
      final t = (frame - 180) / 45;
      final eased = t;
      return -257.3205 + 18.1784 * eased;
    }
    if (frame < 270) {
      final t = (frame - 225) / 45;
      final eased = t;
      return -239.1421 + 19.1421 * eased;
    }
    if (frame < 315) {
      final t = (frame - 270) / 45;
      final eased = t;
      return -220 + 19.8236 * eased;
    }
    if (frame < 360) {
      final t = (frame - 315) / 45;
      final eased = t;
      return -200.1764 + 20.1764 * eased;
    }
    if (frame < 405) {
      final t = (frame - 360) / 45;
      final eased = t;
      return -180 + 20.1764 * eased;
    }
    if (frame < 450) {
      final t = (frame - 405) / 45;
      final eased = t;
      return -159.8236 + 19.8236 * eased;
    }
    if (frame < 495) {
      final t = (frame - 450) / 45;
      final eased = t;
      return -140 + 19.1421 * eased;
    }
    if (frame < 540) {
      final t = (frame - 495) / 45;
      final eased = t;
      return -120.8579 + 18.1784 * eased;
    }
    if (frame < 585) {
      final t = (frame - 540) / 45;
      final eased = t;
      return -102.6795 + 16.998 * eased;
    }
    if (frame < 630) {
      final t = (frame - 585) / 45;
      final eased = t;
      return -85.6815 + 15.6815 * eased;
    }
    if (frame < 675) {
      final t = (frame - 630) / 45;
      final eased = t;
      return -70 + 14.3185 * eased;
    }
    if (frame < 720) {
      final t = (frame - 675) / 45;
      final eased = t;
      return -55.6815 + 13.002 * eased;
    }
    if (frame < 765) {
      final t = (frame - 720) / 45;
      final eased = t;
      return -42.6795 + 11.8216 * eased;
    }
    if (frame < 810) {
      final t = (frame - 765) / 45;
      final eased = t;
      return -30.8579 + 10.8579 * eased;
    }
    if (frame < 855) {
      final t = (frame - 810) / 45;
      final eased = t;
      return -20 + 10.1764 * eased;
    }
    if (frame < 900) {
      final t = (frame - 855) / 45;
      final eased = t;
      return -9.8236 + 9.8236 * eased;
    }
    if (frame < 945) {
      final t = (frame - 900) / 45;
      final eased = t;
      return 0 + 9.8236 * eased;
    }
    if (frame < 990) {
      final t = (frame - 945) / 45;
      final eased = t;
      return 9.8236 + 10.1764 * eased;
    }
    if (frame < 1035) {
      final t = (frame - 990) / 45;
      final eased = t;
      return 20 + 10.8579 * eased;
    }
    if (frame < 1080) {
      final t = (frame - 1035) / 45;
      final eased = t;
      return 30.8579 + 11.8216 * eased;
    }
    return 42.6795;
  }

  double _keyframes6Opacity(double frame) {
    if (frame <= 0) return 0;
    if (frame >= 1080) return 0;
    if (frame < 90.01) {
      return 0;
    }
    if (frame < 180) {
      return 100;
    }
    if (frame < 360) {
      final t = (frame - 180) / 180;
      final eased = t;
      return 100 + -100 * eased;
    }
    if (frame < 720) {
      return 0;
    }
    if (frame < 900) {
      final t = (frame - 720) / 180;
      final eased = t;
      return 0 + 100 * eased;
    }
    if (frame < 990.01) {
      return 100;
    }
    if (frame < 1080) {
      return 0;
    }
    return 0;
  }

  double _keyframes6Rotation(double frame) {
    if (frame <= 0) return 0;
    if (frame >= 1080) return 360;
    if (frame < 45) {
      final t = frame / 45;
      final eased = t;
      return 0 + 9.8236 * eased;
    }
    if (frame < 90) {
      final t = (frame - 45) / 45;
      final eased = t;
      return 9.8236 + 10.1764 * eased;
    }
    if (frame < 135) {
      final t = (frame - 90) / 45;
      final eased = t;
      return 20 + 10.8579 * eased;
    }
    if (frame < 180) {
      final t = (frame - 135) / 45;
      final eased = t;
      return 30.8579 + 11.8216 * eased;
    }
    if (frame < 225) {
      final t = (frame - 180) / 45;
      final eased = t;
      return 42.6795 + 13.002 * eased;
    }
    if (frame < 270) {
      final t = (frame - 225) / 45;
      final eased = t;
      return 55.6815 + 14.3185 * eased;
    }
    if (frame < 315) {
      final t = (frame - 270) / 45;
      final eased = t;
      return 70 + 15.6815 * eased;
    }
    if (frame < 360) {
      final t = (frame - 315) / 45;
      final eased = t;
      return 85.6815 + 16.998 * eased;
    }
    if (frame < 405) {
      final t = (frame - 360) / 45;
      final eased = t;
      return 102.6795 + 18.1784 * eased;
    }
    if (frame < 450) {
      final t = (frame - 405) / 45;
      final eased = t;
      return 120.8579 + 19.1421 * eased;
    }
    if (frame < 495) {
      final t = (frame - 450) / 45;
      final eased = t;
      return 140 + 19.8236 * eased;
    }
    if (frame < 540) {
      final t = (frame - 495) / 45;
      final eased = t;
      return 159.8236 + 20.1764 * eased;
    }
    if (frame < 585) {
      final t = (frame - 540) / 45;
      final eased = t;
      return 180 + 20.1764 * eased;
    }
    if (frame < 630) {
      final t = (frame - 585) / 45;
      final eased = t;
      return 200.1764 + 19.8236 * eased;
    }
    if (frame < 675) {
      final t = (frame - 630) / 45;
      final eased = t;
      return 220 + 19.1421 * eased;
    }
    if (frame < 720) {
      final t = (frame - 675) / 45;
      final eased = t;
      return 239.1421 + 18.1784 * eased;
    }
    if (frame < 765) {
      final t = (frame - 720) / 45;
      final eased = t;
      return 257.3205 + 16.998 * eased;
    }
    if (frame < 810) {
      final t = (frame - 765) / 45;
      final eased = t;
      return 274.3185 + 15.6815 * eased;
    }
    if (frame < 855) {
      final t = (frame - 810) / 45;
      final eased = t;
      return 290 + 14.3185 * eased;
    }
    if (frame < 900) {
      final t = (frame - 855) / 45;
      final eased = t;
      return 304.3185 + 13.002 * eased;
    }
    if (frame < 945) {
      final t = (frame - 900) / 45;
      final eased = t;
      return 317.3205 + 11.8216 * eased;
    }
    if (frame < 990) {
      final t = (frame - 945) / 45;
      final eased = t;
      return 329.1421 + 10.8579 * eased;
    }
    if (frame < 1035) {
      final t = (frame - 990) / 45;
      final eased = t;
      return 340 + 10.1764 * eased;
    }
    if (frame < 1080) {
      final t = (frame - 1035) / 45;
      final eased = t;
      return 350.1764 + 9.8236 * eased;
    }
    return 360;
  }

  double _keyframes7Opacity(double frame) {
    if (frame <= 0) return 100;
    if (frame >= 1080) return 100;
    if (frame < 90.01) {
      return 100;
    }
    if (frame < 270.01) {
      return 0;
    }
    if (frame < 360) {
      return 100;
    }
    if (frame < 540) {
      final t = (frame - 360) / 180;
      final eased = t;
      return 100 + -100 * eased;
    }
    if (frame < 900) {
      return 0;
    }
    if (frame < 1080) {
      final t = (frame - 900) / 180;
      final eased = t;
      return 0 + 100 * eased;
    }
    return 100;
  }

  double _keyframes7Rotation(double frame) {
    if (frame <= 0) return -42.6795;
    if (frame >= 1080) return 317.3205;
    if (frame < 45) {
      final t = frame / 45;
      final eased = t;
      return -42.6795 + 11.8216 * eased;
    }
    if (frame < 90) {
      final t = (frame - 45) / 45;
      final eased = t;
      return -30.8579 + 10.8579 * eased;
    }
    if (frame < 135) {
      final t = (frame - 90) / 45;
      final eased = t;
      return -20 + 10.1764 * eased;
    }
    if (frame < 180) {
      final t = (frame - 135) / 45;
      final eased = t;
      return -9.8236 + 9.8236 * eased;
    }
    if (frame < 225) {
      final t = (frame - 180) / 45;
      final eased = t;
      return 0 + 9.8236 * eased;
    }
    if (frame < 270) {
      final t = (frame - 225) / 45;
      final eased = t;
      return 9.8236 + 10.1764 * eased;
    }
    if (frame < 315) {
      final t = (frame - 270) / 45;
      final eased = t;
      return 20 + 10.8579 * eased;
    }
    if (frame < 360) {
      final t = (frame - 315) / 45;
      final eased = t;
      return 30.8579 + 11.8216 * eased;
    }
    if (frame < 405) {
      final t = (frame - 360) / 45;
      final eased = t;
      return 42.6795 + 13.002 * eased;
    }
    if (frame < 450) {
      final t = (frame - 405) / 45;
      final eased = t;
      return 55.6815 + 14.3185 * eased;
    }
    if (frame < 495) {
      final t = (frame - 450) / 45;
      final eased = t;
      return 70 + 15.6815 * eased;
    }
    if (frame < 540) {
      final t = (frame - 495) / 45;
      final eased = t;
      return 85.6815 + 16.998 * eased;
    }
    if (frame < 585) {
      final t = (frame - 540) / 45;
      final eased = t;
      return 102.6795 + 18.1784 * eased;
    }
    if (frame < 630) {
      final t = (frame - 585) / 45;
      final eased = t;
      return 120.8579 + 19.1421 * eased;
    }
    if (frame < 675) {
      final t = (frame - 630) / 45;
      final eased = t;
      return 140 + 19.8236 * eased;
    }
    if (frame < 720) {
      final t = (frame - 675) / 45;
      final eased = t;
      return 159.8236 + 20.1764 * eased;
    }
    if (frame < 765) {
      final t = (frame - 720) / 45;
      final eased = t;
      return 180 + 20.1764 * eased;
    }
    if (frame < 810) {
      final t = (frame - 765) / 45;
      final eased = t;
      return 200.1764 + 19.8236 * eased;
    }
    if (frame < 855) {
      final t = (frame - 810) / 45;
      final eased = t;
      return 220 + 19.1421 * eased;
    }
    if (frame < 900) {
      final t = (frame - 855) / 45;
      final eased = t;
      return 239.1421 + 18.1784 * eased;
    }
    if (frame < 945) {
      final t = (frame - 900) / 45;
      final eased = t;
      return 257.3205 + 16.998 * eased;
    }
    if (frame < 990) {
      final t = (frame - 945) / 45;
      final eased = t;
      return 274.3185 + 15.6815 * eased;
    }
    if (frame < 1035) {
      final t = (frame - 990) / 45;
      final eased = t;
      return 290 + 14.3185 * eased;
    }
    if (frame < 1080) {
      final t = (frame - 1035) / 45;
      final eased = t;
      return 304.3185 + 13.002 * eased;
    }
    return 317.3205;
  }

  double _keyframes8Opacity(double frame) {
    if (frame <= 0) return 0;
    if (frame >= 1080) return 0;
    if (frame < 180) {
      final t = frame / 180;
      final eased = t;
      return 0 + 100 * eased;
    }
    if (frame < 270.01) {
      return 100;
    }
    if (frame < 450.01) {
      return 0;
    }
    if (frame < 540) {
      return 100;
    }
    if (frame < 720) {
      final t = (frame - 540) / 180;
      final eased = t;
      return 100 + -100 * eased;
    }
    if (frame < 1080) {
      return 0;
    }
    return 0;
  }

  double _keyframes8Rotation(double frame) {
    if (frame <= 0) return -102.6795;
    if (frame >= 1080) return 257.3205;
    if (frame < 45) {
      final t = frame / 45;
      final eased = t;
      return -102.6795 + 16.998 * eased;
    }
    if (frame < 90) {
      final t = (frame - 45) / 45;
      final eased = t;
      return -85.6815 + 15.6815 * eased;
    }
    if (frame < 135) {
      final t = (frame - 90) / 45;
      final eased = t;
      return -70 + 14.3185 * eased;
    }
    if (frame < 180) {
      final t = (frame - 135) / 45;
      final eased = t;
      return -55.6815 + 13.002 * eased;
    }
    if (frame < 225) {
      final t = (frame - 180) / 45;
      final eased = t;
      return -42.6795 + 11.8216 * eased;
    }
    if (frame < 270) {
      final t = (frame - 225) / 45;
      final eased = t;
      return -30.8579 + 10.8579 * eased;
    }
    if (frame < 315) {
      final t = (frame - 270) / 45;
      final eased = t;
      return -20 + 10.1764 * eased;
    }
    if (frame < 360) {
      final t = (frame - 315) / 45;
      final eased = t;
      return -9.8236 + 9.8236 * eased;
    }
    if (frame < 405) {
      final t = (frame - 360) / 45;
      final eased = t;
      return 0 + 9.8236 * eased;
    }
    if (frame < 450) {
      final t = (frame - 405) / 45;
      final eased = t;
      return 9.8236 + 10.1764 * eased;
    }
    if (frame < 495) {
      final t = (frame - 450) / 45;
      final eased = t;
      return 20 + 10.8579 * eased;
    }
    if (frame < 540) {
      final t = (frame - 495) / 45;
      final eased = t;
      return 30.8579 + 11.8216 * eased;
    }
    if (frame < 585) {
      final t = (frame - 540) / 45;
      final eased = t;
      return 42.6795 + 13.002 * eased;
    }
    if (frame < 630) {
      final t = (frame - 585) / 45;
      final eased = t;
      return 55.6815 + 14.3185 * eased;
    }
    if (frame < 675) {
      final t = (frame - 630) / 45;
      final eased = t;
      return 70 + 15.6815 * eased;
    }
    if (frame < 720) {
      final t = (frame - 675) / 45;
      final eased = t;
      return 85.6815 + 16.998 * eased;
    }
    if (frame < 765) {
      final t = (frame - 720) / 45;
      final eased = t;
      return 102.6795 + 18.1784 * eased;
    }
    if (frame < 810) {
      final t = (frame - 765) / 45;
      final eased = t;
      return 120.8579 + 19.1421 * eased;
    }
    if (frame < 855) {
      final t = (frame - 810) / 45;
      final eased = t;
      return 140 + 19.8236 * eased;
    }
    if (frame < 900) {
      final t = (frame - 855) / 45;
      final eased = t;
      return 159.8236 + 20.1764 * eased;
    }
    if (frame < 945) {
      final t = (frame - 900) / 45;
      final eased = t;
      return 180 + 20.1764 * eased;
    }
    if (frame < 990) {
      final t = (frame - 945) / 45;
      final eased = t;
      return 200.1764 + 19.8236 * eased;
    }
    if (frame < 1035) {
      final t = (frame - 990) / 45;
      final eased = t;
      return 220 + 19.1421 * eased;
    }
    if (frame < 1080) {
      final t = (frame - 1035) / 45;
      final eased = t;
      return 239.1421 + 18.1784 * eased;
    }
    return 257.3205;
  }

  double _keyframes9Opacity(double frame) {
    if (frame <= 0) return 0;
    if (frame >= 1080) return 0;
    if (frame < 180) {
      return 0;
    }
    if (frame < 360) {
      final t = (frame - 180) / 180;
      final eased = t;
      return 0 + 100 * eased;
    }
    if (frame < 450.01) {
      return 100;
    }
    if (frame < 630.01) {
      return 0;
    }
    if (frame < 720) {
      return 100;
    }
    if (frame < 900) {
      final t = (frame - 720) / 180;
      final eased = t;
      return 100 + -100 * eased;
    }
    if (frame < 1080) {
      return 0;
    }
    return 0;
  }

  double _keyframes9Rotation(double frame) {
    if (frame <= 0) return -180;
    if (frame >= 1080) return 180;
    if (frame < 45) {
      final t = frame / 45;
      final eased = t;
      return -180 + 20.1764 * eased;
    }
    if (frame < 90) {
      final t = (frame - 45) / 45;
      final eased = t;
      return -159.8236 + 19.8236 * eased;
    }
    if (frame < 135) {
      final t = (frame - 90) / 45;
      final eased = t;
      return -140 + 19.1421 * eased;
    }
    if (frame < 180) {
      final t = (frame - 135) / 45;
      final eased = t;
      return -120.8579 + 18.1784 * eased;
    }
    if (frame < 225) {
      final t = (frame - 180) / 45;
      final eased = t;
      return -102.6795 + 16.998 * eased;
    }
    if (frame < 270) {
      final t = (frame - 225) / 45;
      final eased = t;
      return -85.6815 + 15.6815 * eased;
    }
    if (frame < 315) {
      final t = (frame - 270) / 45;
      final eased = t;
      return -70 + 14.3185 * eased;
    }
    if (frame < 360) {
      final t = (frame - 315) / 45;
      final eased = t;
      return -55.6815 + 13.002 * eased;
    }
    if (frame < 405) {
      final t = (frame - 360) / 45;
      final eased = t;
      return -42.6795 + 11.8216 * eased;
    }
    if (frame < 450) {
      final t = (frame - 405) / 45;
      final eased = t;
      return -30.8579 + 10.8579 * eased;
    }
    if (frame < 495) {
      final t = (frame - 450) / 45;
      final eased = t;
      return -20 + 10.1764 * eased;
    }
    if (frame < 540) {
      final t = (frame - 495) / 45;
      final eased = t;
      return -9.8236 + 9.8236 * eased;
    }
    if (frame < 585) {
      final t = (frame - 540) / 45;
      final eased = t;
      return 0 + 9.8236 * eased;
    }
    if (frame < 630) {
      final t = (frame - 585) / 45;
      final eased = t;
      return 9.8236 + 10.1764 * eased;
    }
    if (frame < 675) {
      final t = (frame - 630) / 45;
      final eased = t;
      return 20 + 10.8579 * eased;
    }
    if (frame < 720) {
      final t = (frame - 675) / 45;
      final eased = t;
      return 30.8579 + 11.8216 * eased;
    }
    if (frame < 765) {
      final t = (frame - 720) / 45;
      final eased = t;
      return 42.6795 + 13.002 * eased;
    }
    if (frame < 810) {
      final t = (frame - 765) / 45;
      final eased = t;
      return 55.6815 + 14.3185 * eased;
    }
    if (frame < 855) {
      final t = (frame - 810) / 45;
      final eased = t;
      return 70 + 15.6815 * eased;
    }
    if (frame < 900) {
      final t = (frame - 855) / 45;
      final eased = t;
      return 85.6815 + 16.998 * eased;
    }
    if (frame < 945) {
      final t = (frame - 900) / 45;
      final eased = t;
      return 102.6795 + 18.1784 * eased;
    }
    if (frame < 990) {
      final t = (frame - 945) / 45;
      final eased = t;
      return 120.8579 + 19.1421 * eased;
    }
    if (frame < 1035) {
      final t = (frame - 990) / 45;
      final eased = t;
      return 140 + 19.8236 * eased;
    }
    if (frame < 1080) {
      final t = (frame - 1035) / 45;
      final eased = t;
      return 159.8236 + 20.1764 * eased;
    }
    return 180;
  }

  double _keyframes10Opacity(double frame) {
    if (frame <= 0) return 0;
    if (frame >= 1080) return 0;
    if (frame < 360) {
      return 0;
    }
    if (frame < 540) {
      final t = (frame - 360) / 180;
      final eased = t;
      return 0 + 100 * eased;
    }
    if (frame < 630.01) {
      return 100;
    }
    if (frame < 810.01) {
      return 0;
    }
    if (frame < 900) {
      return 100;
    }
    if (frame < 1080) {
      final t = (frame - 900) / 180;
      final eased = t;
      return 100 + -100 * eased;
    }
    return 0;
  }

  double _keyframes10Rotation(double frame) {
    if (frame <= 0) return -257.3205;
    if (frame >= 1080) return 102.6795;
    if (frame < 45) {
      final t = frame / 45;
      final eased = t;
      return -257.3205 + 18.1784 * eased;
    }
    if (frame < 90) {
      final t = (frame - 45) / 45;
      final eased = t;
      return -239.1421 + 19.1421 * eased;
    }
    if (frame < 135) {
      final t = (frame - 90) / 45;
      final eased = t;
      return -220 + 19.8236 * eased;
    }
    if (frame < 180) {
      final t = (frame - 135) / 45;
      final eased = t;
      return -200.1764 + 20.1764 * eased;
    }
    if (frame < 225) {
      final t = (frame - 180) / 45;
      final eased = t;
      return -180 + 20.1764 * eased;
    }
    if (frame < 270) {
      final t = (frame - 225) / 45;
      final eased = t;
      return -159.8236 + 19.8236 * eased;
    }
    if (frame < 315) {
      final t = (frame - 270) / 45;
      final eased = t;
      return -140 + 19.1421 * eased;
    }
    if (frame < 360) {
      final t = (frame - 315) / 45;
      final eased = t;
      return -120.8579 + 18.1784 * eased;
    }
    if (frame < 405) {
      final t = (frame - 360) / 45;
      final eased = t;
      return -102.6795 + 16.998 * eased;
    }
    if (frame < 450) {
      final t = (frame - 405) / 45;
      final eased = t;
      return -85.6815 + 15.6815 * eased;
    }
    if (frame < 495) {
      final t = (frame - 450) / 45;
      final eased = t;
      return -70 + 14.3185 * eased;
    }
    if (frame < 540) {
      final t = (frame - 495) / 45;
      final eased = t;
      return -55.6815 + 13.002 * eased;
    }
    if (frame < 585) {
      final t = (frame - 540) / 45;
      final eased = t;
      return -42.6795 + 11.8216 * eased;
    }
    if (frame < 630) {
      final t = (frame - 585) / 45;
      final eased = t;
      return -30.8579 + 10.8579 * eased;
    }
    if (frame < 675) {
      final t = (frame - 630) / 45;
      final eased = t;
      return -20 + 10.1764 * eased;
    }
    if (frame < 720) {
      final t = (frame - 675) / 45;
      final eased = t;
      return -9.8236 + 9.8236 * eased;
    }
    if (frame < 765) {
      final t = (frame - 720) / 45;
      final eased = t;
      return 0 + 9.8236 * eased;
    }
    if (frame < 810) {
      final t = (frame - 765) / 45;
      final eased = t;
      return 9.8236 + 10.1764 * eased;
    }
    if (frame < 855) {
      final t = (frame - 810) / 45;
      final eased = t;
      return 20 + 10.8579 * eased;
    }
    if (frame < 900) {
      final t = (frame - 855) / 45;
      final eased = t;
      return 30.8579 + 11.8216 * eased;
    }
    if (frame < 945) {
      final t = (frame - 900) / 45;
      final eased = t;
      return 42.6795 + 13.002 * eased;
    }
    if (frame < 990) {
      final t = (frame - 945) / 45;
      final eased = t;
      return 55.6815 + 14.3185 * eased;
    }
    if (frame < 1035) {
      final t = (frame - 990) / 45;
      final eased = t;
      return 70 + 15.6815 * eased;
    }
    if (frame < 1080) {
      final t = (frame - 1035) / 45;
      final eased = t;
      return 85.6815 + 16.998 * eased;
    }
    return 102.6795;
  }

  double _keyframes11Opacity(double frame) {
    if (frame <= 0) return 100;
    if (frame >= 1080) return 100;
    if (frame < 180) {
      final t = frame / 180;
      final eased = t;
      return 100 + -100 * eased;
    }
    if (frame < 540) {
      return 0;
    }
    if (frame < 720) {
      final t = (frame - 540) / 180;
      final eased = t;
      return 0 + 100 * eased;
    }
    if (frame < 810.01) {
      return 100;
    }
    if (frame < 990.01) {
      return 0;
    }
    if (frame < 1080) {
      return 100;
    }
    return 100;
  }

  double _keyframes11Rotation(double frame) {
    if (frame <= 0) return -317.3205;
    if (frame >= 1080) return 42.6795;
    if (frame < 45) {
      final t = frame / 45;
      final eased = t;
      return -317.3205 + 13.002 * eased;
    }
    if (frame < 90) {
      final t = (frame - 45) / 45;
      final eased = t;
      return -304.3185 + 14.3185 * eased;
    }
    if (frame < 135) {
      final t = (frame - 90) / 45;
      final eased = t;
      return -290 + 15.6815 * eased;
    }
    if (frame < 180) {
      final t = (frame - 135) / 45;
      final eased = t;
      return -274.3185 + 16.998 * eased;
    }
    if (frame < 225) {
      final t = (frame - 180) / 45;
      final eased = t;
      return -257.3205 + 18.1784 * eased;
    }
    if (frame < 270) {
      final t = (frame - 225) / 45;
      final eased = t;
      return -239.1421 + 19.1421 * eased;
    }
    if (frame < 315) {
      final t = (frame - 270) / 45;
      final eased = t;
      return -220 + 19.8236 * eased;
    }
    if (frame < 360) {
      final t = (frame - 315) / 45;
      final eased = t;
      return -200.1764 + 20.1764 * eased;
    }
    if (frame < 405) {
      final t = (frame - 360) / 45;
      final eased = t;
      return -180 + 20.1764 * eased;
    }
    if (frame < 450) {
      final t = (frame - 405) / 45;
      final eased = t;
      return -159.8236 + 19.8236 * eased;
    }
    if (frame < 495) {
      final t = (frame - 450) / 45;
      final eased = t;
      return -140 + 19.1421 * eased;
    }
    if (frame < 540) {
      final t = (frame - 495) / 45;
      final eased = t;
      return -120.8579 + 18.1784 * eased;
    }
    if (frame < 585) {
      final t = (frame - 540) / 45;
      final eased = t;
      return -102.6795 + 16.998 * eased;
    }
    if (frame < 630) {
      final t = (frame - 585) / 45;
      final eased = t;
      return -85.6815 + 15.6815 * eased;
    }
    if (frame < 675) {
      final t = (frame - 630) / 45;
      final eased = t;
      return -70 + 14.3185 * eased;
    }
    if (frame < 720) {
      final t = (frame - 675) / 45;
      final eased = t;
      return -55.6815 + 13.002 * eased;
    }
    if (frame < 765) {
      final t = (frame - 720) / 45;
      final eased = t;
      return -42.6795 + 11.8216 * eased;
    }
    if (frame < 810) {
      final t = (frame - 765) / 45;
      final eased = t;
      return -30.8579 + 10.8579 * eased;
    }
    if (frame < 855) {
      final t = (frame - 810) / 45;
      final eased = t;
      return -20 + 10.1764 * eased;
    }
    if (frame < 900) {
      final t = (frame - 855) / 45;
      final eased = t;
      return -9.8236 + 9.8236 * eased;
    }
    if (frame < 945) {
      final t = (frame - 900) / 45;
      final eased = t;
      return 0 + 9.8236 * eased;
    }
    if (frame < 990) {
      final t = (frame - 945) / 45;
      final eased = t;
      return 9.8236 + 10.1764 * eased;
    }
    if (frame < 1035) {
      final t = (frame - 990) / 45;
      final eased = t;
      return 20 + 10.8579 * eased;
    }
    if (frame < 1080) {
      final t = (frame - 1035) / 45;
      final eased = t;
      return 30.8579 + 11.8216 * eased;
    }
    return 42.6795;
  }

  double _keyframes12Rotation(double frame) {
    if (frame <= 0) return 0;
    if (frame >= 1080) return -360;
    if (frame < 1080) {
      final t = frame / 1080;
      final eased = t;
      return 0 + -360 * eased;
    }
    return -360;
  }

  double _keyframes13Rotation(double frame) {
    if (frame <= 0) return 60;
    if (frame >= 1080) return -300;
    if (frame < 1080) {
      final t = frame / 1080;
      final eased = t;
      return 60 + -360 * eased;
    }
    return -300;
  }

  double _keyframes14Rotation(double frame) {
    if (frame <= 0) return 120;
    if (frame >= 1080) return -240;
    if (frame < 1080) {
      final t = frame / 1080;
      final eased = t;
      return 120 + -360 * eased;
    }
    return -240;
  }

  double _keyframes15Rotation(double frame) {
    if (frame <= 0) return 180;
    if (frame >= 1080) return -180;
    if (frame < 1080) {
      final t = frame / 1080;
      final eased = t;
      return 180 + -360 * eased;
    }
    return -180;
  }

  double _keyframes16Rotation(double frame) {
    if (frame <= 0) return 240;
    if (frame >= 1080) return -120;
    if (frame < 1080) {
      final t = frame / 1080;
      final eased = t;
      return 240 + -360 * eased;
    }
    return -120;
  }

  double _keyframes17Rotation(double frame) {
    if (frame <= 0) return 300;
    if (frame >= 1080) return -60;
    if (frame < 1080) {
      final t = frame / 1080;
      final eased = t;
      return 300 + -360 * eased;
    }
    return -60;
  }

  static final Path __path22_0_0 = Path()
    ..moveTo(44, 10)
    ..cubicTo(44, 10, 247, 10, 247, 10)
    ..cubicTo(265.2254, 10, 280, 24.7746, 280, 43)
    ..cubicTo(280, 43, 280, 136.045, 280, 136.045)
    ..cubicTo(280, 154.2704, 265.2254, 169.045, 247, 169.045)
    ..cubicTo(247, 169.045, 44, 169.045, 44, 169.045)
    ..cubicTo(25.7746, 169.045, 11, 154.2704, 11, 136.045)
    ..cubicTo(11, 136.045, 11, 43, 11, 43)
    ..cubicTo(11, 24.7746, 25.7746, 10, 44, 10)
    ..close();

  static final Path __path22_1_0 = Path()
    ..moveTo(0.4375, 79.0312)
    ..cubicTo(0.4375, 79.0312, 43.6662, 122.679, 43.6662, 122.679)
    ..cubicTo(43.6662, 122.679, 76.706, 159.52, 79.278, 163.891)
    ..cubicTo(79.278, 163.891, 107.471, 194.488, 107.471, 194.488)
    ..cubicTo(107.471, 194.488, 117.857, 210.099, 117.857, 210.099)
    ..cubicTo(123.496, 219.965, 130.866, 225.585, 132.201, 238.199)
    ..cubicTo(132.201, 238.199, 133.437, 353.031, 133.437, 353.031);

  static final Path __path22_1_1 = Path()
    ..moveTo(0.4375, 110.031)
    ..cubicTo(0.4375, 110.031, 25.7943, 147.522, 25.7943, 147.522)
    ..cubicTo(32.1582, 152.645, 51.9405, 176.264, 58.3537, 187.511)
    ..cubicTo(58.3537, 187.511, 59.8336, 188.761, 59.8336, 188.761)
    ..cubicTo(62.4483, 192.073, 66.0495, 198.134, 68.2201, 203.132)
    ..cubicTo(68.2201, 203.132, 77.248, 229.438, 77.248, 229.438)
    ..cubicTo(77.248, 229.438, 84.4998, 254.994, 84.4998, 254.994)
    ..cubicTo(84.4998, 254.994, 97.3262, 289.985, 97.3262, 289.985)
    ..cubicTo(97.3262, 289.985, 100.779, 296.233, 100.779, 296.233)
    ..cubicTo(100.779, 296.233, 104.726, 303.107, 104.726, 303.107)
    ..cubicTo(117.256, 312.854, 130.034, 317.665, 132.451, 337.348)
    ..cubicTo(132.451, 337.348, 133.438, 353.031, 133.438, 353.031);

  static final Path __path22_1_2 = Path()
    ..moveTo(94.451, 247.006)
    ..cubicTo(95.4381, 247.627, 110.441, 236.513, 125.049, 225.896)
    ..cubicTo(125.049, 225.896, 151.699, 207.456, 151.699, 207.456)
    ..cubicTo(151.699, 207.456, 165.024, 200.44, 165.024, 200.44)
    ..cubicTo(165.024, 200.44, 189.206, 188.022, 189.206, 188.022)
    ..cubicTo(189.206, 188.022, 209.933, 177.467, 209.933, 177.467)
    ..cubicTo(209.933, 177.467, 219.655, 172.562, 219.655, 172.562)
    ..cubicTo(219.655, 172.562, 221.778, 170.637, 221.778, 170.637)
    ..cubicTo(221.778, 170.637, 229.427, 159.15, 229.427, 159.15)
    ..cubicTo(229.427, 159.15, 231.154, 157.598, 231.154, 157.598)
    ..cubicTo(231.154, 157.598, 232.438, 156.977, 232.438, 156.977);

  static final Path __path22_1_3 = Path()
    ..moveTo(57.4375, 187.401)
    ..cubicTo(57.4375, 187.401, 75.204, 160.516, 75.204, 160.516);

  static final Path __path22_1_4 = Path()
    ..moveTo(179.438, 262.031)
    ..cubicTo(179.438, 262.031, 204.438, 308.81, 204.438, 308.81)
    ..cubicTo(204.438, 308.81, 216.637, 337.563, 216.637, 337.563)
    ..cubicTo(216.637, 337.563, 220.438, 353.031, 220.438, 353.031);

  static final Path __path22_1_5 = Path()
    ..moveTo(127.082, 279.969)
    ..cubicTo(127.082, 279.969, 136.234, 300.594, 136.234, 300.594)
    ..cubicTo(138.776, 308.094, 144.878, 315.594, 148.438, 324.344)
    ..cubicTo(150.776, 329.906, 153.878, 345.031, 154.437, 353.031)
    ..cubicTo(154.437, 353.031, 178.438, 353.031, 178.438, 353.031)
    ..cubicTo(178.438, 353.031, 157.082, 308.719, 157.082, 308.719)
    ..cubicTo(157.082, 308.719, 144.37, 273.719, 144.37, 273.719)
    ..cubicTo(144.37, 273.719, 124.438, 225.031, 124.438, 225.031);

  static final Path __path22_1_6 = Path()
    ..moveTo(144.438, 274.031)
    ..cubicTo(144.438, 274.031, 188.039, 258.982, 188.039, 258.982)
    ..cubicTo(188.039, 258.982, 206.165, 253.338, 206.165, 253.338)
    ..cubicTo(206.165, 253.338, 224.291, 247.068, 224.291, 247.068)
    ..cubicTo(231.15, 245.186, 241.437, 241.424, 241.437, 225.12)
    ..cubicTo(241.437, 225.12, 240.115, 213.206, 240.115, 213.206)
    ..cubicTo(240.115, 213.206, 235.069, 195.648, 235.069, 195.648)
    ..cubicTo(235.069, 195.648, 233.599, 186.87, 233.599, 186.87)
    ..cubicTo(233.599, 186.87, 232.766, 175.52, 232.766, 175.52)
    ..cubicTo(232.766, 175.52, 232.619, 162.414, 232.619, 162.414)
    ..cubicTo(232.619, 154.889, 231.15, 150.5, 227.867, 143.54)
    ..cubicTo(227.867, 143.54, 218.902, 118.52, 218.902, 118.52)
    ..cubicTo(218.902, 118.52, 216.943, 89.0478, 216.943, 89.0478)
    ..cubicTo(216.943, 89.0478, 214.983, 84.0312, 214.983, 84.0312);

  static final Path __path22_1_7 = Path()
    ..moveTo(179.339, 260.564)
    ..cubicTo(179.339, 260.564, 202.59, 302.424, 202.59, 302.424)
    ..cubicTo(202.59, 302.424, 210.999, 322.417, 210.999, 322.417)
    ..cubicTo(215.303, 333.726, 218.618, 343.16, 221.438, 353.031)
    ..cubicTo(221.438, 353.031, 221.438, 352.969, 221.438, 352.969)
    ..cubicTo(221.438, 352.969, 200.611, 302.424, 200.611, 302.424)
    ..cubicTo(200.611, 302.424, 181.318, 259.939, 181.318, 259.939)
    ..cubicTo(174.887, 242.445, 168.456, 233.699, 167.467, 206.833)
    ..cubicTo(166.972, 181.842, 172.908, 152.477, 176.866, 130.61)
    ..cubicTo(176.866, 130.61, 179.339, 113.741, 179.339, 113.741)
    ..cubicTo(179.339, 113.741, 187.749, 75.6295, 187.749, 75.6295)
    ..cubicTo(187.749, 75.6295, 192.201, 58.1357, 192.201, 58.1357)
    ..cubicTo(192.201, 58.1357, 195.169, 40.0171, 195.169, 40.0171)
    ..cubicTo(197.643, 29.3959, 200.116, 20.6489, 204.074, 14.4012)
    ..cubicTo(204.074, 14.4012, 216.936, 0.0312, 216.936, 0.0312);

  static final Path __path22_1_8 = Path()
    ..moveTo(180.438, 259.031)
    ..cubicTo(186.365, 257.156, 198.714, 254.031, 209.581, 250.281)
    ..cubicTo(209.581, 250.281, 227.363, 244.031, 227.363, 244.031)
    ..cubicTo(236.749, 242.156, 240.354, 236.781, 242.182, 229.656)
    ..cubicTo(243.17, 225.906, 241.244, 212.719, 237.243, 202.156)
    ..cubicTo(235.267, 196.531, 233.785, 191.531, 233.785, 172.781)
    ..cubicTo(234.032, 168.594, 234.328, 156.531, 231.809, 151.531)
    ..cubicTo(225.388, 150.281, 222.424, 149.656, 218.966, 147.156)
    ..cubicTo(208.099, 138.406, 192.786, 127.156, 191.305, 124.031)
    ..cubicTo(187.847, 119.031, 187.353, 108.406, 188.341, 100.281)
    ..cubicTo(188.341, 100.281, 193.33, 70.9062, 193.33, 70.9062)
    ..cubicTo(193.33, 70.9062, 194.268, 54.0312, 194.268, 54.0312);

  static final Path __path22_1_9 = Path()
    ..moveTo(180.734, 259.031)
    ..cubicTo(173.351, 240.925, 165.969, 228.438, 166.461, 188.479)
    ..cubicTo(166.461, 188.479, 168.922, 163.505, 168.922, 163.505)
    ..cubicTo(170.891, 153.516, 173.351, 140.404, 174.336, 132.288)
    ..cubicTo(174.336, 132.288, 179.258, 102.943, 179.258, 102.943)
    ..cubicTo(179.258, 102.943, 185.164, 73.5986, 185.164, 73.5986)
    ..cubicTo(185.164, 73.5986, 190.086, 54.2437, 190.086, 54.2437)
    ..cubicTo(190.086, 54.2437, 193.777, 35.2009, 193.777, 35.2009)
    ..cubicTo(193.777, 35.2009, 194.516, 32.3914, 194.516, 32.3914)
    ..cubicTo(195.5, 26.1478, 198.453, 19.9043, 199.437, 18.0312);

  static final Path __path22_1_10 = Path()
    ..moveTo(104.438, 307.031)
    ..cubicTo(104.438, 307.031, 109.855, 303.386, 109.855, 303.386)
    ..cubicTo(111.333, 299.74, 113.303, 294.272, 115.765, 290.019)
    ..cubicTo(115.765, 290.019, 127.437, 283.031, 127.437, 283.031);

  static final Path __path22_2_0 = Path()
    ..moveTo(70.4375, 235.705)
    ..cubicTo(70.4375, 235.705, 57.0806, 215.859, 57.0806, 215.859)
    ..cubicTo(57.0806, 215.859, 54.6566, 217.299, 54.6566, 217.299)
    ..cubicTo(54.6566, 217.299, 49.1654, 225.813, 49.1654, 225.813)
    ..cubicTo(49.1654, 225.813, 63.5117, 243.155, 63.5117, 243.155)
    ..cubicTo(63.5117, 243.155, 65.9357, 244.031, 65.9357, 244.031)
    ..cubicTo(65.9357, 244.031, 70.4375, 235.705, 70.4375, 235.705)
    ..close();

  static final Path __path22_2_1 = Path()
    ..moveTo(107.604, 252.031)
    ..cubicTo(107.604, 252.031, 98.4375, 258.753, 98.4375, 258.753)
    ..cubicTo(98.4375, 258.753, 101.188, 263.031, 101.188, 263.031)
    ..cubicTo(101.188, 263.031, 109.438, 256.92, 109.438, 256.92)
    ..cubicTo(109.438, 256.92, 107.604, 252.031, 107.604, 252.031)
    ..close();

  static final Path __path22_2_2 = Path()
    ..moveTo(154.938, 164.031)
    ..cubicTo(154.938, 164.031, 164.438, 175.81, 164.438, 175.81)
    ..cubicTo(164.438, 175.81, 163.938, 185.729, 163.938, 185.729)
    ..cubicTo(163.938, 185.729, 155.988, 187.031, 155.988, 187.031)
    ..cubicTo(155.988, 187.031, 147.438, 174.57, 147.438, 174.57)
    ..cubicTo(147.438, 174.57, 154.938, 164.031, 154.938, 164.031)
    ..close();

  static final Path __path22_2_3 = Path()
    ..moveTo(242.438, 164.713)
    ..cubicTo(242.438, 164.713, 242.691, 174.598, 242.691, 174.598)
    ..cubicTo(244.717, 175.873, 247.757, 173.96, 248.517, 173.641)
    ..cubicTo(248.517, 173.641, 251.811, 172.685, 251.811, 172.685)
    ..cubicTo(251.811, 172.685, 261.437, 172.047, 261.437, 172.047)
    ..cubicTo(261.437, 172.047, 259.917, 165.032, 259.917, 165.032)
    ..cubicTo(255.357, 163.757, 246.237, 163.757, 242.438, 164.713)
    ..cubicTo(242.438, 164.713, 242.438, 164.713, 242.438, 164.713)
    ..close();

  static final Path __path22_2_4 = Path()
    ..moveTo(263.917, 237.093)
    ..cubicTo(263.917, 237.093, 262.009, 242.742, 262.009, 242.742)
    ..cubicTo(262.009, 242.742, 263.917, 249.018, 263.917, 249.018)
    ..cubicTo(263.917, 249.018, 263.44, 252.783, 263.44, 252.783)
    ..cubicTo(263.44, 252.783, 260.578, 257.176, 260.578, 257.176)
    ..cubicTo(260.578, 260.942, 261.055, 262.825, 258.67, 264.707)
    ..cubicTo(258.67, 264.707, 256.762, 263.452, 256.762, 263.452)
    ..cubicTo(256.762, 263.452, 256.285, 265.963, 256.285, 265.963)
    ..cubicTo(258.193, 270.356, 256.285, 272.866, 256.285, 274.749)
    ..cubicTo(254.378, 279.77, 256.285, 281.025, 256.285, 281.652)
    ..cubicTo(260.101, 283.535, 262.963, 280.397, 266.302, 279.142)
    ..cubicTo(266.302, 279.142, 269.164, 281.025, 269.164, 281.025)
    ..cubicTo(269.164, 281.025, 269.164, 284.163, 269.164, 284.163)
    ..cubicTo(269.164, 284.163, 267.733, 286.673, 267.733, 286.673)
    ..cubicTo(267.733, 286.673, 264.871, 290.439, 264.871, 290.439)
    ..cubicTo(264.871, 290.439, 265.348, 293.577, 265.348, 293.577)
    ..cubicTo(265.348, 293.577, 266.779, 296.714, 266.779, 296.714)
    ..cubicTo(266.779, 296.714, 269.641, 299.225, 269.641, 299.225)
    ..cubicTo(271.549, 301.735, 273.934, 303.618, 274.888, 306.756)
    ..cubicTo(274.888, 306.756, 276.319, 310.521, 276.319, 310.521)
    ..cubicTo(276.319, 310.521, 279.181, 310.521, 279.181, 310.521)
    ..cubicTo(279.181, 310.521, 281.089, 309.266, 281.089, 309.266)
    ..cubicTo(283.474, 311.149, 284.904, 314.915, 283.474, 318.68)
    ..cubicTo(282.997, 321.19, 282.52, 324.328, 283.951, 326.211)
    ..cubicTo(283.951, 326.211, 285.858, 326.839, 285.858, 326.839)
    ..cubicTo(285.858, 326.839, 288.243, 325.584, 288.243, 325.584)
    ..cubicTo(288.243, 325.584, 290.437, 328.031, 290.437, 328.031)
    ..cubicTo(290.437, 328.031, 290.437, 250.9, 290.437, 250.9)
    ..cubicTo(290.437, 250.9, 288.243, 250.273, 288.243, 250.273)
    ..cubicTo(288.243, 250.273, 285.858, 246.507, 285.858, 246.507)
    ..cubicTo(285.858, 246.507, 283.951, 245.252, 283.951, 245.252)
    ..cubicTo(283.951, 245.252, 282.52, 245.252, 282.52, 245.252)
    ..cubicTo(282.52, 245.252, 280.612, 243.997, 280.612, 243.997)
    ..cubicTo(280.612, 243.997, 283.474, 242.742, 283.474, 242.742)
    ..cubicTo(283.474, 242.742, 282.043, 240.231, 282.043, 240.231)
    ..cubicTo(282.043, 240.231, 280.135, 240.231, 280.135, 240.231)
    ..cubicTo(280.135, 240.231, 278.704, 238.349, 278.704, 238.349)
    ..cubicTo(278.704, 238.349, 277.75, 236.466, 277.75, 236.466)
    ..cubicTo(277.75, 236.466, 276.796, 231.445, 276.796, 231.445)
    ..cubicTo(277.75, 229.562, 276.319, 227.052, 275.365, 225.797)
    ..cubicTo(275.365, 225.797, 273.934, 225.797, 273.934, 225.797)
    ..cubicTo(273.934, 225.797, 272.98, 224.542, 272.98, 224.542)
    ..cubicTo(272.98, 224.542, 272.98, 222.031, 272.98, 222.031)
    ..cubicTo(272.98, 222.031, 269.164, 225.797, 269.164, 225.797)
    ..cubicTo(269.164, 225.797, 270.595, 229.562, 270.595, 229.562)
    ..cubicTo(270.595, 234.144, 268.687, 237.093, 267.256, 237.093)
    ..cubicTo(267.256, 237.093, 266.779, 237.093, 266.779, 237.093)
    ..cubicTo(266.779, 237.093, 263.917, 237.093, 263.917, 237.093)
    ..cubicTo(263.917, 237.093, 263.917, 237.093, 263.917, 237.093)
    ..close();

  static final Path __path22_2_5 = Path()
    ..moveTo(263.259, 168.893)
    ..cubicTo(263.259, 168.893, 266.681, 171.997, 266.681, 171.997)
    ..cubicTo(271.08, 171.997, 274.502, 174.48, 276.457, 177.583)
    ..cubicTo(276.457, 177.583, 278.901, 181.928, 278.901, 181.928)
    ..cubicTo(278.901, 181.928, 281.834, 185.031, 281.834, 185.031)
    ..cubicTo(281.834, 185.031, 284.767, 186.893, 284.767, 186.893)
    ..cubicTo(284.767, 186.893, 290.438, 194.342, 290.438, 194.342)
    ..cubicTo(290.438, 194.342, 290.438, 221.031, 290.438, 221.031)
    ..cubicTo(290.438, 221.031, 286.722, 216.686, 286.722, 216.686)
    ..cubicTo(284.278, 213.583, 283.301, 211.1, 278.412, 209.859)
    ..cubicTo(278.412, 209.859, 277.924, 207.997, 277.924, 207.997)
    ..cubicTo(277.924, 207.997, 273.524, 207.376, 273.524, 207.376)
    ..cubicTo(273.524, 207.376, 274.013, 203.652, 274.013, 203.652)
    ..cubicTo(274.013, 203.652, 273.524, 201.79, 273.524, 201.79)
    ..cubicTo(273.524, 201.79, 269.125, 199.307, 269.125, 199.307)
    ..cubicTo(269.125, 199.307, 267.658, 194.342, 267.658, 194.342)
    ..cubicTo(267.658, 194.342, 266.192, 191.859, 266.192, 191.859)
    ..cubicTo(266.192, 191.859, 263.748, 189.997, 263.748, 189.997)
    ..cubicTo(263.748, 189.997, 263.748, 188.135, 263.748, 188.135)
    ..cubicTo(263.748, 188.135, 262.281, 188.135, 262.281, 188.135)
    ..cubicTo(262.281, 188.135, 259.348, 190.617, 259.348, 190.617)
    ..cubicTo(259.348, 190.617, 259.348, 183.169, 259.348, 183.169)
    ..cubicTo(259.348, 183.169, 259.837, 183.169, 259.837, 183.169)
    ..cubicTo(259.837, 183.169, 260.815, 180.066, 260.815, 180.066)
    ..cubicTo(260.815, 180.066, 260.326, 178.824, 260.326, 178.824)
    ..cubicTo(260.326, 178.824, 260.326, 177.583, 260.326, 177.583)
    ..cubicTo(260.326, 177.583, 259.788, 175.969, 259.788, 175.969)
    ..cubicTo(259.788, 175.969, 260.326, 176.962, 260.326, 176.962)
    ..cubicTo(260.326, 176.962, 260.326, 176.342, 260.326, 176.342)
    ..cubicTo(260.326, 176.342, 259.348, 175.1, 259.348, 175.1)
    ..cubicTo(259.348, 175.1, 260.277, 173.673, 260.277, 173.673)
    ..cubicTo(260.277, 173.673, 259.348, 173.859, 259.348, 173.859)
    ..cubicTo(259.348, 173.859, 257.882, 172.617, 257.882, 172.617)
    ..cubicTo(257.882, 172.617, 256.415, 172.617, 256.415, 172.617)
    ..cubicTo(256.415, 172.617, 255.438, 172.617, 255.438, 172.617)
    ..cubicTo(255.438, 172.617, 256.904, 167.652, 256.904, 167.652)
    ..cubicTo(256.904, 167.652, 258.859, 167.031, 258.859, 167.031)
    ..cubicTo(258.859, 167.031, 263.259, 168.893, 263.259, 168.893)
    ..cubicTo(263.259, 168.893, 263.259, 168.893, 263.259, 168.893)
    ..close();

  static final Path __path22_3_0 = Path()
    ..moveTo(0.4375, 352.969)
    ..cubicTo(0.4375, 352.969, 0.4375, 138.031, 0.4375, 138.031)
    ..cubicTo(0.4375, 138.031, 3.4054, 141.965, 3.4054, 141.965)
    ..cubicTo(9.2918, 149.709, 13.1006, 156.328, 17.4535, 162.572)
    ..cubicTo(17.4535, 162.572, 23.884, 173.813, 23.884, 173.813)
    ..cubicTo(23.884, 173.813, 39.1688, 210.718, 39.1688, 210.718)
    ..cubicTo(44.1648, 226.204, 65.9295, 249.372, 65.9295, 249.372)
    ..cubicTo(65.9295, 249.372, 77.8011, 268.23, 85.4682, 285.59)
    ..cubicTo(93.1354, 302.95, 111.438, 353.031, 111.438, 353.031)
    ..cubicTo(111.438, 353.031, 0.4375, 352.969, 0.4375, 352.969)
    ..cubicTo(0.4375, 352.969, 0.4375, 352.969, 0.4375, 352.969)
    ..close();

  static final Path __path22_4_0 = Path()
    ..moveTo(42, 0)
    ..cubicTo(42, 0, 248.427, 0, 248.427, 0)
    ..cubicTo(271.623, 0, 290.427, 18.804, 290.427, 42)
    ..cubicTo(290.427, 42, 290.427, 310.662, 290.427, 310.662)
    ..cubicTo(290.427, 333.858, 271.623, 352.662, 248.427, 352.662)
    ..cubicTo(248.427, 352.662, 42, 352.662, 42, 352.662)
    ..cubicTo(18.804, 352.662, 0, 333.858, 0, 310.662)
    ..cubicTo(0, 310.662, 0, 42, 0, 42)
    ..cubicTo(0, 18.804, 18.804, 0, 42, 0)
    ..close();

  static final Path __maskPath22_0 = Path()
    ..moveTo(42, 0)
    ..cubicTo(42, 0, 248.427, 0, 248.427, 0)
    ..cubicTo(271.623, 0, 290.427, 18.804, 290.427, 42)
    ..cubicTo(290.427, 42, 290.427, 310.662, 290.427, 310.662)
    ..cubicTo(290.427, 333.858, 271.623, 352.662, 248.427, 352.662)
    ..cubicTo(248.427, 352.662, 42, 352.662, 42, 352.662)
    ..cubicTo(18.804, 352.662, 0, 333.858, 0, 310.662)
    ..cubicTo(0, 310.662, 0, 42, 0, 42)
    ..cubicTo(0, 18.804, 18.804, 0, 42, 0)
    ..close();

  static final Path __path27_0_0 = Path()
    ..moveTo(44, 10)
    ..cubicTo(44, 10, 247, 10, 247, 10)
    ..cubicTo(265.2254, 10, 280, 24.7746, 280, 43)
    ..cubicTo(280, 43, 280, 136.045, 280, 136.045)
    ..cubicTo(280, 154.2704, 265.2254, 169.045, 247, 169.045)
    ..cubicTo(247, 169.045, 44, 169.045, 44, 169.045)
    ..cubicTo(25.7746, 169.045, 11, 154.2704, 11, 136.045)
    ..cubicTo(11, 136.045, 11, 43, 11, 43)
    ..cubicTo(11, 24.7746, 25.7746, 10, 44, 10)
    ..close();

  static final Path __path27_1_0 = Path()
    ..moveTo(291.566, 177.422)
    ..cubicTo(291.519, 177.544, 291.498, 177.669, 291.498, 177.797)
    ..cubicTo(291.498, 177.797, 291.498, 185.173, 291.498, 185.173)
    ..cubicTo(290.737, 183.766, 289.98, 182.323, 289.219, 180.851)
    ..cubicTo(289.223, 180.848, 289.223, 180.844, 289.226, 180.84)
    ..cubicTo(289.226, 180.84, 290.991, 173.275, 290.991, 173.275)
    ..cubicTo(291.873, 172.85, 292.748, 172.425, 293.623, 171.997)
    ..cubicTo(293.623, 171.997, 291.566, 177.422, 291.566, 177.422)
    ..cubicTo(291.566, 177.422, 291.566, 177.422, 291.566, 177.422)
    ..close();

  static final Path __path27_1_1 = Path()
    ..moveTo(278.272, 179.13)
    ..cubicTo(279.497, 178.587, 280.715, 178.04, 281.929, 177.487)
    ..cubicTo(281.929, 177.487, 286.901, 180.983, 286.901, 180.983)
    ..cubicTo(287.64, 182.426, 288.38, 183.833, 289.119, 185.219)
    ..cubicTo(289.119, 185.219, 278.272, 179.13, 278.272, 179.13)
    ..cubicTo(278.272, 179.13, 278.272, 179.13, 278.272, 179.13)
    ..close();

  static final Path __path27_1_2 = Path()
    ..moveTo(212.688, 203.035)
    ..cubicTo(212.266, 203.196, 211.841, 203.357, 211.416, 203.517)
    ..cubicTo(216.949, 201.203, 222.924, 198.681, 229.311, 195.977)
    ..cubicTo(235.854, 193.206, 240.583, 191.202, 242.055, 190.641)
    ..cubicTo(243.823, 189.941, 246.244, 189.002, 249.098, 187.891)
    ..cubicTo(255.541, 185.387, 264.449, 181.926, 273.078, 178.419)
    ..cubicTo(273.171, 178.612, 273.314, 178.776, 273.511, 178.887)
    ..cubicTo(273.511, 178.887, 273.536, 178.901, 273.536, 178.901)
    ..cubicTo(253.727, 187.548, 232.957, 195.392, 212.688, 203.035)
    ..cubicTo(212.688, 203.035, 212.688, 203.035, 212.688, 203.035)
    ..close();

  static final Path __path27_1_3 = Path()
    ..moveTo(167.209, 228.055)
    ..cubicTo(167.02, 228.184, 166.877, 228.366, 166.798, 228.58)
    ..cubicTo(166.798, 228.58, 164.084, 236.241, 164.084, 236.241)
    ..cubicTo(164.009, 236.445, 164.002, 236.666, 164.059, 236.874)
    ..cubicTo(164.059, 236.874, 176.66, 282.824, 176.66, 282.824)
    ..cubicTo(176.714, 283.017, 176.821, 283.192, 176.967, 283.327)
    ..cubicTo(176.967, 283.327, 183.003, 288.828, 183.003, 288.828)
    ..cubicTo(183.003, 288.828, 177.881, 286.613, 177.881, 286.613)
    ..cubicTo(174.595, 277.566, 171.524, 266.633, 167.252, 251.41)
    ..cubicTo(165.223, 244.188, 162.837, 235.695, 160.016, 225.94)
    ..cubicTo(168.588, 222.337, 177.246, 218.879, 185.929, 215.507)
    ..cubicTo(185.929, 215.507, 167.209, 228.055, 167.209, 228.055)
    ..cubicTo(167.209, 228.055, 167.209, 228.055, 167.209, 228.055)
    ..close();

  static final Path __path27_1_4 = Path()
    ..moveTo(237.472, 369.534)
    ..cubicTo(219.171, 351.458, 206.102, 336.474, 196.369, 322.966)
    ..cubicTo(203.973, 332.453, 214.292, 343.871, 229.153, 360.323)
    ..cubicTo(231.779, 363.23, 234.554, 366.298, 237.472, 369.534)
    ..cubicTo(237.472, 369.534, 237.472, 369.534, 237.472, 369.534)
    ..close();

  static final Path __path27_1_5 = Path()
    ..moveTo(178.91, 289.371)
    ..cubicTo(178.91, 289.371, 187.389, 293.032, 187.389, 293.032)
    ..cubicTo(187.389, 293.032, 183.032, 298.843, 183.032, 298.843)
    ..cubicTo(181.55, 295.835, 180.203, 292.724, 178.91, 289.371)
    ..cubicTo(178.91, 289.371, 178.91, 289.371, 178.91, 289.371)
    ..close();

  static final Path __path27_1_6 = Path()
    ..moveTo(180.56, 301.657)
    ..cubicTo(180.56, 301.657, 173.128, 297.939, 173.128, 297.939)
    ..cubicTo(173.128, 297.939, 174.892, 289.781, 174.892, 289.781)
    ..cubicTo(176.589, 293.721, 178.46, 297.661, 180.56, 301.657)
    ..cubicTo(180.56, 301.657, 180.56, 301.657, 180.56, 301.657)
    ..close();

  static final Path __path27_1_7 = Path()
    ..moveTo(162.416, 244.849)
    ..cubicTo(162.441, 244.596, 162.373, 244.349, 162.219, 244.135)
    ..cubicTo(160.698, 238.695, 159.112, 233.041, 157.362, 227.069)
    ..cubicTo(157.591, 226.973, 157.819, 226.873, 158.048, 226.776)
    ..cubicTo(160.837, 236.42, 163.198, 244.828, 165.209, 251.985)
    ..cubicTo(168.727, 264.508, 171.435, 274.148, 174.11, 282.231)
    ..cubicTo(173.231, 279.959, 172.399, 277.68, 171.599, 275.38)
    ..cubicTo(171.599, 275.38, 171.577, 274.369, 171.577, 274.369)
    ..cubicTo(171.567, 273.937, 171.299, 273.569, 170.924, 273.412)
    ..cubicTo(167.913, 264.508, 165.327, 255.261, 162.48, 245.074)
    ..cubicTo(162.459, 244.999, 162.437, 244.924, 162.416, 244.849)
    ..cubicTo(162.416, 244.849, 162.416, 244.849, 162.416, 244.849)
    ..close();

  static final Path __path27_1_8 = Path()
    ..moveTo(151.258, 233.127)
    ..cubicTo(150.997, 232.87, 150.626, 232.762, 150.265, 232.845)
    ..cubicTo(150.265, 232.845, 137.925, 235.72, 137.925, 235.72)
    ..cubicTo(143.689, 233.027, 149.522, 230.427, 155.398, 227.908)
    ..cubicTo(156.726, 232.445, 157.958, 236.798, 159.144, 241.013)
    ..cubicTo(159.144, 241.013, 151.258, 233.127, 151.258, 233.127)
    ..cubicTo(151.258, 233.127, 151.258, 233.127, 151.258, 233.127)
    ..close();

  static final Path __path27_1_9 = Path()
    ..moveTo(61.9603, 286.024)
    ..cubicTo(61.9603, 286.024, 57.6378, 293.532, 57.6378, 293.532)
    ..cubicTo(55.9416, 294.125, 50.1365, 296.16, 47.5041, 297.157)
    ..cubicTo(52.0359, 292.378, 56.7642, 287.842, 61.6721, 283.527)
    ..cubicTo(61.6721, 283.527, 61.9603, 286.024, 61.9603, 286.024)
    ..cubicTo(61.9603, 286.024, 61.9603, 286.024, 61.9603, 286.024)
    ..close();

  static final Path __path27_1_10 = Path()
    ..moveTo(3.8756, 339.539)
    ..cubicTo(3.8756, 339.539, -5.4162, 338.553, -5.4162, 338.553)
    ..cubicTo(-4.5919, 338.1, -3.7736, 337.642, -2.955, 337.182)
    ..cubicTo(-2.955, 337.182, 2.2287, 338.664, 2.2287, 338.664)
    ..cubicTo(2.2287, 338.664, 4.8003, 332.663, 4.8003, 332.663)
    ..cubicTo(5.4857, 332.249, 6.1697, 331.831, 6.8501, 331.41)
    ..cubicTo(6.8501, 331.41, 3.8756, 339.539, 3.8756, 339.539)
    ..cubicTo(3.8756, 339.539, 3.8756, 339.539, 3.8756, 339.539)
    ..close();

  static final Path __path27_1_11 = Path()
    ..moveTo(-107.606, 267.769)
    ..cubicTo(-63.8352, 248.114, -13.7555, 225.126, 16.6077, 209.207)
    ..cubicTo(16.6723, 209.171, 16.7334, 209.132, 16.7902, 209.086)
    ..cubicTo(22.3678, 204.478, 41.5143, 178.955, 52.9542, 163.703)
    ..cubicTo(56.1445, 159.449, 58.6707, 156.081, 60.0651, 154.285)
    ..cubicTo(60.0933, 154.256, 60.1248, 154.224, 60.1534, 154.195)
    ..cubicTo(61.5746, 155.688, 63.0022, 157.163, 64.4419, 158.617)
    ..cubicTo(64.4419, 158.617, 64.4884, 158.571, 64.4884, 158.571)
    ..cubicTo(64.9406, 158.996, 65.8188, 159.635, 67.4018, 160.785)
    ..cubicTo(67.4018, 160.785, 82.6877, 171.904, 82.6877, 171.904)
    ..cubicTo(82.8123, 171.993, 82.9549, 172.058, 83.1063, 172.086)
    ..cubicTo(83.1063, 172.086, 104.846, 176.369, 104.846, 176.369)
    ..cubicTo(104.913, 176.383, 104.982, 176.386, 105.051, 176.386)
    ..cubicTo(105.085, 176.386, 105.12, 176.386, 105.154, 176.383)
    ..cubicTo(105.154, 176.383, 121.952, 174.736, 121.952, 174.736)
    ..cubicTo(122.009, 174.729, 122.066, 174.718, 122.123, 174.704)
    ..cubicTo(122.506, 174.604, 122.891, 174.497, 123.274, 174.397)
    ..cubicTo(123.274, 174.397, 140.107, 183.826, 140.107, 183.826)
    ..cubicTo(140.271, 183.919, 140.45, 183.962, 140.625, 183.962)
    ..cubicTo(140.689, 183.962, 140.754, 183.951, 140.818, 183.937)
    ..cubicTo(143.747, 191.759, 146.293, 199.035, 148.551, 205.864)
    ..cubicTo(148.551, 205.864, 149.676, 220.115, 149.676, 220.115)
    ..cubicTo(149.676, 220.115, 147.943, 224.237, 147.943, 224.237)
    ..cubicTo(147.943, 224.237, 124.291, 237.445, 124.291, 237.445)
    ..cubicTo(108.615, 244.678, 94.2869, 252.353, 80.5218, 262.29)
    ..cubicTo(80.4825, 262.215, 80.4529, 262.136, 80.3943, 262.072)
    ..cubicTo(80.0028, 261.636, 79.3328, 261.6, 78.8967, 261.993)
    ..cubicTo(75.4928, 265.047, 67.8604, 271.93, 66.3639, 273.526)
    ..cubicTo(66.3485, 273.541, 66.3332, 273.551, 66.3178, 273.566)
    ..cubicTo(65.1509, 273.934, 59.1818, 274.359, 53.8714, 274.566)
    ..cubicTo(53.4824, 274.584, 53.1503, 274.812, 52.9785, 275.148)
    ..cubicTo(52.9785, 275.148, 51.6187, 275.084, 51.6187, 275.084)
    ..cubicTo(51.6187, 275.084, 51.3023, 281.724, 51.3023, 281.724)
    ..cubicTo(51.3023, 281.724, 39.2624, 300.922, 39.2624, 300.922)
    ..cubicTo(39.2624, 300.922, 39.3638, 300.986, 39.3638, 300.986)
    ..cubicTo(29.8502, 310.147, 19.0815, 318.244, 7.553, 325.531)
    ..cubicTo(7.553, 325.531, -6.6656, 321.598, -6.6656, 321.598)
    ..cubicTo(-6.6656, 321.598, -11.1928, 336.385, -11.1928, 336.385)
    ..cubicTo(-21.3664, 341.814, -31.883, 346.779, -42.4592, 351.415)
    ..cubicTo(-42.4592, 351.415, -56.7279, 346.361, -56.7279, 346.361)
    ..cubicTo(-56.7279, 346.361, -61.8686, 340.578, -61.8686, 340.578)
    ..cubicTo(-61.8686, 340.578, -62.5894, 338.375, -62.5894, 338.375)
    ..cubicTo(-62.6141, 338.3, -62.6462, 338.228, -62.6862, 338.164)
    ..cubicTo(-74.3675, 318.562, -90.3624, 294.025, -107.606, 267.769)
    ..cubicTo(-107.606, 267.769, -107.606, 267.769, -107.606, 267.769)
    ..close();

  static final Path __path27_1_12 = Path()
    ..moveTo(-114.264, 257.636)
    ..cubicTo(-138.626, 220.576, -163.765, 182.33, -180.425, 153.049)
    ..cubicTo(-127.44, 119.343, -71.4316, 82.5217, -19.047, 47.9475)
    ..cubicTo(-18.0837, 49.3941, -17.1179, 50.8442, -16.1435, 52.3086)
    ..cubicTo(7.1659, 87.3329, 31.2178, 123.475, 58.6908, 152.66)
    ..cubicTo(58.6315, 152.72, 58.5672, 152.785, 58.5086, 152.845)
    ..cubicTo(58.4804, 152.874, 58.4536, 152.906, 58.4282, 152.938)
    ..cubicTo(57.031, 154.735, 54.4833, 158.131, 51.258, 162.432)
    ..cubicTo(40.6754, 176.54, 21.0227, 202.739, 15.5226, 207.382)
    ..cubicTo(-14.8756, 223.312, -65.016, 246.324, -108.785, 265.972)
    ..cubicTo(-110.601, 263.208, -112.426, 260.433, -114.264, 257.636)
    ..cubicTo(-114.264, 257.636, -114.264, 257.636, -114.264, 257.636)
    ..close();

  static final Path __path27_1_13 = Path()
    ..moveTo(289.666, 169.068)
    ..cubicTo(289.666, 169.068, 281.776, 164.839, 281.776, 164.839)
    ..cubicTo(281.64, 164.768, 281.497, 164.732, 281.347, 164.721)
    ..cubicTo(280.886, 163.732, 280.425, 162.735, 279.961, 161.732)
    ..cubicTo(279.961, 161.732, 291.83, 168.061, 291.83, 168.061)
    ..cubicTo(291.141, 168.386, 290.419, 168.722, 289.666, 169.068)
    ..cubicTo(289.666, 169.068, 289.666, 169.068, 289.666, 169.068)
    ..close();

  static final Path __path27_1_14 = Path()
    ..moveTo(159.012, 222.487)
    ..cubicTo(158.43, 220.486, 157.83, 218.436, 157.208, 216.336)
    ..cubicTo(158.848, 217.118, 161.223, 218.129, 164.352, 219.419)
    ..cubicTo(164.727, 219.576, 165.059, 219.711, 165.359, 219.836)
    ..cubicTo(163.22, 220.729, 161.102, 221.615, 159.012, 222.487)
    ..cubicTo(159.012, 222.487, 159.012, 222.487, 159.012, 222.487)
    ..close();

  static final Path __path27_1_15 = Path()
    ..moveTo(99.9752, 114.046)
    ..cubicTo(103.085, 116.514, 106.23, 119.096, 109.28, 121.761)
    ..cubicTo(109.28, 121.761, 107.304, 125.961, 107.304, 125.961)
    ..cubicTo(107.111, 126.365, 107.197, 126.847, 107.512, 127.161)
    ..cubicTo(107.512, 127.161, 109.983, 129.633, 109.983, 129.633)
    ..cubicTo(110.187, 129.836, 110.455, 129.943, 110.733, 129.943)
    ..cubicTo(110.851, 129.943, 110.969, 129.926, 111.083, 129.883)
    ..cubicTo(111.083, 129.883, 116.023, 128.154, 116.023, 128.154)
    ..cubicTo(116.066, 128.14, 116.101, 128.122, 116.141, 128.1)
    ..cubicTo(121.27, 133.151, 125.745, 138.391, 128.77, 143.627)
    ..cubicTo(129.438, 145.973, 130.481, 149.481, 131.628, 153.327)
    ..cubicTo(131.628, 153.327, 131.21, 159.992, 131.21, 159.992)
    ..cubicTo(131.21, 159.992, 123.191, 172.022, 123.191, 172.022)
    ..cubicTo(123.141, 172.097, 123.106, 172.172, 123.077, 172.254)
    ..cubicTo(122.606, 172.379, 122.131, 172.508, 121.659, 172.633)
    ..cubicTo(121.659, 172.633, 105.103, 174.258, 105.103, 174.258)
    ..cubicTo(105.103, 174.258, 83.7456, 170.05, 83.7456, 170.05)
    ..cubicTo(81.8912, 168.704, 67.0107, 157.878, 65.8881, 157.063)
    ..cubicTo(64.4623, 155.624, 63.0483, 154.16, 61.6407, 152.681)
    ..cubicTo(71.8172, 142.334, 91.4174, 122.561, 99.9752, 114.046)
    ..cubicTo(99.9752, 114.046, 99.9752, 114.046, 99.9752, 114.046)
    ..close();

  static final Path __path27_1_16 = Path()
    ..moveTo(140.639, 176.665)
    ..cubicTo(140.639, 176.665, 143.825, 168.7, 143.825, 168.7)
    ..cubicTo(144.518, 168.504, 145.215, 168.304, 145.915, 168.107)
    ..cubicTo(145.915, 168.107, 142.589, 180.18, 142.589, 180.18)
    ..cubicTo(141.907, 178.858, 141.254, 177.672, 140.639, 176.665)
    ..cubicTo(140.639, 176.665, 140.639, 176.665, 140.639, 176.665)
    ..close();

  static final Path __path27_1_17 = Path()
    ..moveTo(151.369, 214.6)
    ..cubicTo(152.429, 217.979, 153.426, 221.247, 154.372, 224.426)
    ..cubicTo(151.054, 225.812, 147.804, 227.173, 144.611, 228.523)
    ..cubicTo(144.611, 228.523, 149.293, 225.908, 149.293, 225.908)
    ..cubicTo(149.501, 225.794, 149.665, 225.612, 149.754, 225.394)
    ..cubicTo(149.754, 225.394, 151.733, 220.701, 151.733, 220.701)
    ..cubicTo(151.797, 220.544, 151.826, 220.376, 151.812, 220.204)
    ..cubicTo(151.812, 220.204, 151.369, 214.6, 151.369, 214.6)
    ..cubicTo(151.369, 214.6, 151.369, 214.6, 151.369, 214.6)
    ..close();

  static final Path __path27_1_18 = Path()
    ..moveTo(63.1886, 279.234)
    ..cubicTo(64.6452, 277.888, 66.1049, 276.584, 67.5675, 275.309)
    ..cubicTo(67.6786, 275.237, 67.7454, 275.173, 67.794, 275.112)
    ..cubicTo(84.5597, 260.54, 101.804, 250.442, 121.048, 241.31)
    ..cubicTo(121.148, 241.342, 121.252, 241.36, 121.355, 241.36)
    ..cubicTo(121.445, 241.36, 121.53, 241.349, 121.616, 241.327)
    ..cubicTo(100.701, 252.039, 80.9201, 264.365, 63.2608, 279.37)
    ..cubicTo(63.2383, 279.323, 63.2176, 279.277, 63.1886, 279.234)
    ..cubicTo(63.1886, 279.234, 63.1886, 279.234, 63.1886, 279.234)
    ..close();

  static final Path __path27_1_19 = Path()
    ..moveTo(53.3939, 282.377)
    ..cubicTo(53.3939, 282.377, 53.6653, 276.687, 53.6653, 276.687)
    ..cubicTo(53.6653, 276.687, 59.6183, 279.666, 59.6183, 279.666)
    ..cubicTo(55.3255, 283.749, 51.048, 288.156, 46.7612, 292.957)
    ..cubicTo(46.7612, 292.957, 53.3939, 282.377, 53.3939, 282.377)
    ..cubicTo(53.3939, 282.377, 53.3939, 282.377, 53.3939, 282.377)
    ..close();

  static final Path __path27_1_20 = Path()
    ..moveTo(-3.6818, 325.341)
    ..cubicTo(-3.6818, 325.341, -5.8745, 333.485, -5.8745, 333.485)
    ..cubicTo(-6.7614, 333.978, -7.6464, 334.474, -8.539, 334.96)
    ..cubicTo(-8.539, 334.96, -5.2423, 324.191, -5.2423, 324.191)
    ..cubicTo(-5.2423, 324.191, 5.1018, 327.052, 5.1018, 327.052)
    ..cubicTo(4.3428, 327.52, 3.5842, 327.988, 2.8191, 328.449)
    ..cubicTo(2.8191, 328.449, -3.6818, 325.341, -3.6818, 325.341)
    ..cubicTo(-3.6818, 325.341, -3.6818, 325.341, -3.6818, 325.341)
    ..close();

  static final Path __path27_1_21 = Path()
    ..moveTo(248.33, 185.916)
    ..cubicTo(245.469, 187.027, 243.047, 187.97, 241.287, 188.666)
    ..cubicTo(239.79, 189.234, 235.047, 191.245, 228.486, 194.024)
    ..cubicTo(211.302, 201.303, 171.331, 218.233, 167.063, 218.254)
    ..cubicTo(166.652, 218.076, 165.981, 217.797, 165.163, 217.461)
    ..cubicTo(163.03, 216.579, 157.551, 214.318, 156.348, 213.479)
    ..cubicTo(153.683, 206.028, 148.479, 192.388, 144.004, 183.037)
    ..cubicTo(144.004, 183.037, 148.301, 167.425, 148.301, 167.425)
    ..cubicTo(156.151, 165.186, 164.295, 162.825, 172.66, 160.403)
    ..cubicTo(204.855, 151.077, 238.111, 141.448, 265.849, 135.269)
    ..cubicTo(269.717, 144.091, 273.493, 152.695, 277.218, 160.839)
    ..cubicTo(277.218, 160.839, 273.428, 175.99, 273.428, 175.99)
    ..cubicTo(264.471, 179.64, 255.056, 183.301, 248.33, 185.916)
    ..cubicTo(248.33, 185.916, 248.33, 185.916, 248.33, 185.916)
    ..close();

  static final Path __path27_1_22 = Path()
    ..moveTo(397.61, 64.4882)
    ..cubicTo(397.61, 64.4882, 395.003, 47.869, 395.003, 47.869)
    ..cubicTo(395.003, 47.869, 396.946, 37.5074, 396.946, 37.5074)
    ..cubicTo(396.992, 37.2645, 396.949, 37.0145, 396.831, 36.7967)
    ..cubicTo(396.831, 36.7967, 395.181, 33.8321, 395.181, 33.8321)
    ..cubicTo(394.995, 33.4964, 394.642, 33.2892, 394.256, 33.2892)
    ..cubicTo(394.256, 33.2892, 388.984, 33.2892, 388.984, 33.2892)
    ..cubicTo(388.838, 33.2892, 388.688, 33.3214, 388.552, 33.3821)
    ..cubicTo(388.552, 33.3821, 379.001, 37.6646, 379.001, 37.6646)
    ..cubicTo(378.708, 37.7932, 378.494, 38.0467, 378.412, 38.3503)
    ..cubicTo(378.412, 38.3503, 377.423, 41.9756, 377.423, 41.9756)
    ..cubicTo(377.33, 42.3221, 377.415, 42.6935, 377.658, 42.9614)
    ..cubicTo(380.009, 45.5831, 385.212, 50.2656, 388.266, 52.2729)
    ..cubicTo(388.709, 53.0444, 389.727, 54.6873, 392.056, 58.4484)
    ..cubicTo(392.056, 58.4484, 390.674, 61.2129, 390.674, 61.2129)
    ..cubicTo(390.413, 61.7379, 390.624, 62.3737, 391.149, 62.638)
    ..cubicTo(391.149, 62.638, 392.249, 63.188, 392.249, 63.188)
    ..cubicTo(392.249, 63.188, 384.52, 68.9814, 384.52, 68.9814)
    ..cubicTo(384.52, 68.9814, 363.807, 76.7499, 363.807, 76.7499)
    ..cubicTo(363.807, 76.7499, 356.8, 76.1141, 356.8, 76.1141)
    ..cubicTo(356.742, 76.107, 356.682, 76.1069, 356.621, 76.1105)
    ..cubicTo(356.621, 76.1105, 348.385, 76.7713, 348.385, 76.7713)
    ..cubicTo(348.192, 76.7856, 348.006, 76.857, 347.849, 76.9713)
    ..cubicTo(347.849, 76.9713, 322.915, 95.1013, 322.915, 95.1013)
    ..cubicTo(322.915, 95.1013, 311.367, 91.4546, 311.367, 91.4546)
    ..cubicTo(306.092, 79.5429, 301.499, 66.7455, 296.638, 53.2122)
    ..cubicTo(296.527, 52.8979, 296.413, 52.5836, 296.298, 52.2693)
    ..cubicTo(296.405, 52.1514, 296.491, 52.0193, 296.538, 51.8622)
    ..cubicTo(296.538, 51.8622, 300.774, 37.7432, 300.774, 37.7432)
    ..cubicTo(300.813, 37.7324, 300.852, 37.7253, 300.888, 37.7074)
    ..cubicTo(300.888, 37.7074, 307.063, 34.9893, 307.063, 34.9893)
    ..cubicTo(307.599, 34.7536, 307.846, 34.1286, 307.61, 33.5928)
    ..cubicTo(307.374, 33.057, 306.753, 32.8106, 306.21, 33.0499)
    ..cubicTo(306.21, 33.0499, 300.209, 35.6894, 300.209, 35.6894)
    ..cubicTo(300.209, 35.6894, 288.455, 30.8926, 288.455, 30.8926)
    ..cubicTo(284.172, 19.6774, 279.558, 8.6408, 274.196, -1.76)
    ..cubicTo(274.479, -2.2422, 274.346, -2.8602, 273.882, -3.1745)
    ..cubicTo(273.882, -3.1745, 273.232, -3.6138, 273.232, -3.6138)
    ..cubicTo(270.521, -8.7499, 267.614, -13.7217, 264.467, -18.4721)
    ..cubicTo(264.467, -18.4721, 264.467, -19.0936, 264.467, -19.0936)
    ..cubicTo(264.467, -19.6829, 263.992, -20.1544, 263.406, -20.1544)
    ..cubicTo(263.385, -20.1544, 263.363, -20.1508, 263.342, -20.1472)
    ..cubicTo(258.631, -27.0514, 253.384, -33.4698, 247.423, -39.2095)
    ..cubicTo(247.423, -39.2095, 247.394, -39.1809, 247.394, -39.1809)
    ..cubicTo(247.058, -39.4881, 246.394, -39.9667, 245.094, -40.9025)
    ..cubicTo(245.094, -40.9025, 233.147, -49.5175, 233.147, -49.5175)
    ..cubicTo(232.979, -49.6389, 232.782, -49.7068, 232.575, -49.7175)
    ..cubicTo(224.792, -50.0854, 205.705, -49.1925, 191.611, -48.4353)
    ..cubicTo(191.168, -52.4499, 190.647, -55.4144, 190.011, -56.8324)
    ..cubicTo(190.011, -56.8324, 189.972, -56.8109, 189.972, -56.8109)
    ..cubicTo(189.74, -57.2538, 189.222, -57.9824, 188.211, -59.4076)
    ..cubicTo(188.211, -59.4076, 179.039, -72.33, 179.039, -72.33)
    ..cubicTo(178.924, -72.4943, 178.764, -72.6229, 178.578, -72.6979)
    ..cubicTo(178.578, -72.6979, 171.331, -75.6624, 171.331, -75.6624)
    ..cubicTo(171.16, -75.7339, 170.97, -75.7553, 170.785, -75.7303)
    ..cubicTo(170.785, -75.7303, 149.483, -72.7801, 149.483, -72.7801)
    ..cubicTo(149.483, -72.7801, 130.338, -74.0802, 130.338, -74.0802)
    ..cubicTo(130.338, -74.0802, 109.187, -83.1881, 109.187, -83.1881)
    ..cubicTo(109.187, -83.1881, 95.0301, -92.8424, 95.0301, -92.8424)
    ..cubicTo(95.0301, -92.8424, 86.039, -113.394, 86.039, -113.394)
    ..cubicTo(86.039, -113.394, 87.3181, -127.145, 87.3181, -127.145)
    ..cubicTo(87.3181, -127.145, 92.5396, -141.178, 92.5396, -141.178)
    ..cubicTo(92.6635, -141.511, 92.6125, -141.882, 92.4035, -142.171)
    ..cubicTo(87.9882, -148.24, 87.3059, -148.647, 81.9973, -151.811)
    ..cubicTo(81.9973, -151.811, 80.7811, -152.536, 80.7811, -152.536)
    ..cubicTo(77.7973, -157.33, 73.6809, -164.084, 69.5174, -170.981)
    ..cubicTo(69.5174, -170.981, 76.7179, -176.617, 76.7179, -176.617)
    ..cubicTo(76.8419, -176.714, 76.9426, -176.835, 77.0129, -176.978)
    ..cubicTo(77.0129, -176.978, 82.283, -187.518, 82.283, -187.518)
    ..cubicTo(82.3516, -187.654, 82.3898, -187.804, 82.3948, -187.961)
    ..cubicTo(82.3948, -187.961, 83.3738, -220.606, 83.3738, -220.606)
    ..cubicTo(83.3738, -220.606, 93.7561, -236.829, 93.7561, -236.829)
    ..cubicTo(93.8686, -237.004, 93.9268, -237.208, 93.9236, -237.415)
    ..cubicTo(93.9236, -237.415, 93.2411, -281.558, 93.2411, -281.558)
    ..cubicTo(106.184, -281.04, 118.537, -280.136, 127.627, -278.84)
    ..cubicTo(128.213, -278.757, 128.745, -279.161, 128.828, -279.74)
    ..cubicTo(128.91, -280.322, 128.506, -280.858, 127.927, -280.94)
    ..cubicTo(118.752, -282.247, 106.271, -283.158, 93.2082, -283.679)
    ..cubicTo(93.2082, -283.679, 92.9353, -301.316, 92.9353, -301.316)
    ..cubicTo(92.9264, -301.899, 92.4538, -302.363, 91.8756, -302.363)
    ..cubicTo(91.8699, -302.363, 91.8645, -302.363, 91.8588, -302.363)
    ..cubicTo(91.2734, -302.352, 90.8059, -301.87, 90.8152, -301.284)
    ..cubicTo(90.8152, -301.284, 91.0859, -283.761, 91.0859, -283.761)
    ..cubicTo(73.1362, -284.422, 54.3679, -284.354, 41.7433, -283.583)
    ..cubicTo(41.5479, -283.572, 41.3597, -283.508, 41.1997, -283.393)
    ..cubicTo(41.1997, -283.393, 24.9002, -271.985, 24.9002, -271.985)
    ..cubicTo(19.5822, -270.885, -12.3075, -272.453, -31.453, -273.393)
    ..cubicTo(-38.281, -273.728, -43.6743, -273.993, -45.7902, -274.032)
    ..cubicTo(-45.8395, -274.036, -45.8949, -274.032, -45.947, -274.025)
    ..cubicTo(-61.7436, -271.975, -82.4343, -265.385, -100.564, -257.113)
    ..cubicTo(-107.836, -272.871, -114.988, -288.144, -121.521, -301.681)
    ..cubicTo(-121.776, -302.206, -122.41, -302.427, -122.937, -302.174)
    ..cubicTo(-123.464, -301.92, -123.685, -301.284, -123.431, -300.759)
    ..cubicTo(-116.904, -287.233, -109.757, -271.971, -102.489, -256.227)
    ..cubicTo(-110.682, -252.395, -118.288, -248.237, -124.589, -244.019)
    ..cubicTo(-124.898, -243.915, -125.124, -243.526, -126.048, -241.937)
    ..cubicTo(-126.048, -241.937, -131.051, -233.322, -131.051, -233.322)
    ..cubicTo(-131.114, -233.211, -131.158, -233.093, -131.179, -232.968)
    ..cubicTo(-131.179, -232.968, -134.803, -211.888, -134.803, -211.888)
    ..cubicTo(-134.811, -211.838, -134.816, -211.788, -134.817, -211.738)
    ..cubicTo(-134.817, -211.738, -135.476, -189.011, -135.476, -189.011)
    ..cubicTo(-135.477, -188.982, -135.477, -188.954, -135.475, -188.925)
    ..cubicTo(-134.825, -176.488, -117.431, -135.389, -109.498, -125.095)
    ..cubicTo(-109.498, -125.095, -110.406, -117.227, -110.406, -117.227)
    ..cubicTo(-110.406, -117.227, -110.863, -116.566, -110.863, -116.566)
    ..cubicTo(-111.311, -116.637, -111.772, -116.419, -111.982, -115.991)
    ..cubicTo(-112.143, -115.662, -112.118, -115.294, -111.949, -114.998)
    ..cubicTo(-111.949, -114.998, -113.054, -113.401, -113.054, -113.401)
    ..cubicTo(-117.217, -111.476, -126.461, -106.69, -129.726, -104.554)
    ..cubicTo(-129.85, -104.472, -129.956, -104.368, -130.036, -104.243)
    ..cubicTo(-132.221, -100.865, -134.786, -97.4642, -137.587, -94.0639)
    ..cubicTo(-157.847, -97.4071, -182.278, -102.129, -211.728, -108.776)
    ..cubicTo(-211.728, -108.776, -229.352, -120.523, -229.352, -120.523)
    ..cubicTo(-229.84, -120.848, -230.497, -120.716, -230.822, -120.23)
    ..cubicTo(-231.147, -119.745, -231.015, -119.084, -230.528, -118.759)
    ..cubicTo(-230.528, -118.759, -212.741, -106.901, -212.741, -106.901)
    ..cubicTo(-212.633, -106.829, -212.513, -106.779, -212.386, -106.751)
    ..cubicTo(-194.155, -102.636, -167.446, -96.8142, -139.207, -92.1281)
    ..cubicTo(-144.629, -85.7419, -150.807, -79.3663, -156.863, -73.1158)
    ..cubicTo(-166.729, -62.9364, -176.932, -52.4106, -183.726, -41.9919)
    ..cubicTo(-183.786, -41.899, -183.83, -41.799, -183.859, -41.6954)
    ..cubicTo(-183.963, -41.3454, -185.829, -35.127, -185.829, -35.127)
    ..cubicTo(-185.859, -35.0306, -185.874, -34.927, -185.874, -34.8234)
    ..cubicTo(-185.874, -34.8234, -185.544, 147.991, -185.544, 147.991)
    ..cubicTo(-185.544, 148.17, -185.498, 148.345, -185.412, 148.502)
    ..cubicTo(-184.715, 149.759, -183.995, 151.045, -183.263, 152.342)
    ..cubicTo(-199.357, 162.571, -215.167, 172.511, -230.498, 182.001)
    ..cubicTo(-230.995, 182.308, -231.149, 182.962, -230.841, 183.462)
    ..cubicTo(-230.641, 183.787, -230.294, 183.962, -229.939, 183.962)
    ..cubicTo(-229.748, 183.962, -229.555, 183.912, -229.382, 183.805)
    ..cubicTo(-214.073, 174.329, -198.286, 164.403, -182.218, 154.188)
    ..cubicTo(-165.523, 183.519, -140.391, 221.751, -116.036, 258.8)
    ..cubicTo(-114.261, 261.5, -112.499, 264.183, -110.745, 266.851)
    ..cubicTo(-130.638, 275.777, -149.123, 283.97, -163.711, 290.435)
    ..cubicTo(-163.711, 290.435, -164.162, 290.635, -164.162, 290.635)
    ..cubicTo(-164.162, 290.635, -164.154, 290.649, -164.154, 290.649)
    ..cubicTo(-164.71, 290.753, -165.541, 290.953, -166.815, 291.267)
    ..cubicTo(-166.815, 291.267, -229.863, 306.711, -229.863, 306.711)
    ..cubicTo(-230.431, 306.851, -230.779, 307.426, -230.64, 307.994)
    ..cubicTo(-230.522, 308.479, -230.088, 308.804, -229.611, 308.804)
    ..cubicTo(-229.528, 308.804, -229.443, 308.794, -229.358, 308.772)
    ..cubicTo(-228.702, 308.611, -163.798, 292.71, -163.483, 292.635)
    ..cubicTo(-163.422, 292.617, -163.36, 292.599, -163.302, 292.571)
    ..cubicTo(-163.302, 292.571, -162.852, 292.374, -162.852, 292.374)
    ..cubicTo(-148.185, 285.874, -129.582, 277.627, -109.565, 268.647)
    ..cubicTo(-92.2936, 294.946, -76.2641, 319.53, -64.5682, 339.146)
    ..cubicTo(-64.5682, 339.146, -63.7863, 341.536, -63.7863, 341.536)
    ..cubicTo(-63.7863, 341.536, -70.7983, 363.209, -70.7983, 363.209)
    ..cubicTo(-75.0576, 364.912, -79.2836, 366.588, -83.4557, 368.241)
    ..cubicTo(-83.4557, 368.241, -89.7638, 370.741, -89.7638, 370.741)
    ..cubicTo(-90.3077, 370.959, -90.5735, 371.574, -90.3574, 372.116)
    ..cubicTo(-90.1924, 372.534, -89.7938, 372.788, -89.3719, 372.788)
    ..cubicTo(-89.2419, 372.788, -89.1094, 372.763, -88.9808, 372.713)
    ..cubicTo(-88.9808, 372.713, -85.962, 371.516, -85.962, 371.516)
    ..cubicTo(-86.0013, 371.706, -85.9906, 371.909, -85.9156, 372.106)
    ..cubicTo(-85.7538, 372.527, -85.352, 372.788, -84.9248, 372.788)
    ..cubicTo(-84.7991, 372.788, -84.6712, 372.767, -84.5462, 372.717)
    ..cubicTo(-84.5462, 372.717, -79.4561, 370.77, -79.4561, 370.77)
    ..cubicTo(-75.5558, 369.281, -71.6055, 367.773, -67.6241, 366.234)
    ..cubicTo(-67.6241, 366.234, -55.746, 373.024, -55.746, 373.024)
    ..cubicTo(-55.746, 373.024, -42.8493, 356.315, -42.8493, 356.315)
    ..cubicTo(-31.2976, 351.461, -19.7817, 346.214, -8.714, 340.332)
    ..cubicTo(-8.714, 340.332, 5.2982, 341.825, 5.2982, 341.825)
    ..cubicTo(5.2982, 341.825, 9.7814, 329.57, 9.7814, 329.57)
    ..cubicTo(20.5126, 322.691, 30.517, 315.012, 39.3424, 306.272)
    ..cubicTo(39.3652, 306.251, 39.387, 306.229, 39.4077, 306.204)
    ..cubicTo(41.4772, 303.743, 43.6124, 301.364, 45.7794, 299.021)
    ..cubicTo(45.7872, 299.039, 45.7911, 299.057, 45.8001, 299.075)
    ..cubicTo(45.9861, 299.446, 46.3601, 299.661, 46.7491, 299.661)
    ..cubicTo(46.9087, 299.661, 47.0705, 299.625, 47.2227, 299.55)
    ..cubicTo(47.8985, 299.211, 54.6265, 296.828, 58.709, 295.403)
    ..cubicTo(58.949, 295.321, 59.1512, 295.153, 59.2783, 294.932)
    ..cubicTo(59.2783, 294.932, 63.9723, 286.778, 63.9723, 286.778)
    ..cubicTo(64.0858, 286.581, 64.133, 286.352, 64.1069, 286.127)
    ..cubicTo(64.1069, 286.127, 63.6147, 281.863, 63.6147, 281.863)
    ..cubicTo(83.1931, 265.033, 105.477, 251.56, 129.07, 239.959)
    ..cubicTo(129.07, 239.959, 150.172, 235.045, 150.172, 235.045)
    ..cubicTo(150.172, 235.045, 160.309, 245.178, 160.309, 245.178)
    ..cubicTo(160.351, 245.331, 160.394, 245.488, 160.437, 245.646)
    ..cubicTo(163.473, 256.511, 166.216, 266.319, 169.488, 275.777)
    ..cubicTo(169.488, 275.777, 169.952, 297.143, 169.952, 297.143)
    ..cubicTo(169.956, 297.253, 169.974, 297.361, 170.009, 297.468)
    ..cubicTo(170.009, 297.468, 172.235, 303.89, 172.235, 303.89)
    ..cubicTo(172.277, 304.018, 172.349, 304.14, 172.438, 304.24)
    ..cubicTo(172.438, 304.24, 174.167, 306.218, 174.167, 306.218)
    ..cubicTo(174.313, 306.383, 174.506, 306.501, 174.721, 306.551)
    ..cubicTo(174.721, 306.551, 178.921, 307.54, 178.921, 307.54)
    ..cubicTo(179.003, 307.558, 179.082, 307.568, 179.164, 307.568)
    ..cubicTo(179.21, 307.568, 179.26, 307.565, 179.307, 307.558)
    ..cubicTo(179.307, 307.558, 183.489, 306.99, 183.489, 306.99)
    ..cubicTo(194.194, 325.699, 210.448, 346.086, 238.454, 373.474)
    ..cubicTo(238.661, 373.674, 238.929, 373.777, 239.197, 373.777)
    ..cubicTo(239.472, 373.777, 239.747, 373.67, 239.954, 373.456)
    ..cubicTo(240.279, 373.124, 240.329, 372.638, 240.133, 372.245)
    ..cubicTo(240.229, 372.274, 240.329, 372.292, 240.429, 372.292)
    ..cubicTo(240.683, 372.292, 240.937, 372.202, 241.14, 372.02)
    ..cubicTo(241.576, 371.627, 241.612, 370.959, 241.219, 370.524)
    ..cubicTo(237.49, 366.384, 233.997, 362.519, 230.729, 358.901)
    ..cubicTo(206.284, 331.849, 194.211, 318.487, 186.282, 304.883)
    ..cubicTo(186.282, 304.883, 190.472, 297.128, 190.472, 297.128)
    ..cubicTo(190.59, 296.918, 190.625, 296.671, 190.583, 296.432)
    ..cubicTo(190.583, 296.432, 189.961, 293.114, 189.961, 293.114)
    ..cubicTo(190.097, 292.874, 190.143, 292.589, 190.072, 292.317)
    ..cubicTo(189.986, 292.003, 189.765, 291.746, 189.465, 291.617)
    ..cubicTo(189.465, 291.617, 188.986, 291.41, 188.986, 291.41)
    ..cubicTo(188.986, 291.41, 178.624, 281.966, 178.624, 281.966)
    ..cubicTo(178.624, 281.966, 166.191, 236.634, 166.191, 236.634)
    ..cubicTo(166.191, 236.634, 168.681, 229.623, 168.681, 229.623)
    ..cubicTo(168.681, 229.623, 190.129, 215.24, 190.129, 215.24)
    ..cubicTo(190.618, 214.915, 190.747, 214.257, 190.422, 213.772)
    ..cubicTo(190.418, 213.768, 190.418, 213.768, 190.418, 213.768)
    ..cubicTo(198.094, 210.811, 205.78, 207.907, 213.438, 205.021)
    ..cubicTo(234.232, 197.174, 255.563, 189.127, 275.857, 180.205)
    ..cubicTo(275.857, 180.205, 291.019, 188.716, 291.019, 188.716)
    ..cubicTo(291.194, 189.037, 291.373, 189.366, 291.551, 189.68)
    ..cubicTo(291.676, 189.909, 291.88, 190.063, 292.109, 190.148)
    ..cubicTo(300.238, 206.45, 309.639, 226.358, 319.586, 247.421)
    ..cubicTo(333.53, 276.952, 347.949, 307.486, 359.757, 329.892)
    ..cubicTo(361.368, 334.946, 363.85, 345.236, 364.129, 350.047)
    ..cubicTo(364.129, 350.05, 364.129, 350.05, 364.129, 350.054)
    ..cubicTo(364.136, 350.204, 364.568, 357.976, 364.618, 358.858)
    ..cubicTo(364.618, 358.858, 363.389, 371.377, 363.389, 371.377)
    ..cubicTo(363.332, 371.959, 363.761, 372.477, 364.343, 372.534)
    ..cubicTo(364.379, 372.538, 364.414, 372.542, 364.447, 372.542)
    ..cubicTo(364.986, 372.542, 365.447, 372.131, 365.5, 371.584)
    ..cubicTo(365.5, 371.584, 366.736, 358.983, 366.736, 358.983)
    ..cubicTo(366.743, 358.93, 366.743, 358.876, 366.74, 358.823)
    ..cubicTo(366.74, 358.823, 366.322, 351.318, 366.322, 351.318)
    ..cubicTo(366.29, 350.733, 366.265, 350.276, 366.215, 349.929)
    ..cubicTo(366.215, 349.929, 366.243, 349.925, 366.243, 349.925)
    ..cubicTo(365.932, 344.468, 363.193, 333.671, 361.75, 329.16)
    ..cubicTo(361.732, 329.099, 361.707, 329.042, 361.678, 328.988)
    ..cubicTo(349.881, 306.615, 335.455, 276.062, 321.504, 246.517)
    ..cubicTo(311.474, 225.28, 301.999, 205.21, 293.816, 188.816)
    ..cubicTo(293.923, 188.473, 293.844, 188.098, 293.616, 187.827)
    ..cubicTo(293.616, 187.827, 293.616, 177.99, 293.616, 177.99)
    ..cubicTo(293.616, 177.99, 296.134, 171.357, 296.134, 171.357)
    ..cubicTo(299.02, 169.536, 305.177, 163.039, 310.767, 157.038)
    ..cubicTo(311.749, 155.985, 312.557, 155.117, 313.085, 154.57)
    ..cubicTo(313.171, 154.478, 313.246, 154.37, 313.296, 154.253)
    ..cubicTo(313.296, 154.253, 318.482, 142.148, 318.482, 142.148)
    ..cubicTo(318.514, 142.077, 318.536, 142.002, 318.55, 141.927)
    ..cubicTo(318.55, 141.927, 320.775, 130.068, 320.775, 130.068)
    ..cubicTo(320.789, 129.986, 320.793, 129.904, 320.789, 129.818)
    ..cubicTo(320.789, 129.818, 320.339, 120.611, 320.339, 120.611)
    ..cubicTo(320.414, 120.507, 320.472, 120.396, 320.507, 120.271)
    ..cubicTo(320.507, 120.271, 326.079, 99.9267, 326.079, 99.9267)
    ..cubicTo(326.079, 99.9267, 355.071, 82.286, 355.071, 82.286)
    ..cubicTo(355.071, 82.286, 367.329, 83.2504, 367.329, 83.2504)
    ..cubicTo(367.461, 83.2611, 367.597, 83.2468, 367.725, 83.2039)
    ..cubicTo(367.725, 83.2039, 378.101, 79.993, 378.101, 79.993)
    ..cubicTo(378.658, 79.8215, 378.973, 79.2251, 378.798, 78.6679)
    ..cubicTo(378.626, 78.1071, 378.03, 77.7964, 377.473, 77.9678)
    ..cubicTo(377.473, 77.9678, 367.29, 81.1217, 367.29, 81.1217)
    ..cubicTo(367.29, 81.1217, 359.839, 80.5359, 359.839, 80.5359)
    ..cubicTo(359.839, 80.5359, 365.6, 80.5359, 365.6, 80.5359)
    ..cubicTo(365.725, 80.5359, 365.85, 80.5144, 365.964, 80.468)
    ..cubicTo(365.964, 80.468, 384.741, 73.5532, 384.741, 73.5532)
    ..cubicTo(384.816, 73.5246, 384.884, 73.4889, 384.952, 73.446)
    ..cubicTo(384.952, 73.446, 397.139, 65.5418, 397.139, 65.5418)
    ..cubicTo(397.489, 65.3132, 397.674, 64.9025, 397.61, 64.4882)
    ..cubicTo(397.61, 64.4882, 397.61, 64.4882, 397.61, 64.4882)
    ..close();

  static final Path __path27_1_23 = Path()
    ..moveTo(391.115, 261.925)
    ..cubicTo(391.115, 261.925, 373.66, 257.974, 373.66, 257.974)
    ..cubicTo(373.603, 257.96, 373.542, 257.953, 373.485, 257.957)
    ..cubicTo(373.485, 257.957, 361.627, 258.285, 361.627, 258.285)
    ..cubicTo(361.58, 258.285, 361.537, 258.292, 361.494, 258.303)
    ..cubicTo(361.48, 258.307, 361.466, 258.31, 361.448, 258.31)
    ..cubicTo(361.409, 258.303, 361.369, 258.285, 361.327, 258.285)
    ..cubicTo(361.159, 258.285, 361.012, 258.346, 360.891, 258.442)
    ..cubicTo(349.229, 261.075, 336.71, 266.461, 324.591, 271.679)
    ..cubicTo(316.916, 274.987, 309.094, 278.355, 301.382, 281.076)
    ..cubicTo(301.382, 281.076, 301.082, 272.144, 301.082, 272.144)
    ..cubicTo(301.082, 272.094, 301.075, 272.043, 301.065, 271.997)
    ..cubicTo(301.065, 271.997, 298.1, 260.139, 298.1, 260.139)
    ..cubicTo(298.075, 260.043, 298.032, 259.953, 297.971, 259.875)
    ..cubicTo(297.971, 259.875, 291.053, 250.981, 291.053, 250.981)
    ..cubicTo(290.992, 250.903, 290.914, 250.838, 290.824, 250.788)
    ..cubicTo(282.552, 246.474, 264.965, 238.605, 256.34, 235.019)
    ..cubicTo(253.014, 231.108, 251.628, 229.479, 250.986, 228.797)
    ..cubicTo(250.243, 225.325, 249.014, 221.454, 247.385, 217.26)
    ..cubicTo(247.385, 217.26, 291.825, 199.923, 291.825, 199.923)
    ..cubicTo(291.825, 199.923, 297.786, 210.589, 297.786, 210.589)
    ..cubicTo(297.968, 210.917, 298.379, 211.042, 298.718, 210.874)
    ..cubicTo(298.718, 210.874, 302.672, 208.899, 302.672, 208.899)
    ..cubicTo(303.018, 208.724, 303.161, 208.299, 302.986, 207.949)
    ..cubicTo(302.811, 207.599, 302.386, 207.46, 302.04, 207.635)
    ..cubicTo(302.04, 207.635, 298.689, 209.31, 298.689, 209.31)
    ..cubicTo(298.689, 209.31, 292.76, 198.698, 292.76, 198.698)
    ..cubicTo(292.585, 198.388, 292.214, 198.255, 291.885, 198.384)
    ..cubicTo(291.885, 198.384, 246.864, 215.946, 246.864, 215.946)
    ..cubicTo(235.02, 186.522, 204.057, 142.015, 177.89, 106.123)
    ..cubicTo(193.777, 103.766, 209.289, 100.915, 223.49, 96.9544)
    ..cubicTo(223.49, 96.9544, 223.473, 96.8936, 223.473, 96.8936)
    ..cubicTo(223.937, 96.7222, 224.808, 96.2186, 226.691, 95.1363)
    ..cubicTo(226.691, 95.1363, 243.088, 85.6856, 243.088, 85.6856)
    ..cubicTo(243.088, 85.6856, 242.381, 84.4605, 242.381, 84.4605)
    ..cubicTo(242.196, 84.5676, 224.326, 94.8649, 223.023, 95.615)
    ..cubicTo(208.7, 99.6081, 193.013, 102.465, 176.951, 104.834)
    ..cubicTo(170.847, 96.4722, 165.021, 88.5965, 159.785, 81.5209)
    ..cubicTo(153.267, 72.7095, 147.638, 65.0982, 143.541, 59.3549)
    ..cubicTo(143.288, 58.8977, 143.33, 57.3047, 143.555, 55.0653)
    ..cubicTo(156.039, 54.4831, 167.061, 53.6544, 174.951, 52.8365)
    ..cubicTo(174.951, 52.8365, 174.951, 52.8186, 174.951, 52.8186)
    ..cubicTo(175.279, 52.7151, 175.926, 52.2722, 177.751, 51.0185)
    ..cubicTo(177.751, 51.0185, 191.091, 41.8463, 191.091, 41.8463)
    ..cubicTo(191.141, 41.8142, 191.184, 41.7749, 191.224, 41.7285)
    ..cubicTo(191.224, 41.7285, 206.375, 24.2699, 206.375, 24.2699)
    ..cubicTo(206.632, 23.9735, 206.6, 23.5306, 206.307, 23.2734)
    ..cubicTo(206.01, 23.0162, 205.564, 23.0484, 205.31, 23.3448)
    ..cubicTo(205.31, 23.3448, 190.216, 40.7319, 190.216, 40.7319)
    ..cubicTo(189.109, 41.4927, 176.151, 50.4041, 174.629, 51.4471)
    ..cubicTo(165.85, 52.3543, 155.196, 53.1294, 143.713, 53.6544)
    ..cubicTo(144.495, 47.0825, 146.416, 36.6066, 147.416, 31.1633)
    ..cubicTo(148.027, 27.8202, 148.47, 25.4093, 148.574, 24.5485)
    ..cubicTo(148.577, 24.5164, 148.577, 24.4878, 148.577, 24.4556)
    ..cubicTo(148.577, 24.4556, 148.252, 2.4431, 148.252, 2.4431)
    ..cubicTo(148.252, 2.4431, 160.718, 2.4431, 160.718, 2.4431)
    ..cubicTo(160.875, 2.4431, 161.025, 2.3931, 161.15, 2.2967)
    ..cubicTo(162.753, 1.0466, 166.236, -3.5787, 168.129, -6.0968)
    ..cubicTo(171.304, -3.618, 174.576, -1.0964, 177.855, 1.4288)
    ..cubicTo(182.148, 4.7255, 185.541, 7.3328, 186.938, 8.5329)
    ..cubicTo(187.07, 8.6472, 187.234, 8.7044, 187.398, 8.7044)
    ..cubicTo(187.595, 8.7044, 187.795, 8.6186, 187.934, 8.4579)
    ..cubicTo(188.188, 8.1614, 188.152, 7.715, 187.855, 7.4614)
    ..cubicTo(186.434, 6.2363, 183.03, 3.6182, 178.719, 0.3072)
    ..cubicTo(175.879, -1.8751, 172.504, -4.4717, 168.947, -7.2469)
    ..cubicTo(169.05, -7.5291, 168.972, -7.8541, 168.718, -8.047)
    ..cubicTo(168.472, -8.2363, 168.143, -8.2291, 167.9, -8.0648)
    ..cubicTo(162.764, -12.083, 157.332, -16.4191, 152.628, -20.4123)
    ..cubicTo(156.814, -23.5161, 162.214, -27.9772, 165.964, -31.0703)
    ..cubicTo(167.289, -32.1668, 168.375, -33.0597, 169.065, -33.6134)
    ..cubicTo(169.254, -33.7669, 169.35, -34.0027, 169.325, -34.242)
    ..cubicTo(169.043, -36.7743, 168.765, -39.8674, 168.507, -43.2498)
    ..cubicTo(172.076, -43.8642, 175.544, -44.3964, 178.565, -44.6607)
    ..cubicTo(178.83, -44.6857, 179.062, -44.8535, 179.158, -45.1035)
    ..cubicTo(179.158, -45.1035, 179.819, -46.7501, 179.819, -46.7501)
    ..cubicTo(179.962, -47.1109, 179.787, -47.5216, 179.426, -47.6681)
    ..cubicTo(179.062, -47.8145, 178.651, -47.6395, 178.505, -47.2752)
    ..cubicTo(178.505, -47.2752, 178.008, -46.0286, 178.008, -46.0286)
    ..cubicTo(175.083, -45.7536, 171.79, -45.2464, 168.404, -44.6642)
    ..cubicTo(167.614, -55.6723, 167.107, -69.2341, 167.679, -76.6025)
    ..cubicTo(167.711, -76.9918, 167.418, -77.3312, 167.029, -77.3633)
    ..cubicTo(166.643, -77.3919, 166.3, -77.1026, 166.268, -76.7132)
    ..cubicTo(165.689, -69.2519, 166.204, -55.5187, 167.004, -44.4214)
    ..cubicTo(165.468, -44.1499, 163.918, -43.8678, 162.386, -43.5892)
    ..cubicTo(156.86, -42.5784, 151.145, -41.5354, 146.491, -41.1282)
    ..cubicTo(146.32, -41.1139, 146.159, -41.0354, 146.041, -40.9139)
    ..cubicTo(146.041, -40.9139, 139.916, -34.4955, 139.916, -34.4955)
    ..cubicTo(139.916, -34.4955, 137.044, -72.4272, 137.044, -72.4272)
    ..cubicTo(137.016, -72.8165, 136.68, -73.1058, 136.287, -73.0808)
    ..cubicTo(135.898, -73.0523, 135.605, -72.7129, 135.637, -72.3236)
    ..cubicTo(135.637, -72.3236, 138.548, -33.8169, 138.548, -33.8169)
    ..cubicTo(138.548, -33.8169, 119.246, -32.5918, 119.246, -32.5918)
    ..cubicTo(119.246, -32.5918, 119.261, -32.8061, 119.261, -32.8061)
    ..cubicTo(119.282, -33.1954, 118.986, -33.5312, 118.596, -33.5526)
    ..cubicTo(118.296, -33.5741, 118.039, -33.4133, 117.921, -33.1669)
    ..cubicTo(117.921, -33.1669, 113.032, -35.7385, 113.032, -35.7385)
    ..cubicTo(113.032, -35.7385, 106.663, -41.4711, 106.663, -41.4711)
    ..cubicTo(106.663, -41.4711, 104.763, -48.4395, 104.763, -48.4395)
    ..cubicTo(104.763, -48.4395, 104.136, -63.1872, 104.136, -63.1872)
    ..cubicTo(104.136, -63.1872, 124.411, -61.1298, 124.411, -61.1298)
    ..cubicTo(124.436, -61.1298, 124.461, -61.1298, 124.482, -61.1298)
    ..cubicTo(124.843, -61.1298, 125.15, -61.3977, 125.186, -61.762)
    ..cubicTo(125.225, -62.1514, 124.943, -62.4978, 124.554, -62.5371)
    ..cubicTo(124.554, -62.5371, 104.085, -64.6159, 104.085, -64.6159)
    ..cubicTo(104.024, -64.9052, 103.791, -65.1373, 103.481, -65.173)
    ..cubicTo(103.481, -65.173, 102.503, -65.2837, 102.503, -65.2837)
    ..cubicTo(102.503, -65.2837, 102.767, -72.6593, 102.767, -72.6593)
    ..cubicTo(102.829, -72.6629, 102.891, -72.6701, 102.952, -72.6879)
    ..cubicTo(103.153, -72.7487, 103.316, -72.8987, 103.396, -73.0951)
    ..cubicTo(103.396, -73.0951, 107.349, -82.6459, 107.349, -82.6459)
    ..cubicTo(107.499, -83.0066, 107.328, -83.4209, 106.967, -83.5674)
    ..cubicTo(106.606, -83.7174, 106.192, -83.5459, 106.043, -83.1852)
    ..cubicTo(106.043, -83.1852, 102.416, -74.4202, 102.416, -74.4202)
    ..cubicTo(102.416, -74.4202, 94.7122, -79.4599, 94.7122, -79.4599)
    ..cubicTo(94.7122, -79.4599, 86.5805, -94.0968, 86.5805, -94.0968)
    ..cubicTo(86.5805, -94.0968, 76.9418, -116.795, 76.9418, -116.795)
    ..cubicTo(77.1047, -116.845, 77.2726, -116.895, 77.4319, -116.942)
    ..cubicTo(78.4152, -116.792, 83.6959, -115.981, 83.6959, -115.981)
    ..cubicTo(83.6959, -115.981, 83.9106, -117.377, 83.9106, -117.377)
    ..cubicTo(83.9106, -117.377, 80.6996, -117.87, 80.6996, -117.87)
    ..cubicTo(78.5755, -118.199, 77.6387, -118.342, 77.1879, -118.306)
    ..cubicTo(77.1879, -118.306, 77.1769, -118.342, 77.1769, -118.342)
    ..cubicTo(76.9376, -118.27, 76.6879, -118.195, 76.44, -118.12)
    ..cubicTo(76.44, -118.12, 76.44, -135.514, 76.44, -135.514)
    ..cubicTo(76.44, -135.514, 87.553, -134.911, 87.553, -134.911)
    ..cubicTo(87.5663, -134.911, 87.5795, -134.911, 87.592, -134.911)
    ..cubicTo(87.9649, -134.911, 88.2767, -135.204, 88.297, -135.579)
    ..cubicTo(88.3181, -135.972, 88.0191, -136.304, 87.6298, -136.325)
    ..cubicTo(87.6298, -136.325, 76.6707, -136.918, 76.6707, -136.918)
    ..cubicTo(81.0611, -145.915, 82.4234, -148.708, 82.8409, -149.623)
    ..cubicTo(86.8048, -152.698, 92.2805, -156.191, 98.0757, -159.884)
    ..cubicTo(104.546, -164.013, 111.239, -168.278, 115.71, -171.964)
    ..cubicTo(115.867, -172.092, 115.96, -172.285, 115.967, -172.489)
    ..cubicTo(115.967, -172.489, 116.625, -193.241, 116.625, -193.241)
    ..cubicTo(116.632, -193.448, 116.546, -193.651, 116.389, -193.791)
    ..cubicTo(112.124, -197.594, 107.72, -201.988, 103.166, -206.72)
    ..cubicTo(103.166, -206.72, 105.61, -206.759, 105.61, -206.759)
    ..cubicTo(112.299, -206.87, 124.757, -207.07, 128.819, -207.381)
    ..cubicTo(128.965, -207.392, 129.101, -207.445, 129.211, -207.538)
    ..cubicTo(129.211, -207.538, 132.63, -210.335, 132.63, -210.335)
    ..cubicTo(132.63, -210.335, 142.17, -210.028, 142.17, -210.028)
    ..cubicTo(142.17, -210.028, 150.127, -195.387, 150.127, -195.387)
    ..cubicTo(150.127, -195.387, 150.127, -191.573, 150.127, -191.573)
    ..cubicTo(149.163, -190.576, 147.666, -189.001, 145.856, -187.09)
    ..cubicTo(138.937, -179.786, 126.075, -166.213, 122.154, -163.574)
    ..cubicTo(121.418, -163.217, 120.214, -162.656, 118.739, -161.97)
    ..cubicTo(112.596, -159.116, 102.314, -154.337, 99.9723, -152.291)
    ..cubicTo(99.9515, -152.273, 99.9319, -152.251, 99.913, -152.234)
    ..cubicTo(99.913, -152.234, 90.6901, -142.022, 90.6901, -142.022)
    ..cubicTo(90.4283, -141.733, 90.4511, -141.283, 90.7408, -141.022)
    ..cubicTo(90.8762, -140.901, 91.0455, -140.84, 91.2141, -140.84)
    ..cubicTo(91.4069, -140.84, 91.5998, -140.918, 91.7391, -141.072)
    ..cubicTo(91.7391, -141.072, 100.933, -151.251, 100.933, -151.251)
    ..cubicTo(103.188, -153.187, 113.685, -158.063, 119.332, -160.688)
    ..cubicTo(120.85, -161.392, 122.079, -161.963, 122.814, -162.324)
    ..cubicTo(122.843, -162.334, 122.872, -162.352, 122.897, -162.37)
    ..cubicTo(126.904, -165.035, 139.409, -178.232, 146.881, -186.115)
    ..cubicTo(148.82, -188.162, 150.392, -189.819, 151.342, -190.79)
    ..cubicTo(151.47, -190.922, 151.542, -191.101, 151.542, -191.287)
    ..cubicTo(151.542, -191.287, 151.542, -195.569, 151.542, -195.569)
    ..cubicTo(151.542, -195.687, 151.51, -195.801, 151.456, -195.905)
    ..cubicTo(151.456, -195.905, 143.22, -211.056, 143.22, -211.056)
    ..cubicTo(143.102, -211.278, 142.873, -211.417, 142.623, -211.428)
    ..cubicTo(142.623, -211.428, 132.412, -211.756, 132.412, -211.756)
    ..cubicTo(132.24, -211.763, 132.072, -211.703, 131.94, -211.596)
    ..cubicTo(131.94, -211.596, 128.49, -208.774, 128.49, -208.774)
    ..cubicTo(124.254, -208.474, 112.146, -208.281, 105.587, -208.174)
    ..cubicTo(105.587, -208.174, 103.361, -208.138, 103.361, -208.138)
    ..cubicTo(103.361, -208.138, 92.8727, -218.625, 92.8727, -218.625)
    ..cubicTo(92.8727, -218.625, 95.6669, -221.418, 95.6669, -221.418)
    ..cubicTo(95.7994, -221.554, 95.8741, -221.732, 95.8741, -221.918)
    ..cubicTo(95.8741, -221.918, 95.8741, -234.644, 95.8741, -234.644)
    ..cubicTo(95.8741, -234.644, 98.1425, -241.127, 98.1425, -241.127)
    ..cubicTo(98.1425, -241.127, 105.029, -261.46, 105.029, -261.46)
    ..cubicTo(105.029, -261.46, 111.567, -271.265, 111.567, -271.265)
    ..cubicTo(111.653, -271.393, 111.696, -271.55, 111.685, -271.704)
    ..cubicTo(111.685, -271.704, 111.024, -281.258, 111.024, -281.258)
    ..cubicTo(110.999, -281.648, 110.646, -281.933, 110.271, -281.916)
    ..cubicTo(109.881, -281.887, 109.588, -281.551, 109.613, -281.162)
    ..cubicTo(109.613, -281.162, 110.256, -271.847, 110.256, -271.847)
    ..cubicTo(110.256, -271.847, 103.802, -262.168, 103.802, -262.168)
    ..cubicTo(103.768, -262.114, 103.741, -262.06, 103.72, -262.003)
    ..cubicTo(103.72, -262.003, 96.8059, -241.587, 96.8059, -241.587)
    ..cubicTo(96.8059, -241.587, 94.5004, -234.997, 94.5004, -234.997)
    ..cubicTo(94.474, -234.922, 94.4604, -234.844, 94.4604, -234.765)
    ..cubicTo(94.4604, -234.765, 94.4604, -222.211, 94.4604, -222.211)
    ..cubicTo(94.4604, -222.211, 91.4298, -219.182, 91.4298, -219.182)
    ..cubicTo(80.9754, -230.376, 70.2095, -241.809, 60.0297, -249.813)
    ..cubicTo(59.9115, -249.906, 59.7662, -249.959, 59.6158, -249.967)
    ..cubicTo(59.6158, -249.967, 49.4049, -250.295, 49.4049, -250.295)
    ..cubicTo(49.0428, -250.306, 48.7253, -250.024, 48.6867, -249.656)
    ..cubicTo(48.2445, -254.328, 47.6094, -258.553, 46.7751, -261.942)
    ..cubicTo(46.7479, -262.057, 46.6937, -262.157, 46.6183, -262.243)
    ..cubicTo(40.5546, -269.097, 27.9304, -282.626, 21.2845, -289.227)
    ..cubicTo(21.2845, -289.227, 13.7535, -301.667, 13.7535, -301.667)
    ..cubicTo(13.5517, -302.003, 13.117, -302.11, 12.7831, -301.906)
    ..cubicTo(12.4491, -301.703, 12.342, -301.271, 12.5441, -300.935)
    ..cubicTo(12.5441, -300.935, 20.1201, -288.42, 20.1201, -288.42)
    ..cubicTo(20.1501, -288.37, 20.1862, -288.323, 20.2272, -288.284)
    ..cubicTo(26.796, -281.769, 39.3309, -268.336, 45.4439, -261.439)
    ..cubicTo(48.9724, -246.845, 48.8031, -215.678, 45.1171, -201.509)
    ..cubicTo(45.1171, -201.509, 19.8636, -172.646, 19.8636, -172.646)
    ..cubicTo(19.82, -172.596, 19.7836, -172.542, 19.7558, -172.482)
    ..cubicTo(19.7558, -172.482, 16.6655, -165.888, 16.6655, -165.888)
    ..cubicTo(16.6655, -165.888, -11.6689, -179.793, -11.6689, -179.793)
    ..cubicTo(-11.8286, -182.3, -11.9925, -184.643, -12.1682, -186.733)
    ..cubicTo(-12.1761, -186.826, -12.2022, -186.915, -12.2443, -186.997)
    ..cubicTo(-13.9998, -190.405, -15.5903, -193.316, -16.9929, -195.887)
    ..cubicTo(-23.731, -208.227, -26.5201, -213.339, -25.3432, -232.415)
    ..cubicTo(-25.3382, -232.497, -25.3468, -232.576, -25.369, -232.654)
    ..cubicTo(-25.369, -232.654, -34.5722, -264.864, -34.5722, -264.864)
    ..cubicTo(-34.5722, -264.864, -34.6972, -266.539, -34.6972, -266.539)
    ..cubicTo(-35.2397, -273.815, -36.2498, -287.355, -36.542, -293.102)
    ..cubicTo(-36.547, -293.199, -36.572, -293.295, -36.6156, -293.384)
    ..cubicTo(-36.6156, -293.384, -41.227, -302.606, -41.227, -302.606)
    ..cubicTo(-41.402, -302.957, -41.8253, -303.099, -42.1757, -302.921)
    ..cubicTo(-42.525, -302.749, -42.6664, -302.324, -42.4918, -301.974)
    ..cubicTo(-42.4918, -301.974, -37.946, -292.884, -37.946, -292.884)
    ..cubicTo(-37.6439, -287.037, -36.6452, -273.654, -36.1066, -266.432)
    ..cubicTo(-36.1066, -266.432, -35.9766, -264.686, -35.9766, -264.686)
    ..cubicTo(-35.973, -264.639, -35.9641, -264.593, -35.9512, -264.546)
    ..cubicTo(-35.9512, -264.546, -26.7616, -232.383, -26.7616, -232.383)
    ..cubicTo(-27.9442, -212.996, -25.0957, -207.777, -18.2337, -195.209)
    ..cubicTo(-16.8518, -192.676, -15.2878, -189.812, -13.5655, -186.476)
    ..cubicTo(-13.4126, -184.647, -13.2691, -182.615, -13.1287, -180.457)
    ..cubicTo(-13.1301, -180.461, -13.1315, -180.461, -13.1333, -180.461)
    ..cubicTo(-13.1333, -180.461, -23.1791, -181.447, -23.1791, -181.447)
    ..cubicTo(-30.5829, -182.175, -32.6835, -182.386, -33.3821, -182.368)
    ..cubicTo(-33.3821, -182.368, -33.391, -182.433, -33.391, -182.433)
    ..cubicTo(-41.4792, -181.325, -56.7461, -177.032, -64.0892, -174.196)
    ..cubicTo(-76.3127, -173.167, -101.9, -172.996, -124.483, -172.842)
    ..cubicTo(-140.899, -172.732, -156.405, -172.628, -165.741, -172.228)
    ..cubicTo(-165.822, -172.225, -165.903, -172.207, -165.979, -172.175)
    ..cubicTo(-177.623, -167.399, -220.058, -151.498, -230.183, -147.812)
    ..cubicTo(-230.55, -147.676, -230.739, -147.273, -230.606, -146.905)
    ..cubicTo(-230.472, -146.537, -230.066, -146.347, -229.7, -146.483)
    ..cubicTo(-219.601, -150.158, -177.376, -165.985, -165.557, -170.821)
    ..cubicTo(-156.234, -171.217, -140.805, -171.321, -124.473, -171.428)
    ..cubicTo(-100.695, -171.589, -76.107, -171.757, -63.8689, -172.796)
    ..cubicTo(-63.8013, -172.8, -63.7356, -172.814, -63.6724, -172.839)
    ..cubicTo(-56.4618, -175.643, -41.3335, -179.904, -33.2807, -181.022)
    ..cubicTo(-31.9645, -180.893, -15.0381, -179.229, -13.3987, -179.064)
    ..cubicTo(-13.3987, -179.064, -13.028, -178.886, -13.028, -178.886)
    ..cubicTo(-12.874, -176.418, -12.7226, -173.807, -12.5672, -171.121)
    ..cubicTo(-12.255, -165.72, -11.9175, -159.891, -11.49, -154.08)
    ..cubicTo(-19.142, -153.666, -28.3492, -152.723, -38.095, -151.723)
    ..cubicTo(-61.624, -149.308, -88.2926, -146.569, -105.963, -149.819)
    ..cubicTo(-106.018, -149.83, -106.074, -149.83, -106.131, -149.83)
    ..cubicTo(-106.604, -149.801, -117.728, -149.162, -119.405, -148.83)
    ..cubicTo(-119.788, -148.751, -120.036, -148.38, -119.959, -147.998)
    ..cubicTo(-119.883, -147.615, -119.512, -147.365, -119.128, -147.444)
    ..cubicTo(-117.872, -147.694, -110.131, -148.183, -106.135, -148.412)
    ..cubicTo(-100.267, -147.34, -93.4441, -146.919, -86.0899, -146.919)
    ..cubicTo(-71.0505, -146.919, -53.7909, -148.69, -37.951, -150.316)
    ..cubicTo(-28.2095, -151.316, -19.0077, -152.259, -11.3846, -152.669)
    ..cubicTo(-10.6724, -143.326, -9.7116, -134.107, -8.2279, -126.835)
    ..cubicTo(-8.2279, -126.835, -38.8283, -129.735, -38.8283, -129.735)
    ..cubicTo(-38.8672, -129.739, -38.9079, -129.739, -38.9475, -129.735)
    ..cubicTo(-39.079, -129.725, -52.119, -128.75, -54.047, -128.75)
    ..cubicTo(-54.4374, -128.75, -54.7538, -128.432, -54.7538, -128.042)
    ..cubicTo(-54.7538, -127.653, -54.4374, -127.335, -54.047, -127.335)
    ..cubicTo(-52.1147, -127.335, -39.9866, -128.239, -38.9018, -128.321)
    ..cubicTo(-38.9018, -128.321, -7.92, -125.385, -7.92, -125.385)
    ..cubicTo(-7.6264, -124.063, -7.3142, -122.817, -6.9803, -121.653)
    ..cubicTo(-5.4098, -113.273, -5.7813, -90.6429, -5.9599, -79.7671)
    ..cubicTo(-5.9599, -79.7671, -5.9963, -77.474, -5.9963, -77.474)
    ..cubicTo(-5.9963, -77.474, -9.2112, -76.2382, -9.2112, -76.2382)
    ..cubicTo(-9.2112, -76.2382, -12.2297, -82.878, -12.2297, -82.878)
    ..cubicTo(-12.3918, -83.2352, -12.8126, -83.3924, -13.1651, -83.2281)
    ..cubicTo(-13.5209, -83.0673, -13.678, -82.6495, -13.5162, -82.2959)
    ..cubicTo(-13.5162, -82.2959, -10.2224, -75.0488, -10.2224, -75.0488)
    ..cubicTo(-10.1049, -74.7881, -9.8484, -74.6345, -9.5791, -74.6345)
    ..cubicTo(-9.4945, -74.6345, -9.4084, -74.6488, -9.3252, -74.681)
    ..cubicTo(-9.3252, -74.681, -5.0434, -76.3275, -5.0434, -76.3275)
    ..cubicTo(-4.7737, -76.4311, -4.5947, -76.6883, -4.5901, -76.9776)
    ..cubicTo(-4.5901, -76.9776, -4.5466, -79.7421, -4.5466, -79.7421)
    ..cubicTo(-4.3669, -90.6644, -3.9944, -113.395, -5.6063, -121.978)
    ..cubicTo(-5.9495, -123.174, -6.2695, -124.467, -6.5699, -125.831)
    ..cubicTo(-6.5699, -125.831, 18.7635, -139.943, 18.7635, -139.943)
    ..cubicTo(18.7793, -139.951, 18.7878, -139.965, 18.8028, -139.975)
    ..cubicTo(18.8028, -139.975, 20.9751, -135.114, 20.9751, -135.114)
    ..cubicTo(21.512, -133.914, 21.8152, -133.236, 22.0163, -132.846)
    ..cubicTo(22.0163, -132.846, 22.0088, -132.846, 22.0088, -132.846)
    ..cubicTo(23.9218, -123.296, 29.6498, -112.63, 35.9892, -102.565)
    ..cubicTo(35.9892, -102.565, 25.563, -94.5111, 25.563, -94.5111)
    ..cubicTo(25.4723, -94.4397, 25.3998, -94.3468, 25.3523, -94.2433)
    ..cubicTo(18.9068, -80.1457, 17.6742, -77.449, 17.4388, -76.8526)
    ..cubicTo(17.4388, -76.8526, 17.4127, -76.8597, 17.4127, -76.8597)
    ..cubicTo(17.3206, -76.5525, 17.0105, -74.6702, 16.1476, -69.3662)
    ..cubicTo(14.7768, -60.9406, 11.9266, -43.4249, 10.2589, -36.0278)
    ..cubicTo(10.2589, -36.0278, -56.0843, -30.2595, -56.0843, -30.2595)
    ..cubicTo(-56.4732, -30.2238, -56.7611, -29.8809, -56.7272, -29.4951)
    ..cubicTo(-56.6954, -29.1237, -56.3865, -28.8487, -56.0239, -28.8487)
    ..cubicTo(-56.0032, -28.8487, -55.9829, -28.8487, -55.9621, -28.8487)
    ..cubicTo(-55.9621, -28.8487, 9.9143, -34.5777, 9.9143, -34.5777)
    ..cubicTo(9.6961, -33.7205, 9.5074, -33.1097, 9.3574, -32.8133)
    ..cubicTo(9.2935, -32.7776, 9.2339, -32.7347, 9.1817, -32.6811)
    ..cubicTo(9.1817, -32.6811, -3.0243, -20.0229, -4.084, -18.9229)
    ..cubicTo(-28.0117, -5.8397, -54.506, 5.6863, -82.5207, 17.4051)
    ..cubicTo(-82.7218, 17.1872, -83.0404, 17.105, -83.3254, 17.2336)
    ..cubicTo(-83.5969, 17.3586, -83.7497, 17.6301, -83.7362, 17.9123)
    ..cubicTo(-88.9294, 20.0839, -94.1677, 22.259, -99.4578, 24.4556)
    ..cubicTo(-103.955, 26.3237, -108.468, 28.1952, -112.985, 30.0811)
    ..cubicTo(-114.558, 26.3058, -115.954, 22.9234, -117.059, 20.2446)
    ..cubicTo(-117.059, 20.2446, -118.284, 17.2801, -118.284, 17.2801)
    ..cubicTo(-118.303, 17.2336, -118.326, 17.1908, -118.354, 17.1479)
    ..cubicTo(-118.354, 17.1479, -119.263, 15.8156, -119.263, 15.8156)
    ..cubicTo(-122.216, 11.4653, -122.392, 11.2046, -128.148, 8.0365)
    ..cubicTo(-128.198, 8.0079, -128.251, 7.9865, -128.306, 7.9722)
    ..cubicTo(-129.263, 7.715, -131.056, 7.1935, -133.324, 6.5363)
    ..cubicTo(-133.83, 6.3863, -134.362, 6.2328, -134.908, 6.0756)
    ..cubicTo(-134.908, 6.0756, -150.577, -27.5486, -150.577, -27.5486)
    ..cubicTo(-150.622, -27.645, -150.69, -27.7343, -150.776, -27.8022)
    ..cubicTo(-150.776, -27.8022, -159.01, -34.3884, -159.01, -34.3884)
    ..cubicTo(-159.053, -34.4241, -159.099, -34.4527, -159.148, -34.4741)
    ..cubicTo(-159.148, -34.4741, -164.787, -37.1601, -164.787, -37.1601)
    ..cubicTo(-164.907, -37.3601, -165.112, -37.4994, -165.362, -37.5065)
    ..cubicTo(-165.405, -37.5101, -165.442, -37.4958, -165.483, -37.4922)
    ..cubicTo(-165.483, -37.4922, -179.765, -44.2928, -179.765, -44.2928)
    ..cubicTo(-179.765, -44.2928, -183.525, -48.6789, -183.525, -48.6789)
    ..cubicTo(-183.525, -48.6789, -185.094, -53.7007, -185.094, -53.7007)
    ..cubicTo(-185.094, -53.7007, -184.768, -68.0768, -184.768, -68.0768)
    ..cubicTo(-184.766, -68.134, -184.772, -68.1947, -184.785, -68.2483)
    ..cubicTo(-184.785, -68.2483, -188.061, -82.6673, -188.061, -82.6673)
    ..cubicTo(-188.061, -82.6673, -188.061, -102.68, -188.061, -102.68)
    ..cubicTo(-188.061, -103.069, -188.377, -103.387, -188.768, -103.387)
    ..cubicTo(-189.158, -103.387, -189.475, -103.069, -189.475, -102.68)
    ..cubicTo(-189.475, -102.68, -189.475, -82.5852, -189.475, -82.5852)
    ..cubicTo(-189.475, -82.5352, -189.469, -82.4816, -189.457, -82.428)
    ..cubicTo(-189.457, -82.428, -186.183, -68.0233, -186.183, -68.0233)
    ..cubicTo(-186.183, -68.0233, -186.51, -53.615, -186.51, -53.615)
    ..cubicTo(-186.512, -53.54, -186.501, -53.4614, -186.478, -53.3899)
    ..cubicTo(-186.478, -53.3899, -184.831, -48.1181, -184.831, -48.1181)
    ..cubicTo(-184.802, -48.0288, -184.755, -47.9431, -184.693, -47.8681)
    ..cubicTo(-184.693, -47.8681, -180.74, -43.257, -180.74, -43.257)
    ..cubicTo(-180.676, -43.182, -180.596, -43.1213, -180.508, -43.0784)
    ..cubicTo(-180.508, -43.0784, -166.104, -36.2207, -166.104, -36.2207)
    ..cubicTo(-166.104, -36.2207, -167.076, -0.5892, -167.076, -0.5892)
    ..cubicTo(-167.081, -0.3749, -166.993, -0.1749, -166.833, -0.0356)
    ..cubicTo(-166.674, 0.1037, -166.461, 0.1644, -166.253, 0.1287)
    ..cubicTo(-162.784, -0.4499, -145.56, 4.454, -135.684, 7.3221)
    ..cubicTo(-135.63, 7.3435, -135.574, 7.3614, -135.516, 7.3721)
    ..cubicTo(-134.885, 7.5543, -134.283, 7.7293, -133.719, 7.8936)
    ..cubicTo(-131.506, 8.5365, -129.745, 9.0472, -128.755, 9.3151)
    ..cubicTo(-123.371, 12.2796, -123.304, 12.3797, -120.433, 16.6086)
    ..cubicTo(-120.433, 16.6086, -119.562, 17.8872, -119.562, 17.8872)
    ..cubicTo(-119.562, 17.8872, -118.365, 20.7839, -118.365, 20.7839)
    ..cubicTo(-117.212, 23.5805, -115.824, 26.9416, -114.29, 30.6276)
    ..cubicTo(-151.31, 46.0895, -188.525, 62.323, -219.907, 81.9638)
    ..cubicTo(-219.907, 81.9638, -225.763, 67.9984, -225.763, 67.9984)
    ..cubicTo(-225.763, 67.9984, -222.824, 36.6495, -222.824, 36.6495)
    ..cubicTo(-222.824, 36.6495, -217.423, 22.409, -217.423, 22.409)
    ..cubicTo(-217.354, 22.2304, -217.364, 22.0376, -217.438, 21.8733)
    ..cubicTo(-217.896, 18.323, -218.425, -48.0181, -218.68, -80.0635)
    ..cubicTo(-218.769, -91.1751, -218.829, -98.69, -218.856, -100.215)
    ..cubicTo(-218.856, -100.215, -214.487, -108.952, -214.487, -108.952)
    ..cubicTo(-214.312, -109.302, -214.454, -109.723, -214.803, -109.898)
    ..cubicTo(-215.153, -110.073, -215.577, -109.934, -215.751, -109.584)
    ..cubicTo(-215.751, -109.584, -220.198, -100.69, -220.198, -100.69)
    ..cubicTo(-220.25, -100.587, -220.276, -100.472, -220.272, -100.354)
    ..cubicTo(-220.248, -99.3758, -220.183, -91.2716, -220.094, -80.0528)
    ..cubicTo(-219.958, -62.9514, -219.752, -37.11, -219.523, -15.9298)
    ..cubicTo(-219.397, -4.3074, -219.277, 4.7683, -219.165, 11.0403)
    ..cubicTo(-219.036, 18.3016, -218.988, 21.0161, -218.809, 22.0805)
    ..cubicTo(-218.809, 22.0805, -224.18, 36.2387, -224.18, 36.2387)
    ..cubicTo(-224.202, 36.2959, -224.216, 36.3602, -224.222, 36.4209)
    ..cubicTo(-224.222, 36.4209, -227.187, 68.0449, -227.187, 68.0449)
    ..cubicTo(-227.197, 68.1592, -227.18, 68.277, -227.135, 68.3842)
    ..cubicTo(-227.135, 68.3842, -221.118, 82.7318, -221.118, 82.7318)
    ..cubicTo(-224.251, 84.7105, -227.332, 86.7214, -230.34, 88.7715)
    ..cubicTo(-230.662, 88.993, -230.745, 89.4323, -230.525, 89.7538)
    ..cubicTo(-230.389, 89.9538, -230.167, 90.0645, -229.941, 90.0645)
    ..cubicTo(-229.804, 90.0645, -229.665, 90.0216, -229.543, 89.9395)
    ..cubicTo(-226.584, 87.9215, -223.554, 85.9428, -220.473, 83.9962)
    ..cubicTo(-220.352, 84.0819, -220.209, 84.1319, -220.059, 84.1319)
    ..cubicTo(-219.968, 84.1319, -219.876, 84.1176, -219.787, 84.0783)
    ..cubicTo(-219.475, 83.9497, -219.321, 83.6211, -219.378, 83.3032)
    ..cubicTo(-188.042, 63.6552, -150.799, 47.4075, -113.746, 31.9312)
    ..cubicTo(-107.126, 47.804, -98.0784, 68.9164, -93.1812, 76.8885)
    ..cubicTo(-90.5535, 81.0138, -87.6361, 85.3855, -84.5473, 90.0109)
    ..cubicTo(-78.4186, 99.1902, -71.6502, 109.337, -66.4126, 118.817)
    ..cubicTo(-66.4126, 118.817, -97.9537, 149.394, -97.9537, 149.394)
    ..cubicTo(-97.9537, 149.394, -109.972, 156.216, -109.972, 156.216)
    ..cubicTo(-109.972, 156.216, -110.144, 156.256, -110.144, 156.256)
    ..cubicTo(-114.85, 157.327, -127.351, 160.174, -131.127, 162.185)
    ..cubicTo(-131.127, 162.185, -131.099, 162.238, -131.099, 162.238)
    ..cubicTo(-132.117, 162.835, -136.978, 166.042, -163.135, 183.301)
    ..cubicTo(-163.461, 183.515, -163.551, 183.954, -163.336, 184.279)
    ..cubicTo(-163.2, 184.486, -162.975, 184.597, -162.745, 184.597)
    ..cubicTo(-162.612, 184.597, -162.476, 184.561, -162.357, 184.479)
    ..cubicTo(-162.357, 184.479, -130.532, 163.481, -130.462, 163.435)
    ..cubicTo(-126.853, 161.51, -114.04, 158.591, -109.83, 157.631)
    ..cubicTo(-109.83, 157.631, -109.557, 157.57, -109.557, 157.57)
    ..cubicTo(-109.489, 157.556, -109.425, 157.531, -109.365, 157.495)
    ..cubicTo(-109.365, 157.495, -97.1773, 150.58, -97.1773, 150.58)
    ..cubicTo(-97.1255, 150.548, -97.0772, 150.512, -97.0344, 150.469)
    ..cubicTo(-97.0344, 150.469, -65.709, 120.103, -65.709, 120.103)
    ..cubicTo(-64.5975, 122.16, -63.5585, 124.182, -62.6255, 126.15)
    ..cubicTo(-62.4884, 126.764, -61.5462, 131.004, -61.3576, 131.854)
    ..cubicTo(-61.5815, 132.936, -61.8594, 134.257, -62.1766, 135.761)
    ..cubicTo(-64.7704, 148.08, -69.599, 171.007, -69.2457, 179.311)
    ..cubicTo(-69.2443, 179.347, -69.24, 179.382, -69.2325, 179.418)
    ..cubicTo(-63.8692, 206.095, -46.8353, 239.08, -30.3619, 270.979)
    ..cubicTo(-20.8622, 289.373, -11.8896, 306.75, -5.9527, 321.512)
    ..cubicTo(-5.842, 321.787, -5.577, 321.955, -5.2966, 321.955)
    ..cubicTo(-5.2091, 321.955, -5.1198, 321.937, -5.0334, 321.905)
    ..cubicTo(-4.6712, 321.758, -4.4958, 321.347, -4.6412, 320.983)
    ..cubicTo(-10.6031, 306.161, -19.5906, 288.756, -29.1057, 270.329)
    ..cubicTo(-45.5234, 238.541, -62.4994, 205.667, -67.8352, 179.193)
    ..cubicTo(-68.1563, 171.017, -63.1849, 147.412, -60.7933, 136.05)
    ..cubicTo(-60.4611, 134.475, -60.1714, 133.1, -59.9425, 131.989)
    ..cubicTo(-59.9225, 131.893, -59.9232, 131.793, -59.945, 131.693)
    ..cubicTo(-59.945, 131.693, -60.6032, 128.728, -60.6032, 128.728)
    ..cubicTo(-61.0186, 126.86, -61.2044, 126.028, -61.3551, 125.635)
    ..cubicTo(-61.3551, 125.635, -61.314, 125.617, -61.314, 125.617)
    ..cubicTo(-62.3144, 123.503, -63.431, 121.328, -64.6325, 119.117)
    ..cubicTo(-64.6325, 119.117, -38.4597, 102.405, -38.4597, 102.405)
    ..cubicTo(-27.7652, 116.384, -16.4554, 129.578, -8.7908, 138.243)
    ..cubicTo(-8.7583, 138.283, -8.7222, 138.315, -8.6826, 138.343)
    ..cubicTo(-8.6826, 138.343, 1.5286, 145.919, 1.5286, 145.919)
    ..cubicTo(1.6025, 145.976, 1.6857, 146.015, 1.775, 146.037)
    ..cubicTo(1.775, 146.037, 15.9487, 149.648, 15.9487, 149.648)
    ..cubicTo(17.6367, 150.08, 18.3949, 150.273, 18.7832, 150.302)
    ..cubicTo(18.7832, 150.302, 18.7853, 150.341, 18.7853, 150.341)
    ..cubicTo(38.0697, 149.334, 53.1778, 134.325, 67.7879, 119.81)
    ..cubicTo(74.048, 113.591, 79.9606, 107.72, 86.0429, 103.094)
    ..cubicTo(86.3533, 102.858, 86.4137, 102.416, 86.1776, 102.105)
    ..cubicTo(85.9411, 101.794, 85.4982, 101.733, 85.1868, 101.969)
    ..cubicTo(79.0306, 106.652, 73.0858, 112.556, 66.7921, 118.806)
    ..cubicTo(52.397, 133.107, 37.5136, 147.891, 18.8178, 148.923)
    ..cubicTo(17.4945, 148.584, 3.7698, 145.087, 2.2593, 144.701)
    ..cubicTo(2.2593, 144.701, -7.7811, 137.254, -7.7811, 137.254)
    ..cubicTo(-15.4249, 128.607, -26.6794, 115.477, -37.3113, 101.583)
    ..cubicTo(-37.1724, 101.362, -37.1599, 101.069, -37.311, 100.833)
    ..cubicTo(-37.4846, 100.562, -37.8103, 100.462, -38.105, 100.547)
    ..cubicTo(-40.8034, 97.0008, -43.4515, 93.4112, -45.9856, 89.8395)
    ..cubicTo(-19.162, 70.9272, 46.2475, 26.4915, 74.8059, 7.5971)
    ..cubicTo(75.1313, 7.3828, 75.2206, 6.9435, 75.0052, 6.6185)
    ..cubicTo(74.7895, 6.2935, 74.3512, 6.2006, 74.0259, 6.4185)
    ..cubicTo(45.46, 25.3164, -19.9699, 69.77, -46.8021, 88.6858)
    ..cubicTo(-50.9971, 82.7175, -54.8453, 76.817, -58.0148, 71.2737)
    ..cubicTo(-58.1123, 71.063, -78.4454, 26.2736, -81.8953, 18.673)
    ..cubicTo(-53.8373, 6.9364, -27.3001, -4.6074, -3.3114, -17.7371)
    ..cubicTo(-3.3114, -17.7371, -3.3275, -17.7656, -3.3275, -17.7656)
    ..cubicTo(-3.0261, -17.9835, -2.466, -18.5657, -1.057, -20.0265)
    ..cubicTo(-1.057, -20.0265, 10.0468, -31.5418, 10.0468, -31.5418)
    ..cubicTo(10.0561, -31.5453, 10.065, -31.5489, 10.0739, -31.5525)
    ..cubicTo(10.4232, -31.7239, 10.8086, -32.4883, 11.3726, -34.7063)
    ..cubicTo(11.3726, -34.7063, 50.1018, -38.0744, 50.1018, -38.0744)
    ..cubicTo(50.4911, -38.1066, 50.7786, -38.4495, 50.7451, -38.8388)
    ..cubicTo(50.7115, -39.2281, 50.3682, -39.521, 49.98, -39.4817)
    ..cubicTo(49.98, -39.4817, 11.719, -36.1528, 11.719, -36.1528)
    ..cubicTo(12.8138, -40.9675, 14.5146, -50.5254, 17.5431, -69.1412)
    ..cubicTo(18.136, -72.7844, 18.6507, -75.9489, 18.7585, -76.4204)
    ..cubicTo(19.22, -77.4312, 25.7998, -91.8216, 26.5652, -93.4968)
    ..cubicTo(26.5652, -93.4968, 36.7489, -101.369, 36.7489, -101.369)
    ..cubicTo(39.7074, -96.7256, 42.7697, -92.2288, 45.6175, -88.0499)
    ..cubicTo(47.7698, -84.8889, 49.8057, -81.8994, 51.608, -79.1313)
    ..cubicTo(51.608, -79.1313, 50.3297, -70.502, 50.3297, -70.502)
    ..cubicTo(50.3018, -70.3127, 50.3518, -70.1199, 50.4686, -69.9698)
    ..cubicTo(50.5854, -69.8163, 50.759, -69.7198, 50.9497, -69.6948)
    ..cubicTo(50.9497, -69.6948, 78.8559, -66.5374, 78.8559, -66.5374)
    ..cubicTo(79.1549, -64.6051, 79.3149, -62.1585, 79.5663, -58.2868)
    ..cubicTo(79.5663, -58.2868, 79.6388, -57.1759, 79.6388, -57.1759)
    ..cubicTo(79.6413, -57.1367, 79.6477, -57.0938, 79.6574, -57.0545)
    ..cubicTo(79.6974, -56.8902, 83.2802, -41.9069, 83.2802, -41.9069)
    ..cubicTo(83.2909, -41.864, 83.3052, -41.8211, 83.3238, -41.7818)
    ..cubicTo(83.3238, -41.7818, 87.8384, -31.7846, 87.8384, -31.7846)
    ..cubicTo(87.8384, -31.7846, 87.2305, -29.0487, 87.2305, -29.0487)
    ..cubicTo(87.2144, -28.9772, 87.2119, -28.9023, 87.2191, -28.8273)
    ..cubicTo(77.9951, -21.3267, 68.4426, -12.9652, 63.0664, -8.0041)
    ..cubicTo(62.7796, -7.7398, 62.7617, -7.2934, 63.0264, -7.0041)
    ..cubicTo(63.1657, -6.8541, 63.3554, -6.779, 63.5461, -6.779)
    ..cubicTo(63.7172, -6.779, 63.889, -6.8398, 64.0251, -6.9648)
    ..cubicTo(69.3308, -11.8616, 78.7127, -20.0765, 87.8088, -27.4879)
    ..cubicTo(90.674, -21.4802, 90.9872, -20.9123, 96.6745, -15.8512)
    ..cubicTo(96.6745, -15.8512, 96.6973, -15.8762, 96.6973, -15.8762)
    ..cubicTo(97.0892, -15.6619, 98.0082, -15.419, 100.093, -14.8726)
    ..cubicTo(100.093, -14.8726, 103.222, -14.0475, 103.222, -14.0475)
    ..cubicTo(103.281, -14.0332, 103.341, -14.026, 103.402, -14.026)
    ..cubicTo(103.478, -14.026, 103.553, -14.0368, 103.626, -14.0618)
    ..cubicTo(103.626, -14.0618, 111.406, -16.6548, 111.406, -16.6548)
    ..cubicTo(111.406, -16.6548, 116.743, -16.3941, 116.743, -16.3941)
    ..cubicTo(116.743, -16.3941, 105.357, 23.9449, 105.357, 23.9449)
    ..cubicTo(105.341, 24.002, 105.332, 24.0627, 105.331, 24.1234)
    ..cubicTo(105.331, 24.1234, 104.805, 54.3438, 104.805, 54.3438)
    ..cubicTo(81.6833, 54.0545, 59.6308, 52.3829, 45.9522, 48.4897)
    ..cubicTo(45.5753, 48.3826, 45.1857, 48.6005, 45.0785, 48.9755)
    ..cubicTo(44.9721, 49.3505, 45.1892, 49.7434, 45.565, 49.8506)
    ..cubicTo(60.0547, 53.9759, 82.228, 55.5724, 104.779, 55.8153)
    ..cubicTo(104.779, 55.8153, 104.013, 99.8832, 104.013, 99.8832)
    ..cubicTo(104.006, 100.276, 104.317, 100.597, 104.707, 100.601)
    ..cubicTo(104.712, 100.601, 104.716, 100.601, 104.72, 100.601)
    ..cubicTo(105.104, 100.601, 105.419, 100.294, 105.427, 99.9082)
    ..cubicTo(105.427, 99.9082, 106.193, 55.8296, 106.193, 55.8296)
    ..cubicTo(107.813, 55.8439, 109.438, 55.851, 111.06, 55.851)
    ..cubicTo(121.754, 55.851, 132.38, 55.5689, 142.162, 55.1295)
    ..cubicTo(141.927, 57.7833, 141.973, 59.4727, 142.352, 60.1228)
    ..cubicTo(146.491, 65.9304, 152.124, 73.5453, 158.65, 82.3603)
    ..cubicTo(163.757, 89.2644, 169.425, 96.9293, 175.369, 105.066)
    ..cubicTo(164.396, 106.659, 153.267, 108.034, 142.28, 109.387)
    ..cubicTo(130.929, 110.788, 120.204, 112.109, 109.921, 113.638)
    ..cubicTo(109.921, 113.638, 104.575, 107.977, 104.575, 107.977)
    ..cubicTo(104.306, 107.691, 103.858, 107.68, 103.576, 107.948)
    ..cubicTo(103.291, 108.216, 103.279, 108.662, 103.547, 108.945)
    ..cubicTo(103.547, 108.945, 109.146, 114.874, 109.146, 114.874)
    ..cubicTo(109.281, 115.017, 109.467, 115.095, 109.66, 115.095)
    ..cubicTo(109.696, 115.095, 109.731, 115.095, 109.763, 115.088)
    ..cubicTo(114.11, 114.441, 118.543, 113.831, 123.064, 113.234)
    ..cubicTo(123.064, 113.234, 111.914, 120.381, 111.914, 120.381)
    ..cubicTo(111.585, 120.592, 111.492, 121.031, 111.699, 121.36)
    ..cubicTo(111.835, 121.571, 112.064, 121.685, 112.296, 121.685)
    ..cubicTo(112.428, 121.685, 112.56, 121.649, 112.678, 121.571)
    ..cubicTo(112.678, 121.571, 125.525, 113.338, 125.525, 113.338)
    ..cubicTo(125.693, 113.227, 125.797, 113.056, 125.833, 112.874)
    ..cubicTo(131.229, 112.173, 136.762, 111.491, 142.452, 110.791)
    ..cubicTo(153.692, 109.405, 165.086, 107.995, 176.312, 106.355)
    ..cubicTo(202.539, 142.308, 233.738, 187.076, 245.557, 216.457)
    ..cubicTo(245.557, 216.457, 245.442, 216.5, 245.442, 216.5)
    ..cubicTo(245.078, 216.643, 244.899, 217.053, 245.042, 217.418)
    ..cubicTo(245.149, 217.696, 245.417, 217.868, 245.699, 217.868)
    ..cubicTo(245.785, 217.868, 245.871, 217.85, 245.957, 217.818)
    ..cubicTo(245.957, 217.818, 246.074, 217.771, 246.074, 217.771)
    ..cubicTo(247.682, 221.914, 248.892, 225.74, 249.618, 229.165)
    ..cubicTo(249.643, 229.286, 249.7, 229.394, 249.778, 229.483)
    ..cubicTo(249.943, 229.676, 255.372, 236.062, 255.372, 236.062)
    ..cubicTo(255.443, 236.148, 255.536, 236.216, 255.639, 236.258)
    ..cubicTo(264.137, 239.787, 281.688, 247.631, 290.032, 251.97)
    ..cubicTo(290.032, 251.97, 296.764, 260.625, 296.764, 260.625)
    ..cubicTo(296.764, 260.625, 299.675, 272.265, 299.675, 272.265)
    ..cubicTo(299.675, 272.265, 299.982, 281.559, 299.982, 281.559)
    ..cubicTo(294.396, 283.477, 288.874, 285.037, 283.52, 285.955)
    ..cubicTo(268.891, 285.87, 234.859, 286.123, 216.976, 286.288)
    ..cubicTo(206.157, 287.284, 183.044, 294.517, 171.018, 298.842)
    ..cubicTo(170.986, 298.853, 170.954, 298.867, 170.922, 298.885)
    ..cubicTo(170.922, 298.885, 143.409, 313.615, 143.409, 313.615)
    ..cubicTo(140.294, 315.283, 138.973, 315.99, 138.401, 316.358)
    ..cubicTo(138.401, 316.358, 138.384, 316.311, 138.384, 316.311)
    ..cubicTo(124.65, 321.855, 96.7184, 335.013, 82.6301, 343.031)
    ..cubicTo(82.5637, 343.071, 82.5037, 343.117, 82.4526, 343.174)
    ..cubicTo(82.4526, 343.174, 71.5824, 355.361, 71.5824, 355.361)
    ..cubicTo(71.4871, 355.468, 71.4264, 355.604, 71.4089, 355.747)
    ..cubicTo(71.4089, 355.747, 69.4323, 371.555, 69.4323, 371.555)
    ..cubicTo(69.3841, 371.944, 69.6587, 372.298, 70.0459, 372.344)
    ..cubicTo(70.0756, 372.348, 70.1052, 372.352, 70.1345, 372.352)
    ..cubicTo(70.4856, 372.352, 70.7903, 372.091, 70.8349, 371.73)
    ..cubicTo(70.8349, 371.73, 72.784, 356.14, 72.784, 356.14)
    ..cubicTo(72.784, 356.14, 83.4298, 344.203, 83.4298, 344.203)
    ..cubicTo(97.5049, 336.202, 125.25, 323.137, 138.912, 317.622)
    ..cubicTo(138.937, 317.611, 138.962, 317.601, 138.984, 317.586)
    ..cubicTo(139.198, 317.472, 170.154, 300.899, 171.543, 300.153)
    ..cubicTo(183.519, 295.853, 206.432, 288.681, 217.047, 287.698)
    ..cubicTo(234.895, 287.534, 268.994, 287.284, 283.574, 287.37)
    ..cubicTo(283.62, 287.37, 283.656, 287.366, 283.699, 287.359)
    ..cubicTo(288.881, 286.473, 294.203, 285.002, 299.582, 283.191)
    ..cubicTo(299.582, 283.191, 298.389, 286.766, 298.389, 286.766)
    ..cubicTo(298.268, 287.138, 298.468, 287.538, 298.836, 287.663)
    ..cubicTo(298.911, 287.688, 298.986, 287.698, 299.061, 287.698)
    ..cubicTo(299.357, 287.698, 299.632, 287.509, 299.732, 287.213)
    ..cubicTo(299.732, 287.213, 301.265, 282.612, 301.265, 282.612)
    ..cubicTo(309.208, 279.841, 317.255, 276.38, 325.152, 272.979)
    ..cubicTo(336.996, 267.879, 349.229, 262.618, 360.591, 259.96)
    ..cubicTo(360.591, 259.96, 360.28, 277.426, 360.28, 277.426)
    ..cubicTo(360.277, 277.555, 360.312, 277.683, 360.376, 277.798)
    ..cubicTo(360.376, 277.798, 367.884, 290.531, 367.884, 290.531)
    ..cubicTo(367.884, 290.531, 368.524, 294.352, 368.524, 294.352)
    ..cubicTo(368.581, 294.699, 368.881, 294.945, 369.22, 294.945)
    ..cubicTo(369.259, 294.945, 369.299, 294.942, 369.338, 294.935)
    ..cubicTo(369.72, 294.87, 369.981, 294.506, 369.917, 294.12)
    ..cubicTo(369.917, 294.12, 369.259, 290.17, 369.259, 290.17)
    ..cubicTo(369.245, 290.081, 369.213, 289.999, 369.17, 289.927)
    ..cubicTo(369.17, 289.927, 361.694, 277.251, 361.694, 277.251)
    ..cubicTo(361.694, 277.251, 362.009, 259.689, 362.009, 259.689)
    ..cubicTo(362.009, 259.689, 373.435, 259.371, 373.435, 259.371)
    ..cubicTo(373.435, 259.371, 390.804, 263.307, 390.804, 263.307)
    ..cubicTo(391.183, 263.389, 391.565, 263.153, 391.65, 262.771)
    ..cubicTo(391.736, 262.393, 391.497, 262.014, 391.115, 261.925)
    ..cubicTo(391.115, 261.925, 391.115, 261.925, 391.115, 261.925)
    ..close();

  static final Path __path27_1_24 = Path()
    ..moveTo(50.3839, 268.576)
    ..cubicTo(50.3839, 268.576, 38.1897, 243.677, 38.1897, 243.677)
    ..cubicTo(38.1279, 243.552, 38.0011, 243.481, 37.87, 243.485)
    ..cubicTo(45.0178, 240.106, 52.3173, 236.688, 59.7104, 233.334)
    ..cubicTo(63.8943, 242.177, 67.745, 250.649, 70.6995, 258.804)
    ..cubicTo(70.6995, 258.804, 50.3839, 268.576, 50.3839, 268.576)
    ..cubicTo(50.3839, 268.576, 50.3839, 268.576, 50.3839, 268.576)
    ..close();

  static final Path __path27_1_25 = Path()
    ..moveTo(29.1586, 278.784)
    ..cubicTo(29.0654, 278.727, 28.9504, 278.709, 28.8425, 278.752)
    ..cubicTo(28.7215, 278.802, 28.6486, 278.912, 28.6332, 279.034)
    ..cubicTo(28.6332, 279.034, 28.1614, 279.262, 28.1614, 279.262)
    ..cubicTo(28.1614, 279.262, 16.4276, 253.635, 16.4276, 253.635)
    ..cubicTo(20.4072, 251.764, 24.4533, 249.842, 28.5564, 247.896)
    ..cubicTo(31.5385, 246.481, 34.5566, 245.049, 37.6, 243.61)
    ..cubicTo(37.5154, 243.713, 37.4918, 243.86, 37.5543, 243.988)
    ..cubicTo(37.5543, 243.988, 49.7464, 268.883, 49.7464, 268.883)
    ..cubicTo(49.7464, 268.883, 29.1586, 278.784, 29.1586, 278.784)
    ..cubicTo(29.1586, 278.784, 29.1586, 278.784, 29.1586, 278.784)
    ..close();

  static final Path __path27_1_26 = Path()
    ..moveTo(48.0134, 208.485)
    ..cubicTo(50.6393, 214.329, 53.4452, 220.201, 56.2172, 225.997)
    ..cubicTo(57.2973, 228.258, 58.3596, 230.487, 59.4075, 232.698)
    ..cubicTo(48.7709, 237.52, 38.3244, 242.477, 28.2532, 247.256)
    ..cubicTo(24.1529, 249.203, 20.1101, 251.121, 16.1337, 252.996)
    ..cubicTo(16.1337, 252.996, 4.6035, 227.815, 4.6035, 227.815)
    ..cubicTo(19.655, 220.879, 34.3987, 214.239, 48.0134, 208.485)
    ..cubicTo(48.0134, 208.485, 48.0134, 208.485, 48.0134, 208.485)
    ..close();

  static final Path __path27_1_27 = Path()
    ..moveTo(60.3551, 233.044)
    ..cubicTo(76.7293, 225.63, 93.5421, 218.55, 110.118, 212.932)
    ..cubicTo(110.611, 214.714, 111.078, 216.39, 111.503, 217.9)
    ..cubicTo(112.093, 220.018, 112.596, 221.819, 112.961, 223.172)
    ..cubicTo(113.004, 223.333, 113.146, 223.437, 113.304, 223.437)
    ..cubicTo(113.332, 223.437, 113.364, 223.429, 113.393, 223.422)
    ..cubicTo(113.582, 223.372, 113.693, 223.179, 113.643, 222.99)
    ..cubicTo(113.279, 221.633, 112.775, 219.829, 112.182, 217.711)
    ..cubicTo(111.757, 216.19, 111.286, 214.504, 110.789, 212.704)
    ..cubicTo(121.59, 209.068, 132.284, 206.06, 142.688, 203.996)
    ..cubicTo(142.877, 203.956, 143.002, 203.771, 142.963, 203.578)
    ..cubicTo(142.927, 203.388, 142.742, 203.263, 142.549, 203.303)
    ..cubicTo(132.127, 205.371, 121.415, 208.382, 110.6, 212.021)
    ..cubicTo(107.1, 199.324, 102.415, 181.43, 102.785, 174.679)
    ..cubicTo(102.796, 174.486, 102.647, 174.318, 102.452, 174.308)
    ..cubicTo(102.259, 174.29, 102.09, 174.447, 102.08, 174.643)
    ..cubicTo(101.704, 181.501, 106.416, 199.506, 109.932, 212.25)
    ..cubicTo(93.311, 217.879, 76.4603, 224.976, 60.0526, 232.405)
    ..cubicTo(58.9896, 230.159, 57.9188, 227.919, 56.8548, 225.694)
    ..cubicTo(54.0835, 219.897, 51.2783, 214.025, 48.6538, 208.185)
    ..cubicTo(48.7573, 208.085, 48.7963, 207.932, 48.7377, 207.792)
    ..cubicTo(48.677, 207.65, 48.5323, 207.571, 48.3848, 207.582)
    ..cubicTo(46.3772, 203.096, 44.4849, 198.631, 42.8037, 194.238)
    ..cubicTo(42.8622, 194.106, 42.838, 193.945, 42.7276, 193.841)
    ..cubicTo(42.7276, 193.841, 42.6119, 193.731, 42.6119, 193.731)
    ..cubicTo(41.0339, 189.57, 39.6438, 185.469, 38.5419, 181.487)
    ..cubicTo(38.4897, 181.297, 38.294, 181.187, 38.1072, 181.24)
    ..cubicTo(37.919, 181.29, 37.8086, 181.487, 37.8608, 181.672)
    ..cubicTo(38.8462, 185.237, 40.0563, 188.887, 41.4271, 192.595)
    ..cubicTo(41.4271, 192.595, 34.822, 186.266, 34.822, 186.266)
    ..cubicTo(34.6812, 186.13, 34.4573, 186.134, 34.3226, 186.276)
    ..cubicTo(34.1873, 186.416, 34.1923, 186.641, 34.3333, 186.776)
    ..cubicTo(34.3333, 186.776, 42.0075, 194.131, 42.0075, 194.131)
    ..cubicTo(43.7237, 198.642, 45.6632, 203.228, 47.7248, 207.839)
    ..cubicTo(34.1062, 213.596, 19.3611, 220.236, 4.3095, 227.173)
    ..cubicTo(4.3095, 227.173, -0.3455, 217.007, -0.3455, 217.007)
    ..cubicTo(-0.4266, 216.829, -0.6366, 216.75, -0.8141, 216.832)
    ..cubicTo(-0.9916, 216.915, -1.0692, 217.122, -0.9881, 217.3)
    ..cubicTo(-0.9881, 217.3, 3.6673, 227.469, 3.6673, 227.469)
    ..cubicTo(-7.0711, 232.419, -17.9562, 237.509, -28.6939, 242.534)
    ..cubicTo(-53.9763, 254.364, -80.1191, 266.594, -103.246, 276.448)
    ..cubicTo(-103.426, 276.523, -103.509, 276.73, -103.432, 276.912)
    ..cubicTo(-103.375, 277.044, -103.245, 277.127, -103.107, 277.127)
    ..cubicTo(-103.061, 277.127, -103.014, 277.116, -102.969, 277.098)
    ..cubicTo(-79.8309, 267.24, -53.6823, 255.007, -28.3942, 243.174)
    ..cubicTo(-17.658, 238.152, -6.775, 233.059, 3.9616, 228.112)
    ..cubicTo(3.9616, 228.112, 27.6685, 279.884, 27.6685, 279.884)
    ..cubicTo(27.7078, 279.97, 27.7807, 280.038, 27.8696, 280.07)
    ..cubicTo(27.9089, 280.084, 27.9496, 280.091, 27.99, 280.091)
    ..cubicTo(28.0425, 280.091, 28.095, 280.08, 28.1432, 280.055)
    ..cubicTo(28.1432, 280.055, 28.859, 279.713, 28.859, 279.713)
    ..cubicTo(28.859, 279.713, 31.9464, 287.12, 31.9464, 287.12)
    ..cubicTo(32.0028, 287.256, 32.1339, 287.338, 32.2725, 287.338)
    ..cubicTo(32.3178, 287.338, 32.3635, 287.327, 32.4082, 287.31)
    ..cubicTo(32.5882, 287.235, 32.6736, 287.027, 32.5986, 286.849)
    ..cubicTo(32.5986, 286.849, 29.4969, 279.405, 29.4969, 279.405)
    ..cubicTo(29.4969, 279.405, 50.0575, 269.515, 50.0575, 269.515)
    ..cubicTo(50.0575, 269.515, 53.3427, 276.223, 53.3427, 276.223)
    ..cubicTo(53.3427, 276.223, 55.9694, 291.653, 55.9694, 291.653)
    ..cubicTo(55.9987, 291.828, 56.148, 291.949, 56.3173, 291.949)
    ..cubicTo(56.3369, 291.949, 56.3569, 291.946, 56.3769, 291.942)
    ..cubicTo(56.5694, 291.91, 56.6987, 291.728, 56.6659, 291.535)
    ..cubicTo(56.6659, 291.535, 54.031, 276.055, 54.031, 276.055)
    ..cubicTo(54.0253, 276.023, 54.0149, 275.991, 54.0003, 275.959)
    ..cubicTo(54.0003, 275.959, 50.6947, 269.212, 50.6947, 269.212)
    ..cubicTo(50.6947, 269.212, 71.2935, 259.304, 71.2935, 259.304)
    ..cubicTo(71.4567, 259.225, 71.5338, 259.036, 71.4724, 258.864)
    ..cubicTo(68.5168, 250.653, 64.5076, 241.827, 60.3551, 233.044)
    ..cubicTo(60.3551, 233.044, 60.3551, 233.044, 60.3551, 233.044)
    ..close();

  static final Path __path27_1_28 = Path()
    ..moveTo(212.964, 238.9)
    ..cubicTo(212.964, 238.9, 195.17, 245.987, 195.17, 245.987)
    ..cubicTo(195.17, 245.987, 192.984, 240.247, 192.984, 240.247)
    ..cubicTo(192.984, 240.247, 210.614, 232.893, 210.614, 232.893)
    ..cubicTo(210.614, 232.893, 213.089, 238.875, 213.089, 238.875)
    ..cubicTo(213.05, 238.879, 213.007, 238.883, 212.964, 238.9)
    ..cubicTo(212.964, 238.9, 212.964, 238.9, 212.964, 238.9)
    ..close();

  static final Path __path27_1_29 = Path()
    ..moveTo(183.487, 243.44)
    ..cubicTo(183.487, 243.44, 175.375, 238.136, 175.375, 238.136)
    ..cubicTo(175.375, 238.136, 180.061, 230.95, 180.061, 230.95)
    ..cubicTo(180.061, 230.95, 182.944, 229.828, 182.944, 229.828)
    ..cubicTo(187.023, 228.239, 193.234, 225.821, 198.334, 223.821)
    ..cubicTo(198.334, 223.821, 202.888, 234.75, 202.888, 234.75)
    ..cubicTo(202.945, 234.889, 203.077, 234.968, 203.213, 234.968)
    ..cubicTo(203.26, 234.968, 203.306, 234.961, 203.349, 234.943)
    ..cubicTo(203.531, 234.868, 203.617, 234.661, 203.542, 234.479)
    ..cubicTo(203.542, 234.479, 198.991, 223.56, 198.991, 223.56)
    ..cubicTo(201.799, 222.456, 204.213, 221.499, 205.656, 220.913)
    ..cubicTo(205.656, 220.913, 210.342, 232.239, 210.342, 232.239)
    ..cubicTo(210.342, 232.239, 192.734, 239.586, 192.734, 239.586)
    ..cubicTo(192.734, 239.586, 192.673, 239.433, 192.673, 239.433)
    ..cubicTo(192.605, 239.247, 192.398, 239.158, 192.219, 239.226)
    ..cubicTo(192.037, 239.297, 191.944, 239.501, 192.016, 239.683)
    ..cubicTo(192.016, 239.683, 192.08, 239.858, 192.08, 239.858)
    ..cubicTo(192.08, 239.858, 183.487, 243.44, 183.487, 243.44)
    ..cubicTo(183.487, 243.44, 183.487, 243.44, 183.487, 243.44)
    ..close();

  static final Path __path27_1_30 = Path()
    ..moveTo(249.992, 226.592)
    ..cubicTo(249.924, 226.407, 249.721, 226.314, 249.538, 226.378)
    ..cubicTo(249.538, 226.378, 213.953, 239.111, 213.953, 239.111)
    ..cubicTo(213.953, 239.111, 211.267, 232.621, 211.267, 232.621)
    ..cubicTo(211.267, 232.621, 245.181, 218.474, 245.181, 218.474)
    ..cubicTo(245.363, 218.399, 245.449, 218.192, 245.374, 218.01)
    ..cubicTo(245.299, 217.831, 245.088, 217.749, 244.909, 217.82)
    ..cubicTo(244.909, 217.82, 210.996, 231.968, 210.996, 231.968)
    ..cubicTo(210.996, 231.968, 206.174, 220.317, 206.174, 220.317)
    ..cubicTo(206.103, 220.138, 205.896, 220.053, 205.713, 220.124)
    ..cubicTo(204.331, 220.695, 201.752, 221.713, 198.72, 222.906)
    ..cubicTo(198.72, 222.906, 198.599, 222.621, 198.599, 222.621)
    ..cubicTo(198.524, 222.442, 198.316, 222.36, 198.138, 222.431)
    ..cubicTo(197.956, 222.506, 197.873, 222.713, 197.948, 222.896)
    ..cubicTo(197.948, 222.896, 198.059, 223.167, 198.059, 223.167)
    ..cubicTo(192.966, 225.167, 186.762, 227.582, 182.687, 229.171)
    ..cubicTo(182.687, 229.171, 179.697, 230.336, 179.697, 230.336)
    ..cubicTo(179.629, 230.361, 179.572, 230.411, 179.533, 230.471)
    ..cubicTo(179.533, 230.471, 174.589, 238.047, 174.589, 238.047)
    ..cubicTo(174.482, 238.211, 174.529, 238.429, 174.693, 238.536)
    ..cubicTo(174.693, 238.536, 183.258, 244.137, 183.258, 244.137)
    ..cubicTo(183.315, 244.172, 183.383, 244.194, 183.451, 244.194)
    ..cubicTo(183.497, 244.194, 183.544, 244.183, 183.587, 244.165)
    ..cubicTo(183.587, 244.165, 192.334, 240.518, 192.334, 240.518)
    ..cubicTo(192.334, 240.518, 194.516, 246.248, 194.516, 246.248)
    ..cubicTo(194.516, 246.248, 174.097, 254.38, 174.097, 254.38)
    ..cubicTo(173.914, 254.452, 173.829, 254.659, 173.9, 254.841)
    ..cubicTo(173.954, 254.977, 174.089, 255.062, 174.229, 255.062)
    ..cubicTo(174.272, 255.062, 174.314, 255.055, 174.357, 255.037)
    ..cubicTo(174.357, 255.037, 194.973, 246.826, 194.973, 246.826)
    ..cubicTo(194.977, 246.826, 194.977, 246.83, 194.98, 246.83)
    ..cubicTo(195.023, 246.83, 195.063, 246.819, 195.105, 246.805)
    ..cubicTo(195.152, 246.787, 195.195, 246.758, 195.227, 246.726)
    ..cubicTo(195.227, 246.726, 213.225, 239.558, 213.225, 239.558)
    ..cubicTo(213.271, 239.54, 213.31, 239.511, 213.343, 239.483)
    ..cubicTo(213.343, 239.483, 213.428, 239.693, 213.428, 239.693)
    ..cubicTo(213.5, 239.865, 213.696, 239.951, 213.875, 239.89)
    ..cubicTo(213.875, 239.89, 249.778, 227.042, 249.778, 227.042)
    ..cubicTo(249.96, 226.978, 250.056, 226.774, 249.992, 226.592)
    ..cubicTo(249.992, 226.592, 249.992, 226.592, 249.992, 226.592)
    ..close();

  static final Path __path27_1_31 = Path()
    ..moveTo(202.208, 341.166)
    ..cubicTo(202.208, 341.166, 199.243, 335.566, 199.243, 335.566)
    ..cubicTo(199.182, 335.452, 199.061, 335.38, 198.932, 335.38)
    ..cubicTo(198.932, 335.38, 112.132, 334.723, 112.132, 334.723)
    ..cubicTo(112.132, 334.723, 108.286, 330.233, 108.286, 330.233)
    ..cubicTo(108.161, 330.083, 107.936, 330.069, 107.789, 330.194)
    ..cubicTo(107.639, 330.319, 107.621, 330.544, 107.75, 330.691)
    ..cubicTo(107.75, 330.691, 111.7, 335.302, 111.7, 335.302)
    ..cubicTo(111.768, 335.38, 111.865, 335.427, 111.968, 335.427)
    ..cubicTo(111.968, 335.427, 177.495, 335.923, 177.495, 335.923)
    ..cubicTo(177.495, 335.923, 177.495, 369.99, 177.495, 369.99)
    ..cubicTo(177.495, 370.187, 177.652, 370.344, 177.848, 370.344)
    ..cubicTo(178.045, 370.344, 178.202, 370.187, 178.202, 369.99)
    ..cubicTo(178.202, 369.99, 178.202, 335.93, 178.202, 335.93)
    ..cubicTo(178.202, 335.93, 198.718, 336.084, 198.718, 336.084)
    ..cubicTo(198.718, 336.084, 201.543, 341.427, 201.543, 341.427)
    ..cubicTo(201.543, 341.427, 202.529, 366.051, 202.529, 366.051)
    ..cubicTo(202.536, 366.24, 202.693, 366.39, 202.883, 366.39)
    ..cubicTo(202.886, 366.39, 202.893, 366.39, 202.897, 366.39)
    ..cubicTo(203.09, 366.383, 203.243, 366.218, 203.236, 366.022)
    ..cubicTo(203.236, 366.022, 202.247, 341.32, 202.247, 341.32)
    ..cubicTo(202.247, 341.266, 202.233, 341.213, 202.208, 341.166)
    ..cubicTo(202.208, 341.166, 202.208, 341.166, 202.208, 341.166)
    ..close();

  static final Path __path27_1_32 = Path()
    ..moveTo(248.98, 351.522)
    ..cubicTo(246.684, 351.468, 240.276, 351.243, 239.254, 351.208)
    ..cubicTo(239.254, 351.208, 222.264, 334.538, 222.264, 334.538)
    ..cubicTo(222.264, 334.538, 216.731, 324.452, 216.731, 324.452)
    ..cubicTo(216.731, 324.452, 216.599, 312.029, 216.599, 312.029)
    ..cubicTo(216.631, 312.04, 216.663, 312.051, 216.703, 312.051)
    ..cubicTo(216.703, 312.051, 234.154, 312.376, 234.154, 312.376)
    ..cubicTo(234.154, 312.376, 234.8, 330.817, 234.8, 330.817)
    ..cubicTo(234.804, 330.938, 234.872, 331.049, 234.979, 331.109)
    ..cubicTo(234.979, 331.109, 237.283, 332.427, 237.283, 332.427)
    ..cubicTo(237.34, 332.46, 237.404, 332.485, 237.468, 332.474)
    ..cubicTo(237.468, 332.474, 243.712, 332.331, 243.712, 332.331)
    ..cubicTo(243.712, 332.331, 248.98, 351.522, 248.98, 351.522)
    ..cubicTo(248.98, 351.522, 248.98, 351.522, 248.98, 351.522)
    ..close();

  static final Path __path27_1_33 = Path()
    ..moveTo(233.493, 293.621)
    ..cubicTo(233.493, 293.621, 234.129, 311.669, 234.129, 311.669)
    ..cubicTo(234.129, 311.669, 216.713, 311.347, 216.713, 311.347)
    ..cubicTo(216.674, 311.347, 216.631, 311.358, 216.592, 311.372)
    ..cubicTo(216.592, 311.372, 216.406, 294.253, 216.406, 294.253)
    ..cubicTo(216.406, 294.253, 233.493, 293.621, 233.493, 293.621)
    ..cubicTo(233.493, 293.621, 233.493, 293.621, 233.493, 293.621)
    ..close();

  static final Path __path27_1_34 = Path()
    ..moveTo(266.471, 349.493)
    ..cubicTo(266.471, 349.493, 266.471, 286.334, 266.471, 286.334)
    ..cubicTo(266.471, 286.142, 266.31, 285.981, 266.117, 285.981)
    ..cubicTo(265.921, 285.981, 265.764, 286.142, 265.764, 286.334)
    ..cubicTo(265.764, 286.334, 265.764, 331.117, 265.764, 331.117)
    ..cubicTo(265.764, 331.117, 244.248, 331.609, 244.248, 331.609)
    ..cubicTo(244.248, 331.609, 243.74, 329.766, 243.74, 329.766)
    ..cubicTo(243.74, 329.766, 243.74, 286.334, 243.74, 286.334)
    ..cubicTo(243.74, 286.142, 243.583, 285.981, 243.387, 285.981)
    ..cubicTo(243.194, 285.981, 243.033, 286.142, 243.033, 286.334)
    ..cubicTo(243.033, 286.334, 243.033, 329.816, 243.033, 329.816)
    ..cubicTo(243.033, 329.849, 243.037, 329.877, 243.048, 329.909)
    ..cubicTo(243.048, 329.909, 243.519, 331.627, 243.519, 331.627)
    ..cubicTo(243.519, 331.627, 237.551, 331.767, 237.551, 331.767)
    ..cubicTo(237.551, 331.767, 235.5, 330.595, 235.5, 330.595)
    ..cubicTo(235.5, 330.595, 234.19, 293.239, 234.19, 293.239)
    ..cubicTo(234.186, 293.146, 234.143, 293.056, 234.075, 292.992)
    ..cubicTo(234.007, 292.931, 233.911, 292.896, 233.822, 292.899)
    ..cubicTo(233.822, 292.899, 216.42, 293.546, 216.42, 293.546)
    ..cubicTo(216.42, 293.546, 216.731, 287.342, 216.731, 287.342)
    ..cubicTo(216.742, 287.145, 216.592, 286.981, 216.395, 286.97)
    ..cubicTo(216.185, 286.949, 216.035, 287.113, 216.024, 287.306)
    ..cubicTo(216.024, 287.306, 215.695, 293.892, 215.695, 293.892)
    ..cubicTo(215.695, 293.896, 215.699, 293.899, 215.699, 293.903)
    ..cubicTo(215.699, 293.91, 215.695, 293.91, 215.695, 293.917)
    ..cubicTo(215.695, 293.917, 216.024, 324.548, 216.024, 324.548)
    ..cubicTo(216.024, 324.609, 216.042, 324.663, 216.067, 324.716)
    ..cubicTo(216.067, 324.716, 221.667, 334.928, 221.667, 334.928)
    ..cubicTo(221.685, 334.956, 221.707, 334.985, 221.732, 335.01)
    ..cubicTo(221.732, 335.01, 238.858, 351.808, 238.858, 351.808)
    ..cubicTo(238.922, 351.868, 239.004, 351.904, 239.094, 351.908)
    ..cubicTo(239.44, 351.922, 246.934, 352.19, 249.173, 352.233)
    ..cubicTo(249.173, 352.233, 252.27, 363.508, 252.27, 363.508)
    ..cubicTo(252.313, 363.662, 252.455, 363.766, 252.613, 363.766)
    ..cubicTo(252.641, 363.766, 252.673, 363.762, 252.705, 363.755)
    ..cubicTo(252.891, 363.701, 253.005, 363.508, 252.952, 363.319)
    ..cubicTo(252.952, 363.319, 249.884, 352.143, 249.884, 352.143)
    ..cubicTo(249.955, 352.079, 249.998, 351.986, 249.998, 351.886)
    ..cubicTo(249.998, 351.715, 249.88, 351.583, 249.719, 351.547)
    ..cubicTo(249.719, 351.547, 244.44, 332.313, 244.44, 332.313)
    ..cubicTo(244.44, 332.313, 265.764, 331.824, 265.764, 331.824)
    ..cubicTo(265.764, 331.824, 265.764, 349.579, 265.764, 349.579)
    ..cubicTo(265.764, 349.636, 265.774, 349.693, 265.803, 349.743)
    ..cubicTo(265.803, 349.743, 269.757, 357.319, 269.757, 357.319)
    ..cubicTo(269.818, 357.44, 269.943, 357.508, 270.068, 357.508)
    ..cubicTo(270.125, 357.508, 270.178, 357.494, 270.232, 357.469)
    ..cubicTo(270.407, 357.379, 270.471, 357.165, 270.382, 356.99)
    ..cubicTo(270.382, 356.99, 266.471, 349.493, 266.471, 349.493)
    ..cubicTo(266.471, 349.493, 266.471, 349.493, 266.471, 349.493)
    ..close();

  static final Path __path27_2_0 = Path()
    ..moveTo(42, 0)
    ..cubicTo(42, 0, 248.427, 0, 248.427, 0)
    ..cubicTo(271.623, 0, 290.427, 18.804, 290.427, 42)
    ..cubicTo(290.427, 42, 290.427, 310.662, 290.427, 310.662)
    ..cubicTo(290.427, 333.858, 271.623, 352.662, 248.427, 352.662)
    ..cubicTo(248.427, 352.662, 42, 352.662, 42, 352.662)
    ..cubicTo(18.804, 352.662, 0, 333.858, 0, 310.662)
    ..cubicTo(0, 310.662, 0, 42, 0, 42)
    ..cubicTo(0, 18.804, 18.804, 0, 42, 0)
    ..close();

  static final Path __maskPath27_0 = Path()
    ..moveTo(42, 0)
    ..cubicTo(42, 0, 248.427, 0, 248.427, 0)
    ..cubicTo(271.623, 0, 290.427, 18.804, 290.427, 42)
    ..cubicTo(290.427, 42, 290.427, 310.662, 290.427, 310.662)
    ..cubicTo(290.427, 333.858, 271.623, 352.662, 248.427, 352.662)
    ..cubicTo(248.427, 352.662, 42, 352.662, 42, 352.662)
    ..cubicTo(18.804, 352.662, 0, 333.858, 0, 310.662)
    ..cubicTo(0, 310.662, 0, 42, 0, 42)
    ..cubicTo(0, 18.804, 18.804, 0, 42, 0)
    ..close();

  static final Path __path32_0_0 = Path()
    ..moveTo(44, 10)
    ..cubicTo(44, 10, 247, 10, 247, 10)
    ..cubicTo(265.2254, 10, 280, 24.7746, 280, 43)
    ..cubicTo(280, 43, 280, 136.045, 280, 136.045)
    ..cubicTo(280, 154.2704, 265.2254, 169.045, 247, 169.045)
    ..cubicTo(247, 169.045, 44, 169.045, 44, 169.045)
    ..cubicTo(25.7746, 169.045, 11, 154.2704, 11, 136.045)
    ..cubicTo(11, 136.045, 11, 43, 11, 43)
    ..cubicTo(11, 24.7746, 25.7746, 10, 44, 10)
    ..close();

  static final Path __path32_1_0 = Path()
    ..moveTo(-7, 71)
    ..cubicTo(-7, 71, 36.2287, 114.648, 36.2287, 114.648)
    ..cubicTo(36.2287, 114.648, 69.2685, 151.489, 71.8405, 155.86)
    ..cubicTo(71.8405, 155.86, 100.033, 186.457, 100.033, 186.457)
    ..cubicTo(100.033, 186.457, 110.42, 202.068, 110.42, 202.068)
    ..cubicTo(116.058, 211.934, 123.428, 217.554, 124.763, 230.167)
    ..cubicTo(124.763, 230.167, 126, 345, 126, 345);

  static final Path __path32_1_1 = Path()
    ..moveTo(-7, 102)
    ..cubicTo(-7, 102, 18.3568, 139.49, 18.3568, 139.49)
    ..cubicTo(24.7207, 144.614, 44.503, 168.233, 50.9162, 179.48)
    ..cubicTo(50.9162, 179.48, 52.3961, 180.73, 52.3961, 180.73)
    ..cubicTo(55.0108, 184.041, 58.612, 190.102, 60.7826, 195.101)
    ..cubicTo(60.7826, 195.101, 69.8105, 221.407, 69.8105, 221.407)
    ..cubicTo(69.8105, 221.407, 77.0623, 246.963, 77.0623, 246.963)
    ..cubicTo(77.0623, 246.963, 89.8887, 281.954, 89.8887, 281.954)
    ..cubicTo(89.8887, 281.954, 93.342, 288.202, 93.342, 288.202)
    ..cubicTo(93.342, 288.202, 97.2886, 295.075, 97.2886, 295.075)
    ..cubicTo(109.819, 304.823, 122.596, 309.634, 125.013, 329.317)
    ..cubicTo(125.013, 329.317, 126, 345, 126, 345);

  static final Path __path32_1_2 = Path()
    ..moveTo(87.0135, 238.975)
    ..cubicTo(88.0006, 239.596, 103.003, 228.482, 117.611, 217.865)
    ..cubicTo(117.611, 217.865, 144.261, 199.424, 144.261, 199.424)
    ..cubicTo(144.261, 199.424, 157.586, 192.408, 157.586, 192.408)
    ..cubicTo(157.586, 192.408, 181.768, 179.99, 181.768, 179.99)
    ..cubicTo(181.768, 179.99, 202.496, 169.435, 202.496, 169.435)
    ..cubicTo(202.496, 169.435, 212.218, 164.53, 212.218, 164.53)
    ..cubicTo(212.218, 164.53, 214.34, 162.606, 214.34, 162.606)
    ..cubicTo(214.34, 162.606, 221.99, 151.119, 221.99, 151.119)
    ..cubicTo(221.99, 151.119, 223.717, 149.567, 223.717, 149.567)
    ..cubicTo(223.717, 149.567, 225, 148.946, 225, 148.946);

  static final Path __path32_1_3 = Path()
    ..moveTo(50, 179.37)
    ..cubicTo(50, 179.37, 67.7665, 152.485, 67.7665, 152.485);

  static final Path __path32_1_4 = Path()
    ..moveTo(172, 254)
    ..cubicTo(172, 254, 197, 300.779, 197, 300.779)
    ..cubicTo(197, 300.779, 209.2, 329.532, 209.2, 329.532)
    ..cubicTo(209.2, 329.532, 213, 345, 213, 345);

  static final Path __path32_1_5 = Path()
    ..moveTo(119.644, 271.938)
    ..cubicTo(119.644, 271.938, 128.797, 292.563, 128.797, 292.563)
    ..cubicTo(131.339, 300.062, 137.441, 307.562, 141, 316.312)
    ..cubicTo(143.339, 321.875, 146.441, 337, 147, 345)
    ..cubicTo(147, 345, 171, 345, 171, 345)
    ..cubicTo(171, 345, 149.644, 300.687, 149.644, 300.687)
    ..cubicTo(149.644, 300.687, 136.932, 265.688, 136.932, 265.688)
    ..cubicTo(136.932, 265.688, 117, 217, 117, 217);

  static final Path __path32_1_6 = Path()
    ..moveTo(-1.3201, 289.946)
    ..cubicTo(-1.3201, 289.946, 18.3409, 312.827, 18.3409, 312.827)
    ..cubicTo(23.8023, 321.147, 36.9096, 329.468, 44.5556, 339.175)
    ..cubicTo(49.58, 345.346, 56.2429, 362.125, 57.4444, 371)
    ..cubicTo(57.4444, 371, 109, 371, 109, 371)
    ..cubicTo(109, 371, 63.1243, 321.841, 63.1243, 321.841)
    ..cubicTo(63.1243, 321.841, 35.8173, 283.013, 35.8173, 283.013)
    ..cubicTo(35.8173, 283.013, -7, 229, -7, 229);

  static final Path __path32_1_7 = Path()
    ..moveTo(-3.5, 296)
    ..cubicTo(-3.5, 296, 180.601, 250.951, 180.601, 250.951)
    ..cubicTo(180.601, 250.951, 198.727, 245.307, 198.727, 245.307)
    ..cubicTo(198.727, 245.307, 216.854, 239.036, 216.854, 239.036)
    ..cubicTo(223.712, 237.155, 234, 233.393, 234, 217.089)
    ..cubicTo(234, 217.089, 232.677, 205.175, 232.677, 205.175)
    ..cubicTo(232.677, 205.175, 227.631, 187.617, 227.631, 187.617)
    ..cubicTo(227.631, 187.617, 226.162, 178.838, 226.162, 178.838)
    ..cubicTo(226.162, 178.838, 225.329, 167.488, 225.329, 167.488)
    ..cubicTo(225.329, 167.488, 225.182, 154.383, 225.182, 154.383)
    ..cubicTo(225.182, 146.858, 223.712, 142.469, 220.43, 135.508)
    ..cubicTo(220.43, 135.508, 211.465, 110.488, 211.465, 110.488)
    ..cubicTo(211.465, 110.488, 209.505, 81.0165, 209.505, 81.0165)
    ..cubicTo(209.505, 81.0165, 207.545, 76, 207.545, 76);

  static final Path __path32_1_8 = Path()
    ..moveTo(171.902, 252.533)
    ..cubicTo(171.902, 252.533, 195.152, 294.393, 195.152, 294.393)
    ..cubicTo(195.152, 294.393, 203.562, 314.386, 203.562, 314.386)
    ..cubicTo(207.866, 325.694, 211.18, 335.128, 214, 345)
    ..cubicTo(214, 345, 214, 344.938, 214, 344.938)
    ..cubicTo(214, 344.938, 193.173, 294.393, 193.173, 294.393)
    ..cubicTo(193.173, 294.393, 173.88, 251.908, 173.88, 251.908)
    ..cubicTo(167.449, 234.414, 161.018, 225.667, 160.029, 198.802)
    ..cubicTo(159.534, 173.811, 165.471, 144.446, 169.428, 122.579)
    ..cubicTo(169.428, 122.579, 171.902, 105.71, 171.902, 105.71)
    ..cubicTo(171.902, 105.71, 180.311, 67.5982, 180.311, 67.5982)
    ..cubicTo(180.311, 67.5982, 184.764, 50.1044, 184.764, 50.1044)
    ..cubicTo(184.764, 50.1044, 187.732, 31.9858, 187.732, 31.9858)
    ..cubicTo(190.205, 21.3646, 192.679, 12.6177, 196.636, 6.3699)
    ..cubicTo(196.636, 6.3699, 209.498, -8, 209.498, -8);

  static final Path __path32_1_9 = Path()
    ..moveTo(193, 292)
    ..cubicTo(198.927, 290.125, 211.276, 287, 222.143, 283.25)
    ..cubicTo(222.143, 283.25, 239.926, 277, 239.926, 277)
    ..cubicTo(249.311, 275.125, 252.917, 269.75, 254.745, 262.625)
    ..cubicTo(255.733, 258.875, 253.806, 245.688, 249.805, 235.125)
    ..cubicTo(247.829, 229.5, 246.347, 224.5, 246.347, 205.75)
    ..cubicTo(246.594, 201.562, 246.891, 189.5, 244.371, 184.5)
    ..cubicTo(237.95, 183.25, 234.986, 182.625, 231.529, 180.125)
    ..cubicTo(220.662, 171.375, 205.349, 160.125, 203.867, 157)
    ..cubicTo(200.409, 152, 199.915, 141.375, 200.903, 133.25)
    ..cubicTo(200.903, 133.25, 205.892, 103.875, 205.892, 103.875)
    ..cubicTo(205.892, 103.875, 206.831, 87, 206.831, 87);

  static final Path __path32_1_10 = Path()
    ..moveTo(167, 233)
    ..cubicTo(172.927, 231.125, 185.276, 228, 196.143, 224.25)
    ..cubicTo(196.143, 224.25, 213.926, 218, 213.926, 218)
    ..cubicTo(223.311, 216.125, 226.917, 210.75, 228.745, 203.625)
    ..cubicTo(229.733, 199.875, 227.806, 186.688, 223.805, 176.125)
    ..cubicTo(221.829, 170.5, 220.347, 165.5, 220.347, 146.75)
    ..cubicTo(220.594, 142.562, 220.891, 130.5, 218.371, 125.5)
    ..cubicTo(211.95, 124.25, 208.986, 123.625, 205.529, 121.125)
    ..cubicTo(194.662, 112.375, 179.349, 101.125, 177.867, 98)
    ..cubicTo(174.409, 93, 173.915, 82.375, 174.903, 74.25)
    ..cubicTo(174.903, 74.25, 179.892, 44.875, 179.892, 44.875)
    ..cubicTo(179.892, 44.875, 180.831, 28, 180.831, 28);

  static final Path __path32_1_11 = Path()
    ..moveTo(173.297, 251)
    ..cubicTo(165.914, 232.894, 158.531, 220.407, 159.023, 180.448)
    ..cubicTo(159.023, 180.448, 161.484, 155.474, 161.484, 155.474)
    ..cubicTo(163.453, 145.484, 165.914, 132.373, 166.898, 124.256)
    ..cubicTo(166.898, 124.256, 171.82, 94.9119, 171.82, 94.9119)
    ..cubicTo(171.82, 94.9119, 177.727, 65.5674, 177.727, 65.5674)
    ..cubicTo(177.727, 65.5674, 182.648, 46.2124, 182.648, 46.2124)
    ..cubicTo(182.648, 46.2124, 186.34, 27.1697, 186.34, 27.1697)
    ..cubicTo(186.34, 27.1697, 187.078, 24.3601, 187.078, 24.3601)
    ..cubicTo(188.062, 18.1166, 191.016, 11.8731, 192, 10);

  static final Path __path32_2_0 = Path()
    ..moveTo(100.167, 244)
    ..cubicTo(100.167, 244, 91, 250.722, 91, 250.722)
    ..cubicTo(91, 250.722, 93.75, 255, 93.75, 255)
    ..cubicTo(93.75, 255, 102, 248.889, 102, 248.889)
    ..cubicTo(102, 248.889, 100.167, 244, 100.167, 244)
    ..close();

  static final Path __path32_2_1 = Path()
    ..moveTo(147.5, 156)
    ..cubicTo(147.5, 156, 157, 167.779, 157, 167.779)
    ..cubicTo(157, 167.779, 156.5, 177.698, 156.5, 177.698)
    ..cubicTo(156.5, 177.698, 148.55, 179, 148.55, 179)
    ..cubicTo(148.55, 179, 140, 166.539, 140, 166.539)
    ..cubicTo(140, 166.539, 147.5, 156, 147.5, 156)
    ..close();

  static final Path __path32_2_2 = Path()
    ..moveTo(255.821, 160.862)
    ..cubicTo(255.821, 160.862, 259.243, 163.966, 259.243, 163.966)
    ..cubicTo(263.642, 163.966, 267.064, 166.448, 269.02, 169.552)
    ..cubicTo(269.02, 169.552, 271.464, 173.897, 271.464, 173.897)
    ..cubicTo(271.464, 173.897, 274.397, 177, 274.397, 177)
    ..cubicTo(274.397, 177, 277.33, 178.862, 277.33, 178.862)
    ..cubicTo(277.33, 178.862, 283, 186.31, 283, 186.31)
    ..cubicTo(283, 186.31, 283, 213, 283, 213)
    ..cubicTo(283, 213, 279.285, 208.655, 279.285, 208.655)
    ..cubicTo(276.841, 205.552, 275.863, 203.069, 270.975, 201.828)
    ..cubicTo(270.975, 201.828, 270.486, 199.966, 270.486, 199.966)
    ..cubicTo(270.486, 199.966, 266.087, 199.345, 266.087, 199.345)
    ..cubicTo(266.087, 199.345, 266.575, 195.621, 266.575, 195.621)
    ..cubicTo(266.575, 195.621, 266.087, 193.759, 266.087, 193.759)
    ..cubicTo(266.087, 193.759, 261.687, 191.276, 261.687, 191.276)
    ..cubicTo(261.687, 191.276, 260.221, 186.31, 260.221, 186.31)
    ..cubicTo(260.221, 186.31, 258.754, 183.828, 258.754, 183.828)
    ..cubicTo(258.754, 183.828, 256.31, 181.966, 256.31, 181.966)
    ..cubicTo(256.31, 181.966, 256.31, 180.103, 256.31, 180.103)
    ..cubicTo(256.31, 180.103, 254.844, 180.103, 254.844, 180.103)
    ..cubicTo(254.844, 180.103, 251.911, 182.586, 251.911, 182.586)
    ..cubicTo(251.911, 182.586, 251.911, 175.138, 251.911, 175.138)
    ..cubicTo(251.911, 175.138, 252.399, 175.138, 252.399, 175.138)
    ..cubicTo(252.399, 175.138, 253.377, 172.034, 253.377, 172.034)
    ..cubicTo(253.377, 172.034, 252.888, 170.793, 252.888, 170.793)
    ..cubicTo(252.888, 170.793, 252.888, 169.552, 252.888, 169.552)
    ..cubicTo(252.888, 169.552, 252.351, 167.938, 252.351, 167.938)
    ..cubicTo(252.351, 167.938, 252.888, 168.931, 252.888, 168.931)
    ..cubicTo(252.888, 168.931, 252.888, 168.31, 252.888, 168.31)
    ..cubicTo(252.888, 168.31, 251.911, 167.069, 251.911, 167.069)
    ..cubicTo(251.911, 167.069, 252.839, 165.641, 252.839, 165.641)
    ..cubicTo(252.839, 165.641, 251.911, 165.828, 251.911, 165.828)
    ..cubicTo(251.911, 165.828, 250.444, 164.586, 250.444, 164.586)
    ..cubicTo(250.444, 164.586, 248.978, 164.586, 248.978, 164.586)
    ..cubicTo(248.978, 164.586, 248, 164.586, 248, 164.586)
    ..cubicTo(248, 164.586, 249.466, 159.621, 249.466, 159.621)
    ..cubicTo(249.466, 159.621, 251.422, 159, 251.422, 159)
    ..cubicTo(251.422, 159, 255.821, 160.862, 255.821, 160.862)
    ..cubicTo(255.821, 160.862, 255.821, 160.862, 255.821, 160.862)
    ..close();

  static final Path __path32_3_0 = Path()
    ..moveTo(42, 0)
    ..cubicTo(42, 0, 248.427, 0, 248.427, 0)
    ..cubicTo(271.623, 0, 290.427, 18.804, 290.427, 42)
    ..cubicTo(290.427, 42, 290.427, 310.662, 290.427, 310.662)
    ..cubicTo(290.427, 333.858, 271.623, 352.662, 248.427, 352.662)
    ..cubicTo(248.427, 352.662, 42, 352.662, 42, 352.662)
    ..cubicTo(18.804, 352.662, 0, 333.858, 0, 310.662)
    ..cubicTo(0, 310.662, 0, 42, 0, 42)
    ..cubicTo(0, 18.804, 18.804, 0, 42, 0)
    ..close();

  static final Path __maskPath32_0 = Path()
    ..moveTo(42, 0)
    ..cubicTo(42, 0, 248.427, 0, 248.427, 0)
    ..cubicTo(271.623, 0, 290.427, 18.804, 290.427, 42)
    ..cubicTo(290.427, 42, 290.427, 310.662, 290.427, 310.662)
    ..cubicTo(290.427, 333.858, 271.623, 352.662, 248.427, 352.662)
    ..cubicTo(248.427, 352.662, 42, 352.662, 42, 352.662)
    ..cubicTo(18.804, 352.662, 0, 333.858, 0, 310.662)
    ..cubicTo(0, 310.662, 0, 42, 0, 42)
    ..cubicTo(0, 18.804, 18.804, 0, 42, 0)
    ..close();

  static final Path __path37_0_0 = Path()
    ..moveTo(44, 10)
    ..cubicTo(44, 10, 247, 10, 247, 10)
    ..cubicTo(265.2254, 10, 280, 24.7746, 280, 43)
    ..cubicTo(280, 43, 280, 136.045, 280, 136.045)
    ..cubicTo(280, 154.2704, 265.2254, 169.045, 247, 169.045)
    ..cubicTo(247, 169.045, 44, 169.045, 44, 169.045)
    ..cubicTo(25.7746, 169.045, 11, 154.2704, 11, 136.045)
    ..cubicTo(11, 136.045, 11, 43, 11, 43)
    ..cubicTo(11, 24.7746, 25.7746, 10, 44, 10)
    ..close();

  static final Path __path37_1_0 = Path()
    ..moveTo(109.736, 560.636)
    ..cubicTo(85.3737, 523.576, 60.2345, 485.33, 43.5746, 456.049)
    ..cubicTo(96.5596, 422.343, 152.568, 385.522, 204.953, 350.948)
    ..cubicTo(205.916, 352.394, 206.882, 353.844, 207.856, 355.309)
    ..cubicTo(231.166, 390.333, 255.218, 426.475, 282.691, 455.66)
    ..cubicTo(282.631, 455.72, 282.567, 455.785, 282.509, 455.845)
    ..cubicTo(282.48, 455.874, 282.454, 455.906, 282.428, 455.938)
    ..cubicTo(281.031, 457.735, 278.483, 461.131, 275.258, 465.432)
    ..cubicTo(264.675, 479.54, 245.023, 505.739, 239.523, 510.382)
    ..cubicTo(209.124, 526.312, 158.984, 549.324, 115.215, 568.972)
    ..cubicTo(113.399, 566.208, 111.574, 563.433, 109.736, 560.636)
    ..cubicTo(109.736, 560.636, 109.736, 560.636, 109.736, 560.636)
    ..close();

  static final Path __path37_1_1 = Path()
    ..moveTo(40.5762, 450.713)
    ..cubicTo(40.5762, 450.713, 40.2472, 268.33, 40.2472, 268.33)
    ..cubicTo(40.2472, 268.33, 41.1905, 265.187, 41.1905, 265.187)
    ..cubicTo(41.6487, 263.658, 41.9277, 262.73, 42.0702, 262.137)
    ..cubicTo(48.7529, 251.9, 58.8726, 241.457, 68.6599, 231.359)
    ..cubicTo(75.0472, 224.77, 81.5688, 218.033, 87.2271, 211.272)
    ..cubicTo(89.1554, 211.586, 91.0902, 211.897, 93.029, 212.197)
    ..cubicTo(110.891, 214.983, 127.101, 216.89, 141.545, 217.908)
    ..cubicTo(141.545, 217.908, 142.215, 233.306, 142.215, 233.306)
    ..cubicTo(142.219, 233.399, 142.235, 233.488, 142.262, 233.577)
    ..cubicTo(142.262, 233.577, 147.203, 249.386, 147.203, 249.386)
    ..cubicTo(147.248, 249.532, 147.323, 249.664, 147.423, 249.779)
    ..cubicTo(149.021, 251.568, 163.124, 267.494, 167.342, 275.534)
    ..cubicTo(170.917, 284.581, 178.316, 306.115, 181.459, 316.252)
    ..cubicTo(181.491, 316.355, 181.54, 316.455, 181.604, 316.548)
    ..cubicTo(188.952, 327.006, 196.219, 337.839, 203.777, 349.183)
    ..cubicTo(151.432, 383.732, 95.4702, 420.525, 42.5285, 454.202)
    ..cubicTo(41.8648, 453.027, 41.2105, 451.859, 40.5762, 450.713)
    ..cubicTo(40.5762, 450.713, 40.5762, 450.713, 40.5762, 450.713)
    ..close();

  static final Path __path37_1_2 = Path()
    ..moveTo(95.6195, 200.1)
    ..cubicTo(98.953, 197.967, 108.207, 193.178, 112.093, 191.403)
    ..cubicTo(112.267, 191.324, 112.416, 191.199, 112.524, 191.042)
    ..cubicTo(112.524, 191.042, 113.872, 189.095, 113.872, 189.095)
    ..cubicTo(113.872, 189.095, 141.508, 202.607, 141.508, 202.607)
    ..cubicTo(141.508, 202.607, 141.226, 210.493, 141.226, 210.493)
    ..cubicTo(141.226, 210.522, 141.226, 210.55, 141.227, 210.579)
    ..cubicTo(141.227, 210.579, 141.456, 215.847, 141.456, 215.847)
    ..cubicTo(128.371, 214.883, 111.21, 212.961, 88.8276, 209.329)
    ..cubicTo(91.321, 206.254, 93.6204, 203.171, 95.6195, 200.1)
    ..cubicTo(95.6195, 200.1, 95.6195, 200.1, 95.6195, 200.1)
    ..close();

  static final Path __path37_1_3 = Path()
    ..moveTo(90.6445, 114.007)
    ..cubicTo(90.6445, 114.007, 91.2999, 91.398, 91.2999, 91.398)
    ..cubicTo(91.2999, 91.398, 94.8784, 70.5785, 94.8784, 70.5785)
    ..cubicTo(95.5717, 69.3855, 99.8163, 62.0742, 100.589, 60.7455)
    ..cubicTo(106.808, 56.5809, 114.312, 52.477, 122.396, 48.6945)
    ..cubicTo(128.72, 62.4099, 135.117, 76.454, 141.264, 90.0051)
    ..cubicTo(141.264, 90.0051, 130.57, 104.16, 130.57, 104.16)
    ..cubicTo(130.461, 104.303, 130.391, 104.474, 130.366, 104.653)
    ..cubicTo(128.494, 118.061, 127.221, 143.824, 128.385, 156.935)
    ..cubicTo(128.385, 156.935, 128.406, 156.932, 128.406, 156.932)
    ..cubicTo(128.516, 157.36, 128.996, 158.2, 130.373, 160.611)
    ..cubicTo(130.373, 160.611, 140.269, 177.93, 140.269, 177.93)
    ..cubicTo(140.269, 177.93, 141.883, 192.128, 141.883, 192.128)
    ..cubicTo(141.883, 192.128, 141.591, 200.289, 141.591, 200.289)
    ..cubicTo(141.591, 200.289, 115.093, 187.334, 115.093, 187.334)
    ..cubicTo(115.093, 187.334, 115.489, 186.763, 115.489, 186.763)
    ..cubicTo(115.588, 186.616, 115.651, 186.452, 115.67, 186.281)
    ..cubicTo(115.67, 186.281, 116.659, 177.716, 116.659, 177.716)
    ..cubicTo(116.691, 177.434, 116.609, 177.148, 116.431, 176.926)
    ..cubicTo(108.985, 167.69, 91.3103, 126.054, 90.6445, 114.007)
    ..cubicTo(90.6445, 114.007, 90.6445, 114.007, 90.6445, 114.007)
    ..close();

  static final Path __path37_1_4 = Path()
    ..moveTo(303.472, 152.153)
    ..cubicTo(303.472, 152.153, 304.912, 153.01, 304.912, 153.01)
    ..cubicTo(309.858, 155.96, 310.496, 156.339, 314.354, 161.618)
    ..cubicTo(314.354, 161.618, 309.282, 175.248, 309.282, 175.248)
    ..cubicTo(309.249, 175.333, 309.229, 175.426, 309.22, 175.519)
    ..cubicTo(309.22, 175.519, 307.902, 189.684, 307.902, 189.684)
    ..cubicTo(307.886, 189.863, 307.915, 190.042, 307.987, 190.206)
    ..cubicTo(307.987, 190.206, 317.21, 211.286, 317.21, 211.286)
    ..cubicTo(317.29, 211.468, 317.419, 211.626, 317.584, 211.74)
    ..cubicTo(317.584, 211.74, 332.076, 221.619, 332.076, 221.619)
    ..cubicTo(332.133, 221.659, 332.194, 221.691, 332.254, 221.716)
    ..cubicTo(332.254, 221.716, 353.667, 230.941, 353.667, 230.941)
    ..cubicTo(353.774, 230.988, 353.892, 231.016, 354.013, 231.024)
    ..cubicTo(354.013, 231.024, 373.447, 232.342, 373.447, 232.342)
    ..cubicTo(373.518, 232.349, 373.59, 232.345, 373.665, 232.334)
    ..cubicTo(373.665, 232.334, 394.792, 229.409, 394.792, 229.409)
    ..cubicTo(394.792, 229.409, 401.489, 232.149, 401.489, 232.149)
    ..cubicTo(402.831, 234.038, 411.304, 245.975, 412.114, 247.125)
    ..cubicTo(412.643, 248.382, 413.097, 251.111, 413.489, 254.679)
    ..cubicTo(410.107, 254.861, 407.085, 255.033, 404.685, 255.172)
    ..cubicTo(404.685, 255.172, 403.103, 255.261, 403.103, 255.261)
    ..cubicTo(402.521, 255.293, 402.074, 255.793, 402.106, 256.379)
    ..cubicTo(402.139, 256.961, 402.646, 257.408, 403.224, 257.376)
    ..cubicTo(403.224, 257.376, 404.807, 257.286, 404.807, 257.286)
    ..cubicTo(407.228, 257.151, 410.282, 256.976, 413.704, 256.79)
    ..cubicTo(414.622, 266.344, 415.168, 280.306, 415.518, 289.153)
    ..cubicTo(415.675, 293.186, 415.804, 296.422, 415.918, 298.208)
    ..cubicTo(414.29, 300.804, 412.986, 302.969, 411.932, 304.715)
    ..cubicTo(410.936, 306.373, 410.114, 307.733, 409.357, 308.908)
    ..cubicTo(409.3, 308.962, 409.246, 309.019, 409.2, 309.087)
    ..cubicTo(409.15, 309.162, 409.118, 309.241, 409.086, 309.319)
    ..cubicTo(405.907, 314.159, 403.624, 315.827, 393.334, 322.699)
    ..cubicTo(393.334, 322.699, 378.808, 326.571, 378.808, 326.571)
    ..cubicTo(378.808, 326.571, 331.661, 327.063, 331.661, 327.063)
    ..cubicTo(331.661, 327.063, 316.179, 322.71, 316.179, 322.71)
    ..cubicTo(316.179, 322.71, 302.124, 312.53, 302.124, 312.53)
    ..cubicTo(301.232, 311.394, 294.032, 302.211, 288.598, 295.286)
    ..cubicTo(288.62, 295.054, 288.571, 294.814, 288.433, 294.604)
    ..cubicTo(288.26, 294.339, 287.99, 294.182, 287.701, 294.139)
    ..cubicTo(285.109, 290.836, 283.065, 288.228, 282.57, 287.6)
    ..cubicTo(275.949, 267.126, 272.497, 253.854, 272.305, 248.143)
    ..cubicTo(272.305, 248.143, 274.762, 231.438, 274.762, 231.438)
    ..cubicTo(274.803, 231.159, 274.731, 230.874, 274.562, 230.649)
    ..cubicTo(274.393, 230.424, 274.141, 230.274, 273.861, 230.234)
    ..cubicTo(272.937, 230.102, 185.979, 217.805, 176.824, 216.512)
    ..cubicTo(173.662, 196.356, 164.195, 144.634, 161.113, 128.805)
    ..cubicTo(161.097, 128.722, 161.072, 128.644, 161.038, 128.569)
    ..cubicTo(161.038, 128.569, 155.413, 116.129, 155.413, 116.129)
    ..cubicTo(151.739, 107.999, 147.862, 99.4236, 143.873, 90.6265)
    ..cubicTo(143.873, 90.6265, 165.921, 82.1222, 165.921, 82.1222)
    ..cubicTo(165.921, 82.1222, 192.041, 79.5113, 192.041, 79.5113)
    ..cubicTo(192.041, 79.5113, 235.288, 82.458, 235.288, 82.458)
    ..cubicTo(235.288, 82.458, 246.196, 86.3083, 246.196, 86.3083)
    ..cubicTo(246.196, 86.3083, 278.176, 110.457, 278.176, 110.457)
    ..cubicTo(284.124, 120.6, 296.504, 141.188, 303.117, 151.803)
    ..cubicTo(303.206, 151.946, 303.327, 152.064, 303.472, 152.153)
    ..cubicTo(303.472, 152.153, 303.472, 152.153, 303.472, 152.153)
    ..close();

  static final Path __path37_1_5 = Path()
    ..moveTo(228.669, 335.286)
    ..cubicTo(233.685, 331.975, 238.632, 328.706, 243.524, 325.478)
    ..cubicTo(247.168, 331.267, 250.772, 336.711, 254.367, 341.647)
    ..cubicTo(257.228, 345.115, 267.085, 352.276, 272.974, 356.559)
    ..cubicTo(274.043, 357.334, 274.967, 358.005, 275.673, 358.53)
    ..cubicTo(281.73, 366.674, 302.487, 395.973, 309.408, 405.813)
    ..cubicTo(309.471, 405.902, 309.547, 405.981, 309.634, 406.048)
    ..cubicTo(309.634, 406.048, 311.47, 407.438, 311.47, 407.438)
    ..cubicTo(311.47, 407.438, 314.923, 422.728, 314.923, 422.728)
    ..cubicTo(314.945, 422.825, 314.988, 422.91, 315.033, 422.993)
    ..cubicTo(305.382, 432.676, 292.014, 446.177, 284.178, 454.145)
    ..cubicTo(256.85, 425.096, 232.865, 389.061, 209.621, 354.134)
    ..cubicTo(208.649, 352.673, 207.684, 351.223, 206.722, 349.78)
    ..cubicTo(214.118, 344.897, 221.441, 340.061, 228.669, 335.286)
    ..cubicTo(228.669, 335.286, 228.669, 335.286, 228.669, 335.286)
    ..close();

  static final Path __path37_1_6 = Path()
    ..moveTo(174.993, 218.548)
    ..cubicTo(175.119, 219.373, 175.232, 220.133, 175.328, 220.812)
    ..cubicTo(175.347, 220.944, 175.391, 221.073, 175.457, 221.187)
    ..cubicTo(175.457, 221.187, 181.133, 231.116, 181.133, 231.116)
    ..cubicTo(181.261, 231.341, 181.398, 231.581, 181.567, 231.766)
    ..cubicTo(181.567, 231.766, 181.553, 231.781, 181.553, 231.781)
    ..cubicTo(197.81, 248.264, 212.913, 273.97, 227.519, 298.829)
    ..cubicTo(232.607, 307.487, 237.541, 315.884, 242.398, 323.677)
    ..cubicTo(237.492, 326.917, 232.531, 330.196, 227.5, 333.518)
    ..cubicTo(220.27, 338.293, 212.944, 343.133, 205.547, 348.015)
    ..cubicTo(198.012, 336.707, 190.766, 325.903, 183.434, 315.466)
    ..cubicTo(180.248, 305.208, 172.858, 283.714, 169.293, 274.702)
    ..cubicTo(169.279, 274.67, 169.264, 274.638, 169.247, 274.602)
    ..cubicTo(165.054, 266.566, 151.366, 251.022, 149.159, 248.536)
    ..cubicTo(149.159, 248.536, 144.327, 233.077, 144.327, 233.077)
    ..cubicTo(144.327, 233.077, 143.674, 218.055, 143.674, 218.055)
    ..cubicTo(155.317, 218.812, 165.772, 218.976, 174.993, 218.548)
    ..cubicTo(174.993, 218.548, 174.993, 218.548, 174.993, 218.548)
    ..close();

  static final Path __path37_1_7 = Path()
    ..moveTo(300.548, 313.955)
    ..cubicTo(300.609, 314.034, 300.68, 314.102, 300.76, 314.162)
    ..cubicTo(300.76, 314.162, 315.089, 324.538, 315.089, 324.538)
    ..cubicTo(315.19, 324.61, 315.303, 324.663, 315.423, 324.699)
    ..cubicTo(315.423, 324.699, 331.233, 329.146, 331.233, 329.146)
    ..cubicTo(331.333, 329.174, 331.433, 329.192, 331.533, 329.185)
    ..cubicTo(331.533, 329.185, 378.965, 328.692, 378.965, 328.692)
    ..cubicTo(379.051, 328.689, 379.14, 328.678, 379.226, 328.656)
    ..cubicTo(379.226, 328.656, 394.049, 324.703, 394.049, 324.703)
    ..cubicTo(394.163, 324.674, 394.27, 324.624, 394.367, 324.56)
    ..cubicTo(404.625, 317.713, 407.293, 315.738, 410.396, 311.184)
    ..cubicTo(444.131, 334.56, 467.969, 388.358, 488.985, 436.29)
    ..cubicTo(461.261, 442.487, 428.141, 452.077, 396.07, 461.367)
    ..cubicTo(387.834, 463.753, 379.808, 466.075, 372.072, 468.286)
    ..cubicTo(372.04, 468.268, 372.015, 468.239, 371.983, 468.221)
    ..cubicTo(371.983, 468.221, 361.607, 463.507, 361.607, 463.507)
    ..cubicTo(361.607, 463.507, 358.749, 448.97, 358.749, 448.97)
    ..cubicTo(358.732, 448.895, 358.71, 448.82, 358.678, 448.745)
    ..cubicTo(355.663, 441.948, 347.959, 433.079, 342.155, 427.425)
    ..cubicTo(342.155, 427.425, 341.219, 420.621, 341.219, 420.621)
    ..cubicTo(341.166, 420.25, 340.927, 419.953, 340.605, 419.807)
    ..cubicTo(340.605, 419.807, 340.712, 418.974, 340.712, 418.974)
    ..cubicTo(340.712, 418.974, 333.151, 418.028, 333.151, 418.028)
    ..cubicTo(333.151, 418.028, 326.814, 411.992, 326.814, 411.992)
    ..cubicTo(326.814, 411.992, 329.714, 404.259, 329.714, 404.259)
    ..cubicTo(329.714, 404.259, 329.371, 404.127, 329.371, 404.127)
    ..cubicTo(329.371, 404.127, 329.706, 403.291, 329.706, 403.291)
    ..cubicTo(329.923, 402.748, 329.659, 402.13, 329.115, 401.912)
    ..cubicTo(328.572, 401.694, 327.955, 401.959, 327.737, 402.502)
    ..cubicTo(327.737, 402.502, 324.823, 409.788, 324.823, 409.788)
    ..cubicTo(324.823, 409.788, 319.116, 410.074, 319.116, 410.074)
    ..cubicTo(319.116, 410.074, 319.142, 410.599, 319.142, 410.599)
    ..cubicTo(317.191, 409.106, 315.29, 407.666, 313.479, 406.298)
    ..cubicTo(313.479, 406.298, 311.047, 404.455, 311.047, 404.455)
    ..cubicTo(303.991, 394.43, 283.198, 365.081, 277.28, 357.137)
    ..cubicTo(277.218, 357.055, 277.145, 356.98, 277.062, 356.919)
    ..cubicTo(276.336, 356.38, 275.36, 355.669, 274.221, 354.844)
    ..cubicTo(268.794, 350.898, 258.692, 343.558, 256.042, 340.347)
    ..cubicTo(252.489, 335.468, 248.914, 330.067, 245.293, 324.31)
    ..cubicTo(259.607, 314.859, 273.446, 305.73, 287.069, 296.772)
    ..cubicTo(287.069, 296.772, 300.548, 313.955, 300.548, 313.955)
    ..cubicTo(300.548, 313.955, 300.548, 313.955, 300.548, 313.955)
    ..close();

  static final Path __path37_1_8 = Path()
    ..moveTo(280.52, 288.15)
    ..cubicTo(280.548, 288.457, 280.843, 288.832, 281.634, 289.843)
    ..cubicTo(281.634, 289.843, 285.755, 295.097, 285.755, 295.097)
    ..cubicTo(272.193, 304.015, 258.416, 313.105, 244.167, 322.51)
    ..cubicTo(239.338, 314.755, 234.419, 306.387, 229.347, 297.754)
    ..cubicTo(214.705, 272.834, 199.565, 247.064, 183.159, 230.391)
    ..cubicTo(182.563, 229.348, 178.125, 221.58, 177.399, 220.312)
    ..cubicTo(177.327, 219.812, 177.248, 219.273, 177.161, 218.701)
    ..cubicTo(177.161, 218.701, 272.509, 232.184, 272.509, 232.184)
    ..cubicTo(272.509, 232.184, 270.194, 247.928, 270.194, 247.928)
    ..cubicTo(270.185, 247.989, 270.181, 248.05, 270.183, 248.114)
    ..cubicTo(270.346, 253.965, 273.823, 267.434, 280.52, 288.15)
    ..cubicTo(280.52, 288.15, 280.52, 288.15, 280.52, 288.15)
    ..close();

  static final Path __path37_1_9 = Path()
    ..moveTo(143.644, 202.228)
    ..cubicTo(143.68, 202.082, 143.683, 201.935, 143.659, 201.793)
    ..cubicTo(143.659, 201.793, 144.005, 192.124, 144.005, 192.124)
    ..cubicTo(144.006, 192.07, 144.005, 192.02, 143.998, 191.967)
    ..cubicTo(143.998, 191.967, 142.351, 177.473, 142.351, 177.473)
    ..cubicTo(142.335, 177.33, 142.29, 177.191, 142.218, 177.066)
    ..cubicTo(142.108, 176.873, 131.681, 158.628, 130.477, 156.518)
    ..cubicTo(129.368, 143.559, 130.603, 118.511, 132.429, 105.217)
    ..cubicTo(132.429, 105.217, 142.26, 92.2052, 142.26, 92.2052)
    ..cubicTo(146.137, 100.756, 149.905, 109.092, 153.48, 117)
    ..cubicTo(153.48, 117, 159.055, 129.33, 159.055, 129.33)
    ..cubicTo(162.141, 145.192, 171.462, 196.121, 174.668, 216.447)
    ..cubicTo(169.108, 216.726, 159.533, 217.087, 143.585, 215.997)
    ..cubicTo(143.585, 215.997, 143.347, 210.529, 143.347, 210.529)
    ..cubicTo(143.347, 210.529, 143.644, 202.228, 143.644, 202.228)
    ..cubicTo(143.644, 202.228, 143.644, 202.228, 143.644, 202.228)
    ..close();

  static final Path __path37_1_10 = Path()
    ..moveTo(621.61, 367.488)
    ..cubicTo(621.61, 367.488, 619.003, 350.869, 619.003, 350.869)
    ..cubicTo(619.003, 350.869, 620.946, 340.507, 620.946, 340.507)
    ..cubicTo(620.992, 340.265, 620.949, 340.015, 620.831, 339.797)
    ..cubicTo(620.831, 339.797, 619.181, 336.832, 619.181, 336.832)
    ..cubicTo(618.995, 336.496, 618.642, 336.289, 618.256, 336.289)
    ..cubicTo(618.256, 336.289, 612.984, 336.289, 612.984, 336.289)
    ..cubicTo(612.838, 336.289, 612.688, 336.321, 612.552, 336.382)
    ..cubicTo(612.552, 336.382, 603.001, 340.665, 603.001, 340.665)
    ..cubicTo(602.708, 340.793, 602.494, 341.047, 602.412, 341.35)
    ..cubicTo(602.412, 341.35, 601.423, 344.976, 601.423, 344.976)
    ..cubicTo(601.33, 345.322, 601.415, 345.694, 601.658, 345.961)
    ..cubicTo(604.008, 348.583, 609.212, 353.266, 612.266, 355.273)
    ..cubicTo(612.709, 356.044, 613.727, 357.687, 616.056, 361.448)
    ..cubicTo(616.056, 361.448, 614.674, 364.213, 614.674, 364.213)
    ..cubicTo(614.413, 364.738, 614.624, 365.374, 615.149, 365.638)
    ..cubicTo(615.149, 365.638, 616.249, 366.188, 616.249, 366.188)
    ..cubicTo(616.249, 366.188, 608.52, 371.981, 608.52, 371.981)
    ..cubicTo(608.52, 371.981, 587.807, 379.75, 587.807, 379.75)
    ..cubicTo(587.807, 379.75, 580.799, 379.114, 580.799, 379.114)
    ..cubicTo(580.742, 379.107, 580.682, 379.107, 580.621, 379.111)
    ..cubicTo(580.621, 379.111, 572.385, 379.771, 572.385, 379.771)
    ..cubicTo(572.192, 379.786, 572.006, 379.857, 571.849, 379.971)
    ..cubicTo(571.849, 379.971, 546.915, 398.101, 546.915, 398.101)
    ..cubicTo(546.915, 398.101, 535.367, 394.455, 535.367, 394.455)
    ..cubicTo(530.092, 382.543, 525.499, 369.745, 520.637, 356.212)
    ..cubicTo(520.527, 355.898, 520.412, 355.584, 520.298, 355.269)
    ..cubicTo(520.405, 355.151, 520.491, 355.019, 520.537, 354.862)
    ..cubicTo(520.537, 354.862, 524.773, 340.743, 524.773, 340.743)
    ..cubicTo(524.813, 340.732, 524.852, 340.725, 524.888, 340.707)
    ..cubicTo(524.888, 340.707, 531.063, 337.989, 531.063, 337.989)
    ..cubicTo(531.599, 337.754, 531.846, 337.129, 531.61, 336.593)
    ..cubicTo(531.374, 336.057, 530.753, 335.811, 530.21, 336.05)
    ..cubicTo(530.21, 336.05, 524.209, 338.689, 524.209, 338.689)
    ..cubicTo(524.209, 338.689, 512.455, 333.893, 512.455, 333.893)
    ..cubicTo(508.172, 322.677, 503.558, 311.641, 498.196, 301.24)
    ..cubicTo(498.479, 300.758, 498.346, 300.14, 497.882, 299.826)
    ..cubicTo(497.882, 299.826, 497.232, 299.386, 497.232, 299.386)
    ..cubicTo(494.521, 294.25, 491.614, 289.278, 488.467, 284.528)
    ..cubicTo(488.467, 284.528, 488.467, 283.906, 488.467, 283.906)
    ..cubicTo(488.467, 283.317, 487.992, 282.846, 487.406, 282.846)
    ..cubicTo(487.385, 282.846, 487.363, 282.849, 487.342, 282.853)
    ..cubicTo(482.631, 275.949, 477.384, 269.53, 471.423, 263.791)
    ..cubicTo(471.423, 263.791, 471.394, 263.819, 471.394, 263.819)
    ..cubicTo(471.058, 263.512, 470.394, 263.033, 469.094, 262.098)
    ..cubicTo(469.094, 262.098, 457.147, 253.483, 457.147, 253.483)
    ..cubicTo(456.979, 253.361, 456.782, 253.293, 456.575, 253.283)
    ..cubicTo(448.792, 252.915, 429.705, 253.808, 415.611, 254.565)
    ..cubicTo(415.168, 250.55, 414.647, 247.586, 414.011, 246.168)
    ..cubicTo(414.011, 246.168, 413.972, 246.189, 413.972, 246.189)
    ..cubicTo(413.74, 245.746, 413.222, 245.018, 412.211, 243.592)
    ..cubicTo(412.211, 243.592, 403.039, 230.67, 403.039, 230.67)
    ..cubicTo(402.924, 230.506, 402.764, 230.377, 402.578, 230.302)
    ..cubicTo(402.578, 230.302, 395.331, 227.338, 395.331, 227.338)
    ..cubicTo(395.159, 227.266, 394.97, 227.245, 394.784, 227.27)
    ..cubicTo(394.784, 227.27, 373.483, 230.22, 373.483, 230.22)
    ..cubicTo(373.483, 230.22, 354.338, 228.92, 354.338, 228.92)
    ..cubicTo(354.338, 228.92, 333.187, 219.812, 333.187, 219.812)
    ..cubicTo(333.187, 219.812, 319.03, 210.158, 319.03, 210.158)
    ..cubicTo(319.03, 210.158, 310.039, 189.606, 310.039, 189.606)
    ..cubicTo(310.039, 189.606, 311.318, 175.855, 311.318, 175.855)
    ..cubicTo(311.318, 175.855, 316.54, 161.822, 316.54, 161.822)
    ..cubicTo(316.663, 161.489, 316.612, 161.118, 316.403, 160.829)
    ..cubicTo(311.988, 154.76, 311.306, 154.353, 305.997, 151.189)
    ..cubicTo(305.997, 151.189, 304.781, 150.463, 304.781, 150.463)
    ..cubicTo(301.797, 145.67, 297.681, 138.916, 293.517, 132.019)
    ..cubicTo(293.517, 132.019, 300.718, 126.383, 300.718, 126.383)
    ..cubicTo(300.842, 126.287, 300.943, 126.165, 301.013, 126.022)
    ..cubicTo(301.013, 126.022, 306.283, 115.482, 306.283, 115.482)
    ..cubicTo(306.352, 115.346, 306.39, 115.196, 306.395, 115.039)
    ..cubicTo(306.395, 115.039, 307.374, 82.3937, 307.374, 82.3937)
    ..cubicTo(307.374, 82.3937, 317.756, 66.171, 317.756, 66.171)
    ..cubicTo(317.869, 65.996, 317.927, 65.7923, 317.924, 65.5852)
    ..cubicTo(317.924, 65.5852, 317.241, 21.4423, 317.241, 21.4423)
    ..cubicTo(330.184, 21.9602, 342.537, 22.8639, 351.627, 24.1605)
    ..cubicTo(352.213, 24.2426, 352.745, 23.839, 352.827, 23.2603)
    ..cubicTo(352.91, 22.6782, 352.506, 22.1424, 351.927, 22.0603)
    ..cubicTo(342.752, 20.753, 330.271, 19.8423, 317.208, 19.3208)
    ..cubicTo(317.208, 19.3208, 316.935, 1.6836, 316.935, 1.6836)
    ..cubicTo(316.926, 1.1014, 316.454, 0.6371, 315.876, 0.6371)
    ..cubicTo(315.87, 0.6371, 315.864, 0.6371, 315.859, 0.6371)
    ..cubicTo(315.273, 0.6478, 314.806, 1.13, 314.815, 1.7158)
    ..cubicTo(314.815, 1.7158, 315.086, 19.2386, 315.086, 19.2386)
    ..cubicTo(297.136, 18.5778, 278.368, 18.6457, 265.743, 19.4172)
    ..cubicTo(265.548, 19.4279, 265.36, 19.4922, 265.2, 19.6065)
    ..cubicTo(265.2, 19.6065, 248.9, 31.0145, 248.9, 31.0145)
    ..cubicTo(243.582, 32.1146, 211.692, 30.5467, 192.547, 29.6073)
    ..cubicTo(185.719, 29.2716, 180.326, 29.0073, 178.21, 28.968)
    ..cubicTo(178.16, 28.9644, 178.105, 28.9679, 178.053, 28.9751)
    ..cubicTo(162.256, 31.0253, 141.566, 37.6151, 123.436, 45.8872)
    ..cubicTo(116.164, 30.1288, 109.012, 14.8561, 102.479, 1.3193)
    ..cubicTo(102.224, 0.7943, 101.59, 0.5728, 101.063, 0.8264)
    ..cubicTo(100.536, 1.08, 100.315, 1.7157, 100.569, 2.2408)
    ..cubicTo(107.096, 15.7669, 114.243, 31.0289, 121.511, 46.773)
    ..cubicTo(113.318, 50.6054, 105.712, 54.7629, 99.4113, 58.9811)
    ..cubicTo(99.1016, 59.0846, 98.8762, 59.474, 97.9515, 61.0634)
    ..cubicTo(97.9515, 61.0634, 92.9486, 69.6784, 92.9486, 69.6784)
    ..cubicTo(92.8857, 69.7891, 92.8422, 69.907, 92.8207, 70.032)
    ..cubicTo(92.8207, 70.032, 89.1972, 91.1123, 89.1972, 91.1123)
    ..cubicTo(89.189, 91.1623, 89.184, 91.2123, 89.1826, 91.2623)
    ..cubicTo(89.1826, 91.2623, 88.5236, 113.989, 88.5236, 113.989)
    ..cubicTo(88.5229, 114.018, 88.5232, 114.046, 88.5247, 114.075)
    ..cubicTo(89.1747, 126.512, 106.569, 167.611, 114.502, 177.905)
    ..cubicTo(114.502, 177.905, 113.594, 185.773, 113.594, 185.773)
    ..cubicTo(113.594, 185.773, 113.137, 186.434, 113.137, 186.434)
    ..cubicTo(112.689, 186.363, 112.228, 186.581, 112.018, 187.009)
    ..cubicTo(111.857, 187.338, 111.882, 187.706, 112.051, 188.002)
    ..cubicTo(112.051, 188.002, 110.946, 189.599, 110.946, 189.599)
    ..cubicTo(106.783, 191.524, 97.5386, 196.31, 94.2737, 198.446)
    ..cubicTo(94.1498, 198.528, 94.0441, 198.632, 93.9637, 198.757)
    ..cubicTo(91.7785, 202.136, 89.214, 205.536, 86.4131, 208.936)
    ..cubicTo(66.1532, 205.593, 41.7216, 200.871, 12.2721, 194.224)
    ..cubicTo(12.2721, 194.224, -5.3516, 182.477, -5.3516, 182.477)
    ..cubicTo(-5.8395, 182.152, -6.4973, 182.284, -6.8217, 182.77)
    ..cubicTo(-7.1465, 183.255, -7.015, 183.916, -6.5278, 184.241)
    ..cubicTo(-6.5278, 184.241, 11.2591, 196.099, 11.2591, 196.099)
    ..cubicTo(11.367, 196.171, 11.487, 196.221, 11.6138, 196.249)
    ..cubicTo(29.8446, 200.364, 56.5542, 206.186, 84.7933, 210.872)
    ..cubicTo(79.3711, 217.258, 73.1931, 223.634, 67.1372, 229.884)
    ..cubicTo(57.2707, 240.064, 47.0685, 250.589, 40.2743, 261.008)
    ..cubicTo(40.2136, 261.101, 40.1697, 261.201, 40.1408, 261.305)
    ..cubicTo(40.0368, 261.655, 38.1713, 267.873, 38.1713, 267.873)
    ..cubicTo(38.1413, 267.969, 38.126, 268.073, 38.1263, 268.177)
    ..cubicTo(38.1263, 268.177, 38.456, 450.991, 38.456, 450.991)
    ..cubicTo(38.4563, 451.17, 38.5017, 451.345, 38.5885, 451.502)
    ..cubicTo(39.2846, 452.759, 40.005, 454.045, 40.7369, 455.342)
    ..cubicTo(24.6434, 465.571, 8.8331, 475.511, -6.4978, 485.001)
    ..cubicTo(-6.9954, 485.308, -7.1493, 485.962, -6.8411, 486.462)
    ..cubicTo(-6.6406, 486.787, -6.2937, 486.962, -5.9386, 486.962)
    ..cubicTo(-5.7482, 486.962, -5.5554, 486.912, -5.3816, 486.805)
    ..cubicTo(9.9273, 477.329, 25.7139, 467.403, 41.782, 457.188)
    ..cubicTo(58.4769, 486.519, 83.6093, 524.751, 107.964, 561.8)
    ..cubicTo(109.739, 564.5, 111.501, 567.183, 113.255, 569.851)
    ..cubicTo(93.3618, 578.777, 74.8768, 586.97, 60.2888, 593.435)
    ..cubicTo(60.2888, 593.435, 59.8384, 593.635, 59.8384, 593.635)
    ..cubicTo(59.8384, 593.635, 59.8459, 593.649, 59.8459, 593.649)
    ..cubicTo(59.2898, 593.753, 58.4594, 593.953, 57.185, 594.267)
    ..cubicTo(57.185, 594.267, -5.8627, 609.711, -5.8627, 609.711)
    ..cubicTo(-6.4315, 609.851, -6.7794, 610.426, -6.6402, 610.994)
    ..cubicTo(-6.5215, 611.479, -6.0884, 611.804, -5.6111, 611.804)
    ..cubicTo(-5.5275, 611.804, -5.4426, 611.794, -5.3581, 611.772)
    ..cubicTo(-4.7025, 611.611, 60.2017, 595.71, 60.5171, 595.635)
    ..cubicTo(60.5785, 595.617, 60.6396, 595.599, 60.6978, 595.571)
    ..cubicTo(60.6978, 595.571, 61.1482, 595.374, 61.1482, 595.374)
    ..cubicTo(75.8147, 588.874, 94.418, 580.627, 114.435, 571.647)
    ..cubicTo(131.706, 597.946, 147.736, 622.53, 159.432, 642.146)
    ..cubicTo(159.432, 642.146, 160.214, 644.536, 160.214, 644.536)
    ..cubicTo(160.214, 644.536, 153.202, 666.209, 153.202, 666.209)
    ..cubicTo(148.942, 667.912, 144.716, 669.588, 140.544, 671.241)
    ..cubicTo(140.544, 671.241, 134.236, 673.741, 134.236, 673.741)
    ..cubicTo(133.692, 673.959, 133.427, 674.574, 133.643, 675.116)
    ..cubicTo(133.808, 675.534, 134.206, 675.788, 134.628, 675.788)
    ..cubicTo(134.758, 675.788, 134.891, 675.763, 135.019, 675.713)
    ..cubicTo(135.019, 675.713, 138.038, 674.516, 138.038, 674.516)
    ..cubicTo(137.999, 674.706, 138.009, 674.909, 138.084, 675.106)
    ..cubicTo(138.246, 675.527, 138.648, 675.788, 139.075, 675.788)
    ..cubicTo(139.201, 675.788, 139.329, 675.767, 139.454, 675.717)
    ..cubicTo(139.454, 675.717, 144.544, 673.77, 144.544, 673.77)
    ..cubicTo(148.444, 672.281, 152.394, 670.773, 156.376, 669.234)
    ..cubicTo(156.376, 669.234, 168.254, 676.024, 168.254, 676.024)
    ..cubicTo(168.254, 676.024, 181.151, 659.315, 181.151, 659.315)
    ..cubicTo(192.702, 654.461, 204.218, 649.214, 215.286, 643.332)
    ..cubicTo(215.286, 643.332, 229.298, 644.825, 229.298, 644.825)
    ..cubicTo(229.298, 644.825, 233.781, 632.57, 233.781, 632.57)
    ..cubicTo(244.513, 625.691, 254.517, 618.012, 263.342, 609.272)
    ..cubicTo(263.365, 609.251, 263.387, 609.229, 263.408, 609.204)
    ..cubicTo(265.477, 606.743, 267.612, 604.364, 269.779, 602.021)
    ..cubicTo(269.787, 602.039, 269.791, 602.057, 269.8, 602.075)
    ..cubicTo(269.986, 602.446, 270.36, 602.661, 270.749, 602.661)
    ..cubicTo(270.909, 602.661, 271.07, 602.625, 271.223, 602.55)
    ..cubicTo(271.898, 602.211, 278.626, 599.828, 282.709, 598.403)
    ..cubicTo(282.949, 598.321, 283.151, 598.153, 283.278, 597.932)
    ..cubicTo(283.278, 597.932, 287.972, 589.778, 287.972, 589.778)
    ..cubicTo(288.086, 589.581, 288.133, 589.352, 288.107, 589.127)
    ..cubicTo(288.107, 589.127, 287.615, 584.863, 287.615, 584.863)
    ..cubicTo(307.193, 568.033, 329.477, 554.56, 353.07, 542.959)
    ..cubicTo(353.07, 542.959, 374.172, 538.045, 374.172, 538.045)
    ..cubicTo(374.172, 538.045, 384.309, 548.178, 384.309, 548.178)
    ..cubicTo(384.351, 548.331, 384.394, 548.488, 384.437, 548.646)
    ..cubicTo(387.473, 559.511, 390.216, 569.319, 393.488, 578.777)
    ..cubicTo(393.488, 578.777, 393.952, 600.143, 393.952, 600.143)
    ..cubicTo(393.956, 600.253, 393.974, 600.361, 394.009, 600.468)
    ..cubicTo(394.009, 600.468, 396.235, 606.89, 396.235, 606.89)
    ..cubicTo(396.277, 607.018, 396.349, 607.14, 396.438, 607.24)
    ..cubicTo(396.438, 607.24, 398.167, 609.218, 398.167, 609.218)
    ..cubicTo(398.313, 609.383, 398.506, 609.501, 398.72, 609.551)
    ..cubicTo(398.72, 609.551, 402.921, 610.54, 402.921, 610.54)
    ..cubicTo(403.003, 610.558, 403.082, 610.568, 403.164, 610.568)
    ..cubicTo(403.21, 610.568, 403.26, 610.565, 403.307, 610.558)
    ..cubicTo(403.307, 610.558, 407.489, 609.99, 407.489, 609.99)
    ..cubicTo(418.193, 628.699, 434.448, 649.086, 462.454, 676.474)
    ..cubicTo(462.661, 676.674, 462.929, 676.777, 463.197, 676.777)
    ..cubicTo(463.472, 676.777, 463.747, 676.67, 463.954, 676.456)
    ..cubicTo(464.279, 676.124, 464.329, 675.638, 464.133, 675.245)
    ..cubicTo(464.229, 675.274, 464.329, 675.292, 464.429, 675.292)
    ..cubicTo(464.683, 675.292, 464.937, 675.202, 465.14, 675.02)
    ..cubicTo(465.576, 674.627, 465.612, 673.959, 465.219, 673.524)
    ..cubicTo(461.49, 669.384, 457.997, 665.519, 454.729, 661.901)
    ..cubicTo(430.284, 634.849, 418.211, 621.487, 410.282, 607.883)
    ..cubicTo(410.282, 607.883, 414.472, 600.128, 414.472, 600.128)
    ..cubicTo(414.59, 599.918, 414.625, 599.671, 414.582, 599.432)
    ..cubicTo(414.582, 599.432, 413.961, 596.114, 413.961, 596.114)
    ..cubicTo(414.097, 595.874, 414.143, 595.589, 414.072, 595.317)
    ..cubicTo(413.986, 595.003, 413.765, 594.746, 413.465, 594.617)
    ..cubicTo(413.465, 594.617, 412.986, 594.41, 412.986, 594.41)
    ..cubicTo(412.986, 594.41, 402.624, 584.966, 402.624, 584.966)
    ..cubicTo(402.624, 584.966, 390.191, 539.634, 390.191, 539.634)
    ..cubicTo(390.191, 539.634, 392.681, 532.623, 392.681, 532.623)
    ..cubicTo(392.681, 532.623, 414.129, 518.24, 414.129, 518.24)
    ..cubicTo(414.618, 517.915, 414.747, 517.257, 414.422, 516.772)
    ..cubicTo(414.418, 516.768, 414.418, 516.768, 414.418, 516.768)
    ..cubicTo(422.094, 513.811, 429.78, 510.907, 437.438, 508.021)
    ..cubicTo(458.232, 500.174, 479.563, 492.127, 499.857, 483.205)
    ..cubicTo(499.857, 483.205, 515.019, 491.716, 515.019, 491.716)
    ..cubicTo(515.194, 492.037, 515.373, 492.366, 515.551, 492.68)
    ..cubicTo(515.676, 492.909, 515.88, 493.063, 516.109, 493.148)
    ..cubicTo(524.238, 509.45, 533.639, 529.358, 543.586, 550.421)
    ..cubicTo(557.53, 579.952, 571.949, 610.486, 583.757, 632.892)
    ..cubicTo(585.368, 637.946, 587.85, 648.236, 588.129, 653.047)
    ..cubicTo(588.129, 653.05, 588.129, 653.05, 588.129, 653.054)
    ..cubicTo(588.136, 653.204, 588.568, 660.976, 588.618, 661.858)
    ..cubicTo(588.618, 661.858, 587.389, 674.377, 587.389, 674.377)
    ..cubicTo(587.332, 674.959, 587.761, 675.477, 588.343, 675.534)
    ..cubicTo(588.379, 675.538, 588.414, 675.542, 588.446, 675.542)
    ..cubicTo(588.986, 675.542, 589.447, 675.131, 589.5, 674.584)
    ..cubicTo(589.5, 674.584, 590.736, 661.983, 590.736, 661.983)
    ..cubicTo(590.743, 661.93, 590.743, 661.876, 590.739, 661.823)
    ..cubicTo(590.739, 661.823, 590.322, 654.318, 590.322, 654.318)
    ..cubicTo(590.289, 653.733, 590.264, 653.276, 590.214, 652.929)
    ..cubicTo(590.214, 652.929, 590.243, 652.925, 590.243, 652.925)
    ..cubicTo(589.932, 647.468, 587.193, 636.671, 585.75, 632.16)
    ..cubicTo(585.732, 632.099, 585.707, 632.042, 585.678, 631.988)
    ..cubicTo(573.881, 609.615, 559.455, 579.062, 545.504, 549.517)
    ..cubicTo(535.474, 528.28, 525.999, 508.21, 517.816, 491.816)
    ..cubicTo(517.923, 491.473, 517.844, 491.098, 517.616, 490.827)
    ..cubicTo(517.616, 490.827, 517.616, 480.99, 517.616, 480.99)
    ..cubicTo(517.616, 480.99, 520.134, 474.357, 520.134, 474.357)
    ..cubicTo(523.02, 472.536, 529.177, 466.039, 534.767, 460.038)
    ..cubicTo(535.749, 458.985, 536.557, 458.117, 537.085, 457.57)
    ..cubicTo(537.171, 457.478, 537.246, 457.37, 537.296, 457.253)
    ..cubicTo(537.296, 457.253, 542.482, 445.148, 542.482, 445.148)
    ..cubicTo(542.514, 445.077, 542.536, 445.002, 542.55, 444.927)
    ..cubicTo(542.55, 444.927, 544.775, 433.068, 544.775, 433.068)
    ..cubicTo(544.789, 432.986, 544.793, 432.904, 544.789, 432.818)
    ..cubicTo(544.789, 432.818, 544.339, 423.611, 544.339, 423.611)
    ..cubicTo(544.414, 423.507, 544.472, 423.396, 544.507, 423.271)
    ..cubicTo(544.507, 423.271, 550.079, 402.927, 550.079, 402.927)
    ..cubicTo(550.079, 402.927, 579.071, 385.286, 579.071, 385.286)
    ..cubicTo(579.071, 385.286, 591.329, 386.25, 591.329, 386.25)
    ..cubicTo(591.461, 386.261, 591.597, 386.247, 591.725, 386.204)
    ..cubicTo(591.725, 386.204, 602.101, 382.993, 602.101, 382.993)
    ..cubicTo(602.658, 382.822, 602.973, 382.225, 602.798, 381.668)
    ..cubicTo(602.626, 381.107, 602.03, 380.796, 601.472, 380.968)
    ..cubicTo(601.472, 380.968, 591.29, 384.122, 591.29, 384.122)
    ..cubicTo(591.29, 384.122, 583.839, 383.536, 583.839, 383.536)
    ..cubicTo(583.839, 383.536, 589.6, 383.536, 589.6, 383.536)
    ..cubicTo(589.725, 383.536, 589.85, 383.514, 589.964, 383.468)
    ..cubicTo(589.964, 383.468, 608.741, 376.553, 608.741, 376.553)
    ..cubicTo(608.816, 376.525, 608.884, 376.489, 608.952, 376.446)
    ..cubicTo(608.952, 376.446, 621.138, 368.542, 621.138, 368.542)
    ..cubicTo(621.488, 368.313, 621.674, 367.902, 621.61, 367.488)
    ..cubicTo(621.61, 367.488, 621.61, 367.488, 621.61, 367.488)
    ..close();

  static final Path __path37_1_11 = Path()
    ..moveTo(300.127, 225.776)
    ..cubicTo(299.615, 224.787, 299.038, 223.672, 298.387, 222.397)
    ..cubicTo(298.325, 222.279, 298.23, 222.176, 298.113, 222.108)
    ..cubicTo(298.113, 222.108, 290.317, 217.561, 290.317, 217.561)
    ..cubicTo(290.317, 217.561, 282.882, 208.51, 282.882, 208.51)
    ..cubicTo(282.882, 208.51, 276.648, 194.484, 276.648, 194.484)
    ..cubicTo(284.455, 191.523, 293.16, 188.609, 299.583, 186.623)
    ..cubicTo(299.583, 186.623, 309.294, 209.489, 309.294, 209.489)
    ..cubicTo(309.304, 209.514, 309.315, 209.535, 309.326, 209.557)
    ..cubicTo(309.326, 209.557, 317.561, 224.379, 317.561, 224.379)
    ..cubicTo(317.617, 224.479, 317.696, 224.565, 317.792, 224.629)
    ..cubicTo(317.792, 224.629, 325.383, 229.591, 325.383, 229.591)
    ..cubicTo(325.382, 229.598, 325.378, 229.605, 325.378, 229.612)
    ..cubicTo(325.378, 229.612, 325.094, 237.559, 325.094, 237.559)
    ..cubicTo(325.094, 237.559, 304.064, 235.177, 304.064, 235.177)
    ..cubicTo(303.489, 232.302, 302.469, 230.298, 300.127, 225.776)
    ..cubicTo(300.127, 225.776, 300.127, 225.776, 300.127, 225.776)
    ..close();

  static final Path __path37_1_12 = Path()
    ..moveTo(275.836, 231.98)
    ..cubicTo(275.836, 231.98, 277.046, 223.812, 277.046, 223.812)
    ..cubicTo(277.071, 223.64, 277.033, 223.469, 276.939, 223.322)
    ..cubicTo(275.093, 220.479, 273.001, 217.407, 270.786, 214.154)
    ..cubicTo(267.943, 209.982, 264.885, 205.492, 261.934, 200.863)
    ..cubicTo(265.155, 199.106, 269.976, 197.049, 275.326, 194.988)
    ..cubicTo(275.326, 194.988, 281.63, 209.171, 281.63, 209.171)
    ..cubicTo(281.655, 209.232, 281.689, 209.285, 281.729, 209.335)
    ..cubicTo(281.729, 209.335, 289.305, 218.558, 289.305, 218.558)
    ..cubicTo(289.359, 218.622, 289.423, 218.675, 289.495, 218.718)
    ..cubicTo(289.495, 218.718, 297.222, 223.226, 297.222, 223.226)
    ..cubicTo(297.836, 224.426, 298.383, 225.483, 298.872, 226.426)
    ..cubicTo(301.018, 230.569, 302.014, 232.498, 302.583, 235.009)
    ..cubicTo(302.583, 235.009, 275.836, 231.98, 275.836, 231.98)
    ..cubicTo(275.836, 231.98, 275.836, 231.98, 275.836, 231.98)
    ..close();

  static final Path __path37_1_13 = Path()
    ..moveTo(247.395, 169.879)
    ..cubicTo(247.384, 169.825, 247.367, 169.775, 247.346, 169.725)
    ..cubicTo(247.286, 169.593, 241.149, 155.86, 240.487, 154.377)
    ..cubicTo(240.487, 154.377, 240.165, 141.508, 240.165, 141.508)
    ..cubicTo(240.165, 141.508, 241.334, 139.015, 241.334, 139.015)
    ..cubicTo(241.334, 139.015, 269.106, 152.642, 269.106, 152.642)
    ..cubicTo(269.089, 152.688, 269.069, 152.727, 269.061, 152.774)
    ..cubicTo(269.061, 152.774, 267.084, 164.964, 267.084, 164.964)
    ..cubicTo(267.069, 165.064, 267.074, 165.164, 267.1, 165.26)
    ..cubicTo(267.1, 165.26, 274.846, 193.663, 274.846, 193.663)
    ..cubicTo(269.383, 195.766, 264.455, 197.87, 261.176, 199.667)
    ..cubicTo(254.912, 189.723, 249.265, 179.212, 247.395, 169.879)
    ..cubicTo(247.395, 169.879, 247.395, 169.879, 247.395, 169.879)
    ..close();

  static final Path __path37_1_14 = Path()
    ..moveTo(242.075, 161.824)
    ..cubicTo(242.075, 161.824, 217.125, 175.718, 217.125, 175.718)
    ..cubicTo(214.687, 163.642, 213.677, 146.202, 212.844, 131.801)
    ..cubicTo(212.706, 129.4, 212.57, 127.064, 212.433, 124.832)
    ..cubicTo(212.433, 124.832, 240.065, 138.394, 240.065, 138.394)
    ..cubicTo(240.065, 138.394, 238.815, 141.058, 238.815, 141.058)
    ..cubicTo(238.768, 141.158, 238.745, 141.269, 238.748, 141.376)
    ..cubicTo(238.748, 141.376, 239.078, 154.552, 239.078, 154.552)
    ..cubicTo(239.08, 154.645, 239.101, 154.738, 239.139, 154.824)
    ..cubicTo(239.139, 154.824, 242.242, 161.771, 242.242, 161.771)
    ..cubicTo(242.186, 161.785, 242.128, 161.792, 242.075, 161.824)
    ..cubicTo(242.075, 161.824, 242.075, 161.824, 242.075, 161.824)
    ..close();

  static final Path __path37_1_15 = Path()
    ..moveTo(271.813, 160.506)
    ..cubicTo(271.935, 160.496, 272.052, 160.449, 272.151, 160.378)
    ..cubicTo(272.151, 160.378, 275.774, 157.742, 275.774, 157.742)
    ..cubicTo(275.88, 157.663, 275.962, 157.56, 276.012, 157.438)
    ..cubicTo(276.012, 157.438, 276.494, 156.267, 276.494, 156.267)
    ..cubicTo(276.494, 156.267, 299.026, 167.325, 299.026, 167.325)
    ..cubicTo(299.026, 167.325, 299.026, 185.169, 299.026, 185.169)
    ..cubicTo(299.026, 185.216, 299.045, 185.258, 299.055, 185.308)
    ..cubicTo(292.633, 187.298, 283.968, 190.198, 276.173, 193.155)
    ..cubicTo(276.173, 193.155, 268.505, 165.039, 268.505, 165.039)
    ..cubicTo(268.505, 165.039, 269.192, 160.799, 269.192, 160.799)
    ..cubicTo(269.192, 160.799, 271.813, 160.506, 271.813, 160.506)
    ..cubicTo(271.813, 160.506, 271.813, 160.506, 271.813, 160.506)
    ..close();

  static final Path __path37_1_16 = Path()
    ..moveTo(163.651, 372.556)
    ..cubicTo(164.247, 373.867, 164.556, 374.545, 164.767, 374.899)
    ..cubicTo(164.767, 374.899, 164.729, 374.92, 164.729, 374.92)
    ..cubicTo(167.935, 380.528, 171.823, 386.489, 176.059, 392.514)
    ..cubicTo(175.813, 392.754, 175.76, 393.132, 175.964, 393.422)
    ..cubicTo(176.101, 393.618, 176.32, 393.722, 176.541, 393.722)
    ..cubicTo(176.649, 393.722, 176.754, 393.69, 176.854, 393.64)
    ..cubicTo(179.372, 397.19, 182, 400.754, 184.679, 404.28)
    ..cubicTo(184.679, 404.28, 158.682, 420.877, 158.682, 420.877)
    ..cubicTo(153.436, 411.416, 146.718, 401.347, 140.629, 392.225)
    ..cubicTo(137.544, 387.607, 134.631, 383.242, 132.017, 379.138)
    ..cubicTo(127.221, 371.334, 118.041, 349.915, 111.559, 334.385)
    ..cubicTo(116.075, 332.502, 120.587, 330.627, 125.084, 328.759)
    ..cubicTo(130.372, 326.566, 135.608, 324.391, 140.8, 322.219)
    ..cubicTo(140.8, 322.219, 163.651, 372.556, 163.651, 372.556)
    ..cubicTo(163.651, 372.556, 163.651, 372.556, 163.651, 372.556)
    ..close();

  static final Path __path37_1_17 = Path()
    ..moveTo(58.3583, 301.679)
    ..cubicTo(58.3583, 301.679, 59.2919, 267.444, 59.2919, 267.444)
    ..cubicTo(59.2919, 267.444, 64.1705, 269.765, 64.1705, 269.765)
    ..cubicTo(64.1705, 269.765, 72.2123, 276.202, 72.2123, 276.202)
    ..cubicTo(72.2123, 276.202, 87.2888, 308.551, 87.2888, 308.551)
    ..cubicTo(77.4402, 305.704, 63.1258, 301.689, 58.3583, 301.679)
    ..cubicTo(58.3583, 301.679, 58.3583, 301.679, 58.3583, 301.679)
    ..close();

  static final Path __path37_1_18 = Path()
    ..moveTo(615.115, 564.925)
    ..cubicTo(615.115, 564.925, 597.66, 560.974, 597.66, 560.974)
    ..cubicTo(597.603, 560.96, 597.542, 560.953, 597.485, 560.957)
    ..cubicTo(597.485, 560.957, 585.627, 561.285, 585.627, 561.285)
    ..cubicTo(585.58, 561.285, 585.537, 561.292, 585.494, 561.303)
    ..cubicTo(585.48, 561.307, 585.466, 561.31, 585.448, 561.31)
    ..cubicTo(585.409, 561.303, 585.369, 561.285, 585.327, 561.285)
    ..cubicTo(585.159, 561.285, 585.012, 561.346, 584.891, 561.442)
    ..cubicTo(573.229, 564.075, 560.71, 569.461, 548.591, 574.679)
    ..cubicTo(540.916, 577.987, 533.094, 581.355, 525.382, 584.076)
    ..cubicTo(525.382, 584.076, 525.082, 575.144, 525.082, 575.144)
    ..cubicTo(525.082, 575.094, 525.075, 575.043, 525.065, 574.997)
    ..cubicTo(525.065, 574.997, 522.1, 563.139, 522.1, 563.139)
    ..cubicTo(522.075, 563.043, 522.032, 562.953, 521.971, 562.875)
    ..cubicTo(521.971, 562.875, 515.053, 553.981, 515.053, 553.981)
    ..cubicTo(514.992, 553.903, 514.914, 553.838, 514.824, 553.788)
    ..cubicTo(506.552, 549.474, 488.965, 541.605, 480.34, 538.019)
    ..cubicTo(477.014, 534.108, 475.628, 532.479, 474.986, 531.797)
    ..cubicTo(474.243, 528.325, 473.014, 524.454, 471.385, 520.26)
    ..cubicTo(471.385, 520.26, 515.825, 502.923, 515.825, 502.923)
    ..cubicTo(515.825, 502.923, 521.786, 513.589, 521.786, 513.589)
    ..cubicTo(521.968, 513.917, 522.379, 514.042, 522.718, 513.874)
    ..cubicTo(522.718, 513.874, 526.672, 511.899, 526.672, 511.899)
    ..cubicTo(527.018, 511.724, 527.161, 511.299, 526.986, 510.949)
    ..cubicTo(526.811, 510.599, 526.386, 510.46, 526.04, 510.635)
    ..cubicTo(526.04, 510.635, 522.689, 512.31, 522.689, 512.31)
    ..cubicTo(522.689, 512.31, 516.76, 501.698, 516.76, 501.698)
    ..cubicTo(516.585, 501.388, 516.214, 501.255, 515.885, 501.384)
    ..cubicTo(515.885, 501.384, 470.864, 518.946, 470.864, 518.946)
    ..cubicTo(459.02, 489.522, 428.057, 445.015, 401.89, 409.123)
    ..cubicTo(417.777, 406.766, 433.289, 403.915, 447.49, 399.954)
    ..cubicTo(447.49, 399.954, 447.473, 399.894, 447.473, 399.894)
    ..cubicTo(447.937, 399.722, 448.808, 399.219, 450.691, 398.136)
    ..cubicTo(450.691, 398.136, 467.088, 388.686, 467.088, 388.686)
    ..cubicTo(467.088, 388.686, 466.381, 387.46, 466.381, 387.46)
    ..cubicTo(466.196, 387.568, 448.326, 397.865, 447.023, 398.615)
    ..cubicTo(432.7, 402.608, 417.013, 405.465, 400.951, 407.834)
    ..cubicTo(394.847, 399.472, 389.021, 391.597, 383.785, 384.521)
    ..cubicTo(377.267, 375.71, 371.638, 368.098, 367.541, 362.355)
    ..cubicTo(367.288, 361.898, 367.33, 360.305, 367.555, 358.065)
    ..cubicTo(380.039, 357.483, 391.061, 356.654, 398.951, 355.836)
    ..cubicTo(398.951, 355.836, 398.951, 355.819, 398.951, 355.819)
    ..cubicTo(399.279, 355.715, 399.926, 355.272, 401.751, 354.018)
    ..cubicTo(401.751, 354.018, 415.091, 344.846, 415.091, 344.846)
    ..cubicTo(415.141, 344.814, 415.184, 344.775, 415.224, 344.728)
    ..cubicTo(415.224, 344.728, 430.375, 327.27, 430.375, 327.27)
    ..cubicTo(430.632, 326.973, 430.6, 326.531, 430.307, 326.273)
    ..cubicTo(430.01, 326.016, 429.564, 326.048, 429.31, 326.345)
    ..cubicTo(429.31, 326.345, 414.216, 343.732, 414.216, 343.732)
    ..cubicTo(413.109, 344.493, 400.151, 353.404, 398.629, 354.447)
    ..cubicTo(389.85, 355.354, 379.196, 356.129, 367.713, 356.654)
    ..cubicTo(368.495, 350.082, 370.416, 339.607, 371.416, 334.163)
    ..cubicTo(372.027, 330.82, 372.47, 328.409, 372.574, 327.548)
    ..cubicTo(372.577, 327.516, 372.577, 327.488, 372.577, 327.456)
    ..cubicTo(372.577, 327.456, 372.252, 305.443, 372.252, 305.443)
    ..cubicTo(372.252, 305.443, 384.718, 305.443, 384.718, 305.443)
    ..cubicTo(384.875, 305.443, 385.025, 305.393, 385.15, 305.297)
    ..cubicTo(386.753, 304.047, 390.236, 299.421, 392.129, 296.903)
    ..cubicTo(395.304, 299.382, 398.576, 301.904, 401.855, 304.429)
    ..cubicTo(406.148, 307.725, 409.541, 310.333, 410.938, 311.533)
    ..cubicTo(411.07, 311.647, 411.234, 311.704, 411.398, 311.704)
    ..cubicTo(411.595, 311.704, 411.795, 311.619, 411.934, 311.458)
    ..cubicTo(412.188, 311.161, 412.152, 310.715, 411.855, 310.461)
    ..cubicTo(410.434, 309.236, 407.03, 306.618, 402.719, 303.307)
    ..cubicTo(399.879, 301.125, 396.504, 298.528, 392.947, 295.753)
    ..cubicTo(393.05, 295.471, 392.972, 295.146, 392.718, 294.953)
    ..cubicTo(392.472, 294.764, 392.143, 294.771, 391.9, 294.935)
    ..cubicTo(386.764, 290.917, 381.332, 286.581, 376.628, 282.588)
    ..cubicTo(380.814, 279.484, 386.214, 275.023, 389.964, 271.93)
    ..cubicTo(391.289, 270.833, 392.375, 269.94, 393.065, 269.387)
    ..cubicTo(393.254, 269.233, 393.35, 268.997, 393.325, 268.758)
    ..cubicTo(393.043, 266.226, 392.765, 263.133, 392.507, 259.75)
    ..cubicTo(396.076, 259.136, 399.544, 258.604, 402.565, 258.339)
    ..cubicTo(402.83, 258.314, 403.062, 258.146, 403.158, 257.896)
    ..cubicTo(403.158, 257.896, 403.819, 256.25, 403.819, 256.25)
    ..cubicTo(403.962, 255.889, 403.787, 255.478, 403.426, 255.332)
    ..cubicTo(403.062, 255.185, 402.651, 255.361, 402.505, 255.725)
    ..cubicTo(402.505, 255.725, 402.008, 256.971, 402.008, 256.971)
    ..cubicTo(399.083, 257.246, 395.79, 257.754, 392.404, 258.336)
    ..cubicTo(391.614, 247.328, 391.107, 233.766, 391.679, 226.397)
    ..cubicTo(391.711, 226.008, 391.418, 225.669, 391.029, 225.637)
    ..cubicTo(390.643, 225.608, 390.3, 225.897, 390.268, 226.287)
    ..cubicTo(389.689, 233.748, 390.204, 247.481, 391.004, 258.579)
    ..cubicTo(389.468, 258.85, 387.918, 259.132, 386.386, 259.411)
    ..cubicTo(380.86, 260.422, 375.145, 261.465, 370.491, 261.872)
    ..cubicTo(370.32, 261.886, 370.159, 261.965, 370.041, 262.086)
    ..cubicTo(370.041, 262.086, 363.916, 268.504, 363.916, 268.504)
    ..cubicTo(363.916, 268.504, 361.044, 230.573, 361.044, 230.573)
    ..cubicTo(361.016, 230.184, 360.68, 229.894, 360.287, 229.919)
    ..cubicTo(359.898, 229.948, 359.605, 230.287, 359.637, 230.676)
    ..cubicTo(359.637, 230.676, 362.548, 269.183, 362.548, 269.183)
    ..cubicTo(362.548, 269.183, 343.246, 270.408, 343.246, 270.408)
    ..cubicTo(343.246, 270.408, 343.261, 270.194, 343.261, 270.194)
    ..cubicTo(343.282, 269.805, 342.986, 269.469, 342.596, 269.447)
    ..cubicTo(342.296, 269.426, 342.039, 269.587, 341.921, 269.833)
    ..cubicTo(341.921, 269.833, 337.032, 267.261, 337.032, 267.261)
    ..cubicTo(337.032, 267.261, 330.663, 261.529, 330.663, 261.529)
    ..cubicTo(330.663, 261.529, 328.763, 254.56, 328.763, 254.56)
    ..cubicTo(328.763, 254.56, 328.136, 239.813, 328.136, 239.813)
    ..cubicTo(328.136, 239.813, 348.411, 241.87, 348.411, 241.87)
    ..cubicTo(348.436, 241.87, 348.461, 241.87, 348.482, 241.87)
    ..cubicTo(348.843, 241.87, 349.15, 241.602, 349.186, 241.238)
    ..cubicTo(349.225, 240.849, 348.943, 240.502, 348.554, 240.463)
    ..cubicTo(348.554, 240.463, 328.085, 238.384, 328.085, 238.384)
    ..cubicTo(328.024, 238.095, 327.791, 237.863, 327.481, 237.827)
    ..cubicTo(327.481, 237.827, 326.503, 237.716, 326.503, 237.716)
    ..cubicTo(326.503, 237.716, 326.767, 230.341, 326.767, 230.341)
    ..cubicTo(326.829, 230.337, 326.891, 230.33, 326.952, 230.312)
    ..cubicTo(327.153, 230.251, 327.316, 230.101, 327.396, 229.905)
    ..cubicTo(327.396, 229.905, 331.349, 220.354, 331.349, 220.354)
    ..cubicTo(331.499, 219.993, 331.328, 219.579, 330.967, 219.433)
    ..cubicTo(330.606, 219.283, 330.192, 219.454, 330.043, 219.815)
    ..cubicTo(330.043, 219.815, 326.416, 228.58, 326.416, 228.58)
    ..cubicTo(326.416, 228.58, 318.712, 223.54, 318.712, 223.54)
    ..cubicTo(318.712, 223.54, 310.58, 208.903, 310.58, 208.903)
    ..cubicTo(310.58, 208.903, 300.942, 186.205, 300.942, 186.205)
    ..cubicTo(301.105, 186.155, 301.273, 186.105, 301.432, 186.058)
    ..cubicTo(302.415, 186.208, 307.696, 187.019, 307.696, 187.019)
    ..cubicTo(307.696, 187.019, 307.911, 185.623, 307.911, 185.623)
    ..cubicTo(307.911, 185.623, 304.7, 185.13, 304.7, 185.13)
    ..cubicTo(302.576, 184.801, 301.639, 184.658, 301.188, 184.694)
    ..cubicTo(301.188, 184.694, 301.177, 184.658, 301.177, 184.658)
    ..cubicTo(300.938, 184.73, 300.688, 184.805, 300.44, 184.88)
    ..cubicTo(300.44, 184.88, 300.44, 167.486, 300.44, 167.486)
    ..cubicTo(300.44, 167.486, 311.553, 168.089, 311.553, 168.089)
    ..cubicTo(311.566, 168.089, 311.579, 168.089, 311.592, 168.089)
    ..cubicTo(311.965, 168.089, 312.277, 167.796, 312.297, 167.421)
    ..cubicTo(312.318, 167.028, 312.019, 166.696, 311.63, 166.675)
    ..cubicTo(311.63, 166.675, 300.671, 166.082, 300.671, 166.082)
    ..cubicTo(305.061, 157.085, 306.423, 154.292, 306.841, 153.377)
    ..cubicTo(310.805, 150.302, 316.281, 146.809, 322.076, 143.116)
    ..cubicTo(328.546, 138.987, 335.239, 134.722, 339.71, 131.036)
    ..cubicTo(339.867, 130.908, 339.96, 130.715, 339.967, 130.511)
    ..cubicTo(339.967, 130.511, 340.625, 109.759, 340.625, 109.759)
    ..cubicTo(340.632, 109.552, 340.546, 109.349, 340.389, 109.209)
    ..cubicTo(336.124, 105.406, 331.72, 101.012, 327.166, 96.2798)
    ..cubicTo(327.166, 96.2798, 329.61, 96.2405, 329.61, 96.2405)
    ..cubicTo(336.299, 96.1298, 348.757, 95.9298, 352.819, 95.619)
    ..cubicTo(352.965, 95.6083, 353.101, 95.5547, 353.211, 95.4619)
    ..cubicTo(353.211, 95.4619, 356.63, 92.6653, 356.63, 92.6653)
    ..cubicTo(356.63, 92.6653, 366.17, 92.9724, 366.17, 92.9724)
    ..cubicTo(366.17, 92.9724, 374.127, 107.613, 374.127, 107.613)
    ..cubicTo(374.127, 107.613, 374.127, 111.427, 374.127, 111.427)
    ..cubicTo(373.163, 112.424, 371.666, 113.999, 369.856, 115.91)
    ..cubicTo(362.937, 123.214, 350.075, 136.787, 346.154, 139.426)
    ..cubicTo(345.418, 139.783, 344.214, 140.344, 342.739, 141.03)
    ..cubicTo(336.596, 143.884, 326.314, 148.663, 323.972, 150.709)
    ..cubicTo(323.952, 150.727, 323.932, 150.749, 323.913, 150.766)
    ..cubicTo(323.913, 150.766, 314.69, 160.978, 314.69, 160.978)
    ..cubicTo(314.428, 161.267, 314.451, 161.717, 314.741, 161.978)
    ..cubicTo(314.876, 162.099, 315.045, 162.16, 315.214, 162.16)
    ..cubicTo(315.407, 162.16, 315.6, 162.082, 315.739, 161.928)
    ..cubicTo(315.739, 161.928, 324.933, 151.749, 324.933, 151.749)
    ..cubicTo(327.188, 149.813, 337.685, 144.937, 343.332, 142.312)
    ..cubicTo(344.85, 141.608, 346.079, 141.037, 346.814, 140.676)
    ..cubicTo(346.843, 140.666, 346.872, 140.648, 346.897, 140.63)
    ..cubicTo(350.904, 137.965, 363.409, 124.768, 370.881, 116.885)
    ..cubicTo(372.82, 114.838, 374.392, 113.181, 375.342, 112.21)
    ..cubicTo(375.47, 112.078, 375.542, 111.899, 375.542, 111.713)
    ..cubicTo(375.542, 111.713, 375.542, 107.431, 375.542, 107.431)
    ..cubicTo(375.542, 107.313, 375.51, 107.199, 375.456, 107.095)
    ..cubicTo(375.456, 107.095, 367.22, 91.9437, 367.22, 91.9437)
    ..cubicTo(367.102, 91.7223, 366.873, 91.583, 366.623, 91.5723)
    ..cubicTo(366.623, 91.5723, 356.412, 91.2437, 356.412, 91.2437)
    ..cubicTo(356.24, 91.2366, 356.072, 91.2973, 355.94, 91.4044)
    ..cubicTo(355.94, 91.4044, 352.49, 94.2261, 352.49, 94.2261)
    ..cubicTo(348.254, 94.5261, 336.146, 94.719, 329.587, 94.8262)
    ..cubicTo(329.587, 94.8262, 327.361, 94.8619, 327.361, 94.8619)
    ..cubicTo(327.361, 94.8619, 316.873, 84.3753, 316.873, 84.3753)
    ..cubicTo(316.873, 84.3753, 319.667, 81.5822, 319.667, 81.5822)
    ..cubicTo(319.799, 81.4465, 319.874, 81.2679, 319.874, 81.0822)
    ..cubicTo(319.874, 81.0822, 319.874, 68.3561, 319.874, 68.3561)
    ..cubicTo(319.874, 68.3561, 322.142, 61.8734, 322.142, 61.8734)
    ..cubicTo(322.142, 61.8734, 329.029, 41.5397, 329.029, 41.5397)
    ..cubicTo(329.029, 41.5397, 335.567, 31.7353, 335.567, 31.7353)
    ..cubicTo(335.653, 31.6068, 335.696, 31.4496, 335.685, 31.296)
    ..cubicTo(335.685, 31.296, 335.024, 21.7416, 335.024, 21.7416)
    ..cubicTo(334.999, 21.3523, 334.646, 21.0666, 334.271, 21.0844)
    ..cubicTo(333.881, 21.113, 333.588, 21.4488, 333.613, 21.8381)
    ..cubicTo(333.613, 21.8381, 334.256, 31.1531, 334.256, 31.1531)
    ..cubicTo(334.256, 31.1531, 327.802, 40.8325, 327.802, 40.8325)
    ..cubicTo(327.768, 40.886, 327.741, 40.9396, 327.72, 40.9968)
    ..cubicTo(327.72, 40.9968, 320.806, 61.4127, 320.806, 61.4127)
    ..cubicTo(320.806, 61.4127, 318.5, 68.0026, 318.5, 68.0026)
    ..cubicTo(318.474, 68.0776, 318.46, 68.1561, 318.46, 68.2347)
    ..cubicTo(318.46, 68.2347, 318.46, 80.7893, 318.46, 80.7893)
    ..cubicTo(318.46, 80.7893, 315.43, 83.8181, 315.43, 83.8181)
    ..cubicTo(304.975, 72.6243, 294.209, 61.1913, 284.03, 53.1871)
    ..cubicTo(283.912, 53.0942, 283.766, 53.0406, 283.616, 53.0334)
    ..cubicTo(283.616, 53.0334, 273.405, 52.7049, 273.405, 52.7049)
    ..cubicTo(273.043, 52.6942, 272.725, 52.9763, 272.687, 53.3442)
    ..cubicTo(272.244, 48.6724, 271.609, 44.4471, 270.775, 41.0575)
    ..cubicTo(270.748, 40.9432, 270.694, 40.8432, 270.618, 40.7575)
    ..cubicTo(264.555, 33.9034, 251.93, 20.3737, 245.284, 13.7732)
    ..cubicTo(245.284, 13.7732, 237.753, 1.3328, 237.753, 1.3328)
    ..cubicTo(237.552, 0.9971, 237.117, 0.89, 236.783, 1.0936)
    ..cubicTo(236.449, 1.2972, 236.342, 1.7293, 236.544, 2.065)
    ..cubicTo(236.544, 2.065, 244.12, 14.5803, 244.12, 14.5803)
    ..cubicTo(244.15, 14.6304, 244.186, 14.6768, 244.227, 14.7161)
    ..cubicTo(250.796, 21.2309, 263.331, 34.6641, 269.444, 41.5611)
    ..cubicTo(272.972, 56.1551, 272.803, 87.322, 269.117, 101.491)
    ..cubicTo(269.117, 101.491, 243.864, 130.354, 243.864, 130.354)
    ..cubicTo(243.82, 130.404, 243.784, 130.458, 243.756, 130.518)
    ..cubicTo(243.756, 130.518, 240.666, 137.112, 240.666, 137.112)
    ..cubicTo(240.666, 137.112, 212.331, 123.207, 212.331, 123.207)
    ..cubicTo(212.171, 120.7, 212.007, 118.357, 211.832, 116.267)
    ..cubicTo(211.824, 116.174, 211.798, 116.085, 211.756, 116.003)
    ..cubicTo(210, 112.595, 208.41, 109.684, 207.007, 107.113)
    ..cubicTo(200.269, 94.7726, 197.48, 89.6614, 198.657, 70.5849)
    ..cubicTo(198.662, 70.5027, 198.653, 70.4242, 198.631, 70.3456)
    ..cubicTo(198.631, 70.3456, 189.428, 38.1358, 189.428, 38.1358)
    ..cubicTo(189.428, 38.1358, 189.303, 36.4607, 189.303, 36.4607)
    ..cubicTo(188.76, 29.1851, 187.75, 15.6447, 187.458, 9.8978)
    ..cubicTo(187.453, 9.8014, 187.428, 9.705, 187.384, 9.6157)
    ..cubicTo(187.384, 9.6157, 182.773, 0.3935, 182.773, 0.3935)
    ..cubicTo(182.598, 0.0435, 182.175, -0.0994, 181.824, 0.0792)
    ..cubicTo(181.475, 0.2506, 181.334, 0.6757, 181.508, 1.0257)
    ..cubicTo(181.508, 1.0257, 186.054, 10.1157, 186.054, 10.1157)
    ..cubicTo(186.356, 15.9626, 187.355, 29.3458, 187.893, 36.5678)
    ..cubicTo(187.893, 36.5678, 188.023, 38.3144, 188.023, 38.3144)
    ..cubicTo(188.027, 38.3608, 188.036, 38.4073, 188.049, 38.4537)
    ..cubicTo(188.049, 38.4537, 197.238, 70.617, 197.238, 70.617)
    ..cubicTo(196.056, 90.0043, 198.904, 95.2226, 205.766, 107.791)
    ..cubicTo(207.148, 110.324, 208.712, 113.188, 210.434, 116.524)
    ..cubicTo(210.587, 118.353, 210.731, 120.385, 210.871, 122.543)
    ..cubicTo(210.87, 122.539, 210.868, 122.539, 210.867, 122.539)
    ..cubicTo(210.867, 122.539, 200.821, 121.553, 200.821, 121.553)
    ..cubicTo(193.417, 120.825, 191.317, 120.614, 190.618, 120.632)
    ..cubicTo(190.618, 120.632, 190.609, 120.567, 190.609, 120.567)
    ..cubicTo(182.521, 121.675, 167.254, 125.968, 159.911, 128.804)
    ..cubicTo(147.687, 129.833, 122.1, 130.004, 99.517, 130.158)
    ..cubicTo(83.101, 130.268, 67.5951, 130.372, 58.2594, 130.772)
    ..cubicTo(58.1776, 130.775, 58.0972, 130.793, 58.0215, 130.825)
    ..cubicTo(46.377, 135.601, 3.9424, 151.502, -6.183, 155.188)
    ..cubicTo(-6.55, 155.324, -6.739, 155.727, -6.6057, 156.095)
    ..cubicTo(-6.4723, 156.463, -6.0659, 156.653, -5.6998, 156.517)
    ..cubicTo(4.3994, 152.842, 46.6241, 137.015, 58.4433, 132.179)
    ..cubicTo(67.7662, 131.783, 83.1953, 131.679, 99.527, 131.572)
    ..cubicTo(123.305, 131.411, 147.893, 131.243, 160.131, 130.204)
    ..cubicTo(160.199, 130.2, 160.264, 130.186, 160.328, 130.161)
    ..cubicTo(167.538, 127.357, 182.667, 123.096, 190.719, 121.978)
    ..cubicTo(192.036, 122.107, 208.962, 123.771, 210.601, 123.936)
    ..cubicTo(210.601, 123.936, 210.972, 124.114, 210.972, 124.114)
    ..cubicTo(211.126, 126.582, 211.277, 129.193, 211.433, 131.879)
    ..cubicTo(211.745, 137.28, 212.082, 143.109, 212.51, 148.92)
    ..cubicTo(204.858, 149.334, 195.651, 150.277, 185.905, 151.277)
    ..cubicTo(162.376, 153.692, 135.707, 156.431, 118.037, 153.181)
    ..cubicTo(117.982, 153.17, 117.926, 153.17, 117.869, 153.17)
    ..cubicTo(117.396, 153.199, 106.272, 153.838, 104.595, 154.17)
    ..cubicTo(104.212, 154.249, 103.964, 154.62, 104.041, 155.002)
    ..cubicTo(104.117, 155.385, 104.488, 155.635, 104.872, 155.556)
    ..cubicTo(106.128, 155.306, 113.869, 154.817, 117.865, 154.588)
    ..cubicTo(123.733, 155.66, 130.556, 156.081, 137.91, 156.081)
    ..cubicTo(152.949, 156.081, 170.209, 154.31, 186.049, 152.684)
    ..cubicTo(195.79, 151.684, 204.992, 150.741, 212.615, 150.331)
    ..cubicTo(213.328, 159.674, 214.288, 168.893, 215.772, 176.165)
    ..cubicTo(215.772, 176.165, 185.172, 173.265, 185.172, 173.265)
    ..cubicTo(185.133, 173.261, 185.092, 173.261, 185.052, 173.265)
    ..cubicTo(184.921, 173.275, 171.881, 174.25, 169.953, 174.25)
    ..cubicTo(169.563, 174.25, 169.246, 174.568, 169.246, 174.958)
    ..cubicTo(169.246, 175.347, 169.563, 175.665, 169.953, 175.665)
    ..cubicTo(171.885, 175.665, 184.013, 174.761, 185.098, 174.679)
    ..cubicTo(185.098, 174.679, 216.08, 177.615, 216.08, 177.615)
    ..cubicTo(216.374, 178.937, 216.686, 180.183, 217.02, 181.347)
    ..cubicTo(218.59, 189.727, 218.219, 212.357, 218.04, 223.233)
    ..cubicTo(218.04, 223.233, 218.004, 225.526, 218.004, 225.526)
    ..cubicTo(218.004, 225.526, 214.789, 226.762, 214.789, 226.762)
    ..cubicTo(214.789, 226.762, 211.77, 220.122, 211.77, 220.122)
    ..cubicTo(211.608, 219.765, 211.187, 219.608, 210.835, 219.772)
    ..cubicTo(210.479, 219.933, 210.322, 220.351, 210.484, 220.704)
    ..cubicTo(210.484, 220.704, 213.778, 227.951, 213.778, 227.951)
    ..cubicTo(213.895, 228.212, 214.152, 228.365, 214.421, 228.365)
    ..cubicTo(214.506, 228.365, 214.592, 228.351, 214.675, 228.319)
    ..cubicTo(214.675, 228.319, 218.957, 226.672, 218.957, 226.672)
    ..cubicTo(219.226, 226.569, 219.405, 226.312, 219.41, 226.022)
    ..cubicTo(219.41, 226.022, 219.453, 223.258, 219.453, 223.258)
    ..cubicTo(219.633, 212.336, 220.006, 189.605, 218.394, 181.022)
    ..cubicTo(218.05, 179.826, 217.73, 178.533, 217.43, 177.169)
    ..cubicTo(217.43, 177.169, 242.764, 163.057, 242.764, 163.057)
    ..cubicTo(242.779, 163.049, 242.788, 163.035, 242.803, 163.025)
    ..cubicTo(242.803, 163.025, 244.975, 167.886, 244.975, 167.886)
    ..cubicTo(245.512, 169.086, 245.815, 169.764, 246.016, 170.154)
    ..cubicTo(246.016, 170.154, 246.009, 170.154, 246.009, 170.154)
    ..cubicTo(247.922, 179.704, 253.65, 190.37, 259.989, 200.435)
    ..cubicTo(259.989, 200.435, 249.563, 208.489, 249.563, 208.489)
    ..cubicTo(249.472, 208.56, 249.4, 208.653, 249.352, 208.757)
    ..cubicTo(242.907, 222.854, 241.674, 225.551, 241.439, 226.147)
    ..cubicTo(241.439, 226.147, 241.413, 226.14, 241.413, 226.14)
    ..cubicTo(241.321, 226.447, 241.011, 228.33, 240.148, 233.634)
    ..cubicTo(238.777, 242.059, 235.927, 259.575, 234.259, 266.972)
    ..cubicTo(234.259, 266.972, 167.916, 272.74, 167.916, 272.74)
    ..cubicTo(167.527, 272.776, 167.239, 273.119, 167.273, 273.505)
    ..cubicTo(167.305, 273.876, 167.614, 274.151, 167.976, 274.151)
    ..cubicTo(167.997, 274.151, 168.017, 274.151, 168.038, 274.151)
    ..cubicTo(168.038, 274.151, 233.914, 268.422, 233.914, 268.422)
    ..cubicTo(233.696, 269.279, 233.507, 269.89, 233.357, 270.187)
    ..cubicTo(233.293, 270.222, 233.234, 270.265, 233.182, 270.319)
    ..cubicTo(233.182, 270.319, 220.976, 282.977, 219.916, 284.077)
    ..cubicTo(195.988, 297.16, 169.494, 308.686, 141.479, 320.405)
    ..cubicTo(141.278, 320.187, 140.96, 320.105, 140.675, 320.234)
    ..cubicTo(140.403, 320.359, 140.25, 320.63, 140.264, 320.912)
    ..cubicTo(135.071, 323.084, 129.832, 325.259, 124.542, 327.456)
    ..cubicTo(120.045, 329.324, 115.532, 331.195, 111.015, 333.081)
    ..cubicTo(109.442, 329.306, 108.046, 325.923, 106.941, 323.245)
    ..cubicTo(106.941, 323.245, 105.716, 320.28, 105.716, 320.28)
    ..cubicTo(105.697, 320.234, 105.674, 320.191, 105.646, 320.148)
    ..cubicTo(105.646, 320.148, 104.737, 318.816, 104.737, 318.816)
    ..cubicTo(101.784, 314.465, 101.608, 314.205, 95.852, 311.036)
    ..cubicTo(95.802, 311.008, 95.7488, 310.986, 95.6938, 310.972)
    ..cubicTo(94.7366, 310.715, 92.9443, 310.194, 90.6756, 309.536)
    ..cubicTo(90.1698, 309.386, 89.638, 309.233, 89.0918, 309.076)
    ..cubicTo(89.0918, 309.076, 73.4234, 275.451, 73.4234, 275.451)
    ..cubicTo(73.3777, 275.355, 73.3095, 275.266, 73.2245, 275.198)
    ..cubicTo(73.2245, 275.198, 64.9895, 268.612, 64.9895, 268.612)
    ..cubicTo(64.9467, 268.576, 64.901, 268.547, 64.8517, 268.526)
    ..cubicTo(64.8517, 268.526, 59.213, 265.84, 59.213, 265.84)
    ..cubicTo(59.0926, 265.64, 58.8876, 265.501, 58.6383, 265.493)
    ..cubicTo(58.5955, 265.49, 58.5576, 265.504, 58.5165, 265.508)
    ..cubicTo(58.5165, 265.508, 44.2354, 258.707, 44.2354, 258.707)
    ..cubicTo(44.2354, 258.707, 40.4751, 254.321, 40.4751, 254.321)
    ..cubicTo(40.4751, 254.321, 38.906, 249.299, 38.906, 249.299)
    ..cubicTo(38.906, 249.299, 39.2325, 234.923, 39.2325, 234.923)
    ..cubicTo(39.2339, 234.866, 39.2282, 234.805, 39.2153, 234.752)
    ..cubicTo(39.2153, 234.752, 35.939, 220.333, 35.939, 220.333)
    ..cubicTo(35.939, 220.333, 35.939, 200.32, 35.939, 200.32)
    ..cubicTo(35.939, 199.931, 35.6225, 199.613, 35.2321, 199.613)
    ..cubicTo(34.8417, 199.613, 34.5253, 199.931, 34.5253, 200.32)
    ..cubicTo(34.5253, 200.32, 34.5253, 220.415, 34.5253, 220.415)
    ..cubicTo(34.5253, 220.465, 34.5314, 220.518, 34.5428, 220.572)
    ..cubicTo(34.5428, 220.572, 37.8173, 234.977, 37.8173, 234.977)
    ..cubicTo(37.8173, 234.977, 37.4902, 249.385, 37.4902, 249.385)
    ..cubicTo(37.488, 249.46, 37.4995, 249.539, 37.522, 249.61)
    ..cubicTo(37.522, 249.61, 39.1692, 254.882, 39.1692, 254.882)
    ..cubicTo(39.1978, 254.971, 39.2446, 255.057, 39.3071, 255.132)
    ..cubicTo(39.3071, 255.132, 43.2599, 259.743, 43.2599, 259.743)
    ..cubicTo(43.3239, 259.818, 43.4035, 259.879, 43.4924, 259.922)
    ..cubicTo(43.4924, 259.922, 57.8961, 266.779, 57.8961, 266.779)
    ..cubicTo(57.8961, 266.779, 56.9242, 302.411, 56.9242, 302.411)
    ..cubicTo(56.9185, 302.625, 57.0075, 302.825, 57.1668, 302.964)
    ..cubicTo(57.3257, 303.104, 57.5389, 303.164, 57.7472, 303.129)
    ..cubicTo(61.216, 302.55, 78.4399, 307.454, 88.3157, 310.322)
    ..cubicTo(88.37, 310.344, 88.4257, 310.361, 88.4843, 310.372)
    ..cubicTo(89.1154, 310.554, 89.7173, 310.729, 90.2805, 310.894)
    ..cubicTo(92.4943, 311.536, 94.2555, 312.047, 95.2448, 312.315)
    ..cubicTo(100.629, 315.28, 100.696, 315.38, 103.567, 319.609)
    ..cubicTo(103.567, 319.609, 104.438, 320.887, 104.438, 320.887)
    ..cubicTo(104.438, 320.887, 105.635, 323.784, 105.635, 323.784)
    ..cubicTo(106.788, 326.581, 108.176, 329.942, 109.71, 333.628)
    ..cubicTo(72.6902, 349.09, 35.4747, 365.323, 4.0933, 384.964)
    ..cubicTo(4.0933, 384.964, -1.7627, 370.998, -1.7627, 370.998)
    ..cubicTo(-1.7627, 370.998, 1.1761, 339.649, 1.1761, 339.649)
    ..cubicTo(1.1761, 339.649, 6.5774, 325.409, 6.5774, 325.409)
    ..cubicTo(6.6458, 325.23, 6.6355, 325.038, 6.5621, 324.873)
    ..cubicTo(6.1041, 321.323, 5.575, 254.982, 5.3197, 222.936)
    ..cubicTo(5.231, 211.825, 5.1713, 204.31, 5.1442, 202.785)
    ..cubicTo(5.1442, 202.785, 9.5133, 194.048, 9.5133, 194.048)
    ..cubicTo(9.688, 193.698, 9.5465, 193.277, 9.1972, 193.102)
    ..cubicTo(8.8471, 192.927, 8.4229, 193.066, 8.2488, 193.416)
    ..cubicTo(8.2488, 193.416, 3.8017, 202.31, 3.8017, 202.31)
    ..cubicTo(3.7499, 202.413, 3.7245, 202.528, 3.7277, 202.646)
    ..cubicTo(3.7521, 203.624, 3.8166, 211.728, 3.906, 222.947)
    ..cubicTo(4.0425, 240.049, 4.2483, 265.89, 4.4771, 287.07)
    ..cubicTo(4.6027, 298.693, 4.7228, 307.768, 4.8347, 314.04)
    ..cubicTo(4.9638, 321.302, 5.0121, 324.016, 5.1911, 325.08)
    ..cubicTo(5.1911, 325.08, -0.1796, 339.239, -0.1796, 339.239)
    ..cubicTo(-0.2019, 339.296, -0.2164, 339.36, -0.2224, 339.421)
    ..cubicTo(-0.2224, 339.421, -3.1867, 371.045, -3.1867, 371.045)
    ..cubicTo(-3.1973, 371.159, -3.1798, 371.277, -3.1349, 371.384)
    ..cubicTo(-3.1349, 371.384, 2.8818, 385.732, 2.8818, 385.732)
    ..cubicTo(-0.2513, 387.71, -3.3317, 389.721, -6.3398, 391.772)
    ..cubicTo(-6.6621, 391.993, -6.7453, 392.432, -6.5254, 392.754)
    ..cubicTo(-6.3888, 392.954, -6.1668, 393.064, -5.9408, 393.064)
    ..cubicTo(-5.8036, 393.064, -5.6651, 393.022, -5.5432, 392.939)
    ..cubicTo(-2.5841, 390.921, 0.4458, 388.943, 3.5275, 386.996)
    ..cubicTo(3.6476, 387.082, 3.7908, 387.132, 3.9406, 387.132)
    ..cubicTo(4.0317, 387.132, 4.1242, 387.118, 4.2135, 387.078)
    ..cubicTo(4.5248, 386.95, 4.6795, 386.621, 4.622, 386.303)
    ..cubicTo(35.9583, 366.655, 73.2009, 350.407, 110.254, 334.931)
    ..cubicTo(116.874, 350.804, 125.922, 371.916, 130.819, 379.888)
    ..cubicTo(133.446, 384.014, 136.364, 388.386, 139.453, 393.011)
    ..cubicTo(145.581, 402.19, 152.35, 412.337, 157.587, 421.817)
    ..cubicTo(157.587, 421.817, 126.046, 452.394, 126.046, 452.394)
    ..cubicTo(126.046, 452.394, 114.028, 459.216, 114.028, 459.216)
    ..cubicTo(114.028, 459.216, 113.856, 459.256, 113.856, 459.256)
    ..cubicTo(109.15, 460.327, 96.6489, 463.174, 92.8732, 465.185)
    ..cubicTo(92.8732, 465.185, 92.9014, 465.238, 92.9014, 465.238)
    ..cubicTo(91.8831, 465.835, 87.022, 469.042, 60.8646, 486.301)
    ..cubicTo(60.5388, 486.515, 60.4492, 486.954, 60.6642, 487.279)
    ..cubicTo(60.7999, 487.486, 61.0253, 487.597, 61.2549, 487.597)
    ..cubicTo(61.3882, 487.597, 61.5235, 487.561, 61.6432, 487.479)
    ..cubicTo(61.6432, 487.479, 93.4679, 466.481, 93.5379, 466.435)
    ..cubicTo(97.1468, 464.51, 109.96, 461.591, 114.17, 460.631)
    ..cubicTo(114.17, 460.631, 114.443, 460.57, 114.443, 460.57)
    ..cubicTo(114.511, 460.556, 114.575, 460.531, 114.635, 460.495)
    ..cubicTo(114.635, 460.495, 126.823, 453.58, 126.823, 453.58)
    ..cubicTo(126.875, 453.548, 126.923, 453.512, 126.966, 453.469)
    ..cubicTo(126.966, 453.469, 158.291, 423.103, 158.291, 423.103)
    ..cubicTo(159.403, 425.16, 160.442, 427.182, 161.374, 429.15)
    ..cubicTo(161.512, 429.764, 162.454, 434.004, 162.642, 434.854)
    ..cubicTo(162.418, 435.936, 162.141, 437.257, 161.823, 438.761)
    ..cubicTo(159.23, 451.08, 154.401, 474.007, 154.754, 482.311)
    ..cubicTo(154.756, 482.347, 154.76, 482.382, 154.768, 482.418)
    ..cubicTo(160.131, 509.095, 177.165, 542.08, 193.638, 573.979)
    ..cubicTo(203.138, 592.373, 212.11, 609.75, 218.047, 624.512)
    ..cubicTo(218.158, 624.787, 218.423, 624.955, 218.703, 624.955)
    ..cubicTo(218.791, 624.955, 218.88, 624.937, 218.967, 624.905)
    ..cubicTo(219.329, 624.758, 219.504, 624.347, 219.359, 623.983)
    ..cubicTo(213.397, 609.161, 204.409, 591.756, 194.894, 573.329)
    ..cubicTo(178.477, 541.541, 161.501, 508.667, 156.165, 482.193)
    ..cubicTo(155.844, 474.017, 160.815, 450.412, 163.207, 439.05)
    ..cubicTo(163.539, 437.475, 163.829, 436.1, 164.058, 434.989)
    ..cubicTo(164.078, 434.893, 164.077, 434.793, 164.055, 434.693)
    ..cubicTo(164.055, 434.693, 163.397, 431.728, 163.397, 431.728)
    ..cubicTo(162.981, 429.86, 162.796, 429.028, 162.645, 428.635)
    ..cubicTo(162.645, 428.635, 162.686, 428.617, 162.686, 428.617)
    ..cubicTo(161.686, 426.503, 160.569, 424.328, 159.368, 422.117)
    ..cubicTo(159.368, 422.117, 185.54, 405.405, 185.54, 405.405)
    ..cubicTo(196.235, 419.384, 207.545, 432.578, 215.209, 441.243)
    ..cubicTo(215.242, 441.283, 215.278, 441.315, 215.317, 441.343)
    ..cubicTo(215.317, 441.343, 225.529, 448.919, 225.529, 448.919)
    ..cubicTo(225.603, 448.976, 225.686, 449.015, 225.775, 449.037)
    ..cubicTo(225.775, 449.037, 239.949, 452.648, 239.949, 452.648)
    ..cubicTo(241.637, 453.08, 242.395, 453.273, 242.783, 453.302)
    ..cubicTo(242.783, 453.302, 242.785, 453.341, 242.785, 453.341)
    ..cubicTo(262.07, 452.334, 277.178, 437.325, 291.788, 422.81)
    ..cubicTo(298.048, 416.591, 303.961, 410.72, 310.043, 406.094)
    ..cubicTo(310.353, 405.858, 310.414, 405.416, 310.178, 405.105)
    ..cubicTo(309.941, 404.794, 309.498, 404.733, 309.187, 404.969)
    ..cubicTo(303.031, 409.652, 297.086, 415.556, 290.792, 421.806)
    ..cubicTo(276.397, 436.107, 261.514, 450.891, 242.818, 451.923)
    ..cubicTo(241.495, 451.584, 227.77, 448.087, 226.259, 447.701)
    ..cubicTo(226.259, 447.701, 216.219, 440.254, 216.219, 440.254)
    ..cubicTo(208.575, 431.607, 197.321, 418.477, 186.689, 404.583)
    ..cubicTo(186.828, 404.362, 186.84, 404.069, 186.689, 403.833)
    ..cubicTo(186.515, 403.562, 186.19, 403.462, 185.895, 403.547)
    ..cubicTo(183.197, 400.001, 180.549, 396.411, 178.014, 392.839)
    ..cubicTo(204.838, 373.927, 270.248, 329.492, 298.806, 310.597)
    ..cubicTo(299.131, 310.383, 299.221, 309.944, 299.005, 309.618)
    ..cubicTo(298.789, 309.293, 298.351, 309.201, 298.026, 309.418)
    ..cubicTo(269.46, 328.316, 204.03, 372.77, 177.198, 391.686)
    ..cubicTo(173.003, 385.717, 169.155, 379.817, 165.985, 374.274)
    ..cubicTo(165.888, 374.063, 145.555, 329.274, 142.105, 321.673)
    ..cubicTo(170.163, 309.936, 196.7, 298.393, 220.689, 285.263)
    ..cubicTo(220.689, 285.263, 220.672, 285.234, 220.672, 285.234)
    ..cubicTo(220.974, 285.016, 221.534, 284.434, 222.943, 282.973)
    ..cubicTo(222.943, 282.973, 234.047, 271.458, 234.047, 271.458)
    ..cubicTo(234.056, 271.455, 234.065, 271.451, 234.074, 271.448)
    ..cubicTo(234.423, 271.276, 234.809, 270.512, 235.373, 268.294)
    ..cubicTo(235.373, 268.294, 274.102, 264.926, 274.102, 264.926)
    ..cubicTo(274.491, 264.893, 274.779, 264.551, 274.745, 264.161)
    ..cubicTo(274.711, 263.772, 274.368, 263.479, 273.98, 263.518)
    ..cubicTo(273.98, 263.518, 235.719, 266.847, 235.719, 266.847)
    ..cubicTo(236.814, 262.032, 238.515, 252.475, 241.543, 233.859)
    ..cubicTo(242.136, 230.216, 242.651, 227.051, 242.759, 226.58)
    ..cubicTo(243.22, 225.569, 249.8, 211.178, 250.565, 209.503)
    ..cubicTo(250.565, 209.503, 260.749, 201.631, 260.749, 201.631)
    ..cubicTo(263.707, 206.274, 266.77, 210.771, 269.617, 214.95)
    ..cubicTo(271.77, 218.111, 273.806, 221.101, 275.608, 223.869)
    ..cubicTo(275.608, 223.869, 274.33, 232.498, 274.33, 232.498)
    ..cubicTo(274.302, 232.687, 274.352, 232.88, 274.469, 233.03)
    ..cubicTo(274.585, 233.184, 274.759, 233.28, 274.95, 233.305)
    ..cubicTo(274.95, 233.305, 302.856, 236.463, 302.856, 236.463)
    ..cubicTo(303.155, 238.395, 303.315, 240.841, 303.566, 244.713)
    ..cubicTo(303.566, 244.713, 303.639, 245.824, 303.639, 245.824)
    ..cubicTo(303.641, 245.863, 303.648, 245.906, 303.657, 245.945)
    ..cubicTo(303.697, 246.11, 307.28, 261.093, 307.28, 261.093)
    ..cubicTo(307.291, 261.136, 307.305, 261.179, 307.324, 261.218)
    ..cubicTo(307.324, 261.218, 311.838, 271.215, 311.838, 271.215)
    ..cubicTo(311.838, 271.215, 311.231, 273.951, 311.231, 273.951)
    ..cubicTo(311.214, 274.023, 311.212, 274.098, 311.219, 274.173)
    ..cubicTo(301.995, 281.673, 292.443, 290.035, 287.066, 294.996)
    ..cubicTo(286.78, 295.26, 286.762, 295.707, 287.026, 295.996)
    ..cubicTo(287.166, 296.146, 287.355, 296.221, 287.546, 296.221)
    ..cubicTo(287.717, 296.221, 287.889, 296.16, 288.025, 296.035)
    ..cubicTo(293.331, 291.138, 302.713, 282.923, 311.809, 275.512)
    ..cubicTo(314.674, 281.52, 314.987, 282.088, 320.674, 287.149)
    ..cubicTo(320.674, 287.149, 320.697, 287.124, 320.697, 287.124)
    ..cubicTo(321.089, 287.338, 322.008, 287.581, 324.093, 288.127)
    ..cubicTo(324.093, 288.127, 327.222, 288.953, 327.222, 288.953)
    ..cubicTo(327.281, 288.967, 327.341, 288.974, 327.402, 288.974)
    ..cubicTo(327.478, 288.974, 327.553, 288.963, 327.626, 288.938)
    ..cubicTo(327.626, 288.938, 335.406, 286.345, 335.406, 286.345)
    ..cubicTo(335.406, 286.345, 340.743, 286.606, 340.743, 286.606)
    ..cubicTo(340.743, 286.606, 329.357, 326.945, 329.357, 326.945)
    ..cubicTo(329.341, 327.002, 329.332, 327.063, 329.331, 327.123)
    ..cubicTo(329.331, 327.123, 328.805, 357.344, 328.805, 357.344)
    ..cubicTo(305.683, 357.054, 283.631, 355.383, 269.952, 351.49)
    ..cubicTo(269.575, 351.383, 269.186, 351.6, 269.079, 351.975)
    ..cubicTo(268.972, 352.351, 269.189, 352.743, 269.565, 352.851)
    ..cubicTo(284.055, 356.976, 306.228, 358.572, 328.779, 358.815)
    ..cubicTo(328.779, 358.815, 328.013, 402.883, 328.013, 402.883)
    ..cubicTo(328.006, 403.276, 328.317, 403.597, 328.707, 403.601)
    ..cubicTo(328.712, 403.601, 328.716, 403.601, 328.72, 403.601)
    ..cubicTo(329.104, 403.601, 329.419, 403.294, 329.427, 402.908)
    ..cubicTo(329.427, 402.908, 330.193, 358.83, 330.193, 358.83)
    ..cubicTo(331.813, 358.844, 333.438, 358.851, 335.06, 358.851)
    ..cubicTo(345.754, 358.851, 356.38, 358.569, 366.162, 358.13)
    ..cubicTo(365.927, 360.783, 365.973, 362.473, 366.352, 363.123)
    ..cubicTo(370.491, 368.93, 376.124, 376.545, 382.65, 385.36)
    ..cubicTo(387.757, 392.264, 393.425, 399.929, 399.369, 408.066)
    ..cubicTo(388.396, 409.659, 377.267, 411.034, 366.28, 412.387)
    ..cubicTo(354.929, 413.788, 344.204, 415.109, 333.921, 416.638)
    ..cubicTo(333.921, 416.638, 328.575, 410.977, 328.575, 410.977)
    ..cubicTo(328.306, 410.691, 327.858, 410.68, 327.576, 410.948)
    ..cubicTo(327.291, 411.216, 327.279, 411.662, 327.547, 411.945)
    ..cubicTo(327.547, 411.945, 333.146, 417.874, 333.146, 417.874)
    ..cubicTo(333.281, 418.017, 333.467, 418.095, 333.66, 418.095)
    ..cubicTo(333.696, 418.095, 333.731, 418.095, 333.763, 418.088)
    ..cubicTo(338.11, 417.441, 342.543, 416.831, 347.064, 416.234)
    ..cubicTo(347.064, 416.234, 335.914, 423.381, 335.914, 423.381)
    ..cubicTo(335.585, 423.592, 335.492, 424.031, 335.699, 424.36)
    ..cubicTo(335.835, 424.571, 336.064, 424.685, 336.296, 424.685)
    ..cubicTo(336.428, 424.685, 336.56, 424.649, 336.678, 424.571)
    ..cubicTo(336.678, 424.571, 349.525, 416.338, 349.525, 416.338)
    ..cubicTo(349.693, 416.227, 349.797, 416.056, 349.833, 415.874)
    ..cubicTo(355.229, 415.173, 360.762, 414.491, 366.452, 413.791)
    ..cubicTo(377.692, 412.405, 389.086, 410.995, 400.312, 409.355)
    ..cubicTo(426.539, 445.308, 457.738, 490.076, 469.557, 519.457)
    ..cubicTo(469.557, 519.457, 469.442, 519.5, 469.442, 519.5)
    ..cubicTo(469.078, 519.643, 468.899, 520.053, 469.042, 520.418)
    ..cubicTo(469.149, 520.696, 469.417, 520.868, 469.699, 520.868)
    ..cubicTo(469.785, 520.868, 469.871, 520.85, 469.957, 520.818)
    ..cubicTo(469.957, 520.818, 470.074, 520.771, 470.074, 520.771)
    ..cubicTo(471.682, 524.914, 472.892, 528.74, 473.618, 532.165)
    ..cubicTo(473.643, 532.286, 473.7, 532.394, 473.778, 532.483)
    ..cubicTo(473.943, 532.676, 479.372, 539.062, 479.372, 539.062)
    ..cubicTo(479.443, 539.148, 479.536, 539.216, 479.639, 539.258)
    ..cubicTo(488.137, 542.787, 505.688, 550.631, 514.032, 554.97)
    ..cubicTo(514.032, 554.97, 520.764, 563.625, 520.764, 563.625)
    ..cubicTo(520.764, 563.625, 523.675, 575.265, 523.675, 575.265)
    ..cubicTo(523.675, 575.265, 523.982, 584.559, 523.982, 584.559)
    ..cubicTo(518.396, 586.477, 512.874, 588.037, 507.52, 588.955)
    ..cubicTo(492.891, 588.87, 458.859, 589.123, 440.976, 589.288)
    ..cubicTo(430.157, 590.284, 407.044, 597.517, 395.018, 601.842)
    ..cubicTo(394.986, 601.853, 394.954, 601.867, 394.922, 601.885)
    ..cubicTo(394.922, 601.885, 367.409, 616.615, 367.409, 616.615)
    ..cubicTo(364.294, 618.283, 362.973, 618.99, 362.401, 619.358)
    ..cubicTo(362.401, 619.358, 362.384, 619.311, 362.384, 619.311)
    ..cubicTo(348.65, 624.855, 320.718, 638.013, 306.63, 646.031)
    ..cubicTo(306.564, 646.071, 306.504, 646.117, 306.453, 646.174)
    ..cubicTo(306.453, 646.174, 295.582, 658.361, 295.582, 658.361)
    ..cubicTo(295.487, 658.468, 295.426, 658.604, 295.409, 658.747)
    ..cubicTo(295.409, 658.747, 293.432, 674.555, 293.432, 674.555)
    ..cubicTo(293.384, 674.944, 293.659, 675.298, 294.046, 675.344)
    ..cubicTo(294.076, 675.348, 294.105, 675.352, 294.135, 675.352)
    ..cubicTo(294.486, 675.352, 294.79, 675.091, 294.835, 674.73)
    ..cubicTo(294.835, 674.73, 296.784, 659.14, 296.784, 659.14)
    ..cubicTo(296.784, 659.14, 307.43, 647.203, 307.43, 647.203)
    ..cubicTo(321.505, 639.202, 349.25, 626.137, 362.912, 620.622)
    ..cubicTo(362.937, 620.611, 362.962, 620.601, 362.984, 620.586)
    ..cubicTo(363.198, 620.472, 394.154, 603.899, 395.543, 603.153)
    ..cubicTo(407.519, 598.853, 430.432, 591.681, 441.047, 590.698)
    ..cubicTo(458.895, 590.534, 492.994, 590.284, 507.574, 590.37)
    ..cubicTo(507.62, 590.37, 507.656, 590.366, 507.699, 590.359)
    ..cubicTo(512.881, 589.473, 518.203, 588.002, 523.582, 586.191)
    ..cubicTo(523.582, 586.191, 522.389, 589.766, 522.389, 589.766)
    ..cubicTo(522.268, 590.138, 522.468, 590.538, 522.836, 590.663)
    ..cubicTo(522.911, 590.688, 522.986, 590.698, 523.061, 590.698)
    ..cubicTo(523.357, 590.698, 523.632, 590.509, 523.732, 590.213)
    ..cubicTo(523.732, 590.213, 525.265, 585.612, 525.265, 585.612)
    ..cubicTo(533.208, 582.841, 541.255, 579.38, 549.152, 575.979)
    ..cubicTo(560.996, 570.879, 573.229, 565.618, 584.591, 562.96)
    ..cubicTo(584.591, 562.96, 584.28, 580.426, 584.28, 580.426)
    ..cubicTo(584.277, 580.555, 584.312, 580.683, 584.376, 580.798)
    ..cubicTo(584.376, 580.798, 591.884, 593.531, 591.884, 593.531)
    ..cubicTo(591.884, 593.531, 592.524, 597.352, 592.524, 597.352)
    ..cubicTo(592.581, 597.699, 592.881, 597.945, 593.22, 597.945)
    ..cubicTo(593.259, 597.945, 593.299, 597.942, 593.338, 597.935)
    ..cubicTo(593.72, 597.87, 593.981, 597.506, 593.917, 597.12)
    ..cubicTo(593.917, 597.12, 593.259, 593.17, 593.259, 593.17)
    ..cubicTo(593.245, 593.081, 593.213, 592.999, 593.17, 592.927)
    ..cubicTo(593.17, 592.927, 585.694, 580.251, 585.694, 580.251)
    ..cubicTo(585.694, 580.251, 586.009, 562.689, 586.009, 562.689)
    ..cubicTo(586.009, 562.689, 597.435, 562.371, 597.435, 562.371)
    ..cubicTo(597.435, 562.371, 614.804, 566.307, 614.804, 566.307)
    ..cubicTo(615.183, 566.389, 615.565, 566.153, 615.65, 565.771)
    ..cubicTo(615.736, 565.393, 615.497, 565.014, 615.115, 564.925)
    ..cubicTo(615.115, 564.925, 615.115, 564.925, 615.115, 564.925)
    ..close();

  static final Path __path37_1_19 = Path()
    ..moveTo(145.47, 167.706)
    ..cubicTo(145.47, 167.706, 137.894, 170.342, 137.894, 170.342)
    ..cubicTo(137.709, 170.406, 137.612, 170.606, 137.676, 170.792)
    ..cubicTo(137.727, 170.934, 137.863, 171.027, 138.01, 171.027)
    ..cubicTo(138.048, 171.027, 138.087, 171.02, 138.126, 171.009)
    ..cubicTo(138.126, 171.009, 145.651, 168.391, 145.651, 168.391)
    ..cubicTo(145.651, 168.391, 167.336, 167.734, 167.336, 167.734)
    ..cubicTo(167.531, 167.727, 167.685, 167.566, 167.679, 167.37)
    ..cubicTo(167.673, 167.173, 167.507, 167.038, 167.315, 167.027)
    ..cubicTo(167.315, 167.027, 145.575, 167.684, 145.575, 167.684)
    ..cubicTo(145.539, 167.688, 145.503, 167.695, 145.47, 167.706)
    ..cubicTo(145.47, 167.706, 145.47, 167.706, 145.47, 167.706)
    ..close();

  static final Path __path37_1_20 = Path()
    ..moveTo(253.163, 204.963)
    ..cubicTo(253.163, 204.963, 241.905, 197.688, 241.905, 197.688)
    ..cubicTo(241.905, 197.688, 231.364, 193.405, 231.364, 193.405)
    ..cubicTo(231.327, 193.391, 231.289, 193.38, 231.249, 193.38)
    ..cubicTo(231.249, 193.38, 218.403, 192.719, 218.403, 192.719)
    ..cubicTo(218.216, 192.709, 218.042, 192.862, 218.032, 193.055)
    ..cubicTo(218.022, 193.252, 218.172, 193.416, 218.367, 193.427)
    ..cubicTo(218.367, 193.427, 231.153, 194.084, 231.153, 194.084)
    ..cubicTo(231.153, 194.084, 241.58, 198.313, 241.58, 198.313)
    ..cubicTo(241.58, 198.313, 252.779, 205.56, 252.779, 205.56)
    ..cubicTo(252.838, 205.595, 252.905, 205.613, 252.971, 205.613)
    ..cubicTo(253.087, 205.613, 253.2, 205.556, 253.268, 205.453)
    ..cubicTo(253.374, 205.288, 253.327, 205.07, 253.163, 204.963)
    ..cubicTo(253.163, 204.963, 253.163, 204.963, 253.163, 204.963)
    ..close();

  static final Path __path37_1_21 = Path()
    ..moveTo(169.967, 207.083)
    ..cubicTo(169.967, 207.083, 173.471, 204.215, 173.471, 204.215)
    ..cubicTo(173.622, 204.093, 173.645, 203.868, 173.521, 203.718)
    ..cubicTo(173.397, 203.568, 173.174, 203.543, 173.024, 203.668)
    ..cubicTo(173.024, 203.668, 169.401, 206.633, 169.401, 206.633)
    ..cubicTo(169.325, 206.693, 169.278, 206.786, 169.272, 206.883)
    ..cubicTo(169.272, 206.883, 168.952, 211.676, 168.952, 211.676)
    ..cubicTo(168.952, 211.676, 144.052, 202.622, 144.052, 202.622)
    ..cubicTo(143.868, 202.554, 143.666, 202.65, 143.6, 202.832)
    ..cubicTo(143.533, 203.014, 143.628, 203.218, 143.811, 203.286)
    ..cubicTo(143.811, 203.286, 168.715, 212.34, 168.715, 212.34)
    ..cubicTo(168.715, 212.34, 165.393, 216.569, 165.393, 216.569)
    ..cubicTo(165.273, 216.723, 165.3, 216.944, 165.453, 217.066)
    ..cubicTo(165.518, 217.116, 165.595, 217.141, 165.671, 217.141)
    ..cubicTo(165.776, 217.141, 165.88, 217.094, 165.95, 217.005)
    ..cubicTo(165.95, 217.005, 169.572, 212.394, 169.572, 212.394)
    ..cubicTo(169.642, 212.305, 169.666, 212.187, 169.634, 212.079)
    ..cubicTo(169.628, 212.058, 169.611, 212.04, 169.6, 212.019)
    ..cubicTo(169.625, 211.972, 169.644, 211.926, 169.647, 211.869)
    ..cubicTo(169.647, 211.869, 169.967, 207.083, 169.967, 207.083)
    ..cubicTo(169.967, 207.083, 169.967, 207.083, 169.967, 207.083)
    ..close();

  static final Path __path37_1_22 = Path()
    ..moveTo(106.663, 193.852)
    ..cubicTo(106.548, 193.691, 106.328, 193.659, 106.169, 193.774)
    ..cubicTo(106.011, 193.888, 105.976, 194.109, 106.091, 194.266)
    ..cubicTo(106.091, 194.266, 108.67, 197.813, 108.67, 197.813)
    ..cubicTo(108.67, 197.813, 110.307, 214.514, 110.307, 214.514)
    ..cubicTo(110.325, 214.7, 110.479, 214.836, 110.659, 214.836)
    ..cubicTo(110.67, 214.836, 110.682, 214.832, 110.693, 214.832)
    ..cubicTo(110.888, 214.814, 111.029, 214.639, 111.011, 214.447)
    ..cubicTo(111.011, 214.447, 109.364, 197.649, 109.364, 197.649)
    ..cubicTo(109.358, 197.585, 109.335, 197.524, 109.298, 197.474)
    ..cubicTo(109.298, 197.474, 106.663, 193.852, 106.663, 193.852)
    ..cubicTo(106.663, 193.852, 106.663, 193.852, 106.663, 193.852)
    ..close();

  static final Path __path37_1_23 = Path()
    ..moveTo(48.6977, 201.664)
    ..cubicTo(48.7138, 201.664, 48.7291, 201.667, 48.7445, 201.667)
    ..cubicTo(48.9188, 201.667, 49.0709, 201.535, 49.0941, 201.36)
    ..cubicTo(49.0941, 201.36, 50.7143, 189.048, 50.7143, 189.048)
    ..cubicTo(51.5136, 188.727, 52.9102, 188.116, 54.6314, 187.341)
    ..cubicTo(54.6314, 187.341, 54.3192, 202.624, 54.3192, 202.624)
    ..cubicTo(54.3156, 202.817, 54.4707, 202.978, 54.6657, 202.985)
    ..cubicTo(54.6682, 202.985, 54.6703, 202.985, 54.6728, 202.985)
    ..cubicTo(54.8646, 202.985, 55.0221, 202.832, 55.0261, 202.639)
    ..cubicTo(55.0261, 202.639, 55.3454, 187.02, 55.3454, 187.02)
    ..cubicTo(57.6756, 185.966, 60.4886, 184.673, 63.2131, 183.416)
    ..cubicTo(63.2131, 183.416, 63.2131, 195.32, 63.2131, 195.32)
    ..cubicTo(63.2131, 195.32, 60.2711, 203.164, 60.2711, 203.164)
    ..cubicTo(60.2029, 203.349, 60.2954, 203.553, 60.4779, 203.621)
    ..cubicTo(60.519, 203.635, 60.5608, 203.642, 60.6022, 203.642)
    ..cubicTo(60.7451, 203.642, 60.8801, 203.557, 60.9333, 203.414)
    ..cubicTo(60.9333, 203.414, 63.8975, 195.51, 63.8975, 195.51)
    ..cubicTo(63.9121, 195.467, 63.9196, 195.427, 63.9196, 195.385)
    ..cubicTo(63.9196, 195.385, 63.9196, 183.087, 63.9196, 183.087)
    ..cubicTo(65.8194, 182.208, 67.6496, 181.358, 69.2097, 180.633)
    ..cubicTo(70.8038, 179.894, 72.0924, 179.294, 72.8457, 178.948)
    ..cubicTo(72.8457, 178.948, 83.2862, 180.255, 83.2862, 180.255)
    ..cubicTo(83.3133, 180.255, 83.3405, 180.258, 83.3669, 180.255)
    ..cubicTo(83.3669, 180.255, 89.276, 179.633, 89.276, 179.633)
    ..cubicTo(89.276, 179.633, 89.8957, 185.212, 89.8957, 185.212)
    ..cubicTo(89.9078, 185.319, 89.9682, 185.416, 90.0592, 185.473)
    ..cubicTo(90.1507, 185.53, 90.2632, 185.541, 90.365, 185.505)
    ..cubicTo(90.365, 185.505, 100.453, 181.926, 100.453, 181.926)
    ..cubicTo(100.453, 181.926, 107.853, 184.805, 107.853, 184.805)
    ..cubicTo(107.853, 184.805, 100.893, 190.498, 100.893, 190.498)
    ..cubicTo(100.871, 190.516, 100.851, 190.538, 100.834, 190.559)
    ..cubicTo(100.834, 190.559, 97.9113, 194.456, 97.9113, 194.456)
    ..cubicTo(97.9113, 194.456, 89.736, 199.363, 89.736, 199.363)
    ..cubicTo(89.6589, 199.41, 89.6024, 199.481, 89.5778, 199.571)
    ..cubicTo(89.5163, 199.785, 89.161, 200.367, 88.7845, 200.981)
    ..cubicTo(87.4151, 203.217, 85.1231, 206.964, 87.0622, 208.507)
    ..cubicTo(87.1276, 208.557, 87.2051, 208.582, 87.2822, 208.582)
    ..cubicTo(87.3865, 208.582, 87.4894, 208.539, 87.559, 208.45)
    ..cubicTo(87.6805, 208.296, 87.6551, 208.075, 87.5026, 207.953)
    ..cubicTo(86.0521, 206.8, 88.222, 203.253, 89.3874, 201.349)
    ..cubicTo(89.8142, 200.653, 90.086, 200.203, 90.2082, 199.903)
    ..cubicTo(90.2082, 199.903, 98.3346, 195.027, 98.3346, 195.027)
    ..cubicTo(98.3735, 195.006, 98.4078, 194.974, 98.4353, 194.938)
    ..cubicTo(98.4353, 194.938, 101.374, 191.02, 101.374, 191.02)
    ..cubicTo(101.374, 191.02, 108.587, 185.116, 108.587, 185.116)
    ..cubicTo(108.594, 185.112, 108.597, 185.102, 108.604, 185.098)
    ..cubicTo(108.604, 185.098, 112.188, 186.491, 112.188, 186.491)
    ..cubicTo(112.369, 186.562, 112.575, 186.47, 112.645, 186.287)
    ..cubicTo(112.716, 186.105, 112.626, 185.902, 112.444, 185.83)
    ..cubicTo(112.444, 185.83, 108.938, 184.469, 108.938, 184.469)
    ..cubicTo(108.938, 184.469, 113.952, 174.129, 113.952, 174.129)
    ..cubicTo(114.037, 173.951, 113.964, 173.74, 113.788, 173.654)
    ..cubicTo(113.612, 173.572, 113.401, 173.644, 113.316, 173.819)
    ..cubicTo(113.316, 173.819, 108.277, 184.212, 108.277, 184.212)
    ..cubicTo(108.277, 184.212, 100.587, 181.219, 100.587, 181.219)
    ..cubicTo(100.507, 181.187, 100.419, 181.187, 100.34, 181.216)
    ..cubicTo(100.34, 181.216, 90.5493, 184.691, 90.5493, 184.691)
    ..cubicTo(90.5493, 184.691, 89.9396, 179.205, 89.9396, 179.205)
    ..cubicTo(89.9232, 179.055, 89.8092, 178.937, 89.671, 178.901)
    ..cubicTo(89.671, 178.901, 92.5537, 178.64, 92.5537, 178.64)
    ..cubicTo(92.5537, 178.64, 92.8591, 183.219, 92.8591, 183.219)
    ..cubicTo(92.8713, 183.405, 93.027, 183.551, 93.2116, 183.551)
    ..cubicTo(93.2195, 183.551, 93.2274, 183.548, 93.2352, 183.548)
    ..cubicTo(93.4299, 183.537, 93.5774, 183.366, 93.5645, 183.173)
    ..cubicTo(93.5645, 183.173, 93.2349, 178.233, 93.2349, 178.233)
    ..cubicTo(93.2284, 178.137, 93.1841, 178.047, 93.1116, 177.987)
    ..cubicTo(93.0391, 177.926, 92.9448, 177.894, 92.8502, 177.905)
    ..cubicTo(92.8502, 177.905, 89.227, 178.233, 89.227, 178.233)
    ..cubicTo(89.0327, 178.251, 88.8895, 178.422, 88.907, 178.615)
    ..cubicTo(88.922, 178.78, 89.0463, 178.905, 89.2038, 178.93)
    ..cubicTo(89.2038, 178.93, 83.3333, 179.548, 83.3333, 179.548)
    ..cubicTo(83.3333, 179.548, 72.8332, 178.233, 72.8332, 178.233)
    ..cubicTo(72.7679, 178.226, 72.7014, 178.237, 72.6421, 178.262)
    ..cubicTo(71.9035, 178.601, 70.5734, 179.219, 68.9122, 179.99)
    ..cubicTo(67.4338, 180.68, 65.7123, 181.48, 63.9196, 182.308)
    ..cubicTo(63.9196, 182.308, 63.9196, 182.208, 63.9196, 182.208)
    ..cubicTo(63.9196, 182.012, 63.7618, 181.855, 63.5664, 181.855)
    ..cubicTo(63.371, 181.855, 63.2131, 182.012, 63.2131, 182.208)
    ..cubicTo(63.2131, 182.208, 63.2131, 182.637, 63.2131, 182.637)
    ..cubicTo(60.4833, 183.898, 57.6441, 185.205, 55.2768, 186.277)
    ..cubicTo(55.2136, 186.195, 55.12, 186.137, 55.0096, 186.137)
    ..cubicTo(54.8339, 186.141, 54.6535, 186.287, 54.6489, 186.484)
    ..cubicTo(54.6489, 186.484, 54.6475, 186.559, 54.6475, 186.559)
    ..cubicTo(52.6448, 187.462, 51.0486, 188.163, 50.2632, 188.466)
    ..cubicTo(50.1428, 188.513, 50.0574, 188.623, 50.0407, 188.748)
    ..cubicTo(50.0407, 188.748, 48.3937, 201.267, 48.3937, 201.267)
    ..cubicTo(48.368, 201.46, 48.5045, 201.639, 48.6977, 201.664)
    ..cubicTo(48.6977, 201.664, 48.6977, 201.664, 48.6977, 201.664)
    ..close();

  static final Path __path37_1_24 = Path()
    ..moveTo(5.5958, 219.394)
    ..cubicTo(5.3836, 219.397, 5.239, 219.544, 5.2345, 219.74)
    ..cubicTo(5.2303, 219.937, 5.385, 220.097, 5.5799, 220.101)
    ..cubicTo(5.5799, 220.101, 34.8956, 220.762, 34.8956, 220.762)
    ..cubicTo(34.8985, 220.762, 34.901, 220.762, 34.9035, 220.762)
    ..cubicTo(35.0949, 220.762, 35.2525, 220.608, 35.2567, 220.415)
    ..cubicTo(35.261, 220.219, 35.1067, 220.058, 34.9117, 220.054)
    ..cubicTo(34.9117, 220.054, 5.5958, 219.394, 5.5958, 219.394)
    ..cubicTo(5.5958, 219.394, 5.5958, 219.394, 5.5958, 219.394)
    ..close();

  static final Path __path37_1_25 = Path()
    ..moveTo(1.0623, 247.019)
    ..cubicTo(1.0623, 247.019, 1.0625, 247.019, 1.0625, 247.019)
    ..cubicTo(1.9685, 247.944, 9.8202, 248.427, 31.4484, 248.894)
    ..cubicTo(35.0919, 248.977, 37.9692, 249.037, 38.4932, 249.098)
    ..cubicTo(38.5068, 249.102, 38.5204, 249.102, 38.5336, 249.102)
    ..cubicTo(38.7111, 249.102, 38.864, 248.966, 38.8843, 248.787)
    ..cubicTo(38.9068, 248.594, 38.7675, 248.419, 38.5732, 248.394)
    ..cubicTo(38.0171, 248.334, 35.2683, 248.273, 31.4641, 248.191)
    ..cubicTo(22.1451, 247.987, 2.7551, 247.562, 1.6199, 246.598)
    ..cubicTo(1.604, 246.569, 1.5848, 246.544, 1.5619, 246.519)
    ..cubicTo(1.5619, 246.519, -6.0139, 238.944, -6.0139, 238.944)
    ..cubicTo(-6.152, 238.808, -6.3756, 238.808, -6.5137, 238.944)
    ..cubicTo(-6.6517, 239.083, -6.6517, 239.308, -6.5137, 239.444)
    ..cubicTo(-6.5137, 239.444, 1.0623, 247.019, 1.0623, 247.019)
    ..cubicTo(1.0623, 247.019, 1.0623, 247.019, 1.0623, 247.019)
    ..close();

  static final Path __path37_1_26 = Path()
    ..moveTo(-5.9515, 371.625)
    ..cubicTo(-5.9423, 371.625, -5.9325, 371.625, -5.9229, 371.625)
    ..cubicTo(-5.9229, 371.625, 2.3118, 370.964, 2.3118, 370.964)
    ..cubicTo(2.3722, 370.961, 2.4304, 370.939, 2.4808, 370.907)
    ..cubicTo(2.6325, 370.804, 17.6631, 360.674, 19.9465, 359.042)
    ..cubicTo(22.1788, 357.449, 38.4537, 352.556, 38.6177, 352.506)
    ..cubicTo(38.8048, 352.452, 38.9109, 352.252, 38.8548, 352.066)
    ..cubicTo(38.7991, 351.881, 38.602, 351.773, 38.4148, 351.831)
    ..cubicTo(37.938, 351.973, 29.8748, 354.399, 24.3612, 356.395)
    ..cubicTo(24.3312, 355.102, 24.4133, 351.641, 24.5233, 347.019)
    ..cubicTo(24.6008, 343.776, 24.6683, 340.697, 24.724, 337.783)
    ..cubicTo(24.724, 337.783, 38.8398, 338.029, 38.8398, 338.029)
    ..cubicTo(38.8416, 338.029, 38.8438, 338.029, 38.8459, 338.029)
    ..cubicTo(39.0384, 338.029, 39.1959, 337.872, 39.1991, 337.679)
    ..cubicTo(39.2027, 337.487, 39.0473, 337.326, 38.852, 337.322)
    ..cubicTo(38.852, 337.322, 24.7373, 337.079, 24.7373, 337.079)
    ..cubicTo(24.9719, 324.489, 24.9755, 315.145, 24.554, 309.602)
    ..cubicTo(24.554, 309.602, 38.2901, 305.402, 38.2901, 305.402)
    ..cubicTo(38.4769, 305.345, 38.5823, 305.148, 38.5248, 304.962)
    ..cubicTo(38.4677, 304.777, 38.268, 304.67, 38.0837, 304.727)
    ..cubicTo(38.0837, 304.727, 24.494, 308.881, 24.494, 308.881)
    ..cubicTo(24.2522, 306.145, 23.8915, 304.459, 23.3821, 303.909)
    ..cubicTo(23.3604, 303.091, 23.4025, 300.491, 23.4593, 296.98)
    ..cubicTo(23.8615, 272.103, 23.6304, 263.509, 22.5542, 262.927)
    ..cubicTo(22.5542, 262.927, 18.6018, 260.623, 18.6018, 260.623)
    ..cubicTo(18.5639, 260.598, 18.5221, 260.584, 18.4789, 260.577)
    ..cubicTo(18.4789, 260.577, 5.9618, 258.602, 5.9618, 258.602)
    ..cubicTo(5.7716, 258.569, 5.5882, 258.702, 5.5578, 258.894)
    ..cubicTo(5.527, 259.087, 5.6587, 259.27, 5.8514, 259.298)
    ..cubicTo(5.8514, 259.298, 18.3032, 261.266, 18.3032, 261.266)
    ..cubicTo(18.3032, 261.266, 22.1735, 263.52, 22.1735, 263.52)
    ..cubicTo(22.8146, 264.259, 22.9575, 272.235, 22.9346, 280.664)
    ..cubicTo(22.9346, 280.664, 5.2543, 280.335, 5.2543, 280.335)
    ..cubicTo(5.2519, 280.335, 5.2498, 280.335, 5.2477, 280.335)
    ..cubicTo(5.0554, 280.335, 4.8983, 280.489, 4.8944, 280.682)
    ..cubicTo(4.8909, 280.878, 5.0463, 281.039, 5.2412, 281.043)
    ..cubicTo(5.2412, 281.043, 22.9325, 281.371, 22.9325, 281.371)
    ..cubicTo(22.9107, 287.179, 22.815, 293.112, 22.7525, 296.969)
    ..cubicTo(22.6917, 300.744, 22.6474, 303.47, 22.6821, 304.098)
    ..cubicTo(22.6892, 304.22, 22.7607, 304.334, 22.8707, 304.391)
    ..cubicTo(23.32, 304.627, 23.6275, 306.377, 23.8315, 309.081)
    ..cubicTo(23.8315, 309.081, 2.56, 315.581, 2.56, 315.581)
    ..cubicTo(2.56, 315.581, -5.622, 315.581, -5.622, 315.581)
    ..cubicTo(-5.8173, 315.581, -5.9754, 315.738, -5.9754, 315.935)
    ..cubicTo(-5.9754, 316.131, -5.8173, 316.288, -5.622, 316.288)
    ..cubicTo(-5.622, 316.288, 2.6128, 316.288, 2.6128, 316.288)
    ..cubicTo(2.6475, 316.288, 2.6826, 316.285, 2.7159, 316.274)
    ..cubicTo(2.7159, 316.274, 23.8822, 309.806, 23.8822, 309.806)
    ..cubicTo(24.3094, 316.378, 24.2079, 327.718, 24.034, 337.065)
    ..cubicTo(24.034, 337.065, 0.6429, 336.661, 0.6429, 336.661)
    ..cubicTo(0.4632, 336.672, 0.287, 336.815, 0.2831, 337.012)
    ..cubicTo(0.2797, 337.204, 0.4352, 337.365, 0.6303, 337.369)
    ..cubicTo(0.6303, 337.369, 24.0208, 337.772, 24.0208, 337.772)
    ..cubicTo(23.9533, 341.287, 23.8768, 344.487, 23.8168, 347.005)
    ..cubicTo(23.7, 351.92, 23.614, 355.531, 23.6625, 356.652)
    ..cubicTo(21.7002, 357.377, 20.1476, 358.031, 19.5358, 358.467)
    ..cubicTo(17.3445, 360.035, 3.3348, 369.478, 2.1627, 370.268)
    ..cubicTo(2.1627, 370.268, -5.9794, 370.921, -5.9794, 370.921)
    ..cubicTo(-6.1737, 370.936, -6.3191, 371.107, -6.3035, 371.3)
    ..cubicTo(-6.2886, 371.486, -6.1341, 371.625, -5.9515, 371.625)
    ..cubicTo(-5.9515, 371.625, -5.9515, 371.625, -5.9515, 371.625)
    ..close();

  static final Path __path37_1_27 = Path()
    ..moveTo(94.2037, 281.227)
    ..cubicTo(94.2037, 281.227, 89.3819, 268.368, 89.3819, 268.368)
    ..cubicTo(89.3819, 268.368, 107.136, 260.946, 107.136, 260.946)
    ..cubicTo(107.136, 260.946, 129.429, 258.732, 129.429, 258.732)
    ..cubicTo(129.694, 262.668, 130.16, 269.626, 130.633, 276.766)
    ..cubicTo(118.325, 277.837, 105.981, 279.101, 94.2205, 281.334)
    ..cubicTo(94.219, 281.298, 94.2169, 281.262, 94.2037, 281.227)
    ..cubicTo(94.2037, 281.227, 94.2037, 281.227, 94.2037, 281.227)
    ..close();

  static final Path __path37_1_28 = Path()
    ..moveTo(39.8396, 298.567)
    ..cubicTo(39.8807, 298.728, 40.0243, 298.832, 40.1811, 298.832)
    ..cubicTo(40.2107, 298.832, 40.2407, 298.828, 40.2704, 298.821)
    ..cubicTo(40.2704, 298.821, 58.0572, 294.21, 58.0572, 294.21)
    ..cubicTo(58.0865, 294.203, 58.1143, 294.192, 58.14, 294.178)
    ..cubicTo(78.5117, 282.855, 104.674, 279.734, 130.68, 277.469)
    ..cubicTo(130.879, 280.473, 131.078, 283.491, 131.263, 286.313)
    ..cubicTo(131.188, 286.273, 131.099, 286.256, 131.009, 286.277)
    ..cubicTo(131.009, 286.277, 104.328, 292.867, 104.328, 292.867)
    ..cubicTo(104.268, 292.881, 104.213, 292.91, 104.168, 292.953)
    ..cubicTo(104.168, 292.953, 87.6985, 308.765, 87.6985, 308.765)
    ..cubicTo(87.5578, 308.9, 87.5531, 309.122, 87.6881, 309.265)
    ..cubicTo(87.7578, 309.336, 87.8503, 309.372, 87.9432, 309.372)
    ..cubicTo(88.0314, 309.372, 88.1196, 309.34, 88.1878, 309.275)
    ..cubicTo(88.1878, 309.275, 104.59, 293.531, 104.59, 293.531)
    ..cubicTo(104.59, 293.531, 131.178, 286.963, 131.178, 286.963)
    ..cubicTo(131.225, 286.952, 131.266, 286.931, 131.302, 286.906)
    ..cubicTo(131.639, 292.056, 131.925, 296.492, 132.069, 298.896)
    ..cubicTo(132.081, 298.946, 134.044, 306.8, 134.067, 306.864)
    ..cubicTo(134.067, 306.864, 140.985, 321.687, 140.985, 321.687)
    ..cubicTo(141.045, 321.816, 141.172, 321.891, 141.305, 321.891)
    ..cubicTo(141.355, 321.891, 141.406, 321.88, 141.454, 321.855)
    ..cubicTo(141.631, 321.773, 141.708, 321.562, 141.625, 321.387)
    ..cubicTo(141.625, 321.387, 134.73, 306.629, 134.73, 306.629)
    ..cubicTo(134.73, 306.629, 133.742, 302.675, 133.742, 302.675)
    ..cubicTo(133.147, 300.296, 132.885, 299.246, 132.715, 298.792)
    ..cubicTo(132.715, 298.792, 132.764, 298.789, 132.764, 298.789)
    ..cubicTo(132.542, 295.024, 131.963, 286.156, 131.384, 277.408)
    ..cubicTo(133.948, 277.187, 136.51, 276.973, 139.064, 276.758)
    ..cubicTo(149.423, 275.894, 159.207, 275.073, 168.364, 273.794)
    ..cubicTo(168.557, 273.769, 168.691, 273.59, 168.665, 273.397)
    ..cubicTo(168.638, 273.201, 168.459, 273.065, 168.266, 273.094)
    ..cubicTo(159.129, 274.373, 149.354, 275.19, 139.005, 276.055)
    ..cubicTo(136.455, 276.266, 133.897, 276.48, 131.337, 276.701)
    ..cubicTo(130.864, 269.558, 130.398, 262.593, 130.133, 258.661)
    ..cubicTo(130.133, 258.661, 153.527, 256.339, 153.527, 256.339)
    ..cubicTo(153.721, 256.321, 153.863, 256.146, 153.844, 255.953)
    ..cubicTo(153.825, 255.757, 153.653, 255.625, 153.457, 255.635)
    ..cubicTo(153.457, 255.635, 126.521, 258.311, 126.521, 258.311)
    ..cubicTo(126.701, 258.289, 126.84, 258.139, 126.836, 257.957)
    ..cubicTo(126.836, 257.957, 125.847, 217.439, 125.847, 217.439)
    ..cubicTo(125.842, 217.246, 125.685, 217.096, 125.494, 217.096)
    ..cubicTo(125.491, 217.096, 125.488, 217.096, 125.485, 217.096)
    ..cubicTo(125.29, 217.1, 125.136, 217.261, 125.14, 217.457)
    ..cubicTo(125.14, 217.457, 125.758, 242.791, 125.758, 242.791)
    ..cubicTo(124.665, 242.827, 105.834, 243.441, 105.72, 243.445)
    ..cubicTo(105.684, 243.449, 105.646, 243.456, 105.611, 243.466)
    ..cubicTo(101.349, 244.995, 91.0202, 248.328, 85.9084, 249.317)
    ..cubicTo(85.9084, 249.317, 81.3712, 228.901, 81.3712, 228.901)
    ..cubicTo(81.3648, 228.872, 81.3551, 228.844, 81.3423, 228.819)
    ..cubicTo(81.3423, 228.819, 77.3895, 220.915, 77.3895, 220.915)
    ..cubicTo(77.302, 220.74, 77.0905, 220.668, 76.9155, 220.757)
    ..cubicTo(76.7408, 220.843, 76.6701, 221.054, 76.7573, 221.229)
    ..cubicTo(76.7573, 221.229, 80.6908, 229.097, 80.6908, 229.097)
    ..cubicTo(80.6908, 229.097, 85.2922, 249.806, 85.2922, 249.806)
    ..cubicTo(85.329, 249.971, 85.4748, 250.081, 85.6373, 250.081)
    ..cubicTo(85.6583, 250.081, 85.6791, 250.081, 85.7005, 250.078)
    ..cubicTo(90.723, 249.167, 101.474, 245.699, 105.85, 244.134)
    ..cubicTo(105.85, 244.134, 105.839, 244.102, 105.839, 244.102)
    ..cubicTo(106.795, 244.117, 110.517, 243.999, 125.776, 243.495)
    ..cubicTo(125.776, 243.495, 126.129, 257.971, 126.129, 257.971)
    ..cubicTo(126.134, 258.16, 126.286, 258.31, 126.472, 258.314)
    ..cubicTo(126.472, 258.314, 107.013, 260.246, 107.013, 260.246)
    ..cubicTo(106.978, 260.25, 106.944, 260.261, 106.912, 260.271)
    ..cubicTo(106.912, 260.271, 88.795, 267.851, 88.795, 267.851)
    ..cubicTo(88.6196, 267.922, 88.5339, 268.122, 88.6004, 268.301)
    ..cubicTo(88.6004, 268.301, 93.5365, 281.462, 93.5365, 281.462)
    ..cubicTo(80.6419, 283.955, 68.4669, 287.638, 57.8364, 293.535)
    ..cubicTo(57.8364, 293.535, 40.0929, 298.139, 40.0929, 298.139)
    ..cubicTo(39.9039, 298.185, 39.7903, 298.378, 39.8396, 298.567)
    ..cubicTo(39.8396, 298.567, 39.8396, 298.567, 39.8396, 298.567)
    ..close();

  static final Path __path37_1_29 = Path()
    ..moveTo(240.54, 239.174)
    ..cubicTo(240.351, 239.124, 240.159, 239.238, 240.112, 239.428)
    ..cubicTo(240.065, 239.617, 240.18, 239.81, 240.369, 239.856)
    ..cubicTo(240.369, 239.856, 258.195, 244.314, 258.195, 244.314)
    ..cubicTo(257.571, 252.532, 256.496, 261.322, 255.916, 265.487)
    ..cubicTo(255.889, 265.68, 256.024, 265.858, 256.217, 265.887)
    ..cubicTo(256.234, 265.891, 256.25, 265.891, 256.266, 265.891)
    ..cubicTo(256.44, 265.891, 256.591, 265.762, 256.616, 265.587)
    ..cubicTo(257.194, 261.43, 258.263, 252.693, 258.891, 244.478)
    ..cubicTo(258.894, 244.478, 258.898, 244.482, 258.901, 244.482)
    ..cubicTo(259.059, 244.482, 259.203, 244.375, 259.244, 244.214)
    ..cubicTo(259.291, 244.025, 259.176, 243.832, 258.987, 243.785)
    ..cubicTo(258.987, 243.785, 258.943, 243.775, 258.943, 243.775)
    ..cubicTo(259.339, 238.381, 259.532, 233.277, 259.253, 229.934)
    ..cubicTo(259.237, 229.738, 259.067, 229.591, 258.872, 229.613)
    ..cubicTo(258.677, 229.627, 258.532, 229.798, 258.549, 229.991)
    ..cubicTo(258.823, 233.277, 258.636, 238.288, 258.248, 243.6)
    ..cubicTo(258.248, 243.6, 240.54, 239.174, 240.54, 239.174)
    ..cubicTo(240.54, 239.174, 240.54, 239.174, 240.54, 239.174)
    ..close();

  static final Path __path37_2_0 = Path()
    ..moveTo(-5.6213, 167.705)
    ..cubicTo(-5.6213, 167.705, -0.351, 173.963, -0.351, 173.963)
    ..cubicTo(-0.351, 173.963, 14.1421, 166.059, 14.1421, 166.059)
    ..cubicTo(14.1421, 166.059, 19.7418, 170.998, 21.3887, 170.341)
    ..cubicTo(23.0357, 169.68, 32.9175, 166.387, 32.9175, 166.387)
    ..cubicTo(32.9175, 166.387, 40.1642, 168.034, 40.1642, 168.034)
    ..cubicTo(40.1642, 168.034, 39.5052, 178.574, 39.5052, 178.574)
    ..cubicTo(39.5052, 178.574, 40.4935, 185.821, 40.4935, 185.821)
    ..cubicTo(40.4935, 185.821, 42.4697, 181.21, 42.4697, 181.21)
    ..cubicTo(42.4697, 181.21, 43.1283, 172.316, 43.1283, 172.316)
    ..cubicTo(43.1283, 172.316, 40.8228, 164.412, 40.8228, 164.412)
    ..cubicTo(40.8228, 164.412, 51.034, 157.165, 51.034, 157.165)
    ..cubicTo(51.034, 157.165, 67.8328, 158.483, 67.8328, 158.483)
    ..cubicTo(67.8328, 158.483, 68.8211, 153.543, 68.8211, 153.543)
    ..cubicTo(68.8211, 153.543, 76.0678, 153.872, 76.0678, 153.872)
    ..cubicTo(76.0678, 153.872, 79.3616, 158.483, 79.3616, 158.483)
    ..cubicTo(79.3616, 158.483, 82.9848, 177.588, 82.9848, 177.588)
    ..cubicTo(82.9848, 177.588, 72.115, 177.917, 72.115, 177.917)
    ..cubicTo(72.115, 177.917, 50.0457, 189.118, 50.0457, 189.118)
    ..cubicTo(50.0457, 189.118, 39.5052, 188.457, 39.5052, 188.457)
    ..cubicTo(39.5052, 188.457, 30.2823, 189.775, 30.2823, 189.775)
    ..cubicTo(30.2823, 189.775, 31.9292, 198.34, 31.9292, 198.34)
    ..cubicTo(31.9292, 198.34, 9.5306, 192.739, 9.5306, 192.739)
    ..cubicTo(9.5306, 192.739, -6.6094, 183.517, -6.6094, 183.517)
    ..cubicTo(-6.6094, 183.517, -5.6213, 166.716, -5.6213, 167.705)
    ..cubicTo(-5.6213, 167.705, -5.6213, 167.705, -5.6213, 167.705)
    ..close();

  static final Path __path37_2_1 = Path()
    ..moveTo(21.3984, 261.255)
    ..cubicTo(21.3984, 261.255, 21.7281, 257.633, 21.7281, 257.633)
    ..cubicTo(21.7281, 257.633, 25.6806, 257.633, 25.6806, 257.633)
    ..cubicTo(25.6806, 257.633, 27.3275, 249.068, 27.3275, 249.068)
    ..cubicTo(27.3275, 249.068, 37.868, 249.068, 37.868, 249.068)
    ..cubicTo(37.868, 249.068, 41.4915, 258.951, 41.4915, 258.951)
    ..cubicTo(41.4915, 258.951, 38.527, 304.734, 38.527, 304.734)
    ..cubicTo(38.527, 304.734, 24.6923, 308.688, 24.6923, 308.688)
    ..cubicTo(24.6923, 308.688, 23.0454, 303.748, 23.0454, 303.748)
    ..cubicTo(23.0454, 303.748, 23.7043, 265.866, 23.7043, 265.866)
    ..cubicTo(23.7043, 265.866, 21.3984, 261.255, 21.3984, 261.255)
    ..close();

  static final Path __path37_2_2 = Path()
    ..moveTo(49.7256, 305.071)
    ..cubicTo(49.7256, 305.071, 56.6426, 305.4, 56.6426, 305.4)
    ..cubicTo(56.6426, 305.4, 56.6426, 328.455, 56.6426, 328.455)
    ..cubicTo(56.6426, 328.455, 66.1952, 328.787, 66.1952, 328.787)
    ..cubicTo(66.1952, 328.787, 66.5245, 347.232, 66.5245, 347.232)
    ..cubicTo(66.5245, 347.232, 55.984, 347.232, 55.984, 347.232)
    ..cubicTo(55.984, 347.232, 55.6547, 356.454, 55.6547, 356.454)
    ..cubicTo(55.6547, 356.454, 49.3963, 359.09, 49.3963, 359.09)
    ..cubicTo(49.3963, 359.09, 49.0666, 353.822, 49.0666, 353.822)
    ..cubicTo(49.0666, 353.822, 39.8438, 353.822, 39.8438, 353.822)
    ..cubicTo(39.8438, 353.822, 39.8438, 332.081, 39.8438, 332.081)
    ..cubicTo(39.8438, 332.081, 49.0666, 332.409, 49.0666, 332.409)
    ..cubicTo(49.0666, 332.409, 49.7256, 305.071, 49.7256, 305.071)
    ..close();

  static final Path __path37_2_3 = Path()
    ..moveTo(63.2391, 306.716)
    ..cubicTo(63.2391, 306.716, 70.4858, 305.07, 70.4858, 305.07)
    ..cubicTo(70.4858, 305.07, 97.1665, 312.974, 97.1665, 312.974)
    ..cubicTo(97.1665, 312.974, 94.8606, 319.892, 94.8606, 319.892)
    ..cubicTo(94.8606, 319.892, 99.1428, 324.832, 99.1428, 324.832)
    ..cubicTo(99.1428, 324.832, 92.8844, 331.418, 92.8844, 331.418)
    ..cubicTo(92.8844, 331.418, 94.5313, 336.69, 94.5313, 336.69)
    ..cubicTo(94.5313, 336.69, 84.6498, 340.973, 84.6498, 340.973)
    ..cubicTo(84.6498, 340.973, 84.9788, 333.397, 84.9788, 333.397)
    ..cubicTo(84.9788, 333.397, 79.7087, 326.807, 79.7087, 326.807)
    ..cubicTo(79.7087, 326.807, 71.8034, 327.139, 71.8034, 327.139)
    ..cubicTo(71.8034, 327.139, 62.5805, 319.232, 62.5805, 319.232)
    ..cubicTo(62.5805, 319.232, 59.9453, 313.963, 59.9453, 313.963)
    ..cubicTo(59.9453, 313.963, 63.2391, 306.716, 63.2391, 306.716)
    ..close();

  static final Path __path37_2_4 = Path()
    ..moveTo(269.031, 164.341)
    ..cubicTo(269.031, 164.341, 275.949, 157.919, 275.949, 157.919)
    ..cubicTo(275.949, 157.919, 275.949, 166.316, 275.949, 166.316)
    ..cubicTo(275.949, 166.316, 285.83, 169.777, 285.83, 169.777)
    ..cubicTo(285.83, 169.777, 288.795, 174.47, 288.795, 174.47)
    ..cubicTo(288.795, 174.47, 286.571, 177.928, 286.571, 177.928)
    ..cubicTo(286.571, 177.928, 289.536, 182.128, 289.536, 182.128)
    ..cubicTo(289.536, 182.128, 298.183, 178.67, 298.183, 178.67)
    ..cubicTo(298.183, 178.67, 300.159, 186.575, 300.159, 186.575)
    ..cubicTo(300.159, 186.575, 305.347, 198.926, 305.347, 198.926)
    ..cubicTo(305.347, 198.926, 313.499, 215.727, 313.499, 215.727)
    ..cubicTo(313.499, 215.727, 317.946, 224.124, 317.946, 224.124)
    ..cubicTo(317.946, 224.124, 326.345, 230.3, 326.345, 230.3)
    ..cubicTo(326.345, 230.3, 324.863, 237.961, 324.863, 237.961)
    ..cubicTo(324.863, 237.961, 304.606, 235.243, 304.606, 235.243)
    ..cubicTo(304.606, 235.243, 298.183, 222.888, 298.183, 222.888)
    ..cubicTo(298.183, 222.888, 298.677, 216.22, 298.677, 216.22)
    ..cubicTo(298.677, 216.22, 295.218, 213.009, 295.218, 213.009)
    ..cubicTo(295.218, 213.009, 292.253, 210.537, 292.253, 210.537)
    ..cubicTo(292.253, 210.537, 291.512, 207.08, 291.512, 207.08)
    ..cubicTo(291.512, 207.08, 293.983, 196.208, 293.983, 196.208)
    ..cubicTo(293.983, 196.208, 284.842, 190.279, 284.842, 190.279)
    ..cubicTo(284.842, 190.279, 274.466, 189.539, 274.466, 189.539)
    ..cubicTo(274.466, 189.539, 269.031, 172.741, 269.031, 171.752)
    ..cubicTo(269.031, 170.763, 269.031, 164.341, 269.031, 164.341)
    ..cubicTo(269.031, 164.341, 269.031, 164.341, 269.031, 164.341)
    ..close();

  static final Path __path37_3_0 = Path()
    ..moveTo(338.937, 0.3751)
    ..cubicTo(338.937, 0.3751, 333.337, 9.6009, 333.337, 9.6009)
    ..cubicTo(333.337, 9.6009, 335.973, 13.2226, 335.973, 13.2226)
    ..cubicTo(335.973, 13.2226, 352.77, 15.1978, 352.77, 15.1978)
    ..cubicTo(352.77, 15.1978, 352.442, 31.3384, 352.442, 31.3384)
    ..cubicTo(352.442, 31.3384, 343.22, 50.7721, 343.22, 50.7721)
    ..cubicTo(343.22, 50.7721, 338.609, 54.0688, 338.609, 54.0688)
    ..cubicTo(338.609, 54.0688, 335.973, 59.3371, 335.973, 59.3371)
    ..cubicTo(335.973, 59.3371, 330.701, 58.3476, 330.701, 58.3476)
    ..cubicTo(330.701, 58.3476, 323.784, 66.584, 323.784, 66.584)
    ..cubicTo(323.784, 66.584, 323.784, 80.7459, 323.784, 80.7459)
    ..cubicTo(323.784, 80.7459, 327.078, 81.4066, 327.078, 81.4066)
    ..cubicTo(327.078, 81.4066, 329.713, 83.714, 329.713, 83.714)
    ..cubicTo(329.713, 83.714, 328.066, 86.0178, 328.066, 86.0178)
    ..cubicTo(328.066, 86.0178, 336.301, 91.2896, 336.301, 91.2896)
    ..cubicTo(336.301, 91.2896, 350.467, 91.9468, 350.467, 91.9468)
    ..cubicTo(350.467, 91.9468, 353.431, 88.9823, 353.431, 88.9823)
    ..cubicTo(353.431, 88.9823, 368.254, 88.3251, 368.254, 88.3251)
    ..cubicTo(368.254, 88.3251, 378.794, 108.087, 378.794, 108.087)
    ..cubicTo(378.794, 108.087, 381.758, 107.427, 381.758, 107.427)
    ..cubicTo(381.758, 107.427, 382.416, 110.723, 382.416, 110.723)
    ..cubicTo(382.416, 110.723, 386.041, 113.356, 386.041, 113.356)
    ..cubicTo(386.041, 113.356, 381.098, 113.688, 381.098, 113.688)
    ..cubicTo(381.098, 113.688, 380.108, 116.652, 380.108, 116.652)
    ..cubicTo(380.108, 116.652, 375.829, 118.956, 375.829, 118.956)
    ..cubicTo(375.829, 118.956, 374.84, 131.475, 374.84, 131.475)
    ..cubicTo(374.84, 131.475, 372.533, 130.814, 372.533, 130.814)
    ..cubicTo(372.533, 130.814, 370.558, 135.097, 370.558, 135.097)
    ..cubicTo(370.558, 135.097, 377.144, 139.051, 377.144, 139.051)
    ..cubicTo(377.144, 139.051, 368.911, 139.708, 368.911, 139.708)
    ..cubicTo(368.911, 139.708, 366.936, 141.354, 366.936, 141.354)
    ..cubicTo(366.936, 141.354, 363.639, 140.036, 363.639, 140.036)
    ..cubicTo(363.639, 140.036, 331.69, 147.944, 331.69, 147.944)
    ..cubicTo(331.69, 147.944, 317.196, 160.788, 317.196, 160.788)
    ..cubicTo(317.196, 160.788, 314.891, 165.071, 314.891, 165.071)
    ..cubicTo(314.891, 165.071, 314.891, 175.282, 314.891, 175.282)
    ..cubicTo(314.891, 175.282, 310.279, 175.282, 310.279, 175.282)
    ..cubicTo(310.279, 175.282, 309.95, 189.776, 309.95, 189.776)
    ..cubicTo(309.95, 189.776, 318.185, 210.528, 318.185, 210.528)
    ..cubicTo(318.185, 210.528, 330.701, 219.75, 330.701, 219.75)
    ..cubicTo(330.701, 219.75, 342.23, 225.35, 342.23, 225.35)
    ..cubicTo(342.23, 225.35, 358.371, 230.951, 358.371, 230.951)
    ..cubicTo(358.371, 230.951, 359.357, 223.043, 359.357, 223.043)
    ..cubicTo(359.357, 223.043, 361.664, 218.103, 361.664, 218.103)
    ..cubicTo(361.664, 218.103, 359.689, 217.775, 359.689, 217.775)
    ..cubicTo(359.689, 217.775, 361.335, 214.81, 361.335, 214.81)
    ..cubicTo(361.335, 214.81, 366.275, 217.775, 366.275, 217.775)
    ..cubicTo(366.275, 217.775, 365.946, 223.704, 365.946, 223.704)
    ..cubicTo(365.946, 223.704, 361.993, 223.704, 361.993, 223.704)
    ..cubicTo(361.993, 223.704, 360.675, 230.951, 360.675, 230.951)
    ..cubicTo(360.675, 230.951, 370.886, 230.951, 370.886, 230.951)
    ..cubicTo(370.886, 230.951, 375.497, 225.679, 375.497, 225.679)
    ..cubicTo(375.497, 225.679, 380.769, 222.057, 380.769, 222.057)
    ..cubicTo(380.769, 222.057, 390.652, 223.043, 390.652, 223.043)
    ..cubicTo(390.652, 223.043, 396.249, 214.15, 396.249, 214.15)
    ..cubicTo(396.249, 214.15, 395.263, 208.553, 395.263, 208.553)
    ..cubicTo(395.263, 208.553, 396.581, 207.563, 396.581, 207.563)
    ..cubicTo(396.581, 207.563, 393.617, 199.327, 393.617, 199.327)
    ..cubicTo(393.617, 199.327, 399.213, 196.695, 399.213, 196.695)
    ..cubicTo(399.213, 196.695, 403.825, 208.22, 403.825, 208.22)
    ..cubicTo(403.825, 208.22, 415.686, 200.316, 415.686, 200.316)
    ..cubicTo(415.686, 200.316, 411.072, 188.787, 411.072, 188.787)
    ..cubicTo(411.072, 188.787, 407.778, 189.776, 407.778, 189.776)
    ..cubicTo(407.778, 189.776, 406.46, 184.176, 406.46, 184.176)
    ..cubicTo(406.46, 184.176, 435.448, 171, 435.448, 171)
    ..cubicTo(435.448, 171, 444.671, 191.094, 444.671, 191.094)
    ..cubicTo(444.671, 191.094, 436.434, 194.059, 436.434, 194.059)
    ..cubicTo(436.434, 194.059, 429.191, 177.261, 429.191, 177.261)
    ..cubicTo(429.191, 177.261, 413.379, 183.847, 413.379, 183.847)
    ..cubicTo(413.379, 183.847, 429.848, 217.114, 429.848, 217.114)
    ..cubicTo(429.848, 217.114, 425.237, 219.75, 425.237, 219.75)
    ..cubicTo(425.237, 219.75, 419.636, 205.256, 419.636, 205.256)
    ..cubicTo(419.636, 205.256, 414.697, 207.892, 414.697, 207.892)
    ..cubicTo(414.697, 207.892, 416.261, 210.281, 416.261, 210.281)
    ..cubicTo(416.261, 210.281, 412.307, 212.01, 412.307, 212.01)
    ..cubicTo(412.307, 212.01, 410.825, 209.292, 410.825, 209.292)
    ..cubicTo(410.825, 209.292, 402.674, 214.482, 402.674, 214.482)
    ..cubicTo(402.674, 214.482, 401.932, 221.397, 401.932, 221.397)
    ..cubicTo(401.932, 221.397, 403.414, 222.386, 403.414, 222.386)
    ..cubicTo(403.414, 222.386, 409.839, 220.411, 409.839, 220.411)
    ..cubicTo(409.839, 220.411, 411.072, 222.386, 411.072, 222.386)
    ..cubicTo(411.072, 222.386, 401.439, 225.104, 401.439, 225.104)
    ..cubicTo(401.439, 225.104, 402.921, 230.29, 402.921, 230.29)
    ..cubicTo(402.921, 230.29, 407.614, 234.737, 407.614, 234.737)
    ..cubicTo(407.614, 234.737, 414.036, 245.609, 414.036, 245.609)
    ..cubicTo(414.036, 245.609, 419.226, 246.845, 419.226, 246.845)
    ..cubicTo(419.226, 246.845, 426.144, 244.866, 426.144, 244.866)
    ..cubicTo(426.144, 244.866, 427.623, 247.584, 427.623, 247.584)
    ..cubicTo(427.623, 247.584, 438.249, 246.349, 438.249, 246.349)
    ..cubicTo(438.249, 246.349, 438.988, 248.077, 438.988, 248.077)
    ..cubicTo(438.988, 248.077, 443.931, 245.856, 443.931, 245.856)
    ..cubicTo(443.931, 245.856, 445.164, 241.162, 445.164, 241.162)
    ..cubicTo(445.164, 241.162, 448.871, 241.409, 448.871, 241.409)
    ..cubicTo(448.871, 241.409, 450.353, 236.962, 450.353, 236.962)
    ..cubicTo(450.353, 236.962, 452.328, 236.219, 452.328, 236.219)
    ..cubicTo(452.328, 236.219, 453.564, 231.033, 453.564, 231.033)
    ..cubicTo(453.564, 231.033, 457.268, 226.586, 457.268, 226.586)
    ..cubicTo(457.268, 226.586, 469.869, 220.657, 469.869, 220.657)
    ..cubicTo(469.869, 220.657, 471.105, 218.186, 471.105, 218.186)
    ..cubicTo(471.105, 218.186, 477.034, 217.446, 477.034, 217.446)
    ..cubicTo(477.034, 217.446, 479.256, 220.657, 479.256, 220.657)
    ..cubicTo(479.256, 220.657, 479.009, 224.611, 479.009, 224.611)
    ..cubicTo(479.009, 224.611, 482.22, 226.093, 482.22, 226.093)
    ..cubicTo(482.22, 226.093, 484.692, 224.611, 484.692, 224.611)
    ..cubicTo(484.692, 224.611, 485.681, 225.843, 485.681, 225.843)
    ..cubicTo(485.681, 225.843, 492.35, 226.093, 492.35, 226.093)
    ..cubicTo(492.35, 226.093, 495.068, 222.632, 495.068, 222.632)
    ..cubicTo(495.068, 222.632, 495.811, 208.553, 495.811, 208.553)
    ..cubicTo(495.811, 208.553, 502.972, 207.563, 502.972, 207.563)
    ..cubicTo(502.972, 207.563, 501.986, 202.127, 501.986, 202.127)
    ..cubicTo(501.986, 202.127, 505.443, 208.306, 505.443, 208.306)
    ..cubicTo(505.443, 208.306, 507.915, 211.021, 507.915, 211.021)
    ..cubicTo(507.915, 211.021, 504.454, 212.01, 504.454, 212.01)
    ..cubicTo(504.454, 212.01, 502.725, 210.035, 502.725, 210.035)
    ..cubicTo(502.725, 210.035, 498.032, 210.281, 498.032, 210.281)
    ..cubicTo(498.032, 210.281, 497.786, 214.728, 497.786, 214.728)
    ..cubicTo(497.786, 214.728, 506.679, 214.728, 506.679, 214.728)
    ..cubicTo(506.679, 214.728, 506.926, 220.164, 506.926, 220.164)
    ..cubicTo(506.926, 220.164, 517.794, 219.668, 517.794, 219.668)
    ..cubicTo(517.794, 219.668, 521.502, 222.386, 521.502, 222.386)
    ..cubicTo(521.502, 222.386, 534.099, 251.785, 534.099, 251.785)
    ..cubicTo(534.099, 251.785, 529.653, 253.513, 529.653, 253.513)
    ..cubicTo(529.653, 253.513, 531.631, 258.207, 531.631, 258.207)
    ..cubicTo(531.631, 258.207, 531.135, 282.169, 531.135, 282.169)
    ..cubicTo(531.135, 282.169, 544.229, 277.973, 544.229, 277.973)
    ..cubicTo(544.229, 277.973, 546.947, 283.652, 546.947, 283.652)
    ..cubicTo(546.947, 283.652, 541.757, 285.38, 541.757, 285.38)
    ..cubicTo(541.757, 285.38, 542.254, 288.841, 542.254, 288.841)
    ..cubicTo(542.254, 288.841, 537.31, 290.324, 537.31, 290.324)
    ..cubicTo(537.31, 290.324, 539.782, 296.499, 539.782, 296.499)
    ..cubicTo(539.782, 296.499, 544.722, 295.51, 544.722, 295.51)
    ..cubicTo(544.722, 295.51, 567.452, 350.353, 567.452, 350.353)
    ..cubicTo(567.452, 350.353, 559.298, 352.332, 559.298, 352.332)
    ..cubicTo(559.298, 352.332, 562.759, 361.226, 562.759, 361.226)
    ..cubicTo(562.759, 361.226, 572.392, 366.658, 572.392, 366.658)
    ..cubicTo(572.392, 366.658, 576.592, 378.763, 576.592, 378.763)
    ..cubicTo(576.592, 378.763, 584.743, 379.259, 584.743, 379.259)
    ..cubicTo(584.743, 379.259, 595.369, 379.752, 595.369, 379.752)
    ..cubicTo(595.369, 379.752, 603.026, 376.788, 603.026, 376.788)
    ..cubicTo(603.026, 376.788, 593.39, 352.825, 593.39, 352.825)
    ..cubicTo(593.39, 352.825, 596.354, 351.096, 596.354, 351.096)
    ..cubicTo(596.354, 351.096, 598.58, 352.082, 598.58, 352.082)
    ..cubicTo(598.58, 352.082, 600.555, 351.343, 600.555, 351.343)
    ..cubicTo(600.555, 351.343, 600.308, 347.142, 600.308, 347.142)
    ..cubicTo(600.308, 347.142, 603.026, 346.403, 603.026, 346.403)
    ..cubicTo(603.026, 346.403, 602.283, 342.449, 602.283, 342.449)
    ..cubicTo(602.283, 342.449, 616.86, 336.027, 616.86, 336.027)
    ..cubicTo(616.86, 336.027, 619.824, 340.72, 619.824, 340.72)
    ..cubicTo(619.824, 340.72, 624.517, 339.238, 624.517, 339.238)
    ..cubicTo(624.517, 339.238, 629.211, 353.318, 629.211, 353.318)
    ..cubicTo(629.211, 353.318, 626.246, 354.554, 626.246, 354.554)
    ..cubicTo(626.246, 354.554, 623.035, 342.449, 623.035, 342.449)
    ..cubicTo(623.035, 342.449, 618.342, 344.178, 618.342, 344.178)
    ..cubicTo(618.342, 344.178, 617.352, 349.118, 617.352, 349.118)
    ..cubicTo(617.352, 349.118, 614.388, 347.885, 614.388, 347.885)
    ..cubicTo(614.388, 347.885, 611.177, 349.86, 611.177, 349.86)
    ..cubicTo(611.177, 349.86, 611.177, 352.082, 611.177, 352.082)
    ..cubicTo(611.177, 352.082, 618.835, 362.954, 618.835, 362.954)
    ..cubicTo(618.835, 362.954, 620.071, 367.401, 620.071, 367.401)
    ..cubicTo(620.071, 367.401, 609.941, 374.566, 609.941, 374.566)
    ..cubicTo(609.941, 374.566, 611.177, 377.281, 611.177, 377.281)
    ..cubicTo(611.177, 377.281, 597.837, 382.717, 597.837, 382.717)
    ..cubicTo(597.837, 382.717, 599.072, 384.942, 599.072, 384.942)
    ..cubicTo(599.072, 384.942, 564.487, 397.293, 564.487, 397.293)
    ..cubicTo(564.487, 397.293, 563.745, 407.422, 563.745, 407.422)
    ..cubicTo(563.745, 407.422, 565.97, 414.337, 565.97, 414.337)
    ..cubicTo(565.97, 414.337, 567.452, 420.266, 567.452, 420.266)
    ..cubicTo(567.452, 420.266, 571.156, 421.009, 571.156, 421.009)
    ..cubicTo(571.156, 421.009, 568.688, 425.702, 568.688, 425.702)
    ..cubicTo(568.688, 425.702, 570.909, 438.053, 570.909, 438.053)
    ..cubicTo(570.909, 438.053, 574.617, 450.161, 574.617, 450.161)
    ..cubicTo(574.617, 450.161, 585.486, 465.723, 585.486, 465.723)
    ..cubicTo(585.486, 465.723, 600.062, 478.321, 600.062, 478.321)
    ..cubicTo(600.062, 478.321, 612.906, 496.108, 612.906, 496.108)
    ..cubicTo(612.906, 496.108, 615.131, 495.862, 615.131, 495.862)
    ..cubicTo(615.131, 495.862, 616.613, 498.58, 616.613, 498.58)
    ..cubicTo(616.613, 498.58, 624.517, 498.826, 624.517, 498.826)
    ..cubicTo(624.517, 498.826, 624.764, 505.498, 624.764, 505.498)
    ..cubicTo(624.764, 505.498, 627.728, 505.252, 627.728, 505.252)
    ..cubicTo(627.728, 505.252, 627.728, 513.156, 627.728, 513.156)
    ..cubicTo(627.728, 513.156, 625.26, 517.603, 625.26, 517.603)
    ..cubicTo(625.26, 517.603, 629.707, 520.074, 629.707, 520.074)
    ..cubicTo(629.707, 520.074, 626, 521.306, 626, 521.306)
    ..cubicTo(626, 521.306, 628.718, 524.275, 628.718, 524.275)
    ..cubicTo(628.718, 524.275, 626.743, 526.743, 626.743, 526.743)
    ..cubicTo(626.743, 526.743, 626.743, 542.555, 626.743, 542.555)
    ..cubicTo(626.743, 542.555, 624.764, 541.565, 624.764, 541.565)
    ..cubicTo(624.764, 541.565, 625.26, 566.271, 625.26, 566.271)
    ..cubicTo(625.26, 566.271, 628.225, 571.457, 628.225, 571.457)
    ..cubicTo(628.225, 571.457, 629.211, 577.386, 629.211, 577.386)
    ..cubicTo(629.211, 577.386, 628.718, 581.833, 628.718, 581.833)
    ..cubicTo(628.718, 581.833, 625.753, 586.526, 625.753, 586.526)
    ..cubicTo(625.753, 586.526, 620.813, 589.987, 620.813, 589.987)
    ..cubicTo(620.813, 589.987, 618.835, 595.67, 618.835, 595.67)
    ..cubicTo(618.835, 595.67, 620.317, 600.363, 620.317, 600.363)
    ..cubicTo(620.317, 600.363, 617.106, 601.599, 617.106, 601.599)
    ..cubicTo(617.106, 601.599, 617.106, 612.221, 617.106, 612.221)
    ..cubicTo(617.106, 612.221, 614.142, 612.221, 614.142, 612.221)
    ..cubicTo(614.142, 612.221, 614.142, 616.171, 614.142, 616.171)
    ..cubicTo(614.142, 616.171, 617.849, 616.171, 617.849, 616.171)
    ..cubicTo(617.849, 616.171, 617.849, 618.889, 617.849, 618.889)
    ..cubicTo(617.849, 618.889, 613.402, 618.396, 613.402, 618.396)
    ..cubicTo(613.402, 618.396, 614.142, 623.336, 614.142, 623.336)
    ..cubicTo(614.142, 623.336, 609.941, 626.797, 609.941, 626.797)
    ..cubicTo(609.941, 626.797, 608.459, 626.054, 608.459, 626.054)
    ..cubicTo(608.459, 626.054, 604.509, 635.441, 604.509, 635.441)
    ..cubicTo(604.509, 635.441, 601.298, 635.441, 601.298, 635.441)
    ..cubicTo(601.298, 635.441, 598.58, 646.806, 598.58, 646.806)
    ..cubicTo(598.58, 646.806, 598.083, 651.499, 598.083, 651.499)
    ..cubicTo(598.083, 651.499, 598.826, 654.71, 598.826, 654.71)
    ..cubicTo(598.826, 654.71, 606.484, 660.639, 606.484, 660.639)
    ..cubicTo(606.484, 660.639, 605.494, 663.111, 605.494, 663.111)
    ..cubicTo(605.494, 663.111, 603.026, 665.336, 603.026, 665.336)
    ..cubicTo(603.026, 665.336, 599.072, 666.568, 599.072, 666.568)
    ..cubicTo(599.072, 666.568, 599.565, 670.276, 599.565, 670.276)
    ..cubicTo(599.565, 670.276, 596.851, 669.533, 596.851, 669.533)
    ..cubicTo(596.851, 669.533, 598.58, 674.969, 598.58, 674.969)
    ..cubicTo(598.58, 674.969, -6.2656, 674.969, -6.2656, 674.969)
    ..cubicTo(-6.2656, 674.969, -6.2656, 0.0466, -6.2656, 0.0466)
    ..cubicTo(-6.2656, 0.0466, 338.609, 0.7073, 338.937, 0.3751)
    ..cubicTo(338.937, 0.3751, 338.937, 0.3751, 338.937, 0.3751)
    ..close();

  static final Path __path37_4_0 = Path()
    ..moveTo(42, 0)
    ..cubicTo(42, 0, 248.427, 0, 248.427, 0)
    ..cubicTo(271.623, 0, 290.427, 18.804, 290.427, 42)
    ..cubicTo(290.427, 42, 290.427, 310.662, 290.427, 310.662)
    ..cubicTo(290.427, 333.858, 271.623, 352.662, 248.427, 352.662)
    ..cubicTo(248.427, 352.662, 42, 352.662, 42, 352.662)
    ..cubicTo(18.804, 352.662, 0, 333.858, 0, 310.662)
    ..cubicTo(0, 310.662, 0, 42, 0, 42)
    ..cubicTo(0, 18.804, 18.804, 0, 42, 0)
    ..close();

  static final Path __maskPath37_0 = Path()
    ..moveTo(42, 0)
    ..cubicTo(42, 0, 248.427, 0, 248.427, 0)
    ..cubicTo(271.623, 0, 290.427, 18.804, 290.427, 42)
    ..cubicTo(290.427, 42, 290.427, 310.662, 290.427, 310.662)
    ..cubicTo(290.427, 333.858, 271.623, 352.662, 248.427, 352.662)
    ..cubicTo(248.427, 352.662, 42, 352.662, 42, 352.662)
    ..cubicTo(18.804, 352.662, 0, 333.858, 0, 310.662)
    ..cubicTo(0, 310.662, 0, 42, 0, 42)
    ..cubicTo(0, 18.804, 18.804, 0, 42, 0)
    ..close();

  static final Path __path42_0_0 = Path()
    ..moveTo(44, 10)
    ..cubicTo(44, 10, 247, 10, 247, 10)
    ..cubicTo(265.2254, 10, 280, 24.7746, 280, 43)
    ..cubicTo(280, 43, 280, 136.045, 280, 136.045)
    ..cubicTo(280, 154.2704, 265.2254, 169.045, 247, 169.045)
    ..cubicTo(247, 169.045, 44, 169.045, 44, 169.045)
    ..cubicTo(25.7746, 169.045, 11, 154.2704, 11, 136.045)
    ..cubicTo(11, 136.045, 11, 43, 11, 43)
    ..cubicTo(11, 24.7746, 25.7746, 10, 44, 10)
    ..close();

  static final Path __path42_1_0 = Path()
    ..moveTo(51.3937, 391.773)
    ..cubicTo(95.1647, 372.118, 145.244, 349.13, 175.608, 333.211)
    ..cubicTo(175.672, 333.175, 175.733, 333.136, 175.79, 333.089)
    ..cubicTo(181.368, 328.482, 200.514, 302.958, 211.954, 287.707)
    ..cubicTo(215.144, 283.453, 217.671, 280.085, 219.065, 278.289)
    ..cubicTo(219.093, 278.26, 219.125, 278.228, 219.153, 278.199)
    ..cubicTo(220.575, 279.692, 222.002, 281.167, 223.442, 282.621)
    ..cubicTo(223.442, 282.621, 223.488, 282.575, 223.488, 282.575)
    ..cubicTo(223.941, 283, 224.819, 283.639, 226.402, 284.789)
    ..cubicTo(226.402, 284.789, 241.688, 295.908, 241.688, 295.908)
    ..cubicTo(241.812, 295.997, 241.955, 296.061, 242.106, 296.09)
    ..cubicTo(242.106, 296.09, 263.846, 300.373, 263.846, 300.373)
    ..cubicTo(263.913, 300.387, 263.982, 300.39, 264.051, 300.39)
    ..cubicTo(264.085, 300.39, 264.12, 300.39, 264.154, 300.387)
    ..cubicTo(264.154, 300.387, 280.952, 298.74, 280.952, 298.74)
    ..cubicTo(281.009, 298.733, 281.066, 298.722, 281.123, 298.708)
    ..cubicTo(281.506, 298.608, 281.891, 298.501, 282.273, 298.401)
    ..cubicTo(282.273, 298.401, 299.107, 307.83, 299.107, 307.83)
    ..cubicTo(299.271, 307.923, 299.45, 307.966, 299.625, 307.966)
    ..cubicTo(299.689, 307.966, 299.753, 307.955, 299.818, 307.941)
    ..cubicTo(302.747, 315.763, 305.293, 323.039, 307.551, 329.868)
    ..cubicTo(307.551, 329.868, 308.676, 344.119, 308.676, 344.119)
    ..cubicTo(308.676, 344.119, 306.943, 348.241, 306.943, 348.241)
    ..cubicTo(306.943, 348.241, 283.291, 361.449, 283.291, 361.449)
    ..cubicTo(267.615, 368.682, 253.287, 376.357, 239.522, 386.294)
    ..cubicTo(239.482, 386.219, 239.453, 386.14, 239.394, 386.076)
    ..cubicTo(239.003, 385.64, 238.333, 385.604, 237.897, 385.997)
    ..cubicTo(234.493, 389.051, 226.86, 395.934, 225.364, 397.53)
    ..cubicTo(225.349, 397.545, 225.333, 397.555, 225.318, 397.57)
    ..cubicTo(224.151, 397.938, 218.182, 398.363, 212.871, 398.57)
    ..cubicTo(212.482, 398.588, 212.15, 398.816, 211.978, 399.152)
    ..cubicTo(211.978, 399.152, 210.619, 399.088, 210.619, 399.088)
    ..cubicTo(210.619, 399.088, 210.302, 405.727, 210.302, 405.727)
    ..cubicTo(210.302, 405.727, 198.262, 424.925, 198.262, 424.925)
    ..cubicTo(198.262, 424.925, 198.364, 424.99, 198.364, 424.99)
    ..cubicTo(188.85, 434.151, 178.081, 442.248, 166.553, 449.535)
    ..cubicTo(166.553, 449.535, 152.334, 445.602, 152.334, 445.602)
    ..cubicTo(152.334, 445.602, 147.807, 460.389, 147.807, 460.389)
    ..cubicTo(137.634, 465.818, 127.117, 470.783, 116.541, 475.419)
    ..cubicTo(116.541, 475.419, 102.272, 470.365, 102.272, 470.365)
    ..cubicTo(102.272, 470.365, 97.1313, 464.582, 97.1313, 464.582)
    ..cubicTo(97.1313, 464.582, 96.4106, 462.378, 96.4106, 462.378)
    ..cubicTo(96.3859, 462.303, 96.3538, 462.232, 96.3138, 462.168)
    ..cubicTo(84.6325, 442.566, 68.6376, 418.028, 51.3937, 391.773)
    ..cubicTo(51.3937, 391.773, 51.3937, 391.773, 51.3937, 391.773)
    ..close();

  static final Path __path42_1_1 = Path()
    ..moveTo(44.736, 381.64)
    ..cubicTo(20.3737, 344.58, -4.7655, 306.334, -21.4254, 277.053)
    ..cubicTo(31.5596, 243.346, 87.5684, 206.526, 139.953, 171.951)
    ..cubicTo(140.916, 173.398, 141.882, 174.848, 142.856, 176.313)
    ..cubicTo(166.166, 211.337, 190.218, 247.479, 217.691, 276.663)
    ..cubicTo(217.631, 276.724, 217.567, 276.788, 217.509, 276.849)
    ..cubicTo(217.48, 276.878, 217.454, 276.91, 217.428, 276.942)
    ..cubicTo(216.031, 278.739, 213.483, 282.135, 210.258, 286.436)
    ..cubicTo(199.675, 300.544, 180.023, 326.742, 174.523, 331.386)
    ..cubicTo(144.124, 347.316, 93.9839, 370.328, 50.2147, 389.976)
    ..cubicTo(48.3988, 387.212, 46.5744, 384.436, 44.736, 381.64)
    ..cubicTo(44.736, 381.64, 44.736, 381.64, 44.736, 381.64)
    ..close();

  static final Path __path42_1_2 = Path()
    ..moveTo(-24.4238, 271.717)
    ..cubicTo(-24.4238, 271.717, -24.7528, 89.3341, -24.7528, 89.3341)
    ..cubicTo(-24.7528, 89.3341, -23.8095, 86.1909, -23.8095, 86.1909)
    ..cubicTo(-23.3513, 84.6623, -23.0723, 83.7336, -22.9298, 83.1407)
    ..cubicTo(-16.2471, 72.9041, -6.1273, 62.4605, 3.6599, 52.3632)
    ..cubicTo(10.0472, 45.7734, 16.5688, 39.0371, 22.2271, 32.2759)
    ..cubicTo(24.1554, 32.5902, 26.0902, 32.9009, 28.029, 33.201)
    ..cubicTo(45.8915, 35.9869, 62.101, 37.8942, 76.5454, 38.9121)
    ..cubicTo(76.5454, 38.9121, 77.2151, 54.3098, 77.2151, 54.3098)
    ..cubicTo(77.219, 54.4027, 77.2347, 54.492, 77.2622, 54.5812)
    ..cubicTo(77.2622, 54.5812, 82.203, 70.3897, 82.203, 70.3897)
    ..cubicTo(82.248, 70.5361, 82.3234, 70.6682, 82.4234, 70.7825)
    ..cubicTo(84.0206, 72.572, 98.1235, 88.4983, 102.342, 96.5382)
    ..cubicTo(105.917, 105.585, 113.316, 127.119, 116.459, 137.256)
    ..cubicTo(116.491, 137.359, 116.54, 137.459, 116.604, 137.552)
    ..cubicTo(123.952, 148.01, 131.219, 158.843, 138.777, 170.187)
    ..cubicTo(86.4322, 204.736, 30.4702, 241.528, -22.4715, 275.206)
    ..cubicTo(-23.1352, 274.031, -23.7895, 272.863, -24.4238, 271.717)
    ..cubicTo(-24.4238, 271.717, -24.4238, 271.717, -24.4238, 271.717)
    ..close();

  static final Path __path42_1_3 = Path()
    ..moveTo(258.975, 238.05)
    ..cubicTo(262.085, 240.518, 265.23, 243.1, 268.279, 245.765)
    ..cubicTo(268.279, 245.765, 266.304, 249.965, 266.304, 249.965)
    ..cubicTo(266.111, 250.368, 266.197, 250.851, 266.511, 251.165)
    ..cubicTo(266.511, 251.165, 268.983, 253.637, 268.983, 253.637)
    ..cubicTo(269.187, 253.84, 269.455, 253.947, 269.733, 253.947)
    ..cubicTo(269.851, 253.947, 269.969, 253.929, 270.083, 253.887)
    ..cubicTo(270.083, 253.887, 275.023, 252.158, 275.023, 252.158)
    ..cubicTo(275.066, 252.144, 275.101, 252.126, 275.141, 252.104)
    ..cubicTo(280.27, 257.155, 284.745, 262.394, 287.77, 267.631)
    ..cubicTo(288.438, 269.977, 289.481, 273.485, 290.628, 277.331)
    ..cubicTo(290.628, 277.331, 290.21, 283.996, 290.21, 283.996)
    ..cubicTo(290.21, 283.996, 282.191, 296.026, 282.191, 296.026)
    ..cubicTo(282.141, 296.101, 282.106, 296.176, 282.077, 296.258)
    ..cubicTo(281.606, 296.383, 281.13, 296.511, 280.659, 296.636)
    ..cubicTo(280.659, 296.636, 264.103, 298.262, 264.103, 298.262)
    ..cubicTo(264.103, 298.262, 242.746, 294.054, 242.746, 294.054)
    ..cubicTo(240.891, 292.708, 226.011, 281.882, 224.888, 281.067)
    ..cubicTo(223.462, 279.628, 222.048, 278.164, 220.641, 276.685)
    ..cubicTo(230.817, 266.338, 250.417, 246.565, 258.975, 238.05)
    ..cubicTo(258.975, 238.05, 258.975, 238.05, 258.975, 238.05)
    ..close();

  static final Path __path42_1_4 = Path()
    ..moveTo(163.669, 156.289)
    ..cubicTo(168.685, 152.978, 173.632, 149.71, 178.524, 146.482)
    ..cubicTo(182.168, 152.271, 185.772, 157.715, 189.367, 162.651)
    ..cubicTo(192.228, 166.119, 202.085, 173.28, 207.974, 177.563)
    ..cubicTo(209.043, 178.338, 209.967, 179.009, 210.673, 179.534)
    ..cubicTo(216.73, 187.678, 237.487, 216.976, 244.408, 226.817)
    ..cubicTo(244.471, 226.906, 244.547, 226.984, 244.634, 227.052)
    ..cubicTo(244.634, 227.052, 246.47, 228.442, 246.47, 228.442)
    ..cubicTo(246.47, 228.442, 249.923, 243.732, 249.923, 243.732)
    ..cubicTo(249.945, 243.829, 249.988, 243.914, 250.033, 243.997)
    ..cubicTo(240.382, 253.679, 227.014, 267.181, 219.178, 275.149)
    ..cubicTo(191.85, 246.1, 167.865, 210.065, 144.621, 175.137)
    ..cubicTo(143.649, 173.677, 142.684, 172.226, 141.722, 170.784)
    ..cubicTo(149.118, 165.901, 156.441, 161.065, 163.669, 156.289)
    ..cubicTo(163.669, 156.289, 163.669, 156.289, 163.669, 156.289)
    ..close();

  static final Path __path42_1_5 = Path()
    ..moveTo(235.548, 134.959)
    ..cubicTo(235.609, 135.038, 235.68, 135.106, 235.76, 135.166)
    ..cubicTo(235.76, 135.166, 250.089, 145.542, 250.089, 145.542)
    ..cubicTo(250.19, 145.614, 250.303, 145.667, 250.423, 145.703)
    ..cubicTo(250.423, 145.703, 266.233, 150.15, 266.233, 150.15)
    ..cubicTo(266.333, 150.178, 266.433, 150.196, 266.533, 150.189)
    ..cubicTo(266.533, 150.189, 313.965, 149.696, 313.965, 149.696)
    ..cubicTo(314.051, 149.693, 314.14, 149.682, 314.226, 149.66)
    ..cubicTo(314.226, 149.66, 329.049, 145.706, 329.049, 145.706)
    ..cubicTo(329.163, 145.678, 329.27, 145.628, 329.367, 145.564)
    ..cubicTo(339.625, 138.717, 342.293, 136.741, 345.396, 132.188)
    ..cubicTo(379.131, 155.564, 402.969, 209.362, 423.985, 257.294)
    ..cubicTo(396.261, 263.491, 363.141, 273.081, 331.07, 282.371)
    ..cubicTo(322.834, 284.757, 314.808, 287.079, 307.072, 289.289)
    ..cubicTo(307.04, 289.272, 307.015, 289.243, 306.983, 289.225)
    ..cubicTo(306.983, 289.225, 296.607, 284.511, 296.607, 284.511)
    ..cubicTo(296.607, 284.511, 293.749, 269.974, 293.749, 269.974)
    ..cubicTo(293.732, 269.899, 293.71, 269.824, 293.678, 269.749)
    ..cubicTo(290.663, 262.952, 282.959, 254.083, 277.155, 248.429)
    ..cubicTo(277.155, 248.429, 276.219, 241.625, 276.219, 241.625)
    ..cubicTo(276.166, 241.253, 275.927, 240.957, 275.605, 240.811)
    ..cubicTo(275.605, 240.811, 275.712, 239.978, 275.712, 239.978)
    ..cubicTo(275.712, 239.978, 268.151, 239.032, 268.151, 239.032)
    ..cubicTo(268.151, 239.032, 261.814, 232.996, 261.814, 232.996)
    ..cubicTo(261.814, 232.996, 264.714, 225.263, 264.714, 225.263)
    ..cubicTo(264.714, 225.263, 264.371, 225.131, 264.371, 225.131)
    ..cubicTo(264.371, 225.131, 264.706, 224.295, 264.706, 224.295)
    ..cubicTo(264.923, 223.752, 264.659, 223.134, 264.115, 222.916)
    ..cubicTo(263.572, 222.698, 262.955, 222.963, 262.737, 223.506)
    ..cubicTo(262.737, 223.506, 259.823, 230.792, 259.823, 230.792)
    ..cubicTo(259.823, 230.792, 254.116, 231.078, 254.116, 231.078)
    ..cubicTo(254.116, 231.078, 254.142, 231.603, 254.142, 231.603)
    ..cubicTo(252.191, 230.11, 250.29, 228.67, 248.479, 227.302)
    ..cubicTo(248.479, 227.302, 246.047, 225.459, 246.047, 225.459)
    ..cubicTo(238.991, 215.434, 218.198, 186.085, 212.28, 178.141)
    ..cubicTo(212.218, 178.059, 212.145, 177.984, 212.062, 177.923)
    ..cubicTo(211.336, 177.384, 210.36, 176.673, 209.221, 175.848)
    ..cubicTo(203.794, 171.901, 193.692, 164.562, 191.042, 161.351)
    ..cubicTo(187.489, 156.472, 183.914, 151.071, 180.293, 145.314)
    ..cubicTo(194.607, 135.863, 208.446, 126.733, 222.069, 117.776)
    ..cubicTo(222.069, 117.776, 235.548, 134.959, 235.548, 134.959)
    ..cubicTo(235.548, 134.959, 235.548, 134.959, 235.548, 134.959)
    ..close();

  static final Path __path42_1_6 = Path()
    ..moveTo(556.61, 188.492)
    ..cubicTo(556.61, 188.492, 554.003, 171.873, 554.003, 171.873)
    ..cubicTo(554.003, 171.873, 555.946, 161.511, 555.946, 161.511)
    ..cubicTo(555.992, 161.268, 555.949, 161.018, 555.831, 160.801)
    ..cubicTo(555.831, 160.801, 554.181, 157.836, 554.181, 157.836)
    ..cubicTo(553.995, 157.5, 553.642, 157.293, 553.256, 157.293)
    ..cubicTo(553.256, 157.293, 547.984, 157.293, 547.984, 157.293)
    ..cubicTo(547.838, 157.293, 547.688, 157.325, 547.552, 157.386)
    ..cubicTo(547.552, 157.386, 538.001, 161.668, 538.001, 161.668)
    ..cubicTo(537.708, 161.797, 537.494, 162.051, 537.412, 162.354)
    ..cubicTo(537.412, 162.354, 536.423, 165.98, 536.423, 165.98)
    ..cubicTo(536.33, 166.326, 536.415, 166.697, 536.658, 166.965)
    ..cubicTo(539.008, 169.587, 544.212, 174.269, 547.266, 176.277)
    ..cubicTo(547.709, 177.048, 548.727, 178.691, 551.056, 182.452)
    ..cubicTo(551.056, 182.452, 549.674, 185.217, 549.674, 185.217)
    ..cubicTo(549.413, 185.742, 549.624, 186.378, 550.149, 186.642)
    ..cubicTo(550.149, 186.642, 551.249, 187.192, 551.249, 187.192)
    ..cubicTo(551.249, 187.192, 543.52, 192.985, 543.52, 192.985)
    ..cubicTo(543.52, 192.985, 522.807, 200.754, 522.807, 200.754)
    ..cubicTo(522.807, 200.754, 515.799, 200.118, 515.799, 200.118)
    ..cubicTo(515.742, 200.111, 515.682, 200.111, 515.621, 200.114)
    ..cubicTo(515.621, 200.114, 507.385, 200.775, 507.385, 200.775)
    ..cubicTo(507.192, 200.789, 507.006, 200.861, 506.849, 200.975)
    ..cubicTo(506.849, 200.975, 481.915, 219.105, 481.915, 219.105)
    ..cubicTo(481.915, 219.105, 470.367, 215.459, 470.367, 215.459)
    ..cubicTo(465.092, 203.547, 460.499, 190.749, 455.637, 177.216)
    ..cubicTo(455.527, 176.902, 455.412, 176.588, 455.298, 176.273)
    ..cubicTo(455.405, 176.155, 455.491, 176.023, 455.537, 175.866)
    ..cubicTo(455.537, 175.866, 459.773, 161.747, 459.773, 161.747)
    ..cubicTo(459.813, 161.736, 459.852, 161.729, 459.888, 161.711)
    ..cubicTo(459.888, 161.711, 466.063, 158.993, 466.063, 158.993)
    ..cubicTo(466.599, 158.758, 466.846, 158.132, 466.61, 157.597)
    ..cubicTo(466.374, 157.061, 465.753, 156.815, 465.21, 157.054)
    ..cubicTo(465.21, 157.054, 459.209, 159.693, 459.209, 159.693)
    ..cubicTo(459.209, 159.693, 447.455, 154.896, 447.455, 154.896)
    ..cubicTo(443.172, 143.681, 438.558, 132.645, 433.196, 122.244)
    ..cubicTo(433.479, 121.762, 433.346, 121.144, 432.882, 120.829)
    ..cubicTo(432.882, 120.829, 432.232, 120.39, 432.232, 120.39)
    ..cubicTo(429.521, 115.254, 426.614, 110.282, 423.467, 105.532)
    ..cubicTo(423.467, 105.532, 423.467, 104.91, 423.467, 104.91)
    ..cubicTo(423.467, 104.321, 422.992, 103.85, 422.406, 103.85)
    ..cubicTo(422.385, 103.85, 422.363, 103.853, 422.342, 103.857)
    ..cubicTo(417.631, 96.9525, 412.384, 90.5342, 406.423, 84.7944)
    ..cubicTo(406.423, 84.7944, 406.394, 84.823, 406.394, 84.823)
    ..cubicTo(406.058, 84.5158, 405.394, 84.0372, 404.094, 83.1014)
    ..cubicTo(404.094, 83.1014, 392.147, 74.4864, 392.147, 74.4864)
    ..cubicTo(391.979, 74.365, 391.782, 74.2971, 391.575, 74.2864)
    ..cubicTo(383.792, 73.9185, 364.705, 74.8114, 350.611, 75.5686)
    ..cubicTo(350.168, 71.554, 349.647, 68.5895, 349.011, 67.1716)
    ..cubicTo(349.011, 67.1716, 348.972, 67.193, 348.972, 67.193)
    ..cubicTo(348.74, 66.7501, 348.222, 66.0215, 347.211, 64.5964)
    ..cubicTo(347.211, 64.5964, 338.039, 51.6739, 338.039, 51.6739)
    ..cubicTo(337.924, 51.5096, 337.764, 51.381, 337.578, 51.306)
    ..cubicTo(337.578, 51.306, 330.331, 48.3415, 330.331, 48.3415)
    ..cubicTo(330.159, 48.27, 329.97, 48.2486, 329.784, 48.2736)
    ..cubicTo(329.784, 48.2736, 308.483, 51.2238, 308.483, 51.2238)
    ..cubicTo(308.483, 51.2238, 289.338, 49.9237, 289.338, 49.9237)
    ..cubicTo(289.338, 49.9237, 268.187, 40.8158, 268.187, 40.8158)
    ..cubicTo(268.187, 40.8158, 254.03, 31.1615, 254.03, 31.1615)
    ..cubicTo(254.03, 31.1615, 245.039, 10.6099, 245.039, 10.6099)
    ..cubicTo(245.039, 10.6099, 246.318, -3.1413, 246.318, -3.1413)
    ..cubicTo(246.318, -3.1413, 251.54, -17.1745, 251.54, -17.1745)
    ..cubicTo(251.663, -17.5067, 251.612, -17.8782, 251.403, -18.1675)
    ..cubicTo(246.988, -24.2358, 246.306, -24.643, 240.997, -27.8076)
    ..cubicTo(240.997, -27.8076, 239.781, -28.5326, 239.781, -28.5326)
    ..cubicTo(236.797, -33.3259, 232.681, -40.08, 228.517, -46.977)
    ..cubicTo(228.517, -46.977, 235.718, -52.6131, 235.718, -52.6131)
    ..cubicTo(235.842, -52.7096, 235.943, -52.831, 236.013, -52.9739)
    ..cubicTo(236.013, -52.9739, 241.283, -63.514, 241.283, -63.514)
    ..cubicTo(241.352, -63.6497, 241.39, -63.7997, 241.395, -63.9569)
    ..cubicTo(241.395, -63.9569, 242.374, -96.6024, 242.374, -96.6024)
    ..cubicTo(242.374, -96.6024, 252.756, -112.825, 252.756, -112.825)
    ..cubicTo(252.869, -113, 252.927, -113.204, 252.924, -113.411)
    ..cubicTo(252.924, -113.411, 252.241, -157.554, 252.241, -157.554)
    ..cubicTo(265.184, -157.036, 277.537, -156.132, 286.627, -154.836)
    ..cubicTo(287.213, -154.753, 287.745, -155.157, 287.827, -155.736)
    ..cubicTo(287.91, -156.318, 287.506, -156.854, 286.927, -156.936)
    ..cubicTo(277.752, -158.243, 265.271, -159.154, 252.208, -159.675)
    ..cubicTo(252.208, -159.675, 251.935, -177.312, 251.935, -177.312)
    ..cubicTo(251.926, -177.895, 251.454, -178.359, 250.876, -178.359)
    ..cubicTo(250.87, -178.359, 250.864, -178.359, 250.859, -178.359)
    ..cubicTo(250.273, -178.348, 249.806, -177.866, 249.815, -177.28)
    ..cubicTo(249.815, -177.28, 250.086, -159.757, 250.086, -159.757)
    ..cubicTo(232.136, -160.418, 213.368, -160.35, 200.743, -159.579)
    ..cubicTo(200.548, -159.568, 200.36, -159.504, 200.2, -159.39)
    ..cubicTo(200.2, -159.39, 183.9, -147.982, 183.9, -147.982)
    ..cubicTo(178.582, -146.881, 146.692, -148.449, 127.547, -149.389)
    ..cubicTo(120.719, -149.725, 115.326, -149.989, 113.21, -150.028)
    ..cubicTo(113.16, -150.032, 113.105, -150.028, 113.053, -150.021)
    ..cubicTo(97.2563, -147.971, 76.5657, -141.381, 58.4361, -133.109)
    ..cubicTo(51.1644, -148.867, 44.0117, -164.14, 37.479, -177.677)
    ..cubicTo(37.2236, -178.202, 36.5897, -178.423, 36.0632, -178.17)
    ..cubicTo(35.5356, -177.916, 35.3146, -177.28, 35.5689, -176.755)
    ..cubicTo(42.0958, -163.229, 49.2432, -147.967, 56.5106, -132.223)
    ..cubicTo(48.3177, -128.391, 40.7121, -124.233, 34.4113, -120.015)
    ..cubicTo(34.1016, -119.911, 33.8762, -119.522, 32.9515, -117.933)
    ..cubicTo(32.9515, -117.933, 27.9486, -109.318, 27.9486, -109.318)
    ..cubicTo(27.8857, -109.207, 27.8422, -109.089, 27.8207, -108.964)
    ..cubicTo(27.8207, -108.964, 24.1972, -87.8838, 24.1972, -87.8838)
    ..cubicTo(24.189, -87.8338, 24.184, -87.7838, 24.1826, -87.7338)
    ..cubicTo(24.1826, -87.7338, 23.5236, -65.007, 23.5236, -65.007)
    ..cubicTo(23.5229, -64.9784, 23.5232, -64.9498, 23.5247, -64.9213)
    ..cubicTo(24.1747, -52.4845, 41.5693, -11.3848, 49.5021, -1.0911)
    ..cubicTo(49.5021, -1.0911, 48.5942, 6.7774, 48.5942, 6.7774)
    ..cubicTo(48.5942, 6.7774, 48.1367, 7.4381, 48.1367, 7.4381)
    ..cubicTo(47.6888, 7.3667, 47.2277, 7.5846, 47.0176, 8.0132)
    ..cubicTo(46.8573, 8.3418, 46.8819, 8.7096, 47.0505, 9.0061)
    ..cubicTo(47.0505, 9.0061, 45.9461, 10.6027, 45.9461, 10.6027)
    ..cubicTo(41.7833, 12.5279, 32.5386, 17.314, 29.2737, 19.4499)
    ..cubicTo(29.1498, 19.532, 29.0441, 19.6356, 28.9637, 19.7606)
    ..cubicTo(26.7785, 23.1394, 24.214, 26.5397, 21.4131, 29.94)
    ..cubicTo(1.1532, 26.5968, -23.2784, 21.875, -52.7279, 15.2281)
    ..cubicTo(-52.7279, 15.2281, -70.3516, 3.4807, -70.3516, 3.4807)
    ..cubicTo(-70.8395, 3.1557, -71.4974, 3.2879, -71.8217, 3.7736)
    ..cubicTo(-72.1466, 4.2594, -72.015, 4.9201, -71.5278, 5.2451)
    ..cubicTo(-71.5278, 5.2451, -53.7409, 17.1032, -53.7409, 17.1032)
    ..cubicTo(-53.633, 17.1747, -53.513, 17.2247, -53.3862, 17.2532)
    ..cubicTo(-35.1554, 21.3679, -8.4458, 27.1897, 19.7933, 31.8758)
    ..cubicTo(14.3711, 38.2621, 8.193, 44.6376, 2.1372, 50.8881)
    ..cubicTo(-7.7293, 61.0675, -17.9315, 71.5933, -24.7257, 82.012)
    ..cubicTo(-24.7864, 82.1049, -24.8303, 82.2049, -24.8592, 82.3085)
    ..cubicTo(-24.9632, 82.6585, -26.8287, 88.8769, -26.8287, 88.8769)
    ..cubicTo(-26.8587, 88.9733, -26.874, 89.0769, -26.8737, 89.1805)
    ..cubicTo(-26.8737, 89.1805, -26.544, 271.995, -26.544, 271.995)
    ..cubicTo(-26.5437, 272.174, -26.4983, 272.349, -26.4115, 272.506)
    ..cubicTo(-25.7154, 273.763, -24.995, 275.049, -24.2631, 276.346)
    ..cubicTo(-40.3566, 286.575, -56.1669, 296.515, -71.4978, 306.005)
    ..cubicTo(-71.9954, 306.312, -72.1493, 306.966, -71.8411, 307.466)
    ..cubicTo(-71.6407, 307.791, -71.2937, 307.966, -70.9386, 307.966)
    ..cubicTo(-70.7481, 307.966, -70.5555, 307.916, -70.3816, 307.809)
    ..cubicTo(-55.0727, 298.333, -39.2861, 288.407, -23.218, 278.192)
    ..cubicTo(-6.5231, 307.523, 18.6093, 345.755, 42.9641, 382.804)
    ..cubicTo(44.7392, 385.504, 46.5012, 388.187, 48.2552, 390.855)
    ..cubicTo(28.3618, 399.781, 9.8768, 407.974, -4.7112, 414.439)
    ..cubicTo(-4.7112, 414.439, -5.1616, 414.639, -5.1616, 414.639)
    ..cubicTo(-5.1616, 414.639, -5.1541, 414.653, -5.1541, 414.653)
    ..cubicTo(-5.7102, 414.757, -6.5406, 414.957, -7.815, 415.271)
    ..cubicTo(-7.815, 415.271, -70.8627, 430.715, -70.8627, 430.715)
    ..cubicTo(-71.4315, 430.854, -71.7795, 431.43, -71.6402, 431.997)
    ..cubicTo(-71.5215, 432.483, -71.0884, 432.808, -70.6111, 432.808)
    ..cubicTo(-70.5276, 432.808, -70.4426, 432.798, -70.3581, 432.776)
    ..cubicTo(-69.7024, 432.615, -4.7983, 416.714, -4.4829, 416.639)
    ..cubicTo(-4.4215, 416.621, -4.3604, 416.603, -4.3022, 416.575)
    ..cubicTo(-4.3022, 416.575, -3.8518, 416.378, -3.8518, 416.378)
    ..cubicTo(10.8147, 409.878, 29.418, 401.631, 49.4346, 392.651)
    ..cubicTo(66.7064, 418.95, 82.7359, 443.534, 94.4318, 463.15)
    ..cubicTo(94.4318, 463.15, 95.2137, 465.539, 95.2137, 465.539)
    ..cubicTo(95.2137, 465.539, 88.2017, 487.213, 88.2017, 487.213)
    ..cubicTo(83.9424, 488.916, 79.7164, 490.591, 75.5442, 492.245)
    ..cubicTo(75.5442, 492.245, 69.2362, 494.745, 69.2362, 494.745)
    ..cubicTo(68.6923, 494.963, 68.4265, 495.578, 68.6426, 496.12)
    ..cubicTo(68.8076, 496.538, 69.2062, 496.792, 69.628, 496.792)
    ..cubicTo(69.758, 496.792, 69.8906, 496.767, 70.0191, 496.717)
    ..cubicTo(70.0191, 496.717, 73.038, 495.52, 73.038, 495.52)
    ..cubicTo(72.9987, 495.71, 73.0094, 495.913, 73.0844, 496.11)
    ..cubicTo(73.2462, 496.531, 73.648, 496.792, 74.0752, 496.792)
    ..cubicTo(74.2009, 496.792, 74.3288, 496.77, 74.4538, 496.72)
    ..cubicTo(74.4538, 496.72, 79.5438, 494.774, 79.5438, 494.774)
    ..cubicTo(83.4442, 493.284, 87.3945, 491.777, 91.3759, 490.238)
    ..cubicTo(91.3759, 490.238, 103.254, 497.028, 103.254, 497.028)
    ..cubicTo(103.254, 497.028, 116.151, 480.319, 116.151, 480.319)
    ..cubicTo(127.702, 475.465, 139.218, 470.218, 150.286, 464.336)
    ..cubicTo(150.286, 464.336, 164.298, 465.829, 164.298, 465.829)
    ..cubicTo(164.298, 465.829, 168.781, 453.574, 168.781, 453.574)
    ..cubicTo(179.513, 446.695, 189.517, 439.016, 198.342, 430.276)
    ..cubicTo(198.365, 430.254, 198.387, 430.233, 198.408, 430.208)
    ..cubicTo(200.477, 427.747, 202.612, 425.368, 204.779, 423.025)
    ..cubicTo(204.787, 423.043, 204.791, 423.061, 204.8, 423.079)
    ..cubicTo(204.986, 423.45, 205.36, 423.665, 205.749, 423.665)
    ..cubicTo(205.909, 423.665, 206.07, 423.629, 206.223, 423.554)
    ..cubicTo(206.898, 423.215, 213.626, 420.832, 217.709, 419.407)
    ..cubicTo(217.949, 419.325, 218.151, 419.157, 218.278, 418.936)
    ..cubicTo(218.278, 418.936, 222.972, 410.781, 222.972, 410.781)
    ..cubicTo(223.086, 410.585, 223.133, 410.356, 223.107, 410.131)
    ..cubicTo(223.107, 410.131, 222.615, 405.867, 222.615, 405.867)
    ..cubicTo(242.193, 389.037, 264.477, 375.564, 288.07, 363.963)
    ..cubicTo(288.07, 363.963, 309.172, 359.049, 309.172, 359.049)
    ..cubicTo(309.172, 359.049, 319.309, 369.182, 319.309, 369.182)
    ..cubicTo(319.351, 369.335, 319.394, 369.492, 319.437, 369.65)
    ..cubicTo(322.473, 380.515, 325.216, 390.323, 328.488, 399.781)
    ..cubicTo(328.488, 399.781, 328.952, 421.147, 328.952, 421.147)
    ..cubicTo(328.956, 421.257, 328.974, 421.364, 329.009, 421.472)
    ..cubicTo(329.009, 421.472, 331.235, 427.894, 331.235, 427.894)
    ..cubicTo(331.277, 428.022, 331.349, 428.144, 331.438, 428.244)
    ..cubicTo(331.438, 428.244, 333.167, 430.222, 333.167, 430.222)
    ..cubicTo(333.313, 430.387, 333.506, 430.504, 333.72, 430.554)
    ..cubicTo(333.72, 430.554, 337.921, 431.544, 337.921, 431.544)
    ..cubicTo(338.003, 431.562, 338.082, 431.572, 338.164, 431.572)
    ..cubicTo(338.21, 431.572, 338.26, 431.569, 338.307, 431.562)
    ..cubicTo(338.307, 431.562, 342.489, 430.994, 342.489, 430.994)
    ..cubicTo(353.193, 449.702, 369.448, 470.09, 397.454, 497.478)
    ..cubicTo(397.661, 497.678, 397.929, 497.781, 398.197, 497.781)
    ..cubicTo(398.472, 497.781, 398.747, 497.674, 398.954, 497.46)
    ..cubicTo(399.279, 497.128, 399.329, 496.642, 399.133, 496.249)
    ..cubicTo(399.229, 496.278, 399.329, 496.295, 399.429, 496.295)
    ..cubicTo(399.683, 496.295, 399.937, 496.206, 400.14, 496.024)
    ..cubicTo(400.576, 495.631, 400.612, 494.963, 400.219, 494.527)
    ..cubicTo(396.49, 490.388, 392.997, 486.523, 389.729, 482.905)
    ..cubicTo(365.284, 455.853, 353.211, 442.491, 345.282, 428.886)
    ..cubicTo(345.282, 428.886, 349.472, 421.132, 349.472, 421.132)
    ..cubicTo(349.59, 420.922, 349.625, 420.675, 349.582, 420.436)
    ..cubicTo(349.582, 420.436, 348.961, 417.118, 348.961, 417.118)
    ..cubicTo(349.097, 416.878, 349.143, 416.593, 349.072, 416.321)
    ..cubicTo(348.986, 416.007, 348.765, 415.75, 348.465, 415.621)
    ..cubicTo(348.465, 415.621, 347.986, 415.414, 347.986, 415.414)
    ..cubicTo(347.986, 415.414, 337.624, 405.97, 337.624, 405.97)
    ..cubicTo(337.624, 405.97, 325.191, 360.638, 325.191, 360.638)
    ..cubicTo(325.191, 360.638, 327.681, 353.627, 327.681, 353.627)
    ..cubicTo(327.681, 353.627, 349.129, 339.244, 349.129, 339.244)
    ..cubicTo(349.618, 338.918, 349.747, 338.261, 349.422, 337.776)
    ..cubicTo(349.418, 337.772, 349.418, 337.772, 349.418, 337.772)
    ..cubicTo(357.094, 334.815, 364.78, 331.911, 372.438, 329.025)
    ..cubicTo(393.232, 321.178, 414.563, 313.131, 434.857, 304.209)
    ..cubicTo(434.857, 304.209, 450.019, 312.72, 450.019, 312.72)
    ..cubicTo(450.194, 313.041, 450.373, 313.37, 450.551, 313.684)
    ..cubicTo(450.676, 313.913, 450.88, 314.066, 451.109, 314.152)
    ..cubicTo(459.238, 330.454, 468.639, 350.362, 478.586, 371.425)
    ..cubicTo(492.53, 400.956, 506.949, 431.49, 518.757, 453.896)
    ..cubicTo(520.368, 458.95, 522.85, 469.24, 523.129, 474.051)
    ..cubicTo(523.129, 474.054, 523.129, 474.054, 523.129, 474.058)
    ..cubicTo(523.136, 474.208, 523.568, 481.98, 523.618, 482.862)
    ..cubicTo(523.618, 482.862, 522.389, 495.381, 522.389, 495.381)
    ..cubicTo(522.332, 495.963, 522.761, 496.481, 523.343, 496.538)
    ..cubicTo(523.379, 496.542, 523.414, 496.546, 523.446, 496.546)
    ..cubicTo(523.986, 496.546, 524.447, 496.135, 524.5, 495.588)
    ..cubicTo(524.5, 495.588, 525.736, 482.987, 525.736, 482.987)
    ..cubicTo(525.743, 482.934, 525.743, 482.88, 525.739, 482.826)
    ..cubicTo(525.739, 482.826, 525.322, 475.322, 525.322, 475.322)
    ..cubicTo(525.289, 474.737, 525.264, 474.279, 525.214, 473.933)
    ..cubicTo(525.214, 473.933, 525.243, 473.929, 525.243, 473.929)
    ..cubicTo(524.932, 468.472, 522.193, 457.675, 520.75, 453.163)
    ..cubicTo(520.732, 453.103, 520.707, 453.046, 520.678, 452.992)
    ..cubicTo(508.881, 430.619, 494.455, 400.066, 480.504, 370.521)
    ..cubicTo(470.474, 349.284, 460.999, 329.214, 452.816, 312.82)
    ..cubicTo(452.923, 312.477, 452.844, 312.102, 452.616, 311.831)
    ..cubicTo(452.616, 311.831, 452.616, 301.994, 452.616, 301.994)
    ..cubicTo(452.616, 301.994, 455.134, 295.361, 455.134, 295.361)
    ..cubicTo(458.02, 293.54, 464.177, 287.043, 469.767, 281.042)
    ..cubicTo(470.749, 279.989, 471.557, 279.121, 472.085, 278.574)
    ..cubicTo(472.171, 278.481, 472.246, 278.374, 472.296, 278.256)
    ..cubicTo(472.296, 278.256, 477.482, 266.152, 477.482, 266.152)
    ..cubicTo(477.514, 266.08, 477.536, 266.005, 477.55, 265.93)
    ..cubicTo(477.55, 265.93, 479.775, 254.072, 479.775, 254.072)
    ..cubicTo(479.789, 253.99, 479.793, 253.908, 479.789, 253.822)
    ..cubicTo(479.789, 253.822, 479.339, 244.614, 479.339, 244.614)
    ..cubicTo(479.414, 244.511, 479.472, 244.4, 479.507, 244.275)
    ..cubicTo(479.507, 244.275, 485.079, 223.931, 485.079, 223.931)
    ..cubicTo(485.079, 223.931, 514.071, 206.29, 514.071, 206.29)
    ..cubicTo(514.071, 206.29, 526.329, 207.254, 526.329, 207.254)
    ..cubicTo(526.461, 207.265, 526.597, 207.251, 526.725, 207.208)
    ..cubicTo(526.725, 207.208, 537.101, 203.997, 537.101, 203.997)
    ..cubicTo(537.658, 203.825, 537.973, 203.229, 537.798, 202.672)
    ..cubicTo(537.626, 202.111, 537.03, 201.8, 536.472, 201.972)
    ..cubicTo(536.472, 201.972, 526.29, 205.126, 526.29, 205.126)
    ..cubicTo(526.29, 205.126, 518.839, 204.54, 518.839, 204.54)
    ..cubicTo(518.839, 204.54, 524.6, 204.54, 524.6, 204.54)
    ..cubicTo(524.725, 204.54, 524.85, 204.518, 524.964, 204.472)
    ..cubicTo(524.964, 204.472, 543.741, 197.557, 543.741, 197.557)
    ..cubicTo(543.816, 197.529, 543.884, 197.493, 543.952, 197.45)
    ..cubicTo(543.952, 197.45, 556.138, 189.546, 556.138, 189.546)
    ..cubicTo(556.488, 189.317, 556.674, 188.906, 556.61, 188.492)
    ..cubicTo(556.61, 188.492, 556.61, 188.492, 556.61, 188.492)
    ..close();

  static final Path __path42_1_7 = Path()
    ..moveTo(52.927, 227.57)
    ..cubicTo(53.0356, 227.57, 53.1463, 227.545, 53.2499, 227.492)
    ..cubicTo(53.5967, 227.313, 53.7331, 226.885, 53.5545, 226.538)
    ..cubicTo(47.538, 214.855, 37.4618, 190.299, 33.1679, 178.527)
    ..cubicTo(33.0343, 178.163, 32.6296, 177.973, 32.2618, 178.106)
    ..cubicTo(31.8949, 178.241, 31.706, 178.649, 31.8399, 179.013)
    ..cubicTo(36.146, 190.817, 46.2561, 215.455, 52.2977, 227.185)
    ..cubicTo(52.423, 227.431, 52.6702, 227.57, 52.927, 227.57)
    ..cubicTo(52.927, 227.57, 52.927, 227.57, 52.927, 227.57)
    ..close();

  static final Path __path42_1_8 = Path()
    ..moveTo(301.302, 177.723)
    ..cubicTo(289.719, 178.23, 277.343, 178.483, 265.219, 178.362)
    ..cubicTo(265.219, 178.362, 265.742, 148.245, 265.742, 148.245)
    ..cubicTo(265.742, 148.245, 271.331, 128.436, 271.331, 128.436)
    ..cubicTo(271.331, 128.436, 284.365, 130.394, 284.365, 130.394)
    ..cubicTo(284.4, 130.397, 284.436, 130.401, 284.472, 130.401)
    ..cubicTo(284.5, 130.401, 284.533, 130.397, 284.561, 130.394)
    ..cubicTo(284.561, 130.394, 292.197, 129.397, 292.197, 129.397)
    ..cubicTo(292.197, 129.397, 305.631, 126.447, 305.631, 126.447)
    ..cubicTo(305.631, 126.447, 305.838, 126.447, 305.838, 126.447)
    ..cubicTo(305.838, 126.447, 306.163, 148.431, 306.163, 148.431)
    ..cubicTo(306.056, 149.292, 305.599, 151.778, 305.023, 154.91)
    ..cubicTo(303.173, 165.007, 301.852, 172.719, 301.302, 177.723)
    ..cubicTo(301.302, 177.723, 301.302, 177.723, 301.302, 177.723)
    ..close();

  static final Path __path42_1_9 = Path()
    ..moveTo(98.6514, 193.56)
    ..cubicTo(99.2472, 194.87, 99.5561, 195.549, 99.7669, 195.903)
    ..cubicTo(99.7669, 195.903, 99.729, 195.924, 99.729, 195.924)
    ..cubicTo(102.935, 201.532, 106.823, 207.493, 111.059, 213.518)
    ..cubicTo(110.813, 213.758, 110.76, 214.136, 110.964, 214.426)
    ..cubicTo(111.101, 214.622, 111.32, 214.726, 111.541, 214.726)
    ..cubicTo(111.649, 214.726, 111.754, 214.693, 111.854, 214.643)
    ..cubicTo(114.372, 218.194, 117, 221.758, 119.679, 225.284)
    ..cubicTo(119.679, 225.284, 93.6825, 241.881, 93.6825, 241.881)
    ..cubicTo(88.4363, 232.42, 81.7183, 222.351, 75.6285, 213.229)
    ..cubicTo(72.544, 208.611, 69.6309, 204.246, 67.0171, 200.142)
    ..cubicTo(62.221, 192.338, 53.0406, 170.919, 46.559, 155.389)
    ..cubicTo(51.0751, 153.506, 55.5872, 151.631, 60.0844, 149.763)
    ..cubicTo(65.372, 147.57, 70.6085, 145.395, 75.7999, 143.223)
    ..cubicTo(75.7999, 143.223, 98.6514, 193.56, 98.6514, 193.56)
    ..cubicTo(98.6514, 193.56, 98.6514, 193.56, 98.6514, 193.56)
    ..close();

  static final Path __path42_1_10 = Path()
    ..moveTo(550.115, 385.929)
    ..cubicTo(550.115, 385.929, 532.66, 381.978, 532.66, 381.978)
    ..cubicTo(532.603, 381.964, 532.542, 381.957, 532.485, 381.961)
    ..cubicTo(532.485, 381.961, 520.627, 382.289, 520.627, 382.289)
    ..cubicTo(520.58, 382.289, 520.537, 382.296, 520.494, 382.307)
    ..cubicTo(520.48, 382.311, 520.466, 382.314, 520.448, 382.314)
    ..cubicTo(520.409, 382.307, 520.369, 382.289, 520.327, 382.289)
    ..cubicTo(520.159, 382.289, 520.012, 382.35, 519.891, 382.446)
    ..cubicTo(508.229, 385.079, 495.71, 390.465, 483.591, 395.683)
    ..cubicTo(475.916, 398.991, 468.094, 402.359, 460.382, 405.08)
    ..cubicTo(460.382, 405.08, 460.082, 396.147, 460.082, 396.147)
    ..cubicTo(460.082, 396.097, 460.075, 396.047, 460.065, 396.001)
    ..cubicTo(460.065, 396.001, 457.1, 384.143, 457.1, 384.143)
    ..cubicTo(457.075, 384.046, 457.032, 383.957, 456.971, 383.879)
    ..cubicTo(456.971, 383.879, 450.053, 374.985, 450.053, 374.985)
    ..cubicTo(449.992, 374.906, 449.914, 374.842, 449.824, 374.792)
    ..cubicTo(441.552, 370.477, 423.965, 362.609, 415.34, 359.023)
    ..cubicTo(412.014, 355.112, 410.628, 353.483, 409.986, 352.801)
    ..cubicTo(409.243, 349.329, 408.014, 345.458, 406.385, 341.264)
    ..cubicTo(406.385, 341.264, 450.825, 323.927, 450.825, 323.927)
    ..cubicTo(450.825, 323.927, 456.786, 334.592, 456.786, 334.592)
    ..cubicTo(456.968, 334.921, 457.379, 335.046, 457.718, 334.878)
    ..cubicTo(457.718, 334.878, 461.672, 332.903, 461.672, 332.903)
    ..cubicTo(462.018, 332.728, 462.161, 332.303, 461.986, 331.953)
    ..cubicTo(461.811, 331.603, 461.386, 331.464, 461.04, 331.639)
    ..cubicTo(461.04, 331.639, 457.689, 333.314, 457.689, 333.314)
    ..cubicTo(457.689, 333.314, 451.76, 322.702, 451.76, 322.702)
    ..cubicTo(451.585, 322.391, 451.214, 322.259, 450.885, 322.388)
    ..cubicTo(450.885, 322.388, 405.864, 339.95, 405.864, 339.95)
    ..cubicTo(394.02, 310.526, 363.057, 266.019, 336.89, 230.127)
    ..cubicTo(352.777, 227.77, 368.289, 224.919, 382.49, 220.958)
    ..cubicTo(382.49, 220.958, 382.473, 220.898, 382.473, 220.898)
    ..cubicTo(382.937, 220.726, 383.808, 220.222, 385.691, 219.14)
    ..cubicTo(385.691, 219.14, 402.088, 209.689, 402.088, 209.689)
    ..cubicTo(402.088, 209.689, 401.381, 208.464, 401.381, 208.464)
    ..cubicTo(401.196, 208.572, 383.326, 218.869, 382.023, 219.619)
    ..cubicTo(367.7, 223.612, 352.013, 226.469, 335.951, 228.837)
    ..cubicTo(329.847, 220.476, 324.021, 212.6, 318.785, 205.525)
    ..cubicTo(312.267, 196.713, 306.638, 189.102, 302.541, 183.359)
    ..cubicTo(302.288, 182.902, 302.33, 181.309, 302.555, 179.069)
    ..cubicTo(315.039, 178.487, 326.061, 177.658, 333.951, 176.84)
    ..cubicTo(333.951, 176.84, 333.951, 176.823, 333.951, 176.823)
    ..cubicTo(334.279, 176.719, 334.926, 176.276, 336.751, 175.022)
    ..cubicTo(336.751, 175.022, 350.091, 165.85, 350.091, 165.85)
    ..cubicTo(350.141, 165.818, 350.184, 165.779, 350.224, 165.732)
    ..cubicTo(350.224, 165.732, 365.375, 148.274, 365.375, 148.274)
    ..cubicTo(365.632, 147.977, 365.6, 147.534, 365.307, 147.277)
    ..cubicTo(365.01, 147.02, 364.564, 147.052, 364.31, 147.349)
    ..cubicTo(364.31, 147.349, 349.216, 164.736, 349.216, 164.736)
    ..cubicTo(348.109, 165.497, 335.151, 174.408, 333.629, 175.451)
    ..cubicTo(324.85, 176.358, 314.196, 177.133, 302.713, 177.658)
    ..cubicTo(303.495, 171.086, 305.416, 160.611, 306.416, 155.167)
    ..cubicTo(307.027, 151.824, 307.47, 149.413, 307.574, 148.552)
    ..cubicTo(307.577, 148.52, 307.577, 148.492, 307.577, 148.46)
    ..cubicTo(307.577, 148.46, 307.252, 126.447, 307.252, 126.447)
    ..cubicTo(307.252, 126.447, 319.718, 126.447, 319.718, 126.447)
    ..cubicTo(319.875, 126.447, 320.025, 126.397, 320.15, 126.301)
    ..cubicTo(321.753, 125.051, 325.236, 120.425, 327.129, 117.907)
    ..cubicTo(330.304, 120.386, 333.576, 122.907, 336.855, 125.433)
    ..cubicTo(341.148, 128.729, 344.541, 131.337, 345.938, 132.537)
    ..cubicTo(346.07, 132.651, 346.234, 132.708, 346.398, 132.708)
    ..cubicTo(346.595, 132.708, 346.795, 132.623, 346.934, 132.462)
    ..cubicTo(347.188, 132.165, 347.152, 131.719, 346.855, 131.465)
    ..cubicTo(345.434, 130.24, 342.03, 127.622, 337.719, 124.311)
    ..cubicTo(334.879, 122.129, 331.504, 119.532, 327.947, 116.757)
    ..cubicTo(328.05, 116.475, 327.972, 116.15, 327.718, 115.957)
    ..cubicTo(327.472, 115.768, 327.143, 115.775, 326.9, 115.939)
    ..cubicTo(321.764, 111.921, 316.332, 107.585, 311.628, 103.592)
    ..cubicTo(315.814, 100.488, 321.214, 96.0267, 324.964, 92.9336)
    ..cubicTo(326.289, 91.8371, 327.375, 90.9442, 328.065, 90.3905)
    ..cubicTo(328.254, 90.237, 328.35, 90.0012, 328.325, 89.7619)
    ..cubicTo(328.043, 87.2296, 327.765, 84.1365, 327.507, 80.7541)
    ..cubicTo(331.076, 80.1397, 334.544, 79.6075, 337.565, 79.3432)
    ..cubicTo(337.83, 79.3182, 338.062, 79.1504, 338.158, 78.9004)
    ..cubicTo(338.158, 78.9004, 338.819, 77.2538, 338.819, 77.2538)
    ..cubicTo(338.962, 76.893, 338.787, 76.4823, 338.426, 76.3358)
    ..cubicTo(338.062, 76.1894, 337.651, 76.3644, 337.505, 76.7287)
    ..cubicTo(337.505, 76.7287, 337.008, 77.9753, 337.008, 77.9753)
    ..cubicTo(334.083, 78.2503, 330.79, 78.7575, 327.404, 79.3397)
    ..cubicTo(326.614, 68.3316, 326.107, 54.7698, 326.679, 47.4014)
    ..cubicTo(326.711, 47.0121, 326.418, 46.6728, 326.029, 46.6406)
    ..cubicTo(325.643, 46.612, 325.3, 46.9013, 325.268, 47.2907)
    ..cubicTo(324.689, 54.752, 325.204, 68.4852, 326.004, 79.5825)
    ..cubicTo(324.468, 79.854, 322.918, 80.1362, 321.386, 80.4148)
    ..cubicTo(315.86, 81.4255, 310.145, 82.4685, 305.491, 82.8757)
    ..cubicTo(305.32, 82.89, 305.159, 82.9685, 305.041, 83.09)
    ..cubicTo(305.041, 83.09, 298.916, 89.5084, 298.916, 89.5084)
    ..cubicTo(298.916, 89.5084, 296.044, 51.5767, 296.044, 51.5767)
    ..cubicTo(296.016, 51.1874, 295.68, 50.8981, 295.287, 50.9231)
    ..cubicTo(294.898, 50.9516, 294.605, 51.291, 294.637, 51.6803)
    ..cubicTo(294.637, 51.6803, 297.548, 90.187, 297.548, 90.187)
    ..cubicTo(297.548, 90.187, 278.246, 91.4121, 278.246, 91.4121)
    ..cubicTo(278.246, 91.4121, 278.261, 91.1978, 278.261, 91.1978)
    ..cubicTo(278.282, 90.8085, 277.986, 90.4727, 277.596, 90.4513)
    ..cubicTo(277.296, 90.4298, 277.039, 90.5906, 276.921, 90.837)
    ..cubicTo(276.921, 90.837, 272.032, 88.2654, 272.032, 88.2654)
    ..cubicTo(272.032, 88.2654, 265.663, 82.5328, 265.663, 82.5328)
    ..cubicTo(265.663, 82.5328, 263.763, 75.5644, 263.763, 75.5644)
    ..cubicTo(263.763, 75.5644, 263.136, 60.8167, 263.136, 60.8167)
    ..cubicTo(263.136, 60.8167, 283.411, 62.8741, 283.411, 62.8741)
    ..cubicTo(283.436, 62.8741, 283.461, 62.8741, 283.482, 62.8741)
    ..cubicTo(283.843, 62.8741, 284.15, 62.6062, 284.186, 62.2419)
    ..cubicTo(284.225, 61.8525, 283.943, 61.5061, 283.554, 61.4668)
    ..cubicTo(283.554, 61.4668, 263.085, 59.388, 263.085, 59.388)
    ..cubicTo(263.024, 59.0987, 262.791, 58.8666, 262.481, 58.8309)
    ..cubicTo(262.481, 58.8309, 261.503, 58.7202, 261.503, 58.7202)
    ..cubicTo(261.503, 58.7202, 261.767, 51.3446, 261.767, 51.3446)
    ..cubicTo(261.829, 51.341, 261.891, 51.3338, 261.952, 51.316)
    ..cubicTo(262.153, 51.2552, 262.316, 51.1053, 262.396, 50.9088)
    ..cubicTo(262.396, 50.9088, 266.349, 41.358, 266.349, 41.358)
    ..cubicTo(266.499, 40.9973, 266.328, 40.583, 265.967, 40.4365)
    ..cubicTo(265.606, 40.2865, 265.192, 40.458, 265.043, 40.8187)
    ..cubicTo(265.043, 40.8187, 261.416, 49.5837, 261.416, 49.5837)
    ..cubicTo(261.416, 49.5837, 253.712, 44.544, 253.712, 44.544)
    ..cubicTo(253.712, 44.544, 245.58, 29.9071, 245.58, 29.9071)
    ..cubicTo(245.58, 29.9071, 235.942, 7.2088, 235.942, 7.2088)
    ..cubicTo(236.105, 7.1588, 236.273, 7.1088, 236.432, 7.0624)
    ..cubicTo(237.415, 7.2124, 242.696, 8.0232, 242.696, 8.0232)
    ..cubicTo(242.696, 8.0232, 242.911, 6.6267, 242.911, 6.6267)
    ..cubicTo(242.911, 6.6267, 239.7, 6.1337, 239.7, 6.1337)
    ..cubicTo(237.576, 5.8051, 236.639, 5.6623, 236.188, 5.698)
    ..cubicTo(236.188, 5.698, 236.177, 5.6623, 236.177, 5.6623)
    ..cubicTo(235.938, 5.7337, 235.688, 5.8087, 235.44, 5.8837)
    ..cubicTo(235.44, 5.8837, 235.44, -11.5105, 235.44, -11.5105)
    ..cubicTo(235.44, -11.5105, 246.553, -10.9069, 246.553, -10.9069)
    ..cubicTo(246.566, -10.9069, 246.579, -10.9069, 246.592, -10.9069)
    ..cubicTo(246.965, -10.9069, 247.277, -11.1998, 247.297, -11.5748)
    ..cubicTo(247.318, -11.9677, 247.019, -12.2999, 246.63, -12.3213)
    ..cubicTo(246.63, -12.3213, 235.671, -12.9142, 235.671, -12.9142)
    ..cubicTo(240.061, -21.9114, 241.423, -24.7045, 241.841, -25.6188)
    ..cubicTo(245.805, -28.6941, 251.281, -32.1872, 257.076, -35.8804)
    ..cubicTo(263.546, -40.0093, 270.239, -44.2739, 274.71, -47.9599)
    ..cubicTo(274.867, -48.0885, 274.96, -48.2813, 274.967, -48.4849)
    ..cubicTo(274.967, -48.4849, 275.625, -69.2366, 275.625, -69.2366)
    ..cubicTo(275.632, -69.4438, 275.546, -69.6474, 275.389, -69.7867)
    ..cubicTo(271.124, -73.5905, 266.72, -77.9838, 262.166, -82.7163)
    ..cubicTo(262.166, -82.7163, 264.61, -82.7556, 264.61, -82.7556)
    ..cubicTo(271.299, -82.8663, 283.757, -83.0663, 287.819, -83.377)
    ..cubicTo(287.965, -83.3878, 288.101, -83.4413, 288.211, -83.5342)
    ..cubicTo(288.211, -83.5342, 291.63, -86.3308, 291.63, -86.3308)
    ..cubicTo(291.63, -86.3308, 301.17, -86.0237, 301.17, -86.0237)
    ..cubicTo(301.17, -86.0237, 309.127, -71.3832, 309.127, -71.3832)
    ..cubicTo(309.127, -71.3832, 309.127, -67.5686, 309.127, -67.5686)
    ..cubicTo(308.163, -66.5721, 306.666, -64.997, 304.856, -63.0861)
    ..cubicTo(297.937, -55.782, 285.075, -42.2094, 281.154, -39.5699)
    ..cubicTo(280.418, -39.2128, 279.214, -38.652, 277.739, -37.9662)
    ..cubicTo(271.596, -35.1124, 261.314, -30.3335, 258.972, -28.2869)
    ..cubicTo(258.952, -28.269, 258.932, -28.2476, 258.913, -28.2297)
    ..cubicTo(258.913, -28.2297, 249.69, -18.0182, 249.69, -18.0182)
    ..cubicTo(249.428, -17.7289, 249.451, -17.2788, 249.741, -17.0181)
    ..cubicTo(249.876, -16.8967, 250.045, -16.836, 250.214, -16.836)
    ..cubicTo(250.407, -16.836, 250.6, -16.9145, 250.739, -17.0681)
    ..cubicTo(250.739, -17.0681, 259.933, -27.2475, 259.933, -27.2475)
    ..cubicTo(262.188, -29.1834, 272.685, -34.0588, 278.332, -36.684)
    ..cubicTo(279.85, -37.3876, 281.079, -37.9591, 281.814, -38.3198)
    ..cubicTo(281.843, -38.3305, 281.872, -38.3484, 281.897, -38.3663)
    ..cubicTo(285.904, -41.0308, 298.409, -54.2282, 305.881, -62.111)
    ..cubicTo(307.82, -64.1576, 309.392, -65.8149, 310.342, -66.7864)
    ..cubicTo(310.47, -66.9186, 310.542, -67.0972, 310.542, -67.2829)
    ..cubicTo(310.542, -67.2829, 310.542, -71.5654, 310.542, -71.5654)
    ..cubicTo(310.542, -71.6833, 310.51, -71.7975, 310.456, -71.9011)
    ..cubicTo(310.456, -71.9011, 302.22, -87.0524, 302.22, -87.0524)
    ..cubicTo(302.102, -87.2738, 301.873, -87.4131, 301.623, -87.4238)
    ..cubicTo(301.623, -87.4238, 291.412, -87.7524, 291.412, -87.7524)
    ..cubicTo(291.24, -87.7595, 291.072, -87.6988, 290.94, -87.5917)
    ..cubicTo(290.94, -87.5917, 287.49, -84.77, 287.49, -84.77)
    ..cubicTo(283.254, -84.47, 271.146, -84.2771, 264.587, -84.1699)
    ..cubicTo(264.587, -84.1699, 262.361, -84.1342, 262.361, -84.1342)
    ..cubicTo(262.361, -84.1342, 251.873, -94.6208, 251.873, -94.6208)
    ..cubicTo(251.873, -94.6208, 254.667, -97.4139, 254.667, -97.4139)
    ..cubicTo(254.799, -97.5496, 254.874, -97.7282, 254.874, -97.9139)
    ..cubicTo(254.874, -97.9139, 254.874, -110.64, 254.874, -110.64)
    ..cubicTo(254.874, -110.64, 257.142, -117.123, 257.142, -117.123)
    ..cubicTo(257.142, -117.123, 264.029, -137.456, 264.029, -137.456)
    ..cubicTo(264.029, -137.456, 270.567, -147.261, 270.567, -147.261)
    ..cubicTo(270.653, -147.389, 270.696, -147.547, 270.685, -147.7)
    ..cubicTo(270.685, -147.7, 270.024, -157.254, 270.024, -157.254)
    ..cubicTo(269.999, -157.644, 269.646, -157.93, 269.271, -157.912)
    ..cubicTo(268.881, -157.883, 268.588, -157.547, 268.613, -157.158)
    ..cubicTo(268.613, -157.158, 269.256, -147.843, 269.256, -147.843)
    ..cubicTo(269.256, -147.843, 262.802, -138.164, 262.802, -138.164)
    ..cubicTo(262.768, -138.11, 262.741, -138.056, 262.72, -137.999)
    ..cubicTo(262.72, -137.999, 255.806, -117.583, 255.806, -117.583)
    ..cubicTo(255.806, -117.583, 253.5, -110.994, 253.5, -110.994)
    ..cubicTo(253.474, -110.919, 253.46, -110.84, 253.46, -110.761)
    ..cubicTo(253.46, -110.761, 253.46, -98.2068, 253.46, -98.2068)
    ..cubicTo(253.46, -98.2068, 250.43, -95.178, 250.43, -95.178)
    ..cubicTo(239.975, -106.372, 229.209, -117.805, 219.03, -125.809)
    ..cubicTo(218.912, -125.902, 218.766, -125.956, 218.616, -125.963)
    ..cubicTo(218.616, -125.963, 208.405, -126.291, 208.405, -126.291)
    ..cubicTo(208.043, -126.302, 207.725, -126.02, 207.687, -125.652)
    ..cubicTo(207.244, -130.324, 206.609, -134.549, 205.775, -137.939)
    ..cubicTo(205.748, -138.053, 205.694, -138.153, 205.618, -138.239)
    ..cubicTo(199.555, -145.093, 186.93, -158.622, 180.284, -165.223)
    ..cubicTo(180.284, -165.223, 172.753, -177.663, 172.753, -177.663)
    ..cubicTo(172.552, -177.999, 172.117, -178.106, 171.783, -177.903)
    ..cubicTo(171.449, -177.699, 171.342, -177.267, 171.544, -176.931)
    ..cubicTo(171.544, -176.931, 179.12, -164.416, 179.12, -164.416)
    ..cubicTo(179.15, -164.366, 179.186, -164.319, 179.227, -164.28)
    ..cubicTo(185.796, -157.765, 198.331, -144.332, 204.444, -137.435)
    ..cubicTo(207.972, -122.841, 207.803, -91.6741, 204.117, -77.5051)
    ..cubicTo(204.117, -77.5051, 178.864, -48.6421, 178.864, -48.6421)
    ..cubicTo(178.82, -48.5921, 178.784, -48.5385, 178.756, -48.4778)
    ..cubicTo(178.756, -48.4778, 175.666, -41.8844, 175.666, -41.8844)
    ..cubicTo(175.666, -41.8844, 147.331, -55.7891, 147.331, -55.7891)
    ..cubicTo(147.171, -58.2964, 147.007, -60.6395, 146.832, -62.729)
    ..cubicTo(146.824, -62.8218, 146.798, -62.9111, 146.756, -62.9932)
    ..cubicTo(145, -66.4007, 143.41, -69.3116, 142.007, -71.8832)
    ..cubicTo(135.269, -84.2235, 132.48, -89.3347, 133.657, -108.411)
    ..cubicTo(133.662, -108.493, 133.653, -108.572, 133.631, -108.651)
    ..cubicTo(133.631, -108.651, 124.428, -140.86, 124.428, -140.86)
    ..cubicTo(124.428, -140.86, 124.303, -142.535, 124.303, -142.535)
    ..cubicTo(123.76, -149.811, 122.75, -163.351, 122.458, -169.098)
    ..cubicTo(122.453, -169.195, 122.428, -169.291, 122.384, -169.38)
    ..cubicTo(122.384, -169.38, 117.773, -178.603, 117.773, -178.603)
    ..cubicTo(117.598, -178.953, 117.175, -179.096, 116.824, -178.917)
    ..cubicTo(116.475, -178.745, 116.334, -178.32, 116.508, -177.97)
    ..cubicTo(116.508, -177.97, 121.054, -168.88, 121.054, -168.88)
    ..cubicTo(121.356, -163.033, 122.355, -149.65, 122.893, -142.428)
    ..cubicTo(122.893, -142.428, 123.023, -140.682, 123.023, -140.682)
    ..cubicTo(123.027, -140.635, 123.036, -140.589, 123.049, -140.542)
    ..cubicTo(123.049, -140.542, 132.238, -108.379, 132.238, -108.379)
    ..cubicTo(131.056, -88.9918, 133.904, -83.7735, 140.766, -71.2046)
    ..cubicTo(142.148, -68.6723, 143.712, -65.8078, 145.434, -62.4718)
    ..cubicTo(145.587, -60.6431, 145.731, -58.6108, 145.871, -56.4534)
    ..cubicTo(145.87, -56.457, 145.868, -56.457, 145.867, -56.457)
    ..cubicTo(145.867, -56.457, 135.821, -57.4428, 135.821, -57.4428)
    ..cubicTo(128.417, -58.1715, 126.317, -58.3822, 125.618, -58.3643)
    ..cubicTo(125.618, -58.3643, 125.609, -58.4286, 125.609, -58.4286)
    ..cubicTo(117.521, -57.3214, 102.254, -53.0282, 94.9108, -50.1922)
    ..cubicTo(82.6873, -49.1636, 57.0999, -48.9921, 34.517, -48.8385)
    ..cubicTo(18.101, -48.7278, 2.5952, -48.6242, -6.7406, -48.2242)
    ..cubicTo(-6.8224, -48.2206, -6.9028, -48.2028, -6.9785, -48.1706)
    ..cubicTo(-18.623, -43.3952, -61.0576, -27.494, -71.183, -23.808)
    ..cubicTo(-71.55, -23.6722, -71.739, -23.2686, -71.6057, -22.9007)
    ..cubicTo(-71.4724, -22.5328, -71.0659, -22.3435, -70.6998, -22.4793)
    ..cubicTo(-60.6007, -26.1546, -18.3759, -41.9809, -6.5567, -46.817)
    ..cubicTo(2.7662, -47.2134, 18.1953, -47.317, 34.527, -47.4242)
    ..cubicTo(58.305, -47.5849, 82.893, -47.7527, 95.1311, -48.7921)
    ..cubicTo(95.1987, -48.7957, 95.2644, -48.81, 95.3276, -48.835)
    ..cubicTo(102.538, -51.6388, 117.667, -55.8998, 125.719, -57.0178)
    ..cubicTo(127.036, -56.8892, 143.962, -55.2248, 145.601, -55.0605)
    ..cubicTo(145.601, -55.0605, 145.972, -54.8819, 145.972, -54.8819)
    ..cubicTo(146.126, -52.4138, 146.277, -49.8029, 146.433, -47.117)
    ..cubicTo(146.745, -41.7165, 147.082, -35.8875, 147.51, -30.0763)
    ..cubicTo(139.858, -29.662, 130.651, -28.7191, 120.905, -27.719)
    ..cubicTo(97.376, -25.3045, 70.7074, -22.565, 53.037, -25.8153)
    ..cubicTo(52.9817, -25.826, 52.9263, -25.826, 52.8688, -25.826)
    ..cubicTo(52.3963, -25.7974, 41.2718, -25.1581, 39.5952, -24.8259)
    ..cubicTo(39.2124, -24.7473, 38.9641, -24.3759, 39.0409, -23.9937)
    ..cubicTo(39.1166, -23.6115, 39.4885, -23.3615, 39.8724, -23.4401)
    ..cubicTo(41.1279, -23.6901, 48.8692, -24.1794, 52.8652, -24.408)
    ..cubicTo(58.7332, -23.3365, 65.5559, -22.915, 72.9101, -22.915)
    ..cubicTo(87.9495, -22.915, 105.209, -24.6866, 121.049, -26.3117)
    ..cubicTo(130.79, -27.3118, 139.992, -28.2547, 147.615, -28.6655)
    ..cubicTo(148.328, -19.3219, 149.288, -10.1033, 150.772, -2.8313)
    ..cubicTo(150.772, -2.8313, 120.172, -5.7315, 120.172, -5.7315)
    ..cubicTo(120.133, -5.7351, 120.092, -5.7351, 120.052, -5.7315)
    ..cubicTo(119.921, -5.7208, 106.881, -4.7457, 104.953, -4.7457)
    ..cubicTo(104.563, -4.7457, 104.246, -4.4278, 104.246, -4.0385)
    ..cubicTo(104.246, -3.6492, 104.563, -3.3313, 104.953, -3.3313)
    ..cubicTo(106.885, -3.3313, 119.013, -4.2349, 120.098, -4.3171)
    ..cubicTo(120.098, -4.3171, 151.08, -1.3811, 151.08, -1.3811)
    ..cubicTo(151.374, -0.0596, 151.686, 1.1869, 152.02, 2.3513)
    ..cubicTo(153.59, 10.7306, 153.219, 33.361, 153.04, 44.2368)
    ..cubicTo(153.04, 44.2368, 153.004, 46.5299, 153.004, 46.5299)
    ..cubicTo(153.004, 46.5299, 149.789, 47.7657, 149.789, 47.7657)
    ..cubicTo(149.789, 47.7657, 146.77, 41.1259, 146.77, 41.1259)
    ..cubicTo(146.608, 40.7687, 146.187, 40.6115, 145.835, 40.7758)
    ..cubicTo(145.479, 40.9366, 145.322, 41.3544, 145.484, 41.708)
    ..cubicTo(145.484, 41.708, 148.778, 48.9551, 148.778, 48.9551)
    ..cubicTo(148.895, 49.2158, 149.152, 49.3694, 149.421, 49.3694)
    ..cubicTo(149.506, 49.3694, 149.592, 49.3551, 149.675, 49.323)
    ..cubicTo(149.675, 49.323, 153.957, 47.6764, 153.957, 47.6764)
    ..cubicTo(154.226, 47.5728, 154.405, 47.3157, 154.41, 47.0263)
    ..cubicTo(154.41, 47.0263, 154.453, 44.2618, 154.453, 44.2618)
    ..cubicTo(154.633, 33.3395, 155.006, 10.6091, 153.394, 2.0263)
    ..cubicTo(153.05, 0.8298, 152.73, -0.4632, 152.43, -1.8276)
    ..cubicTo(152.43, -1.8276, 177.764, -15.9395, 177.764, -15.9395)
    ..cubicTo(177.779, -15.9466, 177.788, -15.9609, 177.803, -15.9716)
    ..cubicTo(177.803, -15.9716, 179.975, -11.1105, 179.975, -11.1105)
    ..cubicTo(180.512, -9.9104, 180.815, -9.2318, 181.016, -8.8425)
    ..cubicTo(181.016, -8.8425, 181.009, -8.8425, 181.009, -8.8425)
    ..cubicTo(182.922, 0.7083, 188.65, 11.3735, 194.989, 21.4386)
    ..cubicTo(194.989, 21.4386, 184.563, 29.4928, 184.563, 29.4928)
    ..cubicTo(184.472, 29.5642, 184.4, 29.6571, 184.352, 29.7607)
    ..cubicTo(177.907, 43.8582, 176.674, 46.5549, 176.439, 47.1514)
    ..cubicTo(176.439, 47.1514, 176.413, 47.1442, 176.413, 47.1442)
    ..cubicTo(176.321, 47.4514, 176.011, 49.3337, 175.148, 54.6377)
    ..cubicTo(173.777, 63.0633, 170.927, 80.5791, 169.259, 87.9761)
    ..cubicTo(169.259, 87.9761, 102.916, 93.7444, 102.916, 93.7444)
    ..cubicTo(102.527, 93.7801, 102.239, 94.123, 102.273, 94.5088)
    ..cubicTo(102.305, 94.8802, 102.614, 95.1552, 102.976, 95.1552)
    ..cubicTo(102.997, 95.1552, 103.017, 95.1552, 103.038, 95.1552)
    ..cubicTo(103.038, 95.1552, 168.914, 89.4262, 168.914, 89.4262)
    ..cubicTo(168.696, 90.2834, 168.507, 90.8942, 168.357, 91.1906)
    ..cubicTo(168.293, 91.2263, 168.234, 91.2692, 168.182, 91.3228)
    ..cubicTo(168.182, 91.3228, 155.976, 103.981, 154.916, 105.081)
    ..cubicTo(130.988, 118.164, 104.494, 129.69, 76.4793, 141.409)
    ..cubicTo(76.2782, 141.191, 75.9596, 141.109, 75.6746, 141.238)
    ..cubicTo(75.4031, 141.363, 75.2503, 141.634, 75.2638, 141.916)
    ..cubicTo(70.0706, 144.088, 64.8323, 146.263, 59.5422, 148.46)
    ..cubicTo(55.0447, 150.328, 50.5318, 152.199, 46.0154, 154.085)
    ..cubicTo(44.4421, 150.31, 43.0459, 146.927, 41.9411, 144.248)
    ..cubicTo(41.9411, 144.248, 40.716, 141.284, 40.716, 141.284)
    ..cubicTo(40.6975, 141.238, 40.6739, 141.195, 40.6464, 141.152)
    ..cubicTo(40.6464, 141.152, 39.737, 139.82, 39.737, 139.82)
    ..cubicTo(36.7839, 135.469, 36.6075, 135.208, 30.852, 132.04)
    ..cubicTo(30.802, 132.012, 30.7488, 131.99, 30.6938, 131.976)
    ..cubicTo(29.7366, 131.719, 27.9443, 131.197, 25.6756, 130.54)
    ..cubicTo(25.1698, 130.39, 24.638, 130.237, 24.0918, 130.079)
    ..cubicTo(24.0918, 130.079, 8.4234, 96.4554, 8.4234, 96.4554)
    ..cubicTo(8.3777, 96.3589, 8.3095, 96.2696, 8.2245, 96.2017)
    ..cubicTo(8.2245, 96.2017, -0.0105, 89.6155, -0.0105, 89.6155)
    ..cubicTo(-0.0534, 89.5798, -0.099, 89.5512, -0.1483, 89.5298)
    ..cubicTo(-0.1483, 89.5298, -5.787, 86.8438, -5.787, 86.8438)
    ..cubicTo(-5.9074, 86.6438, -6.1124, 86.5045, -6.3617, 86.4974)
    ..cubicTo(-6.4046, 86.4938, -6.4424, 86.5081, -6.4835, 86.5117)
    ..cubicTo(-6.4835, 86.5117, -20.7646, 79.7111, -20.7646, 79.7111)
    ..cubicTo(-20.7646, 79.7111, -24.5249, 75.3251, -24.5249, 75.3251)
    ..cubicTo(-24.5249, 75.3251, -26.094, 70.3032, -26.094, 70.3032)
    ..cubicTo(-26.094, 70.3032, -25.7675, 55.9271, -25.7675, 55.9271)
    ..cubicTo(-25.7661, 55.8699, -25.7718, 55.8092, -25.7847, 55.7556)
    ..cubicTo(-25.7847, 55.7556, -29.061, 41.3366, -29.061, 41.3366)
    ..cubicTo(-29.061, 41.3366, -29.061, 21.3243, -29.061, 21.3243)
    ..cubicTo(-29.061, 20.935, -29.3775, 20.6171, -29.7679, 20.6171)
    ..cubicTo(-30.1583, 20.6171, -30.4747, 20.935, -30.4747, 21.3243)
    ..cubicTo(-30.4747, 21.3243, -30.4747, 41.4188, -30.4747, 41.4188)
    ..cubicTo(-30.4747, 41.4688, -30.4686, 41.5223, -30.4572, 41.5759)
    ..cubicTo(-30.4572, 41.5759, -27.1827, 55.9806, -27.1827, 55.9806)
    ..cubicTo(-27.1827, 55.9806, -27.5098, 70.3889, -27.5098, 70.3889)
    ..cubicTo(-27.512, 70.4639, -27.5005, 70.5425, -27.478, 70.614)
    ..cubicTo(-27.478, 70.614, -25.8308, 75.8858, -25.8308, 75.8858)
    ..cubicTo(-25.8022, 75.9751, -25.7554, 76.0608, -25.6929, 76.1358)
    ..cubicTo(-25.6929, 76.1358, -21.7401, 80.7469, -21.7401, 80.7469)
    ..cubicTo(-21.6761, 80.8219, -21.5965, 80.8826, -21.5076, 80.9255)
    ..cubicTo(-21.5076, 80.9255, -7.1039, 87.7832, -7.1039, 87.7832)
    ..cubicTo(-7.1039, 87.7832, -8.0758, 123.415, -8.0758, 123.415)
    ..cubicTo(-8.0815, 123.629, -7.9925, 123.829, -7.8332, 123.968)
    ..cubicTo(-7.6743, 124.108, -7.461, 124.168, -7.2528, 124.133)
    ..cubicTo(-3.7839, 123.554, 13.4399, 128.458, 23.3157, 131.326)
    ..cubicTo(23.37, 131.347, 23.4257, 131.365, 23.4843, 131.376)
    ..cubicTo(24.1154, 131.558, 24.7173, 131.733, 25.2805, 131.897)
    ..cubicTo(27.4943, 132.54, 29.2555, 133.051, 30.2448, 133.319)
    ..cubicTo(35.6292, 136.284, 35.6964, 136.384, 38.5673, 140.612)
    ..cubicTo(38.5673, 140.612, 39.4377, 141.891, 39.4377, 141.891)
    ..cubicTo(39.4377, 141.891, 40.6346, 144.788, 40.6346, 144.788)
    ..cubicTo(41.7883, 147.584, 43.1762, 150.945, 44.7096, 154.631)
    ..cubicTo(7.6902, 170.093, -29.5253, 186.327, -60.9067, 205.968)
    ..cubicTo(-60.9067, 205.968, -66.7627, 192.002, -66.7627, 192.002)
    ..cubicTo(-66.7627, 192.002, -63.8239, 160.653, -63.8239, 160.653)
    ..cubicTo(-63.8239, 160.653, -58.4226, 146.413, -58.4226, 146.413)
    ..cubicTo(-58.3543, 146.234, -58.3645, 146.041, -58.4379, 145.877)
    ..cubicTo(-58.8959, 142.327, -59.4249, 75.9858, -59.6803, 43.9404)
    ..cubicTo(-59.769, 32.8288, -59.8287, 25.3139, -59.8558, 23.7888)
    ..cubicTo(-59.8558, 23.7888, -55.4867, 15.0523, -55.4867, 15.0523)
    ..cubicTo(-55.3121, 14.7023, -55.4535, 14.2808, -55.8028, 14.1058)
    ..cubicTo(-56.1529, 13.9308, -56.5771, 14.0701, -56.7512, 14.4201)
    ..cubicTo(-56.7512, 14.4201, -61.1983, 23.3137, -61.1983, 23.3137)
    ..cubicTo(-61.25, 23.4173, -61.2756, 23.5316, -61.2723, 23.6495)
    ..cubicTo(-61.2479, 24.6281, -61.1835, 32.7323, -61.094, 43.9511)
    ..cubicTo(-60.9576, 61.0525, -60.7517, 86.8939, -60.5228, 108.074)
    ..cubicTo(-60.3973, 119.697, -60.2771, 128.772, -60.1652, 135.044)
    ..cubicTo(-60.0362, 142.305, -59.9879, 145.02, -59.8089, 146.084)
    ..cubicTo(-59.8089, 146.084, -65.1796, 160.243, -65.1796, 160.243)
    ..cubicTo(-65.2019, 160.3, -65.2164, 160.364, -65.2224, 160.425)
    ..cubicTo(-65.2224, 160.425, -68.1867, 192.049, -68.1867, 192.049)
    ..cubicTo(-68.1973, 192.163, -68.1798, 192.281, -68.1349, 192.388)
    ..cubicTo(-68.1349, 192.388, -62.1182, 206.736, -62.1182, 206.736)
    ..cubicTo(-65.2513, 208.714, -68.3318, 210.725, -71.3398, 212.775)
    ..cubicTo(-71.6621, 212.997, -71.7453, 213.436, -71.5254, 213.758)
    ..cubicTo(-71.3888, 213.958, -71.1668, 214.068, -70.9408, 214.068)
    ..cubicTo(-70.8036, 214.068, -70.6651, 214.026, -70.5432, 213.943)
    ..cubicTo(-67.5841, 211.925, -64.5543, 209.947, -61.4725, 208)
    ..cubicTo(-61.3524, 208.086, -61.2093, 208.136, -61.0594, 208.136)
    ..cubicTo(-60.9683, 208.136, -60.8758, 208.122, -60.7865, 208.082)
    ..cubicTo(-60.4752, 207.954, -60.3205, 207.625, -60.378, 207.307)
    ..cubicTo(-29.0417, 187.659, 8.2009, 171.411, 45.2536, 155.935)
    ..cubicTo(51.8737, 171.808, 60.9216, 192.92, 65.8188, 200.892)
    ..cubicTo(68.4465, 205.018, 71.3639, 209.389, 74.4527, 214.015)
    ..cubicTo(80.5814, 223.194, 87.3498, 233.341, 92.5874, 242.821)
    ..cubicTo(92.5874, 242.821, 61.0463, 273.398, 61.0463, 273.398)
    ..cubicTo(61.0463, 273.398, 49.0278, 280.22, 49.0278, 280.22)
    ..cubicTo(49.0278, 280.22, 48.856, 280.259, 48.856, 280.259)
    ..cubicTo(44.1499, 281.331, 31.6489, 284.178, 27.8732, 286.189)
    ..cubicTo(27.8732, 286.189, 27.9014, 286.242, 27.9014, 286.242)
    ..cubicTo(26.8831, 286.839, 22.022, 290.046, -4.1354, 307.305)
    ..cubicTo(-4.4611, 307.519, -4.5508, 307.958, -4.3358, 308.283)
    ..cubicTo(-4.2001, 308.49, -3.9747, 308.601, -3.745, 308.601)
    ..cubicTo(-3.6118, 308.601, -3.4765, 308.565, -3.3568, 308.483)
    ..cubicTo(-3.3568, 308.483, 28.4679, 287.485, 28.5379, 287.439)
    ..cubicTo(32.1468, 285.513, 44.9596, 282.595, 49.1703, 281.635)
    ..cubicTo(49.1703, 281.635, 49.4432, 281.574, 49.4432, 281.574)
    ..cubicTo(49.5107, 281.56, 49.575, 281.535, 49.6353, 281.499)
    ..cubicTo(49.6353, 281.499, 61.8227, 274.584, 61.8227, 274.584)
    ..cubicTo(61.8745, 274.552, 61.9228, 274.516, 61.9656, 274.473)
    ..cubicTo(61.9656, 274.473, 93.291, 244.107, 93.291, 244.107)
    ..cubicTo(94.4025, 246.164, 95.4415, 248.185, 96.3745, 250.153)
    ..cubicTo(96.5116, 250.768, 97.4538, 255.007, 97.6424, 255.857)
    ..cubicTo(97.4185, 256.94, 97.1406, 258.261, 96.8234, 259.765)
    ..cubicTo(94.2296, 272.084, 89.401, 295.011, 89.7543, 303.315)
    ..cubicTo(89.7557, 303.351, 89.76, 303.386, 89.7675, 303.422)
    ..cubicTo(95.1308, 330.099, 112.165, 363.084, 128.638, 394.983)
    ..cubicTo(138.138, 413.377, 147.11, 430.754, 153.047, 445.516)
    ..cubicTo(153.158, 445.791, 153.423, 445.959, 153.703, 445.959)
    ..cubicTo(153.791, 445.959, 153.88, 445.941, 153.967, 445.909)
    ..cubicTo(154.329, 445.762, 154.504, 445.351, 154.359, 444.987)
    ..cubicTo(148.397, 430.164, 139.409, 412.759, 129.894, 394.333)
    ..cubicTo(113.477, 362.545, 96.5006, 329.671, 91.1648, 303.197)
    ..cubicTo(90.8437, 295.021, 95.8151, 271.416, 98.2067, 260.054)
    ..cubicTo(98.5389, 258.479, 98.8286, 257.104, 99.0575, 255.993)
    ..cubicTo(99.0775, 255.897, 99.0768, 255.797, 99.055, 255.697)
    ..cubicTo(99.055, 255.697, 98.3968, 252.732, 98.3968, 252.732)
    ..cubicTo(97.9814, 250.864, 97.7956, 250.032, 97.6449, 249.639)
    ..cubicTo(97.6449, 249.639, 97.686, 249.621, 97.686, 249.621)
    ..cubicTo(96.6856, 247.507, 95.569, 245.332, 94.3675, 243.121)
    ..cubicTo(94.3675, 243.121, 120.54, 226.409, 120.54, 226.409)
    ..cubicTo(131.235, 240.388, 142.545, 253.582, 150.209, 262.247)
    ..cubicTo(150.242, 262.287, 150.278, 262.319, 150.317, 262.347)
    ..cubicTo(150.317, 262.347, 160.529, 269.923, 160.529, 269.923)
    ..cubicTo(160.603, 269.98, 160.686, 270.019, 160.775, 270.041)
    ..cubicTo(160.775, 270.041, 174.949, 273.652, 174.949, 273.652)
    ..cubicTo(176.637, 274.084, 177.395, 274.277, 177.783, 274.305)
    ..cubicTo(177.783, 274.305, 177.785, 274.345, 177.785, 274.345)
    ..cubicTo(197.07, 273.337, 212.178, 258.329, 226.788, 243.814)
    ..cubicTo(233.048, 237.595, 238.961, 231.723, 245.043, 227.098)
    ..cubicTo(245.353, 226.862, 245.414, 226.419, 245.178, 226.109)
    ..cubicTo(244.941, 225.798, 244.498, 225.737, 244.187, 225.973)
    ..cubicTo(238.031, 230.655, 232.086, 236.56, 225.792, 242.81)
    ..cubicTo(211.397, 257.111, 196.514, 271.895, 177.818, 272.927)
    ..cubicTo(176.495, 272.587, 162.77, 269.091, 161.259, 268.705)
    ..cubicTo(161.259, 268.705, 151.219, 261.258, 151.219, 261.258)
    ..cubicTo(143.575, 252.611, 132.321, 239.481, 121.689, 225.587)
    ..cubicTo(121.828, 225.366, 121.84, 225.073, 121.689, 224.837)
    ..cubicTo(121.515, 224.566, 121.19, 224.466, 120.895, 224.551)
    ..cubicTo(118.197, 221.005, 115.549, 217.415, 113.014, 213.843)
    ..cubicTo(139.838, 194.931, 205.248, 150.495, 233.806, 131.601)
    ..cubicTo(234.131, 131.387, 234.221, 130.947, 234.005, 130.622)
    ..cubicTo(233.789, 130.297, 233.351, 130.205, 233.026, 130.422)
    ..cubicTo(204.46, 149.32, 139.03, 193.774, 112.198, 212.69)
    ..cubicTo(108.003, 206.721, 104.155, 200.821, 100.985, 195.278)
    ..cubicTo(100.888, 195.067, 80.5546, 150.278, 77.1047, 142.677)
    ..cubicTo(105.163, 130.94, 131.7, 119.396, 155.689, 106.267)
    ..cubicTo(155.689, 106.267, 155.672, 106.238, 155.672, 106.238)
    ..cubicTo(155.974, 106.02, 156.534, 105.438, 157.943, 103.977)
    ..cubicTo(157.943, 103.977, 169.047, 92.4621, 169.047, 92.4621)
    ..cubicTo(169.056, 92.4586, 169.065, 92.455, 169.074, 92.4514)
    ..cubicTo(169.423, 92.28, 169.809, 91.5157, 170.373, 89.2976)
    ..cubicTo(170.373, 89.2976, 209.102, 85.9295, 209.102, 85.9295)
    ..cubicTo(209.491, 85.8973, 209.779, 85.5545, 209.745, 85.1651)
    ..cubicTo(209.711, 84.7758, 209.368, 84.4829, 208.98, 84.5222)
    ..cubicTo(208.98, 84.5222, 170.719, 87.8511, 170.719, 87.8511)
    ..cubicTo(171.814, 83.0364, 173.515, 73.4785, 176.543, 54.8627)
    ..cubicTo(177.136, 51.2196, 177.651, 48.055, 177.759, 47.5835)
    ..cubicTo(178.22, 46.5727, 184.8, 32.1823, 185.565, 30.5072)
    ..cubicTo(185.565, 30.5072, 195.749, 22.6351, 195.749, 22.6351)
    ..cubicTo(198.707, 27.2783, 201.77, 31.7751, 204.617, 35.954)
    ..cubicTo(206.77, 39.115, 208.806, 42.1045, 210.608, 44.8726)
    ..cubicTo(210.608, 44.8726, 209.33, 53.5019, 209.33, 53.5019)
    ..cubicTo(209.302, 53.6912, 209.352, 53.884, 209.469, 54.0341)
    ..cubicTo(209.585, 54.1876, 209.759, 54.2841, 209.95, 54.3091)
    ..cubicTo(209.95, 54.3091, 237.856, 57.4665, 237.856, 57.4665)
    ..cubicTo(238.155, 59.3988, 238.315, 61.8454, 238.566, 65.7171)
    ..cubicTo(238.566, 65.7171, 238.639, 66.828, 238.639, 66.828)
    ..cubicTo(238.641, 66.8672, 238.648, 66.9101, 238.657, 66.9494)
    ..cubicTo(238.697, 67.1137, 242.28, 82.097, 242.28, 82.097)
    ..cubicTo(242.291, 82.1399, 242.305, 82.1828, 242.324, 82.2221)
    ..cubicTo(242.324, 82.2221, 246.838, 92.2193, 246.838, 92.2193)
    ..cubicTo(246.838, 92.2193, 246.231, 94.9552, 246.231, 94.9552)
    ..cubicTo(246.214, 95.0267, 246.212, 95.1016, 246.219, 95.1766)
    ..cubicTo(236.995, 102.677, 227.443, 111.039, 222.066, 116)
    ..cubicTo(221.78, 116.264, 221.762, 116.711, 222.026, 117)
    ..cubicTo(222.166, 117.15, 222.355, 117.225, 222.546, 117.225)
    ..cubicTo(222.717, 117.225, 222.889, 117.164, 223.025, 117.039)
    ..cubicTo(228.331, 112.142, 237.713, 103.927, 246.809, 96.516)
    ..cubicTo(249.674, 102.524, 249.987, 103.092, 255.674, 108.153)
    ..cubicTo(255.674, 108.153, 255.697, 108.128, 255.697, 108.128)
    ..cubicTo(256.089, 108.342, 257.008, 108.585, 259.093, 109.131)
    ..cubicTo(259.093, 109.131, 262.222, 109.956, 262.222, 109.956)
    ..cubicTo(262.281, 109.971, 262.341, 109.978, 262.402, 109.978)
    ..cubicTo(262.478, 109.978, 262.553, 109.967, 262.626, 109.942)
    ..cubicTo(262.626, 109.942, 270.406, 107.349, 270.406, 107.349)
    ..cubicTo(270.406, 107.349, 275.743, 107.61, 275.743, 107.61)
    ..cubicTo(275.743, 107.61, 264.357, 147.949, 264.357, 147.949)
    ..cubicTo(264.341, 148.006, 264.332, 148.067, 264.331, 148.127)
    ..cubicTo(264.331, 148.127, 263.805, 178.348, 263.805, 178.348)
    ..cubicTo(240.683, 178.058, 218.631, 176.387, 204.952, 172.494)
    ..cubicTo(204.575, 172.386, 204.186, 172.604, 204.079, 172.979)
    ..cubicTo(203.972, 173.354, 204.189, 173.747, 204.565, 173.854)
    ..cubicTo(219.055, 177.98, 241.228, 179.576, 263.779, 179.819)
    ..cubicTo(263.779, 179.819, 263.013, 223.887, 263.013, 223.887)
    ..cubicTo(263.006, 224.28, 263.317, 224.601, 263.707, 224.605)
    ..cubicTo(263.712, 224.605, 263.716, 224.605, 263.72, 224.605)
    ..cubicTo(264.104, 224.605, 264.419, 224.298, 264.427, 223.912)
    ..cubicTo(264.427, 223.912, 265.193, 179.833, 265.193, 179.833)
    ..cubicTo(266.813, 179.848, 268.438, 179.855, 270.06, 179.855)
    ..cubicTo(280.754, 179.855, 291.38, 179.573, 301.162, 179.133)
    ..cubicTo(300.927, 181.787, 300.973, 183.477, 301.352, 184.127)
    ..cubicTo(305.491, 189.934, 311.124, 197.549, 317.65, 206.364)
    ..cubicTo(322.757, 213.268, 328.425, 220.933, 334.369, 229.07)
    ..cubicTo(323.396, 230.663, 312.267, 232.038, 301.28, 233.391)
    ..cubicTo(289.929, 234.792, 279.204, 236.113, 268.921, 237.642)
    ..cubicTo(268.921, 237.642, 263.575, 231.981, 263.575, 231.981)
    ..cubicTo(263.306, 231.695, 262.858, 231.684, 262.576, 231.952)
    ..cubicTo(262.291, 232.22, 262.279, 232.666, 262.547, 232.949)
    ..cubicTo(262.547, 232.949, 268.146, 238.878, 268.146, 238.878)
    ..cubicTo(268.281, 239.02, 268.467, 239.099, 268.66, 239.099)
    ..cubicTo(268.696, 239.099, 268.731, 239.099, 268.763, 239.092)
    ..cubicTo(273.11, 238.445, 277.543, 237.835, 282.064, 237.238)
    ..cubicTo(282.064, 237.238, 270.914, 244.385, 270.914, 244.385)
    ..cubicTo(270.585, 244.596, 270.492, 245.035, 270.699, 245.364)
    ..cubicTo(270.835, 245.575, 271.064, 245.689, 271.296, 245.689)
    ..cubicTo(271.428, 245.689, 271.56, 245.653, 271.678, 245.575)
    ..cubicTo(271.678, 245.575, 284.525, 237.342, 284.525, 237.342)
    ..cubicTo(284.693, 237.231, 284.797, 237.06, 284.833, 236.877)
    ..cubicTo(290.229, 236.177, 295.762, 235.495, 301.452, 234.795)
    ..cubicTo(312.692, 233.409, 324.086, 231.998, 335.312, 230.359)
    ..cubicTo(361.539, 266.312, 392.738, 311.08, 404.557, 340.461)
    ..cubicTo(404.557, 340.461, 404.442, 340.504, 404.442, 340.504)
    ..cubicTo(404.078, 340.646, 403.899, 341.057, 404.042, 341.422)
    ..cubicTo(404.149, 341.7, 404.417, 341.872, 404.699, 341.872)
    ..cubicTo(404.785, 341.872, 404.871, 341.854, 404.957, 341.822)
    ..cubicTo(404.957, 341.822, 405.074, 341.775, 405.074, 341.775)
    ..cubicTo(406.682, 345.918, 407.892, 349.744, 408.618, 353.169)
    ..cubicTo(408.643, 353.29, 408.7, 353.398, 408.778, 353.487)
    ..cubicTo(408.943, 353.68, 414.372, 360.066, 414.372, 360.066)
    ..cubicTo(414.443, 360.152, 414.536, 360.22, 414.639, 360.262)
    ..cubicTo(423.137, 363.791, 440.688, 371.635, 449.032, 375.974)
    ..cubicTo(449.032, 375.974, 455.764, 384.629, 455.764, 384.629)
    ..cubicTo(455.764, 384.629, 458.675, 396.269, 458.675, 396.269)
    ..cubicTo(458.675, 396.269, 458.982, 405.562, 458.982, 405.562)
    ..cubicTo(453.396, 407.48, 447.874, 409.041, 442.52, 409.959)
    ..cubicTo(427.891, 409.874, 393.859, 410.127, 375.976, 410.291)
    ..cubicTo(365.157, 411.288, 342.044, 418.521, 330.018, 422.846)
    ..cubicTo(329.986, 422.857, 329.954, 422.871, 329.922, 422.889)
    ..cubicTo(329.922, 422.889, 302.409, 437.619, 302.409, 437.619)
    ..cubicTo(299.294, 439.287, 297.973, 439.994, 297.401, 440.362)
    ..cubicTo(297.401, 440.362, 297.384, 440.315, 297.384, 440.315)
    ..cubicTo(283.65, 445.859, 255.718, 459.017, 241.63, 467.035)
    ..cubicTo(241.564, 467.075, 241.504, 467.121, 241.453, 467.178)
    ..cubicTo(241.453, 467.178, 230.582, 479.365, 230.582, 479.365)
    ..cubicTo(230.487, 479.472, 230.426, 479.608, 230.409, 479.751)
    ..cubicTo(230.409, 479.751, 228.432, 495.559, 228.432, 495.559)
    ..cubicTo(228.384, 495.948, 228.659, 496.302, 229.046, 496.348)
    ..cubicTo(229.076, 496.352, 229.105, 496.355, 229.135, 496.355)
    ..cubicTo(229.486, 496.355, 229.79, 496.095, 229.835, 495.734)
    ..cubicTo(229.835, 495.734, 231.784, 480.143, 231.784, 480.143)
    ..cubicTo(231.784, 480.143, 242.43, 468.207, 242.43, 468.207)
    ..cubicTo(256.505, 460.206, 284.25, 447.141, 297.912, 441.626)
    ..cubicTo(297.937, 441.615, 297.962, 441.605, 297.984, 441.59)
    ..cubicTo(298.198, 441.476, 329.154, 424.903, 330.543, 424.157)
    ..cubicTo(342.519, 419.856, 365.432, 412.684, 376.047, 411.702)
    ..cubicTo(393.895, 411.538, 427.994, 411.288, 442.574, 411.374)
    ..cubicTo(442.62, 411.374, 442.656, 411.37, 442.699, 411.363)
    ..cubicTo(447.881, 410.477, 453.203, 409.006, 458.582, 407.195)
    ..cubicTo(458.582, 407.195, 457.389, 410.77, 457.389, 410.77)
    ..cubicTo(457.268, 411.141, 457.468, 411.542, 457.836, 411.667)
    ..cubicTo(457.911, 411.692, 457.986, 411.702, 458.061, 411.702)
    ..cubicTo(458.357, 411.702, 458.632, 411.513, 458.732, 411.216)
    ..cubicTo(458.732, 411.216, 460.265, 406.616, 460.265, 406.616)
    ..cubicTo(468.208, 403.844, 476.255, 400.383, 484.152, 396.983)
    ..cubicTo(495.996, 391.883, 508.229, 386.622, 519.591, 383.964)
    ..cubicTo(519.591, 383.964, 519.28, 401.43, 519.28, 401.43)
    ..cubicTo(519.277, 401.559, 519.312, 401.687, 519.376, 401.801)
    ..cubicTo(519.376, 401.801, 526.884, 414.535, 526.884, 414.535)
    ..cubicTo(526.884, 414.535, 527.524, 418.356, 527.524, 418.356)
    ..cubicTo(527.581, 418.703, 527.881, 418.949, 528.22, 418.949)
    ..cubicTo(528.259, 418.949, 528.299, 418.946, 528.338, 418.939)
    ..cubicTo(528.72, 418.874, 528.981, 418.51, 528.917, 418.124)
    ..cubicTo(528.917, 418.124, 528.259, 414.174, 528.259, 414.174)
    ..cubicTo(528.245, 414.085, 528.213, 414.002, 528.17, 413.931)
    ..cubicTo(528.17, 413.931, 520.694, 401.255, 520.694, 401.255)
    ..cubicTo(520.694, 401.255, 521.009, 383.693, 521.009, 383.693)
    ..cubicTo(521.009, 383.693, 532.435, 383.375, 532.435, 383.375)
    ..cubicTo(532.435, 383.375, 549.804, 387.311, 549.804, 387.311)
    ..cubicTo(550.183, 387.393, 550.565, 387.157, 550.65, 386.775)
    ..cubicTo(550.736, 386.397, 550.497, 386.018, 550.115, 385.929)
    ..cubicTo(550.115, 385.929, 550.115, 385.929, 550.115, 385.929)
    ..close();

  static final Path __path42_1_11 = Path()
    ..moveTo(23.0857, 220.948)
    ..cubicTo(13.315, 224.066, 8.7313, 226.359, 5.3832, 228.034)
    ..cubicTo(5.0603, 228.195, 4.7532, 228.349, 4.4532, 228.495)
    ..cubicTo(4.4532, 228.495, -3.7403, 217.494, -3.7403, 217.494)
    ..cubicTo(-3.7403, 217.494, -5.0355, 210.376, -5.0355, 210.376)
    ..cubicTo(-5.0355, 210.376, -4.2636, 200.472, -4.2636, 200.472)
    ..cubicTo(-4.2075, 200.511, -4.144, 200.536, -4.0736, 200.536)
    ..cubicTo(-4.0557, 200.536, -4.0379, 200.532, -4.0197, 200.532)
    ..cubicTo(-0.7927, 200.032, 4.4139, 198.503, 10.499, 196.46)
    ..cubicTo(10.499, 196.46, 15.6726, 222.977, 15.6726, 222.977)
    ..cubicTo(15.7055, 223.145, 15.8537, 223.263, 16.0191, 223.263)
    ..cubicTo(16.0416, 223.263, 16.0645, 223.259, 16.087, 223.255)
    ..cubicTo(16.2788, 223.22, 16.4038, 223.034, 16.3663, 222.841)
    ..cubicTo(16.3663, 222.841, 11.1694, 196.235, 11.1694, 196.235)
    ..cubicTo(20.9424, 192.928, 32.8244, 188.367, 42.4127, 184.602)
    ..cubicTo(42.4127, 184.602, 50.9523, 207.054, 50.9523, 207.054)
    ..cubicTo(39.8703, 211.605, 27.2768, 217.176, 23.0857, 220.948)
    ..cubicTo(23.0857, 220.948, 23.0857, 220.948, 23.0857, 220.948)
    ..close();

  static final Path __path42_1_12 = Path()
    ..moveTo(-3.0782, 185.26)
    ..cubicTo(-3.0782, 185.26, 4.8936, 181.434, 4.8936, 181.434)
    ..cubicTo(4.8936, 181.434, 10.3297, 195.775, 10.3297, 195.775)
    ..cubicTo(4.2624, 197.814, -0.9244, 199.339, -4.1272, 199.832)
    ..cubicTo(-4.1601, 199.836, -4.1875, 199.854, -4.2161, 199.864)
    ..cubicTo(-4.2161, 199.864, -3.0782, 185.26, -3.0782, 185.26)
    ..cubicTo(-3.0782, 185.26, -3.0782, 185.26, -3.0782, 185.26)
    ..close();

  static final Path __path42_1_13 = Path()
    ..moveTo(39.0231, 175.691)
    ..cubicTo(39.0231, 175.691, 42.1612, 183.942, 42.1612, 183.942)
    ..cubicTo(32.5912, 187.699, 20.7352, 192.249, 10.9948, 195.55)
    ..cubicTo(10.9948, 195.55, 6.9994, 185.002, 6.9994, 185.002)
    ..cubicTo(14.5361, 182.266, 31.2768, 177.67, 39.0231, 175.691)
    ..cubicTo(39.0231, 175.691, 39.0231, 175.691, 39.0231, 175.691)
    ..close();

  static final Path __path42_1_14 = Path()
    ..moveTo(129.599, 154.168)
    ..cubicTo(129.473, 154.018, 129.248, 154, 129.101, 154.125)
    ..cubicTo(114.005, 166.969, 83.161, 190.839, 67.2711, 200.514)
    ..cubicTo(66.0364, 201.018, 64.3676, 201.679, 62.3975, 202.457)
    ..cubicTo(59.3333, 203.672, 55.5798, 205.161, 51.6066, 206.786)
    ..cubicTo(51.6066, 206.786, 43.0702, 184.345, 43.0702, 184.345)
    ..cubicTo(46.3133, 183.07, 49.2818, 181.891, 51.7841, 180.898)
    ..cubicTo(53.5725, 180.191, 55.1119, 179.581, 56.3342, 179.098)
    ..cubicTo(56.3577, 179.091, 56.3799, 179.08, 56.4006, 179.066)
    ..cubicTo(69.452, 170.416, 94.5329, 153.607, 105.786, 145.814)
    ..cubicTo(105.786, 145.814, 119.587, 139.899, 119.587, 139.899)
    ..cubicTo(119.767, 139.82, 119.85, 139.613, 119.773, 139.434)
    ..cubicTo(119.696, 139.256, 119.487, 139.17, 119.309, 139.249)
    ..cubicTo(119.309, 139.249, 105.475, 145.178, 105.475, 145.178)
    ..cubicTo(105.453, 145.185, 105.432, 145.199, 105.412, 145.213)
    ..cubicTo(94.1869, 152.989, 69.1102, 169.794, 56.0413, 178.455)
    ..cubicTo(54.824, 178.934, 53.2957, 179.541, 51.5238, 180.241)
    ..cubicTo(49.0239, 181.234, 46.0587, 182.409, 42.8191, 183.684)
    ..cubicTo(42.8191, 183.684, 39.7128, 175.516, 39.7128, 175.516)
    ..cubicTo(39.7482, 175.509, 39.7871, 175.498, 39.8221, 175.491)
    ..cubicTo(40.0114, 175.441, 40.1261, 175.252, 40.0782, 175.062)
    ..cubicTo(40.031, 174.873, 39.8389, 174.759, 39.6492, 174.805)
    ..cubicTo(39.5889, 174.819, 39.5217, 174.837, 39.4599, 174.852)
    ..cubicTo(39.4599, 174.852, 34.137, 160.858, 34.137, 160.858)
    ..cubicTo(34.0681, 160.675, 33.8645, 160.586, 33.6809, 160.654)
    ..cubicTo(33.4987, 160.722, 33.4069, 160.925, 33.4766, 161.111)
    ..cubicTo(33.4766, 161.111, 38.7706, 175.027, 38.7706, 175.027)
    ..cubicTo(30.9746, 177.02, 14.2793, 181.609, 6.7491, 184.342)
    ..cubicTo(6.7491, 184.342, 2.8659, 174.091, 2.8659, 174.091)
    ..cubicTo(2.8659, 174.091, 2.2091, 148.457, 2.2091, 148.457)
    ..cubicTo(2.2037, 148.267, 2.0469, 148.114, 1.8555, 148.114)
    ..cubicTo(1.8555, 148.114, -6.6935, 148.114, -6.6935, 148.114)
    ..cubicTo(-6.6935, 148.114, -7.3435, 122.765, -7.3435, 122.765)
    ..cubicTo(-7.3485, 122.569, -7.4874, 122.44, -7.706, 122.422)
    ..cubicTo(-7.9014, 122.426, -8.0549, 122.587, -8.0503, 122.783)
    ..cubicTo(-8.0503, 122.783, -7.3914, 148.474, -7.3914, 148.474)
    ..cubicTo(-7.3864, 148.667, -7.2295, 148.821, -7.0381, 148.821)
    ..cubicTo(-7.0381, 148.821, 1.5111, 148.821, 1.5111, 148.821)
    ..cubicTo(1.5111, 148.821, 2.1608, 174.169, 2.1608, 174.169)
    ..cubicTo(2.1619, 174.209, 2.1701, 174.248, 2.1837, 174.284)
    ..cubicTo(2.1837, 174.284, 4.6421, 180.77, 4.6421, 180.77)
    ..cubicTo(4.6421, 180.77, -3.5675, 184.71, -3.5675, 184.71)
    ..cubicTo(-3.6811, 184.763, -3.7575, 184.877, -3.7668, 185.002)
    ..cubicTo(-3.7668, 185.002, -5.7434, 210.365, -5.7434, 210.365)
    ..cubicTo(-5.7459, 210.394, -5.744, 210.426, -5.7387, 210.454)
    ..cubicTo(-5.7387, 210.454, -4.4208, 217.701, -4.4208, 217.701)
    ..cubicTo(-4.4115, 217.755, -4.3897, 217.805, -4.3568, 217.848)
    ..cubicTo(-4.3568, 217.848, 3.8092, 228.813, 3.8092, 228.813)
    ..cubicTo(-1.2573, 231.256, -4.2058, 231.713, -25.1389, 230.792)
    ..cubicTo(-25.3328, 230.792, -25.4989, 230.935, -25.5075, 231.128)
    ..cubicTo(-25.516, 231.324, -25.365, 231.488, -25.1699, 231.495)
    ..cubicTo(-18.6133, 231.785, -13.8065, 231.938, -10.1391, 231.938)
    ..cubicTo(-1.8931, 231.938, 0.5932, 231.16, 4.2392, 229.388)
    ..cubicTo(4.2392, 229.388, 18.6643, 248.754, 18.6643, 248.754)
    ..cubicTo(18.6643, 248.754, 35.1342, 283.667, 35.1342, 283.667)
    ..cubicTo(35.1946, 283.796, 35.3214, 283.871, 35.4539, 283.871)
    ..cubicTo(35.5043, 283.871, 35.5557, 283.86, 35.6046, 283.835)
    ..cubicTo(35.7807, 283.753, 35.8564, 283.542, 35.7732, 283.367)
    ..cubicTo(35.7732, 283.367, 19.2672, 248.39, 19.2672, 248.39)
    ..cubicTo(19.2672, 248.39, 4.8821, 229.074, 4.8821, 229.074)
    ..cubicTo(5.1464, 228.942, 5.4175, 228.806, 5.6993, 228.667)
    ..cubicTo(9.0356, 226.995, 13.6046, 224.709, 23.3736, 221.598)
    ..cubicTo(23.4222, 221.584, 23.4668, 221.559, 23.5047, 221.523)
    ..cubicTo(27.5608, 217.819, 40.1264, 212.262, 51.2034, 207.715)
    ..cubicTo(51.2034, 207.715, 53.815, 214.58, 53.815, 214.58)
    ..cubicTo(51.6223, 215.808, 49.7215, 216.723, 48.5578, 216.962)
    ..cubicTo(48.3664, 217.001, 48.2438, 217.191, 48.2831, 217.38)
    ..cubicTo(48.3174, 217.548, 48.4646, 217.662, 48.6289, 217.662)
    ..cubicTo(48.6525, 217.662, 48.6764, 217.662, 48.7007, 217.655)
    ..cubicTo(52.2238, 216.93, 61.8749, 210.519, 67.06, 207.076)
    ..cubicTo(68.0987, 206.386, 68.9634, 205.811, 69.572, 205.418)
    ..cubicTo(69.7363, 205.315, 69.7834, 205.093, 69.6777, 204.933)
    ..cubicTo(69.5724, 204.768, 69.3534, 204.718, 69.1895, 204.825)
    ..cubicTo(68.5787, 205.218, 67.7108, 205.793, 66.6689, 206.486)
    ..cubicTo(63.4576, 208.619, 58.5208, 211.897, 54.4383, 214.233)
    ..cubicTo(54.4383, 214.233, 51.8577, 207.447, 51.8577, 207.447)
    ..cubicTo(55.8338, 205.818, 59.5919, 204.329, 62.6575, 203.115)
    ..cubicTo(64.6305, 202.336, 66.3014, 201.672, 67.5883, 201.143)
    ..cubicTo(83.5581, 191.424, 114.445, 167.522, 129.559, 154.664)
    ..cubicTo(129.707, 154.539, 129.725, 154.314, 129.599, 154.168)
    ..cubicTo(129.599, 154.168, 129.599, 154.168, 129.599, 154.168)
    ..close();

  static final Path __path42_1_15 = Path()
    ..moveTo(111.504, 213.154)
    ..cubicTo(111.394, 212.993, 111.173, 212.954, 111.012, 213.065)
    ..cubicTo(111.012, 213.065, 51.7223, 254.24, 51.7223, 254.24)
    ..cubicTo(51.5809, 254.34, 51.5305, 254.525, 51.6037, 254.679)
    ..cubicTo(51.6037, 254.679, 60.8263, 274.445, 60.8263, 274.445)
    ..cubicTo(60.8863, 274.57, 61.0138, 274.648, 61.147, 274.648)
    ..cubicTo(61.197, 274.648, 61.2477, 274.638, 61.296, 274.613)
    ..cubicTo(61.4731, 274.531, 61.5496, 274.32, 61.467, 274.145)
    ..cubicTo(61.467, 274.145, 52.3702, 254.65, 52.3702, 254.65)
    ..cubicTo(52.3702, 254.65, 111.416, 213.647, 111.416, 213.647)
    ..cubicTo(111.576, 213.536, 111.616, 213.315, 111.504, 213.154)
    ..cubicTo(111.504, 213.154, 111.504, 213.154, 111.504, 213.154)
    ..close();

  static final Path __path42_1_16 = Path()
    ..moveTo(140.571, 231.354)
    ..cubicTo(140.628, 231.432, 140.714, 231.486, 140.811, 231.5)
    ..cubicTo(140.827, 231.5, 140.844, 231.504, 140.859, 231.504)
    ..cubicTo(140.94, 231.504, 141.018, 231.475, 141.081, 231.425)
    ..cubicTo(141.081, 231.425, 166.774, 210.67, 166.774, 210.67)
    ..cubicTo(166.925, 210.549, 166.949, 210.327, 166.827, 210.174)
    ..cubicTo(166.703, 210.024, 166.481, 209.999, 166.33, 210.124)
    ..cubicTo(166.33, 210.124, 140.93, 230.64, 140.93, 230.64)
    ..cubicTo(140.93, 230.64, 123.36, 205.909, 123.36, 205.909)
    ..cubicTo(123.247, 205.752, 123.026, 205.713, 122.867, 205.827)
    ..cubicTo(122.709, 205.941, 122.671, 206.159, 122.784, 206.32)
    ..cubicTo(122.784, 206.32, 140.571, 231.354, 140.571, 231.354)
    ..cubicTo(140.571, 231.354, 140.571, 231.354, 140.571, 231.354)
    ..close();

  static final Path __path42_1_17 = Path()
    ..moveTo(241.337, 229.848)
    ..cubicTo(241.434, 229.848, 241.53, 229.808, 241.6, 229.733)
    ..cubicTo(241.6, 229.733, 244.564, 226.44, 244.564, 226.44)
    ..cubicTo(244.695, 226.294, 244.683, 226.069, 244.538, 225.94)
    ..cubicTo(244.393, 225.808, 244.17, 225.822, 244.039, 225.965)
    ..cubicTo(244.039, 225.965, 241.27, 229.04, 241.27, 229.04)
    ..cubicTo(241.27, 229.04, 217.127, 214.321, 217.127, 214.321)
    ..cubicTo(217.154, 214.307, 217.182, 214.293, 217.205, 214.271)
    ..cubicTo(217.205, 214.271, 229.392, 202.742, 229.392, 202.742)
    ..cubicTo(229.534, 202.61, 229.541, 202.385, 229.406, 202.242)
    ..cubicTo(229.272, 202.103, 229.048, 202.095, 228.907, 202.228)
    ..cubicTo(228.907, 202.228, 224.215, 206.667, 224.215, 206.667)
    ..cubicTo(224.191, 206.585, 224.137, 206.51, 224.057, 206.464)
    ..cubicTo(219.667, 203.913, 214.878, 200.406, 209.808, 196.691)
    ..cubicTo(203.456, 192.041, 196.896, 187.241, 191.023, 184.34)
    ..cubicTo(191.023, 184.34, 198.502, 169.707, 198.502, 169.707)
    ..cubicTo(198.59, 169.532, 198.522, 169.321, 198.348, 169.232)
    ..cubicTo(198.175, 169.143, 197.961, 169.214, 197.872, 169.386)
    ..cubicTo(197.872, 169.386, 190.464, 183.88, 190.464, 183.88)
    ..cubicTo(190.464, 183.88, 182.704, 164.803, 182.704, 164.803)
    ..cubicTo(182.63, 164.621, 182.423, 164.532, 182.243, 164.607)
    ..cubicTo(182.062, 164.682, 181.975, 164.889, 182.049, 165.067)
    ..cubicTo(182.049, 165.067, 189.954, 184.501, 189.954, 184.501)
    ..cubicTo(189.987, 184.583, 190.05, 184.651, 190.13, 184.687)
    ..cubicTo(196.091, 187.523, 202.852, 192.473, 209.391, 197.263)
    ..cubicTo(214.476, 200.985, 219.279, 204.503, 223.702, 207.074)
    ..cubicTo(223.722, 207.085, 223.745, 207.085, 223.767, 207.092)
    ..cubicTo(223.767, 207.092, 216.719, 213.757, 216.719, 213.757)
    ..cubicTo(216.648, 213.825, 216.611, 213.914, 216.608, 214.003)
    ..cubicTo(216.608, 214.003, 160.491, 179.786, 160.491, 179.786)
    ..cubicTo(160.324, 179.683, 160.107, 179.736, 160.005, 179.901)
    ..cubicTo(159.903, 180.069, 159.956, 180.287, 160.123, 180.387)
    ..cubicTo(160.123, 180.387, 241.153, 229.798, 241.153, 229.798)
    ..cubicTo(241.21, 229.833, 241.274, 229.848, 241.337, 229.848)
    ..cubicTo(241.337, 229.848, 241.337, 229.848, 241.337, 229.848)
    ..close();

  static final Path __path42_1_18 = Path()
    ..moveTo(60.6733, 354.011)
    ..cubicTo(60.495, 354.09, 60.4143, 354.3, 60.4936, 354.479)
    ..cubicTo(60.5518, 354.611, 60.6811, 354.69, 60.8168, 354.69)
    ..cubicTo(60.8643, 354.69, 60.9129, 354.679, 60.9597, 354.658)
    ..cubicTo(60.9597, 354.658, 61.1608, 354.568, 61.1608, 354.568)
    ..cubicTo(61.1608, 354.568, 71.3648, 376.881, 71.3648, 376.881)
    ..cubicTo(71.3981, 376.952, 71.4541, 377.002, 71.5188, 377.038)
    ..cubicTo(71.5188, 377.038, 62.6477, 381.024, 62.6477, 381.024)
    ..cubicTo(62.5541, 381.063, 62.4837, 381.145, 62.4541, 381.242)
    ..cubicTo(62.4541, 381.242, 61.4662, 384.539, 61.4662, 384.539)
    ..cubicTo(61.4101, 384.724, 61.5158, 384.921, 61.703, 384.978)
    ..cubicTo(61.7369, 384.989, 61.7712, 384.992, 61.8048, 384.992)
    ..cubicTo(61.9569, 384.992, 62.0973, 384.892, 62.143, 384.739)
    ..cubicTo(62.143, 384.739, 63.0849, 381.599, 63.0849, 381.599)
    ..cubicTo(63.0849, 381.599, 101.745, 364.237, 101.745, 364.237)
    ..cubicTo(101.745, 364.237, 108.266, 363.912, 108.266, 363.912)
    ..cubicTo(108.461, 363.901, 108.611, 363.733, 108.602, 363.54)
    ..cubicTo(108.592, 363.344, 108.417, 363.176, 108.231, 363.205)
    ..cubicTo(108.231, 363.205, 101.643, 363.533, 101.643, 363.533)
    ..cubicTo(101.599, 363.537, 101.556, 363.548, 101.516, 363.565)
    ..cubicTo(101.516, 363.565, 72.0249, 376.809, 72.0249, 376.809)
    ..cubicTo(72.0417, 376.738, 72.0413, 376.659, 72.0074, 376.584)
    ..cubicTo(72.0074, 376.584, 61.8069, 354.283, 61.8069, 354.283)
    ..cubicTo(61.8069, 354.283, 65.1561, 352.8, 65.1561, 352.8)
    ..cubicTo(87.9355, 342.724, 141.281, 319.126, 158.811, 309.85)
    ..cubicTo(158.861, 309.822, 158.904, 309.786, 158.936, 309.74)
    ..cubicTo(158.936, 309.74, 160.362, 307.675, 160.362, 307.675)
    ..cubicTo(168.541, 314.001, 176.543, 320.205, 181.763, 324.269)
    ..cubicTo(181.763, 324.269, 186.62, 332.363, 186.62, 332.363)
    ..cubicTo(186.62, 332.363, 186.62, 339.842, 186.62, 339.842)
    ..cubicTo(186.62, 340.039, 186.778, 340.196, 186.973, 340.196)
    ..cubicTo(187.168, 340.196, 187.327, 340.039, 187.327, 339.842)
    ..cubicTo(187.327, 339.842, 187.327, 332.267, 187.327, 332.267)
    ..cubicTo(187.327, 332.202, 187.309, 332.138, 187.276, 332.084)
    ..cubicTo(187.276, 332.084, 182.335, 323.848, 182.335, 323.848)
    ..cubicTo(182.313, 323.812, 182.284, 323.78, 182.249, 323.752)
    ..cubicTo(177.023, 319.683, 168.982, 313.451, 160.764, 307.089)
    ..cubicTo(160.764, 307.089, 168.489, 295.903, 168.489, 295.903)
    ..cubicTo(168.599, 295.742, 168.559, 295.524, 168.399, 295.414)
    ..cubicTo(168.238, 295.299, 168.018, 295.342, 167.907, 295.503)
    ..cubicTo(167.907, 295.503, 160.205, 306.657, 160.205, 306.657)
    ..cubicTo(151.643, 300.032, 142.957, 293.324, 137.121, 288.834)
    ..cubicTo(136.966, 288.717, 136.745, 288.745, 136.625, 288.899)
    ..cubicTo(136.507, 289.056, 136.536, 289.277, 136.69, 289.395)
    ..cubicTo(142.532, 293.892, 151.232, 300.61, 159.802, 307.239)
    ..cubicTo(159.802, 307.239, 158.404, 309.265, 158.404, 309.265)
    ..cubicTo(152.644, 312.308, 143.063, 316.88, 131.984, 322.005)
    ..cubicTo(131.978, 321.962, 131.966, 321.919, 131.943, 321.88)
    ..cubicTo(131.943, 321.88, 120.535, 301.6, 120.535, 301.6)
    ..cubicTo(135.238, 291.749, 145.091, 278.669, 155.311, 265.097)
    ..cubicTo(163.142, 254.692, 171.24, 243.938, 181.943, 234.037)
    ..cubicTo(182.086, 233.905, 182.095, 233.68, 181.963, 233.537)
    ..cubicTo(181.829, 233.394, 181.606, 233.384, 181.463, 233.519)
    ..cubicTo(170.714, 243.463, 162.596, 254.246, 154.745, 264.672)
    ..cubicTo(144.581, 278.169, 134.781, 291.177, 120.184, 300.975)
    ..cubicTo(120.184, 300.975, 120.086, 300.8, 120.086, 300.8)
    ..cubicTo(119.99, 300.632, 119.775, 300.571, 119.604, 300.664)
    ..cubicTo(119.434, 300.76, 119.374, 300.978, 119.47, 301.146)
    ..cubicTo(119.47, 301.146, 119.593, 301.368, 119.593, 301.368)
    ..cubicTo(111.952, 306.404, 103.004, 310.572, 92.0179, 313.479)
    ..cubicTo(91.8293, 313.529, 91.7168, 313.722, 91.7668, 313.911)
    ..cubicTo(91.809, 314.069, 91.9519, 314.172, 92.1079, 314.172)
    ..cubicTo(92.1379, 314.172, 92.1687, 314.169, 92.199, 314.161)
    ..cubicTo(103.255, 311.236, 112.258, 307.05, 119.944, 301.989)
    ..cubicTo(119.944, 301.989, 131.327, 322.226, 131.327, 322.226)
    ..cubicTo(131.341, 322.251, 131.365, 322.266, 131.383, 322.284)
    ..cubicTo(108.723, 332.756, 80.028, 345.45, 64.87, 352.154)
    ..cubicTo(64.87, 352.154, 61.513, 353.64, 61.513, 353.64)
    ..cubicTo(61.513, 353.64, 52.5733, 334.095, 52.5733, 334.095)
    ..cubicTo(52.5087, 333.952, 52.3612, 333.881, 52.2133, 333.895)
    ..cubicTo(52.2133, 333.895, 66.6048, 327.123, 66.6048, 327.123)
    ..cubicTo(66.6048, 327.123, 75.648, 346.578, 75.648, 346.578)
    ..cubicTo(75.708, 346.707, 75.8356, 346.782, 75.9688, 346.782)
    ..cubicTo(76.0184, 346.782, 76.0695, 346.771, 76.1177, 346.75)
    ..cubicTo(76.2942, 346.668, 76.3713, 346.457, 76.2892, 346.282)
    ..cubicTo(76.2892, 346.282, 54.921, 300.307, 54.921, 300.307)
    ..cubicTo(54.921, 300.307, 55.6489, 299.992, 55.6489, 299.992)
    ..cubicTo(55.6489, 299.992, 78.3315, 293.092, 78.3315, 293.092)
    ..cubicTo(78.3315, 293.092, 90.8003, 292.763, 90.8003, 292.763)
    ..cubicTo(90.9954, 292.756, 91.1496, 292.595, 91.1446, 292.399)
    ..cubicTo(91.1393, 292.206, 90.9621, 292.053, 90.7818, 292.056)
    ..cubicTo(90.7818, 292.056, 78.2647, 292.385, 78.2647, 292.385)
    ..cubicTo(78.2329, 292.385, 78.2014, 292.392, 78.1711, 292.399)
    ..cubicTo(78.1711, 292.399, 55.4068, 299.332, 55.4068, 299.332)
    ..cubicTo(55.4068, 299.332, 54.6238, 299.667, 54.6238, 299.667)
    ..cubicTo(54.6238, 299.667, 54.5495, 299.507, 54.5495, 299.507)
    ..cubicTo(54.4667, 299.332, 54.2577, 299.253, 54.0795, 299.335)
    ..cubicTo(53.9027, 299.417, 53.8259, 299.628, 53.9081, 299.803)
    ..cubicTo(53.9081, 299.803, 53.9734, 299.946, 53.9734, 299.946)
    ..cubicTo(53.9734, 299.946, 27.6834, 311.218, 27.6834, 311.218)
    ..cubicTo(27.4927, 311.343, 8.5816, 323.73, 7.2972, 324.373)
    ..cubicTo(7.1222, 324.459, 7.0517, 324.673, 7.1389, 324.848)
    ..cubicTo(7.2007, 324.969, 7.3258, 325.041, 7.4554, 325.041)
    ..cubicTo(7.5086, 325.041, 7.5625, 325.03, 7.6129, 325.005)
    ..cubicTo(8.9341, 324.344, 27.2902, 312.322, 28.0163, 311.84)
    ..cubicTo(28.0163, 311.84, 54.2706, 300.585, 54.2706, 300.585)
    ..cubicTo(54.2706, 300.585, 66.3073, 326.48, 66.3073, 326.48)
    ..cubicTo(66.3073, 326.48, 21.798, 347.428, 21.798, 347.428)
    ..cubicTo(21.6212, 347.511, 21.5455, 347.721, 21.6283, 347.896)
    ..cubicTo(21.6887, 348.025, 21.8158, 348.1, 21.9487, 348.1)
    ..cubicTo(21.9991, 348.1, 22.0501, 348.089, 22.0987, 348.068)
    ..cubicTo(22.0987, 348.068, 52.004, 333.995, 52.004, 333.995)
    ..cubicTo(51.9029, 334.095, 51.8679, 334.252, 51.9308, 334.388)
    ..cubicTo(51.9308, 334.388, 60.8668, 353.925, 60.8668, 353.925)
    ..cubicTo(60.8668, 353.925, 60.6733, 354.011, 60.6733, 354.011)
    ..cubicTo(60.6733, 354.011, 60.6733, 354.011, 60.6733, 354.011)
    ..close();

  static final Path __path42_2_0 = Path()
    ..moveTo(257.753, 280.155)
    ..cubicTo(255.382, 279.274, 254.125, 276.683, 254.899, 274.275)
    ..cubicTo(255.748, 271.631, 258.683, 270.284, 261.242, 271.365)
    ..cubicTo(261.242, 271.365, 267.009, 273.801, 267.009, 273.801)
    ..cubicTo(269.37, 274.798, 270.458, 277.535, 269.426, 279.882)
    ..cubicTo(268.446, 282.109, 265.9, 283.185, 263.62, 282.337)
    ..cubicTo(263.62, 282.337, 257.753, 280.155, 257.753, 280.155)
    ..cubicTo(257.753, 280.155, 257.753, 280.155, 257.753, 280.155)
    ..close();

  static final Path __path42_3_0 = Path()
    ..moveTo(273.937, -178.621)
    ..cubicTo(273.937, -178.621, 268.337, -169.395, 268.337, -169.395)
    ..cubicTo(268.337, -169.395, 270.973, -165.774, 270.973, -165.774)
    ..cubicTo(270.973, -165.774, 287.77, -163.798, 287.77, -163.798)
    ..cubicTo(287.77, -163.798, 287.442, -147.658, 287.442, -147.658)
    ..cubicTo(287.442, -147.658, 278.22, -128.224, 278.22, -128.224)
    ..cubicTo(278.22, -128.224, 273.609, -124.927, 273.609, -124.927)
    ..cubicTo(273.609, -124.927, 270.973, -119.659, 270.973, -119.659)
    ..cubicTo(270.973, -119.659, 265.701, -120.648, 265.701, -120.648)
    ..cubicTo(265.701, -120.648, 258.784, -112.412, 258.784, -112.412)
    ..cubicTo(258.784, -112.412, 258.784, -98.2502, 258.784, -98.2502)
    ..cubicTo(258.784, -98.2502, 262.078, -97.5895, 262.078, -97.5895)
    ..cubicTo(262.078, -97.5895, 264.713, -95.2821, 264.713, -95.2821)
    ..cubicTo(264.713, -95.2821, 263.066, -92.9783, 263.066, -92.9783)
    ..cubicTo(263.066, -92.9783, 271.301, -87.7065, 271.301, -87.7065)
    ..cubicTo(271.301, -87.7065, 285.467, -87.0493, 285.467, -87.0493)
    ..cubicTo(285.467, -87.0493, 288.431, -90.0138, 288.431, -90.0138)
    ..cubicTo(288.431, -90.0138, 303.254, -90.671, 303.254, -90.671)
    ..cubicTo(303.254, -90.671, 313.794, -70.9087, 313.794, -70.9087)
    ..cubicTo(313.794, -70.9087, 316.758, -71.5695, 316.758, -71.5695)
    ..cubicTo(316.758, -71.5695, 317.416, -68.2728, 317.416, -68.2728)
    ..cubicTo(317.416, -68.2728, 321.041, -65.6404, 321.041, -65.6404)
    ..cubicTo(321.041, -65.6404, 316.098, -65.3083, 316.098, -65.3083)
    ..cubicTo(316.098, -65.3083, 315.108, -62.3437, 315.108, -62.3437)
    ..cubicTo(315.108, -62.3437, 310.829, -60.04, 310.829, -60.04)
    ..cubicTo(310.829, -60.04, 309.84, -47.5211, 309.84, -47.5211)
    ..cubicTo(309.84, -47.5211, 307.533, -48.1819, 307.533, -48.1819)
    ..cubicTo(307.533, -48.1819, 305.558, -43.8994, 305.558, -43.8994)
    ..cubicTo(305.558, -43.8994, 312.144, -39.9455, 312.144, -39.9455)
    ..cubicTo(312.144, -39.9455, 303.911, -39.2883, 303.911, -39.2883)
    ..cubicTo(303.911, -39.2883, 301.936, -37.6417, 301.936, -37.6417)
    ..cubicTo(301.936, -37.6417, 298.639, -38.9597, 298.639, -38.9597)
    ..cubicTo(298.639, -38.9597, 266.69, -31.0519, 266.69, -31.0519)
    ..cubicTo(266.69, -31.0519, 252.196, -18.208, 252.196, -18.208)
    ..cubicTo(252.196, -18.208, 249.891, -13.9255, 249.891, -13.9255)
    ..cubicTo(249.891, -13.9255, 249.891, -3.714, 249.891, -3.714)
    ..cubicTo(249.891, -3.714, 245.279, -3.714, 245.279, -3.714)
    ..cubicTo(245.279, -3.714, 244.95, 10.78, 244.95, 10.78)
    ..cubicTo(244.95, 10.78, 253.185, 31.5317, 253.185, 31.5317)
    ..cubicTo(253.185, 31.5317, 265.701, 40.7539, 265.701, 40.7539)
    ..cubicTo(265.701, 40.7539, 277.23, 46.3543, 277.23, 46.3543)
    ..cubicTo(277.23, 46.3543, 293.371, 51.9548, 293.371, 51.9548)
    ..cubicTo(293.371, 51.9548, 294.357, 44.047, 294.357, 44.047)
    ..cubicTo(294.357, 44.047, 296.664, 39.1073, 296.664, 39.1073)
    ..cubicTo(296.664, 39.1073, 294.689, 38.7787, 294.689, 38.7787)
    ..cubicTo(294.689, 38.7787, 296.335, 35.8142, 296.335, 35.8142)
    ..cubicTo(296.335, 35.8142, 301.275, 38.7787, 301.275, 38.7787)
    ..cubicTo(301.275, 38.7787, 300.946, 44.7078, 300.946, 44.7078)
    ..cubicTo(300.946, 44.7078, 296.993, 44.7078, 296.993, 44.7078)
    ..cubicTo(296.993, 44.7078, 295.675, 51.9548, 295.675, 51.9548)
    ..cubicTo(295.675, 51.9548, 305.886, 51.9548, 305.886, 51.9548)
    ..cubicTo(305.886, 51.9548, 310.497, 46.6829, 310.497, 46.6829)
    ..cubicTo(310.497, 46.6829, 315.769, 43.0612, 315.769, 43.0612)
    ..cubicTo(315.769, 43.0612, 325.652, 44.047, 325.652, 44.047)
    ..cubicTo(325.652, 44.047, 331.249, 35.1534, 331.249, 35.1534)
    ..cubicTo(331.249, 35.1534, 330.263, 29.5565, 330.263, 29.5565)
    ..cubicTo(330.263, 29.5565, 331.581, 28.5672, 331.581, 28.5672)
    ..cubicTo(331.581, 28.5672, 328.617, 20.3308, 328.617, 20.3308)
    ..cubicTo(328.617, 20.3308, 334.213, 17.6984, 334.213, 17.6984)
    ..cubicTo(334.213, 17.6984, 338.825, 29.2244, 338.825, 29.2244)
    ..cubicTo(338.825, 29.2244, 350.686, 21.3202, 350.686, 21.3202)
    ..cubicTo(350.686, 21.3202, 346.072, 9.7906, 346.072, 9.7906)
    ..cubicTo(346.072, 9.7906, 342.778, 10.78, 342.778, 10.78)
    ..cubicTo(342.778, 10.78, 341.46, 5.1796, 341.46, 5.1796)
    ..cubicTo(341.46, 5.1796, 370.448, -7.9965, 370.448, -7.9965)
    ..cubicTo(370.448, -7.9965, 379.671, 12.098, 379.671, 12.098)
    ..cubicTo(379.671, 12.098, 371.434, 15.0625, 371.434, 15.0625)
    ..cubicTo(371.434, 15.0625, 364.191, -1.7352, 364.191, -1.7352)
    ..cubicTo(364.191, -1.7352, 348.379, 4.851, 348.379, 4.851)
    ..cubicTo(348.379, 4.851, 364.848, 38.118, 364.848, 38.118)
    ..cubicTo(364.848, 38.118, 360.237, 40.7539, 360.237, 40.7539)
    ..cubicTo(360.237, 40.7539, 354.636, 26.2599, 354.636, 26.2599)
    ..cubicTo(354.636, 26.2599, 349.697, 28.8958, 349.697, 28.8958)
    ..cubicTo(349.697, 28.8958, 351.261, 31.2853, 351.261, 31.2853)
    ..cubicTo(351.261, 31.2853, 347.307, 33.014, 347.307, 33.014)
    ..cubicTo(347.307, 33.014, 345.825, 30.2959, 345.825, 30.2959)
    ..cubicTo(345.825, 30.2959, 337.674, 35.4856, 337.674, 35.4856)
    ..cubicTo(337.674, 35.4856, 336.932, 42.4004, 336.932, 42.4004)
    ..cubicTo(336.932, 42.4004, 338.414, 43.3898, 338.414, 43.3898)
    ..cubicTo(338.414, 43.3898, 344.839, 41.4146, 344.839, 41.4146)
    ..cubicTo(344.839, 41.4146, 346.072, 43.3898, 346.072, 43.3898)
    ..cubicTo(346.072, 43.3898, 336.439, 46.1079, 336.439, 46.1079)
    ..cubicTo(336.439, 46.1079, 337.921, 51.294, 337.921, 51.294)
    ..cubicTo(337.921, 51.294, 342.614, 55.7408, 342.614, 55.7408)
    ..cubicTo(342.614, 55.7408, 349.036, 66.6131, 349.036, 66.6131)
    ..cubicTo(349.036, 66.6131, 354.226, 67.8489, 354.226, 67.8489)
    ..cubicTo(354.226, 67.8489, 361.144, 65.8702, 361.144, 65.8702)
    ..cubicTo(361.144, 65.8702, 362.623, 68.5883, 362.623, 68.5883)
    ..cubicTo(362.623, 68.5883, 373.249, 67.3525, 373.249, 67.3525)
    ..cubicTo(373.249, 67.3525, 373.988, 69.0811, 373.988, 69.0811)
    ..cubicTo(373.988, 69.0811, 378.931, 66.8596, 378.931, 66.8596)
    ..cubicTo(378.931, 66.8596, 380.164, 62.1663, 380.164, 62.1663)
    ..cubicTo(380.164, 62.1663, 383.871, 62.4128, 383.871, 62.4128)
    ..cubicTo(383.871, 62.4128, 385.353, 57.966, 385.353, 57.966)
    ..cubicTo(385.353, 57.966, 387.328, 57.223, 387.328, 57.223)
    ..cubicTo(387.328, 57.223, 388.564, 52.0369, 388.564, 52.0369)
    ..cubicTo(388.564, 52.0369, 392.268, 47.5902, 392.268, 47.5902)
    ..cubicTo(392.268, 47.5902, 404.869, 41.6611, 404.869, 41.6611)
    ..cubicTo(404.869, 41.6611, 406.105, 39.1895, 406.105, 39.1895)
    ..cubicTo(406.105, 39.1895, 412.034, 38.4501, 412.034, 38.4501)
    ..cubicTo(412.034, 38.4501, 414.256, 41.6611, 414.256, 41.6611)
    ..cubicTo(414.256, 41.6611, 414.009, 45.615, 414.009, 45.615)
    ..cubicTo(414.009, 45.615, 417.22, 47.0972, 417.22, 47.0972)
    ..cubicTo(417.22, 47.0972, 419.692, 45.615, 419.692, 45.615)
    ..cubicTo(419.692, 45.615, 420.681, 46.8472, 420.681, 46.8472)
    ..cubicTo(420.681, 46.8472, 427.35, 47.0972, 427.35, 47.0972)
    ..cubicTo(427.35, 47.0972, 430.068, 43.6363, 430.068, 43.6363)
    ..cubicTo(430.068, 43.6363, 430.811, 29.5565, 430.811, 29.5565)
    ..cubicTo(430.811, 29.5565, 437.972, 28.5672, 437.972, 28.5672)
    ..cubicTo(437.972, 28.5672, 436.986, 23.131, 436.986, 23.131)
    ..cubicTo(436.986, 23.131, 440.443, 29.3101, 440.443, 29.3101)
    ..cubicTo(440.443, 29.3101, 442.915, 32.0246, 442.915, 32.0246)
    ..cubicTo(442.915, 32.0246, 439.454, 33.014, 439.454, 33.014)
    ..cubicTo(439.454, 33.014, 437.725, 31.0388, 437.725, 31.0388)
    ..cubicTo(437.725, 31.0388, 433.032, 31.2853, 433.032, 31.2853)
    ..cubicTo(433.032, 31.2853, 432.786, 35.7321, 432.786, 35.7321)
    ..cubicTo(432.786, 35.7321, 441.679, 35.7321, 441.679, 35.7321)
    ..cubicTo(441.679, 35.7321, 441.926, 41.1682, 441.926, 41.1682)
    ..cubicTo(441.926, 41.1682, 452.794, 40.6717, 452.794, 40.6717)
    ..cubicTo(452.794, 40.6717, 456.502, 43.3898, 456.502, 43.3898)
    ..cubicTo(456.502, 43.3898, 469.099, 72.7886, 469.099, 72.7886)
    ..cubicTo(469.099, 72.7886, 464.653, 74.5173, 464.653, 74.5173)
    ..cubicTo(464.653, 74.5173, 466.631, 79.2106, 466.631, 79.2106)
    ..cubicTo(466.631, 79.2106, 466.135, 103.173, 466.135, 103.173)
    ..cubicTo(466.135, 103.173, 479.229, 98.9764, 479.229, 98.9764)
    ..cubicTo(479.229, 98.9764, 481.947, 104.655, 481.947, 104.655)
    ..cubicTo(481.947, 104.655, 476.757, 106.384, 476.757, 106.384)
    ..cubicTo(476.757, 106.384, 477.254, 109.845, 477.254, 109.845)
    ..cubicTo(477.254, 109.845, 472.31, 111.327, 472.31, 111.327)
    ..cubicTo(472.31, 111.327, 474.782, 117.503, 474.782, 117.503)
    ..cubicTo(474.782, 117.503, 479.722, 116.514, 479.722, 116.514)
    ..cubicTo(479.722, 116.514, 502.452, 171.357, 502.452, 171.357)
    ..cubicTo(502.452, 171.357, 494.298, 173.336, 494.298, 173.336)
    ..cubicTo(494.298, 173.336, 497.759, 182.23, 497.759, 182.23)
    ..cubicTo(497.759, 182.23, 507.392, 187.662, 507.392, 187.662)
    ..cubicTo(507.392, 187.662, 511.592, 199.767, 511.592, 199.767)
    ..cubicTo(511.592, 199.767, 519.743, 200.263, 519.743, 200.263)
    ..cubicTo(519.743, 200.263, 530.369, 200.756, 530.369, 200.756)
    ..cubicTo(530.369, 200.756, 538.026, 197.792, 538.026, 197.792)
    ..cubicTo(538.026, 197.792, 528.39, 173.829, 528.39, 173.829)
    ..cubicTo(528.39, 173.829, 531.354, 172.1, 531.354, 172.1)
    ..cubicTo(531.354, 172.1, 533.58, 173.086, 533.58, 173.086)
    ..cubicTo(533.58, 173.086, 535.555, 172.347, 535.555, 172.347)
    ..cubicTo(535.555, 172.347, 535.308, 168.146, 535.308, 168.146)
    ..cubicTo(535.308, 168.146, 538.026, 167.407, 538.026, 167.407)
    ..cubicTo(538.026, 167.407, 537.283, 163.453, 537.283, 163.453)
    ..cubicTo(537.283, 163.453, 551.86, 157.031, 551.86, 157.031)
    ..cubicTo(551.86, 157.031, 554.824, 161.724, 554.824, 161.724)
    ..cubicTo(554.824, 161.724, 559.517, 160.242, 559.517, 160.242)
    ..cubicTo(559.517, 160.242, 564.211, 174.322, 564.211, 174.322)
    ..cubicTo(564.211, 174.322, 561.246, 175.558, 561.246, 175.558)
    ..cubicTo(561.246, 175.558, 558.035, 163.453, 558.035, 163.453)
    ..cubicTo(558.035, 163.453, 553.342, 165.182, 553.342, 165.182)
    ..cubicTo(553.342, 165.182, 552.352, 170.121, 552.352, 170.121)
    ..cubicTo(552.352, 170.121, 549.388, 168.889, 549.388, 168.889)
    ..cubicTo(549.388, 168.889, 546.177, 170.864, 546.177, 170.864)
    ..cubicTo(546.177, 170.864, 546.177, 173.086, 546.177, 173.086)
    ..cubicTo(546.177, 173.086, 553.835, 183.958, 553.835, 183.958)
    ..cubicTo(553.835, 183.958, 555.071, 188.405, 555.071, 188.405)
    ..cubicTo(555.071, 188.405, 544.941, 195.57, 544.941, 195.57)
    ..cubicTo(544.941, 195.57, 546.177, 198.284, 546.177, 198.284)
    ..cubicTo(546.177, 198.284, 532.837, 203.721, 532.837, 203.721)
    ..cubicTo(532.837, 203.721, 534.072, 205.946, 534.072, 205.946)
    ..cubicTo(534.072, 205.946, 499.487, 218.297, 499.487, 218.297)
    ..cubicTo(499.487, 218.297, 498.745, 228.426, 498.745, 228.426)
    ..cubicTo(498.745, 228.426, 500.97, 235.341, 500.97, 235.341)
    ..cubicTo(500.97, 235.341, 502.452, 241.27, 502.452, 241.27)
    ..cubicTo(502.452, 241.27, 506.156, 242.013, 506.156, 242.013)
    ..cubicTo(506.156, 242.013, 503.688, 246.706, 503.688, 246.706)
    ..cubicTo(503.688, 246.706, 505.909, 259.057, 505.909, 259.057)
    ..cubicTo(505.909, 259.057, 509.617, 271.165, 509.617, 271.165)
    ..cubicTo(509.617, 271.165, 520.486, 286.727, 520.486, 286.727)
    ..cubicTo(520.486, 286.727, 535.062, 299.325, 535.062, 299.325)
    ..cubicTo(535.062, 299.325, 547.906, 317.112, 547.906, 317.112)
    ..cubicTo(547.906, 317.112, 550.131, 316.865, 550.131, 316.865)
    ..cubicTo(550.131, 316.865, 551.613, 319.583, 551.613, 319.583)
    ..cubicTo(551.613, 319.583, 559.517, 319.83, 559.517, 319.83)
    ..cubicTo(559.517, 319.83, 559.764, 326.502, 559.764, 326.502)
    ..cubicTo(559.764, 326.502, 562.728, 326.255, 562.728, 326.255)
    ..cubicTo(562.728, 326.255, 562.728, 334.16, 562.728, 334.16)
    ..cubicTo(562.728, 334.16, 560.26, 338.606, 560.26, 338.606)
    ..cubicTo(560.26, 338.606, 564.707, 341.078, 564.707, 341.078)
    ..cubicTo(564.707, 341.078, 561, 342.31, 561, 342.31)
    ..cubicTo(561, 342.31, 563.718, 345.278, 563.718, 345.278)
    ..cubicTo(563.718, 345.278, 561.743, 347.746, 561.743, 347.746)
    ..cubicTo(561.743, 347.746, 561.743, 363.558, 561.743, 363.558)
    ..cubicTo(561.743, 363.558, 559.764, 362.569, 559.764, 362.569)
    ..cubicTo(559.764, 362.569, 560.26, 387.275, 560.26, 387.275)
    ..cubicTo(560.26, 387.275, 563.225, 392.461, 563.225, 392.461)
    ..cubicTo(563.225, 392.461, 564.211, 398.39, 564.211, 398.39)
    ..cubicTo(564.211, 398.39, 563.718, 402.837, 563.718, 402.837)
    ..cubicTo(563.718, 402.837, 560.753, 407.53, 560.753, 407.53)
    ..cubicTo(560.753, 407.53, 555.813, 410.991, 555.813, 410.991)
    ..cubicTo(555.813, 410.991, 553.835, 416.673, 553.835, 416.673)
    ..cubicTo(553.835, 416.673, 555.317, 421.367, 555.317, 421.367)
    ..cubicTo(555.317, 421.367, 552.106, 422.603, 552.106, 422.603)
    ..cubicTo(552.106, 422.603, 552.106, 433.225, 552.106, 433.225)
    ..cubicTo(552.106, 433.225, 549.142, 433.225, 549.142, 433.225)
    ..cubicTo(549.142, 433.225, 549.142, 437.175, 549.142, 437.175)
    ..cubicTo(549.142, 437.175, 552.849, 437.175, 552.849, 437.175)
    ..cubicTo(552.849, 437.175, 552.849, 439.893, 552.849, 439.893)
    ..cubicTo(552.849, 439.893, 548.402, 439.4, 548.402, 439.4)
    ..cubicTo(548.402, 439.4, 549.142, 444.34, 549.142, 444.34)
    ..cubicTo(549.142, 444.34, 544.941, 447.801, 544.941, 447.801)
    ..cubicTo(544.941, 447.801, 543.459, 447.058, 543.459, 447.058)
    ..cubicTo(543.459, 447.058, 539.509, 456.445, 539.509, 456.445)
    ..cubicTo(539.509, 456.445, 536.298, 456.445, 536.298, 456.445)
    ..cubicTo(536.298, 456.445, 533.58, 467.81, 533.58, 467.81)
    ..cubicTo(533.58, 467.81, 533.083, 472.503, 533.083, 472.503)
    ..cubicTo(533.083, 472.503, 533.826, 475.714, 533.826, 475.714)
    ..cubicTo(533.826, 475.714, 541.484, 481.643, 541.484, 481.643)
    ..cubicTo(541.484, 481.643, 540.494, 484.115, 540.494, 484.115)
    ..cubicTo(540.494, 484.115, 538.026, 486.34, 538.026, 486.34)
    ..cubicTo(538.026, 486.34, 534.072, 487.572, 534.072, 487.572)
    ..cubicTo(534.072, 487.572, 534.565, 491.279, 534.565, 491.279)
    ..cubicTo(534.565, 491.279, 531.851, 490.537, 531.851, 490.537)
    ..cubicTo(531.851, 490.537, 533.58, 495.973, 533.58, 495.973)
    ..cubicTo(533.58, 495.973, -71.2656, 495.973, -71.2656, 495.973)
    ..cubicTo(-71.2656, 495.973, -71.2656, -178.95, -71.2656, -178.95)
    ..cubicTo(-71.2656, -178.95, 273.609, -178.289, 273.937, -178.621)
    ..cubicTo(273.937, -178.621, 273.937, -178.621, 273.937, -178.621)
    ..close();

  static final Path __path42_4_0 = Path()
    ..moveTo(42, 0)
    ..cubicTo(42, 0, 248.427, 0, 248.427, 0)
    ..cubicTo(271.623, 0, 290.427, 18.804, 290.427, 42)
    ..cubicTo(290.427, 42, 290.427, 310.662, 290.427, 310.662)
    ..cubicTo(290.427, 333.858, 271.623, 352.662, 248.427, 352.662)
    ..cubicTo(248.427, 352.662, 42, 352.662, 42, 352.662)
    ..cubicTo(18.804, 352.662, 0, 333.858, 0, 310.662)
    ..cubicTo(0, 310.662, 0, 42, 0, 42)
    ..cubicTo(0, 18.804, 18.804, 0, 42, 0)
    ..close();

  static final Path __maskPath42_0 = Path()
    ..moveTo(42, 0)
    ..cubicTo(42, 0, 248.427, 0, 248.427, 0)
    ..cubicTo(271.623, 0, 290.427, 18.804, 290.427, 42)
    ..cubicTo(290.427, 42, 290.427, 310.662, 290.427, 310.662)
    ..cubicTo(290.427, 333.858, 271.623, 352.662, 248.427, 352.662)
    ..cubicTo(248.427, 352.662, 42, 352.662, 42, 352.662)
    ..cubicTo(18.804, 352.662, 0, 333.858, 0, 310.662)
    ..cubicTo(0, 310.662, 0, 42, 0, 42)
    ..cubicTo(0, 18.804, 18.804, 0, 42, 0)
    ..close();

  static final Path __path47_0_0 = Path()
    ..moveTo(44, 10)
    ..cubicTo(44, 10, 247, 10, 247, 10)
    ..cubicTo(265.2254, 10, 280, 24.7746, 280, 43)
    ..cubicTo(280, 43, 280, 136.045, 280, 136.045)
    ..cubicTo(280, 154.2704, 265.2254, 169.045, 247, 169.045)
    ..cubicTo(247, 169.045, 44, 169.045, 44, 169.045)
    ..cubicTo(25.7746, 169.045, 11, 154.2704, 11, 136.045)
    ..cubicTo(11, 136.045, 11, 43, 11, 43)
    ..cubicTo(11, 24.7746, 25.7746, 10, 44, 10)
    ..close();

  static final Path __path47_1_0 = Path()
    ..moveTo(-23.264, 560.636)
    ..cubicTo(-47.6263, 523.576, -72.7655, 485.33, -89.4254, 456.049)
    ..cubicTo(-36.4404, 422.343, 19.5684, 385.522, 71.953, 350.948)
    ..cubicTo(72.9163, 352.394, 73.8821, 353.844, 74.8564, 355.309)
    ..cubicTo(98.1658, 390.333, 122.218, 426.475, 149.691, 455.66)
    ..cubicTo(149.631, 455.72, 149.567, 455.785, 149.509, 455.845)
    ..cubicTo(149.48, 455.874, 149.454, 455.906, 149.428, 455.938)
    ..cubicTo(148.031, 457.735, 145.483, 461.131, 142.258, 465.432)
    ..cubicTo(131.675, 479.54, 112.023, 505.739, 106.523, 510.382)
    ..cubicTo(76.1244, 526.312, 25.9839, 549.324, -17.7853, 568.972)
    ..cubicTo(-19.6012, 566.208, -21.4256, 563.433, -23.264, 560.636)
    ..cubicTo(-23.264, 560.636, -23.264, 560.636, -23.264, 560.636)
    ..close();

  static final Path __path47_1_1 = Path()
    ..moveTo(-92.4238, 450.713)
    ..cubicTo(-92.4238, 450.713, -92.7528, 268.33, -92.7528, 268.33)
    ..cubicTo(-92.7528, 268.33, -91.8095, 265.187, -91.8095, 265.187)
    ..cubicTo(-91.3513, 263.658, -91.0723, 262.73, -90.9298, 262.137)
    ..cubicTo(-84.2471, 251.9, -74.1274, 241.457, -64.3401, 231.359)
    ..cubicTo(-57.9528, 224.77, -51.4312, 218.033, -45.7729, 211.272)
    ..cubicTo(-43.8446, 211.586, -41.9098, 211.897, -39.971, 212.197)
    ..cubicTo(-22.1085, 214.983, -5.899, 216.89, 8.5454, 217.908)
    ..cubicTo(8.5454, 217.908, 9.2151, 233.306, 9.2151, 233.306)
    ..cubicTo(9.219, 233.399, 9.2347, 233.488, 9.2622, 233.577)
    ..cubicTo(9.2622, 233.577, 14.203, 249.386, 14.203, 249.386)
    ..cubicTo(14.248, 249.532, 14.3234, 249.664, 14.4234, 249.779)
    ..cubicTo(16.0206, 251.568, 30.1235, 267.494, 34.3421, 275.534)
    ..cubicTo(37.9174, 284.581, 45.3162, 306.115, 48.4586, 316.252)
    ..cubicTo(48.4911, 316.355, 48.54, 316.455, 48.6036, 316.548)
    ..cubicTo(55.9524, 327.006, 63.2194, 337.839, 70.7772, 349.183)
    ..cubicTo(18.4322, 383.732, -37.5298, 420.525, -90.4715, 454.202)
    ..cubicTo(-91.1352, 453.027, -91.7895, 451.859, -92.4238, 450.713)
    ..cubicTo(-92.4238, 450.713, -92.4238, 450.713, -92.4238, 450.713)
    ..close();

  static final Path __path47_1_2 = Path()
    ..moveTo(-37.3805, 200.1)
    ..cubicTo(-34.047, 197.967, -24.7927, 193.178, -20.907, 191.403)
    ..cubicTo(-20.7334, 191.324, -20.5845, 191.199, -20.4755, 191.042)
    ..cubicTo(-20.4755, 191.042, -19.1276, 189.095, -19.1276, 189.095)
    ..cubicTo(-19.1276, 189.095, 8.5083, 202.607, 8.5083, 202.607)
    ..cubicTo(8.5083, 202.607, 8.2264, 210.493, 8.2264, 210.493)
    ..cubicTo(8.2257, 210.522, 8.2257, 210.55, 8.2268, 210.579)
    ..cubicTo(8.2268, 210.579, 8.4557, 215.847, 8.4557, 215.847)
    ..cubicTo(-4.6289, 214.883, -21.7899, 212.961, -44.1724, 209.329)
    ..cubicTo(-41.679, 206.254, -39.3796, 203.171, -37.3805, 200.1)
    ..cubicTo(-37.3805, 200.1, -37.3805, 200.1, -37.3805, 200.1)
    ..close();

  static final Path __path47_1_3 = Path()
    ..moveTo(-42.3555, 114.007)
    ..cubicTo(-42.3555, 114.007, -41.7001, 91.398, -41.7001, 91.398)
    ..cubicTo(-41.7001, 91.398, -38.1216, 70.5785, -38.1216, 70.5785)
    ..cubicTo(-37.4283, 69.3855, -33.1837, 62.0742, -32.4111, 60.7455)
    ..cubicTo(-26.1921, 56.5809, -18.6879, 52.477, -10.604, 48.6945)
    ..cubicTo(-4.2803, 62.4099, 2.117, 76.454, 8.2636, 90.0051)
    ..cubicTo(8.2636, 90.0051, -2.4298, 104.16, -2.4298, 104.16)
    ..cubicTo(-2.5387, 104.303, -2.6087, 104.474, -2.6337, 104.653)
    ..cubicTo(-4.5056, 118.061, -5.779, 143.824, -4.615, 156.935)
    ..cubicTo(-4.615, 156.935, -4.5942, 156.932, -4.5942, 156.932)
    ..cubicTo(-4.4842, 157.36, -4.0042, 158.2, -2.6269, 160.611)
    ..cubicTo(-2.6269, 160.611, 7.2692, 177.93, 7.2692, 177.93)
    ..cubicTo(7.2692, 177.93, 8.8826, 192.128, 8.8826, 192.128)
    ..cubicTo(8.8826, 192.128, 8.5911, 200.289, 8.5911, 200.289)
    ..cubicTo(8.5911, 200.289, -17.9068, 187.334, -17.9068, 187.334)
    ..cubicTo(-17.9068, 187.334, -17.511, 186.763, -17.511, 186.763)
    ..cubicTo(-17.4121, 186.616, -17.3492, 186.452, -17.3296, 186.281)
    ..cubicTo(-17.3296, 186.281, -16.3413, 177.716, -16.3413, 177.716)
    ..cubicTo(-16.3088, 177.434, -16.3909, 177.148, -16.5691, 176.926)
    ..cubicTo(-24.0151, 167.69, -41.6897, 126.054, -42.3555, 114.007)
    ..cubicTo(-42.3555, 114.007, -42.3555, 114.007, -42.3555, 114.007)
    ..close();

  static final Path __path47_1_4 = Path()
    ..moveTo(170.472, 152.153)
    ..cubicTo(170.472, 152.153, 171.912, 153.01, 171.912, 153.01)
    ..cubicTo(176.858, 155.96, 177.496, 156.339, 181.354, 161.618)
    ..cubicTo(181.354, 161.618, 176.282, 175.248, 176.282, 175.248)
    ..cubicTo(176.249, 175.333, 176.229, 175.426, 176.22, 175.519)
    ..cubicTo(176.22, 175.519, 174.902, 189.684, 174.902, 189.684)
    ..cubicTo(174.886, 189.863, 174.915, 190.042, 174.987, 190.206)
    ..cubicTo(174.987, 190.206, 184.21, 211.286, 184.21, 211.286)
    ..cubicTo(184.29, 211.468, 184.419, 211.626, 184.584, 211.74)
    ..cubicTo(184.584, 211.74, 199.076, 221.619, 199.076, 221.619)
    ..cubicTo(199.133, 221.659, 199.194, 221.691, 199.254, 221.716)
    ..cubicTo(199.254, 221.716, 220.667, 230.941, 220.667, 230.941)
    ..cubicTo(220.774, 230.988, 220.892, 231.016, 221.013, 231.024)
    ..cubicTo(221.013, 231.024, 240.447, 232.342, 240.447, 232.342)
    ..cubicTo(240.518, 232.349, 240.59, 232.345, 240.665, 232.334)
    ..cubicTo(240.665, 232.334, 261.792, 229.409, 261.792, 229.409)
    ..cubicTo(261.792, 229.409, 268.489, 232.149, 268.489, 232.149)
    ..cubicTo(269.831, 234.038, 278.304, 245.975, 279.114, 247.125)
    ..cubicTo(279.643, 248.382, 280.097, 251.111, 280.489, 254.679)
    ..cubicTo(277.107, 254.861, 274.085, 255.033, 271.685, 255.172)
    ..cubicTo(271.685, 255.172, 270.103, 255.261, 270.103, 255.261)
    ..cubicTo(269.521, 255.293, 269.074, 255.793, 269.106, 256.379)
    ..cubicTo(269.139, 256.961, 269.646, 257.408, 270.224, 257.376)
    ..cubicTo(270.224, 257.376, 271.807, 257.286, 271.807, 257.286)
    ..cubicTo(274.228, 257.151, 277.282, 256.976, 280.704, 256.79)
    ..cubicTo(281.622, 266.344, 282.168, 280.306, 282.518, 289.153)
    ..cubicTo(282.675, 293.186, 282.804, 296.422, 282.918, 298.208)
    ..cubicTo(281.29, 300.804, 279.986, 302.969, 278.932, 304.715)
    ..cubicTo(277.936, 306.373, 277.114, 307.733, 276.357, 308.908)
    ..cubicTo(276.3, 308.962, 276.246, 309.019, 276.2, 309.087)
    ..cubicTo(276.15, 309.162, 276.118, 309.241, 276.086, 309.319)
    ..cubicTo(272.907, 314.159, 270.624, 315.827, 260.334, 322.699)
    ..cubicTo(260.334, 322.699, 245.808, 326.571, 245.808, 326.571)
    ..cubicTo(245.808, 326.571, 198.661, 327.063, 198.661, 327.063)
    ..cubicTo(198.661, 327.063, 183.179, 322.71, 183.179, 322.71)
    ..cubicTo(183.179, 322.71, 169.124, 312.53, 169.124, 312.53)
    ..cubicTo(168.232, 311.394, 161.032, 302.211, 155.598, 295.286)
    ..cubicTo(155.62, 295.054, 155.571, 294.814, 155.433, 294.604)
    ..cubicTo(155.26, 294.339, 154.99, 294.182, 154.701, 294.139)
    ..cubicTo(152.109, 290.836, 150.065, 288.228, 149.57, 287.6)
    ..cubicTo(142.949, 267.126, 139.497, 253.854, 139.305, 248.143)
    ..cubicTo(139.305, 248.143, 141.762, 231.438, 141.762, 231.438)
    ..cubicTo(141.803, 231.159, 141.731, 230.874, 141.562, 230.649)
    ..cubicTo(141.393, 230.424, 141.141, 230.274, 140.861, 230.234)
    ..cubicTo(139.937, 230.102, 52.9786, 217.805, 43.8239, 216.512)
    ..cubicTo(40.6619, 196.356, 31.1954, 144.634, 28.1127, 128.805)
    ..cubicTo(28.0973, 128.722, 28.072, 128.644, 28.038, 128.569)
    ..cubicTo(28.038, 128.569, 22.4126, 116.129, 22.4126, 116.129)
    ..cubicTo(18.7391, 107.999, 14.862, 99.4236, 10.8734, 90.6265)
    ..cubicTo(10.8734, 90.6265, 32.9209, 82.1222, 32.9209, 82.1222)
    ..cubicTo(32.9209, 82.1222, 59.0405, 79.5113, 59.0405, 79.5113)
    ..cubicTo(59.0405, 79.5113, 102.288, 82.458, 102.288, 82.458)
    ..cubicTo(102.288, 82.458, 113.196, 86.3083, 113.196, 86.3083)
    ..cubicTo(113.196, 86.3083, 145.176, 110.457, 145.176, 110.457)
    ..cubicTo(151.124, 120.6, 163.504, 141.188, 170.117, 151.803)
    ..cubicTo(170.206, 151.946, 170.327, 152.064, 170.472, 152.153)
    ..cubicTo(170.472, 152.153, 170.472, 152.153, 170.472, 152.153)
    ..close();

  static final Path __path47_1_5 = Path()
    ..moveTo(323.161, 255.386)
    ..cubicTo(325, 256.711, 336.09, 264.708, 337.008, 265.369)
    ..cubicTo(343.148, 271.295, 348.531, 277.963, 353.345, 285.164)
    ..cubicTo(353.345, 285.164, 353.345, 294.032, 353.345, 294.032)
    ..cubicTo(353.345, 294.386, 353.52, 294.714, 353.813, 294.911)
    ..cubicTo(353.813, 294.911, 362.6, 300.843, 362.6, 300.843)
    ..cubicTo(368.318, 311.741, 373.186, 323.388, 377.697, 335.236)
    ..cubicTo(376.929, 339.118, 376.022, 343.247, 375.733, 343.883)
    ..cubicTo(375.483, 344.293, 375.544, 344.822, 375.879, 345.172)
    ..cubicTo(375.879, 345.172, 384.648, 354.155, 384.648, 354.155)
    ..cubicTo(384.98, 355.08, 385.309, 356.005, 385.641, 356.927)
    ..cubicTo(390.416, 370.224, 394.938, 382.797, 400.11, 394.569)
    ..cubicTo(399.985, 394.69, 399.885, 394.844, 399.831, 395.022)
    ..cubicTo(399.831, 395.022, 394.577, 412.935, 394.577, 412.935)
    ..cubicTo(391.095, 415.113, 387.634, 417.271, 384.248, 419.385)
    ..cubicTo(374.583, 425.418, 365.446, 431.118, 358.081, 435.797)
    ..cubicTo(336.905, 387.497, 312.892, 333.164, 278.554, 309.408)
    ..cubicTo(279.211, 308.362, 279.922, 307.187, 280.747, 305.812)
    ..cubicTo(281.84, 304.004, 283.193, 301.754, 284.897, 299.043)
    ..cubicTo(285.015, 298.854, 285.072, 298.629, 285.054, 298.404)
    ..cubicTo(284.94, 296.747, 284.804, 293.357, 284.636, 289.071)
    ..cubicTo(284.161, 277.052, 283.633, 265.069, 282.829, 256.676)
    ..cubicTo(296.68, 255.936, 315.296, 255.065, 323.161, 255.386)
    ..cubicTo(323.161, 255.386, 323.161, 255.386, 323.161, 255.386)
    ..close();

  static final Path __path47_1_6 = Path()
    ..moveTo(95.6689, 335.286)
    ..cubicTo(100.685, 331.975, 105.632, 328.706, 110.524, 325.478)
    ..cubicTo(114.168, 331.267, 117.772, 336.711, 121.367, 341.647)
    ..cubicTo(124.228, 345.115, 134.085, 352.276, 139.974, 356.559)
    ..cubicTo(141.043, 357.334, 141.967, 358.005, 142.673, 358.53)
    ..cubicTo(148.73, 366.674, 169.487, 395.973, 176.408, 405.813)
    ..cubicTo(176.471, 405.902, 176.547, 405.981, 176.634, 406.048)
    ..cubicTo(176.634, 406.048, 178.47, 407.438, 178.47, 407.438)
    ..cubicTo(178.47, 407.438, 181.923, 422.728, 181.923, 422.728)
    ..cubicTo(181.945, 422.825, 181.988, 422.91, 182.033, 422.993)
    ..cubicTo(172.382, 432.676, 159.014, 446.177, 151.178, 454.145)
    ..cubicTo(123.85, 425.096, 99.8653, 389.061, 76.6212, 354.134)
    ..cubicTo(75.6487, 352.673, 74.6843, 351.223, 73.7224, 349.78)
    ..cubicTo(81.118, 344.897, 88.4408, 340.061, 95.6689, 335.286)
    ..cubicTo(95.6689, 335.286, 95.6689, 335.286, 95.6689, 335.286)
    ..close();

  static final Path __path47_1_7 = Path()
    ..moveTo(41.9934, 218.548)
    ..cubicTo(42.1188, 219.373, 42.2317, 220.133, 42.3285, 220.812)
    ..cubicTo(42.347, 220.944, 42.391, 221.073, 42.4574, 221.187)
    ..cubicTo(42.4574, 221.187, 48.1325, 231.116, 48.1325, 231.116)
    ..cubicTo(48.2614, 231.341, 48.3975, 231.581, 48.5672, 231.766)
    ..cubicTo(48.5672, 231.766, 48.5533, 231.781, 48.5533, 231.781)
    ..cubicTo(64.8103, 248.264, 79.9133, 273.97, 94.5188, 298.829)
    ..cubicTo(99.6074, 307.487, 104.541, 315.884, 109.398, 323.677)
    ..cubicTo(104.492, 326.917, 99.5313, 330.196, 94.5002, 333.518)
    ..cubicTo(87.2696, 338.293, 79.9444, 343.133, 72.5466, 348.015)
    ..cubicTo(65.0124, 336.707, 57.7661, 325.903, 50.4345, 315.466)
    ..cubicTo(47.2482, 305.208, 39.8579, 283.714, 36.2933, 274.702)
    ..cubicTo(36.2794, 274.67, 36.2641, 274.638, 36.2473, 274.602)
    ..cubicTo(32.0544, 266.566, 18.3662, 251.022, 16.1589, 248.536)
    ..cubicTo(16.1589, 248.536, 11.3274, 233.077, 11.3274, 233.077)
    ..cubicTo(11.3274, 233.077, 10.6741, 218.055, 10.6741, 218.055)
    ..cubicTo(22.3172, 218.812, 32.772, 218.976, 41.9934, 218.548)
    ..cubicTo(41.9934, 218.548, 41.9934, 218.548, 41.9934, 218.548)
    ..close();

  static final Path __path47_1_8 = Path()
    ..moveTo(167.548, 313.955)
    ..cubicTo(167.609, 314.034, 167.68, 314.102, 167.76, 314.162)
    ..cubicTo(167.76, 314.162, 182.089, 324.538, 182.089, 324.538)
    ..cubicTo(182.19, 324.61, 182.303, 324.663, 182.423, 324.699)
    ..cubicTo(182.423, 324.699, 198.233, 329.146, 198.233, 329.146)
    ..cubicTo(198.333, 329.174, 198.433, 329.192, 198.533, 329.185)
    ..cubicTo(198.533, 329.185, 245.965, 328.692, 245.965, 328.692)
    ..cubicTo(246.051, 328.689, 246.14, 328.678, 246.226, 328.656)
    ..cubicTo(246.226, 328.656, 261.049, 324.703, 261.049, 324.703)
    ..cubicTo(261.163, 324.674, 261.27, 324.624, 261.367, 324.56)
    ..cubicTo(271.625, 317.713, 274.293, 315.738, 277.396, 311.184)
    ..cubicTo(311.131, 334.56, 334.969, 388.358, 355.985, 436.29)
    ..cubicTo(328.261, 442.487, 295.141, 452.077, 263.07, 461.367)
    ..cubicTo(254.834, 463.753, 246.808, 466.075, 239.072, 468.286)
    ..cubicTo(239.04, 468.268, 239.015, 468.239, 238.983, 468.221)
    ..cubicTo(238.983, 468.221, 228.607, 463.507, 228.607, 463.507)
    ..cubicTo(228.607, 463.507, 225.749, 448.97, 225.749, 448.97)
    ..cubicTo(225.732, 448.895, 225.71, 448.82, 225.678, 448.745)
    ..cubicTo(222.663, 441.948, 214.959, 433.079, 209.155, 427.425)
    ..cubicTo(209.155, 427.425, 208.219, 420.621, 208.219, 420.621)
    ..cubicTo(208.166, 420.25, 207.927, 419.953, 207.605, 419.807)
    ..cubicTo(207.605, 419.807, 207.712, 418.974, 207.712, 418.974)
    ..cubicTo(207.712, 418.974, 200.151, 418.028, 200.151, 418.028)
    ..cubicTo(200.151, 418.028, 193.814, 411.992, 193.814, 411.992)
    ..cubicTo(193.814, 411.992, 196.714, 404.259, 196.714, 404.259)
    ..cubicTo(196.714, 404.259, 196.371, 404.127, 196.371, 404.127)
    ..cubicTo(196.371, 404.127, 196.706, 403.291, 196.706, 403.291)
    ..cubicTo(196.923, 402.748, 196.659, 402.13, 196.115, 401.912)
    ..cubicTo(195.572, 401.694, 194.955, 401.959, 194.737, 402.502)
    ..cubicTo(194.737, 402.502, 191.823, 409.788, 191.823, 409.788)
    ..cubicTo(191.823, 409.788, 186.116, 410.074, 186.116, 410.074)
    ..cubicTo(186.116, 410.074, 186.142, 410.599, 186.142, 410.599)
    ..cubicTo(184.191, 409.106, 182.29, 407.666, 180.479, 406.298)
    ..cubicTo(180.479, 406.298, 178.047, 404.455, 178.047, 404.455)
    ..cubicTo(170.991, 394.43, 150.198, 365.081, 144.28, 357.137)
    ..cubicTo(144.218, 357.055, 144.145, 356.98, 144.062, 356.919)
    ..cubicTo(143.336, 356.38, 142.36, 355.669, 141.221, 354.844)
    ..cubicTo(135.794, 350.898, 125.692, 343.558, 123.042, 340.347)
    ..cubicTo(119.489, 335.468, 115.914, 330.067, 112.293, 324.31)
    ..cubicTo(126.607, 314.859, 140.446, 305.73, 154.069, 296.772)
    ..cubicTo(154.069, 296.772, 167.548, 313.955, 167.548, 313.955)
    ..cubicTo(167.548, 313.955, 167.548, 313.955, 167.548, 313.955)
    ..close();

  static final Path __path47_1_9 = Path()
    ..moveTo(147.52, 288.15)
    ..cubicTo(147.548, 288.457, 147.843, 288.832, 148.634, 289.843)
    ..cubicTo(148.634, 289.843, 152.755, 295.097, 152.755, 295.097)
    ..cubicTo(139.193, 304.015, 125.416, 313.105, 111.167, 322.51)
    ..cubicTo(106.338, 314.755, 101.419, 306.387, 96.3468, 297.754)
    ..cubicTo(81.7045, 272.834, 66.5647, 247.064, 50.1595, 230.391)
    ..cubicTo(49.563, 229.348, 45.1251, 221.58, 44.399, 220.312)
    ..cubicTo(44.3272, 219.812, 44.2479, 219.273, 44.1611, 218.701)
    ..cubicTo(44.1611, 218.701, 139.509, 232.184, 139.509, 232.184)
    ..cubicTo(139.509, 232.184, 137.194, 247.928, 137.194, 247.928)
    ..cubicTo(137.185, 247.989, 137.181, 248.05, 137.183, 248.114)
    ..cubicTo(137.346, 253.965, 140.823, 267.434, 147.52, 288.15)
    ..cubicTo(147.52, 288.15, 147.52, 288.15, 147.52, 288.15)
    ..close();

  static final Path __path47_1_10 = Path()
    ..moveTo(10.6438, 202.228)
    ..cubicTo(10.6802, 202.082, 10.6827, 201.935, 10.6591, 201.793)
    ..cubicTo(10.6591, 201.793, 11.0045, 192.124, 11.0045, 192.124)
    ..cubicTo(11.0063, 192.07, 11.0045, 192.02, 10.9981, 191.967)
    ..cubicTo(10.9981, 191.967, 9.3512, 177.473, 9.3512, 177.473)
    ..cubicTo(9.3351, 177.33, 9.2901, 177.191, 9.2183, 177.066)
    ..cubicTo(9.1076, 176.873, -1.319, 158.628, -2.5227, 156.518)
    ..cubicTo(-3.6324, 143.559, -2.3965, 118.511, -0.5714, 105.217)
    ..cubicTo(-0.5714, 105.217, 9.2604, 92.2052, 9.2604, 92.2052)
    ..cubicTo(13.1368, 100.756, 16.9046, 109.092, 20.4803, 117)
    ..cubicTo(20.4803, 117, 26.055, 129.33, 26.055, 129.33)
    ..cubicTo(29.141, 145.192, 38.4624, 196.121, 41.6677, 216.447)
    ..cubicTo(36.1083, 216.726, 26.5325, 217.087, 10.5848, 215.997)
    ..cubicTo(10.5848, 215.997, 10.347, 210.529, 10.347, 210.529)
    ..cubicTo(10.347, 210.529, 10.6438, 202.228, 10.6438, 202.228)
    ..cubicTo(10.6438, 202.228, 10.6438, 202.228, 10.6438, 202.228)
    ..close();

  static final Path __path47_1_11 = Path()
    ..moveTo(488.61, 367.488)
    ..cubicTo(488.61, 367.488, 486.003, 350.869, 486.003, 350.869)
    ..cubicTo(486.003, 350.869, 487.946, 340.507, 487.946, 340.507)
    ..cubicTo(487.992, 340.265, 487.949, 340.015, 487.831, 339.797)
    ..cubicTo(487.831, 339.797, 486.181, 336.832, 486.181, 336.832)
    ..cubicTo(485.995, 336.496, 485.642, 336.289, 485.256, 336.289)
    ..cubicTo(485.256, 336.289, 479.984, 336.289, 479.984, 336.289)
    ..cubicTo(479.838, 336.289, 479.688, 336.321, 479.552, 336.382)
    ..cubicTo(479.552, 336.382, 470.001, 340.665, 470.001, 340.665)
    ..cubicTo(469.708, 340.793, 469.494, 341.047, 469.412, 341.35)
    ..cubicTo(469.412, 341.35, 468.423, 344.976, 468.423, 344.976)
    ..cubicTo(468.33, 345.322, 468.415, 345.694, 468.658, 345.961)
    ..cubicTo(471.008, 348.583, 476.212, 353.266, 479.266, 355.273)
    ..cubicTo(479.709, 356.044, 480.727, 357.687, 483.056, 361.448)
    ..cubicTo(483.056, 361.448, 481.674, 364.213, 481.674, 364.213)
    ..cubicTo(481.413, 364.738, 481.624, 365.374, 482.149, 365.638)
    ..cubicTo(482.149, 365.638, 483.249, 366.188, 483.249, 366.188)
    ..cubicTo(483.249, 366.188, 475.52, 371.981, 475.52, 371.981)
    ..cubicTo(475.52, 371.981, 454.807, 379.75, 454.807, 379.75)
    ..cubicTo(454.807, 379.75, 447.799, 379.114, 447.799, 379.114)
    ..cubicTo(447.742, 379.107, 447.682, 379.107, 447.621, 379.111)
    ..cubicTo(447.621, 379.111, 439.385, 379.771, 439.385, 379.771)
    ..cubicTo(439.192, 379.786, 439.006, 379.857, 438.849, 379.971)
    ..cubicTo(438.849, 379.971, 413.915, 398.101, 413.915, 398.101)
    ..cubicTo(413.915, 398.101, 402.367, 394.455, 402.367, 394.455)
    ..cubicTo(397.092, 382.543, 392.499, 369.745, 387.637, 356.212)
    ..cubicTo(387.527, 355.898, 387.412, 355.584, 387.298, 355.269)
    ..cubicTo(387.405, 355.151, 387.491, 355.019, 387.537, 354.862)
    ..cubicTo(387.537, 354.862, 391.773, 340.743, 391.773, 340.743)
    ..cubicTo(391.813, 340.732, 391.852, 340.725, 391.888, 340.707)
    ..cubicTo(391.888, 340.707, 398.063, 337.989, 398.063, 337.989)
    ..cubicTo(398.599, 337.754, 398.846, 337.129, 398.61, 336.593)
    ..cubicTo(398.374, 336.057, 397.753, 335.811, 397.21, 336.05)
    ..cubicTo(397.21, 336.05, 391.209, 338.689, 391.209, 338.689)
    ..cubicTo(391.209, 338.689, 379.455, 333.893, 379.455, 333.893)
    ..cubicTo(375.172, 322.677, 370.558, 311.641, 365.196, 301.24)
    ..cubicTo(365.479, 300.758, 365.346, 300.14, 364.882, 299.826)
    ..cubicTo(364.882, 299.826, 364.232, 299.386, 364.232, 299.386)
    ..cubicTo(361.521, 294.25, 358.614, 289.278, 355.467, 284.528)
    ..cubicTo(355.467, 284.528, 355.467, 283.906, 355.467, 283.906)
    ..cubicTo(355.467, 283.317, 354.992, 282.846, 354.406, 282.846)
    ..cubicTo(354.385, 282.846, 354.363, 282.849, 354.342, 282.853)
    ..cubicTo(349.631, 275.949, 344.384, 269.53, 338.423, 263.791)
    ..cubicTo(338.423, 263.791, 338.394, 263.819, 338.394, 263.819)
    ..cubicTo(338.058, 263.512, 337.394, 263.033, 336.094, 262.098)
    ..cubicTo(336.094, 262.098, 324.147, 253.483, 324.147, 253.483)
    ..cubicTo(323.979, 253.361, 323.782, 253.293, 323.575, 253.283)
    ..cubicTo(315.792, 252.915, 296.705, 253.808, 282.611, 254.565)
    ..cubicTo(282.168, 250.55, 281.647, 247.586, 281.011, 246.168)
    ..cubicTo(281.011, 246.168, 280.972, 246.189, 280.972, 246.189)
    ..cubicTo(280.74, 245.746, 280.222, 245.018, 279.211, 243.592)
    ..cubicTo(279.211, 243.592, 270.039, 230.67, 270.039, 230.67)
    ..cubicTo(269.924, 230.506, 269.764, 230.377, 269.578, 230.302)
    ..cubicTo(269.578, 230.302, 262.331, 227.338, 262.331, 227.338)
    ..cubicTo(262.159, 227.266, 261.97, 227.245, 261.784, 227.27)
    ..cubicTo(261.784, 227.27, 240.483, 230.22, 240.483, 230.22)
    ..cubicTo(240.483, 230.22, 221.338, 228.92, 221.338, 228.92)
    ..cubicTo(221.338, 228.92, 200.187, 219.812, 200.187, 219.812)
    ..cubicTo(200.187, 219.812, 186.03, 210.158, 186.03, 210.158)
    ..cubicTo(186.03, 210.158, 177.039, 189.606, 177.039, 189.606)
    ..cubicTo(177.039, 189.606, 178.318, 175.855, 178.318, 175.855)
    ..cubicTo(178.318, 175.855, 183.54, 161.822, 183.54, 161.822)
    ..cubicTo(183.663, 161.489, 183.612, 161.118, 183.403, 160.829)
    ..cubicTo(178.988, 154.76, 178.306, 154.353, 172.997, 151.189)
    ..cubicTo(172.997, 151.189, 171.781, 150.463, 171.781, 150.463)
    ..cubicTo(168.797, 145.67, 164.681, 138.916, 160.517, 132.019)
    ..cubicTo(160.517, 132.019, 167.718, 126.383, 167.718, 126.383)
    ..cubicTo(167.842, 126.287, 167.943, 126.165, 168.013, 126.022)
    ..cubicTo(168.013, 126.022, 173.283, 115.482, 173.283, 115.482)
    ..cubicTo(173.352, 115.346, 173.39, 115.196, 173.395, 115.039)
    ..cubicTo(173.395, 115.039, 174.374, 82.3937, 174.374, 82.3937)
    ..cubicTo(174.374, 82.3937, 184.756, 66.171, 184.756, 66.171)
    ..cubicTo(184.869, 65.996, 184.927, 65.7923, 184.924, 65.5852)
    ..cubicTo(184.924, 65.5852, 184.241, 21.4423, 184.241, 21.4423)
    ..cubicTo(197.184, 21.9602, 209.537, 22.8639, 218.627, 24.1605)
    ..cubicTo(219.213, 24.2426, 219.745, 23.839, 219.827, 23.2603)
    ..cubicTo(219.91, 22.6782, 219.506, 22.1424, 218.927, 22.0603)
    ..cubicTo(209.752, 20.753, 197.271, 19.8423, 184.208, 19.3208)
    ..cubicTo(184.208, 19.3208, 183.935, 1.6836, 183.935, 1.6836)
    ..cubicTo(183.926, 1.1014, 183.454, 0.6371, 182.876, 0.6371)
    ..cubicTo(182.87, 0.6371, 182.864, 0.6371, 182.859, 0.6371)
    ..cubicTo(182.273, 0.6478, 181.806, 1.13, 181.815, 1.7158)
    ..cubicTo(181.815, 1.7158, 182.086, 19.2386, 182.086, 19.2386)
    ..cubicTo(164.136, 18.5778, 145.368, 18.6457, 132.743, 19.4172)
    ..cubicTo(132.548, 19.4279, 132.36, 19.4922, 132.2, 19.6065)
    ..cubicTo(132.2, 19.6065, 115.9, 31.0145, 115.9, 31.0145)
    ..cubicTo(110.582, 32.1146, 78.6925, 30.5467, 59.547, 29.6073)
    ..cubicTo(52.719, 29.2716, 47.3257, 29.0073, 45.2098, 28.968)
    ..cubicTo(45.1605, 28.9644, 45.1051, 28.9679, 45.053, 28.9751)
    ..cubicTo(29.2563, 31.0253, 8.5658, 37.6151, -9.5639, 45.8872)
    ..cubicTo(-16.8356, 30.1288, -23.9883, 14.8561, -30.521, 1.3193)
    ..cubicTo(-30.7764, 0.7943, -31.4103, 0.5728, -31.9368, 0.8264)
    ..cubicTo(-32.4644, 1.08, -32.6854, 1.7157, -32.4311, 2.2408)
    ..cubicTo(-25.9042, 15.7669, -18.7568, 31.0289, -11.4894, 46.773)
    ..cubicTo(-19.6823, 50.6054, -27.2879, 54.7629, -33.5887, 58.9811)
    ..cubicTo(-33.8984, 59.0846, -34.1238, 59.474, -35.0485, 61.0634)
    ..cubicTo(-35.0485, 61.0634, -40.0514, 69.6784, -40.0514, 69.6784)
    ..cubicTo(-40.1143, 69.7891, -40.1578, 69.907, -40.1793, 70.032)
    ..cubicTo(-40.1793, 70.032, -43.8028, 91.1123, -43.8028, 91.1123)
    ..cubicTo(-43.811, 91.1623, -43.816, 91.2123, -43.8174, 91.2623)
    ..cubicTo(-43.8174, 91.2623, -44.4764, 113.989, -44.4764, 113.989)
    ..cubicTo(-44.4771, 114.018, -44.4768, 114.046, -44.4753, 114.075)
    ..cubicTo(-43.8253, 126.512, -26.4307, 167.611, -18.4979, 177.905)
    ..cubicTo(-18.4979, 177.905, -19.4058, 185.773, -19.4058, 185.773)
    ..cubicTo(-19.4058, 185.773, -19.8633, 186.434, -19.8633, 186.434)
    ..cubicTo(-20.3112, 186.363, -20.7723, 186.581, -20.9824, 187.009)
    ..cubicTo(-21.1427, 187.338, -21.1181, 187.706, -20.9495, 188.002)
    ..cubicTo(-20.9495, 188.002, -22.0539, 189.599, -22.0539, 189.599)
    ..cubicTo(-26.2167, 191.524, -35.4614, 196.31, -38.7263, 198.446)
    ..cubicTo(-38.8502, 198.528, -38.9559, 198.632, -39.0363, 198.757)
    ..cubicTo(-41.2215, 202.136, -43.786, 205.536, -46.5869, 208.936)
    ..cubicTo(-66.8468, 205.593, -91.2784, 200.871, -120.728, 194.224)
    ..cubicTo(-120.728, 194.224, -138.352, 182.477, -138.352, 182.477)
    ..cubicTo(-138.84, 182.152, -139.497, 182.284, -139.822, 182.77)
    ..cubicTo(-140.147, 183.255, -140.015, 183.916, -139.528, 184.241)
    ..cubicTo(-139.528, 184.241, -121.741, 196.099, -121.741, 196.099)
    ..cubicTo(-121.633, 196.171, -121.513, 196.221, -121.386, 196.249)
    ..cubicTo(-103.155, 200.364, -76.4458, 206.186, -48.2067, 210.872)
    ..cubicTo(-53.6289, 217.258, -59.8069, 223.634, -65.8628, 229.884)
    ..cubicTo(-75.7293, 240.064, -85.9315, 250.589, -92.7257, 261.008)
    ..cubicTo(-92.7864, 261.101, -92.8303, 261.201, -92.8592, 261.305)
    ..cubicTo(-92.9632, 261.655, -94.8287, 267.873, -94.8287, 267.873)
    ..cubicTo(-94.8587, 267.969, -94.874, 268.073, -94.8737, 268.177)
    ..cubicTo(-94.8737, 268.177, -94.544, 450.991, -94.544, 450.991)
    ..cubicTo(-94.5437, 451.17, -94.4983, 451.345, -94.4115, 451.502)
    ..cubicTo(-93.7154, 452.759, -92.995, 454.045, -92.2631, 455.342)
    ..cubicTo(-108.357, 465.571, -124.167, 475.511, -139.498, 485.001)
    ..cubicTo(-139.995, 485.308, -140.149, 485.962, -139.841, 486.462)
    ..cubicTo(-139.641, 486.787, -139.294, 486.962, -138.939, 486.962)
    ..cubicTo(-138.748, 486.962, -138.555, 486.912, -138.382, 486.805)
    ..cubicTo(-123.073, 477.329, -107.286, 467.403, -91.218, 457.188)
    ..cubicTo(-74.5231, 486.519, -49.3907, 524.751, -25.0359, 561.8)
    ..cubicTo(-23.2608, 564.5, -21.4988, 567.183, -19.7448, 569.851)
    ..cubicTo(-39.6382, 578.777, -58.1232, 586.97, -72.7112, 593.435)
    ..cubicTo(-72.7112, 593.435, -73.1616, 593.635, -73.1616, 593.635)
    ..cubicTo(-73.1616, 593.635, -73.1541, 593.649, -73.1541, 593.649)
    ..cubicTo(-73.7102, 593.753, -74.5406, 593.953, -75.815, 594.267)
    ..cubicTo(-75.815, 594.267, -138.863, 609.711, -138.863, 609.711)
    ..cubicTo(-139.431, 609.851, -139.779, 610.426, -139.64, 610.994)
    ..cubicTo(-139.522, 611.479, -139.088, 611.804, -138.611, 611.804)
    ..cubicTo(-138.528, 611.804, -138.443, 611.794, -138.358, 611.772)
    ..cubicTo(-137.702, 611.611, -72.7983, 595.71, -72.4829, 595.635)
    ..cubicTo(-72.4215, 595.617, -72.3604, 595.599, -72.3022, 595.571)
    ..cubicTo(-72.3022, 595.571, -71.8518, 595.374, -71.8518, 595.374)
    ..cubicTo(-57.1853, 588.874, -38.582, 580.627, -18.5654, 571.647)
    ..cubicTo(-1.2936, 597.946, 14.7359, 622.53, 26.4318, 642.146)
    ..cubicTo(26.4318, 642.146, 27.2137, 644.536, 27.2137, 644.536)
    ..cubicTo(27.2137, 644.536, 20.2017, 666.209, 20.2017, 666.209)
    ..cubicTo(15.9424, 667.912, 11.7164, 669.588, 7.5442, 671.241)
    ..cubicTo(7.5442, 671.241, 1.2362, 673.741, 1.2362, 673.741)
    ..cubicTo(0.6922, 673.959, 0.4265, 674.574, 0.6426, 675.116)
    ..cubicTo(0.8076, 675.534, 1.2062, 675.788, 1.628, 675.788)
    ..cubicTo(1.758, 675.788, 1.8905, 675.763, 2.0191, 675.713)
    ..cubicTo(2.0191, 675.713, 5.038, 674.516, 5.038, 674.516)
    ..cubicTo(4.9987, 674.706, 5.0094, 674.909, 5.0844, 675.106)
    ..cubicTo(5.2462, 675.527, 5.648, 675.788, 6.0752, 675.788)
    ..cubicTo(6.2009, 675.788, 6.3288, 675.767, 6.4538, 675.717)
    ..cubicTo(6.4538, 675.717, 11.5438, 673.77, 11.5438, 673.77)
    ..cubicTo(15.4442, 672.281, 19.3945, 670.773, 23.3759, 669.234)
    ..cubicTo(23.3759, 669.234, 35.254, 676.024, 35.254, 676.024)
    ..cubicTo(35.254, 676.024, 48.1507, 659.315, 48.1507, 659.315)
    ..cubicTo(59.7024, 654.461, 71.2183, 649.214, 82.286, 643.332)
    ..cubicTo(82.286, 643.332, 96.2982, 644.825, 96.2982, 644.825)
    ..cubicTo(96.2982, 644.825, 100.781, 632.57, 100.781, 632.57)
    ..cubicTo(111.513, 625.691, 121.517, 618.012, 130.342, 609.272)
    ..cubicTo(130.365, 609.251, 130.387, 609.229, 130.408, 609.204)
    ..cubicTo(132.477, 606.743, 134.612, 604.364, 136.779, 602.021)
    ..cubicTo(136.787, 602.039, 136.791, 602.057, 136.8, 602.075)
    ..cubicTo(136.986, 602.446, 137.36, 602.661, 137.749, 602.661)
    ..cubicTo(137.909, 602.661, 138.07, 602.625, 138.223, 602.55)
    ..cubicTo(138.898, 602.211, 145.626, 599.828, 149.709, 598.403)
    ..cubicTo(149.949, 598.321, 150.151, 598.153, 150.278, 597.932)
    ..cubicTo(150.278, 597.932, 154.972, 589.778, 154.972, 589.778)
    ..cubicTo(155.086, 589.581, 155.133, 589.352, 155.107, 589.127)
    ..cubicTo(155.107, 589.127, 154.615, 584.863, 154.615, 584.863)
    ..cubicTo(174.193, 568.033, 196.477, 554.56, 220.07, 542.959)
    ..cubicTo(220.07, 542.959, 241.172, 538.045, 241.172, 538.045)
    ..cubicTo(241.172, 538.045, 251.309, 548.178, 251.309, 548.178)
    ..cubicTo(251.351, 548.331, 251.394, 548.488, 251.437, 548.646)
    ..cubicTo(254.473, 559.511, 257.216, 569.319, 260.488, 578.777)
    ..cubicTo(260.488, 578.777, 260.952, 600.143, 260.952, 600.143)
    ..cubicTo(260.956, 600.253, 260.974, 600.361, 261.009, 600.468)
    ..cubicTo(261.009, 600.468, 263.235, 606.89, 263.235, 606.89)
    ..cubicTo(263.277, 607.018, 263.349, 607.14, 263.438, 607.24)
    ..cubicTo(263.438, 607.24, 265.167, 609.218, 265.167, 609.218)
    ..cubicTo(265.313, 609.383, 265.506, 609.501, 265.72, 609.551)
    ..cubicTo(265.72, 609.551, 269.921, 610.54, 269.921, 610.54)
    ..cubicTo(270.003, 610.558, 270.082, 610.568, 270.164, 610.568)
    ..cubicTo(270.21, 610.568, 270.26, 610.565, 270.307, 610.558)
    ..cubicTo(270.307, 610.558, 274.489, 609.99, 274.489, 609.99)
    ..cubicTo(285.193, 628.699, 301.448, 649.086, 329.454, 676.474)
    ..cubicTo(329.661, 676.674, 329.929, 676.777, 330.197, 676.777)
    ..cubicTo(330.472, 676.777, 330.747, 676.67, 330.954, 676.456)
    ..cubicTo(331.279, 676.124, 331.329, 675.638, 331.133, 675.245)
    ..cubicTo(331.229, 675.274, 331.329, 675.292, 331.429, 675.292)
    ..cubicTo(331.683, 675.292, 331.937, 675.202, 332.14, 675.02)
    ..cubicTo(332.576, 674.627, 332.612, 673.959, 332.219, 673.524)
    ..cubicTo(328.49, 669.384, 324.997, 665.519, 321.729, 661.901)
    ..cubicTo(297.284, 634.849, 285.211, 621.487, 277.282, 607.883)
    ..cubicTo(277.282, 607.883, 281.472, 600.128, 281.472, 600.128)
    ..cubicTo(281.59, 599.918, 281.625, 599.671, 281.582, 599.432)
    ..cubicTo(281.582, 599.432, 280.961, 596.114, 280.961, 596.114)
    ..cubicTo(281.097, 595.874, 281.143, 595.589, 281.072, 595.317)
    ..cubicTo(280.986, 595.003, 280.765, 594.746, 280.465, 594.617)
    ..cubicTo(280.465, 594.617, 279.986, 594.41, 279.986, 594.41)
    ..cubicTo(279.986, 594.41, 269.624, 584.966, 269.624, 584.966)
    ..cubicTo(269.624, 584.966, 257.191, 539.634, 257.191, 539.634)
    ..cubicTo(257.191, 539.634, 259.681, 532.623, 259.681, 532.623)
    ..cubicTo(259.681, 532.623, 281.129, 518.24, 281.129, 518.24)
    ..cubicTo(281.618, 517.915, 281.747, 517.257, 281.422, 516.772)
    ..cubicTo(281.418, 516.768, 281.418, 516.768, 281.418, 516.768)
    ..cubicTo(289.094, 513.811, 296.78, 510.907, 304.438, 508.021)
    ..cubicTo(325.232, 500.174, 346.563, 492.127, 366.857, 483.205)
    ..cubicTo(366.857, 483.205, 382.019, 491.716, 382.019, 491.716)
    ..cubicTo(382.194, 492.037, 382.373, 492.366, 382.551, 492.68)
    ..cubicTo(382.676, 492.909, 382.88, 493.063, 383.109, 493.148)
    ..cubicTo(391.238, 509.45, 400.639, 529.358, 410.586, 550.421)
    ..cubicTo(424.53, 579.952, 438.949, 610.486, 450.757, 632.892)
    ..cubicTo(452.368, 637.946, 454.85, 648.236, 455.129, 653.047)
    ..cubicTo(455.129, 653.05, 455.129, 653.05, 455.129, 653.054)
    ..cubicTo(455.136, 653.204, 455.568, 660.976, 455.618, 661.858)
    ..cubicTo(455.618, 661.858, 454.389, 674.377, 454.389, 674.377)
    ..cubicTo(454.332, 674.959, 454.761, 675.477, 455.343, 675.534)
    ..cubicTo(455.379, 675.538, 455.414, 675.542, 455.446, 675.542)
    ..cubicTo(455.986, 675.542, 456.447, 675.131, 456.5, 674.584)
    ..cubicTo(456.5, 674.584, 457.736, 661.983, 457.736, 661.983)
    ..cubicTo(457.743, 661.93, 457.743, 661.876, 457.739, 661.823)
    ..cubicTo(457.739, 661.823, 457.322, 654.318, 457.322, 654.318)
    ..cubicTo(457.289, 653.733, 457.264, 653.276, 457.214, 652.929)
    ..cubicTo(457.214, 652.929, 457.243, 652.925, 457.243, 652.925)
    ..cubicTo(456.932, 647.468, 454.193, 636.671, 452.75, 632.16)
    ..cubicTo(452.732, 632.099, 452.707, 632.042, 452.678, 631.988)
    ..cubicTo(440.881, 609.615, 426.455, 579.062, 412.504, 549.517)
    ..cubicTo(402.474, 528.28, 392.999, 508.21, 384.816, 491.816)
    ..cubicTo(384.923, 491.473, 384.844, 491.098, 384.616, 490.827)
    ..cubicTo(384.616, 490.827, 384.616, 480.99, 384.616, 480.99)
    ..cubicTo(384.616, 480.99, 387.134, 474.357, 387.134, 474.357)
    ..cubicTo(390.02, 472.536, 396.177, 466.039, 401.767, 460.038)
    ..cubicTo(402.749, 458.985, 403.557, 458.117, 404.085, 457.57)
    ..cubicTo(404.171, 457.478, 404.246, 457.37, 404.296, 457.253)
    ..cubicTo(404.296, 457.253, 409.482, 445.148, 409.482, 445.148)
    ..cubicTo(409.514, 445.077, 409.536, 445.002, 409.55, 444.927)
    ..cubicTo(409.55, 444.927, 411.775, 433.068, 411.775, 433.068)
    ..cubicTo(411.789, 432.986, 411.793, 432.904, 411.789, 432.818)
    ..cubicTo(411.789, 432.818, 411.339, 423.611, 411.339, 423.611)
    ..cubicTo(411.414, 423.507, 411.472, 423.396, 411.507, 423.271)
    ..cubicTo(411.507, 423.271, 417.079, 402.927, 417.079, 402.927)
    ..cubicTo(417.079, 402.927, 446.071, 385.286, 446.071, 385.286)
    ..cubicTo(446.071, 385.286, 458.329, 386.25, 458.329, 386.25)
    ..cubicTo(458.461, 386.261, 458.597, 386.247, 458.725, 386.204)
    ..cubicTo(458.725, 386.204, 469.101, 382.993, 469.101, 382.993)
    ..cubicTo(469.658, 382.822, 469.973, 382.225, 469.798, 381.668)
    ..cubicTo(469.626, 381.107, 469.03, 380.796, 468.472, 380.968)
    ..cubicTo(468.472, 380.968, 458.29, 384.122, 458.29, 384.122)
    ..cubicTo(458.29, 384.122, 450.839, 383.536, 450.839, 383.536)
    ..cubicTo(450.839, 383.536, 456.6, 383.536, 456.6, 383.536)
    ..cubicTo(456.725, 383.536, 456.85, 383.514, 456.964, 383.468)
    ..cubicTo(456.964, 383.468, 475.741, 376.553, 475.741, 376.553)
    ..cubicTo(475.816, 376.525, 475.884, 376.489, 475.952, 376.446)
    ..cubicTo(475.952, 376.446, 488.138, 368.542, 488.138, 368.542)
    ..cubicTo(488.488, 368.313, 488.674, 367.902, 488.61, 367.488)
    ..cubicTo(488.61, 367.488, 488.61, 367.488, 488.61, 367.488)
    ..close();

  static final Path __path47_1_12 = Path()
    ..moveTo(233.302, 356.719)
    ..cubicTo(221.719, 357.226, 209.343, 357.479, 197.219, 357.358)
    ..cubicTo(197.219, 357.358, 197.742, 327.241, 197.742, 327.241)
    ..cubicTo(197.742, 327.241, 203.331, 307.433, 203.331, 307.433)
    ..cubicTo(203.331, 307.433, 216.365, 309.39, 216.365, 309.39)
    ..cubicTo(216.4, 309.393, 216.436, 309.397, 216.472, 309.397)
    ..cubicTo(216.5, 309.397, 216.533, 309.393, 216.561, 309.39)
    ..cubicTo(216.561, 309.39, 224.197, 308.393, 224.197, 308.393)
    ..cubicTo(224.197, 308.393, 237.631, 305.443, 237.631, 305.443)
    ..cubicTo(237.631, 305.443, 237.838, 305.443, 237.838, 305.443)
    ..cubicTo(237.838, 305.443, 238.163, 327.427, 238.163, 327.427)
    ..cubicTo(238.056, 328.288, 237.599, 330.774, 237.023, 333.906)
    ..cubicTo(235.173, 344.003, 233.852, 351.715, 233.302, 356.719)
    ..cubicTo(233.302, 356.719, 233.302, 356.719, 233.302, 356.719)
    ..close();

  static final Path __path47_1_13 = Path()
    ..moveTo(209.193, 286.677)
    ..cubicTo(209.193, 286.677, 229.284, 287.656, 229.284, 287.656)
    ..cubicTo(229.337, 287.656, 229.391, 287.656, 229.448, 287.645)
    ..cubicTo(229.448, 287.645, 238.338, 285.999, 238.338, 285.999)
    ..cubicTo(238.395, 285.988, 238.449, 285.97, 238.499, 285.949)
    ..cubicTo(239.399, 285.545, 240.795, 284.638, 242.445, 283.452)
    ..cubicTo(246.946, 287.274, 252.303, 291.567, 258.014, 296.035)
    ..cubicTo(256.361, 298.232, 253.018, 302.679, 251.46, 304.032)
    ..cubicTo(251.46, 304.032, 237.552, 304.032, 237.552, 304.032)
    ..cubicTo(237.502, 304.032, 237.452, 304.036, 237.402, 304.047)
    ..cubicTo(237.402, 304.047, 223.955, 307, 223.955, 307)
    ..cubicTo(223.955, 307, 216.479, 307.975, 216.479, 307.975)
    ..cubicTo(216.479, 307.975, 203.721, 306.065, 203.721, 306.065)
    ..cubicTo(203.721, 306.065, 209.193, 286.677, 209.193, 286.677)
    ..cubicTo(209.193, 286.677, 209.193, 286.677, 209.193, 286.677)
    ..close();

  static final Path __path47_1_14 = Path()
    ..moveTo(202.342, 284.927)
    ..cubicTo(202.256, 284.924, 202.167, 284.934, 202.085, 284.963)
    ..cubicTo(202.085, 284.963, 194.378, 287.531, 194.378, 287.531)
    ..cubicTo(193.418, 287.277, 189.354, 286.209, 188.487, 285.981)
    ..cubicTo(183.065, 281.155, 182.928, 280.866, 179.978, 274.68)
    ..cubicTo(179.978, 274.68, 179.937, 274.594, 179.937, 274.594)
    ..cubicTo(186.114, 269.594, 192.066, 265.058, 196.429, 262.272)
    ..cubicTo(196.466, 262.336, 196.51, 262.393, 196.565, 262.443)
    ..cubicTo(196.565, 262.443, 203.153, 268.372, 203.153, 268.372)
    ..cubicTo(203.196, 268.412, 203.246, 268.444, 203.296, 268.472)
    ..cubicTo(203.296, 268.472, 208.771, 271.355, 208.771, 271.355)
    ..cubicTo(208.771, 271.355, 207.925, 285.199, 207.925, 285.199)
    ..cubicTo(207.925, 285.199, 202.342, 284.927, 202.342, 284.927)
    ..cubicTo(202.342, 284.927, 202.342, 284.927, 202.342, 284.927)
    ..close();

  static final Path __path47_1_15 = Path()
    ..moveTo(175.64, 260.7)
    ..cubicTo(175.64, 260.7, 172.598, 247.978, 172.598, 247.978)
    ..cubicTo(172.327, 246.846, 172.161, 246.153, 172.028, 245.731)
    ..cubicTo(172.028, 245.731, 172.049, 245.731, 172.049, 245.731)
    ..cubicTo(172.049, 245.731, 171.977, 244.62, 171.977, 244.62)
    ..cubicTo(171.74, 240.977, 171.578, 238.552, 171.308, 236.627)
    ..cubicTo(171.308, 236.627, 192.071, 238.977, 192.071, 238.977)
    ..cubicTo(192.124, 239.284, 192.363, 239.531, 192.683, 239.563)
    ..cubicTo(192.683, 239.563, 193.715, 239.666, 193.715, 239.666)
    ..cubicTo(193.715, 239.666, 194.355, 254.7, 194.355, 254.7)
    ..cubicTo(194.357, 254.753, 194.365, 254.803, 194.379, 254.857)
    ..cubicTo(194.379, 254.857, 196.016, 260.861, 196.016, 260.861)
    ..cubicTo(191.791, 263.518, 186.001, 267.901, 179.939, 272.78)
    ..cubicTo(179.939, 272.78, 180.269, 271.294, 180.269, 271.294)
    ..cubicTo(180.302, 271.144, 180.287, 270.987, 180.224, 270.847)
    ..cubicTo(180.224, 270.847, 175.64, 260.7, 175.64, 260.7)
    ..cubicTo(175.64, 260.7, 175.64, 260.7, 175.64, 260.7)
    ..close();

  static final Path __path47_1_16 = Path()
    ..moveTo(167.127, 225.776)
    ..cubicTo(166.615, 224.787, 166.038, 223.672, 165.387, 222.397)
    ..cubicTo(165.325, 222.279, 165.23, 222.176, 165.113, 222.108)
    ..cubicTo(165.113, 222.108, 157.317, 217.561, 157.317, 217.561)
    ..cubicTo(157.317, 217.561, 149.882, 208.51, 149.882, 208.51)
    ..cubicTo(149.882, 208.51, 143.648, 194.484, 143.648, 194.484)
    ..cubicTo(151.455, 191.523, 160.16, 188.609, 166.583, 186.623)
    ..cubicTo(166.583, 186.623, 176.294, 209.489, 176.294, 209.489)
    ..cubicTo(176.304, 209.514, 176.315, 209.535, 176.326, 209.557)
    ..cubicTo(176.326, 209.557, 184.561, 224.379, 184.561, 224.379)
    ..cubicTo(184.617, 224.479, 184.696, 224.565, 184.792, 224.629)
    ..cubicTo(184.792, 224.629, 192.383, 229.591, 192.383, 229.591)
    ..cubicTo(192.382, 229.598, 192.378, 229.605, 192.378, 229.612)
    ..cubicTo(192.378, 229.612, 192.094, 237.559, 192.094, 237.559)
    ..cubicTo(192.094, 237.559, 171.064, 235.177, 171.064, 235.177)
    ..cubicTo(170.489, 232.302, 169.469, 230.298, 167.127, 225.776)
    ..cubicTo(167.127, 225.776, 167.127, 225.776, 167.127, 225.776)
    ..close();

  static final Path __path47_1_17 = Path()
    ..moveTo(142.836, 231.98)
    ..cubicTo(142.836, 231.98, 144.046, 223.812, 144.046, 223.812)
    ..cubicTo(144.071, 223.64, 144.033, 223.469, 143.939, 223.322)
    ..cubicTo(142.093, 220.479, 140.001, 217.407, 137.786, 214.154)
    ..cubicTo(134.943, 209.982, 131.885, 205.492, 128.934, 200.863)
    ..cubicTo(132.155, 199.106, 136.976, 197.049, 142.326, 194.988)
    ..cubicTo(142.326, 194.988, 148.63, 209.171, 148.63, 209.171)
    ..cubicTo(148.655, 209.232, 148.689, 209.285, 148.729, 209.335)
    ..cubicTo(148.729, 209.335, 156.305, 218.558, 156.305, 218.558)
    ..cubicTo(156.359, 218.622, 156.423, 218.675, 156.495, 218.718)
    ..cubicTo(156.495, 218.718, 164.222, 223.226, 164.222, 223.226)
    ..cubicTo(164.836, 224.426, 165.383, 225.483, 165.872, 226.426)
    ..cubicTo(168.018, 230.569, 169.014, 232.498, 169.583, 235.009)
    ..cubicTo(169.583, 235.009, 142.836, 231.98, 142.836, 231.98)
    ..cubicTo(142.836, 231.98, 142.836, 231.98, 142.836, 231.98)
    ..close();

  static final Path __path47_1_18 = Path()
    ..moveTo(114.395, 169.879)
    ..cubicTo(114.384, 169.825, 114.367, 169.775, 114.346, 169.725)
    ..cubicTo(114.286, 169.593, 108.149, 155.86, 107.487, 154.377)
    ..cubicTo(107.487, 154.377, 107.165, 141.508, 107.165, 141.508)
    ..cubicTo(107.165, 141.508, 108.334, 139.015, 108.334, 139.015)
    ..cubicTo(108.334, 139.015, 136.106, 152.642, 136.106, 152.642)
    ..cubicTo(136.089, 152.688, 136.069, 152.727, 136.061, 152.774)
    ..cubicTo(136.061, 152.774, 134.084, 164.964, 134.084, 164.964)
    ..cubicTo(134.069, 165.064, 134.074, 165.164, 134.1, 165.26)
    ..cubicTo(134.1, 165.26, 141.846, 193.663, 141.846, 193.663)
    ..cubicTo(136.383, 195.766, 131.455, 197.87, 128.176, 199.667)
    ..cubicTo(121.912, 189.723, 116.265, 179.212, 114.395, 169.879)
    ..cubicTo(114.395, 169.879, 114.395, 169.879, 114.395, 169.879)
    ..close();

  static final Path __path47_1_19 = Path()
    ..moveTo(109.075, 161.824)
    ..cubicTo(109.075, 161.824, 84.1254, 175.718, 84.1254, 175.718)
    ..cubicTo(81.687, 163.642, 80.6769, 146.202, 79.8443, 131.801)
    ..cubicTo(79.7058, 129.4, 79.57, 127.064, 79.4329, 124.832)
    ..cubicTo(79.4329, 124.832, 107.065, 138.394, 107.065, 138.394)
    ..cubicTo(107.065, 138.394, 105.815, 141.058, 105.815, 141.058)
    ..cubicTo(105.768, 141.158, 105.745, 141.269, 105.748, 141.376)
    ..cubicTo(105.748, 141.376, 106.078, 154.552, 106.078, 154.552)
    ..cubicTo(106.08, 154.645, 106.101, 154.738, 106.139, 154.824)
    ..cubicTo(106.139, 154.824, 109.242, 161.771, 109.242, 161.771)
    ..cubicTo(109.186, 161.785, 109.128, 161.792, 109.075, 161.824)
    ..cubicTo(109.075, 161.824, 109.075, 161.824, 109.075, 161.824)
    ..close();

  static final Path __path47_1_20 = Path()
    ..moveTo(138.813, 160.506)
    ..cubicTo(138.935, 160.496, 139.052, 160.449, 139.151, 160.378)
    ..cubicTo(139.151, 160.378, 142.774, 157.742, 142.774, 157.742)
    ..cubicTo(142.88, 157.663, 142.962, 157.56, 143.012, 157.438)
    ..cubicTo(143.012, 157.438, 143.494, 156.267, 143.494, 156.267)
    ..cubicTo(143.494, 156.267, 166.026, 167.325, 166.026, 167.325)
    ..cubicTo(166.026, 167.325, 166.026, 185.169, 166.026, 185.169)
    ..cubicTo(166.026, 185.216, 166.045, 185.258, 166.055, 185.308)
    ..cubicTo(159.633, 187.298, 150.968, 190.198, 143.173, 193.155)
    ..cubicTo(143.173, 193.155, 135.505, 165.039, 135.505, 165.039)
    ..cubicTo(135.505, 165.039, 136.192, 160.799, 136.192, 160.799)
    ..cubicTo(136.192, 160.799, 138.813, 160.506, 138.813, 160.506)
    ..cubicTo(138.813, 160.506, 138.813, 160.506, 138.813, 160.506)
    ..close();

  static final Path __path47_1_21 = Path()
    ..moveTo(210.161, 271.83)
    ..cubicTo(210.161, 271.83, 229.851, 270.58, 229.851, 270.58)
    ..cubicTo(231.034, 273.087, 235.316, 277.323, 241.342, 282.506)
    ..cubicTo(239.942, 283.506, 238.77, 284.263, 237.995, 284.624)
    ..cubicTo(237.995, 284.624, 229.269, 286.242, 229.269, 286.242)
    ..cubicTo(229.269, 286.242, 209.336, 285.267, 209.336, 285.267)
    ..cubicTo(209.336, 285.267, 210.161, 271.83, 210.161, 271.83)
    ..cubicTo(210.161, 271.83, 210.161, 271.83, 210.161, 271.83)
    ..close();

  static final Path __path47_1_22 = Path()
    ..moveTo(237.881, 263.258)
    ..cubicTo(242.549, 262.825, 248.185, 261.797, 253.639, 260.804)
    ..cubicTo(255.125, 260.532, 256.621, 260.261, 258.111, 259.997)
    ..cubicTo(258.35, 263.172, 258.615, 266.09, 258.875, 268.526)
    ..cubicTo(258.186, 269.087, 257.218, 269.887, 256.064, 270.837)
    ..cubicTo(252.471, 273.805, 246.764, 278.516, 242.527, 281.648)
    ..cubicTo(236.877, 276.802, 232.462, 272.565, 231.237, 270.215)
    ..cubicTo(231.237, 270.215, 237.881, 263.258, 237.881, 263.258)
    ..cubicTo(237.881, 263.258, 237.881, 263.258, 237.881, 263.258)
    ..close();

  static final Path __path47_1_23 = Path()
    ..moveTo(30.6514, 372.556)
    ..cubicTo(31.2472, 373.867, 31.5561, 374.545, 31.7669, 374.899)
    ..cubicTo(31.7669, 374.899, 31.729, 374.92, 31.729, 374.92)
    ..cubicTo(34.9346, 380.528, 38.8232, 386.489, 43.0589, 392.514)
    ..cubicTo(42.8131, 392.754, 42.7599, 393.132, 42.9639, 393.422)
    ..cubicTo(43.1014, 393.618, 43.3196, 393.722, 43.5414, 393.722)
    ..cubicTo(43.6486, 393.722, 43.7539, 393.69, 43.8536, 393.64)
    ..cubicTo(46.372, 397.19, 49.0004, 400.754, 51.6789, 404.28)
    ..cubicTo(51.6789, 404.28, 25.6825, 420.877, 25.6825, 420.877)
    ..cubicTo(20.4363, 411.416, 13.7183, 401.347, 7.6285, 392.225)
    ..cubicTo(4.544, 387.607, 1.6309, 383.242, -0.9829, 379.138)
    ..cubicTo(-5.779, 371.334, -14.9594, 349.915, -21.441, 334.385)
    ..cubicTo(-16.9249, 332.502, -12.4128, 330.627, -7.9156, 328.759)
    ..cubicTo(-2.628, 326.566, 2.6084, 324.391, 7.7999, 322.219)
    ..cubicTo(7.7999, 322.219, 30.6514, 372.556, 30.6514, 372.556)
    ..cubicTo(30.6514, 372.556, 30.6514, 372.556, 30.6514, 372.556)
    ..close();

  static final Path __path47_1_24 = Path()
    ..moveTo(482.115, 564.925)
    ..cubicTo(482.115, 564.925, 464.66, 560.974, 464.66, 560.974)
    ..cubicTo(464.603, 560.96, 464.542, 560.953, 464.485, 560.957)
    ..cubicTo(464.485, 560.957, 452.627, 561.285, 452.627, 561.285)
    ..cubicTo(452.58, 561.285, 452.537, 561.292, 452.494, 561.303)
    ..cubicTo(452.48, 561.307, 452.466, 561.31, 452.448, 561.31)
    ..cubicTo(452.409, 561.303, 452.369, 561.285, 452.327, 561.285)
    ..cubicTo(452.159, 561.285, 452.012, 561.346, 451.891, 561.442)
    ..cubicTo(440.229, 564.075, 427.71, 569.461, 415.591, 574.679)
    ..cubicTo(407.916, 577.987, 400.094, 581.355, 392.382, 584.076)
    ..cubicTo(392.382, 584.076, 392.082, 575.144, 392.082, 575.144)
    ..cubicTo(392.082, 575.094, 392.075, 575.043, 392.065, 574.997)
    ..cubicTo(392.065, 574.997, 389.1, 563.139, 389.1, 563.139)
    ..cubicTo(389.075, 563.043, 389.032, 562.953, 388.971, 562.875)
    ..cubicTo(388.971, 562.875, 382.053, 553.981, 382.053, 553.981)
    ..cubicTo(381.992, 553.903, 381.914, 553.838, 381.824, 553.788)
    ..cubicTo(373.552, 549.474, 355.965, 541.605, 347.34, 538.019)
    ..cubicTo(344.014, 534.108, 342.628, 532.479, 341.986, 531.797)
    ..cubicTo(341.243, 528.325, 340.014, 524.454, 338.385, 520.26)
    ..cubicTo(338.385, 520.26, 382.825, 502.923, 382.825, 502.923)
    ..cubicTo(382.825, 502.923, 388.786, 513.589, 388.786, 513.589)
    ..cubicTo(388.968, 513.917, 389.379, 514.042, 389.718, 513.874)
    ..cubicTo(389.718, 513.874, 393.672, 511.899, 393.672, 511.899)
    ..cubicTo(394.018, 511.724, 394.161, 511.299, 393.986, 510.949)
    ..cubicTo(393.811, 510.599, 393.386, 510.46, 393.04, 510.635)
    ..cubicTo(393.04, 510.635, 389.689, 512.31, 389.689, 512.31)
    ..cubicTo(389.689, 512.31, 383.76, 501.698, 383.76, 501.698)
    ..cubicTo(383.585, 501.388, 383.214, 501.255, 382.885, 501.384)
    ..cubicTo(382.885, 501.384, 337.864, 518.946, 337.864, 518.946)
    ..cubicTo(326.02, 489.522, 295.057, 445.015, 268.89, 409.123)
    ..cubicTo(284.777, 406.766, 300.289, 403.915, 314.49, 399.954)
    ..cubicTo(314.49, 399.954, 314.473, 399.894, 314.473, 399.894)
    ..cubicTo(314.937, 399.722, 315.808, 399.219, 317.691, 398.136)
    ..cubicTo(317.691, 398.136, 334.088, 388.686, 334.088, 388.686)
    ..cubicTo(334.088, 388.686, 333.381, 387.46, 333.381, 387.46)
    ..cubicTo(333.196, 387.568, 315.326, 397.865, 314.023, 398.615)
    ..cubicTo(299.7, 402.608, 284.013, 405.465, 267.951, 407.834)
    ..cubicTo(261.847, 399.472, 256.021, 391.597, 250.785, 384.521)
    ..cubicTo(244.267, 375.71, 238.638, 368.098, 234.541, 362.355)
    ..cubicTo(234.288, 361.898, 234.33, 360.305, 234.555, 358.065)
    ..cubicTo(247.039, 357.483, 258.061, 356.654, 265.951, 355.836)
    ..cubicTo(265.951, 355.836, 265.951, 355.819, 265.951, 355.819)
    ..cubicTo(266.279, 355.715, 266.926, 355.272, 268.751, 354.018)
    ..cubicTo(268.751, 354.018, 282.091, 344.846, 282.091, 344.846)
    ..cubicTo(282.141, 344.814, 282.184, 344.775, 282.224, 344.728)
    ..cubicTo(282.224, 344.728, 297.375, 327.27, 297.375, 327.27)
    ..cubicTo(297.632, 326.973, 297.6, 326.531, 297.307, 326.273)
    ..cubicTo(297.01, 326.016, 296.564, 326.048, 296.31, 326.345)
    ..cubicTo(296.31, 326.345, 281.216, 343.732, 281.216, 343.732)
    ..cubicTo(280.109, 344.493, 267.151, 353.404, 265.629, 354.447)
    ..cubicTo(256.85, 355.354, 246.196, 356.129, 234.713, 356.654)
    ..cubicTo(235.495, 350.082, 237.416, 339.607, 238.416, 334.163)
    ..cubicTo(239.027, 330.82, 239.47, 328.409, 239.574, 327.548)
    ..cubicTo(239.577, 327.516, 239.577, 327.488, 239.577, 327.456)
    ..cubicTo(239.577, 327.456, 239.252, 305.443, 239.252, 305.443)
    ..cubicTo(239.252, 305.443, 251.718, 305.443, 251.718, 305.443)
    ..cubicTo(251.875, 305.443, 252.025, 305.393, 252.15, 305.297)
    ..cubicTo(253.753, 304.047, 257.236, 299.421, 259.129, 296.903)
    ..cubicTo(262.304, 299.382, 265.576, 301.904, 268.855, 304.429)
    ..cubicTo(273.148, 307.725, 276.541, 310.333, 277.938, 311.533)
    ..cubicTo(278.07, 311.647, 278.234, 311.704, 278.398, 311.704)
    ..cubicTo(278.595, 311.704, 278.795, 311.619, 278.934, 311.458)
    ..cubicTo(279.188, 311.161, 279.152, 310.715, 278.855, 310.461)
    ..cubicTo(277.434, 309.236, 274.03, 306.618, 269.719, 303.307)
    ..cubicTo(266.879, 301.125, 263.504, 298.528, 259.947, 295.753)
    ..cubicTo(260.05, 295.471, 259.972, 295.146, 259.718, 294.953)
    ..cubicTo(259.472, 294.764, 259.143, 294.771, 258.9, 294.935)
    ..cubicTo(253.764, 290.917, 248.332, 286.581, 243.628, 282.588)
    ..cubicTo(247.814, 279.484, 253.214, 275.023, 256.964, 271.93)
    ..cubicTo(258.289, 270.833, 259.375, 269.94, 260.065, 269.387)
    ..cubicTo(260.254, 269.233, 260.35, 268.997, 260.325, 268.758)
    ..cubicTo(260.043, 266.226, 259.765, 263.133, 259.507, 259.75)
    ..cubicTo(263.076, 259.136, 266.544, 258.604, 269.565, 258.339)
    ..cubicTo(269.83, 258.314, 270.062, 258.146, 270.158, 257.896)
    ..cubicTo(270.158, 257.896, 270.819, 256.25, 270.819, 256.25)
    ..cubicTo(270.962, 255.889, 270.787, 255.478, 270.426, 255.332)
    ..cubicTo(270.062, 255.185, 269.651, 255.361, 269.505, 255.725)
    ..cubicTo(269.505, 255.725, 269.008, 256.971, 269.008, 256.971)
    ..cubicTo(266.083, 257.246, 262.79, 257.754, 259.404, 258.336)
    ..cubicTo(258.614, 247.328, 258.107, 233.766, 258.679, 226.397)
    ..cubicTo(258.711, 226.008, 258.418, 225.669, 258.029, 225.637)
    ..cubicTo(257.643, 225.608, 257.3, 225.897, 257.268, 226.287)
    ..cubicTo(256.689, 233.748, 257.204, 247.481, 258.004, 258.579)
    ..cubicTo(256.468, 258.85, 254.918, 259.132, 253.386, 259.411)
    ..cubicTo(247.86, 260.422, 242.145, 261.465, 237.491, 261.872)
    ..cubicTo(237.32, 261.886, 237.159, 261.965, 237.041, 262.086)
    ..cubicTo(237.041, 262.086, 230.916, 268.504, 230.916, 268.504)
    ..cubicTo(230.916, 268.504, 228.044, 230.573, 228.044, 230.573)
    ..cubicTo(228.016, 230.184, 227.68, 229.894, 227.287, 229.919)
    ..cubicTo(226.898, 229.948, 226.605, 230.287, 226.637, 230.676)
    ..cubicTo(226.637, 230.676, 229.548, 269.183, 229.548, 269.183)
    ..cubicTo(229.548, 269.183, 210.246, 270.408, 210.246, 270.408)
    ..cubicTo(210.246, 270.408, 210.261, 270.194, 210.261, 270.194)
    ..cubicTo(210.282, 269.805, 209.986, 269.469, 209.596, 269.447)
    ..cubicTo(209.296, 269.426, 209.039, 269.587, 208.921, 269.833)
    ..cubicTo(208.921, 269.833, 204.032, 267.261, 204.032, 267.261)
    ..cubicTo(204.032, 267.261, 197.663, 261.529, 197.663, 261.529)
    ..cubicTo(197.663, 261.529, 195.763, 254.56, 195.763, 254.56)
    ..cubicTo(195.763, 254.56, 195.136, 239.813, 195.136, 239.813)
    ..cubicTo(195.136, 239.813, 215.411, 241.87, 215.411, 241.87)
    ..cubicTo(215.436, 241.87, 215.461, 241.87, 215.482, 241.87)
    ..cubicTo(215.843, 241.87, 216.15, 241.602, 216.186, 241.238)
    ..cubicTo(216.225, 240.849, 215.943, 240.502, 215.554, 240.463)
    ..cubicTo(215.554, 240.463, 195.085, 238.384, 195.085, 238.384)
    ..cubicTo(195.024, 238.095, 194.791, 237.863, 194.481, 237.827)
    ..cubicTo(194.481, 237.827, 193.503, 237.716, 193.503, 237.716)
    ..cubicTo(193.503, 237.716, 193.767, 230.341, 193.767, 230.341)
    ..cubicTo(193.829, 230.337, 193.891, 230.33, 193.952, 230.312)
    ..cubicTo(194.153, 230.251, 194.316, 230.101, 194.396, 229.905)
    ..cubicTo(194.396, 229.905, 198.349, 220.354, 198.349, 220.354)
    ..cubicTo(198.499, 219.993, 198.328, 219.579, 197.967, 219.433)
    ..cubicTo(197.606, 219.283, 197.192, 219.454, 197.043, 219.815)
    ..cubicTo(197.043, 219.815, 193.416, 228.58, 193.416, 228.58)
    ..cubicTo(193.416, 228.58, 185.712, 223.54, 185.712, 223.54)
    ..cubicTo(185.712, 223.54, 177.58, 208.903, 177.58, 208.903)
    ..cubicTo(177.58, 208.903, 167.942, 186.205, 167.942, 186.205)
    ..cubicTo(168.105, 186.155, 168.273, 186.105, 168.432, 186.058)
    ..cubicTo(169.415, 186.208, 174.696, 187.019, 174.696, 187.019)
    ..cubicTo(174.696, 187.019, 174.911, 185.623, 174.911, 185.623)
    ..cubicTo(174.911, 185.623, 171.7, 185.13, 171.7, 185.13)
    ..cubicTo(169.576, 184.801, 168.639, 184.658, 168.188, 184.694)
    ..cubicTo(168.188, 184.694, 168.177, 184.658, 168.177, 184.658)
    ..cubicTo(167.938, 184.73, 167.688, 184.805, 167.44, 184.88)
    ..cubicTo(167.44, 184.88, 167.44, 167.486, 167.44, 167.486)
    ..cubicTo(167.44, 167.486, 178.553, 168.089, 178.553, 168.089)
    ..cubicTo(178.566, 168.089, 178.579, 168.089, 178.592, 168.089)
    ..cubicTo(178.965, 168.089, 179.277, 167.796, 179.297, 167.421)
    ..cubicTo(179.318, 167.028, 179.019, 166.696, 178.63, 166.675)
    ..cubicTo(178.63, 166.675, 167.671, 166.082, 167.671, 166.082)
    ..cubicTo(172.061, 157.085, 173.423, 154.292, 173.841, 153.377)
    ..cubicTo(177.805, 150.302, 183.281, 146.809, 189.076, 143.116)
    ..cubicTo(195.546, 138.987, 202.239, 134.722, 206.71, 131.036)
    ..cubicTo(206.867, 130.908, 206.96, 130.715, 206.967, 130.511)
    ..cubicTo(206.967, 130.511, 207.625, 109.759, 207.625, 109.759)
    ..cubicTo(207.632, 109.552, 207.546, 109.349, 207.389, 109.209)
    ..cubicTo(203.124, 105.406, 198.72, 101.012, 194.166, 96.2798)
    ..cubicTo(194.166, 96.2798, 196.61, 96.2405, 196.61, 96.2405)
    ..cubicTo(203.299, 96.1298, 215.757, 95.9298, 219.819, 95.619)
    ..cubicTo(219.965, 95.6083, 220.101, 95.5547, 220.211, 95.4619)
    ..cubicTo(220.211, 95.4619, 223.63, 92.6653, 223.63, 92.6653)
    ..cubicTo(223.63, 92.6653, 233.17, 92.9724, 233.17, 92.9724)
    ..cubicTo(233.17, 92.9724, 241.127, 107.613, 241.127, 107.613)
    ..cubicTo(241.127, 107.613, 241.127, 111.427, 241.127, 111.427)
    ..cubicTo(240.163, 112.424, 238.666, 113.999, 236.856, 115.91)
    ..cubicTo(229.937, 123.214, 217.075, 136.787, 213.154, 139.426)
    ..cubicTo(212.418, 139.783, 211.214, 140.344, 209.739, 141.03)
    ..cubicTo(203.596, 143.884, 193.314, 148.663, 190.972, 150.709)
    ..cubicTo(190.952, 150.727, 190.932, 150.749, 190.913, 150.766)
    ..cubicTo(190.913, 150.766, 181.69, 160.978, 181.69, 160.978)
    ..cubicTo(181.428, 161.267, 181.451, 161.717, 181.741, 161.978)
    ..cubicTo(181.876, 162.099, 182.045, 162.16, 182.214, 162.16)
    ..cubicTo(182.407, 162.16, 182.6, 162.082, 182.739, 161.928)
    ..cubicTo(182.739, 161.928, 191.933, 151.749, 191.933, 151.749)
    ..cubicTo(194.188, 149.813, 204.685, 144.937, 210.332, 142.312)
    ..cubicTo(211.85, 141.608, 213.079, 141.037, 213.814, 140.676)
    ..cubicTo(213.843, 140.666, 213.872, 140.648, 213.897, 140.63)
    ..cubicTo(217.904, 137.965, 230.409, 124.768, 237.881, 116.885)
    ..cubicTo(239.82, 114.838, 241.392, 113.181, 242.342, 112.21)
    ..cubicTo(242.47, 112.078, 242.542, 111.899, 242.542, 111.713)
    ..cubicTo(242.542, 111.713, 242.542, 107.431, 242.542, 107.431)
    ..cubicTo(242.542, 107.313, 242.51, 107.199, 242.456, 107.095)
    ..cubicTo(242.456, 107.095, 234.22, 91.9437, 234.22, 91.9437)
    ..cubicTo(234.102, 91.7223, 233.873, 91.583, 233.623, 91.5723)
    ..cubicTo(233.623, 91.5723, 223.412, 91.2437, 223.412, 91.2437)
    ..cubicTo(223.24, 91.2366, 223.072, 91.2973, 222.94, 91.4044)
    ..cubicTo(222.94, 91.4044, 219.49, 94.2261, 219.49, 94.2261)
    ..cubicTo(215.254, 94.5261, 203.146, 94.719, 196.587, 94.8262)
    ..cubicTo(196.587, 94.8262, 194.361, 94.8619, 194.361, 94.8619)
    ..cubicTo(194.361, 94.8619, 183.873, 84.3753, 183.873, 84.3753)
    ..cubicTo(183.873, 84.3753, 186.667, 81.5822, 186.667, 81.5822)
    ..cubicTo(186.799, 81.4465, 186.874, 81.2679, 186.874, 81.0822)
    ..cubicTo(186.874, 81.0822, 186.874, 68.3561, 186.874, 68.3561)
    ..cubicTo(186.874, 68.3561, 189.142, 61.8734, 189.142, 61.8734)
    ..cubicTo(189.142, 61.8734, 196.029, 41.5397, 196.029, 41.5397)
    ..cubicTo(196.029, 41.5397, 202.567, 31.7353, 202.567, 31.7353)
    ..cubicTo(202.653, 31.6068, 202.696, 31.4496, 202.685, 31.296)
    ..cubicTo(202.685, 31.296, 202.024, 21.7416, 202.024, 21.7416)
    ..cubicTo(201.999, 21.3523, 201.646, 21.0666, 201.271, 21.0844)
    ..cubicTo(200.881, 21.113, 200.588, 21.4488, 200.613, 21.8381)
    ..cubicTo(200.613, 21.8381, 201.256, 31.1531, 201.256, 31.1531)
    ..cubicTo(201.256, 31.1531, 194.802, 40.8325, 194.802, 40.8325)
    ..cubicTo(194.768, 40.886, 194.741, 40.9396, 194.72, 40.9968)
    ..cubicTo(194.72, 40.9968, 187.806, 61.4127, 187.806, 61.4127)
    ..cubicTo(187.806, 61.4127, 185.5, 68.0026, 185.5, 68.0026)
    ..cubicTo(185.474, 68.0776, 185.46, 68.1561, 185.46, 68.2347)
    ..cubicTo(185.46, 68.2347, 185.46, 80.7893, 185.46, 80.7893)
    ..cubicTo(185.46, 80.7893, 182.43, 83.8181, 182.43, 83.8181)
    ..cubicTo(171.975, 72.6243, 161.209, 61.1913, 151.03, 53.1871)
    ..cubicTo(150.912, 53.0942, 150.766, 53.0406, 150.616, 53.0334)
    ..cubicTo(150.616, 53.0334, 140.405, 52.7049, 140.405, 52.7049)
    ..cubicTo(140.043, 52.6942, 139.725, 52.9763, 139.687, 53.3442)
    ..cubicTo(139.244, 48.6724, 138.609, 44.4471, 137.775, 41.0575)
    ..cubicTo(137.748, 40.9432, 137.694, 40.8432, 137.618, 40.7575)
    ..cubicTo(131.555, 33.9034, 118.93, 20.3737, 112.284, 13.7732)
    ..cubicTo(112.284, 13.7732, 104.753, 1.3328, 104.753, 1.3328)
    ..cubicTo(104.552, 0.9971, 104.117, 0.89, 103.783, 1.0936)
    ..cubicTo(103.449, 1.2972, 103.342, 1.7293, 103.544, 2.065)
    ..cubicTo(103.544, 2.065, 111.12, 14.5803, 111.12, 14.5803)
    ..cubicTo(111.15, 14.6304, 111.186, 14.6768, 111.227, 14.7161)
    ..cubicTo(117.796, 21.2309, 130.331, 34.6641, 136.444, 41.5611)
    ..cubicTo(139.972, 56.1551, 139.803, 87.322, 136.117, 101.491)
    ..cubicTo(136.117, 101.491, 110.864, 130.354, 110.864, 130.354)
    ..cubicTo(110.82, 130.404, 110.784, 130.458, 110.756, 130.518)
    ..cubicTo(110.756, 130.518, 107.666, 137.112, 107.666, 137.112)
    ..cubicTo(107.666, 137.112, 79.3311, 123.207, 79.3311, 123.207)
    ..cubicTo(79.1714, 120.7, 79.0075, 118.357, 78.8318, 116.267)
    ..cubicTo(78.8239, 116.174, 78.7978, 116.085, 78.7557, 116.003)
    ..cubicTo(77.0002, 112.595, 75.4097, 109.684, 74.0071, 107.113)
    ..cubicTo(67.269, 94.7726, 64.4799, 89.6614, 65.6568, 70.5849)
    ..cubicTo(65.6618, 70.5027, 65.6532, 70.4242, 65.631, 70.3456)
    ..cubicTo(65.631, 70.3456, 56.4278, 38.1358, 56.4278, 38.1358)
    ..cubicTo(56.4278, 38.1358, 56.3028, 36.4607, 56.3028, 36.4607)
    ..cubicTo(55.7603, 29.1851, 54.7502, 15.6447, 54.458, 9.8978)
    ..cubicTo(54.453, 9.8014, 54.428, 9.705, 54.3844, 9.6157)
    ..cubicTo(54.3844, 9.6157, 49.773, 0.3935, 49.773, 0.3935)
    ..cubicTo(49.598, 0.0435, 49.1747, -0.0994, 48.8243, 0.0792)
    ..cubicTo(48.475, 0.2506, 48.3336, 0.6757, 48.5082, 1.0257)
    ..cubicTo(48.5082, 1.0257, 53.054, 10.1157, 53.054, 10.1157)
    ..cubicTo(53.3561, 15.9626, 54.3548, 29.3458, 54.8934, 36.5678)
    ..cubicTo(54.8934, 36.5678, 55.0234, 38.3144, 55.0234, 38.3144)
    ..cubicTo(55.027, 38.3608, 55.0359, 38.4073, 55.0488, 38.4537)
    ..cubicTo(55.0488, 38.4537, 64.2384, 70.617, 64.2384, 70.617)
    ..cubicTo(63.0558, 90.0043, 65.9043, 95.2226, 72.7663, 107.791)
    ..cubicTo(74.1482, 110.324, 75.7122, 113.188, 77.4345, 116.524)
    ..cubicTo(77.5874, 118.353, 77.7309, 120.385, 77.8713, 122.543)
    ..cubicTo(77.8699, 122.539, 77.8685, 122.539, 77.8667, 122.539)
    ..cubicTo(77.8667, 122.539, 67.8209, 121.553, 67.8209, 121.553)
    ..cubicTo(60.4171, 120.825, 58.3165, 120.614, 57.6179, 120.632)
    ..cubicTo(57.6179, 120.632, 57.609, 120.567, 57.609, 120.567)
    ..cubicTo(49.5208, 121.675, 34.2539, 125.968, 26.9108, 128.804)
    ..cubicTo(14.6873, 129.833, -10.9001, 130.004, -33.483, 130.158)
    ..cubicTo(-49.899, 130.268, -65.4049, 130.372, -74.7406, 130.772)
    ..cubicTo(-74.8224, 130.775, -74.9028, 130.793, -74.9785, 130.825)
    ..cubicTo(-86.623, 135.601, -129.058, 151.502, -139.183, 155.188)
    ..cubicTo(-139.55, 155.324, -139.739, 155.727, -139.606, 156.095)
    ..cubicTo(-139.472, 156.463, -139.066, 156.653, -138.7, 156.517)
    ..cubicTo(-128.601, 152.842, -86.3759, 137.015, -74.5567, 132.179)
    ..cubicTo(-65.2338, 131.783, -49.8047, 131.679, -33.473, 131.572)
    ..cubicTo(-9.695, 131.411, 14.893, 131.243, 27.1311, 130.204)
    ..cubicTo(27.1987, 130.2, 27.2644, 130.186, 27.3276, 130.161)
    ..cubicTo(34.5382, 127.357, 49.6665, 123.096, 57.7193, 121.978)
    ..cubicTo(59.0355, 122.107, 75.9619, 123.771, 77.6013, 123.936)
    ..cubicTo(77.6013, 123.936, 77.972, 124.114, 77.972, 124.114)
    ..cubicTo(78.126, 126.582, 78.2774, 129.193, 78.4328, 131.879)
    ..cubicTo(78.745, 137.28, 79.0825, 143.109, 79.51, 148.92)
    ..cubicTo(71.858, 149.334, 62.6508, 150.277, 52.905, 151.277)
    ..cubicTo(29.376, 153.692, 2.7074, 156.431, -14.963, 153.181)
    ..cubicTo(-15.0183, 153.17, -15.0737, 153.17, -15.1312, 153.17)
    ..cubicTo(-15.6037, 153.199, -26.7282, 153.838, -28.4048, 154.17)
    ..cubicTo(-28.7876, 154.249, -29.0359, 154.62, -28.9591, 155.002)
    ..cubicTo(-28.8834, 155.385, -28.5115, 155.635, -28.1276, 155.556)
    ..cubicTo(-26.8721, 155.306, -19.1308, 154.817, -15.1348, 154.588)
    ..cubicTo(-9.2668, 155.66, -2.4441, 156.081, 4.9101, 156.081)
    ..cubicTo(19.9495, 156.081, 37.2091, 154.31, 53.049, 152.684)
    ..cubicTo(62.7905, 151.684, 71.9923, 150.741, 79.6154, 150.331)
    ..cubicTo(80.3276, 159.674, 81.2884, 168.893, 82.7721, 176.165)
    ..cubicTo(82.7721, 176.165, 52.1717, 173.265, 52.1717, 173.265)
    ..cubicTo(52.1328, 173.261, 52.0921, 173.261, 52.0525, 173.265)
    ..cubicTo(51.921, 173.275, 38.881, 174.25, 36.953, 174.25)
    ..cubicTo(36.5626, 174.25, 36.2462, 174.568, 36.2462, 174.958)
    ..cubicTo(36.2462, 175.347, 36.5626, 175.665, 36.953, 175.665)
    ..cubicTo(38.8853, 175.665, 51.0134, 174.761, 52.0982, 174.679)
    ..cubicTo(52.0982, 174.679, 83.0799, 177.615, 83.0799, 177.615)
    ..cubicTo(83.3735, 178.937, 83.6857, 180.183, 84.0197, 181.347)
    ..cubicTo(85.5902, 189.727, 85.2187, 212.357, 85.0401, 223.233)
    ..cubicTo(85.0401, 223.233, 85.0037, 225.526, 85.0037, 225.526)
    ..cubicTo(85.0037, 225.526, 81.7888, 226.762, 81.7888, 226.762)
    ..cubicTo(81.7888, 226.762, 78.7703, 220.122, 78.7703, 220.122)
    ..cubicTo(78.6082, 219.765, 78.1874, 219.608, 77.8349, 219.772)
    ..cubicTo(77.4791, 219.933, 77.322, 220.351, 77.4838, 220.704)
    ..cubicTo(77.4838, 220.704, 80.7776, 227.951, 80.7776, 227.951)
    ..cubicTo(80.8951, 228.212, 81.1516, 228.365, 81.4209, 228.365)
    ..cubicTo(81.5055, 228.365, 81.5916, 228.351, 81.6748, 228.319)
    ..cubicTo(81.6748, 228.319, 85.9566, 226.672, 85.9566, 226.672)
    ..cubicTo(86.2263, 226.569, 86.4052, 226.312, 86.4099, 226.022)
    ..cubicTo(86.4099, 226.022, 86.4534, 223.258, 86.4534, 223.258)
    ..cubicTo(86.6331, 212.336, 87.0056, 189.605, 85.3937, 181.022)
    ..cubicTo(85.0505, 179.826, 84.7305, 178.533, 84.4301, 177.169)
    ..cubicTo(84.4301, 177.169, 109.764, 163.057, 109.764, 163.057)
    ..cubicTo(109.779, 163.049, 109.788, 163.035, 109.803, 163.025)
    ..cubicTo(109.803, 163.025, 111.975, 167.886, 111.975, 167.886)
    ..cubicTo(112.512, 169.086, 112.815, 169.764, 113.016, 170.154)
    ..cubicTo(113.016, 170.154, 113.009, 170.154, 113.009, 170.154)
    ..cubicTo(114.922, 179.704, 120.65, 190.37, 126.989, 200.435)
    ..cubicTo(126.989, 200.435, 116.563, 208.489, 116.563, 208.489)
    ..cubicTo(116.472, 208.56, 116.4, 208.653, 116.352, 208.757)
    ..cubicTo(109.907, 222.854, 108.674, 225.551, 108.439, 226.147)
    ..cubicTo(108.439, 226.147, 108.413, 226.14, 108.413, 226.14)
    ..cubicTo(108.321, 226.447, 108.011, 228.33, 107.148, 233.634)
    ..cubicTo(105.777, 242.059, 102.927, 259.575, 101.259, 266.972)
    ..cubicTo(101.259, 266.972, 34.9157, 272.74, 34.9157, 272.74)
    ..cubicTo(34.5268, 272.776, 34.2389, 273.119, 34.2728, 273.505)
    ..cubicTo(34.3046, 273.876, 34.6135, 274.151, 34.9761, 274.151)
    ..cubicTo(34.9968, 274.151, 35.0171, 274.151, 35.0379, 274.151)
    ..cubicTo(35.0379, 274.151, 100.914, 268.422, 100.914, 268.422)
    ..cubicTo(100.696, 269.279, 100.507, 269.89, 100.357, 270.187)
    ..cubicTo(100.293, 270.222, 100.234, 270.265, 100.182, 270.319)
    ..cubicTo(100.182, 270.319, 87.9757, 282.977, 86.916, 284.077)
    ..cubicTo(62.9883, 297.16, 36.494, 308.686, 8.4793, 320.405)
    ..cubicTo(8.2782, 320.187, 7.9596, 320.105, 7.6746, 320.234)
    ..cubicTo(7.4032, 320.359, 7.2502, 320.63, 7.2638, 320.912)
    ..cubicTo(2.0705, 323.084, -3.1677, 325.259, -8.4578, 327.456)
    ..cubicTo(-12.9553, 329.324, -17.4682, 331.195, -21.9846, 333.081)
    ..cubicTo(-23.5579, 329.306, -24.9541, 325.923, -26.0589, 323.245)
    ..cubicTo(-26.0589, 323.245, -27.284, 320.28, -27.284, 320.28)
    ..cubicTo(-27.3025, 320.234, -27.3261, 320.191, -27.3536, 320.148)
    ..cubicTo(-27.3536, 320.148, -28.263, 318.816, -28.263, 318.816)
    ..cubicTo(-31.2161, 314.465, -31.3925, 314.205, -37.148, 311.036)
    ..cubicTo(-37.198, 311.008, -37.2512, 310.986, -37.3062, 310.972)
    ..cubicTo(-38.2634, 310.715, -40.0557, 310.194, -42.3244, 309.536)
    ..cubicTo(-42.8302, 309.386, -43.362, 309.233, -43.9082, 309.076)
    ..cubicTo(-43.9082, 309.076, -59.5766, 275.451, -59.5766, 275.451)
    ..cubicTo(-59.6223, 275.355, -59.6905, 275.266, -59.7755, 275.198)
    ..cubicTo(-59.7755, 275.198, -68.0105, 268.612, -68.0105, 268.612)
    ..cubicTo(-68.0533, 268.576, -68.099, 268.547, -68.1483, 268.526)
    ..cubicTo(-68.1483, 268.526, -73.787, 265.84, -73.787, 265.84)
    ..cubicTo(-73.9074, 265.64, -74.1124, 265.501, -74.3617, 265.493)
    ..cubicTo(-74.4045, 265.49, -74.4424, 265.504, -74.4835, 265.508)
    ..cubicTo(-74.4835, 265.508, -88.7646, 258.707, -88.7646, 258.707)
    ..cubicTo(-88.7646, 258.707, -92.5249, 254.321, -92.5249, 254.321)
    ..cubicTo(-92.5249, 254.321, -94.094, 249.299, -94.094, 249.299)
    ..cubicTo(-94.094, 249.299, -93.7675, 234.923, -93.7675, 234.923)
    ..cubicTo(-93.7661, 234.866, -93.7718, 234.805, -93.7847, 234.752)
    ..cubicTo(-93.7847, 234.752, -97.061, 220.333, -97.061, 220.333)
    ..cubicTo(-97.061, 220.333, -97.061, 200.32, -97.061, 200.32)
    ..cubicTo(-97.061, 199.931, -97.3775, 199.613, -97.7679, 199.613)
    ..cubicTo(-98.1583, 199.613, -98.4747, 199.931, -98.4747, 200.32)
    ..cubicTo(-98.4747, 200.32, -98.4747, 220.415, -98.4747, 220.415)
    ..cubicTo(-98.4747, 220.465, -98.4686, 220.518, -98.4572, 220.572)
    ..cubicTo(-98.4572, 220.572, -95.1827, 234.977, -95.1827, 234.977)
    ..cubicTo(-95.1827, 234.977, -95.5098, 249.385, -95.5098, 249.385)
    ..cubicTo(-95.512, 249.46, -95.5005, 249.539, -95.478, 249.61)
    ..cubicTo(-95.478, 249.61, -93.8308, 254.882, -93.8308, 254.882)
    ..cubicTo(-93.8022, 254.971, -93.7554, 255.057, -93.6929, 255.132)
    ..cubicTo(-93.6929, 255.132, -89.7401, 259.743, -89.7401, 259.743)
    ..cubicTo(-89.6761, 259.818, -89.5965, 259.879, -89.5076, 259.922)
    ..cubicTo(-89.5076, 259.922, -75.1039, 266.779, -75.1039, 266.779)
    ..cubicTo(-75.1039, 266.779, -76.0758, 302.411, -76.0758, 302.411)
    ..cubicTo(-76.0815, 302.625, -75.9925, 302.825, -75.8332, 302.964)
    ..cubicTo(-75.6743, 303.104, -75.4611, 303.164, -75.2528, 303.129)
    ..cubicTo(-71.784, 302.55, -54.5601, 307.454, -44.6843, 310.322)
    ..cubicTo(-44.63, 310.344, -44.5743, 310.361, -44.5157, 310.372)
    ..cubicTo(-43.8846, 310.554, -43.2827, 310.729, -42.7195, 310.894)
    ..cubicTo(-40.5057, 311.536, -38.7445, 312.047, -37.7552, 312.315)
    ..cubicTo(-32.3708, 315.28, -32.3036, 315.38, -29.4327, 319.609)
    ..cubicTo(-29.4327, 319.609, -28.5623, 320.887, -28.5623, 320.887)
    ..cubicTo(-28.5623, 320.887, -27.3654, 323.784, -27.3654, 323.784)
    ..cubicTo(-26.2117, 326.581, -24.8238, 329.942, -23.2904, 333.628)
    ..cubicTo(-60.3098, 349.09, -97.5253, 365.323, -128.907, 384.964)
    ..cubicTo(-128.907, 384.964, -134.763, 370.998, -134.763, 370.998)
    ..cubicTo(-134.763, 370.998, -131.824, 339.649, -131.824, 339.649)
    ..cubicTo(-131.824, 339.649, -126.423, 325.409, -126.423, 325.409)
    ..cubicTo(-126.354, 325.23, -126.364, 325.038, -126.438, 324.873)
    ..cubicTo(-126.896, 321.323, -127.425, 254.982, -127.68, 222.936)
    ..cubicTo(-127.769, 211.825, -127.829, 204.31, -127.856, 202.785)
    ..cubicTo(-127.856, 202.785, -123.487, 194.048, -123.487, 194.048)
    ..cubicTo(-123.312, 193.698, -123.454, 193.277, -123.803, 193.102)
    ..cubicTo(-124.153, 192.927, -124.577, 193.066, -124.751, 193.416)
    ..cubicTo(-124.751, 193.416, -129.198, 202.31, -129.198, 202.31)
    ..cubicTo(-129.25, 202.413, -129.276, 202.528, -129.272, 202.646)
    ..cubicTo(-129.248, 203.624, -129.183, 211.728, -129.094, 222.947)
    ..cubicTo(-128.958, 240.049, -128.752, 265.89, -128.523, 287.07)
    ..cubicTo(-128.397, 298.693, -128.277, 307.768, -128.165, 314.04)
    ..cubicTo(-128.036, 321.302, -127.988, 324.016, -127.809, 325.08)
    ..cubicTo(-127.809, 325.08, -133.18, 339.239, -133.18, 339.239)
    ..cubicTo(-133.202, 339.296, -133.216, 339.36, -133.222, 339.421)
    ..cubicTo(-133.222, 339.421, -136.187, 371.045, -136.187, 371.045)
    ..cubicTo(-136.197, 371.159, -136.18, 371.277, -136.135, 371.384)
    ..cubicTo(-136.135, 371.384, -130.118, 385.732, -130.118, 385.732)
    ..cubicTo(-133.251, 387.71, -136.332, 389.721, -139.34, 391.772)
    ..cubicTo(-139.662, 391.993, -139.745, 392.432, -139.525, 392.754)
    ..cubicTo(-139.389, 392.954, -139.167, 393.064, -138.941, 393.064)
    ..cubicTo(-138.804, 393.064, -138.665, 393.022, -138.543, 392.939)
    ..cubicTo(-135.584, 390.921, -132.554, 388.943, -129.473, 386.996)
    ..cubicTo(-129.352, 387.082, -129.209, 387.132, -129.059, 387.132)
    ..cubicTo(-128.968, 387.132, -128.876, 387.118, -128.787, 387.078)
    ..cubicTo(-128.475, 386.95, -128.321, 386.621, -128.378, 386.303)
    ..cubicTo(-97.0417, 366.655, -59.7991, 350.407, -22.7464, 334.931)
    ..cubicTo(-16.1263, 350.804, -7.0784, 371.916, -2.1812, 379.888)
    ..cubicTo(0.4465, 384.014, 3.3639, 388.386, 6.4527, 393.011)
    ..cubicTo(12.5814, 402.19, 19.3498, 412.337, 24.5874, 421.817)
    ..cubicTo(24.5874, 421.817, -6.9537, 452.394, -6.9537, 452.394)
    ..cubicTo(-6.9537, 452.394, -18.9722, 459.216, -18.9722, 459.216)
    ..cubicTo(-18.9722, 459.216, -19.144, 459.256, -19.144, 459.256)
    ..cubicTo(-23.8501, 460.327, -36.3511, 463.174, -40.1268, 465.185)
    ..cubicTo(-40.1268, 465.185, -40.0986, 465.238, -40.0986, 465.238)
    ..cubicTo(-41.1169, 465.835, -45.978, 469.042, -72.1354, 486.301)
    ..cubicTo(-72.4612, 486.515, -72.5508, 486.954, -72.3358, 487.279)
    ..cubicTo(-72.2001, 487.486, -71.9747, 487.597, -71.7451, 487.597)
    ..cubicTo(-71.6118, 487.597, -71.4765, 487.561, -71.3568, 487.479)
    ..cubicTo(-71.3568, 487.479, -39.5321, 466.481, -39.4621, 466.435)
    ..cubicTo(-35.8532, 464.51, -23.0404, 461.591, -18.8297, 460.631)
    ..cubicTo(-18.8297, 460.631, -18.5568, 460.57, -18.5568, 460.57)
    ..cubicTo(-18.4893, 460.556, -18.425, 460.531, -18.3647, 460.495)
    ..cubicTo(-18.3647, 460.495, -6.1772, 453.58, -6.1772, 453.58)
    ..cubicTo(-6.1254, 453.548, -6.0773, 453.512, -6.0344, 453.469)
    ..cubicTo(-6.0344, 453.469, 25.291, 423.103, 25.291, 423.103)
    ..cubicTo(26.4025, 425.16, 27.4415, 427.182, 28.3745, 429.15)
    ..cubicTo(28.5116, 429.764, 29.4538, 434.004, 29.6424, 434.854)
    ..cubicTo(29.4185, 435.936, 29.1406, 437.257, 28.8234, 438.761)
    ..cubicTo(26.2296, 451.08, 21.401, 474.007, 21.7543, 482.311)
    ..cubicTo(21.7557, 482.347, 21.76, 482.382, 21.7675, 482.418)
    ..cubicTo(27.1308, 509.095, 44.1647, 542.08, 60.6381, 573.979)
    ..cubicTo(70.1378, 592.373, 79.1103, 609.75, 85.0473, 624.512)
    ..cubicTo(85.158, 624.787, 85.423, 624.955, 85.7034, 624.955)
    ..cubicTo(85.7909, 624.955, 85.8802, 624.937, 85.9666, 624.905)
    ..cubicTo(86.3288, 624.758, 86.5042, 624.347, 86.3588, 623.983)
    ..cubicTo(80.3969, 609.161, 71.4094, 591.756, 61.8943, 573.329)
    ..cubicTo(45.4766, 541.541, 28.5006, 508.667, 23.1648, 482.193)
    ..cubicTo(22.8437, 474.017, 27.8151, 450.412, 30.2067, 439.05)
    ..cubicTo(30.5389, 437.475, 30.8286, 436.1, 31.0575, 434.989)
    ..cubicTo(31.0775, 434.893, 31.0768, 434.793, 31.055, 434.693)
    ..cubicTo(31.055, 434.693, 30.3968, 431.728, 30.3968, 431.728)
    ..cubicTo(29.9814, 429.86, 29.7956, 429.028, 29.6449, 428.635)
    ..cubicTo(29.6449, 428.635, 29.686, 428.617, 29.686, 428.617)
    ..cubicTo(28.6856, 426.503, 27.569, 424.328, 26.3675, 422.117)
    ..cubicTo(26.3675, 422.117, 52.5403, 405.405, 52.5403, 405.405)
    ..cubicTo(63.2348, 419.384, 74.5446, 432.578, 82.2092, 441.243)
    ..cubicTo(82.2417, 441.283, 82.2777, 441.315, 82.3174, 441.343)
    ..cubicTo(82.3174, 441.343, 92.5286, 448.919, 92.5286, 448.919)
    ..cubicTo(92.6025, 448.976, 92.6857, 449.015, 92.775, 449.037)
    ..cubicTo(92.775, 449.037, 106.949, 452.648, 106.949, 452.648)
    ..cubicTo(108.637, 453.08, 109.395, 453.273, 109.783, 453.302)
    ..cubicTo(109.783, 453.302, 109.785, 453.341, 109.785, 453.341)
    ..cubicTo(129.07, 452.334, 144.178, 437.325, 158.788, 422.81)
    ..cubicTo(165.048, 416.591, 170.961, 410.72, 177.043, 406.094)
    ..cubicTo(177.353, 405.858, 177.414, 405.416, 177.178, 405.105)
    ..cubicTo(176.941, 404.794, 176.498, 404.733, 176.187, 404.969)
    ..cubicTo(170.031, 409.652, 164.086, 415.556, 157.792, 421.806)
    ..cubicTo(143.397, 436.107, 128.514, 450.891, 109.818, 451.923)
    ..cubicTo(108.495, 451.584, 94.7698, 448.087, 93.2593, 447.701)
    ..cubicTo(93.2593, 447.701, 83.2189, 440.254, 83.2189, 440.254)
    ..cubicTo(75.5751, 431.607, 64.3206, 418.477, 53.6887, 404.583)
    ..cubicTo(53.8276, 404.362, 53.8401, 404.069, 53.689, 403.833)
    ..cubicTo(53.5154, 403.562, 53.1897, 403.462, 52.895, 403.547)
    ..cubicTo(50.1966, 400.001, 47.5485, 396.411, 45.0144, 392.839)
    ..cubicTo(71.838, 373.927, 137.248, 329.492, 165.806, 310.597)
    ..cubicTo(166.131, 310.383, 166.221, 309.944, 166.005, 309.618)
    ..cubicTo(165.789, 309.293, 165.351, 309.201, 165.026, 309.418)
    ..cubicTo(136.46, 328.316, 71.0301, 372.77, 44.1979, 391.686)
    ..cubicTo(40.0029, 385.717, 36.1547, 379.817, 32.9852, 374.274)
    ..cubicTo(32.8877, 374.063, 12.5546, 329.274, 9.1047, 321.673)
    ..cubicTo(37.1627, 309.936, 63.6998, 298.393, 87.6885, 285.263)
    ..cubicTo(87.6885, 285.263, 87.6725, 285.234, 87.6725, 285.234)
    ..cubicTo(87.9739, 285.016, 88.534, 284.434, 89.943, 282.973)
    ..cubicTo(89.943, 282.973, 101.047, 271.458, 101.047, 271.458)
    ..cubicTo(101.056, 271.455, 101.065, 271.451, 101.074, 271.448)
    ..cubicTo(101.423, 271.276, 101.809, 270.512, 102.373, 268.294)
    ..cubicTo(102.373, 268.294, 141.102, 264.926, 141.102, 264.926)
    ..cubicTo(141.491, 264.893, 141.779, 264.551, 141.745, 264.161)
    ..cubicTo(141.711, 263.772, 141.368, 263.479, 140.98, 263.518)
    ..cubicTo(140.98, 263.518, 102.719, 266.847, 102.719, 266.847)
    ..cubicTo(103.814, 262.032, 105.515, 252.475, 108.543, 233.859)
    ..cubicTo(109.136, 230.216, 109.651, 227.051, 109.759, 226.58)
    ..cubicTo(110.22, 225.569, 116.8, 211.178, 117.565, 209.503)
    ..cubicTo(117.565, 209.503, 127.749, 201.631, 127.749, 201.631)
    ..cubicTo(130.707, 206.274, 133.77, 210.771, 136.617, 214.95)
    ..cubicTo(138.77, 218.111, 140.806, 221.101, 142.608, 223.869)
    ..cubicTo(142.608, 223.869, 141.33, 232.498, 141.33, 232.498)
    ..cubicTo(141.302, 232.687, 141.352, 232.88, 141.469, 233.03)
    ..cubicTo(141.585, 233.184, 141.759, 233.28, 141.95, 233.305)
    ..cubicTo(141.95, 233.305, 169.856, 236.463, 169.856, 236.463)
    ..cubicTo(170.155, 238.395, 170.315, 240.841, 170.566, 244.713)
    ..cubicTo(170.566, 244.713, 170.639, 245.824, 170.639, 245.824)
    ..cubicTo(170.641, 245.863, 170.648, 245.906, 170.657, 245.945)
    ..cubicTo(170.697, 246.11, 174.28, 261.093, 174.28, 261.093)
    ..cubicTo(174.291, 261.136, 174.305, 261.179, 174.324, 261.218)
    ..cubicTo(174.324, 261.218, 178.838, 271.215, 178.838, 271.215)
    ..cubicTo(178.838, 271.215, 178.231, 273.951, 178.231, 273.951)
    ..cubicTo(178.214, 274.023, 178.212, 274.098, 178.219, 274.173)
    ..cubicTo(168.995, 281.673, 159.443, 290.035, 154.066, 294.996)
    ..cubicTo(153.78, 295.26, 153.762, 295.707, 154.026, 295.996)
    ..cubicTo(154.166, 296.146, 154.355, 296.221, 154.546, 296.221)
    ..cubicTo(154.717, 296.221, 154.889, 296.16, 155.025, 296.035)
    ..cubicTo(160.331, 291.138, 169.713, 282.923, 178.809, 275.512)
    ..cubicTo(181.674, 281.52, 181.987, 282.088, 187.674, 287.149)
    ..cubicTo(187.674, 287.149, 187.697, 287.124, 187.697, 287.124)
    ..cubicTo(188.089, 287.338, 189.008, 287.581, 191.093, 288.127)
    ..cubicTo(191.093, 288.127, 194.222, 288.953, 194.222, 288.953)
    ..cubicTo(194.281, 288.967, 194.341, 288.974, 194.402, 288.974)
    ..cubicTo(194.478, 288.974, 194.553, 288.963, 194.626, 288.938)
    ..cubicTo(194.626, 288.938, 202.406, 286.345, 202.406, 286.345)
    ..cubicTo(202.406, 286.345, 207.743, 286.606, 207.743, 286.606)
    ..cubicTo(207.743, 286.606, 196.357, 326.945, 196.357, 326.945)
    ..cubicTo(196.341, 327.002, 196.332, 327.063, 196.331, 327.123)
    ..cubicTo(196.331, 327.123, 195.805, 357.344, 195.805, 357.344)
    ..cubicTo(172.683, 357.054, 150.631, 355.383, 136.952, 351.49)
    ..cubicTo(136.575, 351.383, 136.186, 351.6, 136.079, 351.975)
    ..cubicTo(135.972, 352.351, 136.189, 352.743, 136.565, 352.851)
    ..cubicTo(151.055, 356.976, 173.228, 358.572, 195.779, 358.815)
    ..cubicTo(195.779, 358.815, 195.013, 402.883, 195.013, 402.883)
    ..cubicTo(195.006, 403.276, 195.317, 403.597, 195.707, 403.601)
    ..cubicTo(195.712, 403.601, 195.716, 403.601, 195.72, 403.601)
    ..cubicTo(196.104, 403.601, 196.419, 403.294, 196.427, 402.908)
    ..cubicTo(196.427, 402.908, 197.193, 358.83, 197.193, 358.83)
    ..cubicTo(198.813, 358.844, 200.438, 358.851, 202.06, 358.851)
    ..cubicTo(212.754, 358.851, 223.38, 358.569, 233.162, 358.13)
    ..cubicTo(232.927, 360.783, 232.973, 362.473, 233.352, 363.123)
    ..cubicTo(237.491, 368.93, 243.124, 376.545, 249.65, 385.36)
    ..cubicTo(254.757, 392.264, 260.425, 399.929, 266.369, 408.066)
    ..cubicTo(255.396, 409.659, 244.267, 411.034, 233.28, 412.387)
    ..cubicTo(221.929, 413.788, 211.204, 415.109, 200.921, 416.638)
    ..cubicTo(200.921, 416.638, 195.575, 410.977, 195.575, 410.977)
    ..cubicTo(195.306, 410.691, 194.858, 410.68, 194.576, 410.948)
    ..cubicTo(194.291, 411.216, 194.279, 411.662, 194.547, 411.945)
    ..cubicTo(194.547, 411.945, 200.146, 417.874, 200.146, 417.874)
    ..cubicTo(200.281, 418.017, 200.467, 418.095, 200.66, 418.095)
    ..cubicTo(200.696, 418.095, 200.731, 418.095, 200.763, 418.088)
    ..cubicTo(205.11, 417.441, 209.543, 416.831, 214.064, 416.234)
    ..cubicTo(214.064, 416.234, 202.914, 423.381, 202.914, 423.381)
    ..cubicTo(202.585, 423.592, 202.492, 424.031, 202.699, 424.36)
    ..cubicTo(202.835, 424.571, 203.064, 424.685, 203.296, 424.685)
    ..cubicTo(203.428, 424.685, 203.56, 424.649, 203.678, 424.571)
    ..cubicTo(203.678, 424.571, 216.525, 416.338, 216.525, 416.338)
    ..cubicTo(216.693, 416.227, 216.797, 416.056, 216.833, 415.874)
    ..cubicTo(222.229, 415.173, 227.762, 414.491, 233.452, 413.791)
    ..cubicTo(244.692, 412.405, 256.086, 410.995, 267.312, 409.355)
    ..cubicTo(293.539, 445.308, 324.738, 490.076, 336.557, 519.457)
    ..cubicTo(336.557, 519.457, 336.442, 519.5, 336.442, 519.5)
    ..cubicTo(336.078, 519.643, 335.899, 520.053, 336.042, 520.418)
    ..cubicTo(336.149, 520.696, 336.417, 520.868, 336.699, 520.868)
    ..cubicTo(336.785, 520.868, 336.871, 520.85, 336.957, 520.818)
    ..cubicTo(336.957, 520.818, 337.074, 520.771, 337.074, 520.771)
    ..cubicTo(338.682, 524.914, 339.892, 528.74, 340.618, 532.165)
    ..cubicTo(340.643, 532.286, 340.7, 532.394, 340.778, 532.483)
    ..cubicTo(340.943, 532.676, 346.372, 539.062, 346.372, 539.062)
    ..cubicTo(346.443, 539.148, 346.536, 539.216, 346.639, 539.258)
    ..cubicTo(355.137, 542.787, 372.688, 550.631, 381.032, 554.97)
    ..cubicTo(381.032, 554.97, 387.764, 563.625, 387.764, 563.625)
    ..cubicTo(387.764, 563.625, 390.675, 575.265, 390.675, 575.265)
    ..cubicTo(390.675, 575.265, 390.982, 584.559, 390.982, 584.559)
    ..cubicTo(385.396, 586.477, 379.874, 588.037, 374.52, 588.955)
    ..cubicTo(359.891, 588.87, 325.859, 589.123, 307.976, 589.288)
    ..cubicTo(297.157, 590.284, 274.044, 597.517, 262.018, 601.842)
    ..cubicTo(261.986, 601.853, 261.954, 601.867, 261.922, 601.885)
    ..cubicTo(261.922, 601.885, 234.409, 616.615, 234.409, 616.615)
    ..cubicTo(231.294, 618.283, 229.973, 618.99, 229.401, 619.358)
    ..cubicTo(229.401, 619.358, 229.384, 619.311, 229.384, 619.311)
    ..cubicTo(215.65, 624.855, 187.718, 638.013, 173.63, 646.031)
    ..cubicTo(173.564, 646.071, 173.504, 646.117, 173.453, 646.174)
    ..cubicTo(173.453, 646.174, 162.582, 658.361, 162.582, 658.361)
    ..cubicTo(162.487, 658.468, 162.426, 658.604, 162.409, 658.747)
    ..cubicTo(162.409, 658.747, 160.432, 674.555, 160.432, 674.555)
    ..cubicTo(160.384, 674.944, 160.659, 675.298, 161.046, 675.344)
    ..cubicTo(161.076, 675.348, 161.105, 675.352, 161.135, 675.352)
    ..cubicTo(161.486, 675.352, 161.79, 675.091, 161.835, 674.73)
    ..cubicTo(161.835, 674.73, 163.784, 659.14, 163.784, 659.14)
    ..cubicTo(163.784, 659.14, 174.43, 647.203, 174.43, 647.203)
    ..cubicTo(188.505, 639.202, 216.25, 626.137, 229.912, 620.622)
    ..cubicTo(229.937, 620.611, 229.962, 620.601, 229.984, 620.586)
    ..cubicTo(230.198, 620.472, 261.154, 603.899, 262.543, 603.153)
    ..cubicTo(274.519, 598.853, 297.432, 591.681, 308.047, 590.698)
    ..cubicTo(325.895, 590.534, 359.994, 590.284, 374.574, 590.37)
    ..cubicTo(374.62, 590.37, 374.656, 590.366, 374.699, 590.359)
    ..cubicTo(379.881, 589.473, 385.203, 588.002, 390.582, 586.191)
    ..cubicTo(390.582, 586.191, 389.389, 589.766, 389.389, 589.766)
    ..cubicTo(389.268, 590.138, 389.468, 590.538, 389.836, 590.663)
    ..cubicTo(389.911, 590.688, 389.986, 590.698, 390.061, 590.698)
    ..cubicTo(390.357, 590.698, 390.632, 590.509, 390.732, 590.213)
    ..cubicTo(390.732, 590.213, 392.265, 585.612, 392.265, 585.612)
    ..cubicTo(400.208, 582.841, 408.255, 579.38, 416.152, 575.979)
    ..cubicTo(427.996, 570.879, 440.229, 565.618, 451.591, 562.96)
    ..cubicTo(451.591, 562.96, 451.28, 580.426, 451.28, 580.426)
    ..cubicTo(451.277, 580.555, 451.312, 580.683, 451.376, 580.798)
    ..cubicTo(451.376, 580.798, 458.884, 593.531, 458.884, 593.531)
    ..cubicTo(458.884, 593.531, 459.524, 597.352, 459.524, 597.352)
    ..cubicTo(459.581, 597.699, 459.881, 597.945, 460.22, 597.945)
    ..cubicTo(460.259, 597.945, 460.299, 597.942, 460.338, 597.935)
    ..cubicTo(460.72, 597.87, 460.981, 597.506, 460.917, 597.12)
    ..cubicTo(460.917, 597.12, 460.259, 593.17, 460.259, 593.17)
    ..cubicTo(460.245, 593.081, 460.213, 592.999, 460.17, 592.927)
    ..cubicTo(460.17, 592.927, 452.694, 580.251, 452.694, 580.251)
    ..cubicTo(452.694, 580.251, 453.009, 562.689, 453.009, 562.689)
    ..cubicTo(453.009, 562.689, 464.435, 562.371, 464.435, 562.371)
    ..cubicTo(464.435, 562.371, 481.804, 566.307, 481.804, 566.307)
    ..cubicTo(482.183, 566.389, 482.565, 566.153, 482.65, 565.771)
    ..cubicTo(482.736, 565.393, 482.497, 565.014, 482.115, 564.925)
    ..cubicTo(482.115, 564.925, 482.115, 564.925, 482.115, 564.925)
    ..close();

  static final Path __path47_1_25 = Path()
    ..moveTo(12.4695, 167.706)
    ..cubicTo(12.4695, 167.706, 4.8936, 170.342, 4.8936, 170.342)
    ..cubicTo(4.7093, 170.406, 4.6117, 170.606, 4.676, 170.792)
    ..cubicTo(4.7267, 170.934, 4.8632, 171.027, 5.0096, 171.027)
    ..cubicTo(5.0482, 171.027, 5.0875, 171.02, 5.1257, 171.009)
    ..cubicTo(5.1257, 171.009, 12.6506, 168.391, 12.6506, 168.391)
    ..cubicTo(12.6506, 168.391, 34.3359, 167.734, 34.3359, 167.734)
    ..cubicTo(34.531, 167.727, 34.6845, 167.566, 34.6788, 167.37)
    ..cubicTo(34.6731, 167.173, 34.507, 167.038, 34.3149, 167.027)
    ..cubicTo(34.3149, 167.027, 12.5749, 167.684, 12.5749, 167.684)
    ..cubicTo(12.5392, 167.688, 12.5035, 167.695, 12.4695, 167.706)
    ..cubicTo(12.4695, 167.706, 12.4695, 167.706, 12.4695, 167.706)
    ..close();

  static final Path __path47_1_26 = Path()
    ..moveTo(36.9666, 207.083)
    ..cubicTo(36.9666, 207.083, 40.4708, 204.215, 40.4708, 204.215)
    ..cubicTo(40.6223, 204.093, 40.6448, 203.868, 40.5208, 203.718)
    ..cubicTo(40.3965, 203.568, 40.1744, 203.543, 40.0237, 203.668)
    ..cubicTo(40.0237, 203.668, 36.4005, 206.633, 36.4005, 206.633)
    ..cubicTo(36.3248, 206.693, 36.278, 206.786, 36.2716, 206.883)
    ..cubicTo(36.2716, 206.883, 35.9515, 211.676, 35.9515, 211.676)
    ..cubicTo(35.9515, 211.676, 11.0524, 202.622, 11.0524, 202.622)
    ..cubicTo(10.8684, 202.554, 10.6663, 202.65, 10.5995, 202.832)
    ..cubicTo(10.5327, 203.014, 10.6277, 203.218, 10.8109, 203.286)
    ..cubicTo(10.8109, 203.286, 35.7151, 212.34, 35.7151, 212.34)
    ..cubicTo(35.7151, 212.34, 32.3934, 216.569, 32.3934, 216.569)
    ..cubicTo(32.273, 216.723, 32.2998, 216.944, 32.4531, 217.066)
    ..cubicTo(32.5181, 217.116, 32.5948, 217.141, 32.6713, 217.141)
    ..cubicTo(32.7759, 217.141, 32.8795, 217.094, 32.9495, 217.005)
    ..cubicTo(32.9495, 217.005, 36.5723, 212.394, 36.5723, 212.394)
    ..cubicTo(36.6423, 212.305, 36.6655, 212.187, 36.6345, 212.079)
    ..cubicTo(36.628, 212.058, 36.6109, 212.04, 36.5998, 212.019)
    ..cubicTo(36.6252, 211.972, 36.6437, 211.926, 36.6473, 211.869)
    ..cubicTo(36.6473, 211.869, 36.9666, 207.083, 36.9666, 207.083)
    ..cubicTo(36.9666, 207.083, 36.9666, 207.083, 36.9666, 207.083)
    ..close();

  static final Path __path47_1_27 = Path()
    ..moveTo(195.404, 332.76)
    ..cubicTo(195.599, 332.749, 195.747, 332.581, 195.735, 332.385)
    ..cubicTo(195.722, 332.188, 195.556, 332.038, 195.36, 332.053)
    ..cubicTo(195.36, 332.053, 179.549, 333.042, 179.549, 333.042)
    ..cubicTo(179.515, 333.046, 179.481, 333.053, 179.449, 333.064)
    ..cubicTo(179.249, 333.139, 159.98, 340.282, 157.585, 340.914)
    ..cubicTo(157.585, 340.914, 157.501, 340.511, 157.501, 340.511)
    ..cubicTo(157.501, 340.511, 149.596, 320.748, 149.596, 320.748)
    ..cubicTo(149.523, 320.566, 149.316, 320.477, 149.137, 320.552)
    ..cubicTo(148.955, 320.623, 148.867, 320.827, 148.939, 321.009)
    ..cubicTo(148.939, 321.009, 156.827, 340.714, 156.827, 340.714)
    ..cubicTo(156.827, 340.714, 160.121, 356.526, 160.121, 356.526)
    ..cubicTo(160.155, 356.69, 160.302, 356.805, 160.466, 356.805)
    ..cubicTo(160.49, 356.805, 160.514, 356.805, 160.539, 356.798)
    ..cubicTo(160.73, 356.758, 160.853, 356.573, 160.813, 356.38)
    ..cubicTo(160.813, 356.38, 157.73, 341.607, 157.73, 341.607)
    ..cubicTo(160.13, 340.978, 178.319, 334.235, 179.645, 333.746)
    ..cubicTo(179.645, 333.746, 195.404, 332.76, 195.404, 332.76)
    ..cubicTo(195.404, 332.76, 195.404, 332.76, 195.404, 332.76)
    ..close();

  static final Path __path47_1_28 = Path()
    ..moveTo(194.408, 286.597)
    ..cubicTo(194.213, 286.597, 194.055, 286.754, 194.055, 286.947)
    ..cubicTo(194.055, 286.947, 194.055, 295.49, 194.055, 295.49)
    ..cubicTo(194.055, 295.49, 190.291, 295.49, 190.291, 295.49)
    ..cubicTo(187.549, 295.49, 186.489, 295.49, 186.079, 295.569)
    ..cubicTo(186.079, 295.569, 186.057, 295.508, 186.057, 295.508)
    ..cubicTo(181.485, 297.105, 172.369, 304.127, 165.528, 309.731)
    ..cubicTo(165.377, 309.856, 165.355, 310.077, 165.478, 310.231)
    ..cubicTo(165.548, 310.317, 165.65, 310.359, 165.752, 310.359)
    ..cubicTo(165.831, 310.359, 165.91, 310.334, 165.976, 310.281)
    ..cubicTo(175.672, 302.334, 182.675, 297.465, 186.235, 296.198)
    ..cubicTo(186.975, 296.194, 194.408, 296.194, 194.408, 296.194)
    ..cubicTo(194.604, 296.194, 194.762, 296.037, 194.762, 295.84)
    ..cubicTo(194.762, 295.84, 194.762, 286.947, 194.762, 286.947)
    ..cubicTo(194.762, 286.754, 194.604, 286.597, 194.408, 286.597)
    ..cubicTo(194.408, 286.597, 194.408, 286.597, 194.408, 286.597)
    ..close();

  static final Path __path47_1_29 = Path()
    ..moveTo(114.076, 276.721)
    ..cubicTo(114.058, 276.721, 114.043, 276.728, 114.027, 276.728)
    ..cubicTo(114.027, 276.728, 115.055, 266.238, 115.055, 266.238)
    ..cubicTo(115.074, 266.045, 114.932, 265.87, 114.738, 265.853)
    ..cubicTo(114.539, 265.838, 114.371, 265.978, 114.352, 266.17)
    ..cubicTo(114.352, 266.17, 112.705, 282.968, 112.705, 282.968)
    ..cubicTo(112.699, 283.025, 112.708, 283.086, 112.731, 283.14)
    ..cubicTo(112.731, 283.14, 116.024, 291.044, 116.024, 291.044)
    ..cubicTo(116.081, 291.18, 116.212, 291.262, 116.35, 291.262)
    ..cubicTo(116.396, 291.262, 116.442, 291.255, 116.487, 291.233)
    ..cubicTo(116.667, 291.162, 116.752, 290.955, 116.677, 290.772)
    ..cubicTo(116.677, 290.772, 113.417, 282.95, 113.417, 282.95)
    ..cubicTo(113.417, 282.95, 113.96, 277.411, 113.96, 277.411)
    ..cubicTo(113.978, 277.414, 113.995, 277.425, 114.014, 277.428)
    ..cubicTo(114.014, 277.428, 125.213, 278.414, 125.213, 278.414)
    ..cubicTo(125.223, 278.414, 125.234, 278.414, 125.244, 278.414)
    ..cubicTo(125.262, 278.414, 125.279, 278.414, 125.296, 278.411)
    ..cubicTo(125.296, 278.411, 134.075, 277.111, 134.186, 277.096)
    ..cubicTo(134.21, 277.093, 134.234, 277.086, 134.257, 277.078)
    ..cubicTo(140.798, 274.735, 156.78, 269.242, 168.39, 266.017)
    ..cubicTo(169.665, 270.521, 171.008, 274.989, 172.01, 278.168)
    ..cubicTo(172.057, 278.321, 172.197, 278.414, 172.347, 278.414)
    ..cubicTo(172.382, 278.414, 172.418, 278.411, 172.454, 278.4)
    ..cubicTo(172.639, 278.339, 172.743, 278.143, 172.684, 277.957)
    ..cubicTo(171.684, 274.782, 170.343, 270.324, 169.071, 265.828)
    ..cubicTo(172.146, 264.985, 174.889, 264.31, 177.023, 263.917)
    ..cubicTo(177.215, 263.881, 177.342, 263.695, 177.306, 263.506)
    ..cubicTo(177.271, 263.313, 177.089, 263.184, 176.895, 263.22)
    ..cubicTo(174.743, 263.62, 171.978, 264.299, 168.879, 265.149)
    ..cubicTo(167.381, 259.816, 166.01, 254.519, 165.45, 251.33)
    ..cubicTo(165.434, 251.223, 163.145, 235.193, 163.145, 235.193)
    ..cubicTo(163.145, 235.193, 162.445, 235.293, 162.445, 235.293)
    ..cubicTo(162.445, 235.293, 164.39, 248.908, 164.39, 248.908)
    ..cubicTo(164.603, 250.398, 164.704, 251.101, 164.796, 251.433)
    ..cubicTo(164.796, 251.433, 164.753, 251.444, 164.753, 251.444)
    ..cubicTo(165.317, 254.659, 166.694, 259.984, 168.198, 265.335)
    ..cubicTo(156.556, 268.571, 140.565, 274.067, 134.019, 276.414)
    ..cubicTo(134.019, 276.414, 134.03, 276.446, 134.03, 276.446)
    ..cubicTo(133.405, 276.496, 131.493, 276.778, 125.234, 277.707)
    ..cubicTo(125.234, 277.707, 114.076, 276.721, 114.076, 276.721)
    ..cubicTo(114.076, 276.721, 114.076, 276.721, 114.076, 276.721)
    ..close();

  static final Path __path47_1_30 = Path()
    ..moveTo(107.54, 239.174)
    ..cubicTo(107.351, 239.124, 107.159, 239.238, 107.112, 239.428)
    ..cubicTo(107.065, 239.617, 107.18, 239.81, 107.369, 239.856)
    ..cubicTo(107.369, 239.856, 125.195, 244.314, 125.195, 244.314)
    ..cubicTo(124.571, 252.532, 123.496, 261.322, 122.916, 265.487)
    ..cubicTo(122.889, 265.68, 123.024, 265.858, 123.217, 265.887)
    ..cubicTo(123.234, 265.891, 123.25, 265.891, 123.266, 265.891)
    ..cubicTo(123.44, 265.891, 123.591, 265.762, 123.616, 265.587)
    ..cubicTo(124.194, 261.43, 125.263, 252.693, 125.891, 244.478)
    ..cubicTo(125.894, 244.478, 125.898, 244.482, 125.901, 244.482)
    ..cubicTo(126.059, 244.482, 126.203, 244.375, 126.244, 244.214)
    ..cubicTo(126.291, 244.025, 126.176, 243.832, 125.987, 243.785)
    ..cubicTo(125.987, 243.785, 125.943, 243.775, 125.943, 243.775)
    ..cubicTo(126.339, 238.381, 126.532, 233.277, 126.253, 229.934)
    ..cubicTo(126.237, 229.738, 126.067, 229.591, 125.872, 229.613)
    ..cubicTo(125.677, 229.627, 125.532, 229.798, 125.549, 229.991)
    ..cubicTo(125.823, 233.277, 125.636, 238.288, 125.248, 243.6)
    ..cubicTo(125.248, 243.6, 107.54, 239.174, 107.54, 239.174)
    ..cubicTo(107.54, 239.174, 107.54, 239.174, 107.54, 239.174)
    ..close();

  static final Path __path47_1_31 = Path()
    ..moveTo(197.704, 261.61)
    ..cubicTo(197.762, 261.61, 197.822, 261.596, 197.876, 261.567)
    ..cubicTo(197.876, 261.567, 208.252, 255.835, 208.252, 255.835)
    ..cubicTo(208.252, 255.835, 210.195, 264.896, 210.195, 264.896)
    ..cubicTo(210.195, 264.896, 209.541, 270.107, 209.541, 270.107)
    ..cubicTo(209.52, 270.3, 209.655, 270.479, 209.848, 270.5)
    ..cubicTo(209.863, 270.504, 209.877, 270.504, 209.895, 270.504)
    ..cubicTo(210.07, 270.504, 210.22, 270.372, 210.245, 270.193)
    ..cubicTo(210.245, 270.193, 210.902, 264.925, 210.902, 264.925)
    ..cubicTo(210.906, 264.886, 210.906, 264.846, 210.898, 264.807)
    ..cubicTo(210.898, 264.807, 208.92, 255.585, 208.92, 255.585)
    ..cubicTo(208.913, 255.549, 208.898, 255.521, 208.88, 255.488)
    ..cubicTo(208.88, 255.488, 218.831, 249.995, 218.831, 249.995)
    ..cubicTo(218.831, 249.995, 221.706, 258.949, 221.706, 258.949)
    ..cubicTo(221.706, 258.949, 218.12, 269.711, 218.12, 269.711)
    ..cubicTo(218.06, 269.897, 218.16, 270.097, 218.345, 270.157)
    ..cubicTo(218.381, 270.168, 218.42, 270.175, 218.456, 270.175)
    ..cubicTo(218.606, 270.175, 218.742, 270.082, 218.792, 269.932)
    ..cubicTo(218.792, 269.932, 222.417, 259.064, 222.417, 259.064)
    ..cubicTo(222.439, 258.992, 222.439, 258.914, 222.417, 258.842)
    ..cubicTo(222.417, 258.842, 219.46, 249.649, 219.46, 249.649)
    ..cubicTo(219.46, 249.649, 219.892, 249.409, 219.892, 249.409)
    ..cubicTo(226.121, 248.445, 235.258, 247.381, 244.523, 246.691)
    ..cubicTo(244.826, 248.738, 245.133, 250.688, 245.44, 252.388)
    ..cubicTo(245.44, 252.388, 245.112, 260.585, 245.112, 260.585)
    ..cubicTo(245.105, 260.778, 245.258, 260.942, 245.455, 260.953)
    ..cubicTo(245.458, 260.953, 245.462, 260.953, 245.465, 260.953)
    ..cubicTo(245.655, 260.953, 245.812, 260.803, 245.819, 260.614)
    ..cubicTo(245.819, 260.614, 246.151, 252.377, 246.151, 252.377)
    ..cubicTo(246.151, 252.352, 246.148, 252.327, 246.144, 252.299)
    ..cubicTo(245.841, 250.613, 245.53, 248.674, 245.23, 246.638)
    ..cubicTo(253.634, 246.027, 262.088, 245.734, 268.517, 246.109)
    ..cubicTo(268.517, 246.109, 269.16, 257.324, 269.16, 257.324)
    ..cubicTo(269.171, 257.521, 269.328, 257.674, 269.532, 257.656)
    ..cubicTo(269.728, 257.646, 269.875, 257.478, 269.864, 257.285)
    ..cubicTo(269.864, 257.285, 269.21, 245.852, 269.21, 245.852)
    ..cubicTo(269.21, 245.852, 270.489, 243.298, 270.489, 243.298)
    ..cubicTo(270.535, 243.198, 270.535, 243.084, 270.489, 242.984)
    ..cubicTo(270.489, 242.984, 267.853, 237.712, 267.853, 237.712)
    ..cubicTo(267.832, 237.673, 267.807, 237.637, 267.771, 237.608)
    ..cubicTo(267.771, 237.608, 264.478, 234.644, 264.478, 234.644)
    ..cubicTo(264.417, 234.59, 264.342, 234.558, 264.26, 234.555)
    ..cubicTo(264.021, 234.54, 258.313, 234.222, 257.324, 234.222)
    ..cubicTo(257.131, 234.222, 256.97, 234.383, 256.97, 234.576)
    ..cubicTo(256.97, 234.772, 257.131, 234.93, 257.324, 234.93)
    ..cubicTo(258.213, 234.93, 263.238, 235.205, 264.099, 235.251)
    ..cubicTo(264.099, 235.251, 267.249, 238.087, 267.249, 238.087)
    ..cubicTo(267.249, 238.087, 269.778, 243.141, 269.778, 243.141)
    ..cubicTo(269.778, 243.141, 268.642, 245.409, 268.642, 245.409)
    ..cubicTo(262.16, 245.027, 253.616, 245.32, 245.126, 245.938)
    ..cubicTo(244.715, 243.137, 244.315, 240.184, 243.94, 237.426)
    ..cubicTo(243.88, 236.98, 243.822, 236.544, 243.762, 236.112)
    ..cubicTo(243.812, 236.051, 243.844, 235.976, 243.844, 235.894)
    ..cubicTo(243.844, 235.776, 243.783, 235.68, 243.697, 235.615)
    ..cubicTo(243.519, 234.297, 243.344, 233.04, 243.183, 231.89)
    ..cubicTo(243.155, 231.697, 242.969, 231.561, 242.783, 231.59)
    ..cubicTo(242.59, 231.619, 242.455, 231.797, 242.483, 231.99)
    ..cubicTo(242.637, 233.087, 242.801, 234.287, 242.972, 235.54)
    ..cubicTo(242.972, 235.54, 228.721, 235.54, 228.721, 235.54)
    ..cubicTo(228.721, 235.54, 215.27, 231.276, 215.27, 231.276)
    ..cubicTo(215.177, 231.247, 215.077, 231.258, 214.992, 231.304)
    ..cubicTo(214.906, 231.351, 214.845, 231.429, 214.82, 231.522)
    ..cubicTo(214.82, 231.522, 212.513, 240.416, 212.513, 240.416)
    ..cubicTo(212.499, 240.484, 212.499, 240.555, 212.524, 240.623)
    ..cubicTo(212.545, 240.687, 214.824, 247.206, 215.145, 249.127)
    ..cubicTo(215.174, 249.302, 215.324, 249.424, 215.492, 249.424)
    ..cubicTo(215.509, 249.424, 215.531, 249.424, 215.549, 249.42)
    ..cubicTo(215.742, 249.388, 215.874, 249.206, 215.842, 249.013)
    ..cubicTo(215.527, 247.141, 213.531, 241.362, 213.227, 240.491)
    ..cubicTo(213.227, 240.491, 215.413, 232.061, 215.413, 232.061)
    ..cubicTo(215.413, 232.061, 228.561, 236.23, 228.561, 236.23)
    ..cubicTo(228.596, 236.24, 228.632, 236.248, 228.668, 236.248)
    ..cubicTo(228.668, 236.248, 243.069, 236.248, 243.069, 236.248)
    ..cubicTo(243.126, 236.669, 243.183, 237.09, 243.24, 237.519)
    ..cubicTo(243.612, 240.262, 244.012, 243.202, 244.419, 245.991)
    ..cubicTo(235.115, 246.684, 225.953, 247.752, 219.721, 248.72)
    ..cubicTo(219.678, 248.727, 219.638, 248.741, 219.603, 248.759)
    ..cubicTo(219.603, 248.759, 197.533, 260.95, 197.533, 260.95)
    ..cubicTo(197.363, 261.042, 197.301, 261.257, 197.396, 261.428)
    ..cubicTo(197.46, 261.546, 197.579, 261.61, 197.704, 261.61)
    ..cubicTo(197.704, 261.61, 197.704, 261.61, 197.704, 261.61)
    ..close();

  static final Path __path47_1_32 = Path()
    ..moveTo(267.832, 269.885)
    ..cubicTo(267.832, 269.885, 269.132, 277.349, 269.132, 277.349)
    ..cubicTo(269.132, 277.349, 264.592, 287.079, 264.592, 287.079)
    ..cubicTo(264.592, 287.079, 258.041, 293.954, 258.041, 293.954)
    ..cubicTo(257.909, 294.097, 257.913, 294.319, 258.056, 294.454)
    ..cubicTo(258.124, 294.519, 258.213, 294.551, 258.299, 294.551)
    ..cubicTo(258.391, 294.551, 258.484, 294.515, 258.556, 294.444)
    ..cubicTo(258.556, 294.444, 265.142, 287.525, 265.142, 287.525)
    ..cubicTo(265.171, 287.497, 265.192, 287.465, 265.206, 287.432)
    ..cubicTo(265.206, 287.432, 269.817, 277.549, 269.817, 277.549)
    ..cubicTo(269.85, 277.485, 269.857, 277.41, 269.846, 277.339)
    ..cubicTo(269.846, 277.339, 268.792, 271.267, 268.792, 271.267)
    ..cubicTo(268.792, 271.267, 275.443, 273.292, 275.443, 273.292)
    ..cubicTo(275.414, 273.349, 275.4, 273.41, 275.404, 273.478)
    ..cubicTo(275.404, 273.478, 276.064, 281.382, 276.064, 281.382)
    ..cubicTo(276.068, 281.421, 276.075, 281.46, 276.093, 281.496)
    ..cubicTo(276.093, 281.496, 278.729, 287.425, 278.729, 287.425)
    ..cubicTo(278.757, 287.497, 278.815, 287.554, 278.882, 287.593)
    ..cubicTo(278.882, 287.593, 283.165, 289.897, 283.165, 289.897)
    ..cubicTo(283.218, 289.925, 283.276, 289.94, 283.333, 289.94)
    ..cubicTo(283.458, 289.94, 283.579, 289.872, 283.643, 289.754)
    ..cubicTo(283.736, 289.583, 283.672, 289.368, 283.501, 289.275)
    ..cubicTo(283.501, 289.275, 279.325, 287.029, 279.325, 287.029)
    ..cubicTo(279.325, 287.029, 276.764, 281.264, 276.764, 281.264)
    ..cubicTo(276.764, 281.264, 276.129, 273.642, 276.129, 273.642)
    ..cubicTo(276.129, 273.642, 282.851, 269.802, 282.851, 269.802)
    ..cubicTo(283.018, 269.706, 283.079, 269.488, 282.983, 269.32)
    ..cubicTo(282.883, 269.149, 282.665, 269.092, 282.497, 269.188)
    ..cubicTo(282.497, 269.188, 276.2, 272.785, 276.2, 272.785)
    ..cubicTo(276.196, 272.785, 276.193, 272.781, 276.189, 272.781)
    ..cubicTo(276.189, 272.781, 268.657, 270.485, 268.657, 270.485)
    ..cubicTo(268.657, 270.485, 268.56, 269.935, 268.56, 269.935)
    ..cubicTo(268.56, 269.935, 271.968, 266.213, 271.968, 266.213)
    ..cubicTo(271.968, 266.213, 281.708, 265.566, 281.708, 265.566)
    ..cubicTo(281.904, 265.552, 282.051, 265.384, 282.04, 265.188)
    ..cubicTo(282.025, 264.995, 281.858, 264.852, 281.661, 264.859)
    ..cubicTo(281.661, 264.859, 271.782, 265.52, 271.782, 265.52)
    ..cubicTo(271.689, 265.523, 271.603, 265.566, 271.542, 265.631)
    ..cubicTo(271.542, 265.631, 267.921, 269.584, 267.921, 269.584)
    ..cubicTo(267.846, 269.667, 267.814, 269.777, 267.832, 269.885)
    ..cubicTo(267.832, 269.885, 267.832, 269.885, 267.832, 269.885)
    ..close();

  static final Path __path47_1_33 = Path()
    ..moveTo(182.735, 206.584)
    ..cubicTo(182.735, 206.584, 168.242, 213.174, 168.242, 213.174)
    ..cubicTo(168.177, 213.203, 168.122, 213.253, 168.085, 213.313)
    ..cubicTo(168.085, 213.313, 163.144, 221.55, 163.144, 221.55)
    ..cubicTo(163.044, 221.714, 163.098, 221.932, 163.265, 222.032)
    ..cubicTo(163.322, 222.068, 163.385, 222.082, 163.447, 222.082)
    ..cubicTo(163.567, 222.082, 163.684, 222.021, 163.75, 221.911)
    ..cubicTo(163.75, 221.911, 168.634, 213.771, 168.634, 213.771)
    ..cubicTo(168.634, 213.771, 183.028, 207.231, 183.028, 207.231)
    ..cubicTo(183.205, 207.149, 183.283, 206.938, 183.203, 206.763)
    ..cubicTo(183.123, 206.584, 182.915, 206.502, 182.735, 206.584)
    ..cubicTo(182.735, 206.584, 182.735, 206.584, 182.735, 206.584)
    ..close();

  static final Path __path47_2_0 = Path()
    ..moveTo(242.258, 226.34)
    ..cubicTo(242.258, 226.34, 242.504, 218.432, 242.504, 218.432)
    ..cubicTo(242.504, 218.432, 254.116, 215.718, 254.116, 215.718)
    ..cubicTo(254.116, 215.718, 256.341, 212.503, 256.341, 212.503)
    ..cubicTo(256.341, 212.503, 255.598, 208.799, 255.598, 208.799)
    ..cubicTo(255.598, 208.799, 261.774, 208.306, 261.774, 208.306)
    ..cubicTo(261.774, 208.306, 263.256, 213.985, 263.256, 213.985)
    ..cubicTo(263.256, 213.985, 257.577, 223.129, 257.577, 223.129)
    ..cubicTo(257.577, 223.129, 247.694, 221.893, 247.694, 221.893)
    ..cubicTo(247.694, 221.893, 242.258, 226.34, 242.258, 226.34)
    ..close();

  static final Path __path47_3_0 = Path()
    ..moveTo(136.031, 164.341)
    ..cubicTo(136.031, 164.341, 142.949, 157.919, 142.949, 157.919)
    ..cubicTo(142.949, 157.919, 142.949, 166.316, 142.949, 166.316)
    ..cubicTo(142.949, 166.316, 152.83, 169.777, 152.83, 169.777)
    ..cubicTo(152.83, 169.777, 155.795, 174.47, 155.795, 174.47)
    ..cubicTo(155.795, 174.47, 153.571, 177.928, 153.571, 177.928)
    ..cubicTo(153.571, 177.928, 156.536, 182.128, 156.536, 182.128)
    ..cubicTo(156.536, 182.128, 165.183, 178.67, 165.183, 178.67)
    ..cubicTo(165.183, 178.67, 167.159, 186.575, 167.159, 186.575)
    ..cubicTo(167.159, 186.575, 172.347, 198.926, 172.347, 198.926)
    ..cubicTo(172.347, 198.926, 180.499, 215.727, 180.499, 215.727)
    ..cubicTo(180.499, 215.727, 184.946, 224.124, 184.946, 224.124)
    ..cubicTo(184.946, 224.124, 193.345, 230.3, 193.345, 230.3)
    ..cubicTo(193.345, 230.3, 191.863, 237.961, 191.863, 237.961)
    ..cubicTo(191.863, 237.961, 171.606, 235.243, 171.606, 235.243)
    ..cubicTo(171.606, 235.243, 165.183, 222.888, 165.183, 222.888)
    ..cubicTo(165.183, 222.888, 165.677, 216.22, 165.677, 216.22)
    ..cubicTo(165.677, 216.22, 162.218, 213.009, 162.218, 213.009)
    ..cubicTo(162.218, 213.009, 159.253, 210.537, 159.253, 210.537)
    ..cubicTo(159.253, 210.537, 158.512, 207.08, 158.512, 207.08)
    ..cubicTo(158.512, 207.08, 160.983, 196.208, 160.983, 196.208)
    ..cubicTo(160.983, 196.208, 151.842, 190.279, 151.842, 190.279)
    ..cubicTo(151.842, 190.279, 141.466, 189.539, 141.466, 189.539)
    ..cubicTo(141.466, 189.539, 136.031, 172.741, 136.031, 171.752)
    ..cubicTo(136.031, 170.763, 136.031, 164.341, 136.031, 164.341)
    ..cubicTo(136.031, 164.341, 136.031, 164.341, 136.031, 164.341)
    ..close();

  static final Path __path47_4_0 = Path()
    ..moveTo(205.937, 0.3751)
    ..cubicTo(205.937, 0.3751, 200.337, 9.6009, 200.337, 9.6009)
    ..cubicTo(200.337, 9.6009, 202.973, 13.2226, 202.973, 13.2226)
    ..cubicTo(202.973, 13.2226, 219.77, 15.1978, 219.77, 15.1978)
    ..cubicTo(219.77, 15.1978, 219.442, 31.3384, 219.442, 31.3384)
    ..cubicTo(219.442, 31.3384, 210.22, 50.7721, 210.22, 50.7721)
    ..cubicTo(210.22, 50.7721, 205.609, 54.0688, 205.609, 54.0688)
    ..cubicTo(205.609, 54.0688, 202.973, 59.3371, 202.973, 59.3371)
    ..cubicTo(202.973, 59.3371, 197.701, 58.3476, 197.701, 58.3476)
    ..cubicTo(197.701, 58.3476, 190.784, 66.584, 190.784, 66.584)
    ..cubicTo(190.784, 66.584, 190.784, 80.7459, 190.784, 80.7459)
    ..cubicTo(190.784, 80.7459, 194.078, 81.4066, 194.078, 81.4066)
    ..cubicTo(194.078, 81.4066, 196.713, 83.714, 196.713, 83.714)
    ..cubicTo(196.713, 83.714, 195.066, 86.0178, 195.066, 86.0178)
    ..cubicTo(195.066, 86.0178, 203.301, 91.2896, 203.301, 91.2896)
    ..cubicTo(203.301, 91.2896, 217.467, 91.9468, 217.467, 91.9468)
    ..cubicTo(217.467, 91.9468, 220.431, 88.9823, 220.431, 88.9823)
    ..cubicTo(220.431, 88.9823, 235.254, 88.3251, 235.254, 88.3251)
    ..cubicTo(235.254, 88.3251, 245.794, 108.087, 245.794, 108.087)
    ..cubicTo(245.794, 108.087, 248.758, 107.427, 248.758, 107.427)
    ..cubicTo(248.758, 107.427, 249.416, 110.723, 249.416, 110.723)
    ..cubicTo(249.416, 110.723, 253.041, 113.356, 253.041, 113.356)
    ..cubicTo(253.041, 113.356, 248.098, 113.688, 248.098, 113.688)
    ..cubicTo(248.098, 113.688, 247.108, 116.652, 247.108, 116.652)
    ..cubicTo(247.108, 116.652, 242.829, 118.956, 242.829, 118.956)
    ..cubicTo(242.829, 118.956, 241.84, 131.475, 241.84, 131.475)
    ..cubicTo(241.84, 131.475, 239.533, 130.814, 239.533, 130.814)
    ..cubicTo(239.533, 130.814, 237.558, 135.097, 237.558, 135.097)
    ..cubicTo(237.558, 135.097, 244.144, 139.051, 244.144, 139.051)
    ..cubicTo(244.144, 139.051, 235.911, 139.708, 235.911, 139.708)
    ..cubicTo(235.911, 139.708, 233.936, 141.354, 233.936, 141.354)
    ..cubicTo(233.936, 141.354, 230.639, 140.036, 230.639, 140.036)
    ..cubicTo(230.639, 140.036, 198.69, 147.944, 198.69, 147.944)
    ..cubicTo(198.69, 147.944, 184.196, 160.788, 184.196, 160.788)
    ..cubicTo(184.196, 160.788, 181.891, 165.071, 181.891, 165.071)
    ..cubicTo(181.891, 165.071, 181.891, 175.282, 181.891, 175.282)
    ..cubicTo(181.891, 175.282, 177.279, 175.282, 177.279, 175.282)
    ..cubicTo(177.279, 175.282, 176.95, 189.776, 176.95, 189.776)
    ..cubicTo(176.95, 189.776, 185.185, 210.528, 185.185, 210.528)
    ..cubicTo(185.185, 210.528, 197.701, 219.75, 197.701, 219.75)
    ..cubicTo(197.701, 219.75, 209.23, 225.35, 209.23, 225.35)
    ..cubicTo(209.23, 225.35, 225.371, 230.951, 225.371, 230.951)
    ..cubicTo(225.371, 230.951, 226.357, 223.043, 226.357, 223.043)
    ..cubicTo(226.357, 223.043, 228.664, 218.103, 228.664, 218.103)
    ..cubicTo(228.664, 218.103, 226.689, 217.775, 226.689, 217.775)
    ..cubicTo(226.689, 217.775, 228.335, 214.81, 228.335, 214.81)
    ..cubicTo(228.335, 214.81, 233.275, 217.775, 233.275, 217.775)
    ..cubicTo(233.275, 217.775, 232.946, 223.704, 232.946, 223.704)
    ..cubicTo(232.946, 223.704, 228.993, 223.704, 228.993, 223.704)
    ..cubicTo(228.993, 223.704, 227.675, 230.951, 227.675, 230.951)
    ..cubicTo(227.675, 230.951, 237.886, 230.951, 237.886, 230.951)
    ..cubicTo(237.886, 230.951, 242.497, 225.679, 242.497, 225.679)
    ..cubicTo(242.497, 225.679, 247.769, 222.057, 247.769, 222.057)
    ..cubicTo(247.769, 222.057, 257.652, 223.043, 257.652, 223.043)
    ..cubicTo(257.652, 223.043, 263.249, 214.15, 263.249, 214.15)
    ..cubicTo(263.249, 214.15, 262.263, 208.553, 262.263, 208.553)
    ..cubicTo(262.263, 208.553, 263.581, 207.563, 263.581, 207.563)
    ..cubicTo(263.581, 207.563, 260.617, 199.327, 260.617, 199.327)
    ..cubicTo(260.617, 199.327, 266.213, 196.695, 266.213, 196.695)
    ..cubicTo(266.213, 196.695, 270.825, 208.22, 270.825, 208.22)
    ..cubicTo(270.825, 208.22, 282.686, 200.316, 282.686, 200.316)
    ..cubicTo(282.686, 200.316, 278.072, 188.787, 278.072, 188.787)
    ..cubicTo(278.072, 188.787, 274.778, 189.776, 274.778, 189.776)
    ..cubicTo(274.778, 189.776, 273.46, 184.176, 273.46, 184.176)
    ..cubicTo(273.46, 184.176, 302.448, 171, 302.448, 171)
    ..cubicTo(302.448, 171, 311.671, 191.094, 311.671, 191.094)
    ..cubicTo(311.671, 191.094, 303.434, 194.059, 303.434, 194.059)
    ..cubicTo(303.434, 194.059, 296.191, 177.261, 296.191, 177.261)
    ..cubicTo(296.191, 177.261, 280.379, 183.847, 280.379, 183.847)
    ..cubicTo(280.379, 183.847, 296.848, 217.114, 296.848, 217.114)
    ..cubicTo(296.848, 217.114, 292.237, 219.75, 292.237, 219.75)
    ..cubicTo(292.237, 219.75, 286.636, 205.256, 286.636, 205.256)
    ..cubicTo(286.636, 205.256, 281.697, 207.892, 281.697, 207.892)
    ..cubicTo(281.697, 207.892, 283.261, 210.281, 283.261, 210.281)
    ..cubicTo(283.261, 210.281, 279.307, 212.01, 279.307, 212.01)
    ..cubicTo(279.307, 212.01, 277.825, 209.292, 277.825, 209.292)
    ..cubicTo(277.825, 209.292, 269.674, 214.482, 269.674, 214.482)
    ..cubicTo(269.674, 214.482, 268.932, 221.397, 268.932, 221.397)
    ..cubicTo(268.932, 221.397, 270.414, 222.386, 270.414, 222.386)
    ..cubicTo(270.414, 222.386, 276.839, 220.411, 276.839, 220.411)
    ..cubicTo(276.839, 220.411, 278.072, 222.386, 278.072, 222.386)
    ..cubicTo(278.072, 222.386, 268.439, 225.104, 268.439, 225.104)
    ..cubicTo(268.439, 225.104, 269.921, 230.29, 269.921, 230.29)
    ..cubicTo(269.921, 230.29, 274.614, 234.737, 274.614, 234.737)
    ..cubicTo(274.614, 234.737, 281.036, 245.609, 281.036, 245.609)
    ..cubicTo(281.036, 245.609, 286.226, 246.845, 286.226, 246.845)
    ..cubicTo(286.226, 246.845, 293.144, 244.866, 293.144, 244.866)
    ..cubicTo(293.144, 244.866, 294.623, 247.584, 294.623, 247.584)
    ..cubicTo(294.623, 247.584, 305.249, 246.349, 305.249, 246.349)
    ..cubicTo(305.249, 246.349, 305.988, 248.077, 305.988, 248.077)
    ..cubicTo(305.988, 248.077, 310.931, 245.856, 310.931, 245.856)
    ..cubicTo(310.931, 245.856, 312.164, 241.162, 312.164, 241.162)
    ..cubicTo(312.164, 241.162, 315.871, 241.409, 315.871, 241.409)
    ..cubicTo(315.871, 241.409, 317.353, 236.962, 317.353, 236.962)
    ..cubicTo(317.353, 236.962, 319.328, 236.219, 319.328, 236.219)
    ..cubicTo(319.328, 236.219, 320.564, 231.033, 320.564, 231.033)
    ..cubicTo(320.564, 231.033, 324.268, 226.586, 324.268, 226.586)
    ..cubicTo(324.268, 226.586, 336.869, 220.657, 336.869, 220.657)
    ..cubicTo(336.869, 220.657, 338.105, 218.186, 338.105, 218.186)
    ..cubicTo(338.105, 218.186, 344.034, 217.446, 344.034, 217.446)
    ..cubicTo(344.034, 217.446, 346.256, 220.657, 346.256, 220.657)
    ..cubicTo(346.256, 220.657, 346.009, 224.611, 346.009, 224.611)
    ..cubicTo(346.009, 224.611, 349.22, 226.093, 349.22, 226.093)
    ..cubicTo(349.22, 226.093, 351.692, 224.611, 351.692, 224.611)
    ..cubicTo(351.692, 224.611, 352.681, 225.843, 352.681, 225.843)
    ..cubicTo(352.681, 225.843, 359.35, 226.093, 359.35, 226.093)
    ..cubicTo(359.35, 226.093, 362.068, 222.632, 362.068, 222.632)
    ..cubicTo(362.068, 222.632, 362.811, 208.553, 362.811, 208.553)
    ..cubicTo(362.811, 208.553, 369.972, 207.563, 369.972, 207.563)
    ..cubicTo(369.972, 207.563, 368.986, 202.127, 368.986, 202.127)
    ..cubicTo(368.986, 202.127, 372.443, 208.306, 372.443, 208.306)
    ..cubicTo(372.443, 208.306, 374.915, 211.021, 374.915, 211.021)
    ..cubicTo(374.915, 211.021, 371.454, 212.01, 371.454, 212.01)
    ..cubicTo(371.454, 212.01, 369.725, 210.035, 369.725, 210.035)
    ..cubicTo(369.725, 210.035, 365.032, 210.281, 365.032, 210.281)
    ..cubicTo(365.032, 210.281, 364.786, 214.728, 364.786, 214.728)
    ..cubicTo(364.786, 214.728, 373.679, 214.728, 373.679, 214.728)
    ..cubicTo(373.679, 214.728, 373.926, 220.164, 373.926, 220.164)
    ..cubicTo(373.926, 220.164, 384.794, 219.668, 384.794, 219.668)
    ..cubicTo(384.794, 219.668, 388.502, 222.386, 388.502, 222.386)
    ..cubicTo(388.502, 222.386, 401.099, 251.785, 401.099, 251.785)
    ..cubicTo(401.099, 251.785, 396.653, 253.513, 396.653, 253.513)
    ..cubicTo(396.653, 253.513, 398.631, 258.207, 398.631, 258.207)
    ..cubicTo(398.631, 258.207, 398.135, 282.169, 398.135, 282.169)
    ..cubicTo(398.135, 282.169, 411.229, 277.973, 411.229, 277.973)
    ..cubicTo(411.229, 277.973, 413.947, 283.652, 413.947, 283.652)
    ..cubicTo(413.947, 283.652, 408.757, 285.38, 408.757, 285.38)
    ..cubicTo(408.757, 285.38, 409.254, 288.841, 409.254, 288.841)
    ..cubicTo(409.254, 288.841, 404.31, 290.324, 404.31, 290.324)
    ..cubicTo(404.31, 290.324, 406.782, 296.499, 406.782, 296.499)
    ..cubicTo(406.782, 296.499, 411.722, 295.51, 411.722, 295.51)
    ..cubicTo(411.722, 295.51, 434.452, 350.353, 434.452, 350.353)
    ..cubicTo(434.452, 350.353, 426.298, 352.332, 426.298, 352.332)
    ..cubicTo(426.298, 352.332, 429.759, 361.226, 429.759, 361.226)
    ..cubicTo(429.759, 361.226, 439.392, 366.658, 439.392, 366.658)
    ..cubicTo(439.392, 366.658, 443.592, 378.763, 443.592, 378.763)
    ..cubicTo(443.592, 378.763, 451.743, 379.259, 451.743, 379.259)
    ..cubicTo(451.743, 379.259, 462.369, 379.752, 462.369, 379.752)
    ..cubicTo(462.369, 379.752, 470.026, 376.788, 470.026, 376.788)
    ..cubicTo(470.026, 376.788, 460.39, 352.825, 460.39, 352.825)
    ..cubicTo(460.39, 352.825, 463.354, 351.096, 463.354, 351.096)
    ..cubicTo(463.354, 351.096, 465.58, 352.082, 465.58, 352.082)
    ..cubicTo(465.58, 352.082, 467.555, 351.343, 467.555, 351.343)
    ..cubicTo(467.555, 351.343, 467.308, 347.142, 467.308, 347.142)
    ..cubicTo(467.308, 347.142, 470.026, 346.403, 470.026, 346.403)
    ..cubicTo(470.026, 346.403, 469.283, 342.449, 469.283, 342.449)
    ..cubicTo(469.283, 342.449, 483.86, 336.027, 483.86, 336.027)
    ..cubicTo(483.86, 336.027, 486.824, 340.72, 486.824, 340.72)
    ..cubicTo(486.824, 340.72, 491.517, 339.238, 491.517, 339.238)
    ..cubicTo(491.517, 339.238, 496.211, 353.318, 496.211, 353.318)
    ..cubicTo(496.211, 353.318, 493.246, 354.554, 493.246, 354.554)
    ..cubicTo(493.246, 354.554, 490.035, 342.449, 490.035, 342.449)
    ..cubicTo(490.035, 342.449, 485.342, 344.178, 485.342, 344.178)
    ..cubicTo(485.342, 344.178, 484.352, 349.118, 484.352, 349.118)
    ..cubicTo(484.352, 349.118, 481.388, 347.885, 481.388, 347.885)
    ..cubicTo(481.388, 347.885, 478.177, 349.86, 478.177, 349.86)
    ..cubicTo(478.177, 349.86, 478.177, 352.082, 478.177, 352.082)
    ..cubicTo(478.177, 352.082, 485.835, 362.954, 485.835, 362.954)
    ..cubicTo(485.835, 362.954, 487.071, 367.401, 487.071, 367.401)
    ..cubicTo(487.071, 367.401, 476.941, 374.566, 476.941, 374.566)
    ..cubicTo(476.941, 374.566, 478.177, 377.281, 478.177, 377.281)
    ..cubicTo(478.177, 377.281, 464.837, 382.717, 464.837, 382.717)
    ..cubicTo(464.837, 382.717, 466.072, 384.942, 466.072, 384.942)
    ..cubicTo(466.072, 384.942, 431.487, 397.293, 431.487, 397.293)
    ..cubicTo(431.487, 397.293, 430.745, 407.422, 430.745, 407.422)
    ..cubicTo(430.745, 407.422, 432.97, 414.337, 432.97, 414.337)
    ..cubicTo(432.97, 414.337, 434.452, 420.266, 434.452, 420.266)
    ..cubicTo(434.452, 420.266, 438.156, 421.009, 438.156, 421.009)
    ..cubicTo(438.156, 421.009, 435.688, 425.702, 435.688, 425.702)
    ..cubicTo(435.688, 425.702, 437.909, 438.053, 437.909, 438.053)
    ..cubicTo(437.909, 438.053, 441.617, 450.161, 441.617, 450.161)
    ..cubicTo(441.617, 450.161, 452.486, 465.723, 452.486, 465.723)
    ..cubicTo(452.486, 465.723, 467.062, 478.321, 467.062, 478.321)
    ..cubicTo(467.062, 478.321, 479.906, 496.108, 479.906, 496.108)
    ..cubicTo(479.906, 496.108, 482.131, 495.862, 482.131, 495.862)
    ..cubicTo(482.131, 495.862, 483.613, 498.58, 483.613, 498.58)
    ..cubicTo(483.613, 498.58, 491.517, 498.826, 491.517, 498.826)
    ..cubicTo(491.517, 498.826, 491.764, 505.498, 491.764, 505.498)
    ..cubicTo(491.764, 505.498, 494.728, 505.252, 494.728, 505.252)
    ..cubicTo(494.728, 505.252, 494.728, 513.156, 494.728, 513.156)
    ..cubicTo(494.728, 513.156, 492.26, 517.603, 492.26, 517.603)
    ..cubicTo(492.26, 517.603, 496.707, 520.074, 496.707, 520.074)
    ..cubicTo(496.707, 520.074, 493, 521.306, 493, 521.306)
    ..cubicTo(493, 521.306, 495.718, 524.275, 495.718, 524.275)
    ..cubicTo(495.718, 524.275, 493.743, 526.743, 493.743, 526.743)
    ..cubicTo(493.743, 526.743, 493.743, 542.555, 493.743, 542.555)
    ..cubicTo(493.743, 542.555, 491.764, 541.565, 491.764, 541.565)
    ..cubicTo(491.764, 541.565, 492.26, 566.271, 492.26, 566.271)
    ..cubicTo(492.26, 566.271, 495.225, 571.457, 495.225, 571.457)
    ..cubicTo(495.225, 571.457, 496.211, 577.386, 496.211, 577.386)
    ..cubicTo(496.211, 577.386, 495.718, 581.833, 495.718, 581.833)
    ..cubicTo(495.718, 581.833, 492.753, 586.526, 492.753, 586.526)
    ..cubicTo(492.753, 586.526, 487.813, 589.987, 487.813, 589.987)
    ..cubicTo(487.813, 589.987, 485.835, 595.67, 485.835, 595.67)
    ..cubicTo(485.835, 595.67, 487.317, 600.363, 487.317, 600.363)
    ..cubicTo(487.317, 600.363, 484.106, 601.599, 484.106, 601.599)
    ..cubicTo(484.106, 601.599, 484.106, 612.221, 484.106, 612.221)
    ..cubicTo(484.106, 612.221, 481.142, 612.221, 481.142, 612.221)
    ..cubicTo(481.142, 612.221, 481.142, 616.171, 481.142, 616.171)
    ..cubicTo(481.142, 616.171, 484.849, 616.171, 484.849, 616.171)
    ..cubicTo(484.849, 616.171, 484.849, 618.889, 484.849, 618.889)
    ..cubicTo(484.849, 618.889, 480.402, 618.396, 480.402, 618.396)
    ..cubicTo(480.402, 618.396, 481.142, 623.336, 481.142, 623.336)
    ..cubicTo(481.142, 623.336, 476.941, 626.797, 476.941, 626.797)
    ..cubicTo(476.941, 626.797, 475.459, 626.054, 475.459, 626.054)
    ..cubicTo(475.459, 626.054, 471.509, 635.441, 471.509, 635.441)
    ..cubicTo(471.509, 635.441, 468.298, 635.441, 468.298, 635.441)
    ..cubicTo(468.298, 635.441, 465.58, 646.806, 465.58, 646.806)
    ..cubicTo(465.58, 646.806, 465.083, 651.499, 465.083, 651.499)
    ..cubicTo(465.083, 651.499, 465.826, 654.71, 465.826, 654.71)
    ..cubicTo(465.826, 654.71, 473.484, 660.639, 473.484, 660.639)
    ..cubicTo(473.484, 660.639, 472.494, 663.111, 472.494, 663.111)
    ..cubicTo(472.494, 663.111, 470.026, 665.336, 470.026, 665.336)
    ..cubicTo(470.026, 665.336, 466.072, 666.568, 466.072, 666.568)
    ..cubicTo(466.072, 666.568, 466.565, 670.276, 466.565, 670.276)
    ..cubicTo(466.565, 670.276, 463.851, 669.533, 463.851, 669.533)
    ..cubicTo(463.851, 669.533, 465.58, 674.969, 465.58, 674.969)
    ..cubicTo(465.58, 674.969, -139.266, 674.969, -139.266, 674.969)
    ..cubicTo(-139.266, 674.969, -139.266, 0.0466, -139.266, 0.0466)
    ..cubicTo(-139.266, 0.0466, 205.609, 0.7073, 205.937, 0.3751)
    ..cubicTo(205.937, 0.3751, 205.937, 0.3751, 205.937, 0.3751)
    ..close();

  static final Path __path47_5_0 = Path()
    ..moveTo(534.998, 674.41)
    ..cubicTo(534.998, 674.41, -138.938, 674.41, -138.938, 674.41)
    ..cubicTo(-138.938, 674.41, -138.938, 0.4773, -138.938, 0.4773)
    ..cubicTo(-138.938, 0.4773, 534.998, 0.4773, 534.998, 0.4773)
    ..cubicTo(534.998, 0.4773, 534.998, 674.41, 534.998, 674.41)
    ..close();

  static final Path __path47_6_0 = Path()
    ..moveTo(42, 0)
    ..cubicTo(42, 0, 248.427, 0, 248.427, 0)
    ..cubicTo(271.623, 0, 290.427, 18.804, 290.427, 42)
    ..cubicTo(290.427, 42, 290.427, 310.662, 290.427, 310.662)
    ..cubicTo(290.427, 333.858, 271.623, 352.662, 248.427, 352.662)
    ..cubicTo(248.427, 352.662, 42, 352.662, 42, 352.662)
    ..cubicTo(18.804, 352.662, 0, 333.858, 0, 310.662)
    ..cubicTo(0, 310.662, 0, 42, 0, 42)
    ..cubicTo(0, 18.804, 18.804, 0, 42, 0)
    ..close();

  static final Path __maskPath47_0 = Path()
    ..moveTo(42, 0)
    ..cubicTo(42, 0, 248.427, 0, 248.427, 0)
    ..cubicTo(271.623, 0, 290.427, 18.804, 290.427, 42)
    ..cubicTo(290.427, 42, 290.427, 310.662, 290.427, 310.662)
    ..cubicTo(290.427, 333.858, 271.623, 352.662, 248.427, 352.662)
    ..cubicTo(248.427, 352.662, 42, 352.662, 42, 352.662)
    ..cubicTo(18.804, 352.662, 0, 333.858, 0, 310.662)
    ..cubicTo(0, 310.662, 0, 42, 0, 42)
    ..cubicTo(0, 18.804, 18.804, 0, 42, 0)
    ..close();

  static final Path _compoundStrokePath22_1 = Path()
    ..addPath(__path22_1_0, Offset.zero)
    ..addPath(__path22_1_1, Offset.zero)
    ..addPath(__path22_1_2, Offset.zero)
    ..addPath(__path22_1_3, Offset.zero)
    ..addPath(__path22_1_4, Offset.zero)
    ..addPath(__path22_1_5, Offset.zero)
    ..addPath(__path22_1_6, Offset.zero)
    ..addPath(__path22_1_7, Offset.zero)
    ..addPath(__path22_1_8, Offset.zero)
    ..addPath(__path22_1_9, Offset.zero)
    ..addPath(__path22_1_10, Offset.zero);

  static final Path _compoundFillPath22_2 = Path()
    ..addPath(__path22_2_0, Offset.zero)
    ..addPath(__path22_2_1, Offset.zero)
    ..addPath(__path22_2_2, Offset.zero)
    ..addPath(__path22_2_3, Offset.zero)
    ..addPath(__path22_2_4, Offset.zero)
    ..addPath(__path22_2_5, Offset.zero);

  static final Path _compoundFillPath27_1 = Path()
    ..addPath(__path27_1_0, Offset.zero)
    ..addPath(__path27_1_1, Offset.zero)
    ..addPath(__path27_1_2, Offset.zero)
    ..addPath(__path27_1_3, Offset.zero)
    ..addPath(__path27_1_4, Offset.zero)
    ..addPath(__path27_1_5, Offset.zero)
    ..addPath(__path27_1_6, Offset.zero)
    ..addPath(__path27_1_7, Offset.zero)
    ..addPath(__path27_1_8, Offset.zero)
    ..addPath(__path27_1_9, Offset.zero)
    ..addPath(__path27_1_10, Offset.zero)
    ..addPath(__path27_1_11, Offset.zero)
    ..addPath(__path27_1_12, Offset.zero)
    ..addPath(__path27_1_13, Offset.zero)
    ..addPath(__path27_1_14, Offset.zero)
    ..addPath(__path27_1_15, Offset.zero)
    ..addPath(__path27_1_16, Offset.zero)
    ..addPath(__path27_1_17, Offset.zero)
    ..addPath(__path27_1_18, Offset.zero)
    ..addPath(__path27_1_19, Offset.zero)
    ..addPath(__path27_1_20, Offset.zero)
    ..addPath(__path27_1_21, Offset.zero)
    ..addPath(__path27_1_22, Offset.zero)
    ..addPath(__path27_1_23, Offset.zero)
    ..addPath(__path27_1_24, Offset.zero)
    ..addPath(__path27_1_25, Offset.zero)
    ..addPath(__path27_1_26, Offset.zero)
    ..addPath(__path27_1_27, Offset.zero)
    ..addPath(__path27_1_28, Offset.zero)
    ..addPath(__path27_1_29, Offset.zero)
    ..addPath(__path27_1_30, Offset.zero)
    ..addPath(__path27_1_31, Offset.zero)
    ..addPath(__path27_1_32, Offset.zero)
    ..addPath(__path27_1_33, Offset.zero)
    ..addPath(__path27_1_34, Offset.zero);

  static final Path _compoundStrokePath32_1 = Path()
    ..addPath(__path32_1_0, Offset.zero)
    ..addPath(__path32_1_1, Offset.zero)
    ..addPath(__path32_1_2, Offset.zero)
    ..addPath(__path32_1_3, Offset.zero)
    ..addPath(__path32_1_4, Offset.zero)
    ..addPath(__path32_1_5, Offset.zero)
    ..addPath(__path32_1_6, Offset.zero)
    ..addPath(__path32_1_7, Offset.zero)
    ..addPath(__path32_1_8, Offset.zero)
    ..addPath(__path32_1_9, Offset.zero)
    ..addPath(__path32_1_10, Offset.zero)
    ..addPath(__path32_1_11, Offset.zero);

  static final Path _compoundFillPath32_2 = Path()
    ..addPath(__path32_2_0, Offset.zero)
    ..addPath(__path32_2_1, Offset.zero)
    ..addPath(__path32_2_2, Offset.zero);

  static final Path _compoundFillPath37_1 = Path()
    ..addPath(__path37_1_0, Offset.zero)
    ..addPath(__path37_1_1, Offset.zero)
    ..addPath(__path37_1_2, Offset.zero)
    ..addPath(__path37_1_3, Offset.zero)
    ..addPath(__path37_1_4, Offset.zero)
    ..addPath(__path37_1_5, Offset.zero)
    ..addPath(__path37_1_6, Offset.zero)
    ..addPath(__path37_1_7, Offset.zero)
    ..addPath(__path37_1_8, Offset.zero)
    ..addPath(__path37_1_9, Offset.zero)
    ..addPath(__path37_1_10, Offset.zero)
    ..addPath(__path37_1_11, Offset.zero)
    ..addPath(__path37_1_12, Offset.zero)
    ..addPath(__path37_1_13, Offset.zero)
    ..addPath(__path37_1_14, Offset.zero)
    ..addPath(__path37_1_15, Offset.zero)
    ..addPath(__path37_1_16, Offset.zero)
    ..addPath(__path37_1_17, Offset.zero)
    ..addPath(__path37_1_18, Offset.zero)
    ..addPath(__path37_1_19, Offset.zero)
    ..addPath(__path37_1_20, Offset.zero)
    ..addPath(__path37_1_21, Offset.zero)
    ..addPath(__path37_1_22, Offset.zero)
    ..addPath(__path37_1_23, Offset.zero)
    ..addPath(__path37_1_24, Offset.zero)
    ..addPath(__path37_1_25, Offset.zero)
    ..addPath(__path37_1_26, Offset.zero)
    ..addPath(__path37_1_27, Offset.zero)
    ..addPath(__path37_1_28, Offset.zero)
    ..addPath(__path37_1_29, Offset.zero);

  static final Path _compoundFillPath37_2 = Path()
    ..addPath(__path37_2_0, Offset.zero)
    ..addPath(__path37_2_1, Offset.zero)
    ..addPath(__path37_2_2, Offset.zero)
    ..addPath(__path37_2_3, Offset.zero)
    ..addPath(__path37_2_4, Offset.zero);

  static final Path _compoundFillPath42_1 = Path()
    ..addPath(__path42_1_0, Offset.zero)
    ..addPath(__path42_1_1, Offset.zero)
    ..addPath(__path42_1_2, Offset.zero)
    ..addPath(__path42_1_3, Offset.zero)
    ..addPath(__path42_1_4, Offset.zero)
    ..addPath(__path42_1_5, Offset.zero)
    ..addPath(__path42_1_6, Offset.zero)
    ..addPath(__path42_1_7, Offset.zero)
    ..addPath(__path42_1_8, Offset.zero)
    ..addPath(__path42_1_9, Offset.zero)
    ..addPath(__path42_1_10, Offset.zero)
    ..addPath(__path42_1_11, Offset.zero)
    ..addPath(__path42_1_12, Offset.zero)
    ..addPath(__path42_1_13, Offset.zero)
    ..addPath(__path42_1_14, Offset.zero)
    ..addPath(__path42_1_15, Offset.zero)
    ..addPath(__path42_1_16, Offset.zero)
    ..addPath(__path42_1_17, Offset.zero)
    ..addPath(__path42_1_18, Offset.zero);

  static final Path _compoundFillPath47_1 = Path()
    ..addPath(__path47_1_0, Offset.zero)
    ..addPath(__path47_1_1, Offset.zero)
    ..addPath(__path47_1_2, Offset.zero)
    ..addPath(__path47_1_3, Offset.zero)
    ..addPath(__path47_1_4, Offset.zero)
    ..addPath(__path47_1_5, Offset.zero)
    ..addPath(__path47_1_6, Offset.zero)
    ..addPath(__path47_1_7, Offset.zero)
    ..addPath(__path47_1_8, Offset.zero)
    ..addPath(__path47_1_9, Offset.zero)
    ..addPath(__path47_1_10, Offset.zero)
    ..addPath(__path47_1_11, Offset.zero)
    ..addPath(__path47_1_12, Offset.zero)
    ..addPath(__path47_1_13, Offset.zero)
    ..addPath(__path47_1_14, Offset.zero)
    ..addPath(__path47_1_15, Offset.zero)
    ..addPath(__path47_1_16, Offset.zero)
    ..addPath(__path47_1_17, Offset.zero)
    ..addPath(__path47_1_18, Offset.zero)
    ..addPath(__path47_1_19, Offset.zero)
    ..addPath(__path47_1_20, Offset.zero)
    ..addPath(__path47_1_21, Offset.zero)
    ..addPath(__path47_1_22, Offset.zero)
    ..addPath(__path47_1_23, Offset.zero)
    ..addPath(__path47_1_24, Offset.zero)
    ..addPath(__path47_1_25, Offset.zero)
    ..addPath(__path47_1_26, Offset.zero)
    ..addPath(__path47_1_27, Offset.zero)
    ..addPath(__path47_1_28, Offset.zero)
    ..addPath(__path47_1_29, Offset.zero)
    ..addPath(__path47_1_30, Offset.zero)
    ..addPath(__path47_1_31, Offset.zero)
    ..addPath(__path47_1_32, Offset.zero)
    ..addPath(__path47_1_33, Offset.zero);

  TextPainter? _textPainter18;
  Color? _textPainter18Color;
  Offset _textPainter18Offset = Offset.zero;

  TextSpan _textSpanFor18(Color color) {
    return TextSpan(
      text: overrides.jobCard01TextPostedTimeText ?? '1 dia atrás',
      style: TextStyle(
        color: color,
        fontFamily: 'Inter',
        fontSize: 9.7354,
        fontWeight: FontWeight.w500,
        height: 1.2,
      ),
    );
  }

  TextPainter _textPainterFor18(Color color) {
    final cached = _textPainter18;
    if (cached != null) {
      if (_textPainter18Color != color) {
        _textPainter18Color = color;
        cached.text = _textSpanFor18(color);
      }
      return cached;
    }
    _textPainter18Color = color;
    final painter = TextPainter(
      text: _textSpanFor18(color),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(maxWidth: double.infinity);
    _textPainter18Offset = Offset(
      0,
      -painter.computeDistanceToActualBaseline(TextBaseline.alphabetic),
    );
    return _textPainter18 = painter;
  }

  TextPainter? _textPainter19;
  Color? _textPainter19Color;
  Offset _textPainter19Offset = Offset.zero;

  TextSpan _textSpanFor19(Color color) {
    return TextSpan(
      text: overrides.jobCard01TextJobTitleText ?? 'Garçom',
      style: TextStyle(
        color: color,
        fontFamily: 'Inter',
        fontSize: 16.2412,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.3248,
      ),
    );
  }

  TextPainter _textPainterFor19(Color color) {
    final cached = _textPainter19;
    if (cached != null) {
      if (_textPainter19Color != color) {
        _textPainter19Color = color;
        cached.text = _textSpanFor19(color);
      }
      return cached;
    }
    _textPainter19Color = color;
    final painter = TextPainter(
      text: _textSpanFor19(color),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(maxWidth: double.infinity);
    _textPainter19Offset = Offset(
      0,
      -painter.computeDistanceToActualBaseline(TextBaseline.alphabetic),
    );
    return _textPainter19 = painter;
  }

  TextPainter? _textPainter20;
  Color? _textPainter20Color;
  Offset _textPainter20Offset = Offset.zero;

  TextSpan _textSpanFor20(Color color) {
    return TextSpan(
      text: overrides.jobCard01TextPayText ?? r'R$100/dia',
      style: TextStyle(
        color: color,
        fontFamily: 'Inter',
        fontSize: 18.59,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.3718,
      ),
    );
  }

  TextPainter _textPainterFor20(Color color) {
    final cached = _textPainter20;
    if (cached != null) {
      if (_textPainter20Color != color) {
        _textPainter20Color = color;
        cached.text = _textSpanFor20(color);
      }
      return cached;
    }
    _textPainter20Color = color;
    final painter = TextPainter(
      text: _textSpanFor20(color),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(maxWidth: double.infinity);
    _textPainter20Offset = Offset(
      0,
      -painter.computeDistanceToActualBaseline(TextBaseline.alphabetic),
    );
    return _textPainter20 = painter;
  }

  TextPainter? _textPainter21;
  Color? _textPainter21Color;

  TextSpan _textSpanFor21(Color color) {
    return TextSpan(
      text:
          overrides.jobCard01TextDescriptionText ??
          'Preciso de um garçom para 3 dias em um evento. Precisa ter experiência e já ter participado de eventos',
      style: TextStyle(
        color: color,
        fontFamily: 'Inter',
        fontSize: 11.3405,
        fontWeight: FontWeight.w500,
        height: 1.3227,
        letterSpacing: -0.2268,
      ),
    );
  }

  TextPainter _textPainterFor21(Color color) {
    final cached = _textPainter21;
    if (cached != null) {
      if (_textPainter21Color != color) {
        _textPainter21Color = color;
        cached.text = _textSpanFor21(color);
      }
      return cached;
    }
    _textPainter21Color = color;
    final painter = TextPainter(
      text: _textSpanFor21(color),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      maxLines: 4,
    )..layout(maxWidth: 230);
    return _textPainter21 = painter;
  }

  TextPainter? _textPainter23;
  Color? _textPainter23Color;
  Offset _textPainter23Offset = Offset.zero;

  TextSpan _textSpanFor23(Color color) {
    return TextSpan(
      text: overrides.jobCard02TextPostedTimeText ?? '1 dia atrás',
      style: TextStyle(
        color: color,
        fontFamily: 'Inter',
        fontSize: 9.7354,
        fontWeight: FontWeight.w500,
        height: 1.2,
      ),
    );
  }

  TextPainter _textPainterFor23(Color color) {
    final cached = _textPainter23;
    if (cached != null) {
      if (_textPainter23Color != color) {
        _textPainter23Color = color;
        cached.text = _textSpanFor23(color);
      }
      return cached;
    }
    _textPainter23Color = color;
    final painter = TextPainter(
      text: _textSpanFor23(color),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(maxWidth: double.infinity);
    _textPainter23Offset = Offset(
      0,
      -painter.computeDistanceToActualBaseline(TextBaseline.alphabetic),
    );
    return _textPainter23 = painter;
  }

  TextPainter? _textPainter24;
  Color? _textPainter24Color;
  Offset _textPainter24Offset = Offset.zero;

  TextSpan _textSpanFor24(Color color) {
    return TextSpan(
      text: overrides.jobCard02TextJobTitleText ?? 'Garçom',
      style: TextStyle(
        color: color,
        fontFamily: 'Inter',
        fontSize: 16.2412,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.3248,
      ),
    );
  }

  TextPainter _textPainterFor24(Color color) {
    final cached = _textPainter24;
    if (cached != null) {
      if (_textPainter24Color != color) {
        _textPainter24Color = color;
        cached.text = _textSpanFor24(color);
      }
      return cached;
    }
    _textPainter24Color = color;
    final painter = TextPainter(
      text: _textSpanFor24(color),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(maxWidth: double.infinity);
    _textPainter24Offset = Offset(
      0,
      -painter.computeDistanceToActualBaseline(TextBaseline.alphabetic),
    );
    return _textPainter24 = painter;
  }

  TextPainter? _textPainter25;
  Color? _textPainter25Color;
  Offset _textPainter25Offset = Offset.zero;

  TextSpan _textSpanFor25(Color color) {
    return TextSpan(
      text: overrides.jobCard02TextPayText ?? r'R$100/dia',
      style: TextStyle(
        color: color,
        fontFamily: 'Inter',
        fontSize: 18.59,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.3718,
      ),
    );
  }

  TextPainter _textPainterFor25(Color color) {
    final cached = _textPainter25;
    if (cached != null) {
      if (_textPainter25Color != color) {
        _textPainter25Color = color;
        cached.text = _textSpanFor25(color);
      }
      return cached;
    }
    _textPainter25Color = color;
    final painter = TextPainter(
      text: _textSpanFor25(color),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(maxWidth: double.infinity);
    _textPainter25Offset = Offset(
      0,
      -painter.computeDistanceToActualBaseline(TextBaseline.alphabetic),
    );
    return _textPainter25 = painter;
  }

  TextPainter? _textPainter26;
  Color? _textPainter26Color;

  TextSpan _textSpanFor26(Color color) {
    return TextSpan(
      text:
          overrides.jobCard02TextDescriptionText ??
          'Preciso de um garçom para 3 dias em um evento. Precisa ter experiência e já ter participado de eventos',
      style: TextStyle(
        color: color,
        fontFamily: 'Inter',
        fontSize: 11.3405,
        fontWeight: FontWeight.w500,
        height: 1.3227,
        letterSpacing: -0.2268,
      ),
    );
  }

  TextPainter _textPainterFor26(Color color) {
    final cached = _textPainter26;
    if (cached != null) {
      if (_textPainter26Color != color) {
        _textPainter26Color = color;
        cached.text = _textSpanFor26(color);
      }
      return cached;
    }
    _textPainter26Color = color;
    final painter = TextPainter(
      text: _textSpanFor26(color),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      maxLines: 4,
    )..layout(maxWidth: 230);
    return _textPainter26 = painter;
  }

  TextPainter? _textPainter28;
  Color? _textPainter28Color;
  Offset _textPainter28Offset = Offset.zero;

  TextSpan _textSpanFor28(Color color) {
    return TextSpan(
      text: overrides.jobCard03TextPostedTimeText ?? '1 dia atrás',
      style: TextStyle(
        color: color,
        fontFamily: 'Inter',
        fontSize: 9.7354,
        fontWeight: FontWeight.w500,
        height: 1.2,
      ),
    );
  }

  TextPainter _textPainterFor28(Color color) {
    final cached = _textPainter28;
    if (cached != null) {
      if (_textPainter28Color != color) {
        _textPainter28Color = color;
        cached.text = _textSpanFor28(color);
      }
      return cached;
    }
    _textPainter28Color = color;
    final painter = TextPainter(
      text: _textSpanFor28(color),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(maxWidth: double.infinity);
    _textPainter28Offset = Offset(
      0,
      -painter.computeDistanceToActualBaseline(TextBaseline.alphabetic),
    );
    return _textPainter28 = painter;
  }

  TextPainter? _textPainter29;
  Color? _textPainter29Color;
  Offset _textPainter29Offset = Offset.zero;

  TextSpan _textSpanFor29(Color color) {
    return TextSpan(
      text: overrides.jobCard03TextJobTitleText ?? 'Garçom',
      style: TextStyle(
        color: color,
        fontFamily: 'Inter',
        fontSize: 16.2412,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.3248,
      ),
    );
  }

  TextPainter _textPainterFor29(Color color) {
    final cached = _textPainter29;
    if (cached != null) {
      if (_textPainter29Color != color) {
        _textPainter29Color = color;
        cached.text = _textSpanFor29(color);
      }
      return cached;
    }
    _textPainter29Color = color;
    final painter = TextPainter(
      text: _textSpanFor29(color),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(maxWidth: double.infinity);
    _textPainter29Offset = Offset(
      0,
      -painter.computeDistanceToActualBaseline(TextBaseline.alphabetic),
    );
    return _textPainter29 = painter;
  }

  TextPainter? _textPainter30;
  Color? _textPainter30Color;
  Offset _textPainter30Offset = Offset.zero;

  TextSpan _textSpanFor30(Color color) {
    return TextSpan(
      text: overrides.jobCard03TextPayText ?? r'R$100/dia',
      style: TextStyle(
        color: color,
        fontFamily: 'Inter',
        fontSize: 18.59,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.3718,
      ),
    );
  }

  TextPainter _textPainterFor30(Color color) {
    final cached = _textPainter30;
    if (cached != null) {
      if (_textPainter30Color != color) {
        _textPainter30Color = color;
        cached.text = _textSpanFor30(color);
      }
      return cached;
    }
    _textPainter30Color = color;
    final painter = TextPainter(
      text: _textSpanFor30(color),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(maxWidth: double.infinity);
    _textPainter30Offset = Offset(
      0,
      -painter.computeDistanceToActualBaseline(TextBaseline.alphabetic),
    );
    return _textPainter30 = painter;
  }

  TextPainter? _textPainter31;
  Color? _textPainter31Color;

  TextSpan _textSpanFor31(Color color) {
    return TextSpan(
      text:
          overrides.jobCard03TextDescriptionText ??
          'Preciso de um garçom para 3 dias em um evento. Precisa ter experiência e já ter participado de eventos',
      style: TextStyle(
        color: color,
        fontFamily: 'Inter',
        fontSize: 11.3405,
        fontWeight: FontWeight.w500,
        height: 1.3227,
        letterSpacing: -0.2268,
      ),
    );
  }

  TextPainter _textPainterFor31(Color color) {
    final cached = _textPainter31;
    if (cached != null) {
      if (_textPainter31Color != color) {
        _textPainter31Color = color;
        cached.text = _textSpanFor31(color);
      }
      return cached;
    }
    _textPainter31Color = color;
    final painter = TextPainter(
      text: _textSpanFor31(color),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      maxLines: 4,
    )..layout(maxWidth: 230);
    return _textPainter31 = painter;
  }

  TextPainter? _textPainter33;
  Color? _textPainter33Color;
  Offset _textPainter33Offset = Offset.zero;

  TextSpan _textSpanFor33(Color color) {
    return TextSpan(
      text: overrides.jobCard04TextPostedTimeText ?? '1 dia atrás',
      style: TextStyle(
        color: color,
        fontFamily: 'Inter',
        fontSize: 9.7354,
        fontWeight: FontWeight.w500,
        height: 1.2,
      ),
    );
  }

  TextPainter _textPainterFor33(Color color) {
    final cached = _textPainter33;
    if (cached != null) {
      if (_textPainter33Color != color) {
        _textPainter33Color = color;
        cached.text = _textSpanFor33(color);
      }
      return cached;
    }
    _textPainter33Color = color;
    final painter = TextPainter(
      text: _textSpanFor33(color),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(maxWidth: double.infinity);
    _textPainter33Offset = Offset(
      0,
      -painter.computeDistanceToActualBaseline(TextBaseline.alphabetic),
    );
    return _textPainter33 = painter;
  }

  TextPainter? _textPainter34;
  Color? _textPainter34Color;
  Offset _textPainter34Offset = Offset.zero;

  TextSpan _textSpanFor34(Color color) {
    return TextSpan(
      text: overrides.jobCard04TextJobTitleText ?? 'Garçom',
      style: TextStyle(
        color: color,
        fontFamily: 'Inter',
        fontSize: 16.2412,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.3248,
      ),
    );
  }

  TextPainter _textPainterFor34(Color color) {
    final cached = _textPainter34;
    if (cached != null) {
      if (_textPainter34Color != color) {
        _textPainter34Color = color;
        cached.text = _textSpanFor34(color);
      }
      return cached;
    }
    _textPainter34Color = color;
    final painter = TextPainter(
      text: _textSpanFor34(color),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(maxWidth: double.infinity);
    _textPainter34Offset = Offset(
      0,
      -painter.computeDistanceToActualBaseline(TextBaseline.alphabetic),
    );
    return _textPainter34 = painter;
  }

  TextPainter? _textPainter35;
  Color? _textPainter35Color;
  Offset _textPainter35Offset = Offset.zero;

  TextSpan _textSpanFor35(Color color) {
    return TextSpan(
      text: overrides.jobCard04TextPayText ?? r'R$100/dia',
      style: TextStyle(
        color: color,
        fontFamily: 'Inter',
        fontSize: 18.59,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.3718,
      ),
    );
  }

  TextPainter _textPainterFor35(Color color) {
    final cached = _textPainter35;
    if (cached != null) {
      if (_textPainter35Color != color) {
        _textPainter35Color = color;
        cached.text = _textSpanFor35(color);
      }
      return cached;
    }
    _textPainter35Color = color;
    final painter = TextPainter(
      text: _textSpanFor35(color),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(maxWidth: double.infinity);
    _textPainter35Offset = Offset(
      0,
      -painter.computeDistanceToActualBaseline(TextBaseline.alphabetic),
    );
    return _textPainter35 = painter;
  }

  TextPainter? _textPainter36;
  Color? _textPainter36Color;

  TextSpan _textSpanFor36(Color color) {
    return TextSpan(
      text:
          overrides.jobCard04TextDescriptionText ??
          'Preciso de um garçom para 3 dias em um evento. Precisa ter experiência e já ter participado de eventos',
      style: TextStyle(
        color: color,
        fontFamily: 'Inter',
        fontSize: 11.3405,
        fontWeight: FontWeight.w500,
        height: 1.3227,
        letterSpacing: -0.2268,
      ),
    );
  }

  TextPainter _textPainterFor36(Color color) {
    final cached = _textPainter36;
    if (cached != null) {
      if (_textPainter36Color != color) {
        _textPainter36Color = color;
        cached.text = _textSpanFor36(color);
      }
      return cached;
    }
    _textPainter36Color = color;
    final painter = TextPainter(
      text: _textSpanFor36(color),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      maxLines: 4,
    )..layout(maxWidth: 230);
    return _textPainter36 = painter;
  }

  TextPainter? _textPainter38;
  Color? _textPainter38Color;
  Offset _textPainter38Offset = Offset.zero;

  TextSpan _textSpanFor38(Color color) {
    return TextSpan(
      text: overrides.jobCard05TextPostedTimeText ?? '1 dia atrás',
      style: TextStyle(
        color: color,
        fontFamily: 'Inter',
        fontSize: 9.7354,
        fontWeight: FontWeight.w500,
        height: 1.2,
      ),
    );
  }

  TextPainter _textPainterFor38(Color color) {
    final cached = _textPainter38;
    if (cached != null) {
      if (_textPainter38Color != color) {
        _textPainter38Color = color;
        cached.text = _textSpanFor38(color);
      }
      return cached;
    }
    _textPainter38Color = color;
    final painter = TextPainter(
      text: _textSpanFor38(color),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(maxWidth: double.infinity);
    _textPainter38Offset = Offset(
      0,
      -painter.computeDistanceToActualBaseline(TextBaseline.alphabetic),
    );
    return _textPainter38 = painter;
  }

  TextPainter? _textPainter39;
  Color? _textPainter39Color;
  Offset _textPainter39Offset = Offset.zero;

  TextSpan _textSpanFor39(Color color) {
    return TextSpan(
      text: overrides.jobCard05TextJobTitleText ?? 'Garçom',
      style: TextStyle(
        color: color,
        fontFamily: 'Inter',
        fontSize: 16.2412,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.3248,
      ),
    );
  }

  TextPainter _textPainterFor39(Color color) {
    final cached = _textPainter39;
    if (cached != null) {
      if (_textPainter39Color != color) {
        _textPainter39Color = color;
        cached.text = _textSpanFor39(color);
      }
      return cached;
    }
    _textPainter39Color = color;
    final painter = TextPainter(
      text: _textSpanFor39(color),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(maxWidth: double.infinity);
    _textPainter39Offset = Offset(
      0,
      -painter.computeDistanceToActualBaseline(TextBaseline.alphabetic),
    );
    return _textPainter39 = painter;
  }

  TextPainter? _textPainter40;
  Color? _textPainter40Color;
  Offset _textPainter40Offset = Offset.zero;

  TextSpan _textSpanFor40(Color color) {
    return TextSpan(
      text: overrides.jobCard05TextPayText ?? r'R$100/dia',
      style: TextStyle(
        color: color,
        fontFamily: 'Inter',
        fontSize: 18.59,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.3718,
      ),
    );
  }

  TextPainter _textPainterFor40(Color color) {
    final cached = _textPainter40;
    if (cached != null) {
      if (_textPainter40Color != color) {
        _textPainter40Color = color;
        cached.text = _textSpanFor40(color);
      }
      return cached;
    }
    _textPainter40Color = color;
    final painter = TextPainter(
      text: _textSpanFor40(color),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(maxWidth: double.infinity);
    _textPainter40Offset = Offset(
      0,
      -painter.computeDistanceToActualBaseline(TextBaseline.alphabetic),
    );
    return _textPainter40 = painter;
  }

  TextPainter? _textPainter41;
  Color? _textPainter41Color;

  TextSpan _textSpanFor41(Color color) {
    return TextSpan(
      text:
          overrides.jobCard05TextDescriptionText ??
          'Preciso de um garçom para 3 dias em um evento. Precisa ter experiência e já ter participado de eventos',
      style: TextStyle(
        color: color,
        fontFamily: 'Inter',
        fontSize: 11.3405,
        fontWeight: FontWeight.w500,
        height: 1.3227,
        letterSpacing: -0.2268,
      ),
    );
  }

  TextPainter _textPainterFor41(Color color) {
    final cached = _textPainter41;
    if (cached != null) {
      if (_textPainter41Color != color) {
        _textPainter41Color = color;
        cached.text = _textSpanFor41(color);
      }
      return cached;
    }
    _textPainter41Color = color;
    final painter = TextPainter(
      text: _textSpanFor41(color),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      maxLines: 4,
    )..layout(maxWidth: 230);
    return _textPainter41 = painter;
  }

  TextPainter? _textPainter43;
  Color? _textPainter43Color;
  Offset _textPainter43Offset = Offset.zero;

  TextSpan _textSpanFor43(Color color) {
    return TextSpan(
      text: overrides.jobCard06TextPostedTimeText ?? '1 dia atrás',
      style: TextStyle(
        color: color,
        fontFamily: 'Inter',
        fontSize: 9.7354,
        fontWeight: FontWeight.w500,
        height: 1.2,
      ),
    );
  }

  TextPainter _textPainterFor43(Color color) {
    final cached = _textPainter43;
    if (cached != null) {
      if (_textPainter43Color != color) {
        _textPainter43Color = color;
        cached.text = _textSpanFor43(color);
      }
      return cached;
    }
    _textPainter43Color = color;
    final painter = TextPainter(
      text: _textSpanFor43(color),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(maxWidth: double.infinity);
    _textPainter43Offset = Offset(
      0,
      -painter.computeDistanceToActualBaseline(TextBaseline.alphabetic),
    );
    return _textPainter43 = painter;
  }

  TextPainter? _textPainter44;
  Color? _textPainter44Color;
  Offset _textPainter44Offset = Offset.zero;

  TextSpan _textSpanFor44(Color color) {
    return TextSpan(
      text: overrides.jobCard06TextJobTitleText ?? 'Garçom',
      style: TextStyle(
        color: color,
        fontFamily: 'Inter',
        fontSize: 16.2412,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.3248,
      ),
    );
  }

  TextPainter _textPainterFor44(Color color) {
    final cached = _textPainter44;
    if (cached != null) {
      if (_textPainter44Color != color) {
        _textPainter44Color = color;
        cached.text = _textSpanFor44(color);
      }
      return cached;
    }
    _textPainter44Color = color;
    final painter = TextPainter(
      text: _textSpanFor44(color),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(maxWidth: double.infinity);
    _textPainter44Offset = Offset(
      0,
      -painter.computeDistanceToActualBaseline(TextBaseline.alphabetic),
    );
    return _textPainter44 = painter;
  }

  TextPainter? _textPainter45;
  Color? _textPainter45Color;
  Offset _textPainter45Offset = Offset.zero;

  TextSpan _textSpanFor45(Color color) {
    return TextSpan(
      text: overrides.jobCard06TextPayText ?? r'R$100/dia',
      style: TextStyle(
        color: color,
        fontFamily: 'Inter',
        fontSize: 18.59,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.3718,
      ),
    );
  }

  TextPainter _textPainterFor45(Color color) {
    final cached = _textPainter45;
    if (cached != null) {
      if (_textPainter45Color != color) {
        _textPainter45Color = color;
        cached.text = _textSpanFor45(color);
      }
      return cached;
    }
    _textPainter45Color = color;
    final painter = TextPainter(
      text: _textSpanFor45(color),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(maxWidth: double.infinity);
    _textPainter45Offset = Offset(
      0,
      -painter.computeDistanceToActualBaseline(TextBaseline.alphabetic),
    );
    return _textPainter45 = painter;
  }

  TextPainter? _textPainter46;
  Color? _textPainter46Color;

  TextSpan _textSpanFor46(Color color) {
    return TextSpan(
      text:
          overrides.jobCard06TextDescriptionText ??
          'Preciso de um garçom para 3 dias em um evento. Precisa ter experiência e já ter participado de eventos',
      style: TextStyle(
        color: color,
        fontFamily: 'Inter',
        fontSize: 11.3405,
        fontWeight: FontWeight.w500,
        height: 1.3227,
        letterSpacing: -0.2268,
      ),
    );
  }

  TextPainter _textPainterFor46(Color color) {
    final cached = _textPainter46;
    if (cached != null) {
      if (_textPainter46Color != color) {
        _textPainter46Color = color;
        cached.text = _textSpanFor46(color);
      }
      return cached;
    }
    _textPainter46Color = color;
    final painter = TextPainter(
      text: _textSpanFor46(color),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      maxLines: 4,
    )..layout(maxWidth: 230);
    return _textPainter46 = painter;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final progress = _animationProgress?.value ?? _fixedProgress;
    final frame = math.min(
      1079.999999,
      progress * _CataquiJobCardsCarousel._totalFrames,
    );

    canvas.save();
    if (clip) canvas.clipRect(_canvasRect);
    canvas.scale(_canvasScaleX, _canvasScaleY);

    _drawJobCard06SideInstance11(canvas, frame, 1);
    _drawJobCard05SideInstance10(canvas, frame, 1);
    _drawJobCard04SideInstance9(canvas, frame, 1);
    _drawJobCard03SideInstance8(canvas, frame, 1);
    _drawJobCard02SideInstance7(canvas, frame, 1);
    _drawJobCard01SideInstance6(canvas, frame, 1);
    _drawJobCard06FrontInstance5(canvas, frame, 1);
    _drawJobCard05FrontInstance4(canvas, frame, 1);
    _drawJobCard04FrontInstance3(canvas, frame, 1);
    _drawJobCard03FrontInstance2(canvas, frame, 1);
    _drawJobCard02FrontInstance1(canvas, frame, 1);
    _drawJobCard01FrontInstance0(canvas, frame, 1);

    canvas.restore();
  }

  void _drawJobCard01FrontInstance0(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * _keyframes0Opacity(frame) / 100;
    if (layerOpacity <= 0) return;
    final rotation = _keyframes0Rotation(frame);
    canvas.save();
    // Parent transform: Job Card 01 / Orbit Controller
    canvas.translate(229, 649.5);
    canvas.rotate(_keyframes12Rotation(frame) * math.pi / 180);
    canvas.translate(-229, -649.5);
    canvas.translate(229, 249.5);
    canvas.rotate(rotation * math.pi / 180);
    canvas.translate(-145.5, -176.5);
    canvas.clipRect(const Rect.fromLTWH(0, 0, 291, 353));
    _drawJobCard01Artwork22(canvas, frame, layerOpacity);
    _drawJobCard01TextDescription21(canvas, frame, layerOpacity);
    _drawJobCard01TextPay20(canvas, frame, layerOpacity);
    _drawJobCard01TextJobTitle19(canvas, frame, layerOpacity);
    _drawJobCard01TextPostedTime18(canvas, frame, layerOpacity);
    canvas.restore();
  }

  void _drawJobCard02FrontInstance1(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * _keyframes1Opacity(frame) / 100;
    if (layerOpacity <= 0) return;
    final rotation = _keyframes1Rotation(frame);
    canvas.save();
    // Parent transform: Job Card 02 / Orbit Controller
    canvas.translate(229, 649.5);
    canvas.rotate(_keyframes13Rotation(frame) * math.pi / 180);
    canvas.translate(-229, -649.5);
    canvas.translate(229, 249.5);
    canvas.rotate(rotation * math.pi / 180);
    canvas.translate(-145.5, -176.5);
    canvas.clipRect(const Rect.fromLTWH(0, 0, 291, 353));
    _drawJobCard02Artwork27(canvas, frame, layerOpacity);
    _drawJobCard02TextDescription26(canvas, frame, layerOpacity);
    _drawJobCard02TextPay25(canvas, frame, layerOpacity);
    _drawJobCard02TextJobTitle24(canvas, frame, layerOpacity);
    _drawJobCard02TextPostedTime23(canvas, frame, layerOpacity);
    canvas.restore();
  }

  void _drawJobCard03FrontInstance2(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * _keyframes2Opacity(frame) / 100;
    if (layerOpacity <= 0) return;
    final rotation = _keyframes2Rotation(frame);
    canvas.save();
    // Parent transform: Job Card 03 / Orbit Controller
    canvas.translate(229, 649.5);
    canvas.rotate(_keyframes14Rotation(frame) * math.pi / 180);
    canvas.translate(-229, -649.5);
    canvas.translate(229, 249.5);
    canvas.rotate(rotation * math.pi / 180);
    canvas.translate(-145.5, -176.5);
    canvas.clipRect(const Rect.fromLTWH(0, 0, 291, 353));
    _drawJobCard03Artwork32(canvas, frame, layerOpacity);
    _drawJobCard03TextDescription31(canvas, frame, layerOpacity);
    _drawJobCard03TextPay30(canvas, frame, layerOpacity);
    _drawJobCard03TextJobTitle29(canvas, frame, layerOpacity);
    _drawJobCard03TextPostedTime28(canvas, frame, layerOpacity);
    canvas.restore();
  }

  void _drawJobCard04FrontInstance3(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * _keyframes3Opacity(frame) / 100;
    if (layerOpacity <= 0) return;
    final rotation = _keyframes3Rotation(frame);
    canvas.save();
    // Parent transform: Job Card 04 / Orbit Controller
    canvas.translate(229, 649.5);
    canvas.rotate(_keyframes15Rotation(frame) * math.pi / 180);
    canvas.translate(-229, -649.5);
    canvas.translate(229, 249.5);
    canvas.rotate(rotation * math.pi / 180);
    canvas.translate(-145.5, -176.5);
    canvas.clipRect(const Rect.fromLTWH(0, 0, 291, 353));
    _drawJobCard04Artwork37(canvas, frame, layerOpacity);
    _drawJobCard04TextDescription36(canvas, frame, layerOpacity);
    _drawJobCard04TextPay35(canvas, frame, layerOpacity);
    _drawJobCard04TextJobTitle34(canvas, frame, layerOpacity);
    _drawJobCard04TextPostedTime33(canvas, frame, layerOpacity);
    canvas.restore();
  }

  void _drawJobCard05FrontInstance4(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * _keyframes4Opacity(frame) / 100;
    if (layerOpacity <= 0) return;
    final rotation = _keyframes4Rotation(frame);
    canvas.save();
    // Parent transform: Job Card 05 / Orbit Controller
    canvas.translate(229, 649.5);
    canvas.rotate(_keyframes16Rotation(frame) * math.pi / 180);
    canvas.translate(-229, -649.5);
    canvas.translate(229, 249.5);
    canvas.rotate(rotation * math.pi / 180);
    canvas.translate(-145.5, -176.5);
    canvas.clipRect(const Rect.fromLTWH(0, 0, 291, 353));
    _drawJobCard05Artwork42(canvas, frame, layerOpacity);
    _drawJobCard05TextDescription41(canvas, frame, layerOpacity);
    _drawJobCard05TextPay40(canvas, frame, layerOpacity);
    _drawJobCard05TextJobTitle39(canvas, frame, layerOpacity);
    _drawJobCard05TextPostedTime38(canvas, frame, layerOpacity);
    canvas.restore();
  }

  void _drawJobCard06FrontInstance5(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * _keyframes5Opacity(frame) / 100;
    if (layerOpacity <= 0) return;
    final rotation = _keyframes5Rotation(frame);
    canvas.save();
    // Parent transform: Job Card 06 / Orbit Controller
    canvas.translate(229, 649.5);
    canvas.rotate(_keyframes17Rotation(frame) * math.pi / 180);
    canvas.translate(-229, -649.5);
    canvas.translate(229, 249.5);
    canvas.rotate(rotation * math.pi / 180);
    canvas.translate(-145.5, -176.5);
    canvas.clipRect(const Rect.fromLTWH(0, 0, 291, 353));
    _drawJobCard06Artwork47(canvas, frame, layerOpacity);
    _drawJobCard06TextDescription46(canvas, frame, layerOpacity);
    _drawJobCard06TextPay45(canvas, frame, layerOpacity);
    _drawJobCard06TextJobTitle44(canvas, frame, layerOpacity);
    _drawJobCard06TextPostedTime43(canvas, frame, layerOpacity);
    canvas.restore();
  }

  void _drawJobCard01SideInstance6(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * _keyframes6Opacity(frame) / 100;
    if (layerOpacity <= 0) return;
    final rotation = _keyframes6Rotation(frame);
    canvas.save();
    // Parent transform: Job Card 01 / Orbit Controller
    canvas.translate(229, 649.5);
    canvas.rotate(_keyframes12Rotation(frame) * math.pi / 180);
    canvas.translate(-229, -649.5);
    canvas.translate(229, 249.5);
    canvas.rotate(rotation * math.pi / 180);
    canvas.translate(-145.5, -176.5);
    canvas.clipRect(const Rect.fromLTWH(0, 0, 291, 353));
    _drawJobCard01Artwork22(canvas, frame, layerOpacity);
    _drawJobCard01TextDescription21(canvas, frame, layerOpacity);
    _drawJobCard01TextPay20(canvas, frame, layerOpacity);
    _drawJobCard01TextJobTitle19(canvas, frame, layerOpacity);
    _drawJobCard01TextPostedTime18(canvas, frame, layerOpacity);
    canvas.restore();
  }

  void _drawJobCard02SideInstance7(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * _keyframes7Opacity(frame) / 100;
    if (layerOpacity <= 0) return;
    final rotation = _keyframes7Rotation(frame);
    canvas.save();
    // Parent transform: Job Card 02 / Orbit Controller
    canvas.translate(229, 649.5);
    canvas.rotate(_keyframes13Rotation(frame) * math.pi / 180);
    canvas.translate(-229, -649.5);
    canvas.translate(229, 249.5);
    canvas.rotate(rotation * math.pi / 180);
    canvas.translate(-145.5, -176.5);
    canvas.clipRect(const Rect.fromLTWH(0, 0, 291, 353));
    _drawJobCard02Artwork27(canvas, frame, layerOpacity);
    _drawJobCard02TextDescription26(canvas, frame, layerOpacity);
    _drawJobCard02TextPay25(canvas, frame, layerOpacity);
    _drawJobCard02TextJobTitle24(canvas, frame, layerOpacity);
    _drawJobCard02TextPostedTime23(canvas, frame, layerOpacity);
    canvas.restore();
  }

  void _drawJobCard03SideInstance8(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * _keyframes8Opacity(frame) / 100;
    if (layerOpacity <= 0) return;
    final rotation = _keyframes8Rotation(frame);
    canvas.save();
    // Parent transform: Job Card 03 / Orbit Controller
    canvas.translate(229, 649.5);
    canvas.rotate(_keyframes14Rotation(frame) * math.pi / 180);
    canvas.translate(-229, -649.5);
    canvas.translate(229, 249.5);
    canvas.rotate(rotation * math.pi / 180);
    canvas.translate(-145.5, -176.5);
    canvas.clipRect(const Rect.fromLTWH(0, 0, 291, 353));
    _drawJobCard03Artwork32(canvas, frame, layerOpacity);
    _drawJobCard03TextDescription31(canvas, frame, layerOpacity);
    _drawJobCard03TextPay30(canvas, frame, layerOpacity);
    _drawJobCard03TextJobTitle29(canvas, frame, layerOpacity);
    _drawJobCard03TextPostedTime28(canvas, frame, layerOpacity);
    canvas.restore();
  }

  void _drawJobCard04SideInstance9(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * _keyframes9Opacity(frame) / 100;
    if (layerOpacity <= 0) return;
    final rotation = _keyframes9Rotation(frame);
    canvas.save();
    // Parent transform: Job Card 04 / Orbit Controller
    canvas.translate(229, 649.5);
    canvas.rotate(_keyframes15Rotation(frame) * math.pi / 180);
    canvas.translate(-229, -649.5);
    canvas.translate(229, 249.5);
    canvas.rotate(rotation * math.pi / 180);
    canvas.translate(-145.5, -176.5);
    canvas.clipRect(const Rect.fromLTWH(0, 0, 291, 353));
    _drawJobCard04Artwork37(canvas, frame, layerOpacity);
    _drawJobCard04TextDescription36(canvas, frame, layerOpacity);
    _drawJobCard04TextPay35(canvas, frame, layerOpacity);
    _drawJobCard04TextJobTitle34(canvas, frame, layerOpacity);
    _drawJobCard04TextPostedTime33(canvas, frame, layerOpacity);
    canvas.restore();
  }

  void _drawJobCard05SideInstance10(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * _keyframes10Opacity(frame) / 100;
    if (layerOpacity <= 0) return;
    final rotation = _keyframes10Rotation(frame);
    canvas.save();
    // Parent transform: Job Card 05 / Orbit Controller
    canvas.translate(229, 649.5);
    canvas.rotate(_keyframes16Rotation(frame) * math.pi / 180);
    canvas.translate(-229, -649.5);
    canvas.translate(229, 249.5);
    canvas.rotate(rotation * math.pi / 180);
    canvas.translate(-145.5, -176.5);
    canvas.clipRect(const Rect.fromLTWH(0, 0, 291, 353));
    _drawJobCard05Artwork42(canvas, frame, layerOpacity);
    _drawJobCard05TextDescription41(canvas, frame, layerOpacity);
    _drawJobCard05TextPay40(canvas, frame, layerOpacity);
    _drawJobCard05TextJobTitle39(canvas, frame, layerOpacity);
    _drawJobCard05TextPostedTime38(canvas, frame, layerOpacity);
    canvas.restore();
  }

  void _drawJobCard06SideInstance11(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * _keyframes11Opacity(frame) / 100;
    if (layerOpacity <= 0) return;
    final rotation = _keyframes11Rotation(frame);
    canvas.save();
    // Parent transform: Job Card 06 / Orbit Controller
    canvas.translate(229, 649.5);
    canvas.rotate(_keyframes17Rotation(frame) * math.pi / 180);
    canvas.translate(-229, -649.5);
    canvas.translate(229, 249.5);
    canvas.rotate(rotation * math.pi / 180);
    canvas.translate(-145.5, -176.5);
    canvas.clipRect(const Rect.fromLTWH(0, 0, 291, 353));
    _drawJobCard06Artwork47(canvas, frame, layerOpacity);
    _drawJobCard06TextDescription46(canvas, frame, layerOpacity);
    _drawJobCard06TextPay45(canvas, frame, layerOpacity);
    _drawJobCard06TextJobTitle44(canvas, frame, layerOpacity);
    _drawJobCard06TextPostedTime43(canvas, frame, layerOpacity);
    canvas.restore();
  }

  void _drawJobCard01TextPostedTime18(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * 1;
    if (layerOpacity <= 0) return;
    canvas.save();
    canvas.translate(30.8906, 38.8566);
    final textColor = _dotdartApplyOpacity(
      overrides.jobCard01TextPostedTimeTextColor ?? const Color(0xff676261),
      layerOpacity,
    );
    final textPainter = _textPainterFor18(textColor);
    textPainter.paint(canvas, _textPainter18Offset);
    canvas.restore();
  }

  void _drawJobCard01TextJobTitle19(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * 1;
    if (layerOpacity <= 0) return;
    canvas.save();
    canvas.translate(31.5391, 62.9059);
    final textColor = _dotdartApplyOpacity(
      overrides.jobCard01TextJobTitleTextColor ?? const Color(0xff000000),
      layerOpacity,
    );
    final textPainter = _textPainterFor19(textColor);
    textPainter.paint(canvas, _textPainter19Offset);
    canvas.restore();
  }

  void _drawJobCard01TextPay20(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * 1;
    if (layerOpacity <= 0) return;
    canvas.save();
    canvas.translate(31.6094, 88.9631);
    final textColor = _dotdartApplyOpacity(
      overrides.jobCard01TextPayTextColor ?? const Color(0xff00bb41),
      layerOpacity,
    );
    final textPainter = _textPainterFor20(textColor);
    textPainter.paint(canvas, _textPainter20Offset);
    canvas.restore();
  }

  void _drawJobCard01TextDescription21(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * 1;
    if (layerOpacity <= 0) return;
    canvas.save();
    canvas.translate(31.0391, 98.077);
    final textColor = _dotdartApplyOpacity(
      overrides.jobCard01TextDescriptionTextColor ?? const Color(0xff676261),
      layerOpacity,
    );
    final textPainter = _textPainterFor21(textColor);
    canvas.save();
    canvas.clipRect(const Rect.fromLTWH(0, 0, 230, 60));
    textPainter.paint(canvas, Offset.zero);
    canvas.restore();
    canvas.restore();
  }

  void _drawJobCard01Artwork22(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * 1;
    if (layerOpacity <= 0) return;
    canvas.save();
    canvas.clipPath(__maskPath22_0);
    // Group: Job Card 01 / Surface / Base
    final fillPaint4_0 = _fillPaint
      ..color = _dotdartApplyOpacity(
        overrides.jobCard01ArtworkColor5 ?? const Color(0xfff8f4f3),
        layerOpacity * 1,
      );
    canvas.drawPath(__path22_4_0, fillPaint4_0);
    // Group: Job Card 01 / Map / Style 01
    final fillPaint3_0 = _fillPaint
      ..color = _dotdartApplyOpacity(
        overrides.jobCard01ArtworkColor4 ?? const Color(0xffcdeafa),
        layerOpacity * 1,
      );
    canvas.drawPath(__path22_3_0, fillPaint3_0);
    // Group: Job Card 01 / Map / Style 02
    final compoundFillPaint2 = _fillPaint
      ..color = _dotdartApplyOpacity(
        overrides.jobCard01ArtworkColor3 ?? const Color(0xffcaf1d8),
        layerOpacity * 1,
      );
    canvas.drawPath(_compoundFillPath22_2, compoundFillPaint2);
    // Group: Job Card 01 / Map / Style 03
    final compoundStrokePaint1 = _strokePaint
      ..color = _dotdartApplyOpacity(
        overrides.jobCard01ArtworkColor2 ?? const Color(0xfffdfefe),
        layerOpacity * 1,
      )
      ..strokeWidth = 1.8743
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(_compoundStrokePath22_1, compoundStrokePaint1);
    // Group: Job Card 01 / Surface / Header
    final fillPaint0_0 = _fillPaint
      ..color = _dotdartApplyOpacity(
        overrides.jobCard01ArtworkColor1 ?? const Color(0xffffffff),
        layerOpacity * 1,
      );
    canvas.drawPath(__path22_0_0, fillPaint0_0);
    canvas.restore();
  }

  void _drawJobCard02TextPostedTime23(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * 1;
    if (layerOpacity <= 0) return;
    canvas.save();
    canvas.translate(30.8906, 38.8566);
    final textColor = _dotdartApplyOpacity(
      overrides.jobCard02TextPostedTimeTextColor ?? const Color(0xff676261),
      layerOpacity,
    );
    final textPainter = _textPainterFor23(textColor);
    textPainter.paint(canvas, _textPainter23Offset);
    canvas.restore();
  }

  void _drawJobCard02TextJobTitle24(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * 1;
    if (layerOpacity <= 0) return;
    canvas.save();
    canvas.translate(31.5391, 62.9059);
    final textColor = _dotdartApplyOpacity(
      overrides.jobCard02TextJobTitleTextColor ?? const Color(0xff000000),
      layerOpacity,
    );
    final textPainter = _textPainterFor24(textColor);
    textPainter.paint(canvas, _textPainter24Offset);
    canvas.restore();
  }

  void _drawJobCard02TextPay25(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * 1;
    if (layerOpacity <= 0) return;
    canvas.save();
    canvas.translate(31.6094, 88.9631);
    final textColor = _dotdartApplyOpacity(
      overrides.jobCard02TextPayTextColor ?? const Color(0xff00bb41),
      layerOpacity,
    );
    final textPainter = _textPainterFor25(textColor);
    textPainter.paint(canvas, _textPainter25Offset);
    canvas.restore();
  }

  void _drawJobCard02TextDescription26(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * 1;
    if (layerOpacity <= 0) return;
    canvas.save();
    canvas.translate(31.0391, 98.077);
    final textColor = _dotdartApplyOpacity(
      overrides.jobCard02TextDescriptionTextColor ?? const Color(0xff676261),
      layerOpacity,
    );
    final textPainter = _textPainterFor26(textColor);
    canvas.save();
    canvas.clipRect(const Rect.fromLTWH(0, 0, 230, 60));
    textPainter.paint(canvas, Offset.zero);
    canvas.restore();
    canvas.restore();
  }

  void _drawJobCard02Artwork27(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * 1;
    if (layerOpacity <= 0) return;
    canvas.save();
    canvas.clipPath(__maskPath27_0);
    // Group: Job Card 02 / Surface / Base
    final fillPaint2_0 = _fillPaint
      ..color = _dotdartApplyOpacity(
        overrides.jobCard02ArtworkColor2 ?? const Color(0xfff8f4f3),
        layerOpacity * 1,
      );
    canvas.drawPath(__path27_2_0, fillPaint2_0);
    // Group: Job Card 02 / Map / Style 01
    final compoundFillPaint1 = _fillPaint
      ..color = _dotdartApplyOpacity(
        overrides.jobCard02ArtworkColor1 ?? const Color(0xffffffff),
        layerOpacity * 1,
      );
    canvas.drawPath(_compoundFillPath27_1, compoundFillPaint1);
    // Group: Job Card 02 / Surface / Header
    final fillPaint0_0 = _fillPaint
      ..color = _dotdartApplyOpacity(
        overrides.jobCard02ArtworkColor1 ?? const Color(0xffffffff),
        layerOpacity * 1,
      );
    canvas.drawPath(__path27_0_0, fillPaint0_0);
    canvas.restore();
  }

  void _drawJobCard03TextPostedTime28(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * 1;
    if (layerOpacity <= 0) return;
    canvas.save();
    canvas.translate(30.8906, 38.8566);
    final textColor = _dotdartApplyOpacity(
      overrides.jobCard03TextPostedTimeTextColor ?? const Color(0xff676261),
      layerOpacity,
    );
    final textPainter = _textPainterFor28(textColor);
    textPainter.paint(canvas, _textPainter28Offset);
    canvas.restore();
  }

  void _drawJobCard03TextJobTitle29(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * 1;
    if (layerOpacity <= 0) return;
    canvas.save();
    canvas.translate(31.5391, 62.9059);
    final textColor = _dotdartApplyOpacity(
      overrides.jobCard03TextJobTitleTextColor ?? const Color(0xff000000),
      layerOpacity,
    );
    final textPainter = _textPainterFor29(textColor);
    textPainter.paint(canvas, _textPainter29Offset);
    canvas.restore();
  }

  void _drawJobCard03TextPay30(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * 1;
    if (layerOpacity <= 0) return;
    canvas.save();
    canvas.translate(31.6094, 88.9631);
    final textColor = _dotdartApplyOpacity(
      overrides.jobCard03TextPayTextColor ?? const Color(0xff00bb41),
      layerOpacity,
    );
    final textPainter = _textPainterFor30(textColor);
    textPainter.paint(canvas, _textPainter30Offset);
    canvas.restore();
  }

  void _drawJobCard03TextDescription31(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * 1;
    if (layerOpacity <= 0) return;
    canvas.save();
    canvas.translate(31.0391, 98.077);
    final textColor = _dotdartApplyOpacity(
      overrides.jobCard03TextDescriptionTextColor ?? const Color(0xff676261),
      layerOpacity,
    );
    final textPainter = _textPainterFor31(textColor);
    canvas.save();
    canvas.clipRect(const Rect.fromLTWH(0, 0, 230, 60));
    textPainter.paint(canvas, Offset.zero);
    canvas.restore();
    canvas.restore();
  }

  void _drawJobCard03Artwork32(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * 1;
    if (layerOpacity <= 0) return;
    canvas.save();
    canvas.clipPath(__maskPath32_0);
    // Group: Job Card 03 / Surface / Base
    final fillPaint3_0 = _fillPaint
      ..color = _dotdartApplyOpacity(
        overrides.jobCard03ArtworkColor4 ?? const Color(0xfff8f4f3),
        layerOpacity * 1,
      );
    canvas.drawPath(__path32_3_0, fillPaint3_0);
    // Group: Job Card 03 / Map / Style 01
    final compoundFillPaint2 = _fillPaint
      ..color = _dotdartApplyOpacity(
        overrides.jobCard03ArtworkColor3 ?? const Color(0xffcaf1d8),
        layerOpacity * 1,
      );
    canvas.drawPath(_compoundFillPath32_2, compoundFillPaint2);
    // Group: Job Card 03 / Map / Style 02
    final compoundStrokePaint1 = _strokePaint
      ..color = _dotdartApplyOpacity(
        overrides.jobCard03ArtworkColor2 ?? const Color(0xfffdfefe),
        layerOpacity * 1,
      )
      ..strokeWidth = 1.8743
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(_compoundStrokePath32_1, compoundStrokePaint1);
    // Group: Job Card 03 / Surface / Header
    final fillPaint0_0 = _fillPaint
      ..color = _dotdartApplyOpacity(
        overrides.jobCard03ArtworkColor1 ?? const Color(0xffffffff),
        layerOpacity * 1,
      );
    canvas.drawPath(__path32_0_0, fillPaint0_0);
    canvas.restore();
  }

  void _drawJobCard04TextPostedTime33(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * 1;
    if (layerOpacity <= 0) return;
    canvas.save();
    canvas.translate(30.8906, 38.8566);
    final textColor = _dotdartApplyOpacity(
      overrides.jobCard04TextPostedTimeTextColor ?? const Color(0xff676261),
      layerOpacity,
    );
    final textPainter = _textPainterFor33(textColor);
    textPainter.paint(canvas, _textPainter33Offset);
    canvas.restore();
  }

  void _drawJobCard04TextJobTitle34(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * 1;
    if (layerOpacity <= 0) return;
    canvas.save();
    canvas.translate(31.5391, 62.9059);
    final textColor = _dotdartApplyOpacity(
      overrides.jobCard04TextJobTitleTextColor ?? const Color(0xff000000),
      layerOpacity,
    );
    final textPainter = _textPainterFor34(textColor);
    textPainter.paint(canvas, _textPainter34Offset);
    canvas.restore();
  }

  void _drawJobCard04TextPay35(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * 1;
    if (layerOpacity <= 0) return;
    canvas.save();
    canvas.translate(31.6094, 88.9631);
    final textColor = _dotdartApplyOpacity(
      overrides.jobCard04TextPayTextColor ?? const Color(0xff00bb41),
      layerOpacity,
    );
    final textPainter = _textPainterFor35(textColor);
    textPainter.paint(canvas, _textPainter35Offset);
    canvas.restore();
  }

  void _drawJobCard04TextDescription36(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * 1;
    if (layerOpacity <= 0) return;
    canvas.save();
    canvas.translate(31.0391, 98.077);
    final textColor = _dotdartApplyOpacity(
      overrides.jobCard04TextDescriptionTextColor ?? const Color(0xff676261),
      layerOpacity,
    );
    final textPainter = _textPainterFor36(textColor);
    canvas.save();
    canvas.clipRect(const Rect.fromLTWH(0, 0, 230, 60));
    textPainter.paint(canvas, Offset.zero);
    canvas.restore();
    canvas.restore();
  }

  void _drawJobCard04Artwork37(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * 1;
    if (layerOpacity <= 0) return;
    canvas.save();
    canvas.clipPath(__maskPath37_0);
    // Group: Job Card 04 / Surface / Base
    final fillPaint4_0 = _fillPaint
      ..color = _dotdartApplyOpacity(
        overrides.jobCard04ArtworkColor3 ?? const Color(0xfff8f4f3),
        layerOpacity * 1,
      );
    canvas.drawPath(__path37_4_0, fillPaint4_0);
    // Group: Job Card 04 / Map / Style 01
    final fillPaint3_0 = _fillPaint
      ..color = _dotdartApplyOpacity(
        overrides.jobCard04ArtworkColor3 ?? const Color(0xfff8f4f3),
        layerOpacity * 1,
      );
    canvas.drawPath(__path37_3_0, fillPaint3_0);
    // Group: Job Card 04 / Map / Style 02
    final compoundFillPaint2 = _fillPaint
      ..color = _dotdartApplyOpacity(
        overrides.jobCard04ArtworkColor2 ?? const Color(0xffcaf1d8),
        layerOpacity * 1,
      );
    canvas.drawPath(_compoundFillPath37_2, compoundFillPaint2);
    // Group: Job Card 04 / Map / Style 03
    final compoundFillPaint1 = _fillPaint
      ..color = _dotdartApplyOpacity(
        overrides.jobCard04ArtworkColor1 ?? const Color(0xffffffff),
        layerOpacity * 1,
      );
    canvas.drawPath(_compoundFillPath37_1, compoundFillPaint1);
    // Group: Job Card 04 / Surface / Header
    final fillPaint0_0 = _fillPaint
      ..color = _dotdartApplyOpacity(
        overrides.jobCard04ArtworkColor1 ?? const Color(0xffffffff),
        layerOpacity * 1,
      );
    canvas.drawPath(__path37_0_0, fillPaint0_0);
    canvas.restore();
  }

  void _drawJobCard05TextPostedTime38(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * 1;
    if (layerOpacity <= 0) return;
    canvas.save();
    canvas.translate(30.8906, 38.8566);
    final textColor = _dotdartApplyOpacity(
      overrides.jobCard05TextPostedTimeTextColor ?? const Color(0xff676261),
      layerOpacity,
    );
    final textPainter = _textPainterFor38(textColor);
    textPainter.paint(canvas, _textPainter38Offset);
    canvas.restore();
  }

  void _drawJobCard05TextJobTitle39(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * 1;
    if (layerOpacity <= 0) return;
    canvas.save();
    canvas.translate(31.5391, 62.9059);
    final textColor = _dotdartApplyOpacity(
      overrides.jobCard05TextJobTitleTextColor ?? const Color(0xff000000),
      layerOpacity,
    );
    final textPainter = _textPainterFor39(textColor);
    textPainter.paint(canvas, _textPainter39Offset);
    canvas.restore();
  }

  void _drawJobCard05TextPay40(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * 1;
    if (layerOpacity <= 0) return;
    canvas.save();
    canvas.translate(31.6094, 88.9631);
    final textColor = _dotdartApplyOpacity(
      overrides.jobCard05TextPayTextColor ?? const Color(0xff00bb41),
      layerOpacity,
    );
    final textPainter = _textPainterFor40(textColor);
    textPainter.paint(canvas, _textPainter40Offset);
    canvas.restore();
  }

  void _drawJobCard05TextDescription41(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * 1;
    if (layerOpacity <= 0) return;
    canvas.save();
    canvas.translate(31.0391, 98.077);
    final textColor = _dotdartApplyOpacity(
      overrides.jobCard05TextDescriptionTextColor ?? const Color(0xff676261),
      layerOpacity,
    );
    final textPainter = _textPainterFor41(textColor);
    canvas.save();
    canvas.clipRect(const Rect.fromLTWH(0, 0, 230, 60));
    textPainter.paint(canvas, Offset.zero);
    canvas.restore();
    canvas.restore();
  }

  void _drawJobCard05Artwork42(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * 1;
    if (layerOpacity <= 0) return;
    canvas.save();
    canvas.clipPath(__maskPath42_0);
    // Group: Job Card 05 / Surface / Base
    final fillPaint4_0 = _fillPaint
      ..color = _dotdartApplyOpacity(
        overrides.jobCard05ArtworkColor3 ?? const Color(0xfff8f4f3),
        layerOpacity * 1,
      );
    canvas.drawPath(__path42_4_0, fillPaint4_0);
    // Group: Job Card 05 / Map / Style 01
    final fillPaint3_0 = _fillPaint
      ..color = _dotdartApplyOpacity(
        overrides.jobCard05ArtworkColor3 ?? const Color(0xfff8f4f3),
        layerOpacity * 1,
      );
    canvas.drawPath(__path42_3_0, fillPaint3_0);
    // Group: Job Card 05 / Map / Style 02
    final fillPaint2_0 = _fillPaint
      ..color = _dotdartApplyOpacity(
        overrides.jobCard05ArtworkColor2 ?? const Color(0xffb2dbf7),
        layerOpacity * 1,
      );
    canvas.drawPath(__path42_2_0, fillPaint2_0);
    // Group: Job Card 05 / Map / Style 03
    final compoundFillPaint1 = _fillPaint
      ..color = _dotdartApplyOpacity(
        overrides.jobCard05ArtworkColor1 ?? const Color(0xffffffff),
        layerOpacity * 1,
      );
    canvas.drawPath(_compoundFillPath42_1, compoundFillPaint1);
    // Group: Job Card 05 / Surface / Header
    final fillPaint0_0 = _fillPaint
      ..color = _dotdartApplyOpacity(
        overrides.jobCard05ArtworkColor1 ?? const Color(0xffffffff),
        layerOpacity * 1,
      );
    canvas.drawPath(__path42_0_0, fillPaint0_0);
    canvas.restore();
  }

  void _drawJobCard06TextPostedTime43(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * 1;
    if (layerOpacity <= 0) return;
    canvas.save();
    canvas.translate(30.8906, 38.8566);
    final textColor = _dotdartApplyOpacity(
      overrides.jobCard06TextPostedTimeTextColor ?? const Color(0xff676261),
      layerOpacity,
    );
    final textPainter = _textPainterFor43(textColor);
    textPainter.paint(canvas, _textPainter43Offset);
    canvas.restore();
  }

  void _drawJobCard06TextJobTitle44(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * 1;
    if (layerOpacity <= 0) return;
    canvas.save();
    canvas.translate(31.5391, 62.9059);
    final textColor = _dotdartApplyOpacity(
      overrides.jobCard06TextJobTitleTextColor ?? const Color(0xff000000),
      layerOpacity,
    );
    final textPainter = _textPainterFor44(textColor);
    textPainter.paint(canvas, _textPainter44Offset);
    canvas.restore();
  }

  void _drawJobCard06TextPay45(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * 1;
    if (layerOpacity <= 0) return;
    canvas.save();
    canvas.translate(31.6094, 88.9631);
    final textColor = _dotdartApplyOpacity(
      overrides.jobCard06TextPayTextColor ?? const Color(0xff00bb41),
      layerOpacity,
    );
    final textPainter = _textPainterFor45(textColor);
    textPainter.paint(canvas, _textPainter45Offset);
    canvas.restore();
  }

  void _drawJobCard06TextDescription46(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * 1;
    if (layerOpacity <= 0) return;
    canvas.save();
    canvas.translate(31.0391, 98.077);
    final textColor = _dotdartApplyOpacity(
      overrides.jobCard06TextDescriptionTextColor ?? const Color(0xff676261),
      layerOpacity,
    );
    final textPainter = _textPainterFor46(textColor);
    canvas.save();
    canvas.clipRect(const Rect.fromLTWH(0, 0, 230, 60));
    textPainter.paint(canvas, Offset.zero);
    canvas.restore();
    canvas.restore();
  }

  void _drawJobCard06Artwork47(
    Canvas canvas,
    double frame,
    double inheritedOpacity,
  ) {
    final layerOpacity = inheritedOpacity * 1;
    if (layerOpacity <= 0) return;
    canvas.save();
    canvas.clipPath(__maskPath47_0);
    // Group: Job Card 06 / Surface / Base
    final fillPaint6_0 = _fillPaint
      ..color = _dotdartApplyOpacity(
        overrides.jobCard06ArtworkColor4 ?? const Color(0xfff8f4f3),
        layerOpacity * 1,
      );
    canvas.drawPath(__path47_6_0, fillPaint6_0);
    // Group: Job Card 06 / Map / Style 01
    final fillPaint5_0 = _fillPaint
      ..color = _dotdartApplyOpacity(
        overrides.jobCard06ArtworkColor5 ?? const Color(0xffb2dbf7),
        layerOpacity * 1,
      );
    canvas.drawPath(__path47_5_0, fillPaint5_0);
    // Group: Job Card 06 / Map / Style 02
    final fillPaint4_0 = _fillPaint
      ..color = _dotdartApplyOpacity(
        overrides.jobCard06ArtworkColor4 ?? const Color(0xfff8f4f3),
        layerOpacity * 1,
      );
    canvas.drawPath(__path47_4_0, fillPaint4_0);
    // Group: Job Card 06 / Map / Style 03
    final fillPaint3_0 = _fillPaint
      ..color = _dotdartApplyOpacity(
        overrides.jobCard06ArtworkColor3 ?? const Color(0xffcbedca),
        layerOpacity * 1,
      );
    canvas.drawPath(__path47_3_0, fillPaint3_0);
    // Group: Job Card 06 / Map / Style 04
    final fillPaint2_0 = _fillPaint
      ..color = _dotdartApplyOpacity(
        overrides.jobCard06ArtworkColor2 ?? const Color(0xff78cc57),
        layerOpacity * 1,
      );
    canvas.drawPath(__path47_2_0, fillPaint2_0);
    // Group: Job Card 06 / Map / Style 05
    final compoundFillPaint1 = _fillPaint
      ..color = _dotdartApplyOpacity(
        overrides.jobCard06ArtworkColor1 ?? const Color(0xffffffff),
        layerOpacity * 1,
      );
    canvas.drawPath(_compoundFillPath47_1, compoundFillPaint1);
    // Group: Job Card 06 / Surface / Header
    final fillPaint0_0 = _fillPaint
      ..color = _dotdartApplyOpacity(
        overrides.jobCard06ArtworkColor1 ?? const Color(0xffffffff),
        layerOpacity * 1,
      );
    canvas.drawPath(__path47_0_0, fillPaint0_0);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CataquiJobCardsCarouselPainter oldDelegate) {
    return oldDelegate._fixedProgress != _fixedProgress ||
        oldDelegate._canvasScaleX != _canvasScaleX ||
        oldDelegate._canvasScaleY != _canvasScaleY ||
        oldDelegate._canvasRect != _canvasRect ||
        oldDelegate._animationProgress != _animationProgress ||
        oldDelegate.clip != clip ||
        oldDelegate.overrides != overrides;
  }

  void disposeResources() {
    _textPainter18?.dispose();
    _textPainter19?.dispose();
    _textPainter20?.dispose();
    _textPainter21?.dispose();
    _textPainter23?.dispose();
    _textPainter24?.dispose();
    _textPainter25?.dispose();
    _textPainter26?.dispose();
    _textPainter28?.dispose();
    _textPainter29?.dispose();
    _textPainter30?.dispose();
    _textPainter31?.dispose();
    _textPainter33?.dispose();
    _textPainter34?.dispose();
    _textPainter35?.dispose();
    _textPainter36?.dispose();
    _textPainter38?.dispose();
    _textPainter39?.dispose();
    _textPainter40?.dispose();
    _textPainter41?.dispose();
    _textPainter43?.dispose();
    _textPainter44?.dispose();
    _textPainter45?.dispose();
    _textPainter46?.dispose();
  }
}

/// Text and color values that replace defaults in `pulse.json`.
final class PulseOverrides {
  /// Creates Lottie value overrides.
  const PulseOverrides({this.fixtureColor});

  /// Replacement color for the `fixture` Lottie layer.
  final Color? fixtureColor;
}

/// A dotdart-generated animated widget from `assets/lotties/pulse.json`.
///
/// Renders a 1000ms animation
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
    this.clip = true,
    this.progress,
    this.delay = Duration.zero,
    this.duration,
    this.playback = LottiePlayback.once,
    this.respectDisableAnimations = true,
    this.overrides = const PulseOverrides(),
  });

  static const double _lottieWidth = 100;
  static const double _lottieHeight = 100;
  static const int _totalFrames = 30;
  static const Duration _nativeDuration = Duration(milliseconds: 1000);

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Whether painting is clipped to the Lottie canvas bounds.
  final bool clip;

  /// Fixed animation progress from 0 to 1.
  final double? progress;

  /// Non-negative time to wait once before automatic playback starts.
  final Duration delay;

  /// Positive total playback time. When null, uses the duration from the Lottie file.
  final Duration? duration;

  /// Whether automatic playback runs once or loops continuously.
  final LottiePlayback playback;

  /// Whether reduced-motion settings pause playback.
  final bool respectDisableAnimations;

  /// Text and color values that replace defaults from the Lottie file.
  final PulseOverrides overrides;

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
  Duration get lottieDelay => widget.delay;

  @override
  Duration? get lottieDuration => widget.duration;

  @override
  LottiePlayback get lottiePlayback => widget.playback;

  @override
  bool get lottieRespectDisableAnimations => widget.respectDisableAnimations;

  @override
  Duration get lottieNativeDuration => _Pulse._nativeDuration;

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
            animationProgress: widget.progress == null ? _controller : null,
            fixedProgress: (widget.progress ?? 0).clamp(0, 1).toDouble(),
            canvasScaleX: width / _Pulse._lottieWidth,
            canvasScaleY: height / _Pulse._lottieHeight,
            canvasRect: Rect.fromLTWH(0, 0, width, height),
            clip: widget.clip,
            overrides: widget.overrides,
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
    required this._canvasScaleX,
    required this._canvasScaleY,
    required this._canvasRect,
    required this.clip,
    required this.overrides,
    this._animationProgress,
  }) : super(repaint: _animationProgress);

  final double _fixedProgress;
  final double _canvasScaleX;
  final double _canvasScaleY;
  final Rect _canvasRect;
  final Animation<double>? _animationProgress;

  final bool clip;

  final PulseOverrides overrides;

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
    final frame = math.min(29.999999, progress * _Pulse._totalFrames);

    canvas.save();
    if (clip) canvas.clipRect(_canvasRect);
    canvas.scale(_canvasScaleX, _canvasScaleY);

    _drawFixture0(canvas, frame, 1);

    canvas.restore();
  }

  void _drawFixture0(Canvas canvas, double frame, double inheritedOpacity) {
    final layerOpacity = inheritedOpacity * _keyframes0Opacity(frame) / 100;
    if (layerOpacity <= 0) return;
    final scaleX = _keyframes0ScaleX(frame) / 100;
    final scaleY = _keyframes0ScaleY(frame) / 100;
    canvas.save();
    canvas.translate(50, 50);
    canvas.scale(scaleX, scaleY);
    canvas.translate(-50, -50);
    // Group: shape
    final fillPaint0_0 = _fillPaint
      ..color = _dotdartApplyOpacity(
        overrides.fixtureColor ?? const Color(0xffff4a4a),
        layerOpacity * 1,
      );
    canvas.drawRRect(_rrect0_0_0, fillPaint0_0);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PulsePainter oldDelegate) {
    return oldDelegate._fixedProgress != _fixedProgress ||
        oldDelegate._canvasScaleX != _canvasScaleX ||
        oldDelegate._canvasScaleY != _canvasScaleY ||
        oldDelegate._canvasRect != _canvasRect ||
        oldDelegate._animationProgress != _animationProgress ||
        oldDelegate.clip != clip ||
        oldDelegate.overrides != overrides;
  }
}

/// Text and color values that replace defaults in `trim_path.json`.
final class TrimPathOverrides {
  /// Creates Lottie value overrides.
  const TrimPathOverrides({this.lineColor});

  /// Replacement color for the `Line` Lottie layer.
  final Color? lineColor;
}

/// A dotdart-generated animated widget from `assets/lotties/trim_path.json`.
///
/// Renders a 1000ms animation
/// (30 frames at 30.0Hz)
/// on a 100×40 canvas.
/// No Lottie runtime dependency — the animation is drawn
/// entirely via [CustomPainter].
class _TrimPath extends StatefulWidget {
  const _TrimPath({
    super.key,
    this.width,
    this.height,
    this.maintainAspectRatio = true,
    this.clip = true,
    this.progress,
    this.delay = Duration.zero,
    this.duration,
    this.playback = LottiePlayback.once,
    this.respectDisableAnimations = true,
    this.overrides = const TrimPathOverrides(),
  });

  static const double _lottieWidth = 100;
  static const double _lottieHeight = 40;
  static const int _totalFrames = 30;
  static const Duration _nativeDuration = Duration(milliseconds: 1000);

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// When true (default), keeps the native aspect ratio using the larger requested value as the reference. When false, both dimensions are applied as-is and the asset may distort.
  final bool maintainAspectRatio;

  /// Whether painting is clipped to the Lottie canvas bounds.
  final bool clip;

  /// Fixed animation progress from 0 to 1.
  final double? progress;

  /// Non-negative time to wait once before automatic playback starts.
  final Duration delay;

  /// Positive total playback time. When null, uses the duration from the Lottie file.
  final Duration? duration;

  /// Whether automatic playback runs once or loops continuously.
  final LottiePlayback playback;

  /// Whether reduced-motion settings pause playback.
  final bool respectDisableAnimations;

  /// Text and color values that replace defaults from the Lottie file.
  final TrimPathOverrides overrides;

  @override
  State<_TrimPath> createState() => _TrimPathState();
}

class _TrimPathState extends State<_TrimPath>
    with
        SingleTickerProviderStateMixin,
        WidgetsBindingObserver,
        _DotdartLottieAnimationState<_TrimPath> {
  @override
  double? get lottieWidgetWidth => widget.width;

  @override
  double? get lottieWidgetHeight => widget.height;

  @override
  bool get lottieMaintainAspectRatio => widget.maintainAspectRatio;

  @override
  double? get lottieProgress => widget.progress;

  @override
  Duration get lottieDelay => widget.delay;

  @override
  Duration? get lottieDuration => widget.duration;

  @override
  LottiePlayback get lottiePlayback => widget.playback;

  @override
  bool get lottieRespectDisableAnimations => widget.respectDisableAnimations;

  @override
  Duration get lottieNativeDuration => _TrimPath._nativeDuration;

  @override
  double get lottieCanvasWidth => _TrimPath._lottieWidth;

  @override
  double get lottieCanvasHeight => _TrimPath._lottieHeight;

  @override
  Widget buildPainter({required double width, required double height}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _TrimPathPainter(
            animationProgress: widget.progress == null ? _controller : null,
            fixedProgress: (widget.progress ?? 0).clamp(0, 1).toDouble(),
            canvasScaleX: width / _TrimPath._lottieWidth,
            canvasScaleY: height / _TrimPath._lottieHeight,
            canvasRect: Rect.fromLTWH(0, 0, width, height),
            clip: widget.clip,
            overrides: widget.overrides,
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _TrimPathPainter extends CustomPainter {
  _TrimPathPainter({
    required this._fixedProgress,
    required this._canvasScaleX,
    required this._canvasScaleY,
    required this._canvasRect,
    required this.clip,
    required this.overrides,
    this._animationProgress,
  }) : super(repaint: _animationProgress);

  final double _fixedProgress;
  final double _canvasScaleX;
  final double _canvasScaleY;
  final Rect _canvasRect;
  final Animation<double>? _animationProgress;

  final bool clip;

  final TrimPathOverrides overrides;

  final Paint _strokePaint = Paint()..style = PaintingStyle.stroke;

  double _keyframes0Trim0End(double frame) {
    if (frame <= 0) return 0;
    if (frame >= 30) return 100;
    if (frame < 30) {
      final t = frame / 30;
      final eased = t;
      return 0 + 100 * eased;
    }
    return 100;
  }

  static final Path __path0_0_0 = Path()
    ..moveTo(10, 20)
    ..cubicTo(10, 20, 90, 20, 90, 20);

  static final Path _trimSourcePath0_0 = Path()
    ..addPath(__path0_0_0, Offset.zero);

  static final List<PathMetric> _trimMetrics0_0 = _trimSourcePath0_0
      .computeMetrics()
      .toList(growable: false);

  Path _trimPath(
    Path source,
    List<PathMetric> metrics,
    double totalLength,
    double start,
    double end,
    double offset, {
    required bool sequential,
  }) {
    final lower = math.min(start, end).clamp(0, 100).toDouble() / 100;
    final upper = math.max(start, end).clamp(0, 100).toDouble() / 100;
    final visibleFraction = upper - lower;
    if (visibleFraction <= 0) return Path();
    if (visibleFraction >= 1) return source;
    final normalizedStart = (lower + offset / 360) % 1;
    final normalizedEnd = normalizedStart + visibleFraction;
    final result = Path()..fillType = source.fillType;
    if (sequential) {
      if (totalLength <= 0) return result;
      _appendTrimRange(
        result,
        metrics,
        normalizedStart * totalLength,
        math.min(1, normalizedEnd) * totalLength,
      );
      if (normalizedEnd > 1) {
        _appendTrimRange(result, metrics, 0, (normalizedEnd - 1) * totalLength);
      }
      return result;
    }
    for (final metric in metrics) {
      result.addPath(
        metric.extractPath(
          normalizedStart * metric.length,
          math.min(1, normalizedEnd) * metric.length,
        ),
        Offset.zero,
      );
      if (normalizedEnd > 1) {
        result.addPath(
          metric.extractPath(0, (normalizedEnd - 1) * metric.length),
          Offset.zero,
        );
      }
    }
    return result;
  }

  void _appendTrimRange(
    Path destination,
    List<PathMetric> metrics,
    double start,
    double end,
  ) {
    var metricStart = 0.0;
    for (final metric in metrics) {
      final metricEnd = metricStart + metric.length;
      final overlapStart = math.max(start, metricStart);
      final overlapEnd = math.min(end, metricEnd);
      if (overlapStart < overlapEnd) {
        destination.addPath(
          metric.extractPath(
            overlapStart - metricStart,
            overlapEnd - metricStart,
          ),
          Offset.zero,
        );
      }
      metricStart = metricEnd;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final progress = _animationProgress?.value ?? _fixedProgress;
    final frame = math.min(29.999999, progress * _TrimPath._totalFrames);

    canvas.save();
    if (clip) canvas.clipRect(_canvasRect);
    canvas.scale(_canvasScaleX, _canvasScaleY);

    _drawLine0(canvas, frame, 1);

    canvas.restore();
  }

  void _drawLine0(Canvas canvas, double frame, double inheritedOpacity) {
    final layerOpacity = inheritedOpacity * 1;
    if (layerOpacity <= 0) return;
    // Group: Line Group
    final trimmedPath0_0 = _trimPath(
      _trimSourcePath0_0,
      _trimMetrics0_0,
      0,
      0,
      _keyframes0Trim0End(frame),
      0,
      sequential: false,
    );
    final trimStrokePaint0_0 = _strokePaint
      ..color = _dotdartApplyOpacity(
        overrides.lineColor ?? const Color(0xffff4a4b),
        layerOpacity * 1,
      )
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(trimmedPath0_0, trimStrokePaint0_0);
  }

  @override
  bool shouldRepaint(covariant _TrimPathPainter oldDelegate) {
    return oldDelegate._fixedProgress != _fixedProgress ||
        oldDelegate._canvasScaleX != _canvasScaleX ||
        oldDelegate._canvasScaleY != _canvasScaleY ||
        oldDelegate._canvasRect != _canvasRect ||
        oldDelegate._animationProgress != _animationProgress ||
        oldDelegate.clip != clip ||
        oldDelegate.overrides != overrides;
  }
}
