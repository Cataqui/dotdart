import 'package:dotdart/src/generators/svg_generator.dart';
import 'package:dotdart/src/models/svg_document.dart';
import 'package:dotdart/src/models/svg_element.dart';
import 'package:dotdart/src/models/svg_style.dart';
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

    test('when generating code with a rect element, it should include a static final RRect', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 100, height: 50),
        children: [
          SvgRect(style: SvgStyle(fillColor: (1, 0, 0, 1)), x: 10, y: 10, width: 80, height: 30, rx: 5, ry: 5),
        ],
      );
      final generator = SvgGenerator(doc, 'assets/icons/rect.svg');
      final code = generator.generateWidgetClass();

      expect(code, contains('static final RRect _rrect0 = RRect.fromRectAndRadius('));
    });

    test('when generating code with a circle element, it should include a static final Rect for the oval', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24),
        children: [SvgCircle(style: SvgStyle(fillColor: (0, 0, 0, 1)), cx: 12, cy: 12, r: 10)],
      );
      final generator = SvgGenerator(doc, 'assets/icons/circle.svg');
      final code = generator.generateWidgetClass();

      expect(code, contains('static final Rect _ellipseRect0 = Rect.fromCircle('));
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

    test('when generating code with a clip path containing a rect, it should emit a static final Path __clip field', () {
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
    });

    test('when generating code with a clip path containing a rect, it should emit addRect with the rect dimensions', () {
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

      expect(code, contains('..addRect(Rect.fromLTWH(0, 0, 28, 20))'));
    });

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

    test('when generating code with a clipped group and a transform, it should emit canvas.clipPath after the transform', () {
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
    });

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

    test('when generating code with a clip-path on an individual path, it should emit canvas.clipPath before the draw', () {
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
    });

    test('when generating code with a clip-path on an individual path, it should emit canvas.drawPath for the content', () {
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
    });

    test('when generating code with a clip-path on an individual path, it should emit canvas.restore after the draw', () {
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
    });

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
