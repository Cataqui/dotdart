// StringBuffer.writeln returns void. Cascading void calls is valid Dart but
// makes the code harder to read. This is a known false positive.
// ignore_for_file: cascade_invocations

import 'package:dart_style/dart_style.dart';

import 'accessor_param.dart';
import 'shared_emit.dart';

/// The kind of asset a generated widget represents.
///
/// Determines which shared mixins/helpers [NamespaceAssembler] emits at the
/// top of the file.
enum DotdartAssetType {
  /// A static SVG widget (uses `_DotdartSvgSizing` mixin).
  svg,

  /// An animated Lottie widget (uses `_DotdartLottieAnimationState` mixin).
  lottie,

  /// A raster image widget (uses thumbhash decoder + frameBuilder).
  raster,
}

/// A single asset ready to be placed into a namespace file.
class AssembledAsset {
  const AssembledAsset({
    required this.accessorName,
    required this.widgetClassName,
    required this.params,
    required this.widgetSource,
    required this.assetType,
    this.cacheKey,
  });

  /// lowerCamelCase accessor name (e.g. `cross`, `exclamationCircle`).
  final String accessorName;

  /// PascalCase widget class name (e.g. `Cross`, `ExclamationCircle`).
  final String widgetClassName;

  /// Constructor parameters of the generated widget.
  final List<AccessorParam> params;

  /// Raw Dart source of the widget class(es) and painter.
  /// No header, no imports — not pre-formatted.
  final String widgetSource;

  /// The asset type, used to determine which shared code to emit.
  final DotdartAssetType assetType;

  /// The asset cache key (raster assets only). Null for non-raster types.
  final String? cacheKey;
}

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
  NamespaceAssembler({
    required this.namespaceName,
    required this.folderSegment,
    required this.assets,
  });

  /// PascalCase namespace name without the `$` prefix (e.g. `Icons`).
  final String namespaceName;

  /// Lowercase folder segment for the doc comment (e.g. `icons`).
  final String folderSegment;

  /// Assets sorted alphabetically by [AssembledAsset.accessorName].
  final List<AssembledAsset> assets;

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
    b.writeln('// ignore_for_file: type=lint, unused_import, unused_element, unused_element_parameter');
    b.writeln();
  }

  void _writeImports(StringBuffer b) {
    b.writeln("import 'dart:math' as math;");
    b.writeln("import 'package:flutter/material.dart';");
    b.writeln("import 'package:flutter/rendering.dart' show OverflowBoxFit;");
    b.writeln();
  }

  void _writeSharedCode(StringBuffer b) {
    final types = assets.map((a) => a.assetType).toSet();
    b.write(SharedEmitter.applyOpacityFunction());
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
      b.writeln('    await Future.wait([');
      for (final asset in assets) {
        if (asset.cacheKey != null) {
          b.writeln("      precacheImage(AssetImage('${asset.cacheKey}'), context),");
        }
      }
      b.writeln('    ]);');
      b.writeln('  }');
      b.writeln();
    }

    b.writeln('}');
    b.writeln();
  }

  void _writeAccessorMethod(StringBuffer b, AssembledAsset asset) {
    final docPrefix = asset.accessorName[0].toUpperCase() + asset.accessorName.substring(1);
    final fileExt = switch (asset.assetType) {
      DotdartAssetType.svg => 'svg',
      DotdartAssetType.lottie => 'json',
      DotdartAssetType.raster => 'image',
    };
    b.writeln('  /// Builds the `$docPrefix` widget from `${asset.accessorName}.$fileExt`.');
    b.writeln('  static Widget ${asset.accessorName}({');

    for (var i = 0; i < asset.params.length; i++) {
      final param = asset.params[i];
      if (param.required) {
        b.writeln('    required ${param.type} ${param.name},');
      } else if (param.defaultValue != null) {
        b.writeln('    ${param.type} ${param.name} = ${param.defaultValue},');
      } else {
        b.writeln('    ${param.type} ${param.name},');
      }
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
