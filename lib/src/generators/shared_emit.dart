/// Emits shared, file-level Dart source that is deduplicated across all
/// widget and painter classes inside a single namespace file.
///
/// The returned strings are raw Dart source fragments (not formatted). The
/// `NamespaceAssembler` places them after imports and before the namespace
/// class.
class SharedEmitter {
  SharedEmitter._();

  /// The file-level color-opacity helper used by every painter.
  ///
  /// Replaces the per-painter `_applyOpacity` static method that was
  /// duplicated once per generated painter class.
  static String applyOpacityFunction() {
    return '''
Color _dotdartApplyOpacity(Color color, double opacity) {
  if (opacity == 1) return color;
  return color.withValues(alpha: math.min(1, math.max(0, color.a * opacity)));
}

''';
  }

  /// The shared sizing mixin for SVG `StatelessWidget` subclasses.
  ///
  /// Provides `_defaultSizeFor` and `build` so each SVG widget only declares
  /// its fields, viewBox getters, and `buildPainter`.
  ///
  /// This also fixes the pre-existing bug where the SVG generator emitted
  /// `widget.width` inside a `StatelessWidget.build()` — `StatelessWidget`
  /// has no `widget` property. The mixin accesses `width` / `height` directly
  /// as instance fields via abstract getters.
  static String svgSizingMixin() {
    return '''
mixin _DotdartSvgSizing on StatelessWidget {
  double? get svgWidgetWidth;
  double? get svgWidgetHeight;
  double get svgNativeWidth;
  double get svgNativeHeight;
  double get svgViewBoxWidth;
  double get svgViewBoxHeight;
  bool get svgMaintainAspectRatio;

  Widget buildPainter({required double width, required double height});

  Size _defaultSizeFor(BoxConstraints constraints) {
    final aspect = svgViewBoxHeight / svgViewBoxWidth;
    var w = svgNativeWidth;
    if (constraints.hasBoundedWidth) {
      w = math.min(w, constraints.maxWidth);
    }
    if (constraints.hasBoundedHeight) {
      w = math.min(w, constraints.maxHeight / aspect);
    }
    return Size(w, w * aspect);
  }

  Size _resolveSize(double aspect) {
    if (svgWidgetWidth != null && svgWidgetHeight != null) {
      if (!svgMaintainAspectRatio) {
        return Size(svgWidgetWidth!, svgWidgetHeight!);
      }
      return svgWidgetWidth! >= svgWidgetHeight!
          ? Size(svgWidgetWidth!, svgWidgetWidth! * aspect)
          : Size(svgWidgetHeight! / aspect, svgWidgetHeight!);
    }

    final w = svgWidgetWidth ?? svgWidgetHeight! / aspect;
    return Size(w, svgWidgetHeight ?? w * aspect);
  }

  @override
  Widget build(BuildContext context) {
    final hasExplicitSize = svgWidgetWidth != null || svgWidgetHeight != null;

    if (!hasExplicitSize) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final size = _defaultSizeFor(constraints);
          return buildPainter(width: size.width, height: size.height);
        },
      );
    }

    final aspect = svgViewBoxHeight / svgViewBoxWidth;
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

''';
  }

  /// The shared animation-lifecycle mixin for Lottie `State` subclasses.
  ///
  /// Provides the controller, lifecycle observers, sizing, and build method.
  /// Each Lottie State only declares widget-field accessors and
  /// `buildPainter`.
  ///
  /// The mixin is parameterized by the widget type `T` so `didUpdateWidget`
  /// receives the correct type.
  static String lottieAnimationStateMixin() {
    return '''
mixin _DotdartLottieAnimationState<T extends StatefulWidget> on State<T>, SingleTickerProviderStateMixin<T>, WidgetsBindingObserver {
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
    final disableAnimations = lottieRespectDisableAnimations &&
        (MediaQuery.maybeDisableAnimationsOf(context) ?? false);
    return lottieProgress == null && _canAnimateForLifecycle && !disableAnimations;
  }

  void _validateTiming() {
    if (lottieDelay.isNegative) {
      throw ArgumentError.value(lottieDelay, 'delay', 'must not be negative');
    }
    if (lottieDuration != null && lottieDuration! <= Duration.zero) {
      throw ArgumentError.value(lottieDuration, 'duration', 'must be greater than zero');
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
    final hasExplicitSize = lottieWidgetWidth != null || lottieWidgetHeight != null;

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

''';
  }

  /// The shared thumbhash painter and image frame builder.
  ///
  /// Emitted once per namespace file when any image or GIF is present.
  static String thumbhashCode() {
    return '''
/// Paints a thumbhash placeholder on a [CustomPainter] canvas.
class _DotdartThumbhashPainter extends CustomPainter {
  _DotdartThumbhashPainter(
    this.thumbWidth,
    this.thumbHeight,
    this.pixels,
    this.dominantColor,
  );

  final int thumbWidth;
  final int thumbHeight;
  final List<Color> pixels;
  final Color dominantColor;
  final Paint _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, _paint..color = dominantColor);
    if (thumbWidth <= 0 || thumbHeight <= 0 || pixels.length < thumbWidth * thumbHeight) {
      return;
    }

    final pixelW = size.width / thumbWidth;
    final pixelH = size.height / thumbHeight;

    for (var y = 0; y < thumbHeight; y++) {
      for (var x = 0; x < thumbWidth; x++) {
        final color = pixels[y * thumbWidth + x];
        if (color.a == 0) continue;
        canvas.drawRect(
          Rect.fromLTWH(
            (x * pixelW).floorToDouble(),
            (y * pixelH).floorToDouble(),
            pixelW.ceilToDouble(),
            pixelH.ceilToDouble(),
          ),
          _paint..color = color,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotdartThumbhashPainter oldDelegate) {
    return oldDelegate.thumbWidth != thumbWidth ||
        oldDelegate.thumbHeight != thumbHeight ||
        oldDelegate.pixels != pixels ||
        oldDelegate.dominantColor != dominantColor;
  }
}

/// Returns a frame builder for [Image] that shows a thumbhash placeholder
/// until the image decodes, then swaps to the real image.
ImageFrameBuilder _dotdartImageFrameBuilder(
  int thumbWidth,
  int thumbHeight,
  List<Color> pixels,
  Color color,
) {
  return (context, child, frame, sync) {
    if (sync) return child;
    if (frame != null) return child;
    return CustomPaint(
      painter: _DotdartThumbhashPainter(
        thumbWidth,
        thumbHeight,
        pixels,
        color,
      ),
    );
  };
}
''';
  }
}
