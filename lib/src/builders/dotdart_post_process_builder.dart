import 'dart:convert';
import 'dart:io';

import 'package:build/build.dart';

import 'generated_output_path.dart';
import 'manifest_output.dart';

/// Safely materializes dotdart source outputs from a validated manifest.
class DotdartPostProcessBuilder extends PostProcessBuilder {
  /// Creates the post-process builder used by build_runner.
  DotdartPostProcessBuilder();

  static const manifestExtension = '.dotdart.manifest.json';

  @override
  Iterable<String> get inputExtensions => const [manifestExtension];

  @override
  Future<void> build(PostProcessBuildStep buildStep) async {
    final decodedManifest = jsonDecode(await buildStep.readInputAsString());
    if (decodedManifest is! Map<String, Object?> || decodedManifest['schema_version'] != 2) {
      throw const FormatException('Invalid dotdart manifest.');
    }

    final packageRoot = decodedManifest['package_root'] as String?;
    if (packageRoot == null) return;
    GeneratedOutputPath.validatePackageRoot(packageRoot: packageRoot, workspaceRoot: Directory.current.path);

    final outputs =
        (decodedManifest['outputs'] as List<Object?>?)
            ?.whereType<Map<String, Object?>>()
            .map(_parseOutput)
            .toList(growable: false) ??
        const <ManifestOutput>[];
    for (final output in outputs) {
      final file = File(GeneratedOutputPath.resolve(packageRoot: packageRoot, relativePath: output.path));
      file.parent.createSync(recursive: true);
      file.writeAsStringSync(output.contents);
    }

    final deletedPaths = (decodedManifest['deleted_outputs'] as List<Object?>?)?.whereType<String>() ?? const [];
    for (final path in deletedPaths) {
      final file = File(GeneratedOutputPath.resolve(packageRoot: packageRoot, relativePath: path));
      if (!file.existsSync()) continue;
      if (!GeneratedOutputPath.isDotdartOwned(file.readAsStringSync())) continue;
      file.deleteSync();
    }
  }

  static ManifestOutput _parseOutput(Map<String, Object?> value) {
    final path = value['path'];
    final contents = value['contents'];
    if (path is! String || contents is! String) {
      throw const FormatException('Invalid dotdart manifest output.');
    }
    if (!GeneratedOutputPath.isDotdartOwned(contents)) {
      throw FormatException('Refusing to write output without dotdart ownership header: "$path".');
    }
    return ManifestOutput(path: path, contents: contents);
  }
}
