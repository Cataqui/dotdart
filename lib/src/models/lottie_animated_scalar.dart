import 'lottie_keyframe.dart';

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
