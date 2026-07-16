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
  return color.withValues(alpha: math.min(1.0, math.max(0.0, color.a * opacity)));
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

  @override
  Widget build(BuildContext context) {
    final hasExplicitSize = svgWidgetWidth != null || svgWidgetHeight != null;
    final aspect = svgViewBoxHeight / svgViewBoxWidth;
    final width =
        svgWidgetWidth ?? (svgWidgetHeight != null ? svgWidgetHeight! / aspect : svgNativeWidth);
    final height = svgWidgetHeight ?? width * aspect;

    if (!hasExplicitSize) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final size = _defaultSizeFor(constraints);
          return buildPainter(width: size.width, height: size.height);
        },
      );
    }

    return OverflowBox(
      alignment: Alignment.topLeft,
      fit: OverflowBoxFit.deferToChild,
      minWidth: width,
      maxWidth: width,
      minHeight: height,
      maxHeight: height,
      child: buildPainter(width: width, height: height),
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
  bool get lottieRespectDisableAnimations;
  Duration get lottieLoopDuration;
  double get lottieCanvasWidth;
  double get lottieCanvasHeight;

  Widget buildPainter({required double width, required double height});

  late final AnimationController _controller;
  bool _canAnimateForLifecycle = true;

  bool _shouldAnimate() {
    final disableAnimations = lottieRespectDisableAnimations &&
        (MediaQuery.maybeDisableAnimationsOf(context) ?? false);
    return lottieProgress == null && _canAnimateForLifecycle && !disableAnimations;
  }

  void _syncController() {
    if (_shouldAnimate()) {
      if (!_controller.isAnimating) _controller.repeat();
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

  @override
  Widget build(BuildContext context) {
    final hasExplicitSize = lottieWidgetWidth != null || lottieWidgetHeight != null;
    final aspect = lottieCanvasHeight / lottieCanvasWidth;
    final width = lottieWidgetWidth ??
        (lottieWidgetHeight != null ? lottieWidgetHeight! / aspect : lottieCanvasWidth);
    final height = lottieWidgetHeight ?? width * aspect;

    if (!hasExplicitSize) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final size = _defaultSizeFor(constraints);
          return buildPainter(width: size.width, height: size.height);
        },
      );
    }

    return OverflowBox(
      alignment: Alignment.topLeft,
      fit: OverflowBoxFit.deferToChild,
      minWidth: width,
      maxWidth: width,
      minHeight: height,
      maxHeight: height,
      child: buildPainter(width: width, height: height),
    );
  }
}

''';
  }
}
