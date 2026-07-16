import 'accessor_param.dart';

part 'generated_asset_spec_enums.dart';

/// Immutable source of truth for one asset throughout generation.
class GeneratedAssetSpec {
  const GeneratedAssetSpec({
    required this.sourcePath,
    required this.accessorName,
    required this.widgetClassName,
    required this.params,
    required this.widgetSource,
    required this.assetType,
    this.cacheKey,
  });

  /// Source path relative to the consumer package.
  final String sourcePath;

  /// Public lowerCamelCase accessor name.
  final String accessorName;

  /// Library-private generated widget class name.
  final String widgetClassName;

  /// Parameters shared by the widget constructor and namespace accessor.
  final List<AccessorParam> params;

  /// Generated widget source without file imports or header.
  final String widgetSource;

  /// Pipeline responsible for this asset.
  final DotdartAssetType assetType;

  /// Flutter asset path used by generated raster precaching.
  final String? cacheKey;
}
