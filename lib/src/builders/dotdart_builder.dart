import 'dart:convert';
import 'dart:io';

import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import '../generators/lottie_generator.dart';
import '../parsers/lottie_parser.dart';

/// A `build_runner` [Builder] that converts visual assets (Lottie, SVG, etc.)
/// into pure-Dart `CustomPainter` widget code.
///
/// Reads the `dotdart:` section from `pubspec.yaml` to find asset files
/// and the output directory. Writes a manifest consumed by
/// [_DotdartPostProcessBuilder].
Builder dotdartBuilder(BuilderOptions options) {
  return _DotdartBuilder();
}

/// Materializes generated `.g.dart` files from the manifest written by
/// [_DotdartBuilder].
PostProcessBuilder dotdartPostProcessBuilder(BuilderOptions options) {
  return _DotdartPostProcessBuilder();
}

class _DotdartBuilder implements Builder {
  _DotdartBuilder();

  static const _manifestExtension = '.dotdart.manifest.json';

  @override
  Map<String, List<String>> get buildExtensions => {
    r'$package$': [_manifestExtension],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final pubspecId = AssetId(buildStep.inputId.package, 'pubspec.yaml');

    if (!await buildStep.canRead(pubspecId)) {
      await _writeManifest(buildStep, null, []);
      return;
    }

    final pubspecContent = await buildStep.readAsString(pubspecId);
    final config = _parseConfig(pubspecContent);
    if (config == null) {
      await _writeManifest(buildStep, null, []);
      return;
    }

    final packageRoot = await _packageRoot(buildStep);
    final outputs = <_ManifestOutput>[];

    for (final folder in config.lottieFolders) {
      final glob = folder.endsWith('/') ? '$folder*.json' : '$folder/*.json';
      await for (final assetId in buildStep.findAssets(Glob(glob))) {
        final content = await buildStep.readAsString(assetId);
        if (!_isLottieJson(content)) continue;

        final result = LottieParser.parse(content);
        for (final warning in result.warnings) {
          log.warning('$assetId: $warning');
        }

        final generator = LottieGenerator(result.animation, assetId.path);
        final output = generator.generate();

        final fileName = p.basename(assetId.path).replaceAll('.json', '.g.dart');
        final outputPath = '${config.outputDir}$fileName';
        outputs.add(_ManifestOutput(path: outputPath, contents: output));
      }
    }

    await _writeManifest(buildStep, packageRoot, outputs);
  }

  Future<String> _packageRoot(BuildStep buildStep) async {
    final packageConfig = await buildStep.packageConfig;
    final pkg = packageConfig[buildStep.inputId.package];
    if (pkg != null && pkg.root.scheme == 'file') return pkg.root.toFilePath();
    // Fallback: use the current working directory
    return Directory.current.path;
  }

  _DotdartConfig? _parseConfig(String pubspecContent) {
    final doc = loadYaml(pubspecContent);
    if (doc is! YamlMap) return null;

    final dotdart = doc['dotdart'];
    if (dotdart is! YamlMap) return null;

    final output = dotdart['output'] as String? ?? 'lib/gen/';
    final outputDir = output.endsWith('/') ? output : '$output/';

    final lottieRaw = dotdart['lottie'];
    final lottieFolders = <String>[];
    if (lottieRaw is YamlList) {
      for (final entry in lottieRaw) {
        final s = entry.toString();
        if (s.isNotEmpty) lottieFolders.add(s);
      }
    }

    return _DotdartConfig(outputDir: outputDir, lottieFolders: lottieFolders);
  }

  bool _isLottieJson(String content) {
    try {
      return content.contains('"v"') &&
          content.contains('"fr"') &&
          content.contains('"w"') &&
          content.contains('"h"') &&
          content.contains('"layers"');
    } catch (_) {
      return false;
    }
  }

  Future<void> _writeManifest(BuildStep buildStep, String? packageRoot, List<_ManifestOutput> outputs) {
    return buildStep.writeAsString(
      AssetId(buildStep.inputId.package, _manifestExtension),
      jsonEncode({
        'schema_version': 1,
        if (packageRoot != null) 'package_root': packageRoot,
        'outputs': [
          for (final o in outputs) {'path': o.path, 'contents': o.contents},
        ],
      }),
    );
  }
}

class _DotdartPostProcessBuilder extends PostProcessBuilder {
  static const _manifestExtension = '.dotdart.manifest.json';

  @override
  Iterable<String> get inputExtensions => const [_manifestExtension];

  @override
  Future<void> build(PostProcessBuildStep buildStep) async {
    final manifest = jsonDecode(await buildStep.readInputAsString()) as Map<String, Object?>;

    final packageRoot = manifest['package_root'] as String?;
    if (packageRoot == null) return;

    final outputs = (manifest['outputs']! as List<Object?>)
        .whereType<Map<String, Object?>>()
        .map((o) => _ManifestOutput(path: o['path']! as String, contents: o['contents']! as String))
        .toList();

    for (final output in outputs) {
      final file = File(p.join(packageRoot, output.path));
      if (!file.parent.existsSync()) {
        file.parent.createSync(recursive: true);
      }
      file.writeAsStringSync(output.contents);
    }
  }
}

class _DotdartConfig {
  const _DotdartConfig({required this.outputDir, required this.lottieFolders});
  final String outputDir;
  final List<String> lottieFolders;
}

class _ManifestOutput {
  const _ManifestOutput({required this.path, required this.contents});
  final String path;
  final String contents;
}
