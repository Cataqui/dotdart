// List.filled with 0.0 is intentional for double-typed lists.
// ignore_for_file: prefer_int_literals

import 'dart:math' as math;

import 'package:image/image.dart' as img;

/// Encodes an image into a compact base64 thumbhash string.
class ThumbhashEncoder {
  ThumbhashEncoder._();

  /// Encodes [image] into a thumbhash string.
  static String encode(img.Image image) {
    const maxDimension = 31;
    final imageWidth = image.width;
    final imageHeight = image.height;
    final scale = math.min(maxDimension / imageWidth, maxDimension / imageHeight);
    final thumbWidth = (imageWidth * scale).round().clamp(1, maxDimension);
    final thumbHeight = (imageHeight * scale).round().clamp(1, maxDimension);

    final resized = img.copyResize(
      image,
      width: thumbWidth,
      height: thumbHeight,
      interpolation: img.Interpolation.average,
    );

    final width = resized.width;
    final height = resized.height;
    final pixels = <double>[];
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        final pixel = resized.getPixel(x, y);
        final alpha = pixel.a / 255.0;
        pixels.addAll([
          _srgbToLinear(pixel.r / 255.0) * alpha,
          _srgbToLinear(pixel.g / 255.0) * alpha,
          _srgbToLinear(pixel.b / 255.0) * alpha,
          alpha,
        ]);
      }
    }

    final pixelCount = width * height;
    var dcRed = 0.0;
    var dcGreen = 0.0;
    var dcBlue = 0.0;
    var dcAlpha = 0.0;
    for (var index = 0; index < pixelCount; index++) {
      dcRed += pixels[index * 4];
      dcGreen += pixels[index * 4 + 1];
      dcBlue += pixels[index * 4 + 2];
      dcAlpha += pixels[index * 4 + 3];
    }
    dcRed /= pixelCount;
    dcGreen /= pixelCount;
    dcBlue /= pixelCount;
    dcAlpha /= pixelCount;

    for (var index = 0; index < pixelCount * 4; index += 4) {
      pixels[index] -= dcRed;
      pixels[index + 1] -= dcGreen;
      pixels[index + 2] -= dcBlue;
      pixels[index + 3] -= dcAlpha;
    }

    final coefficientWidth = math.min(math.max(1, (width + 1) ~/ 2), 8);
    final coefficientHeight = math.min(math.max(1, (height + 1) ~/ 2), 8);
    final acRed = List.filled(coefficientWidth * coefficientHeight, 0.0);
    final acGreen = List.filled(coefficientWidth * coefficientHeight, 0.0);
    final acBlue = List.filled(coefficientWidth * coefficientHeight, 0.0);
    final acAlpha = List.filled(coefficientWidth * coefficientHeight, 0.0);

    for (var coefficientY = 0; coefficientY < coefficientHeight; coefficientY++) {
      for (var coefficientX = 0; coefficientX < coefficientWidth; coefficientX++) {
        if (coefficientX == 0 && coefficientY == 0) continue;
        var red = 0.0;
        var green = 0.0;
        var blue = 0.0;
        var alpha = 0.0;
        for (var y = 0; y < height; y++) {
          for (var x = 0; x < width; x++) {
            final index = (y * width + x) * 4;
            final cosineX = math.cos(math.pi / width * (x + 0.5) * coefficientX);
            final cosineY = math.cos(math.pi / height * (y + 0.5) * coefficientY);
            final weight = cosineX * cosineY;
            red += pixels[index] * weight;
            green += pixels[index + 1] * weight;
            blue += pixels[index + 2] * weight;
            alpha += pixels[index + 3] * weight;
          }
        }
        final index = coefficientY * coefficientWidth + coefficientX;
        acRed[index] = red / pixelCount;
        acGreen[index] = green / pixelCount;
        acBlue[index] = blue / pixelCount;
        acAlpha[index] = alpha / pixelCount;
      }
    }

    final bytes = <int>[
      _quantizeDcColor(dcRed),
      _quantizeDcColor(dcGreen),
      _quantizeDcColor(dcBlue),
      (dcAlpha.clamp(0, 1) * 255).round().clamp(0, 255),
      ((coefficientWidth - 1) << 3) | (coefficientHeight - 1),
    ];

    for (var coefficientY = 0; coefficientY < coefficientHeight; coefficientY++) {
      for (var coefficientX = 0; coefficientX < coefficientWidth; coefficientX++) {
        if (coefficientX == 0 && coefficientY == 0) continue;
        final index = coefficientY * coefficientWidth + coefficientX;
        bytes.addAll([
          _quantizeAcCoefficient(acRed[index]),
          _quantizeAcCoefficient(acGreen[index]),
          _quantizeAcCoefficient(acBlue[index]),
          _quantizeAcCoefficient(acAlpha[index]),
        ]);
      }
    }

    return _base64Encode(bytes);
  }

  static double _srgbToLinear(double srgb) {
    if (srgb <= 0.04045) return srgb / 12.92;
    return math.pow((srgb + 0.055) / 1.055, 2.4).toDouble();
  }

  static int _quantizeDcColor(double value) {
    return (value.clamp(-1, 1) * 127 + 128).round().clamp(0, 255);
  }

  static int _quantizeAcCoefficient(double value) {
    final quantized = (value.clamp(-1, 1) * 63).round().clamp(-63, 63);
    return (quantized + 128) & 0xFF;
  }

  static String _base64Encode(List<int> bytes) {
    const table = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_';
    final result = StringBuffer();
    for (var index = 0; index < bytes.length; index += 3) {
      final first = bytes[index];
      final second = index + 1 < bytes.length ? bytes[index + 1] : 0;
      final third = index + 2 < bytes.length ? bytes[index + 2] : 0;
      result
        ..write(table[first >> 2])
        ..write(table[((first & 3) << 4) | (second >> 4)]);
      if (index + 1 < bytes.length) {
        result.write(table[((second & 15) << 2) | (third >> 6)]);
      }
      if (index + 2 < bytes.length) {
        result.write(table[third & 63]);
      }
    }
    return result.toString();
  }
}
