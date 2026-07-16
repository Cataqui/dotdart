import '../../models/svg_document.dart';
import '../../models/svg_element.dart';
import '../../models/svg_style.dart';
import '../lottie_parser.dart' show DotdartUnsupportedFeatureException;
import 'svg_mini_xml.dart';
import 'svg_path_data.dart' show SvgPathData;
import 'svg_transform.dart' show SvgTransform;

/// Exception thrown when an SVG file is structurally invalid or malformed.
class DotdartInvalidSvgException implements FormatException {
  const DotdartInvalidSvgException(this.message);
  @override final String message;
  @override int? get offset => null;
  @override Object? get source => null;
  @override String toString() => 'DotdartInvalidSvgException: $message';
}

/// Result of parsing an SVG XML string.
class SvgParseResult {
  const SvgParseResult({required this.document, this.warnings = const []});
  final SvgDocument document;
  final List<String> warnings;
}

/// Parses SVG XML into a [SvgDocument] model.
///
/// Throws [DotdartUnsupportedFeatureException] for unsupported SVG features
/// (gradients, text, filters, etc.) and [DotdartInvalidSvgException] for
/// malformed SVG files.
class SvgParser {
  SvgParser._();
  final List<String> _warnings = [];

  static SvgParseResult parse(String svgXml) {
    final parser = SvgParser._();
    return parser._parse(svgXml);
  }

  SvgParseResult _parse(String svgXml) {
    XElement root;
    try {
      root = XParser.parse(svgXml);
    } on FormatException catch (e) {
      throw DotdartInvalidSvgException('Failed to parse SVG XML: ${e.message}');
    }

    if (root.tag != 'svg') {
      throw const DotdartInvalidSvgException('Root element must be <svg>.');
    }

    final viewBox = _parseViewBox(root);
    final width = _parseLength(root.attrs['width']);
    final height = _parseLength(root.attrs['height']);

    final rootStyle = _resolveStyle(root, _defaultStyle);
    final children = _parseChildren(root, rootStyle);

    return SvgParseResult(
      document: SvgDocument(
        viewBox: viewBox,
        width: width,
        height: height,
        children: children,
      ),
      warnings: List.unmodifiable(_warnings),
    );
  }

  SvgViewBox _parseViewBox(XElement svg) {
    final vb = svg.attrs['viewBox'];
    if (vb != null) {
      final parts = vb.trim().split(RegExp(r'[\s,]+'));
      if (parts.length >= 4) {
        final minX = double.tryParse(parts[0]) ?? 0;
        final minY = double.tryParse(parts[1]) ?? 0;
        final w = double.tryParse(parts[2]) ?? 0;
        final h = double.tryParse(parts[3]) ?? 0;
        if (w <= 0 || h <= 0) {
          throw const DotdartInvalidSvgException('viewBox must have positive width and height.');
        }
        return SvgViewBox(minX: minX, minY: minY, width: w, height: h);
      }
    }

    final w = _parseLength(svg.attrs['width']) ?? 300;
    final h = _parseLength(svg.attrs['height']) ?? 150;
    return SvgViewBox(minX: 0, minY: 0, width: w, height: h);
  }

  List<SvgElement> _parseChildren(XElement parent, [SvgStyle? inherited]) {
    final children = <SvgElement>[];
    for (final node in parent.children) {
      final element = _parseNode(node, inherited ?? _defaultStyle);
      if (element != null) children.add(element);
    }
    return children;
  }

  SvgElement? _parseNode(XElement element, SvgStyle inherited) {
    switch (element.tag) {
      case 'g':
        return _parseGroup(element, inherited);
      case 'path':
        return _parsePath(element, inherited);
      case 'rect':
        return _parseRect(element, inherited);
      case 'circle':
        return _parseCircle(element, inherited);
      case 'ellipse':
        return _parseEllipse(element, inherited);
      case 'line':
        return _parseLine(element, inherited);
      case 'polyline':
        return _parsePolyline(element, inherited);
      case 'polygon':
        return _parsePolygon(element, inherited);
      case 'linearGradient':
      case 'radialGradient':
        throw const DotdartUnsupportedFeatureException('Gradients are not supported.');
      case 'use':
      case 'symbol':
      case 'defs':
        throw DotdartUnsupportedFeatureException('<${element.tag}> references are not supported. Inline all shapes directly.');
      case 'text':
      case 'tspan':
        throw const DotdartUnsupportedFeatureException('Text elements are not supported.');
      case 'image':
        throw const DotdartUnsupportedFeatureException('Embedded images are not supported.');
      case 'style':
        throw const DotdartUnsupportedFeatureException('CSS <style> blocks are not supported. Use presentation attributes only.');
      case 'filter':
      case 'mask':
      case 'clipPath':
      case 'pattern':
        throw const DotdartUnsupportedFeatureException('Filters, masks, clip-paths, and patterns are not supported.');
      case 'title':
      case 'desc':
      case 'metadata':
      case 'stop':
        return null;
      default:
        _warnings.add('Skipping unknown element "<${element.tag}>".');
        return null;
    }
  }

  SvgGroup _parseGroup(XElement element, SvgStyle inherited) {
    final style = _resolveStyle(element, inherited);
    final transform = _parseTransform(element);
    final children = _parseChildren(element, style);
    return SvgGroup(style: style, transform: transform, children: children);
  }

  SvgPath _parsePath(XElement element, SvgStyle inherited) {
    final d = element.attrs['d'];
    if (d == null || d.trim().isEmpty) {
      throw const DotdartInvalidSvgException('<path> element is missing a "d" attribute.');
    }
    final commands = SvgPathData.parse(d);
    final style = _resolveStyle(element, inherited);
    return SvgPath(style: style, commands: commands);
  }

  SvgRect _parseRect(XElement element, SvgStyle inherited) {
    final x = _parseLength(element.attrs['x']) ?? 0;
    final y = _parseLength(element.attrs['y']) ?? 0;
    final width = _parseLength(element.attrs['width']);
    final height = _parseLength(element.attrs['height']);
    if (width == null || height == null || width <= 0 || height <= 0) {
      throw const DotdartInvalidSvgException('<rect> requires positive width and height.');
    }
    final rx = _parseLength(element.attrs['rx']) ?? 0;
    final ry = _parseLength(element.attrs['ry']) ?? rx;
    final style = _resolveStyle(element, inherited);
    return SvgRect(style: style, x: x, y: y, width: width, height: height, rx: rx, ry: ry);
  }

  SvgCircle _parseCircle(XElement element, SvgStyle inherited) {
    final cx = _parseLength(element.attrs['cx']) ?? 0;
    final cy = _parseLength(element.attrs['cy']) ?? 0;
    final r = _parseLength(element.attrs['r']);
    if (r == null || r <= 0) throw const DotdartInvalidSvgException('<circle> requires positive r.');
    final style = _resolveStyle(element, inherited);
    return SvgCircle(style: style, cx: cx, cy: cy, r: r);
  }

  SvgEllipse _parseEllipse(XElement element, SvgStyle inherited) {
    final cx = _parseLength(element.attrs['cx']) ?? 0;
    final cy = _parseLength(element.attrs['cy']) ?? 0;
    final rx = _parseLength(element.attrs['rx']);
    final ry = _parseLength(element.attrs['ry']);
    if (rx == null || ry == null || rx <= 0 || ry <= 0) {
      throw const DotdartInvalidSvgException('<ellipse> requires positive rx and ry.');
    }
    final style = _resolveStyle(element, inherited);
    return SvgEllipse(style: style, cx: cx, cy: cy, rx: rx, ry: ry);
  }

  SvgLine _parseLine(XElement element, SvgStyle inherited) {
    final x1 = _parseLength(element.attrs['x1']) ?? 0;
    final y1 = _parseLength(element.attrs['y1']) ?? 0;
    final x2 = _parseLength(element.attrs['x2']) ?? 0;
    final y2 = _parseLength(element.attrs['y2']) ?? 0;
    final lineStyle = SvgStyle(fillColor: null, strokeColor: inherited.strokeColor, strokeOpacity: inherited.strokeOpacity, strokeWidth: inherited.strokeWidth, strokeLineCap: inherited.strokeLineCap, strokeLineJoin: inherited.strokeLineJoin, fillRule: inherited.fillRule, opacity: inherited.opacity, fillOpacity: inherited.fillOpacity);
    final style = _resolveStyle(element, lineStyle);
    return SvgLine(style: style, x1: x1, y1: y1, x2: x2, y2: y2);
  }

  SvgPolyline _parsePolyline(XElement element, SvgStyle inherited) {
    final points = _parsePoints(element.attrs['points']);
    if (points.isEmpty) throw const DotdartInvalidSvgException('<polyline> requires a "points" attribute.');
    final style = _resolveStyle(element, inherited);
    return SvgPolyline(style: style, points: points);
  }

  SvgPolygon _parsePolygon(XElement element, SvgStyle inherited) {
    final points = _parsePoints(element.attrs['points']);
    if (points.isEmpty) throw const DotdartInvalidSvgException('<polygon> requires a "points" attribute.');
    final style = _resolveStyle(element, inherited);
    return SvgPolygon(style: style, points: points);
  }

  static const _defaultStyle = SvgStyle(
    fillColor: (0, 0, 0, 1),
    fillOpacity: 1,
    fillRule: SvgFillRule.nonzero,
    strokeColor: null,
    strokeOpacity: 1,
    strokeWidth: 1,
    strokeLineCap: SvgStrokeLineCap.butt,
    strokeLineJoin: SvgStrokeLineJoin.miter,
    opacity: 1,
  );

  SvgStyle _resolveStyle(XElement element, SvgStyle inherited) {
    final fillRaw = element.attrs['fill'];
    final fillColor = fillRaw != null ? _parseColor(fillRaw) : _inheritColor;
    final strokeRaw = element.attrs['stroke'];
    final strokeColor = strokeRaw != null ? _parseColor(strokeRaw) : _inheritColor;

    return SvgStyle(
      fillColor: fillColor is _ConcreteColor ? fillColor.value : fillColor is _NoneColor ? null : inherited.fillColor,
      fillOpacity: _parseOptionalOpacity(element.attrs['fill-opacity']) ?? inherited.fillOpacity,
      fillRule: _parseFillRule(element.attrs['fill-rule']) ?? inherited.fillRule,
      strokeColor: strokeColor is _ConcreteColor ? strokeColor.value : strokeColor is _NoneColor ? null : inherited.strokeColor,
      strokeOpacity: _parseOptionalOpacity(element.attrs['stroke-opacity']) ?? inherited.strokeOpacity,
      strokeWidth: _parseStrokeWidth(element) ?? inherited.strokeWidth,
      strokeLineCap: _parseLineCap(element.attrs['stroke-linecap']) ?? inherited.strokeLineCap,
      strokeLineJoin: _parseLineJoin(element.attrs['stroke-linejoin']) ?? inherited.strokeLineJoin,
      opacity: _parseOptionalOpacity(element.attrs['opacity']) ?? inherited.opacity,
    );
  }

  // ── Color parsing ──

  _ColorValue _parseColor(String? raw) {
    if (raw == null) return _inheritColor;
    final trimmed = raw.trim();
    if (trimmed == 'none' || trimmed == 'transparent') return _noneColor;
    if (trimmed == 'currentColor') return const _ConcreteColor((0, 0, 0, 1));
    final named = _namedColor(trimmed);
    if (named != null) return _ConcreteColor(named);
    if (trimmed.startsWith('#')) return _parseHexColor(trimmed);
    if (trimmed.startsWith('rgb')) return _parseRgbColor(trimmed);
    return _inheritColor;
  }

  _ColorValue _parseHexColor(String raw) {
    final hex = raw.substring(1);
    if (hex.length == 3) {
      final r = int.parse(hex[0] + hex[0], radix: 16);
      final g = int.parse(hex[1] + hex[1], radix: 16);
      final b = int.parse(hex[2] + hex[2], radix: 16);
      return _ConcreteColor(_toColor(r, g, b, 255));
    }
    if (hex.length == 4) {
      final r = int.parse(hex[0] + hex[0], radix: 16);
      final g = int.parse(hex[1] + hex[1], radix: 16);
      final b = int.parse(hex[2] + hex[2], radix: 16);
      final a = int.parse(hex[3] + hex[3], radix: 16);
      return _ConcreteColor(_toColor(r, g, b, a));
    }
    if (hex.length == 6) {
      final r = int.parse(hex.substring(0, 2), radix: 16);
      final g = int.parse(hex.substring(2, 4), radix: 16);
      final b = int.parse(hex.substring(4, 6), radix: 16);
      return _ConcreteColor(_toColor(r, g, b, 255));
    }
    if (hex.length == 8) {
      final r = int.parse(hex.substring(0, 2), radix: 16);
      final g = int.parse(hex.substring(2, 4), radix: 16);
      final b = int.parse(hex.substring(4, 6), radix: 16);
      final a = int.parse(hex.substring(6, 8), radix: 16);
      return _ConcreteColor(_toColor(r, g, b, a));
    }
    return _inheritColor;
  }

  _ColorValue _parseRgbColor(String raw) {
    final inner = raw.substring(raw.indexOf('(') + 1, raw.lastIndexOf(')')).trim();
    final parts = inner.split(RegExp(r'[\s,]+'));
    if (parts.length < 3) return _ConcreteColor(_toColor(0, 0, 0, 255));
    int parseComponent(String s) {
      if (s.endsWith('%')) return ((double.parse(s.substring(0, s.length - 1)) / 100) * 255).round().clamp(0, 255);
      return int.tryParse(s) ?? 0;
    }
    final r = parseComponent(parts[0]);
    final g = parseComponent(parts[1]);
    final b = parseComponent(parts[2]);
    var a = 255;
    if (parts.length > 3) {
      final alphaStr = parts[3];
      if (alphaStr.endsWith('%')) {
        a = ((double.parse(alphaStr.substring(0, alphaStr.length - 1)) / 100) * 255).round().clamp(0, 255);
      } else {
        a = (double.parse(alphaStr) * 255).round().clamp(0, 255);
      }
    }
    return _ConcreteColor(_toColor(r, g, b, a));
  }

  (double, double, double, double) _toColor(int r, int g, int b, int a) => (r / 255, g / 255, b / 255, a / 255);

  (double, double, double, double)? _namedColor(String name) => _namedColors[name.toLowerCase()];

  static const _namedColors = <String, (double, double, double, double)>{
    'black': (0, 0, 0, 1), 'white': (1, 1, 1, 1), 'red': (1, 0, 0, 1),
    'green': (0, 0.50196078, 0, 1), 'blue': (0, 0, 1, 1), 'yellow': (1, 1, 0, 1),
    'gray': (0.50196078, 0.50196078, 0.50196078, 1), 'grey': (0.50196078, 0.50196078, 0.50196078, 1),
    'silver': (0.75294118, 0.75294118, 0.75294118, 1), 'maroon': (0.50196078, 0, 0, 1),
    'purple': (0.50196078, 0, 0.50196078, 1), 'fuchsia': (1, 0, 1, 1),
    'lime': (0, 1, 0, 1), 'olive': (0.50196078, 0.50196078, 0, 1),
    'navy': (0, 0, 0.50196078, 1), 'teal': (0, 0.50196078, 0.50196078, 1),
    'aqua': (0, 1, 1, 1), 'orange': (1, 0.64705882, 0, 1),
    'pink': (1, 0.75294118, 0.79607843, 1),
  };

  double? _parseOptionalOpacity(String? raw) {
    if (raw == null) return null;
    final trimmed = raw.trim();
    if (trimmed.endsWith('%')) {
      final value = double.tryParse(trimmed.substring(0, trimmed.length - 1))?.clamp(0, 100) ?? 0;
      return value / 100;
    }
    return double.tryParse(trimmed)?.clamp(0, 1);
  }

  SvgFillRule? _parseFillRule(String? raw) {
    if (raw == null) return null;
    return switch (raw.trim()) { 'evenodd' => SvgFillRule.evenodd, _ => SvgFillRule.nonzero, };
  }

  SvgStrokeLineCap? _parseLineCap(String? raw) {
    if (raw == null) return null;
    return switch (raw.trim()) { 'round' => SvgStrokeLineCap.round, 'square' => SvgStrokeLineCap.square, _ => SvgStrokeLineCap.butt, };
  }

  SvgStrokeLineJoin? _parseLineJoin(String? raw) {
    if (raw == null) return null;
    return switch (raw.trim()) { 'round' => SvgStrokeLineJoin.round, 'bevel' => SvgStrokeLineJoin.bevel, _ => SvgStrokeLineJoin.miter, };
  }

  double? _parseStrokeWidth(XElement element) {
    final raw = element.attrs['stroke-width'];
    if (raw == null) return null;
    return _parseLength(raw) ?? double.tryParse(raw.trim());
  }

  List<SvgTransformOp>? _parseTransform(XElement element) {
    final raw = element.attrs['transform'];
    if (raw == null || raw.trim().isEmpty) return null;
    return SvgTransform.parse(raw);
  }

  double? _parseLength(String? raw) {
    if (raw == null) return null;
    final trimmed = raw.trim();
    final match = RegExp(r'^([+-]?\d+(?:\.\d+)?)').firstMatch(trimmed);
    return match != null ? double.tryParse(match.group(1)!) : null;
  }

  List<(double, double)> _parsePoints(String? raw) {
    if (raw == null || raw.trim().isEmpty) return [];
    final tokens = raw.trim().split(RegExp(r'[\s,]+'));
    final points = <(double, double)>[];
    for (var i = 0; i + 1 < tokens.length; i += 2) {
      final x = double.tryParse(tokens[i]);
      final y = double.tryParse(tokens[i + 1]);
      if (x != null && y != null) points.add((x, y));
    }
    return points;
  }
}

/// Internal tri-state color value used during style resolution.
sealed class _ColorValue {
  const _ColorValue();
}

/// Explicitly set to `"none"` — no paint.
final class _NoneColor extends _ColorValue {
  const _NoneColor();
}

/// A concrete RGBA color value.
final class _ConcreteColor extends _ColorValue {
  const _ConcreteColor(this.value);
  final (double, double, double, double) value;
}

/// Not specified — inherit from parent.
final class _InheritColor extends _ColorValue {
  const _InheritColor();
}

const _noneColor = _NoneColor();
const _inheritColor = _InheritColor();
