/// A single keyframe in a Lottie animation for a scalar property.
///
/// Represents one entry in a Lottie `k` array for animated properties
/// (`a: 1`). Maps the Lottie keyframe fields (`t`, `s`, `e`, `o`, `i`, `h`)
/// to a typed model that the code generator can emit as Dart code.
class LottieScalarKeyframe {
  const LottieScalarKeyframe({
    required this.time,
    required this.start,
    this.end,
    this.outX,
    this.outY,
    this.inX,
    this.inY,
    this.hold = false,
  });

  /// Frame number at which this keyframe starts.
  final double time;

  /// Value at [time].
  final double start;

  /// Value at the next keyframe's time. `null` for hold keyframes.
  final double? end;

  /// Outgoing bezier handle X (Lottie `o.x`).
  final double? outX;

  /// Outgoing bezier handle Y (Lottie `o.y`).
  final double? outY;

  /// Incoming bezier handle X (Lottie `i.x`).
  final double? inX;

  /// Incoming bezier handle Y (Lottie `i.y`).
  final double? inY;

  /// Whether this is a hold keyframe (`h: 1` in Lottie).
  ///
  /// When `true`, the value stays at [start] until the next keyframe
  /// with no interpolation.
  final bool hold;
}
