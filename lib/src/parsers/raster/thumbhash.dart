// StringBuffer.writeln returns void. Cascading void calls is valid Dart but
// makes the code harder to read. This is a known false positive.
// List.filled with 0.0 is intentional for double-typed lists.
// ignore_for_file: cascade_invocations, prefer_int_literals

/// Thumbhash image placeholder encoder and decoder source emitter.
library;

import 'dart:math' as math;

import 'package:image/image.dart' as img;

/// Encodes an image into a compact base64 thumbhash string.
class ThumbhashEncoder {
  ThumbhashEncoder._();

  /// Encodes [image] into a thumbhash string.
  static String encode(img.Image image) {
    const maxDim = 31;
    final imgW = image.width;
    final imgH = image.height;
    final scale = math.min(maxDim / imgW, maxDim / imgH);
    final thumbW = (imgW * scale).round().clamp(1, maxDim);
    final thumbH = (imgH * scale).round().clamp(1, maxDim);

    final resized = img.copyResize(
      image,
      width: thumbW,
      height: thumbH,
      interpolation: img.Interpolation.average,
    );

    final w = resized.width;
    final h = resized.height;
    final pixels = <double>[];
    for (var y = 0; y < h; y++) {
      for (var x = 0; x < w; x++) {
        final p = resized.getPixel(x, y);
        final a = p.a / 255.0;
        final r = _srgbToLinear(p.r / 255.0) * a;
        final g = _srgbToLinear(p.g / 255.0) * a;
        final b = _srgbToLinear(p.b / 255.0) * a;
        pixels.addAll([r, g, b, a]);
      }
    }

    final n = w * h;
    var dcR = 0.0;
    var dcG = 0.0;
    var dcB = 0.0;
    var dcA = 0.0;
    for (var i = 0; i < n; i++) {
      dcR += pixels[i * 4];
      dcG += pixels[i * 4 + 1];
      dcB += pixels[i * 4 + 2];
      dcA += pixels[i * 4 + 3];
    }
    dcR /= n;
    dcG /= n;
    dcB /= n;
    dcA /= n;

    for (var i = 0; i < n * 4; i += 4) {
      pixels[i] -= dcR;
      pixels[i + 1] -= dcG;
      pixels[i + 2] -= dcB;
      pixels[i + 3] -= dcA;
    }

    final nx = math.min(math.max(1, (w + 1) ~/ 2), 8);
    final ny = math.min(math.max(1, (h + 1) ~/ 2), 8);

    final acR = List.filled(nx * ny, 0.0);
    final acG = List.filled(nx * ny, 0.0);
    final acB = List.filled(nx * ny, 0.0);
    final acA = List.filled(nx * ny, 0.0);

    for (var iy = 0; iy < ny; iy++) {
      for (var ix = 0; ix < nx; ix++) {
        if (ix == 0 && iy == 0) continue;
        var sumR = 0.0;
        var sumG = 0.0;
        var sumB = 0.0;
        var sumA = 0.0;
        for (var y = 0; y < h; y++) {
          for (var x = 0; x < w; x++) {
            final i = (y * w + x) * 4;
            final cx = math.cos(math.pi / w * (x + 0.5) * ix);
            final cy = math.cos(math.pi / h * (y + 0.5) * iy);
            final weight = cx * cy;
            sumR += pixels[i] * weight;
            sumG += pixels[i + 1] * weight;
            sumB += pixels[i + 2] * weight;
            sumA += pixels[i + 3] * weight;
          }
        }
        acR[iy * nx + ix] = sumR / n;
        acG[iy * nx + ix] = sumG / n;
        acB[iy * nx + ix] = sumB / n;
        acA[iy * nx + ix] = sumA / n;
      }
    }

    final buffer = <int>[];
    void emit(int b) => buffer.add(b & 0xFF);

    emit((dcR.clamp(-1, 1) * 127 + 128).round().clamp(0, 255));
    emit((dcG.clamp(-1, 1) * 127 + 128).round().clamp(0, 255));
    emit((dcB.clamp(-1, 1) * 127 + 128).round().clamp(0, 255));
    emit((dcA.clamp(0, 1) * 255).round().clamp(0, 255));
    emit(((nx - 1) << 3) | (ny - 1));

    for (var iy = 0; iy < ny; iy++) {
      for (var ix = 0; ix < nx; ix++) {
        if (ix == 0 && iy == 0) continue;
        final idx = iy * nx + ix;
        void emitCoeff(double v) {
          final clamped = v.clamp(-1, 1);
          final q = (clamped * 63).round().clamp(-63, 63);
          emit(q + 128);
        }
        emitCoeff(acR[idx]);
        emitCoeff(acG[idx]);
        emitCoeff(acB[idx]);
        emitCoeff(acA[idx]);
      }
    }

    return _base64Encode(buffer);
  }

  static String _base64Encode(List<int> bytes) {
    const table = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_';
    final result = StringBuffer();
    for (var i = 0; i < bytes.length; i += 3) {
      final b0 = bytes[i];
      final b1 = i + 1 < bytes.length ? bytes[i + 1] : 0;
      final b2 = i + 2 < bytes.length ? bytes[i + 2] : 0;
      result
        ..write(table[b0 >> 2])
        ..write(table[((b0 & 3) << 4) | (b1 >> 4)]);
      if (i + 1 < bytes.length) {
        result.write(table[((b1 & 15) << 2) | (b2 >> 6)]);
      }
      if (i + 2 < bytes.length) {
        result.write(table[b2 & 63]);
      }
    }
    return result.toString();
  }
}

/// Generates the source code for the thumbhash decoder used in generated files.
class ThumbhashDecoderSource {
  ThumbhashDecoderSource._();

  /// Returns the Dart source for the decoder classes emitted into each
  /// namespace file that contains raster assets.
  static String source() {
    return '''
/// Decodes a thumbhash string into a small RGBA image.
///
/// Produces an nx × ny pixel grid (typically 1×1 to 8×8) that
/// approximates the original image. Painted at widget size, it produces
/// the blurry placeholder while the real image decodes.
class _DotdartThumbhashDecoder {
  _DotdartThumbhashDecoder._();

  /// Decodes [hash] (base64-url-encoded) into pixel data.
  ///
  /// Returns the pixel grid width, height, and a flat list of
  /// [r, g, b, a, r, g, b, a, ...] byte values.
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
        ? bytes.sublist(5, 5 + acCount * 4)
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

/// Paints a thumbhash placeholder on a [CustomPainter] canvas,
/// with [dominantColor] as the background wash.
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
''';
  }
}

double _srgbToLinear(double srgb) {
  return srgb <= 0.04045 ? srgb / 12.92 : math.pow((srgb + 0.055) / 1.055, 2.4).toDouble();
}
