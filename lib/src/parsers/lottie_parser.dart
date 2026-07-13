import 'dart:convert';

import '../models/lottie_animation.dart';
import '../models/lottie_keyframe.dart';
import '../models/lottie_layer.dart';
import '../models/lottie_shape.dart';

/// Exception thrown when the parser encounters an unsupported Lottie feature.
class DotdartUnsupportedFeatureException implements Exception {
  const DotdartUnsupportedFeatureException(this.message);

  /// Human-readable explanation of what is unsupported.
  final String message;

  @override
  String toString() => 'DotdartUnsupportedFeatureException: $message';
}

/// Parses a Lottie JSON string into a [LottieAnimation] model.
///
/// Throws [DotdartUnsupportedFeatureException] for features not yet supported.
class LottieParser {
  /// Parses [jsonString] as a Lottie animation.
  ///
  /// The JSON must have the standard Lottie top-level fields (`v`, `fr`, `w`,
  /// `h`, `layers`). Non-shape layers (`ty` other than 4) are skipped with a
  /// warning message returned in the result.
  static LottieParseResult parse(String jsonString) {
    final root = json.decode(jsonString) as Map<String, dynamic>;

    final warnings = <String>[];

    final fr = (root['fr'] as num?)?.toDouble();
    final w = (root['w'] as num?)?.toInt();
    final h = (root['h'] as num?)?.toInt();
    final ip = (root['ip'] as num?)?.toInt() ?? 0;
    final op = (root['op'] as num?)?.toInt() ?? 0;
    final nm = root['nm'] as String? ?? '';
    final layersRaw = root['layers'] as List<dynamic>? ?? [];

    final layers = <LottieLayer>[];
    for (final layerRaw in layersRaw) {
      final layer = _parseLayer(layerRaw as Map<String, dynamic>, warnings);
      if (layer != null) {
        layers.add(layer);
      }
    }

    return LottieParseResult(
      animation: LottieAnimation(
        width: w ?? 0,
        height: h ?? 0,
        frameRate: fr ?? 60,
        inPoint: ip,
        outPoint: op,
        name: nm,
        layers: layers,
      ),
      warnings: warnings,
    );
  }

  static LottieLayer? _parseLayer(Map<String, dynamic> raw, List<String> warnings) {
    final ty = raw['ty'] as int?;
    if (ty == null) return null;

    if (ty != 4) {
      final nm = raw['nm'] as String? ?? 'unknown';
      warnings.add('Skipping non-shape layer "$nm" (ty: $ty) — only shape layers (ty: 4) are supported.');
      return null;
    }

    final nm = raw['nm'] as String? ?? '';
    final ks = raw['ks'] as Map<String, dynamic>? ?? {};
    final shapesRaw = raw['shapes'] as List<dynamic>? ?? [];
    final ip = (raw['ip'] as num?)?.toInt() ?? 0;
    final op = (raw['op'] as num?)?.toInt() ?? 0;

    final shapeGroups = <LottieGroup>[];
    for (final shapeRaw in shapesRaw) {
      final group = _parseShapeGroup(shapeRaw as Map<String, dynamic>, warnings);
      if (group != null) {
        shapeGroups.add(group);
      }
    }

    return LottieLayer(
      name: nm,
      shapeGroups: shapeGroups,
      opacity: _parseAnimatedScalar(ks['o'] as Map<String, dynamic>?),
      rotation: _parseAnimatedScalar(ks['r'] as Map<String, dynamic>?),
      positionX: _parseAnimatedScalarFromArray(ks['p'] as Map<String, dynamic>?, 0),
      positionY: _parseAnimatedScalarFromArray(ks['p'] as Map<String, dynamic>?, 1),
      anchorX: _parseStaticArrayValue(ks['a'] as Map<String, dynamic>?, 0),
      anchorY: _parseStaticArrayValue(ks['a'] as Map<String, dynamic>?, 1),
      scaleX: _parseAnimatedScalarFromArray(ks['s'] as Map<String, dynamic>?, 0),
      scaleY: _parseAnimatedScalarFromArray(ks['s'] as Map<String, dynamic>?, 1),
      inPoint: ip,
      outPoint: op,
    );
  }

  static LottieGroup? _parseShapeGroup(Map<String, dynamic> raw, List<String> warnings) {
    final ty = raw['ty'] as String?;
    if (ty != 'gr') {
      warnings.add('Skipping non-group shape (ty: "$ty") — only groups (ty: "gr") are supported at the top level.');
      return null;
    }

    final nm = raw['nm'] as String? ?? '';
    final it = raw['it'] as List<dynamic>? ?? [];

    final items = <LottieShape>[];
    for (final itemRaw in it) {
      final item = _parseShapeItem(itemRaw as Map<String, dynamic>, warnings);
      if (item != null) {
        items.add(item);
      }
    }

    return LottieGroup(name: nm, items: items);
  }

  static LottieShape? _parseShapeItem(Map<String, dynamic> raw, List<String> warnings) {
    final ty = raw['ty'] as String?;
    if (ty == null) return null;

    switch (ty) {
      case 'sh':
        return _parsePath(raw);
      case 'rc':
        return _parseRect(raw);
      case 'el':
        return _parseEllipse(raw);
      case 'fl':
        return _parseFill(raw);
      case 'st':
        return _parseStroke(raw);
      case 'tr':
        return _parseGroupTransform(raw);
      default:
        warnings.add('Skipping unsupported shape type "$ty".');
        return null;
    }
  }

  static LottiePath _parsePath(Map<String, dynamic> raw) {
    final ks = raw['ks'] as Map<String, dynamic>? ?? {};
    final k = ks['k'] as Map<String, dynamic>? ?? {};
    final vRaw = k['v'] as List<dynamic>? ?? [];
    final v = vRaw.map<List<double>>((e) {
      final arr = e as List<dynamic>;
      return <double>[(arr[0] as num).toDouble(), (arr[1] as num).toDouble()];
    }).toList();
    final iRaw = k['i'] as List<dynamic>? ?? [];
    final i = iRaw.map<List<double>>((e) {
      final arr = e as List<dynamic>;
      return <double>[(arr[0] as num).toDouble(), (arr[1] as num).toDouble()];
    }).toList();
    final oRaw = k['o'] as List<dynamic>? ?? [];
    final o = oRaw.map<List<double>>((e) {
      final arr = e as List<dynamic>;
      return <double>[(arr[0] as num).toDouble(), (arr[1] as num).toDouble()];
    }).toList();
    final closed = k['c'] as bool? ?? true;

    return LottiePath(vertices: v, inTangents: i, outTangents: o, closed: closed);
  }

  static LottieRect _parseRect(Map<String, dynamic> raw) {
    final p = raw['p'] as Map<String, dynamic>? ?? {};
    final s = raw['s'] as Map<String, dynamic>? ?? {};
    final r = raw['r'] as Map<String, dynamic>? ?? {};
    final d = (raw['d'] as num?)?.toInt() ?? 1;

    return LottieRect(
      positionX: _staticValue(p, 0),
      positionY: _staticValue(p, 1),
      width: _staticValue(s, 0),
      height: _staticValue(s, 1),
      cornerRadius: _staticValue(r, 0),
      direction: d,
    );
  }

  static LottieEllipse _parseEllipse(Map<String, dynamic> raw) {
    final p = raw['p'] as Map<String, dynamic>? ?? {};
    final s = raw['s'] as Map<String, dynamic>? ?? {};
    final d = (raw['d'] as num?)?.toInt() ?? 1;

    return LottieEllipse(
      positionX: _staticValue(p, 0),
      positionY: _staticValue(p, 1),
      width: _staticValue(s, 0),
      height: _staticValue(s, 1),
      direction: d,
    );
  }

  static LottieFill _parseFill(Map<String, dynamic> raw) {
    final c = raw['c'] as Map<String, dynamic>? ?? {};
    final o = raw['o'] as Map<String, dynamic>? ?? {};
    final r = (raw['r'] as num?)?.toInt() ?? 1;

    final color = _staticColor(c);
    return LottieFill(
      colorR: color[0],
      colorG: color[1],
      colorB: color[2],
      colorA: color[3],
      opacity: _staticValue(o, 0),
      fillRule: r,
    );
  }

  static LottieStroke _parseStroke(Map<String, dynamic> raw) {
    final c = raw['c'] as Map<String, dynamic>? ?? {};
    final o = raw['o'] as Map<String, dynamic>? ?? {};
    final w = raw['w'] as Map<String, dynamic>? ?? {};
    final lc = (raw['lc'] as num?)?.toInt() ?? 1;
    final lj = (raw['lj'] as num?)?.toInt() ?? 1;

    final color = _staticColor(c);
    return LottieStroke(
      colorR: color[0],
      colorG: color[1],
      colorB: color[2],
      colorA: color[3],
      opacity: _staticValue(o, 0),
      width: _staticValue(w, 0),
      lineCap: lc,
      lineJoin: lj,
    );
  }

  static LottieGroupTransform _parseGroupTransform(Map<String, dynamic> raw) {
    return LottieGroupTransform(
      positionX: _staticValue(raw['p'] as Map<String, dynamic>?, 0),
      positionY: _staticValue(raw['p'] as Map<String, dynamic>?, 1),
      anchorX: _staticValue(raw['a'] as Map<String, dynamic>?, 0),
      anchorY: _staticValue(raw['a'] as Map<String, dynamic>?, 1),
      scaleX: _staticValue(raw['s'] as Map<String, dynamic>?, 0),
      scaleY: _staticValue(raw['s'] as Map<String, dynamic>?, 1),
      rotation: _staticValue(raw['r'] as Map<String, dynamic>?, 0),
      opacity: _staticValue(raw['o'] as Map<String, dynamic>?, 0),
    );
  }

  // ── Helpers ──

  /// Parses an animated or static scalar property.
  static LottieAnimatedScalar _parseAnimatedScalar(Map<String, dynamic>? raw) {
    if (raw == null) return const LottieAnimatedScalar(animated: false, staticValue: 100);

    final a = (raw['a'] as num?)?.toInt() ?? 0;
    if (a == 0) {
      final k = raw['k'] as dynamic;
      final value = k is List ? (k[0] as num).toDouble() : (k as num).toDouble();
      return LottieAnimatedScalar(animated: false, staticValue: value);
    }

    final k = raw['k'] as List<dynamic>? ?? [];
    final keyframes = k.map((kf) => _parseScalarKeyframe(kf as Map<String, dynamic>)).toList();
    return LottieAnimatedScalar(animated: true, keyframes: keyframes);
  }

  /// Parses an animated or static scalar from an array property (e.g. position X from [x, y, z]).
  static LottieAnimatedScalar _parseAnimatedScalarFromArray(Map<String, dynamic>? raw, int index) {
    if (raw == null) return const LottieAnimatedScalar(animated: false, staticValue: 0);

    final a = (raw['a'] as num?)?.toInt() ?? 0;
    if (a == 0) {
      final k = raw['k'] as dynamic;
      final arr = k is List ? k : (k as List<dynamic>);
      final value = (arr[index] as num).toDouble();
      return LottieAnimatedScalar(animated: false, staticValue: value);
    }

    final k = raw['k'] as List<dynamic>? ?? [];
    final keyframes = k.map((kf) {
      final kfMap = kf as Map<String, dynamic>;
      final s = kfMap['s'] as List<dynamic>? ?? [];
      final e = kfMap['e'] as List<dynamic>?;
      final o = kfMap['o'] as Map<String, dynamic>?;
      final i = kfMap['i'] as Map<String, dynamic>?;
      final h = (kfMap['h'] as num?)?.toInt() ?? 0;

      return LottieScalarKeyframe(
        time: (kfMap['t'] as num).toDouble(),
        start: (s[index] as num).toDouble(),
        end: e != null ? (e[index] as num).toDouble() : null,
        outX: _extractEasingValue(o, 'x', index),
        outY: _extractEasingValue(o, 'y', index),
        inX: _extractEasingValue(i, 'x', index),
        inY: _extractEasingValue(i, 'y', index),
        hold: h == 1,
      );
    }).toList();
    return LottieAnimatedScalar(animated: true, keyframes: keyframes);
  }

  static LottieScalarKeyframe _parseScalarKeyframe(Map<String, dynamic> raw) {
    final s = raw['s'] as List<dynamic>? ?? [];
    final e = raw['e'] as List<dynamic>?;
    final o = raw['o'] as Map<String, dynamic>?;
    final i = raw['i'] as Map<String, dynamic>?;
    final h = (raw['h'] as num?)?.toInt() ?? 0;

    return LottieScalarKeyframe(
      time: (raw['t'] as num).toDouble(),
      start: (s[0] as num).toDouble(),
      end: e != null ? (e[0] as num).toDouble() : null,
      outX: _extractEasingValue(o, 'x', 0),
      outY: _extractEasingValue(o, 'y', 0),
      inX: _extractEasingValue(i, 'x', 0),
      inY: _extractEasingValue(i, 'y', 0),
      hold: h == 1,
    );
  }

  /// Extracts a static value from a property like `{"a": 0, "k": [value]}`.
  static double _staticValue(Map<String, dynamic>? raw, int index) {
    if (raw == null) return 0;
    final k = raw['k'] as dynamic;
    if (k is List) {
      if (index < k.length) return (k[index] as num).toDouble();
      return 0;
    }
    return (k as num).toDouble();
  }

  /// Extracts a static color from a property like `{"a": 0, "k": [r, g, b, a]}`.
  static List<double> _staticColor(Map<String, dynamic>? raw) {
    if (raw == null) return [0, 0, 0, 1];
    final k = raw['k'] as List<dynamic>? ?? [];
    return [
      if (k.isNotEmpty) (k[0] as num).toDouble() else 0,
      if (k.length > 1) (k[1] as num).toDouble() else 0,
      if (k.length > 2) (k[2] as num).toDouble() else 0,
      if (k.length > 3) (k[3] as num).toDouble() else 1,
    ];
  }

  /// Extracts a single value from a static array property.
  static double _parseStaticArrayValue(Map<String, dynamic>? raw, int index) {
    if (raw == null) return 0;
    final k = raw['k'] as List<dynamic>? ?? [];
    if (index < k.length) return (k[index] as num).toDouble();
    return 0;
  }

  /// Extracts an easing handle value from a Lottie `o` or `i` map.
  ///
  /// The value can be either a single number (`{"x": 0.2}`) or an array
  /// (`{"x": [0.2, 0.3, 0.2]}`) for multi-dimensional properties.
  static double? _extractEasingValue(Map<String, dynamic>? raw, String key, int index) {
    if (raw == null) return null;
    final val = raw[key] as dynamic;
    if (val is List) {
      if (index < val.length) return (val[index] as num).toDouble();
      return null;
    }
    return (val as num?)?.toDouble();
  }
}

/// Result of parsing a Lottie JSON string.
class LottieParseResult {
  const LottieParseResult({required this.animation, this.warnings = const []});

  /// The parsed animation.
  final LottieAnimation animation;

  /// Non-fatal warnings (e.g. skipped unsupported layers).
  final List<String> warnings;
}
