/// Static text content and styling from a Lottie text layer (`ty: 5`).
class LottieText {
  const LottieText({
    required this.value,
    required this.fontFamily,
    required this.fontWeight,
    required this.italic,
    required this.fontSize,
    required this.lineHeight,
    required this.tracking,
    required this.justification,
    required this.colorR,
    required this.colorG,
    required this.colorB,
    required this.colorA,
    this.boxWidth,
    this.boxHeight,
  });

  /// Text stored in the Lottie document.
  final String value;

  /// Font family declared by the Lottie font table.
  final String fontFamily;

  /// Numeric font weight, such as 500 or 600.
  final int fontWeight;

  /// Whether the source font style is italic.
  final bool italic;

  /// Font size in logical pixels.
  final double fontSize;

  /// Line height in logical pixels.
  final double lineHeight;

  /// Lottie tracking value in thousandths of an em.
  final double tracking;

  /// Text justification: 0 left, 1 right, or 2 center.
  final int justification;

  /// Red component (0.0-1.0).
  final double colorR;

  /// Green component (0.0-1.0).
  final double colorG;

  /// Blue component (0.0-1.0).
  final double colorB;

  /// Alpha component (0.0-1.0).
  final double colorA;

  /// Optional paragraph box width.
  final double? boxWidth;

  /// Optional paragraph box height.
  final double? boxHeight;
}
