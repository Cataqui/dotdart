import 'package:build/build.dart';

import '../generators/generated_asset_spec.dart';

/// A generated asset specification paired with its build graph identifier.
class DiscoveredAsset {
  const DiscoveredAsset({required this.assetId, required this.spec});

  /// Source asset identifier in the build graph.
  final AssetId assetId;

  /// Immutable generation contract for the asset.
  final GeneratedAssetSpec spec;
}
