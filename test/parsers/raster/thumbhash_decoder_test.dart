import 'package:dotdart/src/parsers/raster/thumbhash.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

void main() {
  group('ThumbhashDecoder', () {
    test('when a thumbhash is truncated, it should return one safe fallback pixel', () {
      final decoded = ThumbhashDecoder.decode('short');

      expect(
        [decoded.width, decoded.height, ...decoded.pixels],
        orderedEquals([1, 1, 0, 0, 0, 255]),
      );
    });

    test('when a solid image is encoded and decoded, it should preserve its placeholder color', () {
      final image = img.Image(width: 16, height: 16, numChannels: 4);
      for (final pixel in image) {
        pixel
          ..r = 255
          ..g = 0
          ..b = 0
          ..a = 255;
      }
      final decoded = ThumbhashDecoder.decode(ThumbhashEncoder.encode(image));
      final isSolidRed = <int>[255, 0, 0, 255];

      expect(
        [
          decoded.width,
          decoded.height,
          decoded.pixels.length,
          for (var index = 0; index < decoded.pixels.length; index += 4) decoded.pixels.sublist(index, index + 4),
        ],
        [8, 8, 256, for (var index = 0; index < 64; index++) isSolidRed],
      );
    });
  });
}
