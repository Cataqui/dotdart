part of 'generated_asset_spec.dart';

/// The kind of asset represented by generated output.
enum DotdartAssetType {
  /// A static SVG widget.
  svg,

  /// An animated Lottie widget.
  lottie,

  /// A raster image widget.
  raster;

  /// Configuration key in `pubspec.yaml`.
  String get configKey => switch (this) {
    DotdartAssetType.svg => 'svg',
    DotdartAssetType.lottie => 'lottie',
    DotdartAssetType.raster => 'image',
  };

  /// Source extension used in generated documentation.
  String get documentationExtension => switch (this) {
    DotdartAssetType.svg => 'svg',
    DotdartAssetType.lottie => 'json',
    DotdartAssetType.raster => 'image',
  };

  /// Supported source extensions, including the leading dot.
  List<String> get extensions => switch (this) {
    DotdartAssetType.svg => const ['.svg'],
    DotdartAssetType.lottie => const ['.json'],
    DotdartAssetType.raster => const ['.webp', '.png', '.jpg', '.jpeg', '.gif'],
  };
}
