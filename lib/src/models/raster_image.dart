part 'raster_image_enums.dart';

/// Parsed metadata of a raster image asset ready for code generation.
class RasterImage {
  const RasterImage({
    required this.intrinsicWidth,
    required this.intrinsicHeight,
    required this.format,
    required this.isAnimated,
    required this.aspectRatio,
    required this.dominantColor,
    required this.thumbhash,
    this.frameCount = 1,
    this.durationMs = 0,
  });

  /// Width in source pixels (e.g. 1024).
  final int intrinsicWidth;

  /// Height in source pixels (e.g. 1024).
  final int intrinsicHeight;

  /// The encoded format of the source file.
  final RasterImageFormat format;

  /// Whether the image has multiple frames (animated WebP, GIF).
  final bool isAnimated;

  /// Total frame count. 1 for still images.
  final int frameCount;

  /// Total duration of the animation in milliseconds. 0 for still images.
  final int durationMs;

  /// Intrinsic aspect ratio (width / height).
  final double aspectRatio;

  /// 32-bit ARGB dominant color value (0xAARRGGBB).
  final int dominantColor;

  /// A base64-encoded thumbhash of the image, approximately 25 bytes.
  final String thumbhash;
}
