import '../../models/svg_element.dart';
import '../lottie_parser.dart' show DotdartUnsupportedFeatureException;

/// Parses SVG `transform` attribute values into [SvgTransformOp]s.
///
/// Supports `translate()`, `scale()`, and `rotate()`. Throws
/// [DotdartUnsupportedFeatureException] for `matrix()`, `skewX()`, and
/// `skewY()` which would require `Matrix4` in generated code.
class SvgTransform {
  /// Parses a `transform="..."` value into an ordered list of operations.
  static List<SvgTransformOp> parse(String transform) {
    final ops = <SvgTransformOp>[];
    var i = 0;

    void skip() {
      while (i < transform.length &&
          (transform[i] == ' ' ||
              transform[i] == ',' ||
              transform[i] == '\t' ||
              transform[i] == '\n' ||
              transform[i] == '\r')) {
        i++;
      }
    }

    while (i < transform.length) {
      skip();
      if (i >= transform.length) break;

      // Read function name (letters only)
      final nameStart = i;
      while (i < transform.length &&
          ((transform[i].codeUnitAt(0) >= 65 && transform[i].codeUnitAt(0) <= 90) ||
              (transform[i].codeUnitAt(0) >= 97 && transform[i].codeUnitAt(0) <= 122))) {
        i++;
      }
      if (i == nameStart) break;
      final name = transform.substring(nameStart, i);

      skip();
      if (i < transform.length && transform[i] == '(') i++;

      // Read comma/space-separated numbers
      final args = <double>[];
      while (true) {
        skip();
        if (i >= transform.length || transform[i] == ')') break;
        final ch = transform[i];
        if (!((ch.codeUnitAt(0) >= 48 && ch.codeUnitAt(0) <= 57) || ch == '.' || ch == '+' || ch == '-')) break;

        final numStart = i;
        if (i < transform.length && (transform[i] == '+' || transform[i] == '-')) i++;
        while (i < transform.length && transform[i].codeUnitAt(0) >= 48 && transform[i].codeUnitAt(0) <= 57) {
          i++;
        }
        if (i < transform.length && transform[i] == '.') {
          i++;
          while (i < transform.length && transform[i].codeUnitAt(0) >= 48 && transform[i].codeUnitAt(0) <= 57) {
            i++;
          }
        }
        if (i < transform.length && (transform[i] == 'e' || transform[i] == 'E')) {
          i++;
          if (i < transform.length && (transform[i] == '+' || transform[i] == '-')) i++;
          while (i < transform.length && transform[i].codeUnitAt(0) >= 48 && transform[i].codeUnitAt(0) <= 57) {
            i++;
          }
        }
        args.add(double.parse(transform.substring(numStart, i)));
      }

      if (i < transform.length && transform[i] == ')') i++;

      switch (name) {
        case 'translate':
          ops.add(SvgTranslate(tx: args[0], ty: args.length > 1 ? args[1] : 0));
        case 'scale':
          ops.add(SvgScale(sx: args[0], sy: args.length > 1 ? args[1] : args[0]));
        case 'rotate':
          ops.add(
            SvgRotate(angle: args[0], cx: args.length > 2 ? args[1] : null, cy: args.length > 2 ? args[2] : null),
          );
        case 'matrix':
        case 'skewX':
        case 'skewY':
          throw const DotdartUnsupportedFeatureException(
            'matrix()/skewX()/skewY() transforms are not supported. Use translate/scale/rotate instead.',
          );
        default:
          throw DotdartUnsupportedFeatureException('Unknown SVG transform function "$name".');
      }
    }

    return ops;
  }
}
