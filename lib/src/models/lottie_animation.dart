import 'lottie_layer.dart';

/// A parsed Lottie animation ready for code generation.
class LottieAnimation {
  const LottieAnimation({
    required this.width,
    required this.height,
    required this.frameRate,
    required this.inPoint,
    required this.outPoint,
    required this.name,
    required this.layers,
  });

  /// Canvas width in pixels (Lottie `w`).
  final int width;

  /// Canvas height in pixels (Lottie `h`).
  final int height;

  /// Frame rate (Lottie `fr`).
  final double frameRate;

  /// In-point frame (Lottie `ip`).
  final int inPoint;

  /// Out-point frame (Lottie `op`).
  final int outPoint;

  /// Animation name (Lottie `nm`).
  final String name;

  /// Layers in rendering order (bottom to top).
  final List<LottieLayer> layers;

  /// Total duration in milliseconds.
  int get durationMs => ((outPoint - inPoint) / frameRate * 1000).round();

  /// Total number of frames.
  int get totalFrames => outPoint - inPoint;
}
