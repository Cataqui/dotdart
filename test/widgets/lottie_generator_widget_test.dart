import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Generated CustomPainter rendering', () {
    testWidgets('when a CustomPainter draws rect fill and stroke like generated code, it should paint without errors', (
      tester,
    ) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: SizedBox(
            width: 200,
            height: 200,
            child: RepaintBoundary(
              child: CustomPaint(painter: _MockRectPainter(), size: const Size(200, 200)),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('when a CustomPainter draws an ellipse like generated code, it should paint without errors', (
      tester,
    ) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: SizedBox(
            width: 200,
            height: 200,
            child: RepaintBoundary(
              child: CustomPaint(painter: _MockEllipsePainter(), size: const Size(200, 200)),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'when a CustomPainter draws a path with fill and stroke like generated code, it should paint without errors',
      (tester) async {
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(
              width: 200,
              height: 200,
              child: RepaintBoundary(
                child: CustomPaint(painter: _MockPathPainter(), size: const Size(200, 200)),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'when a CustomPainter uses canvas.save/restore and translate like generated code, it should paint without errors',
      (tester) async {
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(
              width: 200,
              height: 200,
              child: RepaintBoundary(
                child: CustomPaint(painter: _MockTransformedPainter(), size: const Size(200, 200)),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );
  });

}

class _MockRectPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 200;
    final scaleY = size.height / 200;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(100, 100);

    final bodyRect = Rect.fromCenter(center: Offset.zero, width: 100, height: 50);
    final body = RRect.fromRectAndRadius(bodyRect, const Radius.circular(10));

    final fillPaint = Paint()
      ..color = const Color(0xFFFF0000)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(body, fillPaint);

    final strokePaint = Paint()
      ..color = const Color(0xFF0000FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas
      ..drawRRect(body, strokePaint)
      ..restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MockEllipsePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 100;
    final scaleY = size.height / 100;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(50, 50);

    final rect = Rect.fromCenter(center: Offset.zero, width: 80, height: 60);

    final fillPaint = Paint()
      ..color = const Color(0xFFFF0000)
      ..style = PaintingStyle.fill;
    canvas.drawOval(rect, fillPaint);

    final strokePaint = Paint()
      ..color = const Color(0xFF0000FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas
      ..drawOval(rect, strokePaint)
      ..restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MockPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 100;
    final scaleY = size.height / 100;
    canvas
      ..save()
      ..scale(scaleX, scaleY);

    final path = Path()
      ..moveTo(10, 10)
      ..lineTo(50, 10)
      ..lineTo(50, 50)
      ..close();

    final fillPaint = Paint()
      ..color = const Color(0x8800FF00)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    final strokePaint = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.bevel;
    canvas
      ..drawPath(path, strokePaint)
      ..restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MockTransformedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 200;
    final scaleY = size.height / 200;
    canvas
      ..save()
      ..scale(scaleX, scaleY)
      ..translate(100, 100)
      ..rotate(0.785398)
      ..scale(1.5, 0.8)
      ..translate(-10, -20);

    final bodyRect = Rect.fromCenter(center: Offset.zero, width: 50, height: 50);
    final body = RRect.fromRectAndRadius(bodyRect, Radius.zero);

    final fillPaint = Paint()
      ..color = const Color(0xFFFF0000)
      ..style = PaintingStyle.fill;
    canvas
      ..drawRRect(body, fillPaint)
      ..restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
