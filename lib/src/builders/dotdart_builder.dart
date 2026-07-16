// StringBuffer.writeln returns void. Cascading void calls is valid Dart but
// makes the code harder to read. This is a known false positive.
// ignore_for_file: cascade_invocations

import 'dart:convert';
import 'dart:io';

import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import '../generators/accessor_param.dart';
import '../generators/lottie_generator.dart';
import '../generators/namespace_assembler.dart';
import '../generators/naming.dart';
import '../generators/svg_generator.dart';
import '../parsers/lottie_parser.dart';
import '../parsers/svg/svg_parser.dart';

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
      await _writeManifest(buildStep, null, [], []);
      return;
    }

    final pubspecContent = await buildStep.readAsString(pubspecId);
    final config = _parseConfig(pubspecContent);
    if (config == null) {
      await _writeManifest(buildStep, null, [], []);
      return;
    }

    final packageRoot = await _packageRoot(buildStep);

    // Collect all raw assembled assets from lottie and svg inputs.
    final rawAssets = <_RawAsset>[];

    for (final input in config.lottieInputs) {
      final globPattern = input.endsWith('.json') ? input : '${input.replaceFirst(RegExp(r'/$'), '')}/*.json';
      await for (final assetId in buildStep.findAssets(Glob(globPattern))) {
        final content = await buildStep.readAsString(assetId);
        if (!_isLottieJson(content)) continue;

        final result = LottieParser.parse(content);
        for (final warning in result.warnings) {
          log.warning('$assetId: $warning');
        }

        final generator = LottieGenerator(result.animation, assetId.path);
        rawAssets.add(_RawAsset(
          assetId: assetId,
          generator: generator,
          widgetSource: generator.generateWidgetClass(),
          params: generator.params,
          widgetClassName: generator.widgetClassName,
          assetType: DotdartAssetType.lottie,
        ));
      }
    }

    for (final input in config.svgInputs) {
      final globPattern = input.endsWith('.svg') ? input : '${input.replaceFirst(RegExp(r'/$'), '')}/*.svg';
      await for (final assetId in buildStep.findAssets(Glob(globPattern))) {
        final content = await buildStep.readAsString(assetId);
        if (!_isSvgXml(content)) continue;

        final result = SvgParser.parse(content);
        for (final warning in result.warnings) {
          log.warning('$assetId: $warning');
        }

        final generator = SvgGenerator(result.document, assetId.path);
        rawAssets.add(_RawAsset(
          assetId: assetId,
          generator: null,
          widgetSource: generator.generateWidgetClass(),
          params: generator.params,
          widgetClassName: generator.widgetClassName,
          assetType: DotdartAssetType.svg,
        ));
      }
    }

    // Group by namespace key derived from parent folder.
    final namespaceGroups = <String, List<_RawAsset>>{};
    for (final raw in rawAssets) {
      final folderSegment = _parentFolder(raw.assetId.path);
      namespaceGroups.putIfAbsent(folderSegment, () => []).add(raw);
    }

    final outputs = <_ManifestOutput>[];

    for (final entry in namespaceGroups.entries) {
      final folderSegment = entry.key;
      final assets = entry.value;

      // Sort by accessor name for deterministic output.
      assets.sort((a, b) => a.accessorName.compareTo(b.accessorName));

      // Detect class-name collisions within the namespace.
      final seen = <String>{};
      for (final asset in assets) {
        if (!seen.add(asset.widgetClassName)) {
          throw DotdartNamespaceCollisionException(
            'Two assets in the same folder "$folderSegment" produced the same '
            'widget class name "${asset.widgetClassName}". '
            'Check that filenames differ by more than case/hyphen/underscore.',
          );
        }
      }

      final namespaceName = Naming.namespaceNameFromFolder(folderSegment);
      final assembled = assets
          .map((raw) => AssembledAsset(
                accessorName: raw.accessorName,
                widgetClassName: raw.widgetClassName,
                params: raw.params,
                widgetSource: raw.widgetSource,
                assetType: raw.assetType,
              ))
          .toList();

      final assembler = NamespaceAssembler(
        namespaceName: namespaceName,
        folderSegment: folderSegment,
        assets: assembled,
      );

      final outputPath = p.posix.join(config.outputDir, '$folderSegment.g.dart');
      outputs.add(_ManifestOutput(path: outputPath, contents: assembler.assemble()));
    }

    // Collect stale file paths to delete.
    final stalePaths = _collectStalePaths(packageRoot, config.outputDir, outputs);

    await _writeManifest(buildStep, packageRoot, outputs, stalePaths);
  }

  /// Extracts the parent folder name from an asset path.
  ///
  /// `assets/icons/cross.svg` → `icons`
  /// `assets/lotties/swipe_up.json` → `lotties`
  String _parentFolder(String assetPath) {
    final parts = assetPath.split('/');
    // Parent directory is the segment before the filename.
    return parts.length >= 2 ? parts[parts.length - 2] : parts.first;
  }

  /// Scans the output directory for existing `.g.dart` files and returns
  /// paths of those not present in the current [outputs].
  List<String> _collectStalePaths(String packageRoot, String outputDir, List<_ManifestOutput> outputs) {
    final currentPaths = outputs.map((o) => o.path).toSet();
    final genDir = Directory(p.join(packageRoot, outputDir));
    if (!genDir.existsSync()) return [];

    final stale = <String>[];
    _walkForGdart(genDir, packageRoot, currentPaths, stale);
    return stale;
  }

  void _walkForGdart(Directory dir, String packageRoot, Set<String> currentPaths, List<String> stale) {
    for (final entry in dir.listSync()) {
      if (entry is File && entry.path.endsWith('.g.dart')) {
        final relativePath = p.relative(entry.path, from: packageRoot);
        final posixPath = p.posix.joinAll(p.split(relativePath));
        if (!currentPaths.contains(posixPath)) {
          stale.add(posixPath);
        }
      } else if (entry is Directory) {
        _walkForGdart(entry, packageRoot, currentPaths, stale);
      }
    }
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

    final svgRaw = dotdart['svg'];
    final svgInputs = <String>[];
    if (svgRaw is YamlList) {
      for (final entry in svgRaw) {
        if (entry is! String) {
          throw const FormatException('dotdart.svg entries must be relative file or directory paths.');
        }

        final input = _normalizePackagePath(entry, fieldName: 'dotdart.svg');
        if (input.isNotEmpty) svgInputs.add(input);
      }
    }

    return _DotdartConfig(outputDir: outputDir, lottieInputs: lottieInputs, svgInputs: svgInputs);
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

  bool _isSvgXml(String content) {
    // Quick content-based check — does this look like an SVG XML file?
    try {
      final trimmed = content.trimLeft();
      if (!trimmed.startsWith('<')) return false;
      // Check for <svg opening tag (with or without namespace/attributes)
      return RegExp(r'<\s*svg[\s>]', caseSensitive: false).hasMatch(trimmed);
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

  Future<void> _writeManifest(
    BuildStep buildStep,
    String? packageRoot,
    List<_ManifestOutput> outputs,
    List<String> stalePaths,
  ) {
    return buildStep.writeAsString(
      AssetId(buildStep.inputId.package, _manifestExtension),
      jsonEncode({
        'schema_version': 2,
        if (packageRoot != null) 'package_root': packageRoot,
        'outputs': [
          for (final o in outputs) {'path': o.path, 'contents': o.contents},
        ],
        if (stalePaths.isNotEmpty) 'deleted_outputs': stalePaths,
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

    // Write new outputs.
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

    // Delete stale files from previous runs.
    final deletedPaths = (manifest['deleted_outputs'] as List<Object?>?)
        ?.whereType<String>()
        .toList() ?? [];
    for (final path in deletedPaths) {
      final file = File(p.join(packageRoot, path));
      if (file.existsSync()) {
        file.deleteSync();
      }
    }
  }
}

class _DotdartConfig {
  const _DotdartConfig({required this.outputDir, required this.lottieInputs, required this.svgInputs});
  final String outputDir;
  final List<String> lottieInputs;
  final List<String> svgInputs;
}

class _ManifestOutput {
  const _ManifestOutput({required this.path, required this.contents});
  final String path;
  final String contents;
}

/// Thrown when two assets in the same namespace produce the same widget class name.
class DotdartNamespaceCollisionException implements Exception {
  DotdartNamespaceCollisionException(this.message);
  final String message;

  @override
  String toString() => 'DotdartNamespaceCollisionException: $message';
}

/// Internal: holds a parsed asset and its generated artifacts before namespace grouping.
class _RawAsset {
  _RawAsset({
    required this.assetId,
    required this.generator,
    required this.widgetSource,
    required this.params,
    required this.widgetClassName,
    required this.assetType,
  });

  final AssetId assetId;
  final Object? generator;
  final String widgetSource;
  final List<AccessorParam> params;
  final String widgetClassName;
  final DotdartAssetType assetType;

  String get accessorName => Naming.accessorName(assetId.path);
}
