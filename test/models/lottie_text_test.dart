import 'package:dotdart/src/models/lottie_text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LottieText', () {
    test('when creating text, it should retain editable content and layout styling', () {
      const text = LottieText(
        value: 'Job title',
        fontFamily: 'Inter',
        fontWeight: 600,
        italic: false,
        fontSize: 16,
        lineHeight: 20,
        tracking: -20,
        justification: 0,
        colorR: 0,
        colorG: 0,
        colorB: 0,
        colorA: 1,
        boxWidth: 230,
        boxHeight: 60,
      );

      expect(
        (text.value, text.fontFamily, text.fontWeight, text.fontSize, text.boxWidth, text.boxHeight),
        ('Job title', 'Inter', 600, 16, 230, 60),
      );
    });
  });
}
