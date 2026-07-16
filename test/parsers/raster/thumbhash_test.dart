import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:dotdart/src/parsers/raster/thumbhash.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ThumbhashEncoder', () {
    test('when encoding a solid red image, it should produce a non-empty hash', () {
      final image = img.Image(width: 32, height: 32, numChannels: 4);
      for (final p in image) {
        p
          ..r = 255
          ..g = 0
          ..b = 0
          ..a = 255;
      }

      final hash = ThumbhashEncoder.encode(image);
      expect(hash, isNotEmpty);
      expect(hash.length, greaterThan(4));
    });

    test('when encoding a solid blue image, it should produce a different hash than red', () {
      final redImage = img.Image(width: 16, height: 16, numChannels: 4);
      for (final p in redImage) {
        p
          ..r = 255
          ..g = 0
          ..b = 0
          ..a = 255;
      }
      final redHash = ThumbhashEncoder.encode(redImage);

      final blueImage = img.Image(width: 16, height: 16, numChannels: 4);
      for (final p in blueImage) {
        p
          ..r = 0
          ..g = 0
          ..b = 255
          ..a = 255;
      }
      final blueHash = ThumbhashEncoder.encode(blueImage);

      expect(redHash, isNot(equals(blueHash)));
    });

    test('when encoding a fully transparent image, it should encode without errors', () {
      final image = img.Image(width: 8, height: 8, numChannels: 4);
      for (final p in image) {
        p
          ..r = 0
          ..g = 0
          ..b = 0
          ..a = 0;
      }

      final hash = ThumbhashEncoder.encode(image);
      expect(hash, isNotEmpty);
    });

    test('when encoding a larger image, it should downsample to max 31 pixels', () {
      final image = img.Image(width: 200, height: 100, numChannels: 4);
      for (final p in image) {
        p
          ..r = 128
          ..g = 64
          ..b = 32
          ..a = 255;
      }

      final hash = ThumbhashEncoder.encode(image);
      expect(hash, isNotEmpty);
    });

    test('when encoding a small 1x1 pixel image, it should still produce a valid hash', () {
      final image = img.Image(width: 1, height: 1, numChannels: 4);
      for (final p in image) {
        p
          ..r = 64
          ..g = 128
          ..b = 192
          ..a = 255;
      }

      final hash = ThumbhashEncoder.encode(image);
      expect(hash, isNotEmpty);
    });

    test('when encoding a PNG image from bytes, it should produce a valid hash', () {
      final image = img.Image(width: 16, height: 16, numChannels: 4);
      for (var y = 0; y < 16; y++) {
        for (var x = 0; x < 16; x++) {
          image.setPixelRgba(x, y, x * 16, y * 16, 128, 255);
        }
      }
      final pngBytes = img.encodePng(image);
      final decoded = img.decodeImage(pngBytes)!;

      final hash = ThumbhashEncoder.encode(decoded);
      expect(hash, isNotEmpty);
    });

    test('when the base64 output is valid base64-url-safe, it should contain only valid characters', () {
      final image = img.Image(width: 32, height: 32, numChannels: 4);
      for (final p in image) {
        p
          ..r = 255
          ..g = 0
          ..b = 0
          ..a = 255;
      }

      final hash = ThumbhashEncoder.encode(image);
      expect(hash, matches(RegExp(r'^[A-Za-z0-9\-_]+$')));
    });
  });
}
