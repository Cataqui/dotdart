import 'package:dotdart/src/models/lottie_composition.dart';
import 'package:dotdart/src/models/lottie_layer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LottieComposition', () {
    test('when creating a composition, it should retain its canvas and layers', () {
      const composition = LottieComposition(
        id: 'card',
        width: 291,
        height: 353,
        layers: [LottieLayer(name: 'Title', shapeGroups: [])],
      );

      expect(
        (composition.id, composition.width, composition.height, composition.layers.single.name),
        ('card', 291, 353, 'Title'),
      );
    });
  });
}
