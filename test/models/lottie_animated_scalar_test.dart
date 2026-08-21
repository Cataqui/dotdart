import 'package:dotdart/src/models/lottie_animated_scalar.dart';
import 'package:dotdart/src/models/lottie_keyframe.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LottieAnimatedScalar', () {
    test('when animated is false, it should store the static value', () {
      const scalar = LottieAnimatedScalar(animated: false, staticValue: 75);

      expect((scalar.animated, scalar.staticValue), (false, 75));
    });

    test('when animated is true, it should store keyframes', () {
      const keyframe = LottieScalarKeyframe(time: 0, start: 10);
      const scalar = LottieAnimatedScalar(animated: true, keyframes: [keyframe]);

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
