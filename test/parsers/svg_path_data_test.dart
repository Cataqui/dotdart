import 'package:dotdart/src/models/svg_element.dart';
import 'package:dotdart/src/parsers/svg/svg_path_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SvgPathData', () {
    test('when parsing M x y, it should produce a single SvgMoveTo', () {
      final cmds = SvgPathData.parse('M 10 20');

      expect(cmds, hasLength(1));
      expect(cmds.first, isA<SvgMoveTo>());
    });

    test('when parsing M x y, it should set the correct coordinates', () {
      final cmds = SvgPathData.parse('M 10 20');
      final m = cmds.first as SvgMoveTo;

      expect(m.x, equals(10));
      expect(m.y, equals(20));
    });

    test('when parsing m x y (relative), it should produce an absolute moveTo', () {
      final cmds = SvgPathData.parse('m 10 20');
      final m = cmds.first as SvgMoveTo;

      expect(m.x, equals(10));
      expect(m.y, equals(20));
    });

    test('when parsing M with multiple coordinate pairs, it should produce a moveTo then lineTo', () {
      final cmds = SvgPathData.parse('M 0 0 10 10');

      expect(cmds, hasLength(2));
      expect(cmds[0], isA<SvgMoveTo>());
      expect(cmds[1], isA<SvgLineTo>());
    });

    test('when parsing M with multiple pairs, the second pair should have correct coordinates', () {
      final cmds = SvgPathData.parse('M 0 0 10 10');
      final line = cmds[1] as SvgLineTo;

      expect(line.x, equals(10));
      expect(line.y, equals(10));
    });

    test('when parsing L x y, it should produce an SvgLineTo', () {
      final cmds = SvgPathData.parse('M 0 0 L 10 20');

      expect(cmds[1], isA<SvgLineTo>());
    });

    test('when parsing L x y, it should set the correct coordinates', () {
      final cmds = SvgPathData.parse('M 0 0 L 10 20');
      final l = cmds[1] as SvgLineTo;

      expect(l.x, equals(10));
      expect(l.y, equals(20));
    });

    test('when parsing H x, it should produce a horizontal lineTo at current y', () {
      final cmds = SvgPathData.parse('M 0 0 H 50');
      final h = cmds[1] as SvgLineTo;

      expect(h.x, equals(50));
      expect(h.y, equals(0));
    });

    test('when parsing V y, it should produce a vertical lineTo at current x', () {
      final cmds = SvgPathData.parse('M 0 0 V 50');
      final v = cmds[1] as SvgLineTo;

      expect(v.x, equals(0));
      expect(v.y, equals(50));
    });

    test('when parsing C with 6 arguments, it should produce an SvgCubicTo', () {
      final cmds = SvgPathData.parse('M 0 0 C 10 10 20 10 30 0');

      expect(cmds[1], isA<SvgCubicTo>());
    });

    test('when parsing C with 6 arguments, it should set correct control point coordinates', () {
      final cmds = SvgPathData.parse('M 0 0 C 10 10 20 10 30 0');
      final c = cmds[1] as SvgCubicTo;

      expect(c.x1, equals(10));
      expect(c.y1, equals(10));
      expect(c.x2, equals(20));
      expect(c.y2, equals(10));
      expect(c.x, equals(30));
      expect(c.y, equals(0));
    });

    test('when parsing Q with 4 arguments, it should produce an SvgQuadTo', () {
      final cmds = SvgPathData.parse('M 0 0 Q 25 25 50 0');

      expect(cmds[1], isA<SvgQuadTo>());
    });

    test('when parsing Q with 4 arguments, it should set correct coordinates', () {
      final cmds = SvgPathData.parse('M 0 0 Q 25 25 50 0');
      final q = cmds[1] as SvgQuadTo;

      expect(q.x1, equals(25));
      expect(q.y1, equals(25));
      expect(q.x, equals(50));
      expect(q.y, equals(0));
    });

    test('when parsing Z, it should produce an SvgClosePath', () {
      final cmds = SvgPathData.parse('M 0 0 L 10 0 L 10 10 Z');

      expect(cmds.last, isA<SvgClosePath>());
    });

    test('when parsing a cubic with implicit continuation, it should produce multiple cubics', () {
      final cmds = SvgPathData.parse('M 0 0 C 10 0 20 10 30 0 40 0 50 10 60 0');

      expect(cmds, hasLength(3));
      expect(cmds[1], isA<SvgCubicTo>());
      expect(cmds[2], isA<SvgCubicTo>());
    });

    test('when parsing S (smooth cubic) without prior cubic, it should reflect about current point', () {
      final cmds = SvgPathData.parse('M 0 0 S 20 20 40 0');
      final s = cmds[1] as SvgCubicTo;

      expect(s.x1, equals(0));
      expect(s.y1, equals(0));
      expect(s.x2, equals(20));
      expect(s.y2, equals(20));
    });

    test('when parsing S after C, it should reflect the previous control point correctly', () {
      final cmds = SvgPathData.parse('M 0 0 C 10 0 20 10 30 0 S 50 20 60 0');
      final s = cmds[2] as SvgCubicTo;

      expect(s.x1, equals(40));
      expect(s.y1, equals(-10));
      expect(s.x2, equals(50));
      expect(s.y2, equals(20));
    });

    test('when parsing a line with the format from cross.svg, it should produce four commands', () {
      final cmds = SvgPathData.parse('M0.75 0.75L23.25 23.25M23.25 0.75L0.75 23.25');

      expect(cmds, hasLength(4));
    });

    test('when parsing cross.svg, the first moveTo should have correct coordinates', () {
      final cmds = SvgPathData.parse('M0.75 0.75L23.25 23.25M23.25 0.75L0.75 23.25');
      final m = cmds[0] as SvgMoveTo;

      expect(m.x, equals(0.75));
      expect(m.y, equals(0.75));
    });

    test('when parsing cross.svg, the first lineTo should have correct coordinates', () {
      final cmds = SvgPathData.parse('M0.75 0.75L23.25 23.25M23.25 0.75L0.75 23.25');
      final l = cmds[1] as SvgLineTo;

      expect(l.x, equals(23.25));
      expect(l.y, equals(23.25));
    });

    test('when parsing a closed path from map_pin.svg, it should end with SvgClosePath', () {
      final cmds = SvgPathData.parse('M4 10C4 5.58172 7.58172 2 12 2C16.4183 2 20 5.58172 20 10Z');

      expect(cmds.first, isA<SvgMoveTo>());
      expect(cmds.last, isA<SvgClosePath>());
    });

    test('when parsing a map_pin-like path, it should have a cubic between move and close', () {
      final cmds = SvgPathData.parse('M4 10C4 5.58172 7.58172 2 12 2C16.4183 2 20 5.58172 20 10Z');

      expect(cmds[1], isA<SvgCubicTo>());
    });

    test('when parsing an empty string, it should return an empty list', () {
      final cmds = SvgPathData.parse('');

      expect(cmds, isEmpty);
    });

    test('when parsing lowercase relative commands, it should produce absolute coordinates', () {
      final cmds = SvgPathData.parse('M100 100 l 10 0 0 10 -10 0 0 -10');

      expect(cmds, hasLength(5));
    });

    test('when parsing relative l, the first lineTo should add to current point', () {
      final cmds = SvgPathData.parse('M100 100 l 10 0');
      final l = cmds[1] as SvgLineTo;

      expect(l.x, equals(110));
      expect(l.y, equals(100));
    });

    test('when parsing relative l with successive offsets, it should accumulate correctly', () {
      final cmds = SvgPathData.parse('M100 100 l 10 0 0 10 -10 0 0 -10');
      final l4 = cmds[4] as SvgLineTo;

      expect(l4.x, equals(100));
      expect(l4.y, equals(100));
    });

    test('when parsing relative m with offsets, it should add to current point', () {
      final cmds = SvgPathData.parse('M 50 50 m 10 20');
      final m = cmds[1] as SvgMoveTo;

      expect(m.x, equals(60));
      expect(m.y, equals(70));
    });
  });
}
