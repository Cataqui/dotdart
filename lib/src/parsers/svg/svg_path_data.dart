import '../../models/svg_element.dart';
import '../lottie_parser.dart' show DotdartUnsupportedFeatureException;

/// Parses SVG path `d` attribute values into absolute [SvgPathCommand]s.
///
/// All relative commands (lowercase) are resolved to absolute coordinates
/// at parse time. Smooth cubic (`S`/`s`) and smooth quad (`T`/`t`) commands
/// are resolved to explicit control points. Arc commands (`A`/`a`) are not
/// yet supported and throw [DotdartUnsupportedFeatureException].
class SvgPathData {
  static List<SvgPathCommand> parse(String d) {
    final commands = <SvgPathCommand>[];
    final p = _PathTokenizer(d);
    var curX = 0.0;
    var curY = 0.0;
    var startX = 0.0;
    var startY = 0.0;
    var prevControlX = 0.0;
    var prevControlY = 0.0;
    var lastCmd = '';

    while (true) {
      final cmd = p.readCommand();
      if (cmd == null) break;

      final isRelative = cmd != cmd.toUpperCase();
      final cmdUpper = cmd.toUpperCase();

      while (true) {
        switch (cmdUpper) {
          case 'M': {
            final coords = p.readCoordPair(relative: isRelative, curX: curX, curY: curY);
            if (coords == null) break;
            final (cx, cy) = coords;
            commands.add(SvgMoveTo(x: cx, y: cy));
            startX = cx; startY = cy; curX = cx; curY = cy;
            prevControlX = cx; prevControlY = cy;
            lastCmd = 'M';

            var next = p.peekNumber();
            while (next != null) {
              final l = p.readCoordPair(relative: isRelative, curX: curX, curY: curY);
              if (l == null) break;
              final (lx, ly) = l;
              commands.add(SvgLineTo(x: lx, y: ly));
              curX = lx; curY = ly;
              prevControlX = lx; prevControlY = ly;
              lastCmd = 'L';
              next = p.peekNumber();
            }
            break;
          }
          case 'L': {
            final coords = p.readCoordPair(relative: isRelative, curX: curX, curY: curY);
            if (coords == null) break;
            final (cx, cy) = coords;
            commands.add(SvgLineTo(x: cx, y: cy));
            curX = cx; curY = cy;
            prevControlX = cx; prevControlY = cy;
            lastCmd = 'L';
            break;
          }
          case 'H': {
            final x = p.readNumber();
            if (x == null) break;
            final cx = isRelative ? curX + x : x;
            commands.add(SvgLineTo(x: cx, y: curY));
            curX = cx;
            prevControlX = cx;
            lastCmd = 'L';
            break;
          }
          case 'V': {
            final y = p.readNumber();
            if (y == null) break;
            final cy = isRelative ? curY + y : y;
            commands.add(SvgLineTo(x: curX, y: cy));
            curY = cy;
            prevControlY = cy;
            lastCmd = 'L';
            break;
          }
          case 'C': {
            final x1 = p.readNumber();
            final y1 = p.readNumber();
            final x2 = p.readNumber();
            final y2 = p.readNumber();
            final x = p.readNumber();
            final y = p.readNumber();
            if (x == null || y == null || x1 == null || y1 == null || x2 == null || y2 == null) break;
            final cx1 = isRelative ? curX + x1 : x1;
            final cy1 = isRelative ? curY + y1 : y1;
            final cx2 = isRelative ? curX + x2 : x2;
            final cy2 = isRelative ? curY + y2 : y2;
            final cx = isRelative ? curX + x : x;
            final cy = isRelative ? curY + y : y;
            commands.add(SvgCubicTo(x1: cx1, y1: cy1, x2: cx2, y2: cy2, x: cx, y: cy));
            prevControlX = cx2; prevControlY = cy2;
            curX = cx; curY = cy;
            lastCmd = 'C';
            break;
          }
          case 'S': {
            final x2 = p.readNumber();
            final y2 = p.readNumber();
            final x = p.readNumber();
            final y = p.readNumber();
            if (x == null || y == null || x2 == null || y2 == null) break;
            double cx1;
            double cy1;
            if (lastCmd == 'C' || lastCmd == 'S') {
              cx1 = curX + (curX - prevControlX);
              cy1 = curY + (curY - prevControlY);
            } else {
              cx1 = curX; cy1 = curY;
            }
            final cx2 = isRelative ? curX + x2 : x2;
            final cy2 = isRelative ? curY + y2 : y2;
            final cx = isRelative ? curX + x : x;
            final cy = isRelative ? curY + y : y;
            commands.add(SvgCubicTo(x1: cx1, y1: cy1, x2: cx2, y2: cy2, x: cx, y: cy));
            prevControlX = cx2; prevControlY = cy2;
            curX = cx; curY = cy;
            lastCmd = 'C';
            break;
          }
          case 'Q': {
            final x1 = p.readNumber();
            final y1 = p.readNumber();
            final x = p.readNumber();
            final y = p.readNumber();
            if (x == null || y == null || x1 == null || y1 == null) break;
            final cx1 = isRelative ? curX + x1 : x1;
            final cy1 = isRelative ? curY + y1 : y1;
            final cx = isRelative ? curX + x : x;
            final cy = isRelative ? curY + y : y;
            commands.add(SvgQuadTo(x1: cx1, y1: cy1, x: cx, y: cy));
            prevControlX = cx1; prevControlY = cy1;
            curX = cx; curY = cy;
            lastCmd = 'Q';
            break;
          }
          case 'T': {
            final x = p.readNumber();
            final y = p.readNumber();
            if (x == null || y == null) break;
            double cx1;
            double cy1;
            if (lastCmd == 'Q' || lastCmd == 'T') {
              cx1 = curX + (curX - prevControlX);
              cy1 = curY + (curY - prevControlY);
            } else {
              cx1 = curX; cy1 = curY;
            }
            final cx = isRelative ? curX + x : x;
            final cy = isRelative ? curY + y : y;
            commands.add(SvgQuadTo(x1: cx1, y1: cy1, x: cx, y: cy));
            prevControlX = cx1; prevControlY = cy1;
            curX = cx; curY = cy;
            lastCmd = 'Q';
            break;
          }
          case 'A': {
            throw const DotdartUnsupportedFeatureException(
              'Arc commands (A/a) are not yet supported. '
              'None of the current icons use arcs. '
              'Open an issue at https://github.com/cataqui/mobile/issues to request arc support.',
            );
          }
          case 'Z': {
            commands.add(const SvgClosePath());
            curX = startX; curY = startY;
            prevControlX = startX; prevControlY = startY;
            lastCmd = 'Z';
            break;
          }
        }

        if (cmdUpper != 'Z' && cmdUpper != 'M') {
          final next = p.peekNumber();
          if (next != null) continue;
        }
        break;
      }
    }

    return commands;
  }
}

class _PathTokenizer {
  _PathTokenizer(this.input);
  final String input;
  int _pos = 0;

  void _skip() {
    while (_pos < input.length &&
        (input[_pos] == ' ' || input[_pos] == ',' || input[_pos] == '\t' || input[_pos] == '\n' || input[_pos] == '\r')) {
      _pos++;
    }
  }

  String? readCommand() {
    _skip();
    if (_pos >= input.length) return null;
    final ch = input[_pos];
    if ((ch.codeUnitAt(0) >= 65 && ch.codeUnitAt(0) <= 90) || (ch.codeUnitAt(0) >= 97 && ch.codeUnitAt(0) <= 122)) {
      _pos++;
      return ch;
    }
    return null;
  }

  double? readNumber() {
    _skip();
    if (_pos >= input.length) return null;
    final ch = input[_pos];
    if (!((ch.codeUnitAt(0) >= 48 && ch.codeUnitAt(0) <= 57) || ch == '.' || ch == '+' || ch == '-')) return null;

    final start = _pos;
    if (_pos < input.length && (input[_pos] == '+' || input[_pos] == '-')) {
      _pos++;
    }
    while (_pos < input.length && input[_pos].codeUnitAt(0) >= 48 && input[_pos].codeUnitAt(0) <= 57) {
      _pos++;
    }
    if (_pos < input.length && input[_pos] == '.') {
      _pos++;
      while (_pos < input.length && input[_pos].codeUnitAt(0) >= 48 && input[_pos].codeUnitAt(0) <= 57) {
        _pos++;
      }
    }
    if (_pos < input.length && (input[_pos] == 'e' || input[_pos] == 'E')) {
      _pos++;
      if (_pos < input.length && (input[_pos] == '+' || input[_pos] == '-')) {
        _pos++;
      }
      while (_pos < input.length && input[_pos].codeUnitAt(0) >= 48 && input[_pos].codeUnitAt(0) <= 57) {
        _pos++;
      }
    }
    return double.parse(input.substring(start, _pos));
  }

  double? peekNumber() {
    final saved = _pos;
    final result = readNumber();
    _pos = saved;
    return result;
  }

  (double, double)? readCoordPair({required bool relative, required double curX, required double curY}) {
    final x = readNumber();
    if (x == null) return null;
    final y = readNumber();
    if (y == null) return null;
    return (relative ? curX + x : x, relative ? curY + y : y);
  }
}
