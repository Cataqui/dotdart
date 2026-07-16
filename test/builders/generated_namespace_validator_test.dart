import 'package:dotdart/src/builders/dotdart_namespace_collision_exception.dart';
import 'package:dotdart/src/builders/generated_namespace_validator.dart';
import 'package:dotdart/src/generators/generated_asset_spec.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GeneratedNamespaceValidator', () {
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

    test('when an asset produces the reserved precache helper name, it should reject the accessor', () {
      const assets = [
        GeneratedAssetSpec(
          sourcePath: 'assets/images/precache.webp',
          accessorName: 'precache',
          widgetClassName: '_Precache',
          params: [],
          widgetSource: '',
          assetType: DotdartAssetType.raster,
          cacheKey: 'assets/images/precache.webp',
        ),
      ];

      expect(
        () => GeneratedNamespaceValidator.validate(folderSegment: 'images', assets: assets),
        throwsA(isA<DotdartNamespaceCollisionException>()),
      );
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
