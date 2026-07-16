// StringBuffer.writeln returns void. Cascading void calls is valid Dart but
// makes the code harder to read. This is a known false positive.
// ignore_for_file: cascade_invocations

import 'package:dart_style/dart_style.dart';

import 'generated_asset_spec.dart';
import 'shared_emit.dart';

/// Assembles a complete `.g.dart` file for one namespace.
///
/// Produces a file containing:
/// 1. Generated-code header + imports
/// 2. Shared mixins/helpers (deduplicated once per file)
/// 3. `abstract final class $NamespaceName` with one static method per asset
/// 4. All widget class + painter definitions
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
    for (final asset in assets) {
      b.write(asset.widgetSource);
    }
    return DartFormatter(languageVersion: DartFormatter.latestLanguageVersion).format(b.toString());
  }

  String get _className => '\$$namespaceName';

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
    final hasRaster = assets.any((a) => a.assetType == DotdartAssetType.raster);

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

    if (hasRaster) {
      b.writeln('  /// Precaches all images in this namespace.');
      b.writeln('  ///');
      b.writeln('  /// Call during app bootstrap (off the critical path) to warm the image');
      b.writeln('  /// cache so the first render never stalls on a cold decode.');
      b.writeln('  static Future<void> precache(BuildContext context) async {');
      final rasterAssets = assets.where((asset) => asset.cacheKey != null).toList(growable: false);
      for (var index = 0; index < rasterAssets.length; index++) {
        final asset = rasterAssets[index];
        if (asset.cacheKey != null) {
          b.writeln("    await precacheImage(const AssetImage('${asset.cacheKey}'), context);");
          if (index < rasterAssets.length - 1) {
            b.writeln('    if (!context.mounted) return;');
          }
        }
      }
      b.writeln('  }');
      b.writeln();
    }

    b.writeln('}');
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
}
