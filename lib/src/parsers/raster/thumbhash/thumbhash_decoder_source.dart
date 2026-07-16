/// Emits the thumbhash decoder used in generated raster namespaces.
class ThumbhashDecoderSource {
  ThumbhashDecoderSource._();

  /// Returns the canonical runtime decoder source.
  static String source() {
    return '''
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
    final acGreen = List<double>.filled(coefficientWidth * coefficientHeight, 0);
    final acBlue = List<double>.filled(coefficientWidth * coefficientHeight, 0);
    final acAlpha = List<double>.filled(coefficientWidth * coefficientHeight, 0);

    var acIndex = 0;
    for (var coefficientY = 0; coefficientY < coefficientHeight; coefficientY++) {
      for (var coefficientX = 0; coefficientX < coefficientWidth; coefficientX++) {
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
        for (var coefficientY = 0; coefficientY < coefficientHeight; coefficientY++) {
          for (var coefficientX = 0; coefficientX < coefficientWidth; coefficientX++) {
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
          ..add((_linearToSrgb((red * inverseAlpha).clamp(0, 1)) * 255).round().clamp(0, 255))
          ..add((_linearToSrgb((green * inverseAlpha).clamp(0, 1)) * 255).round().clamp(0, 255))
          ..add((_linearToSrgb((blue * inverseAlpha).clamp(0, 1)) * 255).round().clamp(0, 255))
          ..add((alpha.clamp(0, 1) * 255).round().clamp(0, 255));
      }
    }

    return (
      width: coefficientWidth,
      height: coefficientHeight,
      pixels: pixels,
    );
  }

  static double _linearToSrgb(double linear) {
    if (linear <= 0.0031308) return linear * 12.92;
    return 1.055 * math.pow(linear, 1 / 2.4) - 0.055;
  }

  static List<int> _decodeBase64(String value) {
    const table = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_';
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
''';
  }
}
