import 'package:dotdart/src/models/lottie_animation.dart';
import 'package:dotdart/src/models/lottie_layer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LottieAnimation', () {
    test('when the animation span is 60 frames at 60fps, it should compute 1000ms', () {
      const animation = LottieAnimation(
        width: 200,
        height: 200,
        frameRate: 60,
        inPoint: 0,
        outPoint: 60,
        name: 'Test',
        layers: [],
      );

      expect(animation.durationMs, 1000);
    });

    test('when inPoint is non-zero, it should compute the correct duration', () {
      const animation = LottieAnimation(
        width: 200,
        height: 200,
        frameRate: 30,
        inPoint: 10,
        outPoint: 70,
        name: 'Test',
        layers: [],
      );

      expect(animation.durationMs, 2000);
    });

    test('when total frames is computed, it should equal outPoint minus inPoint', () {
      const animation = LottieAnimation(
        width: 200,
        height: 200,
        frameRate: 60,
        inPoint: 5,
        outPoint: 65,
        name: 'Test',
        layers: [],
      );

      expect(animation.totalFrames, 60);
    });

    test('when the animation has layers, it should store them', () {
      const layer = LottieLayer(name: 'Layer A', shapeGroups: []);
      const animation = LottieAnimation(
        width: 100,
        height: 100,
        frameRate: 30,
        inPoint: 0,
        outPoint: 30,
        name: 'Layered',
        layers: [layer],
      );

      expect(animation.layers.length, 1);
    });
  });
}
