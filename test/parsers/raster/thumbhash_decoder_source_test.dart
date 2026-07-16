import 'package:dotdart/src/parsers/raster/thumbhash.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ThumbhashDecoderSource', () {
    test('when emitting coefficient slicing, it should include the five-byte header offset', () {
      expect(ThumbhashDecoderSource.source(), contains('bytes.sublist(5, 5 + acCount * 4)'));
    });

    test('when emitting a truncated-hash guard, it should return a safe fallback pixel', () {
      expect(ThumbhashDecoderSource.source(), contains('if (bytes.length < expectedLength)'));
    });
  });
}
