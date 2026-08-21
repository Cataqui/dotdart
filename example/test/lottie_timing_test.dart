import 'package:dotdart_example/gen/lotties.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('when a generated Lottie has an initial delay, it should wait before autoplay starts', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: $Lotties.pulse(
          width: 96,
          delay: const Duration(milliseconds: 100),
        ),
      ),
    );

    expect(tester.hasRunningAnimations, isFalse);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('when a generated Lottie initial delay expires, it should start autoplay', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: $Lotties.pulse(
          width: 96,
          delay: const Duration(milliseconds: 100),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    expect(tester.hasRunningAnimations, isTrue);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('when a generated Lottie uses the default playback, it should stop after one play', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: $Lotties.pulse(
          width: 96,
          duration: const Duration(milliseconds: 100),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 150));

    expect(tester.hasRunningAnimations, isFalse);
  });

  testWidgets('when a generated Lottie uses loop playback, it should keep playing', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: $Lotties.pulse(
          width: 96,
          duration: const Duration(milliseconds: 100),
          playback: LottiePlayback.loop,
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 150));

    expect(tester.hasRunningAnimations, isTrue);

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
