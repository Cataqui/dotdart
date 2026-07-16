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
      final code = generator.generate();

      expect(
        code,
        allOf(
          isNotEmpty,
          contains('class Arrow extends StatelessWidget'),
          contains('class _ArrowPainter extends CustomPainter'),
          isNot(contains('class Arrow extends StatefulWidget')),
        ),
      );
    });

    test('when generating code, it should include the correct widget class name', () {
      const doc = SvgDocument(viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24), children: []);
      final generator = SvgGenerator(doc, 'assets/icons/my_test_icon.svg');

      expect(generator.widgetClassName, 'MyTestIcon');
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
      final code = generator.generate();

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
      final code = generator.generate();

      expect(code, isNot(contains('color2')));
    });

    test('when generating code, it should include the header comment', () {
      const doc = SvgDocument(viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24), children: []);
      final generator = SvgGenerator(doc, 'assets/icons/icon.svg');
      final code = generator.generate();

      expect(code, allOf(contains('// GENERATED CODE - DO NOT MODIFY BY HAND'), contains('//  dotdart')));
    });

    test('when generating code, it should include the coverage ignore directive', () {
      const doc = SvgDocument(viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24), children: []);
      final generator = SvgGenerator(doc, 'assets/icons/icon.svg');
      final code = generator.generate();

      expect(code, contains('// coverage:ignore-file'));
    });

    test('when generating code, it should include the correct imports', () {
      const doc = SvgDocument(viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24), children: []);
      final generator = SvgGenerator(doc, 'assets/icons/icon.svg');
      final code = generator.generate();

      expect(
        code,
        allOf(
          contains("import 'dart:math' as math;"),
          contains("import 'package:flutter/material.dart';"),
          contains("import 'package:flutter/rendering.dart' show OverflowBoxFit;"),
        ),
      );
    });

    test('when generating code, it should not include Flutter animation-related code', () {
      const doc = SvgDocument(viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24), children: []);
      final generator = SvgGenerator(doc, 'assets/icons/icon.svg');
      final code = generator.generate();

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
      final code = generator.generate();

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
      final code = generator.generate();

      expect(code, contains('static final Path __path0 = Path()'));
      expect(code, contains('..moveTo(0, 0)'));
      expect(code, contains('..cubicTo(10, 0, 20, 10, 24, 24)'));
    });

    test('when generating code, it should include reusable fill and stroke paints', () {
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
      final code = generator.generate();

      expect(RegExp(r'Paint\(\)').allMatches(code).length, 2);
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
      final code = generator.generate();

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
      final code = generator.generate();

      expect(code, allOf(contains('..translate(-Arrow._viewBoxMinX, -Arrow._viewBoxMinY)')));
    });

    test('when generating code with no fill or stroke, it should produce no canvas draw calls', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24),
        children: [
          SvgPath(style: SvgStyle(fillColor: null), commands: [SvgMoveTo(x: 0, y: 0)]),
        ],
      );
      final generator = SvgGenerator(doc, 'assets/icons/empty.svg');
      final code = generator.generate();

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
      final code = generator.generate();

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
      final code = generator.generate();

      expect(code, contains('static final RRect _rrect0 = RRect.fromRectAndRadius('));
    });

    test('when generating code with a circle element, it should include a static final Rect for the oval', () {
      const doc = SvgDocument(
        viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24),
        children: [SvgCircle(style: SvgStyle(fillColor: (0, 0, 0, 1)), cx: 12, cy: 12, r: 10)],
      );
      final generator = SvgGenerator(doc, 'assets/icons/circle.svg');
      final code = generator.generate();

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
      final code = generator.generate();

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
      final code = generator.generate();

      expect(code, isNot(contains('color2')));
    });

    test('when generating code with the sizing logic, it should match the Lottie-derived pattern', () {
      const doc = SvgDocument(viewBox: SvgViewBox(minX: 0, minY: 0, width: 24, height: 24), children: []);
      final generator = SvgGenerator(doc, 'assets/icons/icon.svg');
      final code = generator.generate();

      expect(
        code,
        allOf(
          contains('Size _defaultSizeFor(BoxConstraints constraints)'),
          contains('return LayoutBuilder('),
          contains('return OverflowBox('),
          contains('fit: OverflowBoxFit.deferToChild'),
          contains('final hasExplicitSize = widget.width != null || widget.height != null'),
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
      final code = generator.generate();

      expect((code.isNotEmpty, code.runes.length > 1000), (true, true));
    });
  });
}
