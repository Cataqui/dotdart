// GENERATED CODE - DO NOT MODIFY BY HAND
// *****************************************************
//  dotdart
// *****************************************************

// coverage:ignore-file
// Generated canvas and paint sequences intentionally use repeated receiver calls.
// ignore_for_file: cascade_invocations, unused_element, unused_element_parameter

import 'package:flutter/widgets.dart';

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
    if (thumbWidth <= 0 ||
        thumbHeight <= 0 ||
        pixels.length < thumbWidth * thumbHeight) {
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
      painter: _DotdartThumbhashPainter(thumbWidth, thumbHeight, pixels, color),
    );
  };
}

/// Namespace for dotdart-generated widgets from `images/`.
///
/// Call a method named after each asset to render it:
///
/// ```dart
/// $Images.cataqui(<params>);
/// ```
abstract final class $Images {
  $Images._();

  /// Builds the `Cataqui` widget from `cataqui.image`.
  static Widget cataqui({
    Key? key,
    double? width,
    double? height,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    Color? color,
    BlendMode? colorBlendMode,
  }) => _Cataqui(
    key: key,
    width: width,
    height: height,
    fit: fit,
    alignment: alignment,
    color: color,
    colorBlendMode: colorBlendMode,
  );

  /// Builds the asset matching [fileName], or returns null if it is absent.
  ///
  /// Pass the original filename, including its extension and exact case.
  /// Directory paths and extensionless names do not match.
  /// [key] is forwarded to the generated widget. [width] and [height] are
  /// logical pixels and use the same sizing rules as the named accessor.
  /// All asset-specific options keep their defaults.
  static Widget? findByName(
    String fileName, {
    Key? key,
    double? width,
    double? height,
  }) => switch (fileName) {
    'cataqui.png' => cataqui(key: key, width: width, height: height),
    _ => null,
  };
}

/// Manages Flutter image-cache entries for `images/`.
///
/// Use the same width and height when caching, rendering, and removing
/// an image so every operation addresses the same decoded entry.
abstract final class $ImagesCache {
  $ImagesCache._();

  static const _cataquiAsset = AssetImage('assets/images/cataqui.png');

  /// Decodes `cataqui` before its first render.
  ///
  /// [width] and [height] are logical pixels. Pass the same values to
  /// `$Images.cataqui` so it reuses this cache entry.
  /// Omitting both values uses the widget's default display size.
  static Future<void> precacheCataqui(
    BuildContext context, {
    double? width,
    double? height,
  }) => precacheImage(
    _provider(
      context,
      asset: _cataquiAsset,
      aspectRatio: 1,
      width: width,
      height: height,
    ),
    context,
  );

  /// Removes the decoded `cataqui` entry from Flutter's image cache.
  ///
  /// Returns whether the matching entry existed. [width] and [height]
  /// must match the values used to precache or render the image.
  /// An image that is still displayed remains live until its last listener
  /// is removed, preventing a duplicate decode during transitions.
  static Future<bool> removeCataqui(
    BuildContext context, {
    double? width,
    double? height,
  }) async {
    final configuration = createLocalImageConfiguration(context);
    final provider = _provider(
      context,
      asset: _cataquiAsset,
      aspectRatio: 1,
      width: width,
      height: height,
    );
    final key = await provider.obtainKey(configuration);
    return imageCache.evict(key, includeLive: false);
  }

  static ImageProvider<Object> _provider(
    BuildContext context, {
    required AssetImage asset,
    required double aspectRatio,
    double? width,
    double? height,
  }) {
    assert(width == null || width > 0, 'width must be greater than zero.');
    assert(height == null || height > 0, 'height must be greater than zero.');
    final resolvedWidth =
        width ?? (height != null ? height * aspectRatio : 280);
    final resolvedHeight = height ?? resolvedWidth / aspectRatio;
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    return ResizeImage.resizeIfNeeded(
      (resolvedWidth * devicePixelRatio).ceil(),
      (resolvedHeight * devicePixelRatio).ceil(),
      asset,
    );
  }
}

/// A dotdart-generated image widget from `assets/images/cataqui.png`.
///
/// Intrinsic 1024×1024 · PNG · aspect 1.0000.
/// Decodes at display size × device pixel ratio for minimal memory.
/// Renders a thumbhash placeholder in frame 1, then swaps to the image.
class _Cataqui extends StatelessWidget {
  const _Cataqui({
    super.key,
    this.width,
    this.height,
    this.fit,
    this.alignment = Alignment.center,
    this.color,
    this.colorBlendMode,
  });

  /// Width in logical pixels.
  final double? width;

  /// Height in logical pixels.
  final double? height;

  /// How to inscribe the image in its bounds.
  final BoxFit? fit;

  /// Alignment within the widget bounds.
  final AlignmentGeometry alignment;

  /// A color to blend with the image.
  final Color? color;

  /// The blend mode applied when color is set.
  final BlendMode? colorBlendMode;

  static const double _aspectRatio = 1;
  static const Color _dominantColor = Color(0x22232323);
  static const int _thumbhashWidth = 8;
  static const int _thumbhashHeight = 8;
  static const List<Color> _thumbhashPixels = <Color>[
    Color(0x059C9C9C),
    Color(0x0FE1E1E1),
    Color(0x19ECECEC),
    Color(0x16EBEBEB),
    Color(0x1EF7F7F7),
    Color(0x16FFFFFF),
    Color(0x06FFFFFF),
    Color(0x0BFFFFFF),
    Color(0x0FB8B8B8),
    Color(0x09848484),
    Color(0x27F1F1F1),
    Color(0x28F7F7F7),
    Color(0x29FBFBFB),
    Color(0x17FAFAFA),
    Color(0x0AF3F3F3),
    Color(0x06E7E7E7),
    Color(0x19FFFFFF),
    Color(0x1CEBEBEB),
    Color(0x5CF1F1F1),
    Color(0x68EDEDED),
    Color(0x6EF0F0F0),
    Color(0x32EAEAEA),
    Color(0x19FAFAFA),
    Color(0x19FFFFFF),
    Color(0x18EDEDED),
    Color(0x21E6E6E6),
    Color(0x67F2F2F2),
    Color(0x1CB8B8B8),
    Color(0x63EEEEEE),
    Color(0x4AEEEEEE),
    Color(0x10D3D3D3),
    Color(0x1CF7F7F7),
    Color(0x1FF7F7F7),
    Color(0x1DE8E8E8),
    Color(0x5EF2F2F2),
    Color(0x67EFEFEF),
    Color(0x74F0F0F0),
    Color(0x5BF0F0F0),
    Color(0x1FE5E5E5),
    Color(0x29F5F5F5),
    Color(0x05FFFFFF),
    Color(0x1BFBFBFB),
    Color(0x25E2E2E2),
    Color(0x29D2D2D2),
    Color(0x28CDCDCD),
    Color(0x55EFEFEF),
    Color(0x12DEDEDE),
    Color(0x0CFFFFFF),
    Color(0x00000000),
    Color(0x0AF4F4F4),
    Color(0x14F9F9F9),
    Color(0x12F5F5F5),
    Color(0x1CF3F3F3),
    Color(0x18E8E8E8),
    Color(0x12D0D0D0),
    Color(0x06000000),
    Color(0x09FFFFFF),
    Color(0x09FFFFFF),
    Color(0x19FFFFFF),
    Color(0x15F4F4F4),
    Color(0x1EF1F1F1),
    Color(0x19ECECEC),
    Color(0x09CACACA),
    Color(0x09CDCDCD),
  ];
  static final _frameBuilder = _dotdartImageFrameBuilder(
    _thumbhashWidth,
    _thumbhashHeight,
    _thumbhashPixels,
    _dominantColor,
  );
  static const String _assetPath = 'assets/images/cataqui.png';

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    const aspect = _aspectRatio;
    final w = width ?? (height != null ? height! * aspect : 280.0);
    final h = height ?? w / aspect;

    final image = Image.asset(
      _assetPath,
      key: key,
      width: w,
      height: h,
      fit: fit,
      alignment: alignment,
      color: color,
      colorBlendMode: colorBlendMode,
      gaplessPlayback: true,
      filterQuality: FilterQuality.low,
      cacheWidth: (w * dpr).ceil(),
      cacheHeight: (h * dpr).ceil(),
      frameBuilder: _frameBuilder,
    );

    return RepaintBoundary(child: image);
  }
}
