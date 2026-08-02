import 'package:dotdart/src/models/lottie_keyframe.dart';
import 'package:dotdart/src/models/lottie_layer.dart';
import 'package:dotdart/src/models/lottie_shape.dart';
import 'package:dotdart/src/models/lottie_text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LottieLayer', () {
    test('when creating a layer with all fields, it should store them', () {
      const group = LottieGroup(name: 'G1', items: []);
      const opacity = LottieAnimatedScalar(animated: false, staticValue: 100);
      const text = LottieText(
        value: 'Title',
        fontFamily: 'Inter',
        fontWeight: 600,
        italic: false,
        fontSize: 16,
        lineHeight: 20,
        tracking: 0,
        justification: 0,
        colorR: 0,
        colorG: 0,
        colorB: 0,
        colorA: 1,
      );
      const layer = LottieLayer(
        name: 'Layer A',
        shapeGroups: [group],
        layerIndex: 7,
        parentIndex: 3,
        referenceId: 'composition',
        text: text,
        masks: [LottiePath(vertices: [], inTangents: [], outTangents: [], closed: true)],
        opacity: opacity,
        rotation: opacity,
        positionX: opacity,
        positionY: opacity,
        anchorX: 10,
        anchorY: 20,
        scaleX: opacity,
        scaleY: opacity,
        inPoint: 5,
        outPoint: 25,
        startTime: 2,
        stretch: 0.5,
      );

      expect(
        (
          layer.name,
          layer.shapeGroups.length,
          layer.layerIndex,
          layer.parentIndex,
          layer.referenceId,
          layer.text?.value,
          layer.masks.length,
          layer.anchorX,
          layer.anchorY,
          layer.inPoint,
          layer.outPoint,
          layer.startTime,
          layer.stretch,
        ),
        ('Layer A', 1, 7, 3, 'composition', 'Title', 1, 10, 20, 5, 25, 2, 0.5),
      );
    });

    test('when inPoint and outPoint are not provided, they should default to 0', () {
      const layer = LottieLayer(name: 'Layer', shapeGroups: []);

      expect((layer.inPoint, layer.outPoint), (0, 0));
    });

    test('when anchor is not provided, it should default to null', () {
      const layer = LottieLayer(name: 'Layer', shapeGroups: []);

      expect(layer.anchorX, isNull);
      expect(layer.anchorY, isNull);
    });

    test('when transform properties are null, they should default to null', () {
      const layer = LottieLayer(name: 'Layer', shapeGroups: []);

      expect(layer.opacity, isNull);
      expect(layer.rotation, isNull);
      expect(layer.positionX, isNull);
      expect(layer.positionY, isNull);
      expect(layer.scaleX, isNull);
      expect(layer.scaleY, isNull);
    });
  });

  group('LottieAnimatedScalar', () {
    test('when animated is false, it should store the static value', () {
      const scalar = LottieAnimatedScalar(animated: false, staticValue: 75);

      expect((scalar.animated, scalar.staticValue), (false, 75));
    });

    test('when animated is true, it should store keyframes', () {
      const kf = LottieScalarKeyframe(time: 0, start: 10);
      const scalar = LottieAnimatedScalar(animated: true, keyframes: [kf]);

      expect((scalar.animated, scalar.keyframes.length), (true, 1));
    });

    test('when keyframes are not provided, they should default to empty', () {
      const scalar = LottieAnimatedScalar(animated: true);

      expect(scalar.keyframes, isEmpty);
    });

    test('when staticValue is not provided, it should default to 0', () {
      const scalar = LottieAnimatedScalar(animated: false);

      expect(scalar.staticValue, 0);
    });
  });
}
