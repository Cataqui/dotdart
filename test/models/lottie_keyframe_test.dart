import 'package:dotdart/src/models/lottie_keyframe.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LottieScalarKeyframe', () {
    test('when creating a keyframe with only required fields, it should store time and start', () {
      const kf = LottieScalarKeyframe(time: 10, start: 50);

      expect((kf.time, kf.start), (10, 50));
    });

    test('when creating a keyframe with all optional fields, it should store end and easing', () {
      const kf = LottieScalarKeyframe(time: 20, start: 100, end: 200, outX: 0.5, outY: 0, inX: 0.5, inY: 1);

      expect((kf.time, kf.start, kf.end, kf.outX, kf.outY, kf.inX, kf.inY), (20, 100, 200, 0.5, 0, 0.5, 1));
    });

    test('when a keyframe is not marked as hold, it should default to false', () {
      const kf = LottieScalarKeyframe(time: 0, start: 0);

      expect(kf.hold, isFalse);
    });

    test('when a keyframe is a hold keyframe, it should set hold to true', () {
      const kf = LottieScalarKeyframe(time: 15, start: 0, hold: true);

      expect(kf.hold, isTrue);
    });

    test('when end is null on a regular keyframe, it should accept null', () {
      const kf = LottieScalarKeyframe(time: 0, start: 0);

      expect(kf.end, isNull);
    });

    test('when easing handles are null, they should default to null', () {
      const kf = LottieScalarKeyframe(time: 0, start: 0);

      expect(kf.outX, isNull);
      expect(kf.outY, isNull);
      expect(kf.inX, isNull);
      expect(kf.inY, isNull);
    });
  });
}
