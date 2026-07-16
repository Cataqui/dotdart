import 'package:dotdart/src/models/svg_element.dart';
import 'package:dotdart/src/models/svg_style.dart';
import 'package:dotdart/src/parsers/lottie_parser.dart';
import 'package:dotdart/src/parsers/svg/svg_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SvgParser', () {
    test('when parsing a minimal SVG with a path, it should return a document with correct viewBox', () {
      final result = SvgParser.parse('<svg viewBox="0 0 24 24"><path d="M0 0L24 24" fill="black"/></svg>');

      expect(result.document.viewBox.width, 24);
      expect(result.document.viewBox.height, 24);
      expect(result.document.viewBox.minX, 0);
      expect(result.document.viewBox.minY, 0);
    });

    test('when parsing a path element, it should produce an SvgPath with commands', () {
      final result = SvgParser.parse('<svg viewBox="0 0 24 24"><path d="M0 0L24 24" fill="black"/></svg>');

      expect(result.document.children, hasLength(1));
      expect(result.document.children.first, isA<SvgPath>());
    });

    test('when parsing fill="black", it should resolve to (0, 0, 0, 1)', () {
      final result = SvgParser.parse('<svg viewBox="0 0 24 24"><path d="M0 0L24 24" fill="black"/></svg>');
      final path = result.document.children.first as SvgPath;

      expect(path.style.fillColor, equals((0, 0, 0, 1)));
    });

    test('when parsing fill="none", it should have null fillColor', () {
      final result = SvgParser.parse('<svg viewBox="0 0 24 24"><path d="M0 0L24 24" fill="none"/></svg>');
      final path = result.document.children.first as SvgPath;

      expect(path.style.fillColor, isNull);
    });

    test('when parsing fill="#ff0000", it should resolve to (1, 0, 0, 1)', () {
      final result = SvgParser.parse('<svg viewBox="0 0 24 24"><path d="M0 0L24 24" fill="#ff0000"/></svg>');
      final path = result.document.children.first as SvgPath;

      expect(path.style.fillColor, equals((1, 0, 0, 1)));
    });

    test('when parsing fill="#f00", it should expand to (1, 0, 0, 1)', () {
      final result = SvgParser.parse('<svg viewBox="0 0 24 24"><path d="M0 0L24 24" fill="#f00"/></svg>');
      final path = result.document.children.first as SvgPath;

      expect(path.style.fillColor, equals((1, 0, 0, 1)));
    });

    test('when parsing fill="rgb(255, 0, 0)", it should resolve to (1, 0, 0, 1)', () {
      final result = SvgParser.parse('<svg viewBox="0 0 24 24"><path d="M0 0L24 24" fill="rgb(255, 0, 0)"/></svg>');
      final path = result.document.children.first as SvgPath;

      expect(path.style.fillColor, equals((1, 0, 0, 1)));
    });

    test('when parsing stroke="#000" with stroke-width, it should produce correct stroke style', () {
      final result = SvgParser.parse(
        '<svg viewBox="0 0 24 24"><path d="M0 0L24 24" stroke="black" stroke-width="1.5" stroke-linecap="round"/></svg>',
      );
      final path = result.document.children.first as SvgPath;

      expect(path.style.strokeColor, equals((0, 0, 0, 1)));
      expect(path.style.strokeWidth, equals(1.5));
      expect(path.style.strokeLineCap, equals(SvgStrokeLineCap.round));
    });

    test('when parsing an SVG with fill-rule="evenodd", it should resolve to evenodd', () {
      final result = SvgParser.parse(
        '<svg viewBox="0 0 24 24"><path d="M0 0L24 24" fill="black" fill-rule="evenodd"/></svg>',
      );
      final path = result.document.children.first as SvgPath;

      expect(path.style.fillRule, equals(SvgFillRule.evenodd));
    });

    test('when parsing a rect element, it should produce an SvgRect', () {
      final result = SvgParser.parse(
        '<svg viewBox="0 0 100 50"><rect x="10" y="10" width="80" height="30" fill="red"/></svg>',
      );
      final rect = result.document.children.first as SvgRect;

      expect(rect.x, equals(10));
      expect(rect.y, equals(10));
      expect(rect.width, equals(80));
      expect(rect.height, equals(30));
    });

    test('when parsing a circle element, it should produce an SvgCircle', () {
      final result = SvgParser.parse('<svg viewBox="0 0 100 100"><circle cx="50" cy="50" r="40" fill="blue"/></svg>');
      final circle = result.document.children.first as SvgCircle;

      expect(circle.cx, equals(50));
      expect(circle.cy, equals(50));
      expect(circle.r, equals(40));
    });

    test('when parsing an ellipse element, it should produce an SvgEllipse', () {
      final result = SvgParser.parse(
        '<svg viewBox="0 0 100 100"><ellipse cx="50" cy="50" rx="40" ry="20" fill="green"/></svg>',
      );
      final ellipse = result.document.children.first as SvgEllipse;

      expect(ellipse.cx, equals(50));
      expect(ellipse.cy, equals(50));
      expect(ellipse.rx, equals(40));
      expect(ellipse.ry, equals(20));
    });

    test('when parsing a line element, it should produce an SvgLine', () {
      final result = SvgParser.parse(
        '<svg viewBox="0 0 100 100"><line x1="0" y1="0" x2="100" y2="100" stroke="black"/></svg>',
      );
      final line = result.document.children.first as SvgLine;

      expect(line.x1, equals(0));
      expect(line.y1, equals(0));
      expect(line.x2, equals(100));
      expect(line.y2, equals(100));
    });

    test('when parsing a polyline with points, it should produce an SvgPolyline', () {
      final result = SvgParser.parse(
        '<svg viewBox="0 0 100 100"><polyline points="0,0 50,50 100,0" fill="none" stroke="black"/></svg>',
      );
      final polyline = result.document.children.first as SvgPolyline;

      expect(polyline.points, hasLength(3));
    });

    test('when parsing a polygon with points, it should produce an SvgPolygon', () {
      final result = SvgParser.parse(
        '<svg viewBox="0 0 100 100"><polygon points="0,0 50,100 100,0" fill="black"/></svg>',
      );
      final polygon = result.document.children.first as SvgPolygon;

      expect(polygon.points, hasLength(3));
    });

    test('when parsing a group with fill inheritance, children should inherit the fill', () {
      final result = SvgParser.parse('<svg viewBox="0 0 100 100"><g fill="red"><path d="M0 0L100 100"/></g></svg>');
      final group = result.document.children.first as SvgGroup;
      final path = group.children.first as SvgPath;

      expect(path.style.fillColor, equals((1, 0, 0, 1)));
    });

    test('when parsing a child with its own fill inside a group, the child fill should override', () {
      final result = SvgParser.parse(
        '<svg viewBox="0 0 100 100"><g fill="red"><path d="M0 0L100 100" fill="blue"/></g></svg>',
      );
      final group = result.document.children.first as SvgGroup;
      final path = group.children.first as SvgPath;

      expect(path.style.fillColor, equals((0, 0, 1, 1)));
    });

    test('when parsing SVG with a gradient, it should throw an unsupported exception', () {
      expect(
        () => SvgParser.parse(
          '<svg viewBox="0 0 100 100"><defs><linearGradient id="g"><stop offset="0" stop-color="red"/></linearGradient></defs><rect fill="url(#g)" width="100" height="100"/></svg>',
        ),
        throwsA(isA<DotdartUnsupportedFeatureException>()),
      );
    });

    test('when parsing SVG with a <use> element, it should throw an unsupported exception', () {
      expect(
        () => SvgParser.parse('<svg viewBox="0 0 100 100"><defs><circle id="c" r="10"/></defs><use href="#c"/></svg>'),
        throwsA(isA<DotdartUnsupportedFeatureException>()),
      );
    });

    test('when parsing SVG with a text element, it should throw an unsupported exception', () {
      expect(
        () => SvgParser.parse('<svg viewBox="0 0 100 100"><text x="10" y="20">Hello</text></svg>'),
        throwsA(isA<DotdartUnsupportedFeatureException>()),
      );
    });

    test('when parsing an SVG with clip-rule, it should be silently ignored without warning', () {
      final result = SvgParser.parse(
        '<svg viewBox="0 0 24 24"><path d="M0 0L24 24" fill="black" fill-rule="evenodd" clip-rule="evenodd"/></svg>',
      );

      expect(result.warnings, isEmpty);
    });

    test('when parsing a cross.svg-like icon, it should produce two path sub-commands', () {
      final result = SvgParser.parse(
        '<svg viewBox="0 0 24 24"><path d="M0.75 0.75L23.25 23.25M23.25 0.75L0.75 23.25" stroke="black" stroke-width="1.5" stroke-linecap="round"/></svg>',
      );
      final path = result.document.children.first as SvgPath;

      expect(path.commands, hasLength(4));
    });

    test('when parsing a map_pin.svg-like icon, it should produce a complex path', () {
      final result = SvgParser.parse(
        '<svg viewBox="4 2 16 19.65"><path fill-rule="evenodd" d="M4 10C4 5.58172 7.58172 2 12 2Z" fill="black"/></svg>',
      );
      final path = result.document.children.first as SvgPath;

      expect(path.commands, hasLength(3));
      expect(path.style.fillRule, equals(SvgFillRule.evenodd));
    });

    test('when parsing an SVG with no viewBox, it should derive from width/height', () {
      final result = SvgParser.parse('<svg width="200" height="100"><path d="M0 0L200 100" fill="black"/></svg>');

      expect(result.document.viewBox.width, equals(200));
      expect(result.document.viewBox.height, equals(100));
    });

    test('when parsing a malformed SVG, it should throw an exception', () {
      expect(() => SvgParser.parse('not xml'), throwsA(isA<DotdartInvalidSvgException>()));
    });

    test('when parsing an SVG with a path with no fill, the default should be inherited black', () {
      final result = SvgParser.parse('<svg viewBox="0 0 10 10"><path d="M0 0L10 10"/></svg>');
      final path = result.document.children.first as SvgPath;

      expect(path.style.fillColor, equals((0, 0, 0, 1)));
    });

    test('when parsing an SVG with root fill="none", paths should have no fill by default', () {
      final result = SvgParser.parse('<svg viewBox="0 0 10 10" fill="none"><path d="M0 0L10 10"/></svg>');
      final path = result.document.children.first as SvgPath;

      expect(path.style.fillColor, isNull);
    });
  });
}
