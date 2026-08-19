// GENERATED CODE - DO NOT MODIFY BY HAND
// *****************************************************
//  dotdart
// *****************************************************

// coverage:ignore-file
// Generated canvas and paint sequences intentionally use repeated receiver calls.
// ignore_for_file: cascade_invocations, unused_element, unused_element_parameter

import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Decodes a thumbhash string into a small RGBA image.
class _DotdartThumbhashDecoder {
  _DotdartThumbhashDecoder._();

  static ({int width, int height, List<int> pixels}) decode(String hash) {
    final bytes = _decodeBase64(hash);
    if (bytes.length < 5) {
      return (width: 1, height: 1, pixels: [0, 0, 0, 255]);
    }

    final dcRed = (bytes[0] - 128) / 127;
    final dcGreen = (bytes[1] - 128) / 127;
    final dcBlue = (bytes[2] - 128) / 127;
    final dcAlpha = bytes[3] / 255;
    final header = bytes[4];
    final coefficientWidth = ((header >> 3) & 7) + 1;
    final coefficientHeight = (header & 7) + 1;
    final acCount = coefficientWidth * coefficientHeight - 1;
    final expectedLength = 5 + acCount * 4;
    if (bytes.length < expectedLength) {
      return (width: 1, height: 1, pixels: [0, 0, 0, 255]);
    }
    final acBytes = bytes.sublist(5, 5 + acCount * 4);
    final acRed = List<double>.filled(coefficientWidth * coefficientHeight, 0);
    final acGreen = List<double>.filled(
      coefficientWidth * coefficientHeight,
      0,
    );
    final acBlue = List<double>.filled(coefficientWidth * coefficientHeight, 0);
    final acAlpha = List<double>.filled(
      coefficientWidth * coefficientHeight,
      0,
    );

    var acIndex = 0;
    for (
      var coefficientY = 0;
      coefficientY < coefficientHeight;
      coefficientY++
    ) {
      for (
        var coefficientX = 0;
        coefficientX < coefficientWidth;
        coefficientX++
      ) {
        if (coefficientX == 0 && coefficientY == 0) continue;
        final index = coefficientY * coefficientWidth + coefficientX;
        acRed[index] = (acBytes[acIndex++] - 128) / 63;
        acGreen[index] = (acBytes[acIndex++] - 128) / 63;
        acBlue[index] = (acBytes[acIndex++] - 128) / 63;
        acAlpha[index] = (acBytes[acIndex++] - 128) / 63;
      }
    }

    final pixels = <int>[];
    for (var y = 0; y < coefficientHeight; y++) {
      for (var x = 0; x < coefficientWidth; x++) {
        var red = dcRed;
        var green = dcGreen;
        var blue = dcBlue;
        var alpha = dcAlpha;
        for (
          var coefficientY = 0;
          coefficientY < coefficientHeight;
          coefficientY++
        ) {
          for (
            var coefficientX = 0;
            coefficientX < coefficientWidth;
            coefficientX++
          ) {
            if (coefficientX == 0 && coefficientY == 0) continue;
            final index = coefficientY * coefficientWidth + coefficientX;
            final cosineX = math.cos(
              math.pi / coefficientWidth * (x + 0.5) * coefficientX,
            );
            final cosineY = math.cos(
              math.pi / coefficientHeight * (y + 0.5) * coefficientY,
            );
            final weight = cosineX * cosineY;
            red += acRed[index] * weight;
            green += acGreen[index] * weight;
            blue += acBlue[index] * weight;
            alpha += acAlpha[index] * weight;
          }
        }

        if (alpha <= 0) {
          pixels.addAll([0, 0, 0, 0]);
          continue;
        }
        final inverseAlpha = 1 / alpha;
        pixels
          ..add(
            (_linearToSrgb((red * inverseAlpha).clamp(0, 1)) * 255)
                .round()
                .clamp(0, 255),
          )
          ..add(
            (_linearToSrgb((green * inverseAlpha).clamp(0, 1)) * 255)
                .round()
                .clamp(0, 255),
          )
          ..add(
            (_linearToSrgb((blue * inverseAlpha).clamp(0, 1)) * 255)
                .round()
                .clamp(0, 255),
          )
          ..add((alpha.clamp(0, 1) * 255).round().clamp(0, 255));
      }
    }

    return (width: coefficientWidth, height: coefficientHeight, pixels: pixels);
  }

  static double _linearToSrgb(double linear) {
    if (linear <= 0.0031308) return linear * 12.92;
    return 1.055 * math.pow(linear, 1 / 2.4) - 0.055;
  }

  static List<int> _decodeBase64(String value) {
    const table =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_';
    final bytes = <int>[];
    var bits = 0;
    var bitCount = 0;
    for (var index = 0; index < value.length; index++) {
      final tableIndex = table.indexOf(value[index]);
      if (tableIndex < 0) continue;
      bits = (bits << 6) | tableIndex;
      bitCount += 6;
      if (bitCount < 8) continue;
      bitCount -= 8;
      bytes.add((bits >> bitCount) & 0xFF);
      bits &= (1 << bitCount) - 1;
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
    final thumbW = decoded.width;
    final thumbH = decoded.height;
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
            ..color = Color.fromARGB(
              a,
              pixels[pi],
              pixels[pi + 1],
              pixels[pi + 2],
            ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotdartThumbhashPainter oldDelegate) {
    return oldDelegate.hash != hash ||
        oldDelegate.dominantColor != dominantColor;
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
/// Renders a thumbhash placeholder in frame 1, then crossfades to the image.
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
  static const String _thumbhash =
      'j4-PIz-AgICAe3t7eoCAgICAgICAf39_f4KCgoKBgYGBgYGBgYCAgIF_f39_f39_f4GBgYGAgICAgICAgIGBgYF7e3t6gICAgIODg4SAgICAgICAgIGBgYF-fn5-f39_f39_f39_f39_gYGBgYGBgYF_f39_gICAgICAgIB-fn5-gYGBgYCAgICAgICAgICAgICAgIB_f39_gYGBgYGBgYF_f39_gICAgIGBgYGAgICAf39_f39_f3-AgICAgYGBgYGBgYGAgICAgICAf4CAgICAgICAgICAgICAgIB_f39_goKCgoCAgIB-fn5-f39_f4KCgoKBgYGBf39_f4CAgIA';
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
      frameBuilder: _dotdartImageFrameBuilder(_thumbhash, _dominantColor),
    );

    return RepaintBoundary(child: image);
  }
}
