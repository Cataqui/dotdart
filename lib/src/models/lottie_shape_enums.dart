/// How one trim-path modifier applies to multiple shapes in its group.
enum LottieTrimPathMode {
  /// Applies the same start and end percentages to every shape.
  parallel,

  /// Treats all shapes as one continuous sequence.
  sequential;

  /// Returns the mode represented by Lottie's `m` value.
  static LottieTrimPathMode? fromValue(int value) {
    return switch (value) {
      1 => parallel,
      2 => sequential,
      _ => null,
    };
  }
}
