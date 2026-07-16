import '../generators/generated_asset_spec.dart';

/// Validated dotdart configuration read from a consumer pubspec.
class DotdartConfig {
  const DotdartConfig({required this.outputDir, required this.inputs});

  /// Package-relative generated output directory.
  final String outputDir;

  /// Normalized source inputs grouped by asset type.
  final Map<DotdartAssetType, List<String>> inputs;
}
