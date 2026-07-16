import '../generators/generated_asset_spec.dart';
import 'dotdart_namespace_collision_exception.dart';

/// Validates every generated symbol within one namespace.
class GeneratedNamespaceValidator {
  GeneratedNamespaceValidator._();

  /// Throws when [assets] would emit conflicting Dart declarations.
  static void validate({required String folderSegment, required List<GeneratedAssetSpec> assets}) {
    final classNames = <String, String>{};
    final publicNames = <String, String>{'precache': '<namespace helper>'};
    for (final asset in assets) {
      _claim(
        names: classNames,
        name: asset.widgetClassName,
        sourcePath: asset.sourcePath,
        folderSegment: folderSegment,
      );
      _claim(names: publicNames, name: asset.accessorName, sourcePath: asset.sourcePath, folderSegment: folderSegment);
    }
  }

  static void _claim({
    required Map<String, String> names,
    required String name,
    required String sourcePath,
    required String folderSegment,
  }) {
    final existingSource = names[name];
    if (existingSource == null) {
      names[name] = sourcePath;
      return;
    }
    throw DotdartNamespaceCollisionException(
      '"$existingSource" and "$sourcePath" both produce "$name" in namespace "$folderSegment".',
    );
  }
}
