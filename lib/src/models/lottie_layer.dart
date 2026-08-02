import 'lottie_keyframe.dart';
import 'lottie_shape.dart';
import 'lottie_text.dart';

/// A single layer in a Lottie animation.
///
class LottieLayer {
  const LottieLayer({
    required this.name,
    required this.shapeGroups,
    this.layerIndex,
    this.parentIndex,
    this.referenceId,
    this.text,
    this.masks = const [],
    this.opacity,
    this.rotation,
    this.positionX,
    this.positionY,
    this.anchorX,
    this.anchorY,
    this.scaleX,
    this.scaleY,
    this.inPoint = 0,
    this.outPoint = 0,
    this.startTime = 0,
    this.stretch = 1,
  });

  /// Layer name (Lottie `nm`).
  final String name;

  /// Shape groups in this layer.
  final List<LottieGroup> shapeGroups;

  /// Layer index used by Lottie parent references (`ind`).
  final int? layerIndex;

  /// Index of the layer whose transform is inherited (`parent`).
  final int? parentIndex;

  /// Referenced composition for a precomposition layer (`ty: 0`).
  final String? referenceId;

  /// Text content for a text layer (`ty: 5`).
  final LottieText? text;

  /// Static additive masks applied before this layer is painted.
  final List<LottiePath> masks;

  /// Opacity (0–100). `null` means 100 (fully opaque).
  final LottieAnimatedScalar? opacity;

  /// Rotation in degrees. `null` means 0.
  final LottieAnimatedScalar? rotation;

  /// Position X. `null` means 0.
  final LottieAnimatedScalar? positionX;

  /// Position Y. `null` means 0.
  final LottieAnimatedScalar? positionY;

  /// Anchor point X. `null` means 0.
  final double? anchorX;

  /// Anchor point Y. `null` means 0.
  final double? anchorY;

  /// Scale X (0–100). `null` means 100.
  final LottieAnimatedScalar? scaleX;

  /// Scale Y (0–100). `null` means 100.
  final LottieAnimatedScalar? scaleY;

  /// In-point frame (Lottie `ip`).
  final int inPoint;

  /// Out-point frame (Lottie `op`).
  final int outPoint;

  /// Layer start time (`st`).
  final double startTime;

  /// Layer time stretch (`sr`).
  final double stretch;
}

/// An animated or static scalar value.
///
/// When [animated] is `false`, the value is [staticValue].
/// When [animated] is `true`, the value is interpolated from [keyframes].
class LottieAnimatedScalar {
  const LottieAnimatedScalar({required this.animated, this.staticValue = 0, this.keyframes = const []});

  /// Whether this property has keyframe animation.
  final bool animated;

  /// Static value used when [animated] is `false`.
  final double staticValue;

  /// Keyframes used when [animated] is `true`.
  final List<LottieScalarKeyframe> keyframes;
}
