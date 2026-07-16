import 'dart:io';

import 'package:dotdart/src/builders/package_root_resolver.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('PackageRootResolver', () {
    late Directory workspaceDirectory;
    late Directory quiPackageDirectory;

    setUp(() {
      workspaceDirectory = Directory.systemTemp.createTempSync('dotdart_workspace_');
      Directory(p.join(workspaceDirectory.path, '.dart_tool')).createSync(recursive: true);
      quiPackageDirectory = Directory(p.join(workspaceDirectory.path, 'packages/qui'))..createSync(recursive: true);
      File(p.join(quiPackageDirectory.path, 'pubspec.yaml')).writeAsStringSync('name: qui');
      File(p.join(workspaceDirectory.path, '.dart_tool/package_config.json')).writeAsStringSync('''
{
  "configVersion": 2,
  "packages": [
    {
      "name": "qui",
      "rootUri": "../packages/qui",
      "packageUri": "lib/",
      "languageVersion": "3.12"
    }
  ]
}
''');
    });

    tearDown(() {
      workspaceDirectory.deleteSync(recursive: true);
    });

    test('when a workspace package root URI is relative, it should resolve from package_config location', () {
      final resolvedRoot = PackageRootResolver.resolveRootUri(
        packageName: 'qui',
        rootUri: Uri.parse('../packages/qui/'),
        currentDirectory: workspaceDirectory,
      );

      expect(resolvedRoot, equals(p.normalize(quiPackageDirectory.path)));
    });

    test('when build runner provides an asset root URI, it should resolve from package_config by name', () {
      final resolvedRoot = PackageRootResolver.resolveRootUri(
        packageName: 'qui',
        rootUri: Uri.parse('asset:qui/'),
        currentDirectory: workspaceDirectory,
      );

      expect(resolvedRoot, equals(p.normalize(quiPackageDirectory.path)));
    });

    test('when a package root belongs to the current build package, it should accept the root', () {
      final validatedRoot = PackageRootResolver.validatePackageRoot(
        packageName: 'qui',
        packageRoot: quiPackageDirectory.path,
      );

      expect(validatedRoot, equals(quiPackageDirectory.path));
    });

    test('when a package root belongs to another package, it should reject the root', () {
      File(p.join(workspaceDirectory.path, 'pubspec.yaml')).writeAsStringSync('name: cataqui_workspace');

      expect(
        () => PackageRootResolver.validatePackageRoot(packageName: 'qui', packageRoot: workspaceDirectory.path),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
