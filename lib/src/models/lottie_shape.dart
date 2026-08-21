import 'lottie_animated_scalar.dart';
import 'lottie_shape_enums.dart';

/// A shape item inside a Lottie shape group.
///
/// Each variant maps to a Lottie shape type (`ty`):
/// - `sh` → [LottiePath]
/// - `rc` → [LottieRect]
/// - `el` → [LottieEllipse]
/// - `fl` → [LottieFill]
/// - `st` → [LottieStroke]
/// - `tm` → [LottieTrimPath]
/// - `tr` → [LottieGroupTransform]
/// - `gr` → [LottieGroup]
sealed class LottieShape {
  const LottieShape();
}

/// A bezier path shape (`ty: "sh"`).
class LottiePath extends LottieShape {
  const LottiePath({
    required this.vertices,
    required this.inTangents,
    required this.outTangents,
    required this.closed,
    this.direction = 1,
  });

  /// Vertex positions, each as `[x, y]`.
  final List<List<double>> vertices;

  /// Incoming tangent handles, each as `[x, y]`.
  final List<List<double>> inTangents;

  /// Outgoing tangent handles, each as `[x, y]`.
  final List<List<double>> outTangents;

  /// Whether the path is closed (`c: true`).
  final bool closed;

  /// Drawing direction: 1 = normal, 3 = reversed.
  final int direction;
}

/// A rounded rectangle shape (`ty: "rc"`).
class LottieRect extends LottieShape {
  const LottieRect({
    required this.positionX,
    required this.positionY,
    required this.width,
    required this.height,
    required this.cornerRadius,
    this.direction = 1,
  });

  /// Center X.
  final double positionX;

  /// Center Y.
  final double positionY;

  /// Total width.
  final double width;

  /// Total height.
  final double height;

  /// Corner radius.
  final double cornerRadius;

  /// Drawing direction: 1 = clockwise, 3 = counter-clockwise.
  final int direction;
}

/// An ellipse shape (`ty: "el"`).
class LottieEllipse extends LottieShape {
  const LottieEllipse({
    required this.positionX,
    required this.positionY,
    required this.width,
    required this.height,
    this.direction = 1,
  });

  /// Center X.
  final double positionX;

  /// Center Y.
  final double positionY;

  /// Total width.
  final double width;

  /// Total height.
  final double height;

  /// Drawing direction: 1 = clockwise, 3 = counter-clockwise.
  final int direction;
}

/// A solid fill (`ty: "fl"`).
class LottieFill extends LottieShape {
  const LottieFill({
    required this.colorR,
    required this.colorG,
    required this.colorB,
    required this.colorA,
    required this.opacity,
    this.fillRule = 1,
  });

  /// Red component (0.0–1.0).
  final double colorR;

  /// Green component (0.0–1.0).
  final double colorG;

  /// Blue component (0.0–1.0).
  final double colorB;

  /// Alpha component (0.0–1.0).
  final double colorA;

  /// Opacity (0–100).
  final double opacity;

  /// Fill rule: 1 = non-zero, 2 = even-odd.
  final int fillRule;
}

/// A solid stroke (`ty: "st"`).
class LottieStroke extends LottieShape {
  const LottieStroke({
    required this.colorR,
    required this.colorG,
    required this.colorB,
    required this.colorA,
    required this.opacity,
    required this.width,
    this.lineCap = 1,
    this.lineJoin = 1,
  });

  /// Red component (0.0–1.0).
  final double colorR;

  /// Green component (0.0–1.0).
  final double colorG;

  /// Blue component (0.0–1.0).
  final double colorB;

  /// Alpha component (0.0–1.0).
  final double colorA;

  /// Opacity (0–100).
  final double opacity;

  /// Stroke width.
  final double width;

  /// Line cap: 1 = butt, 2 = round, 3 = square.
  final int lineCap;

  /// Line join: 1 = miter, 2 = round, 3 = bevel.
  final int lineJoin;
}

/// A trim-path modifier (`ty: "tm"`).
class LottieTrimPath extends LottieShape {
  const LottieTrimPath({required this.start, required this.end, required this.offset, required this.mode});

  /// Visible segment start as a percentage from 0 to 100.
  final LottieAnimatedScalar start;

  /// Visible segment end as a percentage from 0 to 100.
  final LottieAnimatedScalar end;

  /// Cyclic path offset in degrees, where 360 is one complete path length.
  final LottieAnimatedScalar offset;

  /// How this modifier treats multiple shapes in its group.
  final LottieTrimPathMode mode;
}

/// A group transform (`ty: "tr"`) inside a shape group.
class LottieGroupTransform extends LottieShape {
  const LottieGroupTransform({
    this.positionX = 0,
    this.positionY = 0,
    this.anchorX = 0,
    this.anchorY = 0,
    this.scaleX = 100,
    this.scaleY = 100,
    this.rotation = 0,
    this.opacity = 100,
  });

  final double positionX;
  final double positionY;
  final double anchorX;
  final double anchorY;
  final double scaleX;
  final double scaleY;
  final double rotation;
  final double opacity;
}

/// A shape group (`ty: "gr"`) containing nested items.
class LottieGroup extends LottieShape {
  const LottieGroup({required this.name, required this.items});

  /// Group name (Lottie `nm`).
  final String name;

  /// Child shapes, fills, strokes, and transforms.
  final List<LottieShape> items;
}
