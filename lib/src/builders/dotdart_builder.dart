// StringBuffer.writeln returns void. Cascading void calls is valid Dart but
// makes the code harder to read. This is a known false positive.
// ignore_for_file: cascade_invocations

import 'dart:convert';
import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;

import '../generators/accessor_param.dart';
import '../generators/generated_asset_spec.dart';
import '../generators/image_generator.dart';
import '../generators/lottie_generator.dart';
import '../generators/namespace_assembler.dart';
import '../generators/naming.dart';
import '../generators/svg_generator.dart';
import '../parsers/lottie_parser.dart';
import '../parsers/raster/raster_parser.dart';
import '../parsers/svg/svg_parser.dart';
import 'discovered_asset.dart';
import 'dotdart_config_parser.dart';
import 'dotdart_post_process_builder.dart';
import 'generated_namespace_validator.dart';
import 'generated_output_ownership.dart';
import 'manifest_output.dart';
import 'package_root_resolver.dart';

/// A `build_runner` [Builder] that converts visual assets (Lottie, SVG, etc.)
/// into pure-Dart `CustomPainter` widget code.
///
/// Reads the `dotdart:` section from `pubspec.yaml` to find asset files
/// and the output directory. Writes a manifest consumed by
/// [DotdartPostProcessBuilder].
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
  return DotdartPostProcessBuilder();
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
      await _writeManifest(buildStep, null, [], []);
      return;
    }

    final pubspecContent = await buildStep.readAsString(pubspecId);
    final config = DotdartConfigParser.parse(pubspecContent);
    if (config == null) {
      await _writeManifest(buildStep, null, [], []);
      return;
    }

    final packageRoot = await _packageRoot(buildStep);

    final rawAssets = <DiscoveredAsset>[];
    final discoveredPaths = <String>{};
    for (final assetType in DotdartAssetType.values) {
      for (final input in config.inputs[assetType] ?? const <String>[]) {
        rawAssets.addAll(
          await _collectInputAssets(
            buildStep: buildStep,
            assetType: assetType,
            input: input,
            discoveredPaths: discoveredPaths,
          ),
        );
      }
    }

    // Group by namespace key derived from parent folder.
    final namespaceGroups = <String, List<DiscoveredAsset>>{};
    for (final raw in rawAssets) {
      final folderSegment = _parentFolder(raw.assetId.path);
      namespaceGroups.putIfAbsent(folderSegment, () => []).add(raw);
    }

    final outputs = <ManifestOutput>[];

    for (final entry in namespaceGroups.entries) {
      final folderSegment = entry.key;
      final assets = entry.value;

      // Sort by accessor name for deterministic output.
      assets.sort((a, b) => a.spec.accessorName.compareTo(b.spec.accessorName));

      final namespaceName = Naming.namespaceNameFromFolder(folderSegment);
      final assembled = assets.map((asset) => asset.spec).toList(growable: false);
      GeneratedNamespaceValidator.validate(folderSegment: folderSegment, assets: assembled);

      final assembler = NamespaceAssembler(
        namespaceName: namespaceName,
        folderSegment: folderSegment,
        assets: assembled,
      );

      final outputPath = p.posix.join(config.outputDir, '$folderSegment.g.dart');
      outputs.add(ManifestOutput(path: outputPath, contents: assembler.assemble()));
    }

    // Collect stale file paths to delete.
    final stalePaths = _collectStalePaths(packageRoot, config.outputDir, outputs);

    await _writeManifest(buildStep, packageRoot, outputs, stalePaths);
  }

  Future<List<DiscoveredAsset>> _collectInputAssets({
    required BuildStep buildStep,
    required DotdartAssetType assetType,
    required String input,
    required Set<String> discoveredPaths,
  }) async {
    final explicitFile = assetType.extensions.any(input.toLowerCase().endsWith);
    final candidates = await buildStep.findAssets(Glob(_globPattern(assetType: assetType, input: input))).toList();
    if (candidates.isEmpty) {
      throw FormatException('dotdart.${assetType.configKey} input "$input" matched no assets.');
    }

    final assets = <DiscoveredAsset>[];
    for (final assetId in candidates) {
      final asset = await _parseAsset(buildStep: buildStep, assetType: assetType, assetId: assetId);
      if (asset == null) {
        if (explicitFile) {
          throw FormatException('${assetId.path} does not contain valid ${assetType.configKey} content.');
        }
        log.warning('${assetId.path}: skipped because its content does not match ${assetType.configKey}.');
        continue;
      }
      if (!discoveredPaths.add(assetId.path)) {
        throw FormatException('Asset "${assetId.path}" is included by more than one dotdart input.');
      }
      assets.add(asset);
    }
    if (assets.isEmpty) {
      throw FormatException('dotdart.${assetType.configKey} input "$input" produced no valid assets.');
    }
    return assets;
  }

  Future<DiscoveredAsset?> _parseAsset({
    required BuildStep buildStep,
    required DotdartAssetType assetType,
    required AssetId assetId,
  }) async {
    try {
      return switch (assetType) {
        DotdartAssetType.lottie => _parseLottieAsset(assetId, await buildStep.readAsString(assetId)),
        DotdartAssetType.svg => _parseSvgAsset(assetId, await buildStep.readAsString(assetId)),
        DotdartAssetType.raster => _parseRasterAsset(assetId, await buildStep.readAsBytes(assetId)),
      };
    } on DotdartInvalidLottieException catch (error) {
      throw DotdartInvalidLottieException('${assetId.path}: ${error.message}');
    } on DotdartInvalidSvgException catch (error) {
      throw DotdartInvalidSvgException('${assetId.path}: ${error.message}');
    } on DotdartUnsupportedFeatureException catch (error) {
      throw DotdartUnsupportedFeatureException('${assetId.path}: ${error.message}');
    } on FormatException catch (error) {
      throw FormatException('${assetId.path}: ${error.message}');
    }
  }

  DiscoveredAsset? _parseLottieAsset(AssetId assetId, String content) {
    if (!_isLottieJson(content)) return null;
    final result = LottieParser.parse(content);
    for (final warning in result.warnings) {
      log.warning('$assetId: $warning');
    }
    final generator = LottieGenerator(result.animation, assetId.path);
    return _discoveredAsset(
      assetId: assetId,
      assetType: DotdartAssetType.lottie,
      widgetClassName: generator.widgetClassName,
      params: generator.params,
      widgetSource: generator.generateWidgetClass(),
    );
  }

  DiscoveredAsset? _parseSvgAsset(AssetId assetId, String content) {
    if (!_isSvgXml(content)) return null;
    final result = SvgParser.parse(content);
    for (final warning in result.warnings) {
      log.warning('$assetId: $warning');
    }
    final generator = SvgGenerator(result.document, assetId.path);
    return _discoveredAsset(
      assetId: assetId,
      assetType: DotdartAssetType.svg,
      widgetClassName: generator.widgetClassName,
      params: generator.params,
      widgetSource: generator.generateWidgetClass(),
    );
  }

  DiscoveredAsset? _parseRasterAsset(AssetId assetId, List<int> bytes) {
    if (!_isRasterImage(bytes)) return null;
    final generator = ImageGenerator(RasterParser.parse(bytes), assetId.path);
    return _discoveredAsset(
      assetId: assetId,
      assetType: DotdartAssetType.raster,
      widgetClassName: generator.widgetClassName,
      params: generator.params,
      widgetSource: generator.generateWidgetClass(),
      cacheKey: assetId.path,
    );
  }

  DiscoveredAsset _discoveredAsset({
    required AssetId assetId,
    required DotdartAssetType assetType,
    required String widgetClassName,
    required List<AccessorParam> params,
    required String widgetSource,
    String? cacheKey,
  }) {
    return DiscoveredAsset(
      assetId: assetId,
      spec: GeneratedAssetSpec(
        sourcePath: assetId.path,
        accessorName: Naming.accessorName(assetId.path),
        widgetClassName: widgetClassName,
        params: params,
        widgetSource: widgetSource,
        assetType: assetType,
        cacheKey: cacheKey,
      ),
    );
  }

  String _globPattern({required DotdartAssetType assetType, required String input}) {
    if (assetType.extensions.any(input.toLowerCase().endsWith)) return input;
    final directory = input.replaceFirst(RegExp(r'/$'), '');
    if (assetType.extensions.length == 1) return '$directory/*${assetType.extensions.single}';
    return '$directory/{${assetType.extensions.map((extension) => '*$extension').join(',')}}';
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
  List<String> _collectStalePaths(String packageRoot, String outputDir, List<ManifestOutput> outputs) {
    return GeneratedOutputOwnership.collectStalePaths(
      packageRoot: packageRoot,
      outputDir: outputDir,
      currentPaths: outputs.map((output) => output.path).toSet(),
    );
  }

  Future<String> _packageRoot(BuildStep buildStep) async {
    return PackageRootResolver.resolve(buildStep);
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
    try {
      final trimmed = content.trimLeft();
      if (!trimmed.startsWith('<')) return false;
      return RegExp(r'<\s*svg[\s>]', caseSensitive: false).hasMatch(trimmed);
    } catch (_) {
      return false;
    }
  }

  /// Detects raster image formats from magic bytes.
  ///
  /// Supports WebP, PNG, JPEG, and GIF. Returns false for AVIF, HEIC, and
  /// other unsupported formats.
  bool _isRasterImage(List<int> bytes) {
    if (bytes.length < 4) return false;

    // PNG: 89 50 4E 47 0D 0A 1A 0A
    if (bytes.length >= 8 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47 &&
        bytes[4] == 0x0D &&
        bytes[5] == 0x0A &&
        bytes[6] == 0x1A &&
        bytes[7] == 0x0A) {
      return true;
    }

    // JPEG: FF D8 FF
    if (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) {
      return true;
    }

    // GIF: 47 49 46 38
    if (bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46 && bytes[3] == 0x38) {
      return true;
    }

    // WebP: 52 49 46 46 .... 57 45 42 50
    if (bytes.length >= 12 &&
        bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x46 &&
        bytes[8] == 0x57 &&
        bytes[9] == 0x45 &&
        bytes[10] == 0x42 &&
        bytes[11] == 0x50) {
      return true;
    }

    // AVIF/HEIC — not supported by Flutter on low-end devices.
    if (bytes.length >= 8 && bytes[4] == 0x66 && bytes[5] == 0x74 && bytes[6] == 0x79 && bytes[7] == 0x70) {
      return false; // ftyp box — AVIF or HEIC
    }

    return false;
  }

  Future<void> _writeManifest(
    BuildStep buildStep,
    String? packageRoot,
    List<ManifestOutput> outputs,
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
