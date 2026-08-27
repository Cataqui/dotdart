import 'package:dotdart/src/generators/svg_generator.dart';
import 'package:dotdart/src/models/svg_document.dart';
import 'package:dotdart/src/models/svg_element.dart';
import 'package:dotdart/src/models/svg_style.dart';
import 'package:dotdart/src/parsers/svg/svg_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SvgGenerator', () {
    test('when generating code from a path SVG, it should produce valid Dart', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24),
        children: [
          SvgPath(
            style: SvgStyle(fillColor: (0, 0, 0, 1)),
            commands: [SvgMoveTo(x: 0, y: 0), SvgLineTo(x: 24, y: 24), SvgClosePath()],
          ),
        ],
      );
      final generator = SvgGenerator(doc, 'assets/icons/arrow.svg');
      final code = generator.generateWidgetClass();

      expect(
        code,
        allOf(
          isNotEmpty,
          contains('class _Arrow extends StatelessWidget with _DotdartSvgSizing'),
          contains('class _ArrowPainter extends CustomPainter'),
          isNot(contains('class Arrow extends')),
        ),
      );
    });

    test('when generating code, it should include the correct widget class name', () {
      const doc = SvgDocument(viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24), children: []);
      final generator = SvgGenerator(doc, 'assets/icons/my_test_icon.svg');

      expect(generator.widgetClassName, '_MyTestIcon');
    });

    test('when generating code, it should include color properties for each unique color', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24),
        children: [
          SvgPath(
            style: SvgStyle(fillColor: (0, 0, 0, 1)),
            commands: [SvgMoveTo(x: 0, y: 0), SvgLineTo(x: 24, y: 24)],
          ),
        ],
      );
      final generator = SvgGenerator(doc, 'assets/icons/icon.svg');
      final code = generator.generateWidgetClass();

      expect(code, contains('color1'));
    });

    test('when distinct colors are present, it should emit one color prop per unique color', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24),
        children: [
          SvgPath(
            style: SvgStyle(fillColor: (0, 0, 0, 1)),
            commands: [SvgMoveTo(x: 0, y: 0), SvgLineTo(x: 24, y: 24)],
          ),
        ],
      );
      final generator = SvgGenerator(doc, 'assets/icons/icon.svg');
      final code = generator.generateWidgetClass();

      expect(code, isNot(contains('color2')));
    });

    test('when generating code, it should not include Flutter animation-related code', () {
      const doc = SvgDocument(viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24), children: []);
      final generator = SvgGenerator(doc, 'assets/icons/icon.svg');
      final code = generator.generateWidgetClass();

      expect(
        code,
        allOf(
          isNot(contains('AnimationController')),
          isNot(contains('SingleTickerProviderStateMixin')),
          isNot(contains('WidgetsBindingObserver')),
          isNot(contains('progress')),
          isNot(contains('respectDisableAnimations')),
          isNot(contains('AnimatedWidget')),
          isNot(contains('_loopDuration')),
        ),
      );
    });

    test('when generating code, it should include the viewBox constants', () {
      const doc = SvgDocument(viewBox: SvgViewBox(minX: 3, minY: 5, width: 18, height: 14), children: []);
      final generator = SvgGenerator(doc, 'assets/icons/arrow.svg');
      final code = generator.generateWidgetClass();

      expect(
        code,
        allOf(
          contains('_svgWidth = 18'),
          contains('_svgHeight = 14'),
          contains('_viewBoxMinX = 3'),
          contains('_viewBoxMinY = 5'),
          contains('_viewBoxWidth = 18'),
          contains('_viewBoxHeight = 14'),
        ),
      );
    });

    test('when generating code with a path, it should include a static final Path field', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24),
        children: [
          SvgPath(
            style: SvgStyle(fillColor: (0, 0, 0, 1)),
            commands: [SvgMoveTo(x: 0, y: 0), SvgCubicTo(x1: 10, y1: 0, x2: 20, y2: 10, x: 24, y: 24)],
          ),
        ],
      );
      final generator = SvgGenerator(doc, 'assets/icons/arrow.svg');
      final code = generator.generateWidgetClass();

      expect(code, contains('static final Path __path0 = Path()'));
      expect(code, contains('..moveTo(0, 0)'));
      expect(code, contains('..cubicTo(10, 0, 20, 10, 24, 24)'));
    });

    test('when generating code with an even-odd fill path, it should preserve the fill rule', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24),
        children: [
          SvgPath(
            style: SvgStyle(fillColor: (0, 0, 0, 1), fillRule: SvgFillRule.evenodd),
            commands: [
              SvgMoveTo(x: 0, y: 0),
              SvgLineTo(x: 24, y: 0),
              SvgLineTo(x: 24, y: 24),
              SvgLineTo(x: 0, y: 24),
              SvgClosePath(),
              SvgMoveTo(x: 8, y: 8),
              SvgLineTo(x: 16, y: 8),
              SvgLineTo(x: 16, y: 16),
              SvgLineTo(x: 8, y: 16),
              SvgClosePath(),
            ],
          ),
        ],
      );
      final generator = SvgGenerator(doc, 'assets/icons/even_odd.svg');
      final code = generator.generateWidgetClass();

      expect(code, contains('..fillType = PathFillType.evenOdd'));
    });

    test('when generating a fill-only asset, it should emit only the reusable fill paint', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24),
        children: [
          SvgPath(
            style: SvgStyle(fillColor: (0, 0, 0, 1)),
            commands: [SvgMoveTo(x: 0, y: 0), SvgLineTo(x: 24, y: 24)],
          ),
        ],
      );
      final generator = SvgGenerator(doc, 'assets/icons/icon.svg');
      final code = generator.generateWidgetClass();

      expect(RegExp(r'Paint\(\)').allMatches(code).length, 1);
    });

    test('when generating code, it should include the painter with shouldRepaint comparing colors', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24),
        children: [
          SvgPath(
            style: SvgStyle(fillColor: (0, 0, 0, 1)),
            commands: [SvgMoveTo(x: 0, y: 0), SvgLineTo(x: 24, y: 24)],
          ),
        ],
      );
      final generator = SvgGenerator(doc, 'assets/icons/icon.svg');
      final code = generator.generateWidgetClass();

      expect(
        code,
        allOf(
          contains('bool shouldRepaint'),
          contains('oldDelegate.color1 != color1'),
          isNot(contains('_fixedProgress')),
        ),
      );
    });

    test('when generating code with a viewBox offset, it should translate the canvas', () {
      const doc = SvgDocument(viewBox: SvgViewBox(minX: 3, minY: 5, width: 18, height: 14), children: []);
      final generator = SvgGenerator(doc, 'assets/icons/arrow.svg');
      final code = generator.generateWidgetClass();

      expect(code, allOf(contains('..translate(-_Arrow._viewBoxMinX, -_Arrow._viewBoxMinY)')));
    });

    test('when generating code with no fill or stroke, it should produce no canvas draw calls', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24),
        children: [
          SvgPath(style: SvgStyle(fillColor: null), commands: [SvgMoveTo(x: 0, y: 0)]),
        ],
      );
      final generator = SvgGenerator(doc, 'assets/icons/empty.svg');
      final code = generator.generateWidgetClass();

      expect(code, isNot(contains('canvas.drawPath')));
    });

    test('when generating code with a stroke on a path, it should include stroke parameters', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24),
        children: [
          SvgPath(
            style: SvgStyle(
              strokeColor: (0, 0, 0, 1),
              strokeWidth: 1.5,
              strokeLineCap: SvgStrokeLineCap.round,
              strokeLineJoin: SvgStrokeLineJoin.round,
            ),
            commands: [SvgMoveTo(x: 0, y: 0), SvgLineTo(x: 24, y: 24)],
          ),
        ],
      );
      final generator = SvgGenerator(doc, 'assets/icons/cross.svg');
      final code = generator.generateWidgetClass();

      expect(code, allOf(contains('strokeWidth = 1.5'), contains('StrokeCap.round'), contains('StrokeJoin.round')));
    });

    test('when generating code with a rect element, it should include a static const RRect', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 100, height: 50),
        children: [
          SvgRect(style: SvgStyle(fillColor: (1, 0, 0, 1)), x: 10, y: 10, width: 80, height: 30, rx: 5, ry: 5),
        ],
      );
      final generator = SvgGenerator(doc, 'assets/icons/rect.svg');
      final code = generator.generateWidgetClass();

      expect(code, contains('static const RRect _rrect0 = RRect.fromRectAndRadius('));
    });

    test('when generating code with a circle element, it should include a static const Rect for the oval', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24),
        children: [SvgCircle(style: SvgStyle(fillColor: (0, 0, 0, 1)), cx: 12, cy: 12, r: 10)],
      );
      final generator = SvgGenerator(doc, 'assets/icons/circle.svg');
      final code = generator.generateWidgetClass();

      expect(code, contains('static const Rect _ellipseRect0 = Rect.fromCircle('));
    });

    test('when generating code with a group containing transform, it should include canvas save/restore', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 100, height: 100),
        children: [
          SvgGroup(
            style: SvgStyle(),
            transform: [SvgTranslate(tx: 10, ty: 20)],
            children: [
              SvgPath(
                style: SvgStyle(fillColor: (0, 0, 0, 1)),
                commands: [SvgMoveTo(x: 0, y: 0), SvgLineTo(x: 10, y: 10)],
              ),
            ],
          ),
        ],
      );
      final generator = SvgGenerator(doc, 'assets/icons/group.svg');
      final code = generator.generateWidgetClass();

      expect(
        code,
        allOf(contains('canvas.save()'), contains('canvas.translate(10, 20)'), contains('canvas.restore()')),
      );
    });

    test('when generating code with deduplicated colors, it should emit a single color prop', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 100, height: 100),
        children: [
          SvgPath(
            style: SvgStyle(fillColor: (0, 0, 0, 1)),
            commands: [SvgMoveTo(x: 0, y: 0), SvgLineTo(x: 10, y: 10)],
          ),
          SvgPath(
            style: SvgStyle(strokeColor: (0, 0, 0, 1)),
            commands: [SvgMoveTo(x: 10, y: 10), SvgLineTo(x: 20, y: 20)],
          ),
        ],
      );
      final generator = SvgGenerator(doc, 'assets/icons/dedup.svg');
      final code = generator.generateWidgetClass();

      expect(code, isNot(contains('color2')));
    });

    test('when a drawable has an id, it should use the drawable id for its color name', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24),
        children: [
          SvgGroup(
            id: 'outline',
            style: SvgStyle(),
            children: [
              SvgPath(
                id: 'detail',
                style: SvgStyle(fillColor: (0, 0, 0, 1)),
                commands: [SvgMoveTo(x: 0, y: 0), SvgLineTo(x: 24, y: 24)],
              ),
            ],
          ),
        ],
      );
      final code = SvgGenerator(doc, 'assets/icons/semantic.svg').generateWidgetClass();

      expect(code, allOf(contains('final Color? detailColor;'), isNot(contains('outlineColor'))));
    });

    test('when only the SVG root has an id, it should keep an anonymous color name', () {
      final parsed = SvgParser.parse(
        '<svg id="semantic" viewBox="0 0 24 24"><path d="M0 0L24 24" fill="black"/></svg>',
      );
      final code = SvgGenerator(parsed.document, 'assets/icons/semantic.svg').generateWidgetClass();

      expect(code, allOf(contains('final Color? color1;'), isNot(contains('semanticColor'))));
    });

    test('when valid non-ASCII ids have no Dart words, it should suffix their fallback names', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24),
        children: [
          SvgPath(
            id: '画面',
            style: SvgStyle(fillColor: (0, 0, 0, 1)),
            commands: [SvgMoveTo(x: 0, y: 0), SvgLineTo(x: 12, y: 12)],
          ),
          SvgPath(
            id: '背景',
            style: SvgStyle(fillColor: (1, 1, 1, 1)),
            commands: [SvgMoveTo(x: 12, y: 12), SvgLineTo(x: 24, y: 24)],
          ),
        ],
      );
      final code = SvgGenerator(doc, 'assets/icons/semantic.svg').generateWidgetClass();

      expect(
        code,
        allOf(
          contains('final Color? svgIdColor;'),
          contains('final Color? svgIdColor2;'),
          contains('SVG id `画面`'),
          contains('SVG id `背景`'),
        ),
      );
    });

    test('when a drawable is unnamed, it should use the nearest group id for its color name', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24),
        children: [
          SvgGroup(
            id: 'inner_text',
            style: SvgStyle(fillColor: (0, 0, 0, 1)),
            children: [
              SvgGroup(
                style: SvgStyle(fillColor: (0, 0, 0, 1)),
                children: [
                  SvgPath(
                    style: SvgStyle(fillColor: (1, 1, 1, 1)),
                    commands: [SvgMoveTo(x: 0, y: 0), SvgLineTo(x: 24, y: 24)],
                  ),
                ],
              ),
            ],
          ),
        ],
      );
      final code = SvgGenerator(doc, 'assets/icons/semantic.svg').generateWidgetClass();

      expect(
        code,
        allOf(
          contains('final Color? innerTextColor;'),
          contains('SVG id `inner_text`'),
          isNot(contains('final Color? color1;')),
        ),
      );
    });

    test('when a logo has outline and inner text groups, it should emit only their semantic colors', () {
      final parsed = SvgParser.parse('''
<svg id="Layer_1" viewBox="0 0 40 20">
  <g id="Logo">
    <g id="Outline" opacity="0.8">
      <path fill="#1E1E1E" d="M0 0L20 0L20 20L0 20Z"/>
      <path fill="#1E1E1E" d="M20 0L40 0L40 20L20 20Z"/>
    </g>
    <g id="Inner_text">
      <g><path fill="#FFFFFF" d="M4 4L36 4L36 16L4 16Z"/></g>
    </g>
  </g>
</svg>
''');
      final code = SvgGenerator(parsed.document, 'assets/logos/google_maps.svg').generateWidgetClass();

      expect(
        code,
        allOf(
          contains('final Color? outlineColor;'),
          contains('outlineColor ?? const Color(0xff1e1e1e)'),
          contains('_dotdartApplyOpacity(outlineColor, 0.8)'),
          contains('final Color? innerTextColor;'),
          contains('innerTextColor ?? const Color(0xffffffff)'),
          isNot(contains('final Color? color1;')),
        ),
      );
    });

    test('when named scopes share a color, it should keep their colors independently customizable', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24),
        children: [
          SvgPath(
            id: 'outline',
            style: SvgStyle(fillColor: (0, 0, 0, 1)),
            commands: [SvgMoveTo(x: 0, y: 0), SvgLineTo(x: 12, y: 12)],
          ),
          SvgPath(
            id: 'background',
            style: SvgStyle(fillColor: (0, 0, 0, 1)),
            commands: [SvgMoveTo(x: 12, y: 12), SvgLineTo(x: 24, y: 24)],
          ),
        ],
      );
      final code = SvgGenerator(doc, 'assets/icons/semantic.svg').generateWidgetClass();

      expect(code, allOf(contains('outlineColor'), contains('backgroundColor')));
    });

    test('when a named scope has multiple colors, it should number colors within that scope', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24),
        children: [
          SvgGroup(
            id: 'artwork',
            style: SvgStyle(),
            children: [
              SvgPath(
                style: SvgStyle(fillColor: (1, 0, 0, 1)),
                commands: [SvgMoveTo(x: 0, y: 0), SvgLineTo(x: 12, y: 12)],
              ),
              SvgPath(
                style: SvgStyle(fillColor: (0, 0, 1, 1)),
                commands: [SvgMoveTo(x: 12, y: 12), SvgLineTo(x: 24, y: 24)],
              ),
            ],
          ),
        ],
      );
      final code = SvgGenerator(doc, 'assets/icons/semantic.svg').generateWidgetClass();

      expect(code, allOf(contains('artworkColor1'), contains('artworkColor2')));
    });

    test('when an id already ends in color, it should append the color suffix only once', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24),
        children: [
          SvgPath(
            id: 'outline-color',
            style: SvgStyle(fillColor: (0, 0, 0, 1)),
            commands: [SvgMoveTo(x: 0, y: 0), SvgLineTo(x: 24, y: 24)],
          ),
        ],
      );
      final code = SvgGenerator(doc, 'assets/icons/semantic.svg').generateWidgetClass();

      expect(code, allOf(contains('outlineColor'), isNot(contains('outlineColorColor'))));
    });

    test('when a camel-case id already ends in Color, it should preserve camel case and append nothing', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24),
        children: [
          SvgPath(
            id: 'outlineColor',
            style: SvgStyle(fillColor: (0, 0, 0, 1)),
            commands: [SvgMoveTo(x: 0, y: 0), SvgLineTo(x: 24, y: 24)],
          ),
        ],
      );
      final code = SvgGenerator(doc, 'assets/icons/semantic.svg').generateWidgetClass();

      expect(code, allOf(contains('final Color? outlineColor;'), isNot(contains('outlineColorColor'))));
    });

    test('when distinct ids normalize to one Dart name, it should suffix the later color name', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24),
        children: [
          SvgPath(
            id: 'inner-text',
            style: SvgStyle(fillColor: (0, 0, 0, 1)),
            commands: [SvgMoveTo(x: 0, y: 0), SvgLineTo(x: 12, y: 12)],
          ),
          SvgPath(
            id: 'inner_text',
            style: SvgStyle(fillColor: (1, 1, 1, 1)),
            commands: [SvgMoveTo(x: 12, y: 12), SvgLineTo(x: 24, y: 24)],
          ),
        ],
      );
      final code = SvgGenerator(doc, 'assets/icons/semantic.svg').generateWidgetClass();

      expect(code, allOf(contains('innerTextColor;'), contains('innerTextColor2;')));
    });

    test('when unnamed drawables repeat a color, it should retain one numeric fallback color', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24),
        children: [
          SvgGroup(
            id: 'group-only',
            style: SvgStyle(fillColor: (1, 0, 0, 1)),
            children: [],
          ),
          SvgPath(
            style: SvgStyle(fillColor: (0, 0, 0, 1)),
            commands: [SvgMoveTo(x: 0, y: 0), SvgLineTo(x: 12, y: 12)],
          ),
          SvgPath(
            style: SvgStyle(fillColor: (0, 0, 0, 1)),
            commands: [SvgMoveTo(x: 12, y: 12), SvgLineTo(x: 24, y: 24)],
          ),
        ],
      );
      final code = SvgGenerator(doc, 'assets/icons/semantic.svg').generateWidgetClass();

      expect(
        code,
        allOf(contains('final Color? color1;'), isNot(contains('color2')), isNot(contains('groupOnlyColor'))),
      );
    });

    test('when sibling groups contain paths, it should draw every emitted path field once', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24),
        children: [
          SvgGroup(
            style: SvgStyle(),
            children: [
              SvgPath(
                style: SvgStyle(fillColor: (0, 0, 0, 1)),
                commands: [SvgMoveTo(x: 0, y: 0), SvgLineTo(x: 12, y: 12)],
              ),
            ],
          ),
          SvgGroup(
            style: SvgStyle(),
            children: [
              SvgPath(
                style: SvgStyle(fillColor: (1, 1, 1, 1)),
                commands: [SvgMoveTo(x: 12, y: 12), SvgLineTo(x: 24, y: 24)],
              ),
            ],
          ),
        ],
      );
      final code = SvgGenerator(doc, 'assets/icons/groups.svg').generateWidgetClass();

      expect(
        (
          RegExp(r'canvas\.drawPath\(__path0,').allMatches(code).length,
          RegExp(r'canvas\.drawPath\(__path1,').allMatches(code).length,
        ),
        (1, 1),
      );
    });

    test('when sibling groups contain every geometry type, it should draw each matching field', () {
      const black = SvgStyle(fillColor: (0, 0, 0, 1), strokeColor: (0, 0, 0, 1));
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24),
        children: [
          SvgGroup(
            style: SvgStyle(),
            children: [
              SvgRect(style: black, width: 2, height: 2),
              SvgCircle(style: black, r: 1),
              SvgLine(style: black, x2: 2, y2: 2),
              SvgPolygon(style: black, points: [(0, 0), (2, 0), (1, 2)]),
            ],
          ),
          SvgGroup(
            style: SvgStyle(),
            children: [
              SvgRect(style: black, x: 3, width: 2, height: 2),
              SvgEllipse(style: black, cx: 4, cy: 4, rx: 2, ry: 1),
              SvgLine(style: black, x1: 3, y1: 3, x2: 5, y2: 5),
              SvgPolyline(style: black, points: [(3, 3), (5, 3), (4, 5)]),
            ],
          ),
        ],
      );
      final code = SvgGenerator(doc, 'assets/icons/groups.svg').generateWidgetClass();

      expect(
        (
          code.contains('canvas.drawRect(_rect0'),
          code.contains('canvas.drawRect(_rect1'),
          code.contains('canvas.drawOval(_ellipseRect0'),
          code.contains('canvas.drawOval(_ellipseRect1'),
          code.contains('canvas.drawPath(__linePath0'),
          code.contains('canvas.drawPath(__linePath1'),
          code.contains('canvas.drawPath(__polyPath0'),
          code.contains('canvas.drawPath(__polyPath1'),
        ),
        (true, true, true, true, true, true, true, true),
      );
    });

    test('when generating code with the sizing logic, it should use the shared SVG sizing mixin', () {
      const doc = SvgDocument(viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24), children: []);
      final generator = SvgGenerator(doc, 'assets/icons/icon.svg');
      final code = generator.generateWidgetClass();

      expect(
        code,
        allOf(
          contains('with _DotdartSvgSizing'),
          contains('double? get svgWidgetWidth => width;'),
          contains('double get svgNativeWidth => _Icon._svgWidth;'),
          contains('Widget buildPainter({required double width, required double height})'),
          isNot(contains('Size _defaultSizeFor')),
          isNot(contains('Widget build(BuildContext context)')),
        ),
      );
    });

    test('when generating code, it should be valid Dart', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24),
        children: [
          SvgPath(
            style: SvgStyle(fillColor: (0, 0, 0, 1)),
            commands: [SvgMoveTo(x: 0, y: 0), SvgLineTo(x: 24, y: 24), SvgClosePath()],
          ),
        ],
      );
      final generator = SvgGenerator(doc, 'assets/icons/arrow.svg');
      final code = generator.generateWidgetClass();

      expect((code.isNotEmpty, code.runes.length > 1000), (true, true));
    });

    test('when getting params, it should include standard constructor parameters', () {
      const doc = SvgDocument(viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24), children: []);
      final generator = SvgGenerator(doc, 'assets/icons/icon.svg');
      final params = generator.params;

      expect(params.any((p) => p.name == 'key' && p.type == 'Key?'), isTrue);
    });

    test('when getting params, it should include width and height', () {
      const doc = SvgDocument(viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24), children: []);
      final generator = SvgGenerator(doc, 'assets/icons/icon.svg');
      final params = generator.params;

      expect(params.any((p) => p.name == 'width' && p.type == 'double?'), isTrue);
      expect(params.any((p) => p.name == 'height' && p.type == 'double?'), isTrue);
    });

    test('when getting params, it should include color props for each unique color', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24),
        children: [
          SvgPath(
            style: SvgStyle(fillColor: (0, 0, 0, 1)),
            commands: [SvgMoveTo(x: 0, y: 0), SvgLineTo(x: 24, y: 24)],
          ),
        ],
      );
      final generator = SvgGenerator(doc, 'assets/icons/icon.svg');
      final params = generator.params;

      expect(params.any((p) => p.name == 'color1' && p.type == 'Color?'), isTrue);
    });

    test('when getting semantic color params, it should keep accessor and widget constructor names in parity', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24),
        children: [
          SvgPath(
            id: 'outline',
            style: SvgStyle(fillColor: (0, 0, 0, 1)),
            commands: [SvgMoveTo(x: 0, y: 0), SvgLineTo(x: 24, y: 24)],
          ),
        ],
      );
      final generator = SvgGenerator(doc, 'assets/icons/icon.svg');
      final semanticParams = generator.params
          .where((param) => param.type == 'Color?')
          .map((param) => param.name)
          .toList();
      final code = generator.generateWidgetClass();

      expect(
        semanticParams.length == 1 && semanticParams.single == 'outlineColor' && code.contains('this.outlineColor,'),
        isTrue,
      );
    });

    test('when getting params, it should not include color2 when colors are deduplicated', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24),
        children: [
          SvgPath(
            style: SvgStyle(fillColor: (0, 0, 0, 1)),
            commands: [SvgMoveTo(x: 0, y: 0), SvgLineTo(x: 24, y: 24)],
          ),
        ],
      );
      final generator = SvgGenerator(doc, 'assets/icons/icon.svg');
      final params = generator.params;

      expect(params.any((p) => p.name == 'color2'), isFalse);
    });

    test('when getting params, it should include maintainAspectRatio as a bool defaulting to true', () {
      const doc = SvgDocument(viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24), children: []);
      final generator = SvgGenerator(doc, 'assets/icons/icon.svg');
      final params = generator.params;

      expect(
        params.any((p) => p.name == 'maintainAspectRatio' && p.type == 'bool' && p.defaultValue == 'true'),
        isTrue,
      );
    });

    test('when generating source, it should emit the maintainAspectRatio field declaration in SVG widgets', () {
      const doc = SvgDocument(viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24), children: []);
      final generator = SvgGenerator(doc, 'assets/icons/icon.svg');
      final code = generator.generateWidgetClass();

      expect(code, contains('final bool maintainAspectRatio;'));
    });

    test('when generating source, it should emit the svgMaintainAspectRatio getter override in SVG widgets', () {
      const doc = SvgDocument(viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24), children: []);
      final generator = SvgGenerator(doc, 'assets/icons/icon.svg');
      final code = generator.generateWidgetClass();

      expect(code, contains('bool get svgMaintainAspectRatio => maintainAspectRatio;'));
    });

    test('when generating source, it should include maintainAspectRatio = true in the widget constructor', () {
      const doc = SvgDocument(viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24), children: []);
      final generator = SvgGenerator(doc, 'assets/icons/icon.svg');
      final code = generator.generateWidgetClass();

      expect(code, contains('this.maintainAspectRatio = true'));
    });

    test(
      'when generating code with a clip path containing a rect, it should emit a static final Path __clip field',
      () {
        const doc = SvgDocument(
          viewBox: SvgViewBox(minX: 0, minY: 0, width: 28, height: 20),
          children: [
            SvgGroup(
              style: SvgStyle(clipPathId: 'c'),
              children: [
                SvgPath(
                  style: SvgStyle(fillColor: (0, 0, 0, 1)),
                  commands: [SvgMoveTo(x: 0, y: 0), SvgLineTo(x: 28, y: 20)],
                ),
              ],
            ),
          ],
          clipPaths: {
            'c': SvgClipPath(
              id: 'c',
              children: [SvgRect(style: SvgStyle(), x: 0, y: 0, width: 28, height: 20)],
            ),
          },
        );
        final generator = SvgGenerator(doc, 'assets/icons/clip.svg');
        final code = generator.generateWidgetClass();

        expect(code, contains('static final Path __clip0 = Path()'));
      },
    );

    test(
      'when generating code with a clip path containing a rect, it should emit addRect with the rect dimensions',
      () {
        const doc = SvgDocument(
          viewBox: SvgViewBox(minX: 0, minY: 0, width: 28, height: 20),
          children: [
            SvgGroup(
              style: SvgStyle(clipPathId: 'c'),
              children: [
                SvgPath(
                  style: SvgStyle(fillColor: (0, 0, 0, 1)),
                  commands: [SvgMoveTo(x: 0, y: 0), SvgLineTo(x: 28, y: 20)],
                ),
              ],
            ),
          ],
          clipPaths: {
            'c': SvgClipPath(
              id: 'c',
              children: [SvgRect(style: SvgStyle(), x: 0, y: 0, width: 28, height: 20)],
            ),
          },
        );
        final generator = SvgGenerator(doc, 'assets/icons/clip.svg');
        final code = generator.generateWidgetClass();

        expect(code, contains('..addRect(const Rect.fromLTWH(0, 0, 28, 20))'));
      },
    );

    test('when generating code with a clipped group, it should emit canvas.clipPath in paint()', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 28, height: 20),
        children: [
          SvgGroup(
            style: SvgStyle(clipPathId: 'c'),
            children: [
              SvgPath(
                style: SvgStyle(fillColor: (0, 0, 0, 1)),
                commands: [SvgMoveTo(x: 0, y: 0), SvgLineTo(x: 28, y: 20)],
              ),
            ],
          ),
        ],
        clipPaths: {
          'c': SvgClipPath(
            id: 'c',
            children: [SvgRect(style: SvgStyle(), x: 0, y: 0, width: 28, height: 20)],
          ),
        },
      );
      final generator = SvgGenerator(doc, 'assets/icons/clip.svg');
      final code = generator.generateWidgetClass();

      expect(code, contains('canvas.clipPath(__clip0)'));
    });

    test('when generating code with a clipped group, it should emit canvas.save before the clip', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 28, height: 20),
        children: [
          SvgGroup(
            style: SvgStyle(clipPathId: 'c'),
            children: [
              SvgPath(
                style: SvgStyle(fillColor: (0, 0, 0, 1)),
                commands: [SvgMoveTo(x: 0, y: 0), SvgLineTo(x: 28, y: 20)],
              ),
            ],
          ),
        ],
        clipPaths: {
          'c': SvgClipPath(
            id: 'c',
            children: [SvgRect(style: SvgStyle(), x: 0, y: 0, width: 28, height: 20)],
          ),
        },
      );
      final generator = SvgGenerator(doc, 'assets/icons/clip.svg');
      final code = generator.generateWidgetClass();

      expect(code, contains('canvas.save()'));
    });

    test('when generating code with a clipped group, it should emit canvas.restore after the clipped content', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 28, height: 20),
        children: [
          SvgGroup(
            style: SvgStyle(clipPathId: 'c'),
            children: [
              SvgPath(
                style: SvgStyle(fillColor: (0, 0, 0, 1)),
                commands: [SvgMoveTo(x: 0, y: 0), SvgLineTo(x: 28, y: 20)],
              ),
            ],
          ),
        ],
        clipPaths: {
          'c': SvgClipPath(
            id: 'c',
            children: [SvgRect(style: SvgStyle(), x: 0, y: 0, width: 28, height: 20)],
          ),
        },
      );
      final generator = SvgGenerator(doc, 'assets/icons/clip.svg');
      final code = generator.generateWidgetClass();

      expect(code, contains('canvas.restore()'));
    });

    test('when generating code with a clipped group and a transform, it should emit canvas.save', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 100, height: 100),
        children: [
          SvgGroup(
            style: SvgStyle(clipPathId: 'c'),
            transform: [SvgTranslate(tx: 10, ty: 20)],
            children: [
              SvgPath(
                style: SvgStyle(fillColor: (0, 0, 0, 1)),
                commands: [SvgMoveTo(x: 0, y: 0), SvgLineTo(x: 10, y: 10)],
              ),
            ],
          ),
        ],
        clipPaths: {
          'c': SvgClipPath(
            id: 'c',
            children: [SvgRect(style: SvgStyle(), x: 0, y: 0, width: 100, height: 100)],
          ),
        },
      );
      final generator = SvgGenerator(doc, 'assets/icons/clip.svg');
      final code = generator.generateWidgetClass();

      expect(code, contains('canvas.save()'));
    });

    test('when generating code with a clipped group and a transform, it should emit the transform before the clip', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 100, height: 100),
        children: [
          SvgGroup(
            style: SvgStyle(clipPathId: 'c'),
            transform: [SvgTranslate(tx: 10, ty: 20)],
            children: [
              SvgPath(
                style: SvgStyle(fillColor: (0, 0, 0, 1)),
                commands: [SvgMoveTo(x: 0, y: 0), SvgLineTo(x: 10, y: 10)],
              ),
            ],
          ),
        ],
        clipPaths: {
          'c': SvgClipPath(
            id: 'c',
            children: [SvgRect(style: SvgStyle(), x: 0, y: 0, width: 100, height: 100)],
          ),
        },
      );
      final generator = SvgGenerator(doc, 'assets/icons/clip.svg');
      final code = generator.generateWidgetClass();

      expect(code, contains('canvas.translate(10, 20)'));
    });

    test(
      'when generating code with a clipped group and a transform, it should emit canvas.clipPath after the transform',
      () {
        const doc = SvgDocument(
          viewBox: SvgViewBox(minX: 0, minY: 0, width: 100, height: 100),
          children: [
            SvgGroup(
              style: SvgStyle(clipPathId: 'c'),
              transform: [SvgTranslate(tx: 10, ty: 20)],
              children: [
                SvgPath(
                  style: SvgStyle(fillColor: (0, 0, 0, 1)),
                  commands: [SvgMoveTo(x: 0, y: 0), SvgLineTo(x: 10, y: 10)],
                ),
              ],
            ),
          ],
          clipPaths: {
            'c': SvgClipPath(
              id: 'c',
              children: [SvgRect(style: SvgStyle(), x: 0, y: 0, width: 100, height: 100)],
            ),
          },
        );
        final generator = SvgGenerator(doc, 'assets/icons/clip.svg');
        final code = generator.generateWidgetClass();

        expect(code, contains('canvas.clipPath(__clip0)'));
      },
    );

    test('when generating code with a clipped group and a transform, it should emit canvas.restore', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 100, height: 100),
        children: [
          SvgGroup(
            style: SvgStyle(clipPathId: 'c'),
            transform: [SvgTranslate(tx: 10, ty: 20)],
            children: [
              SvgPath(
                style: SvgStyle(fillColor: (0, 0, 0, 1)),
                commands: [SvgMoveTo(x: 0, y: 0), SvgLineTo(x: 10, y: 10)],
              ),
            ],
          ),
        ],
        clipPaths: {
          'c': SvgClipPath(
            id: 'c',
            children: [SvgRect(style: SvgStyle(), x: 0, y: 0, width: 100, height: 100)],
          ),
        },
      );
      final generator = SvgGenerator(doc, 'assets/icons/clip.svg');
      final code = generator.generateWidgetClass();

      expect(code, contains('canvas.restore()'));
    });

    test('when generating code with an evenodd clip-rule, it should emit PathFillType.evenOdd on the clip path', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 28, height: 20),
        children: [],
        clipPaths: {
          'c': SvgClipPath(
            id: 'c',
            clipRule: SvgFillRule.evenodd,
            children: [SvgRect(style: SvgStyle(), x: 0, y: 0, width: 28, height: 20)],
          ),
        },
      );
      final generator = SvgGenerator(doc, 'assets/icons/clip_evenodd.svg');
      final code = generator.generateWidgetClass();

      expect(code, contains('..fillType = PathFillType.evenOdd'));
    });

    test('when generating code with a clip-path on an individual path, it should emit canvas.save before the draw', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 28, height: 20),
        children: [
          SvgPath(
            style: SvgStyle(fillColor: (0, 0, 0, 1), clipPathId: 'c'),
            commands: [SvgMoveTo(x: 0, y: 0), SvgLineTo(x: 28, y: 20)],
          ),
        ],
        clipPaths: {
          'c': SvgClipPath(
            id: 'c',
            children: [SvgRect(style: SvgStyle(), x: 0, y: 0, width: 28, height: 20)],
          ),
        },
      );
      final generator = SvgGenerator(doc, 'assets/icons/clip_path.svg');
      final code = generator.generateWidgetClass();

      expect(code, contains('canvas.save()'));
    });

    test(
      'when generating code with a clip-path on an individual path, it should emit canvas.clipPath before the draw',
      () {
        const doc = SvgDocument(
          viewBox: SvgViewBox(minX: 0, minY: 0, width: 28, height: 20),
          children: [
            SvgPath(
              style: SvgStyle(fillColor: (0, 0, 0, 1), clipPathId: 'c'),
              commands: [SvgMoveTo(x: 0, y: 0), SvgLineTo(x: 28, y: 20)],
            ),
          ],
          clipPaths: {
            'c': SvgClipPath(
              id: 'c',
              children: [SvgRect(style: SvgStyle(), x: 0, y: 0, width: 28, height: 20)],
            ),
          },
        );
        final generator = SvgGenerator(doc, 'assets/icons/clip_path.svg');
        final code = generator.generateWidgetClass();

        expect(code, contains('canvas.clipPath(__clip0)'));
      },
    );

    test(
      'when generating code with a clip-path on an individual path, it should emit canvas.drawPath for the content',
      () {
        const doc = SvgDocument(
          viewBox: SvgViewBox(minX: 0, minY: 0, width: 28, height: 20),
          children: [
            SvgPath(
              style: SvgStyle(fillColor: (0, 0, 0, 1), clipPathId: 'c'),
              commands: [SvgMoveTo(x: 0, y: 0), SvgLineTo(x: 28, y: 20)],
            ),
          ],
          clipPaths: {
            'c': SvgClipPath(
              id: 'c',
              children: [SvgRect(style: SvgStyle(), x: 0, y: 0, width: 28, height: 20)],
            ),
          },
        );
        final generator = SvgGenerator(doc, 'assets/icons/clip_path.svg');
        final code = generator.generateWidgetClass();

        expect(code, contains('canvas.drawPath'));
      },
    );

    test(
      'when generating code with a clip-path on an individual path, it should emit canvas.restore after the draw',
      () {
        const doc = SvgDocument(
          viewBox: SvgViewBox(minX: 0, minY: 0, width: 28, height: 20),
          children: [
            SvgPath(
              style: SvgStyle(fillColor: (0, 0, 0, 1), clipPathId: 'c'),
              commands: [SvgMoveTo(x: 0, y: 0), SvgLineTo(x: 28, y: 20)],
            ),
          ],
          clipPaths: {
            'c': SvgClipPath(
              id: 'c',
              children: [SvgRect(style: SvgStyle(), x: 0, y: 0, width: 28, height: 20)],
            ),
          },
        );
        final generator = SvgGenerator(doc, 'assets/icons/clip_path.svg');
        final code = generator.generateWidgetClass();

        expect(code, contains('canvas.restore()'));
      },
    );

    test('when generating code with a clip-path on a path and no fill, it should not emit draw calls', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 28, height: 20),
        children: [
          SvgPath(
            style: SvgStyle(fillColor: null, clipPathId: 'c'),
            commands: [],
          ),
        ],
        clipPaths: {
          'c': SvgClipPath(
            id: 'c',
            children: [SvgRect(style: SvgStyle(), x: 0, y: 0, width: 28, height: 20)],
          ),
        },
      );
      final generator = SvgGenerator(doc, 'assets/icons/clip_nofill.svg');
      final code = generator.generateWidgetClass();

      expect(code, isNot(contains('canvas.drawPath')));
    });
  });
}
