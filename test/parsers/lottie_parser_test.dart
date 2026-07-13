import 'dart:convert';

import 'package:dotdart/src/models/lottie_animation.dart';
import 'package:dotdart/src/models/lottie_layer.dart';
import 'package:dotdart/src/models/lottie_shape.dart';
import 'package:dotdart/src/parsers/lottie_parser.dart';
import 'package:flutter_test/flutter_test.dart';

const _minimalLottie = '''
{
  "v": "5.5.2",
  "fr": 60,
  "ip": 0,
  "op": 60,
  "w": 200,
  "h": 200,
  "nm": "Test Animation",
  "layers": [
    {
      "ty": 4,
      "nm": "Test Layer",
      "ip": 0,
      "op": 60,
      "ks": {
        "o": { "a": 0, "k": 100 },
        "r": { "a": 0, "k": 0 },
        "p": { "a": 0, "k": [100, 100] },
        "a": { "a": 0, "k": [0, 0] },
        "s": { "a": 0, "k": [100, 100] }
      },
      "shapes": [
        {
          "ty": "gr",
          "nm": "Rectangle Group",
          "it": [
            {
              "ty": "rc",
              "nm": "Rectangle",
              "p": { "a": 0, "k": [0, 0] },
              "s": { "a": 0, "k": [100, 50] },
              "r": { "a": 0, "k": 10 },
              "d": 1
            },
            {
              "ty": "fl",
              "nm": "Fill",
              "c": { "a": 0, "k": [1, 0, 0, 1] },
              "o": { "a": 0, "k": 100 },
              "r": 1
            },
            {
              "ty": "st",
              "nm": "Stroke",
              "c": { "a": 0, "k": [0, 0, 1, 1] },
              "o": { "a": 0, "k": 100 },
              "w": { "a": 0, "k": 2 },
              "lc": 2,
              "lj": 2
            },
            {
              "ty": "tr",
              "nm": "Transform",
              "p": { "a": 0, "k": [0, 0] },
              "a": { "a": 0, "k": [0, 0] },
              "s": { "a": 0, "k": [100, 100] },
              "r": { "a": 0, "k": 0 },
              "o": { "a": 0, "k": 100 }
            }
          ]
        }
      ]
    }
  ]
}
''';

void main() {
  group('LottieParser', () {
    test('when parsing a minimal valid Lottie JSON, it should return an animation with correct metadata', () {
      final result = LottieParser.parse(_minimalLottie);

      expect(result.animation.width, 200);
      expect(result.animation.height, 200);
      expect(result.animation.frameRate, 60);
      expect(result.animation.inPoint, 0);
      expect(result.animation.outPoint, 60);
      expect(result.animation.name, 'Test Animation');
    });

    test('when parsing a minimal valid Lottie JSON, it should return one layer', () {
      final result = LottieParser.parse(_minimalLottie);

      expect(result.animation.layers.length, 1);
    });

    test('when parsing a minimal valid Lottie JSON, it should parse layer metadata', () {
      final result = LottieParser.parse(_minimalLottie);
      final layer = result.animation.layers.first;

      expect(layer.name, 'Test Layer');
      expect(layer.inPoint, 0);
      expect(layer.outPoint, 60);
    });

    test('when parsing a minimal valid Lottie JSON, it should parse layer transform properties', () {
      final result = LottieParser.parse(_minimalLottie);
      final layer = result.animation.layers.first;

      expect(layer.opacity?.animated, false);
      expect(layer.opacity?.staticValue, 100);
      expect(layer.rotation?.animated, false);
      expect(layer.rotation?.staticValue, 0);
      expect(layer.positionX?.animated, false);
      expect(layer.positionX?.staticValue, 100);
      expect(layer.positionY?.animated, false);
      expect(layer.positionY?.staticValue, 100);
      expect(layer.anchorX, 0);
      expect(layer.anchorY, 0);
      expect(layer.scaleX?.animated, false);
      expect(layer.scaleX?.staticValue, 100);
      expect(layer.scaleY?.animated, false);
      expect(layer.scaleY?.staticValue, 100);
    });

    test('when parsing a minimal valid Lottie JSON, it should parse one shape group', () {
      final result = LottieParser.parse(_minimalLottie);
      final layer = result.animation.layers.first;

      expect(layer.shapeGroups.length, 1);
    });

    test('when parsing a minimal valid Lottie JSON, it should parse the shape group name', () {
      final result = LottieParser.parse(_minimalLottie);
      final group = result.animation.layers.first.shapeGroups.first;

      expect(group.name, 'Rectangle Group');
    });

    test('when parsing a minimal valid Lottie JSON, it should parse a rect shape', () {
      final result = LottieParser.parse(_minimalLottie);
      final items = result.animation.layers.first.shapeGroups.first.items;

      final rect = items.whereType<LottieRect>().first;
      expect(rect.positionX, 0);
      expect(rect.positionY, 0);
      expect(rect.width, 100);
      expect(rect.height, 50);
      expect(rect.cornerRadius, 10);
      expect(rect.direction, 1);
    });

    test('when parsing a minimal valid Lottie JSON, it should parse a fill shape', () {
      final result = LottieParser.parse(_minimalLottie);
      final items = result.animation.layers.first.shapeGroups.first.items;

      final fill = items.whereType<LottieFill>().first;
      expect(fill.colorR, 1);
      expect(fill.colorG, 0);
      expect(fill.colorB, 0);
      expect(fill.colorA, 1);
      expect(fill.opacity, 100);
      expect(fill.fillRule, 1);
    });

    test('when parsing a minimal valid Lottie JSON, it should parse a stroke shape', () {
      final result = LottieParser.parse(_minimalLottie);
      final items = result.animation.layers.first.shapeGroups.first.items;

      final stroke = items.whereType<LottieStroke>().first;
      expect(stroke.colorR, 0);
      expect(stroke.colorG, 0);
      expect(stroke.colorB, 1);
      expect(stroke.colorA, 1);
      expect(stroke.opacity, 100);
      expect(stroke.width, 2);
      expect(stroke.lineCap, 2);
      expect(stroke.lineJoin, 2);
    });

    test('when parsing a minimal valid Lottie JSON, it should parse a group transform', () {
      final result = LottieParser.parse(_minimalLottie);
      final items = result.animation.layers.first.shapeGroups.first.items;

      final transform = items.whereType<LottieGroupTransform>().first;
      expect(transform.positionX, 0);
      expect(transform.positionY, 0);
      expect(transform.anchorX, 0);
      expect(transform.anchorY, 0);
      expect(transform.scaleX, 100);
      expect(transform.scaleY, 100);
      expect(transform.rotation, 0);
      expect(transform.opacity, 100);
    });

    test('when parsing a minimal valid Lottie JSON, it should have no warnings', () {
      final result = LottieParser.parse(_minimalLottie);

      expect(result.warnings, isEmpty);
    });

    test('when parsing a Lottie JSON with a non-shape layer, it should skip it with a warning', () {
      final json = jsonEncode({
        'v': '5.5.2',
        'fr': 30,
        'w': 100,
        'h': 100,
        'ip': 0,
        'op': 30,
        'nm': 'With Null Layer',
        'layers': [
          {'ty': 0, 'nm': 'Null Layer', 'ip': 0, 'op': 30, 'ks': {}, 'shapes': []},
          {
            'ty': 4,
            'nm': 'Shape Layer',
            'ip': 0,
            'op': 30,
            'ks': {
              'o': {'a': 0, 'k': 100},
              'r': {'a': 0, 'k': 0},
              'p': {'a': 0, 'k': [50, 50]},
              'a': {'a': 0, 'k': [0, 0]},
              's': {'a': 0, 'k': [100, 100]},
            },
            'shapes': [],
          },
        ],
      });

      final result = LottieParser.parse(json);

      expect(result.animation.layers.length, 1);
      expect(result.warnings.length, 1);
      expect(result.warnings.first, contains('Null Layer'));
    });

    test('when computing duration, it should return correct milliseconds', () {
      final result = LottieParser.parse(_minimalLottie);

      expect(result.animation.durationMs, 1000);
    });

    test('when computing total frames, it should return correct frame count', () {
      final result = LottieParser.parse(_minimalLottie);

      expect(result.animation.totalFrames, 60);
    });
  });
}
