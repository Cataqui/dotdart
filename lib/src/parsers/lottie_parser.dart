import 'dart:convert';

import '../models/lottie_animation.dart';
import '../models/lottie_composition.dart';
import '../models/lottie_keyframe.dart';
import '../models/lottie_layer.dart';
import '../models/lottie_shape.dart';
import '../models/lottie_text.dart';

/// Exception thrown when the parser encounters an unsupported Lottie feature.
class DotdartUnsupportedFeatureException implements Exception {
  const DotdartUnsupportedFeatureException(this.message);

  /// Human-readable explanation of what is unsupported.
  final String message;

  @override
  String toString() => 'DotdartUnsupportedFeatureException: $message';
}

/// Exception thrown when a file looks like Lottie JSON but is structurally invalid.
class DotdartInvalidLottieException implements FormatException {
  /// Creates an invalid-Lottie exception with a package-consumer-facing [message].
  const DotdartInvalidLottieException(this.message);

  @override
  final String message;

  @override
  int? get offset => null;

  @override
  Object? get source => null;

  @override
  String toString() => 'DotdartInvalidLottieException: $message';
}

/// Parses a Lottie JSON string into a [LottieAnimation] model.
///
/// Throws [DotdartUnsupportedFeatureException] for features not yet supported.
/// Throws [DotdartInvalidLottieException] when required Lottie metadata is
/// missing or malformed.
class LottieParser {
  /// Parses [jsonString] as a Lottie animation.
  ///
  /// The JSON must have the standard Lottie top-level fields (`v`, `fr`, `w`,
  /// `h`, `layers`). Shape, precomposition, static text, and null controller
  /// layers are parsed. Other layer types are skipped with a warning returned
  /// in the result.
  static LottieParseResult parse(String jsonString) {
    try {
      return _parse(jsonString);
    } on DotdartUnsupportedFeatureException {
      rethrow;
    } on DotdartInvalidLottieException {
      rethrow;
    } on FormatException catch (error) {
      throw DotdartInvalidLottieException('Invalid JSON at \$: ${error.message}');
    } on Object catch (error) {
      throw DotdartInvalidLottieException('Malformed Lottie value at \$: $error');
    }
  }

  static LottieParseResult _parse(String jsonString) {
    final decoded = json.decode(jsonString);
    if (decoded is! Map<String, dynamic>) {
      throw const DotdartInvalidLottieException('Expected the Lottie file root to be a JSON object.');
    }

    final root = decoded;

    final warnings = <String>[];

    final fr = _requiredPositiveDouble(root, 'fr');
    final w = _requiredPositiveInt(root, 'w');
    final h = _requiredPositiveInt(root, 'h');
    final ip = (root['ip'] as num?)?.toInt() ?? 0;
    final op = _requiredPositiveInt(root, 'op');
    if (op <= ip) {
      throw DotdartInvalidLottieException('Expected Lottie "op" ($op) to be greater than "ip" ($ip).');
    }

    final nm = root['nm'] as String? ?? '';
    final fonts = _parseFonts(root['fonts']);
    final assetsRaw = _optionalList(root['assets'], path: r'$.assets');
    final assetMaps = <String, Map<String, dynamic>>{};
    for (var index = 0; index < assetsRaw.length; index++) {
      final path = '\$.assets[$index]';
      final asset = _requiredMap(assetsRaw[index], path: path);
      final id = asset['id'];
      if (id is! String || id.isEmpty) {
        throw DotdartInvalidLottieException('Expected a non-empty string at $path.id.');
      }
      if (assetMaps.containsKey(id)) {
        throw DotdartInvalidLottieException('Expected unique asset ids; found duplicate id "$id" at $path.id.');
      }
      assetMaps[id] = asset;
    }

    final compositionAssets = <String, Map<String, dynamic>>{
      for (final entry in assetMaps.entries)
        if (entry.value.containsKey('layers')) entry.key: entry.value,
    };
    final compositionIds = compositionAssets.keys.toSet();
    final compositions = <String, LottieComposition>{};
    for (final entry in compositionAssets.entries) {
      final asset = entry.value;
      final layers = _parseLayers(
        _optionalList(asset['layers'], path: '\$.assets["${entry.key}"].layers'),
        warnings,
        fonts: fonts,
        compositionIds: compositionIds,
        path: '\$.assets["${entry.key}"].layers',
      );
      compositions[entry.key] = LottieComposition(
        id: entry.key,
        width: _requiredPositiveInt(asset, 'w'),
        height: _requiredPositiveInt(asset, 'h'),
        layers: layers,
      );
    }
    _validateCompositionReferences(compositions);

    final layersRaw = _optionalList(root['layers'], path: r'$.layers');
    final layers = _parseLayers(
      layersRaw,
      warnings,
      fonts: fonts,
      compositionIds: compositionIds,
      path: r'$.layers',
    );

    return LottieParseResult(
      animation: LottieAnimation(
        width: w,
        height: h,
        frameRate: fr,
        inPoint: ip,
        outPoint: op,
        name: nm,
        layers: layers,
        compositions: compositions,
      ),
      warnings: warnings,
    );
  }

  static List<LottieLayer> _parseLayers(
    List<dynamic> rawLayers,
    List<String> warnings, {
    required Map<String, ({String family, int weight, bool italic})> fonts,
    required Set<String> compositionIds,
    required String path,
  }) {
    final layers = <LottieLayer>[];
    for (var index = 0; index < rawLayers.length; index++) {
      final layerPath = '$path[$index]';
      final layer = _parseLayer(
        _requiredMap(rawLayers[index], path: layerPath),
        warnings,
        fonts: fonts,
        compositionIds: compositionIds,
        path: layerPath,
      );
      if (layer != null) layers.add(layer);
    }
    _validateLayerParents(layers, path: path);
    return layers;
  }

  static LottieLayer? _parseLayer(
    Map<String, dynamic> raw,
    List<String> warnings, {
    required Map<String, ({String family, int weight, bool italic})> fonts,
    required Set<String> compositionIds,
    required String path,
  }) {
    final ty = raw['ty'] as int?;
    if (ty == null) return null;

    if (ty != 0 && ty != 3 && ty != 4 && ty != 5) {
      final nm = raw['nm'] as String? ?? 'unknown';
      warnings.add('Skipping unsupported layer "$nm" (ty: $ty).');
      return null;
    }

    final nm = raw['nm'] as String? ?? '';
    final ks = _optionalMap(raw['ks'], path: '$path.ks');
    final shapesRaw = ty == 4 ? _optionalList(raw['shapes'], path: '$path.shapes') : const <dynamic>[];
    final ip = (raw['ip'] as num?)?.toInt() ?? 0;
    final op = (raw['op'] as num?)?.toInt() ?? 0;
    final referenceId = raw['refId'] as String?;
    if (ty == 0 && (referenceId == null || !compositionIds.contains(referenceId))) {
      throw DotdartInvalidLottieException('Expected $path.refId to reference a Lottie precomposition asset.');
    }
    if (ty == 0 && raw['tm'] != null) {
      throw DotdartUnsupportedFeatureException('$path uses precomposition time remapping.');
    }

    final shapeGroups = <LottieGroup>[];
    for (var index = 0; index < shapesRaw.length; index++) {
      final shapePath = '$path.shapes[$index]';
      final group = _parseShapeGroup(_requiredMap(shapesRaw[index], path: shapePath), warnings, path: shapePath);
      if (group != null) {
        shapeGroups.add(group);
      }
    }

    return LottieLayer(
      name: nm,
      shapeGroups: shapeGroups,
      layerIndex: _optionalInt(raw['ind'], path: '$path.ind'),
      parentIndex: _optionalInt(raw['parent'], path: '$path.parent'),
      referenceId: referenceId,
      text: ty == 5 ? _parseText(raw, fonts, path: path) : null,
      masks: _parseMasks(raw['masksProperties'], path: '$path.masksProperties'),
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
      startTime: (raw['st'] as num?)?.toDouble() ?? 0,
      stretch: (raw['sr'] as num?)?.toDouble() ?? 1,
    );
  }

  static void _validateLayerParents(List<LottieLayer> layers, {required String path}) {
    final layersByIndex = <int, LottieLayer>{};
    for (final layer in layers) {
      final layerIndex = layer.layerIndex;
      if (layerIndex == null) continue;
      if (layersByIndex.containsKey(layerIndex)) {
        throw DotdartInvalidLottieException('Expected unique layer indexes at $path; found duplicate ind $layerIndex.');
      }
      layersByIndex[layerIndex] = layer;
    }

    for (final layer in layers) {
      var parentIndex = layer.parentIndex;
      if (parentIndex == null) continue;
      final visited = <int>{};
      final layerIndex = layer.layerIndex;
      if (layerIndex != null) visited.add(layerIndex);
      while (parentIndex != null) {
        final parent = layersByIndex[parentIndex];
        if (parent == null) {
          throw DotdartInvalidLottieException(
            'Expected parent $parentIndex for layer "${layer.name}" to reference a parsed layer at $path.',
          );
        }
        if (!visited.add(parentIndex)) {
          throw DotdartInvalidLottieException('Expected an acyclic layer parent hierarchy at $path.');
        }
        parentIndex = parent.parentIndex;
      }
    }
  }

  static void _validateCompositionReferences(Map<String, LottieComposition> compositions) {
    final visiting = <String>{};
    final visited = <String>{};
    for (final id in compositions.keys) {
      _visitComposition(id, compositions, visiting, visited);
    }
  }

  static void _visitComposition(
    String id,
    Map<String, LottieComposition> compositions,
    Set<String> visiting,
    Set<String> visited,
  ) {
    if (visited.contains(id)) return;
    if (!visiting.add(id)) {
      throw DotdartInvalidLottieException('Expected an acyclic precomposition graph; found a cycle at asset "$id".');
    }
    for (final layer in compositions[id]!.layers) {
      final referenceId = layer.referenceId;
      if (referenceId != null) {
        _visitComposition(referenceId, compositions, visiting, visited);
      }
    }
    visiting.remove(id);
    visited.add(id);
  }

  static Map<String, ({String family, int weight, bool italic})> _parseFonts(Object? raw) {
    if (raw == null) return const {};
    final fonts = _requiredMap(raw, path: r'$.fonts');
    final list = _optionalList(fonts['list'], path: r'$.fonts.list');
    final result = <String, ({String family, int weight, bool italic})>{};
    for (var index = 0; index < list.length; index++) {
      final font = _requiredMap(list[index], path: '\$.fonts.list[$index]');
      final name = font['fName'];
      final family = font['fFamily'];
      if (name is! String || family is! String) continue;
      final style = (font['fStyle'] as String? ?? '').toLowerCase();
      result[name] = (
        family: family,
        weight: _fontWeight(style),
        italic: style.contains('italic'),
      );
    }
    return result;
  }

  static int _fontWeight(String style) {
    if (style.contains('thin')) return 100;
    if (style.contains('extralight') || style.contains('ultralight')) return 200;
    if (style.contains('light')) return 300;
    if (style.contains('medium')) return 500;
    if (style.contains('semibold') || style.contains('demibold')) return 600;
    if (style.contains('extrabold') || style.contains('ultrabold')) return 800;
    if (style.contains('bold')) return 700;
    if (style.contains('black') || style.contains('heavy')) return 900;
    return 400;
  }

  static LottieText _parseText(
    Map<String, dynamic> raw,
    Map<String, ({String family, int weight, bool italic})> fonts, {
    required String path,
  }) {
    final text = _requiredMap(raw['t'], path: '$path.t');
    final document = _requiredMap(text['d'], path: '$path.t.d');
    final keyframes = _optionalList(document['k'], path: '$path.t.d.k');
    if (keyframes.length != 1) {
      throw DotdartUnsupportedFeatureException(
        '$path uses animated text documents; only one static text document is supported.',
      );
    }
    final keyframe = _requiredMap(keyframes.single, path: '$path.t.d.k[0]');
    final style = _requiredMap(keyframe['s'], path: '$path.t.d.k[0].s');
    final value = style['t'];
    final fontName = style['f'];
    final fontSize = style['s'];
    if (value is! String || fontName is! String || fontSize is! num) {
      throw DotdartInvalidLottieException('Expected static text, font, and size at $path.t.d.k[0].s.');
    }
    final font = fonts[fontName] ?? (family: fontName, weight: 400, italic: false);
    final color = _numberList(style['fc'], path: '$path.t.d.k[0].s.fc');
    final box = style['sz'] == null ? const <double>[] : _numberList(style['sz'], path: '$path.t.d.k[0].s.sz');
    return LottieText(
      value: value,
      fontFamily: font.family,
      fontWeight: font.weight,
      italic: font.italic,
      fontSize: fontSize.toDouble(),
      lineHeight: (style['lh'] as num?)?.toDouble() ?? fontSize.toDouble(),
      tracking: (style['tr'] as num?)?.toDouble() ?? 0,
      justification: (style['j'] as num?)?.toInt() ?? 0,
      colorR: color.isNotEmpty ? color[0] : 0,
      colorG: color.length > 1 ? color[1] : 0,
      colorB: color.length > 2 ? color[2] : 0,
      colorA: color.length > 3 ? color[3] : 1,
      boxWidth: box.isNotEmpty ? box[0] : null,
      boxHeight: box.length > 1 ? box[1] : null,
    );
  }

  static List<LottiePath> _parseMasks(Object? raw, {required String path}) {
    final masks = _optionalList(raw, path: path);
    final result = <LottiePath>[];
    for (var index = 0; index < masks.length; index++) {
      final maskPath = '$path[$index]';
      final mask = _requiredMap(masks[index], path: maskPath);
      if ((mask['mode'] as String? ?? 'a') != 'a' || (mask['inv'] as bool? ?? false)) {
        throw DotdartUnsupportedFeatureException(
          '$maskPath uses a mask mode other than a non-inverted additive mask.',
        );
      }
      final property = _requiredMap(mask['pt'], path: '$maskPath.pt');
      if ((property['a'] as num?)?.toInt() == 1) {
        throw DotdartUnsupportedFeatureException('$maskPath uses an animated mask path.');
      }
      final opacity = _staticMaskValue(mask['o'], path: '$maskPath.o', fallback: 100);
      if (opacity != 100) {
        throw DotdartUnsupportedFeatureException('$maskPath uses mask opacity other than 100%.');
      }
      final expansion = _staticMaskValue(mask['x'], path: '$maskPath.x', fallback: 0);
      if (expansion != 0) {
        throw DotdartUnsupportedFeatureException('$maskPath uses non-zero mask expansion.');
      }
      result.add(_parsePath({'ks': property}));
    }
    return result;
  }

  static double _staticMaskValue(Object? raw, {required String path, required double fallback}) {
    if (raw == null) return fallback;
    final property = _requiredMap(raw, path: path);
    if ((property['a'] as num?)?.toInt() == 1) {
      throw DotdartUnsupportedFeatureException('$path is animated.');
    }
    final value = property['k'];
    if (value is num) return value.toDouble();
    if (value is List<dynamic> && value.isNotEmpty && value.first is num) {
      return (value.first as num).toDouble();
    }
    throw DotdartInvalidLottieException('Expected a static mask value at $path.k.');
  }

  static List<double> _numberList(Object? raw, {required String path}) {
    if (raw is! List<dynamic>) {
      throw DotdartInvalidLottieException('Expected a list of numbers at $path.');
    }
    final result = <double>[];
    for (final value in raw) {
      if (value is! num) {
        throw DotdartInvalidLottieException('Expected a list of numbers at $path.');
      }
      result.add(value.toDouble());
    }
    return result;
  }

  static LottieGroup? _parseShapeGroup(Map<String, dynamic> raw, List<String> warnings, {required String path}) {
    final ty = raw['ty'] as String?;
    if (ty != 'gr') {
      warnings.add('Skipping non-group shape (ty: "$ty") — only groups (ty: "gr") are supported at the top level.');
      return null;
    }

    final nm = raw['nm'] as String? ?? '';
    final it = _optionalList(raw['it'], path: '$path.it');

    final items = <LottieShape>[];
    for (var index = 0; index < it.length; index++) {
      final itemPath = '$path.it[$index]';
      final item = _parseShapeItem(_requiredMap(it[index], path: itemPath), warnings);
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
    final keyframes = <LottieScalarKeyframe>[];
    for (var index = 0; index < k.length; index++) {
      final keyframe = k[index] as Map<String, dynamic>;
      final nextKeyframe = index + 1 < k.length ? k[index + 1] as Map<String, dynamic> : null;
      keyframes.add(_parseScalarKeyframe(keyframe, nextKeyframe));
    }
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
    final keyframes = <LottieScalarKeyframe>[];
    for (var keyframeIndex = 0; keyframeIndex < k.length; keyframeIndex++) {
      final kfMap = k[keyframeIndex] as Map<String, dynamic>;
      final nextKeyframe = keyframeIndex + 1 < k.length ? k[keyframeIndex + 1] as Map<String, dynamic> : null;
      final s = kfMap['s'] as List<dynamic>? ?? [];
      final e = kfMap['e'] as List<dynamic>?;
      final o = kfMap['o'] as Map<String, dynamic>?;
      final i = _incomingEasingFor(keyframe: kfMap, nextKeyframe: nextKeyframe);
      final h = (kfMap['h'] as num?)?.toInt() ?? 0;

      keyframes.add(
        LottieScalarKeyframe(
          time: (kfMap['t'] as num).toDouble(),
          start: (s[index] as num).toDouble(),
          end: e != null ? (e[index] as num).toDouble() : null,
          outX: _extractEasingValue(o, 'x', index),
          outY: _extractEasingValue(o, 'y', index),
          inX: _extractEasingValue(i, 'x', index),
          inY: _extractEasingValue(i, 'y', index),
          hold: h == 1,
        ),
      );
    }
    return LottieAnimatedScalar(animated: true, keyframes: keyframes);
  }

  static LottieScalarKeyframe _parseScalarKeyframe(Map<String, dynamic> raw, Map<String, dynamic>? nextRaw) {
    final s = raw['s'] as List<dynamic>? ?? [];
    final e = raw['e'] as List<dynamic>?;
    final o = raw['o'] as Map<String, dynamic>?;
    final i = _incomingEasingFor(keyframe: raw, nextKeyframe: nextRaw);
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

  static Map<String, dynamic>? _incomingEasingFor({
    required Map<String, dynamic> keyframe,
    required Map<String, dynamic>? nextKeyframe,
  }) {
    return keyframe['i'] as Map<String, dynamic>? ?? nextKeyframe?['i'] as Map<String, dynamic>?;
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

  static double _requiredPositiveDouble(Map<String, dynamic> raw, String key) {
    final value = raw[key];
    if (value is! num || value <= 0) {
      throw DotdartInvalidLottieException('Expected Lottie "$key" to be a positive number.');
    }

    return value.toDouble();
  }

  static int _requiredPositiveInt(Map<String, dynamic> raw, String key) {
    final value = raw[key];
    if (value is! num || value <= 0) {
      throw DotdartInvalidLottieException('Expected Lottie "$key" to be a positive number.');
    }

    return value.toInt();
  }

  static int? _optionalInt(Object? value, {required String path}) {
    if (value == null) return null;
    if (value is! num || value != value.toInt()) {
      throw DotdartInvalidLottieException('Expected an integer at $path.');
    }
    return value.toInt();
  }

  static Map<String, dynamic> _requiredMap(Object? value, {required String path}) {
    if (value is Map<String, dynamic>) return value;
    throw DotdartInvalidLottieException('Expected an object at $path.');
  }

  static Map<String, dynamic> _optionalMap(Object? value, {required String path}) {
    if (value == null) return const {};
    return _requiredMap(value, path: path);
  }

  static List<dynamic> _optionalList(Object? value, {required String path}) {
    if (value == null) return const [];
    if (value is List<dynamic>) return value;
    throw DotdartInvalidLottieException('Expected a list at $path.');
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
