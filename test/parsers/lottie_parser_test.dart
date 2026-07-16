import 'dart:convert';

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
    test('when a layer entry is not an object, it should report the failing JSON path', () {
      const source = '''
{"v":"5.7.0","fr":30,"w":100,"h":100,"ip":0,"op":30,"layers":[false]}
''';

      expect(
        () => LottieParser.parse(source),
        throwsA(
          isA<DotdartInvalidLottieException>().having((error) => error.message, 'message', contains(r'$.layers[0]')),
        ),
      );
    });
    test('when parsing a minimal valid Lottie JSON, it should return an animation with correct metadata', () {
      final result = LottieParser.parse(_minimalLottie);

      expect(
        (
          result.animation.width,
          result.animation.height,
          result.animation.frameRate,
          result.animation.inPoint,
          result.animation.outPoint,
          result.animation.name,
        ),
        (200, 200, 60, 0, 60, 'Test Animation'),
      );
    });

    test('when parsing a minimal valid Lottie JSON, it should return one layer', () {
      final result = LottieParser.parse(_minimalLottie);

      expect(result.animation.layers.length, 1);
    });

    test('when parsing a minimal valid Lottie JSON, it should parse layer metadata', () {
      final result = LottieParser.parse(_minimalLottie);
      final layer = result.animation.layers.first;

      expect((layer.name, layer.inPoint, layer.outPoint), ('Test Layer', 0, 60));
    });

    test('when parsing a minimal valid Lottie JSON, it should parse layer transform properties', () {
      final result = LottieParser.parse(_minimalLottie);
      final layer = result.animation.layers.first;

      expect(
        (
          layer.opacity?.animated,
          layer.opacity?.staticValue,
          layer.rotation?.animated,
          layer.rotation?.staticValue,
          layer.positionX?.animated,
          layer.positionX?.staticValue,
          layer.positionY?.animated,
          layer.positionY?.staticValue,
          layer.anchorX,
          layer.anchorY,
          layer.scaleX?.animated,
          layer.scaleX?.staticValue,
          layer.scaleY?.animated,
          layer.scaleY?.staticValue,
        ),
        (false, 100, false, 0, false, 100, false, 100, 0, 0, false, 100, false, 100),
      );
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
      expect(
        (rect.positionX, rect.positionY, rect.width, rect.height, rect.cornerRadius, rect.direction),
        (0, 0, 100, 50, 10, 1),
      );
    });

    test('when parsing a minimal valid Lottie JSON, it should parse a fill shape', () {
      final result = LottieParser.parse(_minimalLottie);
      final items = result.animation.layers.first.shapeGroups.first.items;

      final fill = items.whereType<LottieFill>().first;
      expect((fill.colorR, fill.colorG, fill.colorB, fill.colorA, fill.opacity, fill.fillRule), (1, 0, 0, 1, 100, 1));
    });

    test('when parsing a minimal valid Lottie JSON, it should parse a stroke shape', () {
      final result = LottieParser.parse(_minimalLottie);
      final items = result.animation.layers.first.shapeGroups.first.items;

      final stroke = items.whereType<LottieStroke>().first;
      expect(
        (
          stroke.colorR,
          stroke.colorG,
          stroke.colorB,
          stroke.colorA,
          stroke.opacity,
          stroke.width,
          stroke.lineCap,
          stroke.lineJoin,
        ),
        (0, 0, 1, 1, 100, 2, 2, 2),
      );
    });

    test('when parsing a minimal valid Lottie JSON, it should parse a group transform', () {
      final result = LottieParser.parse(_minimalLottie);
      final items = result.animation.layers.first.shapeGroups.first.items;

      final transform = items.whereType<LottieGroupTransform>().first;
      expect(
        (
          transform.positionX,
          transform.positionY,
          transform.anchorX,
          transform.anchorY,
          transform.scaleX,
          transform.scaleY,
          transform.rotation,
          transform.opacity,
        ),
        (0, 0, 0, 0, 100, 100, 0, 100),
      );
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
          <String, dynamic>{
            'ty': 0,
            'nm': 'Null Layer',
            'ip': 0,
            'op': 30,
            'ks': <String, dynamic>{},
            'shapes': <Object?>[],
          },
          {
            'ty': 4,
            'nm': 'Shape Layer',
            'ip': 0,
            'op': 30,
            'ks': {
              'o': {'a': 0, 'k': 100},
              'r': {'a': 0, 'k': 0},
              'p': {
                'a': 0,
                'k': [50, 50],
              },
              'a': {
                'a': 0,
                'k': [0, 0],
              },
              's': {
                'a': 0,
                'k': [100, 100],
              },
            },
            'shapes': <Object?>[],
          },
        ],
      });

      final result = LottieParser.parse(json);

      expect(
        (result.animation.layers.length, result.warnings.length, result.warnings.first.contains('Null Layer')),
        (1, 1, true),
      );
    });

    test('when parsing a Lottie JSON without a positive width, it should throw an actionable invalid Lottie error', () {
      final json = jsonEncode({'v': '5.5.2', 'fr': 30, 'w': 0, 'h': 100, 'ip': 0, 'op': 30, 'layers': <Object?>[]});

      expect(() => LottieParser.parse(json), throwsA(isA<DotdartInvalidLottieException>()));
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

  group('LottieParser animated keyframes', () {
    test('when parsing animated opacity keyframes, it should set animated to true', () {
      final json = jsonEncode({
        'v': '5.5.2',
        'fr': 30,
        'w': 100,
        'h': 100,
        'ip': 0,
        'op': 30,
        'nm': 'Animated',
        'layers': [
          {
            'ty': 4,
            'nm': 'Layer',
            'ip': 0,
            'op': 30,
            'ks': {
              'o': {
                'a': 1,
                'k': [
                  {
                    't': 0,
                    's': [100],
                    'e': [50],
                  },
                  {
                    't': 15,
                    's': [50],
                  },
                ],
              },
              'r': {'a': 0, 'k': 0},
              'p': {
                'a': 0,
                'k': [0, 0],
              },
              'a': {
                'a': 0,
                'k': [0, 0],
              },
              's': {
                'a': 0,
                'k': [100, 100],
              },
            },
            'shapes': <Object?>[],
          },
        ],
      });

      final result = LottieParser.parse(json);
      final opacity = result.animation.layers.first.opacity!;

      expect((opacity.animated, opacity.keyframes.length), (true, 2));
    });

    test('when parsing animated keyframes with hold, it should set hold to true', () {
      final json = jsonEncode({
        'v': '5.5.2',
        'fr': 30,
        'w': 100,
        'h': 100,
        'ip': 0,
        'op': 30,
        'nm': 'Hold',
        'layers': [
          {
            'ty': 4,
            'nm': 'Layer',
            'ip': 0,
            'op': 30,
            'ks': {
              'o': {
                'a': 1,
                'k': [
                  {
                    't': 0,
                    's': [100],
                    'e': [100],
                    'h': 1,
                  },
                ],
              },
              'r': {'a': 0, 'k': 0},
              'p': {
                'a': 0,
                'k': [0, 0],
              },
              'a': {
                'a': 0,
                'k': [0, 0],
              },
              's': {
                'a': 0,
                'k': [100, 100],
              },
            },
            'shapes': <Object?>[],
          },
        ],
      });

      final result = LottieParser.parse(json);
      final kf = result.animation.layers.first.opacity!.keyframes.first;

      expect(kf.hold, isTrue);
    });

    test('when parsing animated keyframes with bezier easing, it should parse the handles', () {
      final json = jsonEncode({
        'v': '5.5.2',
        'fr': 30,
        'w': 100,
        'h': 100,
        'ip': 0,
        'op': 30,
        'nm': 'Eased',
        'layers': [
          {
            'ty': 4,
            'nm': 'Layer',
            'ip': 0,
            'op': 30,
            'ks': {
              'o': {
                'a': 1,
                'k': [
                  {
                    't': 0,
                    's': [100],
                    'e': [50],
                    'o': {
                      'x': [0.42],
                      'y': [0],
                    },
                    'i': {
                      'x': [0.58],
                      'y': [1],
                    },
                  },
                ],
              },
              'r': {'a': 0, 'k': 0},
              'p': {
                'a': 0,
                'k': [0, 0],
              },
              'a': {
                'a': 0,
                'k': [0, 0],
              },
              's': {
                'a': 0,
                'k': [100, 100],
              },
            },
            'shapes': <Object?>[],
          },
        ],
      });

      final result = LottieParser.parse(json);
      final kf = result.animation.layers.first.opacity!.keyframes.first;

      expect((kf.outX, kf.outY, kf.inX, kf.inY), (0.42, 0, 0.58, 1));
    });

    test('when parsing easing split across adjacent keyframes, it should use the next incoming handle', () {
      final json = jsonEncode({
        'v': '5.5.2',
        'fr': 30,
        'w': 100,
        'h': 100,
        'ip': 0,
        'op': 30,
        'nm': 'Split Easing',
        'layers': [
          {
            'ty': 4,
            'nm': 'Layer',
            'ip': 0,
            'op': 30,
            'ks': {
              'o': {
                'a': 1,
                'k': [
                  {
                    't': 0,
                    's': [100],
                    'e': [50],
                    'o': {
                      'x': [0.2],
                      'y': [0.75],
                    },
                  },
                  {
                    't': 15,
                    's': [50],
                    'i': {
                      'x': [0.34],
                      'y': [0.94],
                    },
                  },
                ],
              },
              'r': {'a': 0, 'k': 0},
              'p': {
                'a': 0,
                'k': [0, 0],
              },
              'a': {
                'a': 0,
                'k': [0, 0],
              },
              's': {
                'a': 0,
                'k': [100, 100],
              },
            },
            'shapes': <Object?>[],
          },
        ],
      });

      final result = LottieParser.parse(json);
      final keyframe = result.animation.layers.first.opacity!.keyframes.first;

      expect((keyframe.outX, keyframe.outY, keyframe.inX, keyframe.inY), (0.2, 0.75, 0.34, 0.94));
    });

    test('when parsing animated array-based keyframes for position, it should extract both axes', () {
      final json = jsonEncode({
        'v': '5.5.2',
        'fr': 30,
        'w': 100,
        'h': 100,
        'ip': 0,
        'op': 30,
        'nm': 'Position Anim',
        'layers': [
          {
            'ty': 4,
            'nm': 'Layer',
            'ip': 0,
            'op': 30,
            'ks': {
              'o': {'a': 0, 'k': 100},
              'r': {'a': 0, 'k': 0},
              'p': {
                'a': 1,
                'k': [
                  {
                    't': 0,
                    's': [0, 0],
                    'e': [100, 50],
                  },
                  {
                    't': 30,
                    's': [100, 50],
                  },
                ],
              },
              'a': {
                'a': 0,
                'k': [0, 0],
              },
              's': {
                'a': 0,
                'k': [100, 100],
              },
            },
            'shapes': <Object?>[],
          },
        ],
      });

      final result = LottieParser.parse(json);
      final layer = result.animation.layers.first;

      expect((layer.positionX!.animated, layer.positionY!.animated), (true, true));
    });
  });

  group('LottieParser shapes', () {
    test('when parsing an ellipse shape, it should parse position, size, and direction', () {
      final json = jsonEncode({
        'v': '5.5.2',
        'fr': 30,
        'w': 100,
        'h': 100,
        'ip': 0,
        'op': 30,
        'nm': 'Ellipse Anim',
        'layers': [
          {
            'ty': 4,
            'nm': 'Layer',
            'ip': 0,
            'op': 30,
            'ks': {
              'o': {'a': 0, 'k': 100},
              'r': {'a': 0, 'k': 0},
              'p': {
                'a': 0,
                'k': [50, 50],
              },
              'a': {
                'a': 0,
                'k': [0, 0],
              },
              's': {
                'a': 0,
                'k': [100, 100],
              },
            },
            'shapes': [
              {
                'ty': 'gr',
                'nm': 'Ellipse Group',
                'it': [
                  {
                    'ty': 'el',
                    'nm': 'Circle',
                    'p': {
                      'a': 0,
                      'k': [0, 0],
                    },
                    's': {
                      'a': 0,
                      'k': [80, 80],
                    },
                    'd': 1,
                  },
                  {
                    'ty': 'fl',
                    'c': {
                      'a': 0,
                      'k': [1, 0, 0, 1],
                    },
                    'o': {'a': 0, 'k': 100},
                    'r': 1,
                  },
                  {
                    'ty': 'tr',
                    'p': {
                      'a': 0,
                      'k': [0, 0],
                    },
                    'a': {
                      'a': 0,
                      'k': [0, 0],
                    },
                    's': {
                      'a': 0,
                      'k': [100, 100],
                    },
                    'r': {'a': 0, 'k': 0},
                    'o': {'a': 0, 'k': 100},
                  },
                ],
              },
            ],
          },
        ],
      });

      final result = LottieParser.parse(json);
      final items = result.animation.layers.first.shapeGroups.first.items;
      final ellipse = items.whereType<LottieEllipse>().first;

      expect(
        (ellipse.positionX, ellipse.positionY, ellipse.width, ellipse.height, ellipse.direction),
        (0, 0, 80, 80, 1),
      );
    });

    test('when parsing a path shape, it should parse vertices and tangents', () {
      final json = jsonEncode({
        'v': '5.5.2',
        'fr': 30,
        'w': 100,
        'h': 100,
        'ip': 0,
        'op': 30,
        'nm': 'Path Anim',
        'layers': [
          {
            'ty': 4,
            'nm': 'Layer',
            'ip': 0,
            'op': 30,
            'ks': {
              'o': {'a': 0, 'k': 100},
              'r': {'a': 0, 'k': 0},
              'p': {
                'a': 0,
                'k': [50, 50],
              },
              'a': {
                'a': 0,
                'k': [0, 0],
              },
              's': {
                'a': 0,
                'k': [100, 100],
              },
            },
            'shapes': [
              {
                'ty': 'gr',
                'nm': 'Path Group',
                'it': [
                  {
                    'ty': 'sh',
                    'nm': 'Triangle',
                    'ks': {
                      'a': 0,
                      'k': {
                        'v': [
                          [0, -10],
                          [10, 10],
                          [-10, 10],
                        ],
                        'i': [
                          [0, 0],
                          [0, 0],
                          [0, 0],
                        ],
                        'o': [
                          [0, 0],
                          [0, 0],
                          [0, 0],
                        ],
                        'c': true,
                      },
                    },
                  },
                  {
                    'ty': 'fl',
                    'c': {
                      'a': 0,
                      'k': [1, 0, 0, 1],
                    },
                    'o': {'a': 0, 'k': 100},
                    'r': 1,
                  },
                  {
                    'ty': 'tr',
                    'p': {
                      'a': 0,
                      'k': [0, 0],
                    },
                    'a': {
                      'a': 0,
                      'k': [0, 0],
                    },
                    's': {
                      'a': 0,
                      'k': [100, 100],
                    },
                    'r': {'a': 0, 'k': 0},
                    'o': {'a': 0, 'k': 100},
                  },
                ],
              },
            ],
          },
        ],
      });

      final result = LottieParser.parse(json);
      final items = result.animation.layers.first.shapeGroups.first.items;
      final path = items.whereType<LottiePath>().first;

      expect((path.vertices.length, path.inTangents.length, path.outTangents.length, path.closed), (3, 3, 3, true));
    });

    test('when parsing a fill with even-odd fill rule, it should set fillRule to 2', () {
      final json = jsonEncode({
        'v': '5.5.2',
        'fr': 30,
        'w': 100,
        'h': 100,
        'ip': 0,
        'op': 30,
        'nm': 'EvenOdd',
        'layers': [
          {
            'ty': 4,
            'nm': 'Layer',
            'ip': 0,
            'op': 30,
            'ks': {
              'o': {'a': 0, 'k': 100},
              'r': {'a': 0, 'k': 0},
              'p': {
                'a': 0,
                'k': [0, 0],
              },
              'a': {
                'a': 0,
                'k': [0, 0],
              },
              's': {
                'a': 0,
                'k': [100, 100],
              },
            },
            'shapes': [
              {
                'ty': 'gr',
                'nm': 'Group',
                'it': [
                  {
                    'ty': 'rc',
                    'p': {
                      'a': 0,
                      'k': [0, 0],
                    },
                    's': {
                      'a': 0,
                      'k': [50, 50],
                    },
                    'r': {'a': 0, 'k': 0},
                    'd': 1,
                  },
                  {
                    'ty': 'fl',
                    'c': {
                      'a': 0,
                      'k': [0, 1, 0, 1],
                    },
                    'o': {'a': 0, 'k': 100},
                    'r': 2,
                  },
                  {
                    'ty': 'tr',
                    'p': {
                      'a': 0,
                      'k': [0, 0],
                    },
                    'a': {
                      'a': 0,
                      'k': [0, 0],
                    },
                    's': {
                      'a': 0,
                      'k': [100, 100],
                    },
                    'r': {'a': 0, 'k': 0},
                    'o': {'a': 0, 'k': 100},
                  },
                ],
              },
            ],
          },
        ],
      });

      final result = LottieParser.parse(json);
      final items = result.animation.layers.first.shapeGroups.first.items;
      final fill = items.whereType<LottieFill>().first;

      expect(fill.fillRule, 2);
    });

    test('when parsing a stroke with butt cap and bevel join, it should set the correct line cap and join', () {
      final json = jsonEncode({
        'v': '5.5.2',
        'fr': 30,
        'w': 100,
        'h': 100,
        'ip': 0,
        'op': 30,
        'nm': 'Line Styles',
        'layers': [
          {
            'ty': 4,
            'nm': 'Layer',
            'ip': 0,
            'op': 30,
            'ks': {
              'o': {'a': 0, 'k': 100},
              'r': {'a': 0, 'k': 0},
              'p': {
                'a': 0,
                'k': [0, 0],
              },
              'a': {
                'a': 0,
                'k': [0, 0],
              },
              's': {
                'a': 0,
                'k': [100, 100],
              },
            },
            'shapes': [
              {
                'ty': 'gr',
                'nm': 'Group',
                'it': [
                  {
                    'ty': 'rc',
                    'p': {
                      'a': 0,
                      'k': [0, 0],
                    },
                    's': {
                      'a': 0,
                      'k': [50, 50],
                    },
                    'r': {'a': 0, 'k': 0},
                    'd': 1,
                  },
                  {
                    'ty': 'st',
                    'c': {
                      'a': 0,
                      'k': [0, 0, 0, 1],
                    },
                    'o': {'a': 0, 'k': 100},
                    'w': {'a': 0, 'k': 3},
                    'lc': 1,
                    'lj': 3,
                  },
                  {
                    'ty': 'tr',
                    'p': {
                      'a': 0,
                      'k': [0, 0],
                    },
                    'a': {
                      'a': 0,
                      'k': [0, 0],
                    },
                    's': {
                      'a': 0,
                      'k': [100, 100],
                    },
                    'r': {'a': 0, 'k': 0},
                    'o': {'a': 0, 'k': 100},
                  },
                ],
              },
            ],
          },
        ],
      });

      final result = LottieParser.parse(json);
      final items = result.animation.layers.first.shapeGroups.first.items;
      final stroke = items.whereType<LottieStroke>().first;

      expect((stroke.lineCap, stroke.lineJoin), (1, 3));
    });
  });

  group('LottieParser error cases', () {
    test('when the root JSON is not a Map, it should throw an invalid Lottie error', () {
      expect(() => LottieParser.parse(jsonEncode([])), throwsA(isA<DotdartInvalidLottieException>()));
    });

    test('when inPoint and outPoint are equal, it should throw an invalid Lottie error', () {
      final json = jsonEncode({
        'v': '5.5.2',
        'fr': 30,
        'w': 100,
        'h': 100,
        'ip': 10,
        'op': 10,
        'nm': 'Bad Range',
        'layers': <Object?>[],
      });

      expect(() => LottieParser.parse(json), throwsA(isA<DotdartInvalidLottieException>()));
    });

    test('when inPoint is greater than outPoint, it should throw an invalid Lottie error', () {
      final json = jsonEncode({
        'v': '5.5.2',
        'fr': 30,
        'w': 100,
        'h': 100,
        'ip': 20,
        'op': 10,
        'nm': 'Bad Range',
        'layers': <Object?>[],
      });

      expect(() => LottieParser.parse(json), throwsA(isA<DotdartInvalidLottieException>()));
    });

    test('when a shape has an unsupported ty, it should skip it with a warning', () {
      final json = jsonEncode({
        'v': '5.5.2',
        'fr': 30,
        'w': 100,
        'h': 100,
        'ip': 0,
        'op': 30,
        'nm': 'Unsupported',
        'layers': [
          {
            'ty': 4,
            'nm': 'Layer',
            'ip': 0,
            'op': 30,
            'ks': {
              'o': {'a': 0, 'k': 100},
              'r': {'a': 0, 'k': 0},
              'p': {
                'a': 0,
                'k': [0, 0],
              },
              'a': {
                'a': 0,
                'k': [0, 0],
              },
              's': {
                'a': 0,
                'k': [100, 100],
              },
            },
            'shapes': [
              {
                'ty': 'gr',
                'nm': 'Group',
                'it': [
                  {'ty': '??', 'nm': 'Unknown'},
                  {
                    'ty': 'tr',
                    'p': {
                      'a': 0,
                      'k': [0, 0],
                    },
                    'a': {
                      'a': 0,
                      'k': [0, 0],
                    },
                    's': {
                      'a': 0,
                      'k': [100, 100],
                    },
                    'r': {'a': 0, 'k': 0},
                    'o': {'a': 0, 'k': 100},
                  },
                ],
              },
            ],
          },
        ],
      });

      final result = LottieParser.parse(json);

      expect(result.warnings.length, 1);
    });

    test('when parse is called with missing frame rate, it should throw an invalid Lottie error', () {
      final json = jsonEncode(<String, dynamic>{
        'v': '5.5.2',
        'w': 100,
        'h': 100,
        'ip': 0,
        'op': 30,
        'layers': <Object?>[],
      });

      expect(() => LottieParser.parse(json), throwsA(isA<DotdartInvalidLottieException>()));
    });

    test('when parse is called with missing height, it should throw an invalid Lottie error', () {
      final json = jsonEncode(<String, dynamic>{
        'v': '5.5.2',
        'fr': 30,
        'w': 100,
        'ip': 0,
        'op': 30,
        'layers': <Object?>[],
      });

      expect(() => LottieParser.parse(json), throwsA(isA<DotdartInvalidLottieException>()));
    });
  });

  group('DotdartInvalidLottieException', () {
    test('when toString is called, it should include the message', () {
      const ex = DotdartInvalidLottieException('something went wrong');

      expect(ex.toString(), contains('something went wrong'));
    });

    test('when the offset and source getters are accessed, they should return null', () {
      const ex = DotdartInvalidLottieException('error');

      expect(ex.offset, isNull);
      expect(ex.source, isNull);
    });
  });

  group('DotdartUnsupportedFeatureException', () {
    test('when toString is called, it should include the message', () {
      const ex = DotdartUnsupportedFeatureException('gradient not supported');

      expect(ex.toString(), contains('gradient not supported'));
    });
  });
}
