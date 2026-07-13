import 'package:dotdart/src/models/lottie_shape.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LottiePath', () {
    test('when creating a closed path with vertices and tangents, it should store all of them', () {
      const path = LottiePath(
        vertices: [
          [0, 0],
          [10, 20],
        ],
        inTangents: [
          [1, 1],
          [2, 2],
        ],
        outTangents: [
          [3, 3],
          [4, 4],
        ],
        closed: true,
      );

      expect((path.vertices.length, path.inTangents.length, path.outTangents.length, path.closed), (2, 2, 2, true));
    });

    test('when creating an open path, it should store closed as false', () {
      const path = LottiePath(
        vertices: [
          [0, 0],
          [5, 5],
        ],
        inTangents: [
          [0, 0],
          [0, 0],
        ],
        outTangents: [
          [0, 0],
          [0, 0],
        ],
        closed: false,
      );

      expect(path.closed, isFalse);
    });
  });

  group('LottieRect', () {
    test('when creating a rect with all fields, it should store them', () {
      const rect = LottieRect(
        positionX: 10,
        positionY: 20,
        width: 100,
        height: 50,
        cornerRadius: 8,
        direction: 1,
      );

      expect((rect.positionX, rect.positionY, rect.width, rect.height, rect.cornerRadius, rect.direction),
          (10, 20, 100, 50, 8, 1));
    });

    test('when direction is not provided, it should default to 1 (clockwise)', () {
      const rect = LottieRect(positionX: 0, positionY: 0, width: 100, height: 100, cornerRadius: 0);

      expect(rect.direction, 1);
    });
  });

  group('LottieEllipse', () {
    test('when creating an ellipse with all fields, it should store them', () {
      const ellipse = LottieEllipse(positionX: 50, positionY: 50, width: 80, height: 60, direction: 1);

      expect((ellipse.positionX, ellipse.positionY, ellipse.width, ellipse.height, ellipse.direction), (50, 50, 80, 60, 1));
    });

    test('when direction is not provided, it should default to 1 (clockwise)', () {
      const ellipse = LottieEllipse(positionX: 0, positionY: 0, width: 100, height: 100);

      expect(ellipse.direction, 1);
    });
  });

  group('LottieFill', () {
    test('when creating a fill with all fields, it should store them', () {
      const fill = LottieFill(colorR: 1, colorG: 0, colorB: 0, colorA: 0.5, opacity: 80, fillRule: 2);

      expect((fill.colorR, fill.colorG, fill.colorB, fill.colorA, fill.opacity, fill.fillRule), (1, 0, 0, 0.5, 80, 2));
    });

    test('when fillRule is not provided, it should default to 1 (non-zero)', () {
      const fill = LottieFill(colorR: 0, colorG: 0, colorB: 0, colorA: 1, opacity: 100);

      expect(fill.fillRule, 1);
    });
  });

  group('LottieStroke', () {
    test('when creating a stroke with all fields, it should store them', () {
      const stroke = LottieStroke(
        colorR: 0,
        colorG: 0,
        colorB: 1,
        colorA: 1,
        opacity: 100,
        width: 3,
        lineCap: 1,
        lineJoin: 3,
      );

      expect((stroke.colorR, stroke.colorG, stroke.colorB, stroke.colorA, stroke.opacity, stroke.width, stroke.lineCap, stroke.lineJoin),
          (0, 0, 1, 1, 100, 3, 1, 3));
    });

    test('when lineCap and lineJoin are not provided, they should default to 1', () {
      const stroke = LottieStroke(colorR: 0, colorG: 0, colorB: 0, colorA: 1, opacity: 100, width: 2);

      expect((stroke.lineCap, stroke.lineJoin), (1, 1));
    });
  });

  group('LottieGroupTransform', () {
    test('when no transform values are provided, they should all default', () {
      const transform = LottieGroupTransform();

      expect(
        (transform.positionX, transform.positionY, transform.anchorX, transform.anchorY, transform.scaleX, transform.scaleY, transform.rotation, transform.opacity),
        (0, 0, 0, 0, 100, 100, 0, 100),
      );
    });

    test('when creating a transform with custom values, it should store them', () {
      const transform = LottieGroupTransform(
        positionX: 50,
        positionY: 60,
        anchorX: 10,
        anchorY: 20,
        scaleX: 150,
        scaleY: 80,
        rotation: 45,
        opacity: 50,
      );

      expect((transform.positionX, transform.positionY, transform.anchorX, transform.anchorY),
          (50, 60, 10, 20));
    });
  });

  group('LottieGroup', () {
    test('when creating a group with items, it should store name and items', () {
      const rect = LottieRect(positionX: 0, positionY: 0, width: 10, height: 10, cornerRadius: 0);
      const group = LottieGroup(name: 'My Group', items: [rect]);

      expect((group.name, group.items.length), ('My Group', 1));
    });

    test('when creating a group with no items, it should store an empty list', () {
      const group = LottieGroup(name: 'Empty', items: []);

      expect(group.items, isEmpty);
    });

    test('when a group has fill and stroke as items, it should store them as shapes', () {
      const fill = LottieFill(colorR: 1, colorG: 0, colorB: 0, colorA: 1, opacity: 100);
      const stroke = LottieStroke(colorR: 0, colorG: 0, colorB: 1, colorA: 1, opacity: 100, width: 2);
      const group = LottieGroup(name: 'Colored', items: [fill, stroke]);

      expect(group.items.length, 2);
    });
  });
}
