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
///
/// This function is referenced by `build.yaml`; application code does not call
/// it directly.
///
/// ```yaml
/// builders:
///   dotdart:
///     import: "package:dotdart/dotdart.dart"
///     builder_factories: ["dotdartBuilder"]
/// ```
Builder dotdartBuilder(BuilderOptions options) {
  return _DotdartBuilder();
}

/// Materializes generated `.g.dart` files from the manifest written by
/// [_DotdartBuilder].
///
/// This function is referenced by `build.yaml`; application code does not call
/// it directly.
///
/// ```yaml
/// post_process_builders:
///   dotdart_post_process:
///     import: "package:dotdart/dotdart.dart"
///     builder_factory: "dotdartPostProcessBuilder"
/// ```
PostProcessBuilder dotdartPostProcessBuilder(BuilderOptions options) {
  return _DotdartPostProcessBuilder();
}

class _DotdartBuilder implements Builder {
  _DotdartBuilder();

  static const _manifestExtension = '.dotdart.manifest.json';
  static const _defaultOutputDir = 'lib/gen/';

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

    for (final input in config.lottieInputs) {
      final glob = input.endsWith('.json') ? input : '${input.replaceFirst(RegExp(r'/$'), '')}/*.json';
      await for (final assetId in buildStep.findAssets(Glob(glob))) {
        final content = await buildStep.readAsString(assetId);
        if (!_isLottieJson(content)) continue;

        final result = LottieParser.parse(content);
        for (final warning in result.warnings) {
          log.warning('$assetId: $warning');
        }

        final generator = LottieGenerator(result.animation, assetId.path);
        final output = generator.generate();

        final fileName = '${p.basenameWithoutExtension(assetId.path)}.g.dart';
        final outputPath = p.posix.join(config.outputDir, fileName);
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

    final output = dotdart['output'];
    if (output != null && output is! String) {
      throw const FormatException('dotdart.output must be a relative directory path.');
    }

    final outputPath = output as String? ?? _defaultOutputDir;
    final outputDir = _normalizePackagePath(outputPath, fieldName: 'dotdart.output');

    final lottieRaw = dotdart['lottie'];
    final lottieInputs = <String>[];
    if (lottieRaw is YamlList) {
      for (final entry in lottieRaw) {
        if (entry is! String) {
          throw const FormatException('dotdart.lottie entries must be relative file or directory paths.');
        }

        final input = _normalizePackagePath(entry, fieldName: 'dotdart.lottie');
        if (input.isNotEmpty) lottieInputs.add(input);
      }
    }

    return _DotdartConfig(outputDir: outputDir, lottieInputs: lottieInputs);
  }

  bool _isLottieJson(String content) {
    try {
      final json = jsonDecode(content);
      if (json is! Map<String, Object?>) return false;

      return json.containsKey('v') &&
          json.containsKey('fr') &&
          json.containsKey('w') &&
          json.containsKey('h') &&
          json.containsKey('layers');
    } catch (_) {
      return false;
    }
  }

  String _normalizePackagePath(String path, {required String fieldName}) {
    final normalized = p.posix.normalize(path.trim());
    if (normalized.isEmpty || normalized == '.') return '';
    if (p.posix.isAbsolute(normalized) || normalized == '..' || normalized.startsWith('../')) {
      throw FormatException('$fieldName must stay inside the package. Received "$path".');
    }

    return normalized;
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
  const _DotdartConfig({required this.outputDir, required this.lottieInputs});
  final String outputDir;
  final List<String> lottieInputs;
}

class _ManifestOutput {
  const _ManifestOutput({required this.path, required this.contents});
  final String path;
  final String contents;
}
