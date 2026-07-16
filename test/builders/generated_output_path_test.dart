import 'dart:io';

import 'package:dotdart/src/builders/generated_output_path.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GeneratedOutputPath', () {
    late Directory packageDirectory;

    setUp(() {
      packageDirectory = Directory.systemTemp.createTempSync('dotdart_output_path_');
    });

    tearDown(() {
      packageDirectory.deleteSync(recursive: true);
    });

    test('when contents use the exact dotdart header, it should recognize ownership', () {
      expect(
        GeneratedOutputPath.isDotdartOwned(
          '''
// GENERATED CODE - DO NOT MODIFY BY HAND
// *****************************************************
//  dotdart
'''
              .trimLeft(),
        ),
        isTrue,
      );
    });

    test('when contents belong to another generator, it should reject ownership', () {
      expect(GeneratedOutputPath.isDotdartOwned('// GENERATED CODE - other generator'), isFalse);
    });

    test('when an output traverses above the package, it should reject the path', () {
      expect(
        () => GeneratedOutputPath.resolve(packageRoot: packageDirectory.path, relativePath: '../outside.g.dart'),
        throwsA(isA<FormatException>()),
      );
    });

    test('when an output is absolute, it should reject the path', () {
      expect(
        () => GeneratedOutputPath.resolve(packageRoot: packageDirectory.path, relativePath: '/tmp/outside.g.dart'),
        throwsA(isA<FormatException>()),
      );
    });

    test('when an output parent is a symlink outside the package, it should reject the path', () {
      final outsideDirectory = Directory.systemTemp.createTempSync('dotdart_outside_');
      addTearDown(() => outsideDirectory.deleteSync(recursive: true));
      Link('${packageDirectory.path}/gen').createSync(outsideDirectory.path);

      expect(
        () => GeneratedOutputPath.resolve(packageRoot: packageDirectory.path, relativePath: 'gen/output.g.dart'),
        throwsA(isA<FormatException>()),
      );
    });

    test('when an existing output file is a symlink outside the package, it should reject the path', () {
      final outsideDirectory = Directory.systemTemp.createTempSync('dotdart_file_outside_');
      addTearDown(() => outsideDirectory.deleteSync(recursive: true));
      File('${outsideDirectory.path}/outside.g.dart').writeAsStringSync('foreign');
      Directory('${packageDirectory.path}/gen').createSync();
      Link('${packageDirectory.path}/gen/output.g.dart').createSync('${outsideDirectory.path}/outside.g.dart');

      expect(
        () => GeneratedOutputPath.resolve(packageRoot: packageDirectory.path, relativePath: 'gen/output.g.dart'),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
