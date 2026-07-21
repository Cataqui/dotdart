import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('when loading the pulse fixture, it should contain changing opacity and scale keyframes', () {
    final document = jsonDecode(File('assets/lotties/pulse.json').readAsStringSync()) as Map<String, Object?>;
    final layers = document['layers']! as List<Object?>;
    final layer = layers.single! as Map<String, Object?>;
    final transform = layer['ks']! as Map<String, Object?>;
    final opacity = transform['o']! as Map<String, Object?>;
    final scale = transform['s']! as Map<String, Object?>;
    final opacityKeyframes = opacity['k']! as List<Object?>;
    final scaleKeyframes = scale['k']! as List<Object?>;
    final opacityStart = opacityKeyframes.first! as Map<String, Object?>;
    final opacityPeak = opacityKeyframes[1]! as Map<String, Object?>;
    final scaleStart = scaleKeyframes.first! as Map<String, Object?>;
    final scalePeak = scaleKeyframes[1]! as Map<String, Object?>;

    expect((
      opacity['a'],
      scale['a'],
      (opacityStart['s']! as List<Object?>).first,
      (opacityPeak['s']! as List<Object?>).first,
      (scaleStart['s']! as List<Object?>).first,
      (scalePeak['s']! as List<Object?>).first,
    ), equals((1, 1, 55, 100, 75, 110)));
  });
}
