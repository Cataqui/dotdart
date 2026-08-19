// StringBuffer.writeln returns void. Cascading void calls is valid Dart but
// makes the code harder to read. This is a known false positive.
// ignore_for_file: cascade_invocations

import 'package:dart_style/dart_style.dart';

import 'generated_asset_spec.dart';
import 'image_generator.dart';
import 'shared_emit.dart';

/// Assembles a complete `.g.dart` file for one namespace.
///
/// Produces a file containing:
/// 1. Generated-code header + imports
/// 2. Shared mixins/helpers (deduplicated once per file)
/// 3. `abstract final class $NamespaceName` with one static method per asset
/// 4. A companion cache class when the namespace contains images or GIFs
/// 5. All widget class + painter definitions
///
/// The [namespaceName] is the PascalCase identifier (e.g. `Icons` — the
/// assembler prepends `$` for the class name).
class NamespaceAssembler {
  NamespaceAssembler({required this.namespaceName, required this.folderSegment, required this.assets});

  /// PascalCase namespace name without the `$` prefix (e.g. `Icons`).
  final String namespaceName;

  /// Lowercase folder segment for the doc comment (e.g. `icons`).
  final String folderSegment;

  /// Assets sorted alphabetically by [GeneratedAssetSpec.accessorName].
  final List<GeneratedAssetSpec> assets;

  /// Produces the complete, formatted Dart source for the namespace file.
  String assemble() {
    final b = StringBuffer();
    _writeHeader(b);
    _writeImports(b);
    _writeSharedCode(b);
    _writeNamespaceClass(b);
    _writeCacheClass(b);
    for (final asset in assets) {
      b.write(asset.widgetSource);
    }
    return DartFormatter(languageVersion: DartFormatter.latestLanguageVersion).format(b.toString());
  }

  String get _className => '\$$namespaceName';

  String get _cacheClassName => '\$${namespaceName}Cache';

  void _writeHeader(StringBuffer b) {
    b.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
    b.writeln('// *****************************************************');
    b.writeln('//  dotdart');
    b.writeln('// *****************************************************');
    b.writeln();
    b.writeln('// coverage:ignore-file');
    b.writeln('// Generated canvas and paint sequences intentionally use repeated receiver calls.');
    b.writeln('// ignore_for_file: cascade_invocations, unused_element, unused_element_parameter');
    b.writeln();
  }

  void _writeImports(StringBuffer b) {
    final types = assets.map((asset) => asset.assetType).toSet();
    if (types.contains(DotdartAssetType.lottie)) {
      b.writeln("import 'dart:async';");
    }
    b.writeln("import 'dart:math' as math;");
    b.writeln("import 'package:flutter/material.dart';");
    if (types.contains(DotdartAssetType.svg) || types.contains(DotdartAssetType.lottie)) {
      b.writeln("import 'package:flutter/rendering.dart' show OverflowBoxFit;");
    }
    b.writeln();
  }

  void _writeSharedCode(StringBuffer b) {
    final types = assets.map((a) => a.assetType).toSet();
    if (types.contains(DotdartAssetType.svg) || types.contains(DotdartAssetType.lottie)) {
      b.write(SharedEmitter.applyOpacityFunction());
    }
    if (types.contains(DotdartAssetType.svg)) {
      b.write(SharedEmitter.svgSizingMixin());
    }
    if (types.contains(DotdartAssetType.lottie)) {
      b.write(SharedEmitter.lottieAnimationStateMixin());
    }
    if (types.contains(DotdartAssetType.raster)) {
      b.write(SharedEmitter.thumbhashCode());
    }
  }

  void _writeNamespaceClass(StringBuffer b) {
    final className = _className;

    b.writeln('/// Namespace for dotdart-generated widgets from `$folderSegment/`.');
    b.writeln('///');
    b.writeln('/// Call a method named after each asset to render it:');
    b.writeln('///');
    for (final asset in assets) {
      b.writeln('/// ```dart');
      b.writeln('/// $className.${asset.accessorName}(<params>);');
      b.writeln('/// ```');
    }
    b.writeln('abstract final class $className {');
    b.writeln('  $className._();');
    b.writeln();

    for (final asset in assets) {
      _writeAccessorMethod(b, asset);
    }

    b.writeln('}');
    b.writeln();
  }

  void _writeCacheClass(StringBuffer b) {
    final rasterAssets = assets.where((asset) => asset.assetType == DotdartAssetType.raster).toList(growable: false);
    if (rasterAssets.isEmpty) return;

    final cacheClassName = _cacheClassName;
    b.writeln('/// Manages Flutter image-cache entries for `$folderSegment/`.');
    b.writeln('///');
    b.writeln('/// Use the same width and height when caching, rendering, and removing');
    b.writeln('/// an image so every operation addresses the same decoded entry.');
    b.writeln('abstract final class $cacheClassName {');
    b.writeln('  $cacheClassName._();');
    b.writeln();

    for (final asset in rasterAssets) {
      final cacheKey = asset.cacheKey;
      if (cacheKey == null || asset.cacheAspectRatio == null) {
        throw StateError('Image asset `${asset.sourcePath}` is missing cache metadata.');
      }
      b.writeln("  static const _${asset.accessorName}Asset = AssetImage('$cacheKey');");
    }
    b.writeln();

    for (final asset in rasterAssets) {
      _writeCacheMethods(b, asset);
    }

    _writeCacheProvider(b);

    b.writeln('}');
    b.writeln();
  }

  void _writeCacheMethods(StringBuffer b, GeneratedAssetSpec asset) {
    final methodSuffix = asset.accessorName[0].toUpperCase() + asset.accessorName.substring(1);
    final assetProviderName = '_${asset.accessorName}Asset';
    final aspectRatio = _formatNumber(asset.cacheAspectRatio!);

    b.writeln('  /// Decodes `${asset.accessorName}` before its first render.');
    b.writeln('  ///');
    b.writeln('  /// [width] and [height] are logical pixels. Pass the same values to');
    b.writeln('  /// `$_className.${asset.accessorName}` so it reuses this cache entry.');
    b.writeln("  /// Omitting both values uses the widget's default display size.");
    b.writeln('  static Future<void> precache$methodSuffix(');
    b.writeln('    BuildContext context, {');
    b.writeln('    double? width,');
    b.writeln('    double? height,');
    b.writeln('  }) =>');
    b.writeln('      precacheImage(');
    b.writeln('        _provider(');
    b.writeln('          context,');
    b.writeln('          asset: $assetProviderName,');
    b.writeln('          aspectRatio: $aspectRatio,');
    b.writeln('          width: width,');
    b.writeln('          height: height,');
    b.writeln('        ),');
    b.writeln('        context,');
    b.writeln('      );');
    b.writeln();
    b.writeln("  /// Removes the decoded `${asset.accessorName}` entry from Flutter's image cache.");
    b.writeln('  ///');
    b.writeln('  /// Returns whether the matching entry existed. [width] and [height]');
    b.writeln('  /// must match the values used to precache or render the image.');
    b.writeln('  /// An image that is still displayed remains live until its last listener');
    b.writeln('  /// is removed, preventing a duplicate decode during transitions.');
    b.writeln('  static Future<bool> remove$methodSuffix(');
    b.writeln('    BuildContext context, {');
    b.writeln('    double? width,');
    b.writeln('    double? height,');
    b.writeln('  }) async {');
    b.writeln('    final configuration = createLocalImageConfiguration(context);');
    b.writeln('    final provider = _provider(');
    b.writeln('      context,');
    b.writeln('      asset: $assetProviderName,');
    b.writeln('      aspectRatio: $aspectRatio,');
    b.writeln('      width: width,');
    b.writeln('      height: height,');
    b.writeln('    );');
    b.writeln('    final key = await provider.obtainKey(configuration);');
    b.writeln('    return imageCache.evict(key, includeLive: false);');
    b.writeln('  }');
    b.writeln();
  }

  void _writeCacheProvider(StringBuffer b) {
    b.writeln('  static ImageProvider<Object> _provider(');
    b.writeln('    BuildContext context, {');
    b.writeln('    required AssetImage asset,');
    b.writeln('    required double aspectRatio,');
    b.writeln('    double? width,');
    b.writeln('    double? height,');
    b.writeln('  }) {');
    b.writeln("    assert(width == null || width > 0, 'width must be greater than zero.');");
    b.writeln("    assert(height == null || height > 0, 'height must be greater than zero.');");
    b.writeln(
      '    final resolvedWidth = width ?? '
      '(height != null ? height * aspectRatio : ${ImageGenerator.defaultWidth});',
    );
    b.writeln('    final resolvedHeight = height ?? resolvedWidth / aspectRatio;');
    b.writeln('    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);');
    b.writeln('    return ResizeImage.resizeIfNeeded(');
    b.writeln('      (resolvedWidth * devicePixelRatio).ceil(),');
    b.writeln('      (resolvedHeight * devicePixelRatio).ceil(),');
    b.writeln('      asset,');
    b.writeln('    );');
    b.writeln('  }');
    b.writeln();
  }

  void _writeAccessorMethod(StringBuffer b, GeneratedAssetSpec asset) {
    final docPrefix = asset.accessorName[0].toUpperCase() + asset.accessorName.substring(1);
    final fileExt = asset.assetType.documentationExtension;
    b.writeln('  /// Builds the `$docPrefix` widget from `${asset.accessorName}.$fileExt`.');
    b.writeln('  static Widget ${asset.accessorName}({');

    for (var i = 0; i < asset.params.length; i++) {
      final param = asset.params[i];
      if (param.required) {
        b.writeln('    ${param.signature},');
        continue;
      }
      b.writeln('    ${param.signature},');
    }

    b.writeln('  }) =>');
    b.writeln('      ${asset.widgetClassName}(');

    for (var i = 0; i < asset.params.length; i++) {
      final param = asset.params[i];
      final comma = i < asset.params.length - 1 ? ',' : '';
      b.writeln('        ${param.name}: ${param.name}$comma');
    }

    b.writeln('      );');
    b.writeln();
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toString();
  }
}
