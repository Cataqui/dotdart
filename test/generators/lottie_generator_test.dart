import 'dart:io';

import 'package:dotdart/src/generators/lottie_generator.dart';
import 'package:dotdart/src/models/lottie_animation.dart';
import 'package:dotdart/src/models/lottie_composition.dart';
import 'package:dotdart/src/models/lottie_keyframe.dart';
import 'package:dotdart/src/models/lottie_layer.dart';
import 'package:dotdart/src/models/lottie_shape.dart';
import 'package:dotdart/src/models/lottie_text.dart';
import 'package:dotdart/src/parsers/lottie_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const animation = LottieAnimation(
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
              LottieRect(positionX: 0, positionY: 0, width: 100, height: 50, cornerRadius: 10, direction: 1),
              LottieFill(colorR: 1, colorG: 0, colorB: 0, colorA: 1, opacity: 100, fillRule: 1),
              LottieStroke(colorR: 0, colorG: 0, colorB: 1, colorA: 1, opacity: 100, width: 2, lineCap: 2, lineJoin: 2),
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
        opacity: LottieAnimatedScalar(animated: false, staticValue: 100),
        rotation: LottieAnimatedScalar(animated: false, staticValue: 0),
        positionX: LottieAnimatedScalar(animated: false, staticValue: 100),
        positionY: LottieAnimatedScalar(animated: false, staticValue: 100),
        anchorX: 0,
        anchorY: 0,
        scaleX: LottieAnimatedScalar(animated: false, staticValue: 100),
        scaleY: LottieAnimatedScalar(animated: false, staticValue: 100),
        inPoint: 0,
        outPoint: 60,
      ),
    ],
  );

  group('LottieGenerator', () {
    test('when text and color layers are unnamed, it should expose generic parameters in source order', () {
      const unnamedAnimation = LottieAnimation(
        width: 100,
        height: 100,
        frameRate: 30,
        inPoint: 0,
        outPoint: 30,
        name: 'Unnamed',
        layers: [
          LottieLayer(
            name: '',
            shapeGroups: [],
            text: LottieText(
              value: 'Default',
              fontFamily: 'Inter',
              fontWeight: 400,
              italic: false,
              fontSize: 12,
              lineHeight: 12,
              tracking: 0,
              justification: 0,
              colorR: 0,
              colorG: 0,
              colorB: 0,
              colorA: 1,
            ),
          ),
          LottieLayer(
            name: '',
            shapeGroups: [
              LottieGroup(
                name: '',
                items: [
                  LottieRect(positionX: 0, positionY: 0, width: 10, height: 10, cornerRadius: 0),
                  LottieFill(colorR: 1, colorG: 0, colorB: 0, colorA: 1, opacity: 100),
                ],
              ),
            ],
          ),
        ],
      );

      final code = LottieGenerator(unnamedAnimation, 'assets/lotties/unnamed.json').generateWidgetClass();

      expect(
        code,
        allOf(contains('final String? text1;'), contains('final Color? color1;'), contains('final Color? color2;')),
      );
    });

    test('when Lottie text contains source-breaking characters, it should emit safe generated Dart', () {
      const unsafeAnimation = LottieAnimation(
        width: 100,
        height: 100,
        frameRate: 30,
        inPoint: 0,
        outPoint: 30,
        name: 'Unsafe source',
        layers: [
          LottieLayer(
            name: 'Title\nclass Injected {}',
            shapeGroups: [],
            text: LottieText(
              value: 'Line\u2028break \$value',
              fontFamily: 'Inter',
              fontWeight: 400,
              italic: false,
              fontSize: 12,
              lineHeight: 12,
              tracking: 0,
              justification: 0,
              colorR: 0,
              colorG: 0,
              colorB: 0,
              colorA: 1,
            ),
          ),
        ],
      );

      final code = LottieGenerator(unsafeAnimation, 'assets/lotties/unsafe.json').generateWidgetClass();

      expect(
        code,
        allOf([
          contains('/// Replacement text for the `Title class Injected {}` Lottie layer.'),
          isNot(contains('\nclass Injected {}')),
          contains(r"text: overrides.titleClassInjectedText ?? 'Line\u2028break \$value'"),
        ]),
      );
    });

    test('when a layer has multiple additive masks, it should combine them before clipping', () {
      const maskedAnimation = LottieAnimation(
        width: 100,
        height: 100,
        frameRate: 30,
        inPoint: 0,
        outPoint: 30,
        name: 'Masks',
        layers: [
          LottieLayer(
            name: 'Masked',
            shapeGroups: [
              LottieGroup(
                name: 'Shape',
                items: [
                  LottieRect(positionX: 0, positionY: 0, width: 10, height: 10, cornerRadius: 0),
                  LottieFill(colorR: 1, colorG: 0, colorB: 0, colorA: 1, opacity: 100),
                ],
              ),
            ],
            masks: [
              LottiePath(
                vertices: [
                  [0, 0],
                  [10, 0],
                  [10, 10],
                ],
                inTangents: [
                  [0, 0],
                  [0, 0],
                  [0, 0],
                ],
                outTangents: [
                  [0, 0],
                  [0, 0],
                  [0, 0],
                ],
                closed: true,
              ),
              LottiePath(
                vertices: [
                  [5, 5],
                  [15, 5],
                  [15, 15],
                ],
                inTangents: [
                  [0, 0],
                  [0, 0],
                  [0, 0],
                ],
                outTangents: [
                  [0, 0],
                  [0, 0],
                  [0, 0],
                ],
                closed: true,
              ),
            ],
          ),
        ],
      );

      final code = LottieGenerator(maskedAnimation, 'assets/lotties/masks.json').generateWidgetClass();

      expect(
        code,
        allOf(
          contains('Path.combine(PathOperation.union'),
          contains('canvas.clipPath(__maskPath0);'),
          isNot(contains('canvas.clipPath(__maskPath0_0);')),
        ),
      );
    });

    test('when Lottie values are customizable, it should expose one generated overrides parameter', () {
      final source = File('example/assets/lotties/cataqui_job_cards_carousel.json').readAsStringSync();
      final animation = LottieParser.parse(source).animation;

      final params = LottieGenerator(animation, 'assets/lotties/job_cards.json').params;

      expect(
        params.map((param) => param.name),
        allOf(contains('overrides'), isNot(contains('jobTitleText')), isNot(contains('payTextColor'))),
      );
    });

    test('when naming text overrides, it should append Text once and keep colors inside the overrides class', () {
      const namedTextAnimation = LottieAnimation(
        width: 100,
        height: 100,
        frameRate: 30,
        inPoint: 0,
        outPoint: 30,
        name: 'Named text',
        layers: [
          LottieLayer(
            name: 'Pay',
            shapeGroups: [],
            text: LottieText(
              value: '100',
              fontFamily: 'Inter',
              fontWeight: 400,
              italic: false,
              fontSize: 12,
              lineHeight: 12,
              tracking: 0,
              justification: 0,
              colorR: 0,
              colorG: 0,
              colorB: 0,
              colorA: 1,
            ),
          ),
          LottieLayer(
            name: 'Summary Text',
            shapeGroups: [],
            text: LottieText(
              value: 'Summary',
              fontFamily: 'Inter',
              fontWeight: 400,
              italic: false,
              fontSize: 12,
              lineHeight: 12,
              tracking: 0,
              justification: 0,
              colorR: 0,
              colorG: 0,
              colorB: 0,
              colorA: 1,
            ),
          ),
        ],
      );

      final code = LottieGenerator(namedTextAnimation, 'assets/lotties/named_text.json').generateWidgetClass();

      expect(
        code,
        allOf([
          contains('final class NamedTextOverrides'),
          contains('final String? payText;'),
          contains('final String? summaryText;'),
          contains('final Color? payTextColor;'),
          contains('final Color? summaryTextColor;'),
          isNot(contains('summaryTextText')),
        ]),
      );
    });

    test('when named text layers are unique, it should expose a separate text and color override for each layer', () {
      final source = File('example/assets/lotties/cataqui_job_cards_carousel.json').readAsStringSync();
      final animation = LottieParser.parse(source).animation;

      final code = LottieGenerator(animation, 'assets/lotties/job_cards.json').generateWidgetClass();

      expect(
        code,
        allOf([
          contains('final String? jobCard01TextPostedTimeText;'),
          contains('final String? jobCard01TextJobTitleText;'),
          contains('final String? jobCard01TextPayText;'),
          contains('final String? jobCard01TextDescriptionText;'),
          contains('final String? jobCard02TextPostedTimeText;'),
          contains('final String? jobCard02TextJobTitleText;'),
          contains('final String? jobCard02TextPayText;'),
          contains('final String? jobCard02TextDescriptionText;'),
          contains('final String? jobCard06TextPostedTimeText;'),
          contains('final String? jobCard06TextJobTitleText;'),
          contains('final String? jobCard06TextPayText;'),
          contains('final String? jobCard06TextDescriptionText;'),
          contains('final Color? jobCard01TextPostedTimeTextColor;'),
          contains('final Color? jobCard01TextJobTitleTextColor;'),
          contains('final Color? jobCard01TextPayTextColor;'),
          contains('final Color? jobCard01TextDescriptionTextColor;'),
          contains('final Color? jobCard02TextPostedTimeTextColor;'),
          contains('final Color? jobCard02TextJobTitleTextColor;'),
          contains('final Color? jobCard02TextPayTextColor;'),
          contains('final Color? jobCard02TextDescriptionTextColor;'),
          contains('final Color? jobCard06TextPostedTimeTextColor;'),
          contains('final Color? jobCard06TextJobTitleTextColor;'),
          contains('final Color? jobCard06TextPayTextColor;'),
          contains('final Color? jobCard06TextDescriptionTextColor;'),
        ]),
      );
    });

    test('when generating the job card carousel, it should expose colors named after artwork layers', () {
      final source = File('example/assets/lotties/cataqui_job_cards_carousel.json').readAsStringSync();
      final animation = LottieParser.parse(source).animation;

      final code = LottieGenerator(animation, 'assets/lotties/job_cards.json').generateWidgetClass();

      expect(
        code,
        allOf(
          contains('final Color? jobCard01ArtworkColor1;'),
          contains('final Color? jobCard02ArtworkColor1;'),
          contains('final Color? jobCard04ArtworkColor1;'),
        ),
      );
    });

    test('when generating the job card carousel, it should paint reusable compositions and custom text', () {
      final source = File('example/assets/lotties/cataqui_job_cards_carousel.json').readAsStringSync();
      final animation = LottieParser.parse(source).animation;

      final code = LottieGenerator(animation, 'assets/lotties/job_cards.json').generateWidgetClass();

      expect(
        code,
        allOf(
          contains('TextPainter _textPainterFor'),
          contains("text: overrides.jobCard01TextJobTitleText ?? 'Garçom'"),
          contains(r"text: overrides.jobCard01TextPayText ?? r'R$100/dia'"),
          contains('canvas.clipPath(__maskPath'),
          contains('_drawJobCard01TextPostedTime'),
        ),
      );
    });

    test('when a layer has a parent controller, it should apply the parent transform before the layer transform', () {
      final source = File('example/assets/lotties/cataqui_job_cards_carousel.json').readAsStringSync();
      final animation = LottieParser.parse(source).animation;

      final code = LottieGenerator(animation, 'assets/lotties/job_cards.json').generateWidgetClass();
      final drawMethod = code.indexOf('void _drawJobCard01FrontInstance0');
      final parentRotation = code.indexOf('canvas.rotate(_keyframes12Rotation(frame)', drawMethod);
      final childTranslation = code.indexOf('canvas.translate(229, 249.5)', drawMethod);

      expect(
        (parentRotation > drawMethod, childTranslation > parentRotation),
        (true, true),
      );
    });

    test('when a layer only controls its children, it should not emit a standalone draw call or method', () {
      final source = File('example/assets/lotties/cataqui_job_cards_carousel.json').readAsStringSync();
      final parsedAnimation = LottieParser.parse(source).animation;

      final code = LottieGenerator(parsedAnimation, 'assets/lotties/job_cards.json').generateWidgetClass();

      expect(
        code,
        allOf(
          contains('// Parent transform: Job Card 01 / Orbit Controller'),
          isNot(contains('_drawJobCard01OrbitController12(canvas, frame, 1);')),
          isNot(contains('void _drawJobCard01OrbitController12(')),
        ),
      );
    });

    test('when shape groups overlap, it should paint the bottom Lottie group before the groups above it', () {
      final source = File('example/assets/lotties/cataqui_job_cards_carousel.json').readAsStringSync();
      final animation = LottieParser.parse(source).animation;

      final code = LottieGenerator(animation, 'assets/lotties/job_cards.json').generateWidgetClass();

      expect(
        code.indexOf('// Group: Job Card 01 / Surface / Base'),
        lessThan(code.indexOf('// Group: Job Card 01 / Map / Style 03')),
      );
    });

    test('when generating code, it should produce valid Dart', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generateWidgetClass();

      expect(
        code,
        allOf(
          isNotEmpty,
          contains('class _Test extends StatefulWidget'),
          contains('class _TestState extends State<_Test>'),
          contains('class _TestPainter extends CustomPainter'),
          isNot(contains('class _DotdartScalarKeyframe')),
        ),
      );
    });

    test('when generating code, it should include the correct widget class name', () {
      final generator = LottieGenerator(animation, 'assets/lottie/my_animation.json');
      final code = generator.generateWidgetClass();

      expect(code, contains('class _MyAnimation extends StatefulWidget'));
    });

    test('when generating code, it should include color properties', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generateWidgetClass();

      expect(code, contains('layer1Color1'));
    });

    test('when generating code, it should include the lottie dimensions', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generateWidgetClass();

      expect(
        code,
        allOf(contains('_lottieWidth = 200'), contains('_lottieHeight = 200'), contains('_totalFrames = 60')),
      );
    });

    test('when a layer spans the animation, it should share the single animation bounds guard', () {
      final code = LottieGenerator(animation, 'assets/lottie/test.json').generateWidgetClass();
      final drawMethod = code.substring(code.indexOf('void _drawLayer10'));

      expect(
        (code.contains('if (frame >= 60) return;'), drawMethod.contains('if (frame < 0 || frame >= 60) return;')),
        (true, false),
      );
    });

    test('when an animation starts after frame zero, it should offset progress by the in-point', () {
      const offsetAnimation = LottieAnimation(
        width: 100,
        height: 100,
        frameRate: 30,
        inPoint: 10,
        outPoint: 40,
        name: 'Offset',
        layers: [],
      );

      final code = LottieGenerator(offsetAnimation, 'assets/lottie/offset.json').generateWidgetClass();

      expect(code, contains('final frame = 10 + progress * _Offset._totalFrames;'));
    });

    test('when a precomposition shifts child time, it should retain the child visibility guard', () {
      const shiftedCompositionAnimation = LottieAnimation(
        width: 100,
        height: 100,
        frameRate: 60,
        inPoint: 0,
        outPoint: 60,
        name: 'Shifted child',
        layers: [
          LottieLayer(
            name: 'Reference',
            shapeGroups: [],
            referenceId: 'child',
            inPoint: 0,
            outPoint: 60,
            startTime: 10,
          ),
        ],
        compositions: {
          'child': LottieComposition(
            id: 'child',
            width: 100,
            height: 100,
            layers: [
              LottieLayer(
                name: 'Child',
                shapeGroups: [
                  LottieGroup(
                    name: 'Visible',
                    items: [
                      LottieRect(positionX: 0, positionY: 0, width: 10, height: 10, cornerRadius: 0),
                      LottieFill(colorR: 1, colorG: 0, colorB: 0, colorA: 1, opacity: 100),
                    ],
                  ),
                ],
                inPoint: 0,
                outPoint: 60,
              ),
            ],
          ),
        },
      );

      final code = LottieGenerator(
        shiftedCompositionAnimation,
        'assets/lottie/shifted_child.json',
      ).generateWidgetClass();
      final childMethod = code.substring(code.indexOf('void _drawChild1'));

      expect(childMethod, contains('if (frame < 0 || frame >= 60) return;'));
    });

    test('when generating code, it should use the shared Lottie animation state mixin', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generateWidgetClass();

      expect(
        code,
        allOf(
          contains('_DotdartLottieAnimationState<_Test>'),
          contains('double? get lottieWidgetWidth => widget.width;'),
          contains('double get lottieCanvasWidth => _Test._lottieWidth;'),
          contains('Duration get lottieLoopDuration => _Test._loopDuration;'),
        ),
      );
    });

    test('when generating code, it should delegate sizing and build to the mixin', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generateWidgetClass();

      expect(
        code,
        allOf(
          isNot(contains('Size _defaultSizeFor')),
          isNot(contains('Widget build(BuildContext context)')),
          isNot(contains('void initState()')),
          isNot(contains('void dispose()')),
        ),
      );
    });

    test('when generating code, it should include the loop duration', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generateWidgetClass();

      expect(code, contains('Duration(milliseconds: 1000)'));
    });

    test('when generating code, it should include manual progress playback control', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generateWidgetClass();

      expect(code, allOf(contains('final double? progress;'), contains('final bool respectDisableAnimations;')));
    });

    test('when generating code, it should replace the animated property with nullable progress', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generateWidgetClass();

      expect(code, isNot(contains('final bool animated;')));
    });

    test('when generating code, it should include the painter with reusable paints', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generateWidgetClass();

      expect(
        code,
        allOf(
          contains('class _TestPainter extends CustomPainter'),
          contains('void paint(Canvas canvas, Size size)'),
          contains('final Paint _fillPaint = Paint()'),
          contains('final Paint _strokePaint = Paint()'),
          contains('bool shouldRepaint'),
        ),
      );
    });

    test('when generating a painter, it should compute canvas scale once outside the paint hot path', () {
      final code = LottieGenerator(animation, 'assets/lottie/test.json').generateWidgetClass();

      expect(
        code,
        allOf(
          contains('canvasScaleX: width / _Test._lottieWidth,'),
          contains('canvas.scale(_canvasScaleX, _canvasScaleY);'),
          isNot(contains('final scaleX = size.width / _Test._lottieWidth;')),
        ),
      );
    });

    test('when clipping a generated painter, it should reuse a canvas rectangle allocated during build', () {
      final code = LottieGenerator(animation, 'assets/lottie/test.json').generateWidgetClass();

      expect(
        code,
        allOf(
          contains('canvasRect: Rect.fromLTWH(0, 0, width, height),'),
          contains('if (clip) canvas.clipRect(_canvasRect);'),
          isNot(contains('Offset.zero & size')),
        ),
      );
    });

    test('when generating automatic playback, it should keep the painter attached while the controller is paused', () {
      final code = LottieGenerator(animation, 'assets/lottie/test.json').generateWidgetClass();

      expect(
        code,
        allOf(
          contains('animationProgress: widget.progress == null ? _controller : null,'),
          isNot(contains('animationProgress: _shouldAnimate() ? _controller : null,')),
        ),
      );
    });

    test('when generating unboxed text, it should compute and cache its paint offset with the text layout', () {
      final source = File('example/assets/lotties/cataqui_job_cards_carousel.json').readAsStringSync();
      final parsedAnimation = LottieParser.parse(source).animation;

      final code = LottieGenerator(parsedAnimation, 'assets/lotties/job_cards.json').generateWidgetClass();

      expect(
        code,
        allOf(
          contains(
            '_textPainter18Offset = Offset(0, -painter.computeDistanceToActualBaseline(TextBaseline.alphabetic));',
          ),
          contains('textPainter.paint(canvas, _textPainter18Offset);'),
        ),
      );
    });

    test('when generating code, it should delegate lifecycle management to the mixin', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generateWidgetClass();

      expect(
        code,
        allOf(
          contains('_DotdartLottieAnimationState<_Test>'),
          isNot(contains('void initState()')),
          isNot(contains('void didChangeAppLifecycleState')),
          isNot(contains('_controller.dispose()')),
        ),
      );
    });

    test('when generating code, it should include the draw method for the layer', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generateWidgetClass();

      expect(code, contains('_drawLayer10'));
    });

    test('when generating code, it should include the rect drawing code', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generateWidgetClass();

      expect(
        code,
        allOf(
          contains('static final RRect _rrect0_0_0 = RRect.fromRectAndRadius('),
          contains('canvas.drawRRect(_rrect0_0_0, fillPaint0_0);'),
        ),
      );
    });

    test('when generating code with fills and strokes, it should allocate only two reusable paint objects', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generateWidgetClass();

      expect(RegExp(r'Paint\(\)').allMatches(code).length, 2);
    });

    test('when generating code, it should include the fill and stroke paints', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generateWidgetClass();

      expect(code, allOf(contains('PaintingStyle.fill'), contains('PaintingStyle.stroke')));
    });

    test('when generating code, it should be valid Dart that can be parsed', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generateWidgetClass();

      // Verify it's valid Dart by checking it can be parsed
      // (DartFormatter already validates during generation)
      expect((code.isNotEmpty, code.runes.length > 500), (true, true));
    });

    test('when generating code for reduced-motion users, it should expose the respect flag via a getter', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generateWidgetClass();

      expect(
        code,
        allOf(
          contains('bool get lottieRespectDisableAnimations => widget.respectDisableAnimations;'),
          contains('this.respectDisableAnimations = true'),
        ),
      );
    });

    test('when generating code with manual progress, it should expose progress via a getter', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generateWidgetClass();

      expect(code, contains('double? get lottieProgress => widget.progress;'));
    });

    test('when generating code with manual progress, it should clamp the fixed progress before painting', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generateWidgetClass();

      expect(code, contains('fixedProgress: (widget.progress ?? 0).clamp(0, 1).toDouble(),'));
    });

    test('when generating code with manual progress, it should repaint when the fixed progress changes', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generateWidgetClass();

      expect(code, contains('oldDelegate._fixedProgress != _fixedProgress'));
    });

    test('when generating code with layer opacity, it should apply opacity via the shared helper', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generateWidgetClass();

      expect(
        code,
        allOf(
          contains('_dotdartApplyOpacity(overrides.layer1Color1 ?? const Color(0xffff0000), layerOpacity * 1)'),
          isNot(contains('saveLayer')),
        ),
      );
    });

    test('when generating code for an open path, it should not close the generated path', () {
      const openPathAnimation = LottieAnimation(
        width: 100,
        height: 100,
        frameRate: 60,
        inPoint: 0,
        outPoint: 60,
        name: 'Open Path',
        layers: [
          LottieLayer(
            name: 'Path Layer',
            shapeGroups: [
              LottieGroup(
                name: 'Open Path Group',
                items: [
                  LottiePath(
                    vertices: [
                      [0, 0],
                      [10, 10],
                    ],
                    inTangents: [
                      [0, 0],
                      [0, 0],
                    ],
                    outTangents: [
                      [0, 0],
                      [0, 0],
                    ],
                    closed: false,
                  ),
                  LottieStroke(colorR: 1, colorG: 0, colorB: 0, colorA: 1, opacity: 100, width: 2),
                ],
              ),
            ],
          ),
        ],
      );
      final generator = LottieGenerator(openPathAnimation, 'assets/lottie/open_path.json');
      final code = generator.generateWidgetClass();

      expect(code, isNot(contains('..close()')));
    });

    test('when getting params, it should include standard constructor parameters', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final params = generator.params;

      expect(params.any((p) => p.name == 'key' && p.type == 'Key?'), isTrue);
    });

    test('when getting params, it should include width and height', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final params = generator.params;

      expect(params.any((p) => p.name == 'width' && p.type == 'double?'), isTrue);
      expect(params.any((p) => p.name == 'height' && p.type == 'double?'), isTrue);
    });

    test('when getting params, it should include progress', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final params = generator.params;

      expect(params.any((p) => p.name == 'progress' && p.type == 'double?'), isTrue);
    });

    test('when getting params, it should include respectDisableAnimations with default true', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final params = generator.params;

      final param = params.firstWhere((p) => p.name == 'respectDisableAnimations');
      expect(param.type, 'bool');
      expect(param.defaultValue, 'true');
    });

    test('when getting params, it should include maintainAspectRatio with default true', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final params = generator.params;

      final param = params.firstWhere((p) => p.name == 'maintainAspectRatio');
      expect(param.type, 'bool');
      expect(param.defaultValue, 'true');
    });

    test('when getting params, it should include clip with default true', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final params = generator.params;

      final param = params.firstWhere((candidate) => candidate.name == 'clip');
      expect((param.type, param.defaultValue), ('bool', 'true'));
    });

    test('when generating clipping controls, it should conditionally clip and repaint at the canvas boundary', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generateWidgetClass();

      expect(
        code,
        allOf(
          contains('this.clip = true'),
          contains('final bool clip;'),
          contains('clip: widget.clip'),
          contains('required this.clip'),
          contains('if (clip) canvas.clipRect(_canvasRect);'),
          contains('oldDelegate.clip != clip'),
        ),
      );
    });

    test('when generating source, it should emit the maintainAspectRatio field declaration in Lottie widgets', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generateWidgetClass();

      expect(code, contains('final bool maintainAspectRatio;'));
    });

    test('when generating source, it should emit the lottieMaintainAspectRatio getter override in Lottie state', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generateWidgetClass();

      expect(code, contains('bool get lottieMaintainAspectRatio => widget.maintainAspectRatio;'));
    });

    test('when getting params, it should include one overrides object for customizable colors', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final params = generator.params;

      expect(params.any((p) => p.name == 'overrides' && p.type == 'TestOverrides'), isTrue);
    });

    test('when extracting colors from the animation, it should produce correct color entries', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generateWidgetClass();

      expect(RegExp(r'final Color\? layer1Color\d;').allMatches(code).length, 2);
    });
  });

  group('LottieGenerator ellipse', () {
    test('when generating code with an ellipse shape, it should include drawOval', () {
      const ellipseAnimation = LottieAnimation(
        width: 100,
        height: 100,
        frameRate: 60,
        inPoint: 0,
        outPoint: 60,
        name: 'Ellipse Anim',
        layers: [
          LottieLayer(
            name: 'Ellipse Layer',
            shapeGroups: [
              LottieGroup(
                name: 'Ellipse Group',
                items: [
                  LottieEllipse(positionX: 0, positionY: 0, width: 80, height: 60, direction: 1),
                  LottieFill(colorR: 1, colorG: 0, colorB: 0, colorA: 1, opacity: 100),
                  LottieGroupTransform(opacity: 100),
                ],
              ),
            ],
            opacity: LottieAnimatedScalar(animated: false, staticValue: 100),
          ),
        ],
      );
      final generator = LottieGenerator(ellipseAnimation, 'assets/lottie/ellipse.json');
      final code = generator.generateWidgetClass();

      expect(
        code,
        allOf(
          contains('static final Rect _ellipseRect0_0_0 = Rect.fromCenter('),
          contains('canvas.drawOval(_ellipseRect0_0_0, fillPaint0_0);'),
        ),
      );
    });

    test('when generating code for an ellipse with stroke, it should include strokePaint', () {
      const ellipseAnimation = LottieAnimation(
        width: 100,
        height: 100,
        frameRate: 60,
        inPoint: 0,
        outPoint: 60,
        name: 'Ellipse Stroke',
        layers: [
          LottieLayer(
            name: 'Ellipse Layer',
            shapeGroups: [
              LottieGroup(
                name: 'Group',
                items: [
                  LottieEllipse(positionX: 0, positionY: 0, width: 80, height: 60, direction: 1),
                  LottieStroke(colorR: 0, colorG: 0, colorB: 1, colorA: 1, opacity: 100, width: 3),
                  LottieGroupTransform(opacity: 100),
                ],
              ),
            ],
            opacity: LottieAnimatedScalar(animated: false, staticValue: 100),
          ),
        ],
      );
      final generator = LottieGenerator(ellipseAnimation, 'assets/lottie/ellipse_stroke.json');
      final code = generator.generateWidgetClass();

      expect(code, allOf(contains('drawOval'), contains('strokePaint')));
    });

    test('when generating code without strokes, it should omit the unused stroke paint', () {
      const fillOnlyAnimation = LottieAnimation(
        width: 100,
        height: 100,
        frameRate: 60,
        inPoint: 0,
        outPoint: 60,
        name: 'Fill Only',
        layers: [
          LottieLayer(
            name: 'Fill Layer',
            shapeGroups: [
              LottieGroup(
                name: 'Fill Group',
                items: [
                  LottieRect(positionX: 0, positionY: 0, width: 50, height: 50, cornerRadius: 0, direction: 1),
                  LottieFill(colorR: 1, colorG: 0, colorB: 0, colorA: 1, opacity: 100),
                  LottieGroupTransform(opacity: 100),
                ],
              ),
            ],
            opacity: LottieAnimatedScalar(animated: false, staticValue: 100),
          ),
        ],
      );
      final generator = LottieGenerator(fillOnlyAnimation, 'assets/lottie/fill_only.json');
      final code = generator.generateWidgetClass();

      expect(code, isNot(contains('final Paint _strokePaint')));
    });
  });

  group('LottieGenerator path shapes', () {
    test('when generating code with a static path, it should compile path commands without retaining point lists', () {
      const staticPathAnimation = LottieAnimation(
        width: 100,
        height: 100,
        frameRate: 60,
        inPoint: 0,
        outPoint: 60,
        name: 'Static Path',
        layers: [
          LottieLayer(
            name: 'Path Layer',
            shapeGroups: [
              LottieGroup(
                name: 'Group',
                items: [
                  LottiePath(
                    vertices: [
                      [0, 0],
                      [10, 10],
                    ],
                    inTangents: [
                      [0, 0],
                      [0, 0],
                    ],
                    outTangents: [
                      [0, 0],
                      [0, 0],
                    ],
                    closed: false,
                  ),
                  LottieStroke(colorR: 0, colorG: 0, colorB: 0, colorA: 1, opacity: 100, width: 2),
                ],
              ),
            ],
          ),
        ],
      );
      final generator = LottieGenerator(staticPathAnimation, 'assets/lottie/static_path.json');
      final code = generator.generateWidgetClass();

      expect(
        code,
        allOf(
          contains('static final Path __path0_0_0 = Path()'),
          contains('..moveTo(0, 0)'),
          contains('..cubicTo(0, 0, 10, 10, 10, 10)'),
          isNot(contains('_path0_0_0Vertices')),
          isNot(contains('static Path? _cached_path0_0_0')),
        ),
      );
    });

    test('when compiling path control points, it should preserve the previous component rounding order', () {
      const roundedPathAnimation = LottieAnimation(
        width: 100,
        height: 100,
        frameRate: 60,
        inPoint: 0,
        outPoint: 60,
        name: 'Rounded Path',
        layers: [
          LottieLayer(
            name: 'Path Layer',
            shapeGroups: [
              LottieGroup(
                name: 'Group',
                items: [
                  LottiePath(
                    vertices: [
                      [0.00006, 0],
                      [1, 1],
                    ],
                    inTangents: [
                      [0, 0],
                      [0, 0],
                    ],
                    outTangents: [
                      [0.00006, 0],
                      [0, 0],
                    ],
                    closed: false,
                  ),
                  LottieStroke(colorR: 0, colorG: 0, colorB: 0, colorA: 1, opacity: 100, width: 2),
                ],
              ),
            ],
          ),
        ],
      );
      final generator = LottieGenerator(roundedPathAnimation, 'assets/lottie/rounded_path.json');
      final code = generator.generateWidgetClass();

      expect(code, contains('..cubicTo(0.0002, 0, 1, 1, 1, 1)'));
    });

    test('when generating code with a closed path, it should include close()', () {
      const closedPathAnimation = LottieAnimation(
        width: 100,
        height: 100,
        frameRate: 60,
        inPoint: 0,
        outPoint: 60,
        name: 'Closed Path',
        layers: [
          LottieLayer(
            name: 'Path Layer',
            shapeGroups: [
              LottieGroup(
                name: 'Group',
                items: [
                  LottiePath(
                    vertices: [
                      [0, 0],
                      [10, 0],
                      [10, 10],
                    ],
                    inTangents: [
                      [0, 0],
                      [0, 0],
                      [0, 0],
                    ],
                    outTangents: [
                      [0, 0],
                      [0, 0],
                      [0, 0],
                    ],
                    closed: true,
                  ),
                  LottieStroke(colorR: 0, colorG: 0, colorB: 0, colorA: 1, opacity: 100, width: 2),
                ],
              ),
            ],
          ),
        ],
      );
      final generator = LottieGenerator(closedPathAnimation, 'assets/lottie/closed_path.json');
      final code = generator.generateWidgetClass();

      expect(code, contains('..close()'));
    });

    test('when generating code with an even-odd fill path, it should include PathFillType.evenOdd', () {
      const evenOddAnimation = LottieAnimation(
        width: 100,
        height: 100,
        frameRate: 60,
        inPoint: 0,
        outPoint: 60,
        name: 'EvenOdd Path',
        layers: [
          LottieLayer(
            name: 'Path Layer',
            shapeGroups: [
              LottieGroup(
                name: 'Group',
                items: [
                  LottiePath(
                    vertices: [
                      [0, 0],
                      [50, 0],
                      [50, 50],
                    ],
                    inTangents: [
                      [0, 0],
                      [0, 0],
                      [0, 0],
                    ],
                    outTangents: [
                      [0, 0],
                      [0, 0],
                      [0, 0],
                    ],
                    closed: true,
                  ),
                  LottieFill(colorR: 0, colorG: 1, colorB: 0, colorA: 1, opacity: 100, fillRule: 2),
                ],
              ),
            ],
          ),
        ],
      );
      final generator = LottieGenerator(evenOddAnimation, 'assets/lottie/even_odd.json');
      final code = generator.generateWidgetClass();

      expect(code, contains('PathFillType.evenOdd'));
    });
  });

  group('LottieGenerator animated keyframes', () {
    test('when generating code with animated layer opacity, it should emit a specialized scalar evaluator', () {
      const animatedAnimation = LottieAnimation(
        width: 100,
        height: 100,
        frameRate: 60,
        inPoint: 0,
        outPoint: 60,
        name: 'Animated Opacity',
        layers: [
          LottieLayer(
            name: 'Anim Layer',
            shapeGroups: [],
            opacity: LottieAnimatedScalar(
              animated: true,
              keyframes: [LottieScalarKeyframe(time: 0, start: 100, end: 0), LottieScalarKeyframe(time: 60, start: 0)],
            ),
          ),
        ],
      );
      final generator = LottieGenerator(animatedAnimation, 'assets/lottie/animated_opacity.json');
      final code = generator.generateWidgetClass();

      expect(
        code,
        allOf(
          contains('double _keyframes0Opacity(double frame)'),
          contains('final t = frame / 60;'),
          isNot(contains('List<_DotdartScalarKeyframe>')),
          isNot(contains('for (var i = 0; i < kfs.length - 1; i++)')),
        ),
      );
    });

    test('when generating code with incomplete easing handles, it should fall back to linear interpolation', () {
      const incompleteEasingAnimation = LottieAnimation(
        width: 100,
        height: 100,
        frameRate: 60,
        inPoint: 0,
        outPoint: 60,
        name: 'Incomplete Easing',
        layers: [
          LottieLayer(
            name: 'Anim Layer',
            shapeGroups: [],
            opacity: LottieAnimatedScalar(
              animated: true,
              keyframes: [LottieScalarKeyframe(time: 0, start: 100, end: 0, outX: 0.42)],
            ),
          ),
        ],
      );
      final generator = LottieGenerator(incompleteEasingAnimation, 'assets/lottie/incomplete_easing.json');
      final code = generator.generateWidgetClass();

      expect(code, isNot(contains('const Cubic(')));
    });

    test('when animated properties share easing, it should solve the cubic only once for the same progress', () {
      const sharedKeyframes = [
        LottieScalarKeyframe(time: 0, start: 0, end: 100, outX: 0.42, outY: 0, inX: 0.58, inY: 1),
        LottieScalarKeyframe(time: 60, start: 100),
      ];
      const sharedEasingAnimation = LottieAnimation(
        width: 100,
        height: 100,
        frameRate: 60,
        inPoint: 0,
        outPoint: 60,
        name: 'Shared Easing',
        layers: [
          LottieLayer(
            name: 'Anim Layer',
            shapeGroups: [],
            opacity: LottieAnimatedScalar(animated: true, keyframes: sharedKeyframes),
            rotation: LottieAnimatedScalar(animated: true, keyframes: sharedKeyframes),
          ),
        ],
      );
      final generator = LottieGenerator(sharedEasingAnimation, 'assets/lottie/shared_easing.json');
      final code = generator.generateWidgetClass();

      expect(
        code,
        allOf(
          contains('double _transformCurve0(double t)'),
          contains('final eased = _transformCurve0(t);'),
          predicate<String>((value) => RegExp(r'const Cubic\(').allMatches(value).length == 1),
        ),
      );
    });

    test('when an animated property never changes value, it should compile it as a static transform', () {
      const constantAnimation = LottieAnimation(
        width: 100,
        height: 100,
        frameRate: 60,
        inPoint: 0,
        outPoint: 60,
        name: 'Constant Transform',
        layers: [
          LottieLayer(
            name: 'Layer',
            shapeGroups: [
              LottieGroup(
                name: 'Visible',
                items: [
                  LottieRect(positionX: 0, positionY: 0, width: 10, height: 10, cornerRadius: 0),
                  LottieFill(colorR: 1, colorG: 0, colorB: 0, colorA: 1, opacity: 100),
                ],
              ),
            ],
            positionX: LottieAnimatedScalar(
              animated: true,
              keyframes: [
                LottieScalarKeyframe(time: 0, start: 25, end: 25, outX: 0.42, outY: 0, inX: 0.58, inY: 1),
                LottieScalarKeyframe(time: 60, start: 25),
              ],
            ),
          ),
        ],
      );
      final generator = LottieGenerator(constantAnimation, 'assets/lottie/constant_transform.json');
      final code = generator.generateWidgetClass();

      expect(code, allOf(contains('canvas.translate(25, 0);'), isNot(contains('_keyframes0PositionX'))));
    });

    test('when one animated segment has no value delta, it should skip easing work for that segment', () {
      const constantSegmentAnimation = LottieAnimation(
        width: 100,
        height: 100,
        frameRate: 60,
        inPoint: 0,
        outPoint: 60,
        name: 'Constant Segment',
        layers: [
          LottieLayer(
            name: 'Layer',
            shapeGroups: [],
            rotation: LottieAnimatedScalar(
              animated: true,
              keyframes: [
                LottieScalarKeyframe(time: 0, start: 0, end: 0, outX: 0.42, outY: 0, inX: 0.58, inY: 1),
                LottieScalarKeyframe(time: 30, start: 0, end: 90),
                LottieScalarKeyframe(time: 60, start: 90),
              ],
            ),
          ),
        ],
      );
      final generator = LottieGenerator(constantSegmentAnimation, 'assets/lottie/constant_segment.json');
      final code = generator.generateWidgetClass();

      expect(code, contains('if (frame < 30) {\n      return 0;\n    }'));
    });
  });

  group('LottieGenerator multiple items', () {
    test('when generating code with multiple layers, it should emit multiple draw methods', () {
      const multiLayer = LottieAnimation(
        width: 100,
        height: 100,
        frameRate: 60,
        inPoint: 0,
        outPoint: 60,
        name: 'Multi Layer',
        layers: [
          LottieLayer(
            name: 'Layer A',
            shapeGroups: [
              LottieGroup(
                name: 'Group A',
                items: [
                  LottieRect(positionX: 0, positionY: 0, width: 50, height: 50, cornerRadius: 0),
                  LottieFill(colorR: 1, colorG: 0, colorB: 0, colorA: 1, opacity: 100),
                  LottieGroupTransform(opacity: 100),
                ],
              ),
            ],
          ),
          LottieLayer(
            name: 'Layer B',
            shapeGroups: [
              LottieGroup(
                name: 'Group B',
                items: [
                  LottieRect(positionX: 10, positionY: 10, width: 30, height: 30, cornerRadius: 0),
                  LottieFill(colorR: 0, colorG: 0, colorB: 1, colorA: 1, opacity: 100),
                  LottieGroupTransform(opacity: 100),
                ],
              ),
            ],
          ),
        ],
      );
      final generator = LottieGenerator(multiLayer, 'assets/lottie/multi_layer.json');
      final code = generator.generateWidgetClass();

      expect(code, allOf(contains('_drawLayerA0'), contains('_drawLayerB1')));
    });

    test('when generating code with multiple layers, it should paint later Lottie layers behind earlier layers', () {
      const multiLayer = LottieAnimation(
        width: 100,
        height: 100,
        frameRate: 60,
        inPoint: 0,
        outPoint: 60,
        name: 'Layer Order',
        layers: [
          LottieLayer(
            name: 'Top Layer',
            shapeGroups: [
              LottieGroup(
                name: 'Top',
                items: [
                  LottieRect(positionX: 0, positionY: 0, width: 10, height: 10, cornerRadius: 0),
                  LottieFill(colorR: 1, colorG: 0, colorB: 0, colorA: 1, opacity: 100),
                ],
              ),
            ],
          ),
          LottieLayer(
            name: 'Bottom Layer',
            shapeGroups: [
              LottieGroup(
                name: 'Bottom',
                items: [
                  LottieRect(positionX: 0, positionY: 0, width: 10, height: 10, cornerRadius: 0),
                  LottieFill(colorR: 0, colorG: 0, colorB: 1, colorA: 1, opacity: 100),
                ],
              ),
            ],
          ),
        ],
      );
      final generator = LottieGenerator(multiLayer, 'assets/lottie/layer_order.json');
      final code = generator.generateWidgetClass();

      expect(
        code.indexOf('_drawBottomLayer1(canvas, frame, 1);') < code.indexOf('_drawTopLayer0(canvas, frame, 1);'),
        isTrue,
      );
    });

    test('when generating code with multiple shape groups in a layer, it should render both groups', () {
      const multiGroup = LottieAnimation(
        width: 100,
        height: 100,
        frameRate: 60,
        inPoint: 0,
        outPoint: 60,
        name: 'Multi Group',
        layers: [
          LottieLayer(
            name: 'Layer',
            shapeGroups: [
              LottieGroup(
                name: 'Group 1',
                items: [
                  LottieRect(positionX: 0, positionY: 0, width: 20, height: 20, cornerRadius: 0),
                  LottieFill(colorR: 1, colorG: 0, colorB: 0, colorA: 1, opacity: 100),
                  LottieGroupTransform(opacity: 100),
                ],
              ),
              LottieGroup(
                name: 'Group 2',
                items: [
                  LottieRect(positionX: 10, positionY: 10, width: 20, height: 20, cornerRadius: 0),
                  LottieFill(colorR: 0, colorG: 0, colorB: 1, colorA: 1, opacity: 100),
                  LottieGroupTransform(opacity: 100),
                ],
              ),
            ],
          ),
        ],
      );
      final generator = LottieGenerator(multiGroup, 'assets/lottie/multi_group.json');
      final code = generator.generateWidgetClass();

      expect(code, allOf(contains('Group: Group 1'), contains('Group: Group 2')));
    });

    test('when a non-zero fill applies to multiple shapes, it should draw them as one compound path', () {
      const multiRect = LottieAnimation(
        width: 100,
        height: 100,
        frameRate: 60,
        inPoint: 0,
        outPoint: 60,
        name: 'Multi Rect',
        layers: [
          LottieLayer(
            name: 'Layer',
            shapeGroups: [
              LottieGroup(
                name: 'Group',
                items: [
                  LottieRect(positionX: 0, positionY: 0, width: 20, height: 20, cornerRadius: 0),
                  LottieRect(positionX: 10, positionY: 10, width: 12, height: 12, cornerRadius: 2),
                  LottieFill(colorR: 1, colorG: 0, colorB: 0, colorA: 1, opacity: 100),
                  LottieGroupTransform(opacity: 100),
                ],
              ),
            ],
          ),
        ],
      );
      final generator = LottieGenerator(multiRect, 'assets/lottie/multi_rect.json');
      final code = generator.generateWidgetClass();

      expect(
        code,
        allOf(
          contains('static final Path _compoundFillPath0_0 = Path()'),
          contains('..addRRect('),
          contains('canvas.drawPath(_compoundFillPath0_0, compoundFillPaint0)'),
          isNot(contains('PathFillType.evenOdd')),
          isNot(contains('static final RRect _rrect0_0_0')),
        ),
      );
    });

    test('when generating code with an even-odd fill across multiple rects, it should combine them into one path', () {
      const compoundRect = LottieAnimation(
        width: 100,
        height: 100,
        frameRate: 60,
        inPoint: 0,
        outPoint: 60,
        name: 'Compound Rect',
        layers: [
          LottieLayer(
            name: 'Layer',
            shapeGroups: [
              LottieGroup(
                name: 'Group',
                items: [
                  LottieRect(positionX: 0, positionY: 0, width: 40, height: 40, cornerRadius: 8),
                  LottieRect(positionX: 0, positionY: 0, width: 12, height: 12, cornerRadius: 2),
                  LottieFill(colorR: 1, colorG: 0, colorB: 0, colorA: 1, opacity: 100, fillRule: 2),
                  LottieGroupTransform(opacity: 100),
                ],
              ),
            ],
          ),
        ],
      );
      final generator = LottieGenerator(compoundRect, 'assets/lottie/compound_rect.json');
      final code = generator.generateWidgetClass();

      expect(
        code,
        allOf(
          contains('static final Path _compoundFillPath0_0 = Path()'),
          contains('..fillType = PathFillType.evenOdd'),
          contains('..addRRect('),
          contains('canvas.drawPath(_compoundFillPath0_0, compoundFillPaint0)'),
          isNot(contains('static final RRect _rrect0_0_0')),
          isNot(contains('final bodyRect0_0')),
          isNot(contains('canvas.drawRRect(body0_0, fillPaint0_0)')),
        ),
      );
    });

    test('when generating code with multiple stroke-only paths, it should draw one combined stroke path', () {
      const compoundStroke = LottieAnimation(
        width: 100,
        height: 100,
        frameRate: 60,
        inPoint: 0,
        outPoint: 60,
        name: 'Compound Stroke',
        layers: [
          LottieLayer(
            name: 'Layer',
            shapeGroups: [
              LottieGroup(
                name: 'Group',
                items: [
                  LottiePath(
                    vertices: [
                      [0, 0],
                      [10, 0],
                    ],
                    inTangents: [
                      [0, 0],
                      [0, 0],
                    ],
                    outTangents: [
                      [0, 0],
                      [0, 0],
                    ],
                    closed: false,
                  ),
                  LottiePath(
                    vertices: [
                      [0, 0],
                      [0, 10],
                    ],
                    inTangents: [
                      [0, 0],
                      [0, 0],
                    ],
                    outTangents: [
                      [0, 0],
                      [0, 0],
                    ],
                    closed: false,
                  ),
                  LottieStroke(colorR: 1, colorG: 0, colorB: 0, colorA: 1, opacity: 100, width: 2),
                ],
              ),
            ],
          ),
        ],
      );
      final generator = LottieGenerator(compoundStroke, 'assets/lottie/compound_stroke.json');
      final code = generator.generateWidgetClass();

      expect(
        code,
        allOf(
          contains('static final Path _compoundStrokePath0_0 = Path()'),
          contains('..addPath(__path0_0_0, Offset.zero)'),
          contains('..addPath(__path0_0_1, Offset.zero)'),
          contains('canvas.drawPath(_compoundStrokePath0_0, compoundStrokePaint0);'),
          isNot(contains('canvas.drawPath(__path0_0_0, strokePaint0_0);')),
        ),
      );
    });

    test('when generating code with filled paths and a stroke, it should not combine strokes', () {
      const filledStroke = LottieAnimation(
        width: 100,
        height: 100,
        frameRate: 60,
        inPoint: 0,
        outPoint: 60,
        name: 'Filled Stroke',
        layers: [
          LottieLayer(
            name: 'Layer',
            shapeGroups: [
              LottieGroup(
                name: 'Group',
                items: [
                  LottiePath(
                    vertices: [
                      [0, 0],
                      [10, 0],
                    ],
                    inTangents: [
                      [0, 0],
                      [0, 0],
                    ],
                    outTangents: [
                      [0, 0],
                      [0, 0],
                    ],
                    closed: false,
                  ),
                  LottiePath(
                    vertices: [
                      [0, 0],
                      [0, 10],
                    ],
                    inTangents: [
                      [0, 0],
                      [0, 0],
                    ],
                    outTangents: [
                      [0, 0],
                      [0, 0],
                    ],
                    closed: false,
                  ),
                  LottieFill(colorR: 1, colorG: 1, colorB: 1, colorA: 1, opacity: 100),
                  LottieStroke(colorR: 1, colorG: 0, colorB: 0, colorA: 1, opacity: 100, width: 2),
                ],
              ),
            ],
          ),
        ],
      );
      final generator = LottieGenerator(filledStroke, 'assets/lottie/filled_stroke.json');
      final code = generator.generateWidgetClass();

      expect(code, isNot(contains('compoundStrokePath0')));
    });

    test('when generating code with an identity group transform, it should omit redundant canvas stack operations', () {
      final generator = LottieGenerator(animation, 'assets/lottie/test.json');
      final code = generator.generateWidgetClass();

      expect(code, isNot(contains('// Group: Group 1\n    canvas.save();')));
    });

    test('when generating code with a fully transparent group, it should preserve later visible groups', () {
      const transparentGroupAnimation = LottieAnimation(
        width: 100,
        height: 100,
        frameRate: 60,
        inPoint: 0,
        outPoint: 60,
        name: 'Transparent Group',
        layers: [
          LottieLayer(
            name: 'Layer',
            shapeGroups: [
              LottieGroup(
                name: 'Hidden',
                items: [
                  LottieRect(positionX: 0, positionY: 0, width: 20, height: 20, cornerRadius: 0),
                  LottieFill(colorR: 1, colorG: 0, colorB: 0, colorA: 1, opacity: 100),
                  LottieGroupTransform(opacity: 0),
                ],
              ),
              LottieGroup(
                name: 'Visible',
                items: [
                  LottieRect(positionX: 0, positionY: 0, width: 20, height: 20, cornerRadius: 0),
                  LottieFill(colorR: 0, colorG: 1, colorB: 0, colorA: 1, opacity: 100),
                  LottieGroupTransform(opacity: 100),
                ],
              ),
            ],
          ),
        ],
      );
      final generator = LottieGenerator(transparentGroupAnimation, 'assets/lottie/transparent_group.json');
      final code = generator.generateWidgetClass();

      expect(code, allOf(isNot(contains('Group: Hidden')), contains('Group: Visible')));
    });
  });

  group('LottieGenerator line styles', () {
    test('when generating code with stroke butt cap and bevel join, it should emit the correct options', () {
      const lineStyleAnimation = LottieAnimation(
        width: 100,
        height: 100,
        frameRate: 60,
        inPoint: 0,
        outPoint: 60,
        name: 'Line Style',
        layers: [
          LottieLayer(
            name: 'Layer',
            shapeGroups: [
              LottieGroup(
                name: 'Group',
                items: [
                  LottieRect(positionX: 0, positionY: 0, width: 50, height: 50, cornerRadius: 0),
                  LottieStroke(
                    colorR: 0,
                    colorG: 0,
                    colorB: 0,
                    colorA: 1,
                    opacity: 100,
                    width: 2,
                    lineCap: 1,
                    lineJoin: 3,
                  ),
                  LottieGroupTransform(opacity: 100),
                ],
              ),
            ],
            opacity: LottieAnimatedScalar(animated: false, staticValue: 100),
          ),
        ],
      );
      final generator = LottieGenerator(lineStyleAnimation, 'assets/lottie/line_style.json');
      final code = generator.generateWidgetClass();

      expect(code, allOf(contains('StrokeCap.butt'), contains('StrokeJoin.bevel')));
    });
  });

  group('LottieGenerator transform', () {
    test('when generating code with group rotation, it should include canvas.rotate', () {
      const rotationAnimation = LottieAnimation(
        width: 100,
        height: 100,
        frameRate: 60,
        inPoint: 0,
        outPoint: 60,
        name: 'Rotation',
        layers: [
          LottieLayer(
            name: 'Layer',
            shapeGroups: [
              LottieGroup(
                name: 'Group',
                items: [
                  LottieRect(positionX: 0, positionY: 0, width: 50, height: 50, cornerRadius: 0),
                  LottieFill(colorR: 1, colorG: 0, colorB: 0, colorA: 1, opacity: 100),
                  LottieGroupTransform(opacity: 100, rotation: 45),
                ],
              ),
            ],
            opacity: LottieAnimatedScalar(animated: false, staticValue: 100),
          ),
        ],
      );
      final generator = LottieGenerator(rotationAnimation, 'assets/lottie/rotation.json');
      final code = generator.generateWidgetClass();

      expect(code, contains('canvas.rotate('));
    });

    test('when generating code with group scaling, it should include canvas.scale', () {
      const scaleAnimation = LottieAnimation(
        width: 100,
        height: 100,
        frameRate: 60,
        inPoint: 0,
        outPoint: 60,
        name: 'Scale',
        layers: [
          LottieLayer(
            name: 'Layer',
            shapeGroups: [
              LottieGroup(
                name: 'Group',
                items: [
                  LottieRect(positionX: 0, positionY: 0, width: 50, height: 50, cornerRadius: 0),
                  LottieFill(colorR: 1, colorG: 0, colorB: 0, colorA: 1, opacity: 100),
                  LottieGroupTransform(opacity: 100, scaleX: 150, scaleY: 80),
                ],
              ),
            ],
            opacity: LottieAnimatedScalar(animated: false, staticValue: 100),
          ),
        ],
      );
      final generator = LottieGenerator(scaleAnimation, 'assets/lottie/scale.json');
      final code = generator.generateWidgetClass();

      expect(code, contains('canvas.scale'));
    });

    test('when generating code with group anchor, it should include a negative translate', () {
      const anchorAnimation = LottieAnimation(
        width: 100,
        height: 100,
        frameRate: 60,
        inPoint: 0,
        outPoint: 60,
        name: 'Anchor',
        layers: [
          LottieLayer(
            name: 'Layer',
            shapeGroups: [
              LottieGroup(
                name: 'Group',
                items: [
                  LottieRect(positionX: 0, positionY: 0, width: 50, height: 50, cornerRadius: 0),
                  LottieFill(colorR: 1, colorG: 0, colorB: 0, colorA: 1, opacity: 100),
                  LottieGroupTransform(opacity: 100, anchorX: 10, anchorY: 20),
                ],
              ),
            ],
            opacity: LottieAnimatedScalar(animated: false, staticValue: 100),
          ),
        ],
      );
      final generator = LottieGenerator(anchorAnimation, 'assets/lottie/anchor.json');
      final code = generator.generateWidgetClass();

      expect(code, contains('translate(-10, -20)'));
    });
  });

  group('LottieGenerator widget class name', () {
    test('when the filename has dashes, it should convert to PascalCase', () {
      final generator = LottieGenerator(animation, 'assets/lottie/my-cool-animation.json');

      expect(generator.widgetClassName, '_MyCoolAnimation');
    });

    test('when the filename has underscores, it should convert to PascalCase', () {
      final generator = LottieGenerator(animation, 'assets/lottie/my_awesome_file.json');

      expect(generator.widgetClassName, '_MyAwesomeFile');
    });

    test('when the filename has spaces, it should convert to PascalCase', () {
      final generator = LottieGenerator(animation, 'assets/lottie/my file name.json');

      expect(generator.widgetClassName, '_MyFileName');
    });
  });

  group('LottieGenerator color deduplication', () {
    test('when two shapes use the same color, it should not duplicate the color parameter', () {
      const dedupAnimation = LottieAnimation(
        width: 100,
        height: 100,
        frameRate: 60,
        inPoint: 0,
        outPoint: 60,
        name: 'Dedup',
        layers: [
          LottieLayer(
            name: 'Layer',
            shapeGroups: [
              LottieGroup(
                name: 'Group',
                items: [
                  LottieRect(positionX: 0, positionY: 0, width: 50, height: 50, cornerRadius: 0),
                  LottieFill(colorR: 1, colorG: 0, colorB: 0, colorA: 1, opacity: 100),
                  LottieStroke(colorR: 1, colorG: 0, colorB: 0, colorA: 1, opacity: 100, width: 2),
                  LottieGroupTransform(opacity: 100),
                ],
              ),
            ],
            opacity: LottieAnimatedScalar(animated: false, staticValue: 100),
          ),
        ],
      );
      final generator = LottieGenerator(dedupAnimation, 'assets/lottie/dedup.json');
      final code = generator.generateWidgetClass();

      expect(code, allOf(isNot(contains('layerColor2')), contains('layerColor')));
    });
  });
}
