import 'package:dotdart/src/builders/dotdart_namespace_collision_exception.dart';
import 'package:dotdart/src/builders/generated_namespace_validator.dart';
import 'package:dotdart/src/generators/generated_asset_spec.dart';
import 'package:dotdart/src/generators/naming.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GeneratedNamespaceValidator', () {
    for (final filename in ['find_by_name.svg', 'find-by-name.json', 'find by name.png']) {
      test('when $filename claims the lookup method, it should explain how to resolve the collision', () {
        final asset = GeneratedAssetSpec(
          sourcePath: 'assets/icons/$filename',
          accessorName: Naming.accessorName('assets/icons/$filename'),
          widgetClassName: '_FindByName',
          params: [],
          widgetSource: '',
          assetType: DotdartAssetType.svg,
        );

        expect(
          () => GeneratedNamespaceValidator.validate(folderSegment: 'icons', assets: [asset]),
          throwsA(
            isA<DotdartNamespaceCollisionException>().having(
              (error) => error.message,
              'message',
              allOf(contains('assets/icons/$filename'), contains('findByName'), contains('Rename')),
            ),
          ),
        );
      });
    }

    test('when normalized filenames produce the same accessor, it should reject both source paths', () {
      const assets = [
        GeneratedAssetSpec(
          sourcePath: 'assets/icons/foo_bar.svg',
          accessorName: 'fooBar',
          widgetClassName: '_FooBar',
          params: [],
          widgetSource: '',
          assetType: DotdartAssetType.svg,
        ),
        GeneratedAssetSpec(
          sourcePath: 'assets/icons/foo-bar.svg',
          accessorName: 'fooBar',
          widgetClassName: '_FooBarAlternative',
          params: [],
          widgetSource: '',
          assetType: DotdartAssetType.svg,
        ),
      ];

      expect(
        () => GeneratedNamespaceValidator.validate(folderSegment: 'icons', assets: assets),
        throwsA(isA<DotdartNamespaceCollisionException>()),
      );
    });

    test('when an image is named precache, it should allow the accessor', () {
      const assets = [
        GeneratedAssetSpec(
          sourcePath: 'assets/images/precache.webp',
          accessorName: 'precache',
          widgetClassName: '_Precache',
          params: [],
          widgetSource: '',
          assetType: DotdartAssetType.raster,
          cacheKey: 'assets/images/precache.webp',
          cacheAspectRatio: 1,
        ),
      ];

      expect(() => GeneratedNamespaceValidator.validate(folderSegment: 'images', assets: assets), returnsNormally);
    });

    test('when different asset types in one folder produce the same accessor, it should reject both source paths', () {
      const assets = [
        GeneratedAssetSpec(
          sourcePath: 'assets/icons/box.svg',
          accessorName: 'box',
          widgetClassName: '_Box',
          params: [],
          widgetSource: '',
          assetType: DotdartAssetType.svg,
        ),
        GeneratedAssetSpec(
          sourcePath: 'assets/icons/box.json',
          accessorName: 'box',
          widgetClassName: '_BoxAnimation',
          params: [],
          widgetSource: '',
          assetType: DotdartAssetType.lottie,
        ),
      ];

      expect(
        () => GeneratedNamespaceValidator.validate(folderSegment: 'icons', assets: assets),
        throwsA(
          isA<DotdartNamespaceCollisionException>()
              .having((error) => error.message, 'message', contains('assets/icons/box.svg'))
              .having((error) => error.message, 'message', contains('assets/icons/box.json')),
        ),
      );
    });
  });
}
