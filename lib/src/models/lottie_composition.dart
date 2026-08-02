import 'lottie_layer.dart';

/// A reusable Lottie precomposition referenced by animation layers.
class LottieComposition {
  const LottieComposition({
    required this.id,
    required this.width,
    required this.height,
    required this.layers,
  });

  /// Identifier referenced by a precomposition layer (`refId`).
  final String id;

  /// Composition width in pixels.
  final int width;

  /// Composition height in pixels.
  final int height;

  /// Layers in rendering order (top to bottom in the Lottie source).
  final List<LottieLayer> layers;
}
