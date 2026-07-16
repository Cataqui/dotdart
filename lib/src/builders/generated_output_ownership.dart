import 'dart:io';

import 'package:path/path.dart' as p;

import 'generated_output_path.dart';

/// Finds stale files that are demonstrably owned by dotdart.
class GeneratedOutputOwnership {
  GeneratedOutputOwnership._();

  /// Returns owned `.g.dart` paths absent from [currentPaths].
  static List<String> collectStalePaths({
    required String packageRoot,
    required String outputDir,
    required Set<String> currentPaths,
  }) {
    final directory = Directory(GeneratedOutputPath.resolve(packageRoot: packageRoot, relativePath: outputDir));
    if (!directory.existsSync()) return const [];

    final stalePaths = <String>[];
    for (final entity in directory.listSync(recursive: true, followLinks: false)) {
      if (entity is! File || !entity.path.endsWith('.g.dart')) continue;
      if (!GeneratedOutputPath.isDotdartOwned(entity.readAsStringSync())) continue;
      final relativePath = p.posix.joinAll(p.split(p.relative(entity.path, from: packageRoot)));
      if (!currentPaths.contains(relativePath)) stalePaths.add(relativePath);
    }
    stalePaths.sort();
    return stalePaths;
  }
}
