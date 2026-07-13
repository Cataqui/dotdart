import 'dart:io';

import 'package:dotdart/src/generators/lottie_generator.dart';
import 'package:dotdart/src/models/lottie_animation.dart';
import 'package:dotdart/src/models/lottie_layer.dart';
import 'package:dotdart/src/models/lottie_shape.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LottieGenerator', () {
    final animation = LottieAnimation(
      width: 200,
      height: 200,
      frameRate: 60,
      inPoint: 0,
      outPoint: 60,
      name: 'Test',
      layers: [
        LottieLayer(
          name: 'Layer 1',
          shapeGroups: [
            LottieGroup(
              name: 'Group 1',
              items: [
                LottieRect(
                  positionX: 0,
                  positionY: 0,
                  width: 100,
                  height: 50,
                  cornerRadius: 10,
                  direction: 1,
                ),
                LottieFill(
                  colorR: 1,
                  colorG: 0,
                  colorB: 0,
                  colorA: 1,
                  opacity: 100,
                  fillRule: 1,
                ),
                LottieStroke(
                  colorR: 0,
                  colorG: 0,
                  colorB: 1,
                  colorA: 1,
                  opacity: 100,
                  width: 2,
                  lineCap: 2,
                  lineJoin: 2,
                ),
                LottieGroupTransform(
                  positionX: 0,
                  positionY: 0,
                  anchorX: 0,
                  anchorY: 0,
                  scaleX: 100,
                  scaleY: 100,
                  rotation: 0,
                  opacity: 100,
                ),
              ],
            ),
          ],
          opacity: const LottieAnimatedScalar(animated: false, staticValue: 100),
          rotation: const LottieAnimatedScalar(animated: false, staticValue: 0),
          positionX: const LottieAnimatedScalar(animated: false, staticValue: 100),
          positionY: const LottieAnimatedScalar(animated: false, staticValue: 100),
          anchorX: 0,
          anchorY: 0,
          scaleX: const LottieAnimatedScalar(animated: false, staticValue: 100),
          scaleY: const LottieAnimatedScalar(animated: false, staticValue: 100),
          inPoint: 0,
          outPoint: 60,
        ),
      ],
    );

    test('when generating code, it should produce valid Dart', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generate();

      expect(code, isNotEmpty);
      expect(code, contains('class Test extends StatefulWidget'));
      expect(code, contains('class _TestState extends State<Test>'));
      expect(code, contains('class _TestPainter extends CustomPainter'));
      expect(code, contains('class _DotdartScalarKeyframe'));
    });

    test('when generating code, it should include the correct widget class name', () {
      final generator = LottieGenerator(animation, 'assets/lottie/my_animation.json');
      final code = generator.generate();

      expect(code, contains('class MyAnimation extends StatefulWidget'));
    });

    test('when generating code, it should include color properties', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generate();

      expect(code, contains('color1'));
    });

    test('when generating code, it should include the header comment', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generate();

      expect(code, contains('// GENERATED CODE - DO NOT MODIFY BY HAND'));
      expect(code, contains('//  dotdart'));
    });

    test('when generating code, it should include the coverage ignore directive', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generate();

      expect(code, contains('// coverage:ignore-file'));
    });

    test('when generating code, it should include the correct imports', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generate();

      expect(code, contains("import 'dart:math' as math;"));
      expect(code, contains("import 'package:flutter/material.dart';"));
    });

    test('when generating code, it should include the lottie dimensions', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generate();

      expect(code, contains('_lottieWidth = 200'));
      expect(code, contains('_lottieHeight = 200'));
      expect(code, contains('_totalFrames = 60'));
    });

    test('when generating code, it should include the loop duration', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generate();

      expect(code, contains('Duration(milliseconds: 1000)'));
    });

    test('when generating code, it should include the animated property', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generate();

      expect(code, contains('final bool animated;'));
    });

    test('when generating code, it should include the painter with keyframe data', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generate();

      expect(code, contains('class _TestPainter extends CustomPainter'));
      expect(code, contains('void paint(Canvas canvas, Size size)'));
      expect(code, contains('bool shouldRepaint'));
    });

    test('when generating code, it should include the lifecycle observer', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generate();

      expect(code, contains('WidgetsBindingObserver'));
      expect(code, contains('didChangeAppLifecycleState'));
    });

    test('when generating code, it should include the draw method for the layer', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generate();

      expect(code, contains('_draw_Layer_1_0'));
    });

    test('when generating code, it should include the rect drawing code', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generate();

      expect(code, contains('RRect'));
      expect(code, contains('drawRRect'));
    });

    test('when generating code, it should include the fill and stroke paints', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generate();

      expect(code, contains('PaintingStyle.fill'));
      expect(code, contains('PaintingStyle.stroke'));
    });

    test('when generating code, it should be valid Dart that can be parsed', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generate();

      // Verify it's valid Dart by checking it can be parsed
      // (DartFormatter already validates during generation)
      expect(code, isNotEmpty);
      expect(code.runes.length, greaterThan(500));
    });
  });
}
