import 'package:dotdart/src/generators/shared_emit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SharedEmitter', () {
    test(
      'when emitting Lottie lifecycle code, it should delay once and apply the playback duration',
      () {
        final code = SharedEmitter.lottieAnimationStateMixin();

        expect(
          code,
          allOf([
            contains('Timer? _delayTimer;'),
            contains('bool _hasCompletedInitialDelay = false;'),
            contains("ArgumentError.value(lottieDelay, 'delay', 'must not be negative')"),
            contains("ArgumentError.value(lottieDuration, 'duration', 'must be greater than zero')"),
            contains(
              'final duration = lottieDuration ?? lottieNativeDuration;',
            ),
            contains('_controller.duration = duration;'),
            contains('_delayTimer = Timer(lottieDelay, () {'),
            contains('_hasCompletedInitialDelay = true;'),
            contains('_delayTimer?.cancel();'),
          ]),
        );
      },
    );

    test(
      'when emitting Lottie playback code, it should handle once and loop modes exhaustively',
      () {
        final code = SharedEmitter.lottieAnimationStateMixin();

        expect(
          code,
          allOf(
            contains('switch (lottiePlayback) {'),
            contains('case LottiePlayback.once:'),
            contains('unawaited(_controller.forward());'),
            contains('case LottiePlayback.loop:'),
            contains('unawaited(_controller.repeat());'),
          ),
        );
      },
    );

    test('when emitting thumbhash painting code, it should reuse compiled pixels and one paint', () {
      final code = SharedEmitter.thumbhashCode();

      expect(
        code,
        allOf(
          contains('final Paint _paint = Paint();'),
          contains('final List<Color> pixels;'),
          contains('_paint..color = color'),
          isNot(contains('_DotdartThumbhashDecoder')),
          isNot(contains('Paint()..color = dominantColor')),
        ),
      );
    });
  });
}
