import 'package:dotdart/src/models/raster_image.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RasterImageFormat', () {
    test('when checking the enum values, it should have all four formats', () {
      expect(RasterImageFormat.values, hasLength(4));
    });

    test('when checking the enum values, it should contain webp', () {
      expect(RasterImageFormat.values, contains(RasterImageFormat.webp));
    });

    test('when checking the enum values, it should contain png', () {
      expect(RasterImageFormat.values, contains(RasterImageFormat.png));
    });

    test('when checking the enum values, it should contain jpeg', () {
      expect(RasterImageFormat.values, contains(RasterImageFormat.jpeg));
    });

    test('when checking the enum values, it should contain gif', () {
      expect(RasterImageFormat.values, contains(RasterImageFormat.gif));
    });
  });

  group('RasterImage', () {
    test('when creating a RasterImage, it should store all fields', () {
      const image = RasterImage(
        intrinsicWidth: 1024,
        intrinsicHeight: 768,
        format: RasterImageFormat.webp,
        isAnimated: false,
        aspectRatio: 1024 / 768,
        dominantColor: 0xFF8A6D4B,
        thumbhash: 'test-hash',
      );

      expect((
        image.intrinsicWidth,
        image.intrinsicHeight,
        image.format,
        image.isAnimated,
        image.frameCount,
        image.durationMs,
        image.dominantColor,
        image.thumbhash,
      ), equals((1024, 768, RasterImageFormat.webp, false, 1, 0, 0xFF8A6D4B, 'test-hash')));
    });

    test('when creating an animated RasterImage, it should store frame info', () {
      const image = RasterImage(
        intrinsicWidth: 320,
        intrinsicHeight: 240,
        format: RasterImageFormat.gif,
        isAnimated: true,
        frameCount: 12,
        durationMs: 600,
        aspectRatio: 320 / 240,
        dominantColor: 0xFFFF0000,
        thumbhash: 'animated-hash',
      );

      expect((
        image.intrinsicWidth,
        image.isAnimated,
        image.frameCount,
        image.durationMs,
        image.format,
      ), equals((320, true, 12, 600, RasterImageFormat.gif)));
    });

    test('when checking aspectRatio of a square image, it should equal 1.0', () {
      const image = RasterImage(
        intrinsicWidth: 512,
        intrinsicHeight: 512,
        format: RasterImageFormat.png,
        isAnimated: false,
        aspectRatio: 1,
        dominantColor: 0xFF000000,
        thumbhash: 'square',
      );

      expect(image.aspectRatio, equals(1.0));
    });

    test('when checking a portrait image, the aspectRatio should be less than 1', () {
      const image = RasterImage(
        intrinsicWidth: 768,
        intrinsicHeight: 1024,
        format: RasterImageFormat.jpeg,
        isAnimated: false,
        aspectRatio: 768 / 1024,
        dominantColor: 0xFF00FF00,
        thumbhash: 'portrait',
      );

      expect(image.aspectRatio, lessThan(1.0));
    });
  });
}
