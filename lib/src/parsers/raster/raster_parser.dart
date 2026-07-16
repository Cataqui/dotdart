/// Parses raster image bytes into a [RasterImage] model with metadata,
/// dominant color, and thumbhash.
///
/// Uses the `image` package (dart-lang/image) at build time only — never
/// imported by generated code. This is justified because `dart:ui` is not
/// available during `build_runner`, and `image` provides pure-Dart decoding
/// for all supported raster formats (PNG, JPEG, WebP, GIF).
library;

import 'dart:typed_data';

import 'package:image/image.dart' as img;

import '../../models/raster_image.dart';
import 'thumbhash.dart';

/// Parses raw image bytes and extracts metadata for code generation.
class RasterParser {
  RasterParser._();

  /// Parses [bytes] into a [RasterImage] model.
  ///
  /// Throws [FormatException] if the bytes cannot be decoded or the format
  /// is unsupported.
  static RasterImage parse(List<int> bytes) {
    final data = Uint8List.fromList(bytes);
    final format = _detectFormat(bytes);

    if (format == RasterImageFormat.gif) {
      final decoder = img.GifDecoder(data);
      if (!decoder.isValidFile(data)) {
        throw const FormatException('Failed to decode GIF image.');
      }
      final decoded = decoder.decode(data);
      if (decoded == null) {
        throw const FormatException('Failed to decode GIF image.');
      }

      final frameCount = decoded.numFrames;
      var totalMs = 0;
      for (final frame in decoded.frames) {
        totalMs += frame.frameDuration;
      }

      final aspectRatio = decoded.width / decoded.height;
      final dominantColor = _computeDominantColor(decoded);
      final thumbhash = ThumbhashEncoder.encode(decoded);

      return RasterImage(
        intrinsicWidth: decoded.width,
        intrinsicHeight: decoded.height,
        format: format,
        isAnimated: decoded.hasAnimation,
        frameCount: frameCount,
        durationMs: totalMs,
        aspectRatio: aspectRatio,
        dominantColor: dominantColor,
        thumbhash: thumbhash,
      );
    }

    final decoded = img.decodeImage(data);
    if (decoded == null) {
      throw const FormatException('Failed to decode image.');
    }

    final aspectRatio = decoded.width / decoded.height;
    final dominantColor = _computeDominantColor(decoded);
    final thumbhash = ThumbhashEncoder.encode(decoded);

    return RasterImage(
      intrinsicWidth: decoded.width,
      intrinsicHeight: decoded.height,
      format: format,
      isAnimated: false,
      aspectRatio: aspectRatio,
      dominantColor: dominantColor,
      thumbhash: thumbhash,
    );
  }

  /// Detects format from magic bytes (not extension).
  static RasterImageFormat _detectFormat(List<int> bytes) {
    if (bytes.length < 4) {
      throw const FormatException('Image too short to detect format.');
    }

    if (bytes.length >= 8 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47 &&
        bytes[4] == 0x0D &&
        bytes[5] == 0x0A &&
        bytes[6] == 0x1A &&
        bytes[7] == 0x0A) {
      return RasterImageFormat.png;
    }

    if (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) {
      return RasterImageFormat.jpeg;
    }

    if (bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46 && bytes[3] == 0x38) {
      return RasterImageFormat.gif;
    }

    if (bytes.length >= 12 &&
        bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x46 &&
        bytes[8] == 0x57 &&
        bytes[9] == 0x45 &&
        bytes[10] == 0x42 &&
        bytes[11] == 0x50) {
      return RasterImageFormat.webp;
    }

    throw const FormatException(
      'Unsupported image format (only WebP, PNG, JPEG, and GIF are supported). '
      'AVIF and HEIC are not supported on low-end devices.',
    );
  }

  /// Computes a dominant ARGB color by downsampling to 16x16 and averaging.
  static int _computeDominantColor(img.Image image) {
    final thumbW = image.width > 16 ? 16 : image.width;
    final thumbH = image.height > 16 ? 16 : image.height;
    final resized = img.copyResize(
      image,
      width: thumbW,
      height: thumbH,
      interpolation: img.Interpolation.average,
    );

    var totalR = 0;
    var totalG = 0;
    var totalB = 0;
    var totalA = 0;
    for (var y = 0; y < thumbH; y++) {
      for (var x = 0; x < thumbW; x++) {
        final p = resized.getPixel(x, y);
        totalR += p.r.toInt();
        totalG += p.g.toInt();
        totalB += p.b.toInt();
        totalA += p.a.toInt();
      }
    }
    final n = thumbW * thumbH;
    final r = (totalR / n).round().clamp(0, 255);
    final g = (totalG / n).round().clamp(0, 255);
    final b = (totalB / n).round().clamp(0, 255);
    final a = (totalA / n).round().clamp(0, 255);
    return (a << 24) | (r << 16) | (g << 8) | b;
  }
}
