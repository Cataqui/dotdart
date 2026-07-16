import 'dart:io';

import 'package:dotdart/src/builders/generated_output_ownership.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GeneratedOutputOwnership', () {
    late Directory packageDirectory;
    late Directory outputDirectory;

    setUp(() {
      packageDirectory = Directory.systemTemp.createTempSync('dotdart_ownership_');
      outputDirectory = Directory('${packageDirectory.path}/lib/gen')..createSync(recursive: true);
    });

    tearDown(() {
      packageDirectory.deleteSync(recursive: true);
    });

    test('when an owned output is no longer generated, it should report the stale path', () {
      File('${outputDirectory.path}/old.g.dart').writeAsStringSync(
        '''
// GENERATED CODE - DO NOT MODIFY BY HAND
// *****************************************************
//  dotdart
'''
            .trimLeft(),
      );

      final stale = GeneratedOutputOwnership.collectStalePaths(
        packageRoot: packageDirectory.path,
        outputDir: 'lib/gen',
        currentPaths: const {},
      );

      expect(stale, equals(['lib/gen/old.g.dart']));
    });

    test('when a foreign generated output shares the directory, it should preserve the file', () {
      File('${outputDirectory.path}/foreign.g.dart').writeAsStringSync('// GENERATED CODE - flutter_gen');

      final stale = GeneratedOutputOwnership.collectStalePaths(
        packageRoot: packageDirectory.path,
        outputDir: 'lib/gen',
        currentPaths: const {},
      );

      expect(stale, isEmpty);
    });
  });
}
