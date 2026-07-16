// Canvas.cascade and ..save()/..scale() fragments produce cleaner test code
// but trigger cascade_invocations. This is a known false positive.
// ignore_for_file: cascade_invocations

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Generated SVG CustomPainter rendering', () {
    testWidgets('when a CustomPainter draws a path with fill like generated code, it should paint without errors', (
      tester,
    ) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: SizedBox(
            width: 200,
            height: 200,
            child: RepaintBoundary(
              child: CustomPaint(painter: _MockPathFillPainter(), size: const Size(200, 200)),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('when a CustomPainter draws a stroke-only path like generated code, it should paint without errors', (
      tester,
    ) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: SizedBox(
            width: 200,
            height: 200,
            child: RepaintBoundary(
              child: CustomPaint(painter: _MockStrokePainter(), size: const Size(200, 200)),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'when a CustomPainter draws a path with even-odd fill like generated code, it should paint without errors',
      (tester) async {
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(
              width: 200,
              height: 200,
              child: RepaintBoundary(
                child: CustomPaint(painter: _MockEvenOddPainter(), size: const Size(200, 200)),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'when a CustomPainter uses nested canvas save/restore like group transforms, it should paint without errors',
      (tester) async {
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(
              width: 200,
              height: 200,
              child: RepaintBoundary(
                child: CustomPaint(painter: _MockGroupTransformPainter(), size: const Size(200, 200)),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'when a CustomPainter uses reuse fill and stroke paints like generated code, it should paint without errors',
      (tester) async {
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(
              width: 200,
              height: 200,
              child: RepaintBoundary(
                child: CustomPaint(painter: _MockReusablePaintPainter(), size: const Size(200, 200)),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'when a CustomPainter scales and offsets a viewBox like generated code, it should paint without errors',
      (tester) async {
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(
              width: 200,
              height: 200,
              child: RepaintBoundary(
                child: CustomPaint(painter: _MockViewBoxPainter(), size: const Size(200, 200)),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );
  });
}

class _MockPathFillPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 24;
    final scaleY = size.height / 24;
    canvas
      ..save()
      ..scale(scaleX, scaleY);

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(24, 24)
      ..close();
    final paint = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MockStrokePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 24;
    final scaleY = size.height / 24;
    canvas
      ..save()
      ..scale(scaleX, scaleY);

    final path = Path()
      ..moveTo(0.75, 0.75)
      ..lineTo(23.25, 23.25)
      ..moveTo(23.25, 0.75)
      ..lineTo(0.75, 23.25);
    final paint = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MockEvenOddPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 24;
    final scaleY = size.height / 24;
    canvas
      ..save()
      ..scale(scaleX, scaleY);

    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..moveTo(0, 0)
      ..lineTo(24, 0)
      ..lineTo(24, 24)
      ..lineTo(0, 24)
      ..close()
      ..moveTo(6, 6)
      ..lineTo(18, 6)
      ..lineTo(18, 18)
      ..lineTo(6, 18)
      ..close();
    final paint = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MockGroupTransformPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 100;
    final scaleY = size.height / 100;
    canvas
      ..save()
      ..scale(scaleX, scaleY);

    // Group with translate
    canvas
      ..save()
      ..translate(10, 20);

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(50, 50);
    final paint = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);

    canvas.restore();

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MockReusablePaintPainter extends CustomPainter {
  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;
  final Paint _strokePaint = Paint()..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 24;
    final scaleY = size.height / 24;
    canvas
      ..save()
      ..scale(scaleX, scaleY);

    // Fill element 1
    final fillPath1 = Path()
      ..moveTo(0, 0)
      ..lineTo(12, 12)
      ..close();
    canvas.drawPath(fillPath1, _fillPaint..color = const Color(0xFF000000));

    // Fill element 2 with same paint (reuse, just change color via cascade)
    final fillPath2 = Path()
      ..moveTo(12, 12)
      ..lineTo(24, 24)
      ..close();
    canvas.drawPath(fillPath2, _fillPaint..color = const Color(0xFFFF0000));

    // Stroke element with stroke paint
    final strokePath = Path()
      ..moveTo(0, 24)
      ..lineTo(24, 0);
    canvas.drawPath(
      strokePath,
      _strokePaint
        ..color = const Color(0xFF0000FF)
        ..strokeWidth = 2,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MockViewBoxPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 100;
    final scaleY = size.height / 100;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(-3, -5);

    final path = Path()
      ..moveTo(3, 5)
      ..lineTo(103, 105);
    final paint = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
