import 'package:build/build.dart';
import 'package:dotdart/dotdart.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('dotdartBuilder', () {
    test('when build runner asks for the dotdart builder, it should return a builder instance', () {
      final builder = dotdartBuilder(const BuilderOptions({}));

      expect(builder, isA<Builder>());
    });

    test('when the builder is created, it should declare build extensions', () {
      final builder = dotdartBuilder(const BuilderOptions({}));

      expect(builder.buildExtensions, isNotEmpty);
      expect(builder.buildExtensions.containsKey(r'$package$'), isTrue);
    });
  });

  group('dotdartPostProcessBuilder', () {
    test(
      'when build runner asks for the dotdart post-process builder, it should return a post-process builder instance',
      () {
        final builder = dotdartPostProcessBuilder(const BuilderOptions({}));

        expect(builder, isA<PostProcessBuilder>());
      },
    );

    test('when the post-process builder is created, it should declare input extensions', () {
      final builder = dotdartPostProcessBuilder(const BuilderOptions({}));

      expect(builder.inputExtensions, isNotEmpty);
    });
  });
}
