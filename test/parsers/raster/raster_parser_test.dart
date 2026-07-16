import 'package:dotdart/src/models/raster_image.dart';
import 'package:dotdart/src/parsers/raster/raster_parser.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

void main() {
  group('RasterParser', () {
    test('when parsing a PNG image, it should return correct metadata', () {
      final image = _createTestImage(width: 64, height: 48);
      final pngBytes = img.encodePng(image);

      final result = RasterParser.parse(pngBytes);

      expect(result.intrinsicWidth, equals(64));
      expect(result.intrinsicHeight, equals(48));
      expect(result.format, equals(RasterImageFormat.png));
      expect(result.isAnimated, isFalse);
      expect(result.aspectRatio, closeTo(64 / 48, 0.0001));
      expect(result.thumbhash, isNotEmpty);
    });

    test('when parsing a JPEG image, it should return correct metadata', () {
      final image = _createTestImage(width: 100, height: 80);
      final jpegBytes = img.encodeJpg(image);

      final result = RasterParser.parse(jpegBytes);

      expect(result.intrinsicWidth, equals(100));
      expect(result.intrinsicHeight, equals(80));
      expect(result.format, equals(RasterImageFormat.jpeg));
      expect(result.isAnimated, isFalse);
    });

    test('when parsing a WebP file from bytes, it should detect the format', () {
      final image = _createTestImage(width: 32, height: 32);
      final pngBytes = img.encodePng(image);

      final result = RasterParser.parse(pngBytes);

      expect(result.intrinsicWidth, equals(32));
      expect(result.intrinsicHeight, equals(32));
      expect(result.format, equals(RasterImageFormat.png));
    });

    test('when parsing a square image, the aspectRatio should be 1.0', () {
      final image = _createTestImage(width: 50, height: 50);
      final pngBytes = img.encodePng(image);

      final result = RasterParser.parse(pngBytes);

      expect(result.aspectRatio, closeTo(1.0, 0.0001));
    });

    test('when parsing a landscape image, the aspectRatio should be > 1', () {
      final image = _createTestImage(width: 80, height: 40);
      final pngBytes = img.encodePng(image);

      final result = RasterParser.parse(pngBytes);

      expect(result.aspectRatio, greaterThan(1.0));
    });

    test('when parsing a portrait image, the aspectRatio should be < 1', () {
      final image = _createTestImage(width: 40, height: 80);
      final pngBytes = img.encodePng(image);

      final result = RasterParser.parse(pngBytes);

      expect(result.aspectRatio, lessThan(1.0));
    });

    test('when parsing an image, it should produce a dominant color', () {
      final image = _createSolidImage(r: 200, g: 100, b: 50, a: 255);
      final pngBytes = img.encodePng(image);

      final result = RasterParser.parse(pngBytes);

      expect(result.dominantColor, isNonZero);
    });

    test('when parsing a mostly-red image, the dominant color should be red-ish', () {
      final image = _createSolidImage(r: 220, g: 30, b: 30, a: 255);
      final pngBytes = img.encodePng(image);

      final result = RasterParser.parse(pngBytes);

      final r = (result.dominantColor >> 16) & 0xFF;
      final g = (result.dominantColor >> 8) & 0xFF;
      final b = result.dominantColor & 0xFF;
      expect(r, greaterThan(g));
      expect(r, greaterThan(b));
    });

    test('when parsing a transparent image, the dominant color should have lower alpha', () {
      final image = _createSolidImage(r: 255, g: 0, b: 0, a: 128);
      final pngBytes = img.encodePng(image);

      final result = RasterParser.parse(pngBytes);

      final a = (result.dominantColor >> 24) & 0xFF;
      expect(a, lessThan(255));
    });

    test('when parsing an empty byte array, it should throw FormatException', () {
      expect(() => RasterParser.parse([]), throwsA(isA<FormatException>()));
    });

    test('when parsing an unsupported format (AVIF-like bytes), it should throw FormatException', () {
      final bytes = <int>[0, 0, 0, 0, 0x66, 0x74, 0x79, 0x70, 0x61, 0x76, 0x69, 0x66];
      expect(() => RasterParser.parse(bytes), throwsA(isA<FormatException>()));
    });
  });
}

img.Image _createTestImage({required int width, required int height}) {
  final image = img.Image(width: width, height: height, numChannels: 4);
  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      image.setPixelRgba(x, y, (x * 255 / width).round(), (y * 255 / height).round(), 128, 255);
    }
  }
  return image;
}

img.Image _createSolidImage({required int r, required int g, required int b, required int a}) {
  final image = img.Image(width: 16, height: 16, numChannels: 4);
  for (final p in image) {
    p
      ..r = r
      ..g = g
      ..b = b
      ..a = a;
  }
  return image;
}
