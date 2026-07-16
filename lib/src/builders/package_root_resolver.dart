import 'dart:convert';
import 'dart:io';

import 'package:build/build.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

/// Resolves the filesystem root for the package currently being generated.
class PackageRootResolver {
  PackageRootResolver._();

  static const _packageConfigPath = '.dart_tool/package_config.json';

  /// Resolves [buildStep]'s package root without depending on process cwd.
  ///
  /// Dart workspaces may expose package roots as relative URIs. Those roots are
  /// relative to `.dart_tool/package_config.json`, not to arbitrary shell cwd.
  static Future<String> resolve(BuildStep buildStep) async {
    final packageName = buildStep.inputId.package;
    final packageConfig = await buildStep.packageConfig;
    final package = packageConfig[packageName];
    if (package == null) {
      throw FormatException('Unable to resolve dotdart package root for "$packageName".');
    }

    return validatePackageRoot(
      packageName: packageName,
      packageRoot: resolveRootUri(packageName: packageName, rootUri: package.root, currentDirectory: Directory.current),
    );
  }

  /// Resolves a package root URI into a normalized filesystem path.
  static String resolveRootUri({
    required String packageName,
    required Uri rootUri,
    required Directory currentDirectory,
  }) {
    final resolvedUri = switch (rootUri.hasScheme) {
      true when rootUri.isScheme('file') => rootUri,
      true => _resolveFromPackageConfigFile(packageName: packageName, currentDirectory: currentDirectory),
      false => _packageConfigFile(currentDirectory).uri.resolveUri(rootUri),
    };

    return p.normalize(resolvedUri.toFilePath());
  }

  /// Returns [packageRoot] only when its `pubspec.yaml` owns [packageName].
  static String validatePackageRoot({required String packageName, required String packageRoot}) {
    if (_hasMatchingPubspecName(packageRoot: packageRoot, packageName: packageName)) {
      return packageRoot;
    }

    throw FormatException('Resolved dotdart package root "$packageRoot" does not belong to package "$packageName".');
  }

  static File _packageConfigFile(Directory currentDirectory) {
    var directory = currentDirectory;
    while (true) {
      final packageConfigFile = File(p.join(directory.path, _packageConfigPath));
      if (packageConfigFile.existsSync()) return packageConfigFile;

      final parent = directory.parent;
      if (parent.path == directory.path) {
        throw FormatException('Unable to find .dart_tool/package_config.json from "${currentDirectory.path}".');
      }
      directory = parent;
    }
  }

  static Uri _resolveFromPackageConfigFile({required String packageName, required Directory currentDirectory}) {
    final packageConfigFile = _packageConfigFile(currentDirectory);
    final packageConfig = jsonDecode(packageConfigFile.readAsStringSync());
    if (packageConfig is! Map<String, Object?>) {
      throw const FormatException('Invalid .dart_tool/package_config.json.');
    }

    final packages = packageConfig['packages'];
    if (packages is! List<Object?>) {
      throw const FormatException('Invalid package list in .dart_tool/package_config.json.');
    }

    for (final package in packages.whereType<Map<String, Object?>>()) {
      if (package['name'] != packageName) continue;

      final rootUri = package['rootUri'];
      if (rootUri is! String) {
        throw FormatException('Missing rootUri for package "$packageName" in .dart_tool/package_config.json.');
      }
      return packageConfigFile.uri.resolveUri(Uri.parse(rootUri));
    }

    throw FormatException('Unable to find package "$packageName" in .dart_tool/package_config.json.');
  }

  static bool _hasMatchingPubspecName({required String packageRoot, required String packageName}) {
    final pubspecFile = File(p.join(packageRoot, 'pubspec.yaml'));
    if (!pubspecFile.existsSync()) return false;

    final pubspec = loadYaml(pubspecFile.readAsStringSync());
    if (pubspec is! YamlMap) return false;

    return pubspec['name'] == packageName;
  }
}
