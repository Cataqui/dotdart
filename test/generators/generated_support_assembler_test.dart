import 'package:dotdart/src/generators/generated_support_assembler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GeneratedSupportAssembler', () {
    test(
      'when assembling shared Lottie support, it should emit the documented playback enum',
      () {
        final code = GeneratedSupportAssembler().assemble();

        expect(
          code,
          allOf(
            contains('enum LottiePlayback {'),
            contains('once,'),
            contains('loop,'),
            contains('Plays the animation once and keeps the final frame visible.'),
            contains('Repeats the animation continuously.'),
          ),
        );
      },
    );

    test(
      'when assembling shared Lottie support, it should include the dotdart ownership header',
      () {
        final code = GeneratedSupportAssembler().assemble();

        expect(
          code,
          startsWith('// GENERATED CODE - DO NOT MODIFY BY HAND\n'),
        );
      },
    );
  });
}
