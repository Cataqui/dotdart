import 'package:dotdart/src/builders/dotdart_config_parser.dart';
import 'package:dotdart/src/generators/generated_asset_spec.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DotdartConfigParser', () {
    test('when dotdart is absent, it should return null', () {
      expect(DotdartConfigParser.parse('name: example'), isNull);
    });

    test('when an unknown key is configured, it should reject the key', () {
      expect(
        () => DotdartConfigParser.parse('''
dotdart:
  video:
    - assets/video/
'''),
        throwsA(isA<FormatException>()),
      );
    });

    test('when an asset configuration is not a list, it should reject the configuration', () {
      expect(
        () => DotdartConfigParser.parse('''
dotdart:
  image: assets/images/
'''),
        throwsA(isA<FormatException>()),
      );
    });

    test('when two asset types configure the same path, it should reject the duplicate', () {
      expect(
        () => DotdartConfigParser.parse('''
dotdart:
  image:
    - assets/shared/
  svg:
    - assets/shared/
'''),
        throwsA(isA<FormatException>()),
      );
    });

    test('when an input escapes the package, it should reject traversal', () {
      expect(
        () => DotdartConfigParser.parse('''
dotdart:
  svg:
    - ../icons/
'''),
        throwsA(isA<FormatException>()),
      );
    });

    test('when valid inputs are configured, it should normalize them by asset type', () {
      final config = DotdartConfigParser.parse('''
dotdart:
  output: lib/generated/
  svg:
    - assets/./icons/
''');

      expect(config?.inputs[DotdartAssetType.svg], equals(['assets/icons']));
    });
  });
}
