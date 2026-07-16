import 'package:dotdart/src/models/svg_element.dart';
import 'package:dotdart/src/parsers/lottie_parser.dart';
import 'package:dotdart/src/parsers/svg/svg_transform.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SvgTransform', () {
    test('when parsing translate(tx, ty), it should produce a single operation', () {
      final ops = SvgTransform.parse('translate(10, 20)');

      expect(ops, hasLength(1));
    });

    test('when parsing translate(tx, ty), it should have correct tx and ty', () {
      final ops = SvgTransform.parse('translate(10, 20)');
      final t = ops.first as SvgTranslate;

      expect(t.tx, equals(10));
      expect(t.ty, equals(20));
    });

    test('when parsing translate(tx) without ty, it should use ty=0', () {
      final ops = SvgTransform.parse('translate(15)');
      final t = ops.first as SvgTranslate;

      expect(t.tx, equals(15));
      expect(t.ty, equals(0));
    });

    test('when parsing scale(sx, sy), it should have correct sx and sy', () {
      final ops = SvgTransform.parse('scale(2, 3)');
      final s = ops.first as SvgScale;

      expect(s.sx, equals(2));
      expect(s.sy, equals(3));
    });

    test('when parsing scale(s) without sy, it should use sx as sy', () {
      final ops = SvgTransform.parse('scale(1.5)');
      final s = ops.first as SvgScale;

      expect(s.sx, equals(1.5));
      expect(s.sy, equals(1.5));
    });

    test('when parsing rotate(angle), it should produce a rotate operation', () {
      final ops = SvgTransform.parse('rotate(45)');
      final r = ops.first as SvgRotate;

      expect(r.angle, equals(45));
    });

    test('when parsing rotate(angle) without center, cx and cy should be null', () {
      final ops = SvgTransform.parse('rotate(45)');
      final r = ops.first as SvgRotate;

      expect(r.cx, isNull);
      expect(r.cy, isNull);
    });

    test('when parsing rotate(angle, cx, cy), it should include the center', () {
      final ops = SvgTransform.parse('rotate(90, 10, 20)');
      final r = ops.first as SvgRotate;

      expect(r.angle, equals(90));
      expect(r.cx, equals(10));
      expect(r.cy, equals(20));
    });

    test('when parsing chained transforms, it should return them in order', () {
      final ops = SvgTransform.parse('translate(10, 20) rotate(45)');

      expect(ops, hasLength(2));
      expect(ops[0], isA<SvgTranslate>());
      expect(ops[1], isA<SvgRotate>());
    });

    test('when parsing matrix(), it should throw an unsupported exception', () {
      expect(
        () => SvgTransform.parse('matrix(1, 0, 0, 1, 0, 0)'),
        throwsA(isA<DotdartUnsupportedFeatureException>()),
      );
    });

    test('when parsing skewX(), it should throw an unsupported exception', () {
      expect(
        () => SvgTransform.parse('skewX(10)'),
        throwsA(isA<DotdartUnsupportedFeatureException>()),
      );
    });

    test('when parsing skewY(), it should throw an unsupported exception', () {
      expect(
        () => SvgTransform.parse('skewY(10)'),
        throwsA(isA<DotdartUnsupportedFeatureException>()),
      );
    });

    test('when parsing an empty string, it should return an empty list', () {
      final ops = SvgTransform.parse('');

      expect(ops, isEmpty);
    });

    test('when parsing an unknown function, it should throw an unsupported exception', () {
      expect(
        () => SvgTransform.parse('unknown(1, 2)'),
        throwsA(isA<DotdartUnsupportedFeatureException>()),
      );
    });

    test('when parsing translate with a space instead of comma, it should still parse', () {
      final ops = SvgTransform.parse('translate(10 20)');
      final t = ops.first as SvgTranslate;

      expect(t.tx, equals(10));
      expect(t.ty, equals(20));
    });
  });
}
