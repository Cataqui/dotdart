import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

void main() {
  test(
    'when a consumer generates every supported asset type, it should analyze and render the real generated output',
    () async {
      final fixture = GeneratedConsumerFixture(packageRoot: Directory.current);

      expect(await fixture.verify(), isTrue);
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );
}

class GeneratedConsumerFixture {
  const GeneratedConsumerFixture({required this.packageRoot});

  final Directory packageRoot;

  Future<bool> verify() async {
    final fixtureDirectory = Directory('${packageRoot.path}/build/generated_consumer_fixture');
    if (fixtureDirectory.existsSync()) fixtureDirectory.deleteSync(recursive: true);
    fixtureDirectory.createSync(recursive: true);
    _copyDirectory(Directory('${packageRoot.path}/test/fixtures/generated_consumer'), fixtureDirectory);
    _writePubspec(fixtureDirectory);
    _writeRasterAssets(fixtureDirectory);

    final flutterRoot = Platform.environment['FLUTTER_ROOT'];
    if (flutterRoot == null) {
      throw StateError('FLUTTER_ROOT is required for the generated consumer fixture.');
    }
    final flutter = '$flutterRoot/bin/flutter';
    final dart = '$flutterRoot/bin/dart';
    await _run(executable: flutter, arguments: const ['pub', 'get'], workingDirectory: fixtureDirectory.path);
    await _run(
      executable: dart,
      arguments: const ['run', 'build_runner', 'build', '--delete-conflicting-outputs'],
      workingDirectory: fixtureDirectory.path,
    );
    await _run(executable: dart, arguments: const ['analyze', 'lib', 'test'], workingDirectory: fixtureDirectory.path);
    await _run(executable: flutter, arguments: const ['test'], workingDirectory: fixtureDirectory.path);
    return true;
  }

  void _copyDirectory(Directory source, Directory destination) {
    for (final entity in source.listSync(recursive: true, followLinks: false)) {
      final relativePath = entity.path.substring(source.path.length + 1);
      final destinationPath = '${destination.path}/$relativePath';
      if (entity is Directory) {
        Directory(destinationPath).createSync(recursive: true);
        continue;
      }
      if (entity is File) {
        File(destinationPath)
          ..parent.createSync(recursive: true)
          ..writeAsBytesSync(entity.readAsBytesSync());
      }
    }
  }

  void _writePubspec(Directory fixtureDirectory) {
    final template = File('${fixtureDirectory.path}/pubspec.yaml.template');
    final pubspec = template.readAsStringSync().replaceAll('DOTDART_PACKAGE_PATH', packageRoot.absolute.path);
    File('${fixtureDirectory.path}/pubspec.yaml').writeAsStringSync(pubspec);
    template.deleteSync();
    File(
      '${fixtureDirectory.path}/test/generated_widgets_test.dart.template',
    ).renameSync('${fixtureDirectory.path}/test/generated_widgets_test.dart');
  }

  void _writeRasterAssets(Directory fixtureDirectory) {
    final assetDirectory = Directory('${fixtureDirectory.path}/assets/images')..createSync(recursive: true);
    File(
      '${assetDirectory.path}/landscape.png',
    ).writeAsBytesSync(img.encodePng(img.Image(width: 80, height: 40)..clear(img.ColorRgb8(255, 74, 75))));
    File(
      '${assetDirectory.path}/portrait.png',
    ).writeAsBytesSync(img.encodePng(img.Image(width: 40, height: 80)..clear(img.ColorRgb8(74, 75, 255))));
    final firstFrame = img.Image(width: 16, height: 16)..clear(img.ColorRgb8(255, 74, 75));
    final secondFrame = img.Image(width: 16, height: 16)..clear(img.ColorRgb8(74, 255, 75));
    final gifEncoder = img.GifEncoder()
      ..addFrame(firstFrame, duration: 10)
      ..addFrame(secondFrame, duration: 10);
    File('${assetDirectory.path}/animated.gif').writeAsBytesSync(gifEncoder.finish()!);
  }

  Future<void> _run({
    required String executable,
    required List<String> arguments,
    required String workingDirectory,
  }) async {
    final result = await Process.run(executable, arguments, workingDirectory: workingDirectory);
    if (result.exitCode == 0) return;
    throw StateError(
      '$executable ${arguments.join(' ')} failed with ${result.exitCode}.\n'
      '${result.stdout}\n${result.stderr}',
    );
  }
}
