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

  /// The shared thumbhash decoder, painter, and image frame builder.
  ///
  /// Emitted once per namespace file when any raster asset is present.
  static String thumbhashCode() {
    return '''
/// Decodes a thumbhash string into a small RGBA image.
class _DotdartThumbhashDecoder {
  _DotdartThumbhashDecoder._();

  static ({int w, int h, List<int> pixels}) decode(String hash) {
    final bytes = _b64decode(hash);
    if (bytes.length < 5) {
      return (w: 1, h: 1, pixels: [0, 0, 0, 255]);
    }

    final dcR = (bytes[0] - 128) / 127;
    final dcG = (bytes[1] - 128) / 127;
    final dcB = (bytes[2] - 128) / 127;
    final dcA = bytes[3] / 255;

    final header = bytes[4];
    final nx = ((header >> 3) & 7) + 1;
    final ny = (header & 7) + 1;

    final acCount = nx * ny - 1;
    final expectedLen = 5 + acCount * 4;
    final acBytes = bytes.length >= expectedLen
        ? bytes.sublist(5, acCount * 4)
        : <int>[];

    final acR = List.filled(nx * ny, 0.0);
    final acG = List.filled(nx * ny, 0.0);
    final acB = List.filled(nx * ny, 0.0);
    final acA = List.filled(nx * ny, 0.0);

    var acIdx = 0;
    for (var iy = 0; iy < ny; iy++) {
      for (var ix = 0; ix < nx; ix++) {
        if (ix == 0 && iy == 0) continue;
        final idx = iy * nx + ix;
        acR[idx] = (acBytes[acIdx++] - 128) / 63;
        acG[idx] = (acBytes[acIdx++] - 128) / 63;
        acB[idx] = (acBytes[acIdx++] - 128) / 63;
        acA[idx] = (acBytes[acIdx++] - 128) / 63;
      }
    }

    final pixels = <int>[];
    for (var y = 0; y < ny; y++) {
      for (var x = 0; x < nx; x++) {
        var r = dcR;
        var g = dcG;
        var b = dcB;
        var a = dcA;
        for (var iy = 0; iy < ny; iy++) {
          for (var ix = 0; ix < nx; ix++) {
            if (ix == 0 && iy == 0) continue;
            final idx = iy * nx + ix;
            final cx = math.cos(math.pi / nx * (x + 0.5) * ix);
            final cy = math.cos(math.pi / ny * (y + 0.5) * iy);
            final weight = cx * cy;
            r += acR[idx] * weight;
            g += acG[idx] * weight;
            b += acB[idx] * weight;
            a += acA[idx] * weight;
          }
        }

        if (a <= 0) {
          pixels.addAll([0, 0, 0, 0]);
        } else {
          final invA = 1.0 / a;
          pixels.add((_linearToSrgb((r * invA).clamp(0, 1)) * 255).round().clamp(0, 255));
          pixels.add((_linearToSrgb((g * invA).clamp(0, 1)) * 255).round().clamp(0, 255));
          pixels.add((_linearToSrgb((b * invA).clamp(0, 1)) * 255).round().clamp(0, 255));
          pixels.add((a.clamp(0, 1) * 255).round().clamp(0, 255));
        }
      }
    }

    return (w: nx, h: ny, pixels: pixels);
  }

  static double _linearToSrgb(double linear) {
    return linear <= 0.0031308
        ? linear * 12.92
        : 1.055 * math.pow(linear, 1 / 2.4) - 0.055;
  }

  static List<int> _b64decode(String str) {
    const table = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_';
    final bytes = <int>[];
    var bits = 0;
    var bitCount = 0;
    for (var i = 0; i < str.length; i++) {
      final idx = table.indexOf(str[i]);
      if (idx < 0) continue;
      bits = (bits << 6) | idx;
      bitCount += 6;
      if (bitCount >= 8) {
        bitCount -= 8;
        bytes.add((bits >> bitCount) & 0xFF);
        bits &= (1 << bitCount) - 1;
      }
    }
    return bytes;
  }
}

/// Paints a thumbhash placeholder on a [CustomPainter] canvas.
class _DotdartThumbhashPainter extends CustomPainter {
  _DotdartThumbhashPainter(this.hash, this.dominantColor);

  final String hash;
  final Color dominantColor;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = dominantColor);
    if (hash.isEmpty) return;

    final decoded = _DotdartThumbhashDecoder.decode(hash);
    final thumbW = decoded.w;
    final thumbH = decoded.h;
    final pixels = decoded.pixels;
    final pixelW = size.width / thumbW;
    final pixelH = size.height / thumbH;

    for (var y = 0; y < thumbH; y++) {
      for (var x = 0; x < thumbW; x++) {
        final pi = (y * thumbW + x) * 4;
        final a = pixels[pi + 3];
        if (a == 0) continue;
        canvas.drawRect(
          Rect.fromLTWH(
            (x * pixelW).floorToDouble(),
            (y * pixelH).floorToDouble(),
            pixelW.ceilToDouble(),
            pixelH.ceilToDouble(),
          ),
          Paint()
            ..color = Color.fromARGB(a, pixels[pi], pixels[pi + 1], pixels[pi + 2]),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotdartThumbhashPainter oldDelegate) {
    return oldDelegate.hash != hash || oldDelegate.dominantColor != dominantColor;
  }
}

/// Returns a frame builder for [Image] that shows a thumbhash placeholder
/// until the image decodes, then swaps to the real image.
ImageFrameBuilder _dotdartImageFrameBuilder(String hash, Color color) {
  return (context, child, frame, sync) {
    if (sync) return child;
    if (frame != null) return child;
    return CustomPaint(painter: _DotdartThumbhashPainter(hash, color));
  };
}
''';
  }
}
