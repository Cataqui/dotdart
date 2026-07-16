import 'package:dotdart/src/generators/accessor_param.dart';
import 'package:dotdart/src/generators/generated_asset_spec.dart';
import 'package:dotdart/src/generators/namespace_assembler.dart';
import 'package:dotdart/src/generators/naming.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  const crossAsset = GeneratedAssetSpec(
    sourcePath: 'assets/icons/cross.svg',
    accessorName: 'cross',
    widgetClassName: '_Cross',
    params: [
      AccessorParam(name: 'key', type: 'Key?'),
      AccessorParam(name: 'width', type: 'double?'),
      AccessorParam(name: 'height', type: 'double?'),
      AccessorParam(name: 'color1', type: 'Color?'),
    ],
    widgetSource: 'class _Cross extends StatelessWidget {}',
    assetType: DotdartAssetType.svg,
  );

  const phoneAsset = GeneratedAssetSpec(
    sourcePath: 'assets/icons/phone.svg',
    accessorName: 'phone',
    widgetClassName: '_Phone',
    params: [
      AccessorParam(name: 'key', type: 'Key?'),
      AccessorParam(name: 'width', type: 'double?'),
      AccessorParam(name: 'height', type: 'double?'),
      AccessorParam(name: 'color1', type: 'Color?'),
    ],
    widgetSource: 'class _Phone extends StatelessWidget {}',
    assetType: DotdartAssetType.svg,
  );

  const lottieAsset = GeneratedAssetSpec(
    sourcePath: 'assets/lotties/swipe_up_animation.json',
    accessorName: 'swipeUpAnimation',
    widgetClassName: '_SwipeUpAnimation',
    params: [
      AccessorParam(name: 'key', type: 'Key?'),
      AccessorParam(name: 'respectDisableAnimations', type: 'bool', defaultValue: 'true'),
    ],
    widgetSource: 'class _SwipeUpAnimation extends StatefulWidget {}',
    assetType: DotdartAssetType.lottie,
  );

  const rasterAsset = GeneratedAssetSpec(
    sourcePath: 'assets/images/landscape.png',
    accessorName: 'landscape',
    widgetClassName: '_Landscape',
    params: [AccessorParam(name: 'key', type: 'Key?')],
    widgetSource: 'class _Landscape extends StatelessWidget {}',
    assetType: DotdartAssetType.raster,
    cacheKey: 'assets/images/landscape.png',
  );

  group('NamespaceAssembler', () {
    test('when assembling a namespace with one asset, it should include the generated code header', () {
      final assembler = NamespaceAssembler(namespaceName: 'Icons', folderSegment: 'icons', assets: [crossAsset]);
      final code = assembler.assemble();

      expect(code, allOf(contains('// GENERATED CODE - DO NOT MODIFY BY HAND'), contains('//  dotdart')));
    });

    test('when assembling a namespace with one asset, it should include the coverage ignore directive', () {
      final assembler = NamespaceAssembler(namespaceName: 'Icons', folderSegment: 'icons', assets: [crossAsset]);
      final code = assembler.assemble();

      expect(code, contains('// coverage:ignore-file'));
    });

    test('when assembling a namespace, it should include the correct imports', () {
      final assembler = NamespaceAssembler(namespaceName: 'Icons', folderSegment: 'icons', assets: [crossAsset]);
      final code = assembler.assemble();

      expect(
        code,
        allOf(
          contains("import 'dart:math' as math;"),
          contains("import 'package:flutter/material.dart';"),
          contains("import 'package:flutter/rendering.dart' show OverflowBoxFit;"),
        ),
      );
    });

    test('when assembling a namespace, it should emit the abstract final class with dollar prefix', () {
      final assembler = NamespaceAssembler(namespaceName: 'Icons', folderSegment: 'icons', assets: [crossAsset]);
      final code = assembler.assemble();

      expect(code, contains(r'abstract final class $Icons {'));
    });

    test('when assembling a namespace with one asset, it should emit one accessor method', () {
      final assembler = NamespaceAssembler(namespaceName: 'Icons', folderSegment: 'icons', assets: [crossAsset]);
      final code = assembler.assemble();

      expect(code, contains('static Widget cross({'));
      expect(code, contains('double? width,'));
      expect(code, contains('double? height,'));
      expect(code, contains('Color? color1,'));
    });

    test('when assembling a namespace with one asset, the accessor should delegate to the widget constructor', () {
      final assembler = NamespaceAssembler(namespaceName: 'Icons', folderSegment: 'icons', assets: [crossAsset]);
      final code = assembler.assemble();

      expect(code, contains('_Cross('));
    });

    test(
      'when assembling a namespace with multiple assets, it should emit one accessor per asset in alphabetical order',
      () {
        const arrowAsset = GeneratedAssetSpec(
          sourcePath: 'assets/icons/arrow.svg',
          accessorName: 'arrow',
          widgetClassName: '_Arrow',
          params: [AccessorParam(name: 'key', type: 'Key?')],
          widgetSource: 'class _Arrow extends StatelessWidget {}',
          assetType: DotdartAssetType.svg,
        );
        final assembler = NamespaceAssembler(
          namespaceName: 'Icons',
          folderSegment: 'icons',
          assets: [arrowAsset, crossAsset, phoneAsset],
        );
        final code = assembler.assemble();

        final arrowIdx = code.indexOf('static Widget arrow({');
        final crossIdx = code.indexOf('static Widget cross({');
        final phoneIdx = code.indexOf('static Widget phone({');

        expect(arrowIdx, lessThan(crossIdx));
        expect(crossIdx, lessThan(phoneIdx));
      },
    );

    test('when assembling a namespace, it should include all widget classes after the namespace class', () {
      final assembler = NamespaceAssembler(
        namespaceName: 'Icons',
        folderSegment: 'icons',
        assets: [crossAsset, phoneAsset],
      );
      final code = assembler.assemble();

      final namespaceClassEnd = code.indexOf(r'abstract final class $Icons {');
      expect(namespaceClassEnd, greaterThan(0));
      expect(code, contains('class _Cross extends StatelessWidget {}'));
      expect(code, contains('class _Phone extends StatelessWidget {}'));
    });

    test(
      'when assembling a namespace with a param that has a default value, it should include the default in the accessor',
      () {
        final assembler = NamespaceAssembler(namespaceName: 'Lotties', folderSegment: 'lotties', assets: [lottieAsset]);
        final code = assembler.assemble();

        expect(code, contains('bool respectDisableAnimations = true'));
      },
    );

    test('when using naming helpers with underscore filenames, it should produce correct accessor names', () {
      final arrowLeft = Naming.accessorName('assets/icons/arrow_left.svg');
      final exclamationCircle = Naming.accessorName('assets/icons/exclamation_circle.svg');
      final swipeUp = Naming.accessorName('assets/lottie/swipe_up_phone_animation.json');

      expect(arrowLeft, 'arrowLeft');
      expect(exclamationCircle, 'exclamationCircle');
      expect(swipeUp, 'swipeUpPhoneAnimation');
    });

    test('when using naming helpers, it should produce correct namespace names', () {
      expect(Naming.namespaceNameFromFolder('icons'), 'Icons');
      expect(Naming.namespaceNameFromFolder('lotties'), 'Lotties');
      expect(Naming.namespaceNameFromFolder('my_icons'), 'MyIcons');
    });

    test('when assembling SVG assets, it should emit the shared _dotdartApplyOpacity function', () {
      final assembler = NamespaceAssembler(namespaceName: 'Icons', folderSegment: 'icons', assets: [crossAsset]);
      final code = assembler.assemble();

      expect(code, contains('Color _dotdartApplyOpacity(Color color, double opacity)'));
    });

    test('when assembling SVG assets, it should emit the shared _DotdartSvgSizing mixin', () {
      final assembler = NamespaceAssembler(namespaceName: 'Icons', folderSegment: 'icons', assets: [crossAsset]);
      final code = assembler.assemble();

      expect(code, contains('mixin _DotdartSvgSizing on StatelessWidget'));
    });

    test('when assembling SVG assets, it should not emit the Lottie animation state mixin', () {
      final assembler = NamespaceAssembler(namespaceName: 'Icons', folderSegment: 'icons', assets: [crossAsset]);
      final code = assembler.assemble();

      expect(code, isNot(contains('_DotdartLottieAnimationState')));
    });

    test('when assembling Lottie assets, it should emit the shared _DotdartLottieAnimationState mixin', () {
      final assembler = NamespaceAssembler(namespaceName: 'Lotties', folderSegment: 'lotties', assets: [lottieAsset]);
      final code = assembler.assemble();

      expect(code, contains('mixin _DotdartLottieAnimationState<T extends StatefulWidget>'));
    });

    test('when assembling Lottie assets, it should not emit the SVG sizing mixin', () {
      final assembler = NamespaceAssembler(namespaceName: 'Lotties', folderSegment: 'lotties', assets: [lottieAsset]);
      final code = assembler.assemble();

      expect(code, isNot(contains('_DotdartSvgSizing')));
    });

    test('when assembling mixed asset types, it should emit both shared mixins', () {
      final assembler = NamespaceAssembler(
        namespaceName: 'Mixed',
        folderSegment: 'mixed',
        assets: [crossAsset, lottieAsset],
      );
      final code = assembler.assemble();

      expect(code, allOf(contains('_DotdartSvgSizing'), contains('_DotdartLottieAnimationState')));
    });

    test('when assembling Lottie assets, the accessor doc should reference .json extension', () {
      final assembler = NamespaceAssembler(namespaceName: 'Lotties', folderSegment: 'lotties', assets: [lottieAsset]);
      final code = assembler.assemble();

      expect(code, contains('swipeUpAnimation.json'));
    });

    test('when assembling SVG assets, the accessor doc should reference .svg extension', () {
      final assembler = NamespaceAssembler(namespaceName: 'Icons', folderSegment: 'icons', assets: [crossAsset]);
      final code = assembler.assemble();

      expect(code, contains('cross.svg'));
    });

    test('when assembling raster assets, it should expose precache without public cache keys', () {
      final assembler = NamespaceAssembler(namespaceName: 'Images', folderSegment: 'images', assets: [rasterAsset]);
      final code = assembler.assemble();

      expect(code, allOf(contains('static Future<void> precache(BuildContext context)'), isNot(contains('CacheKey'))));
    });
  });
}
