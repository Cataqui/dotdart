/// One generated source file serialized through the post-process manifest.
class ManifestOutput {
  const ManifestOutput({required this.path, required this.contents});

  /// Package-relative output path.
  final String path;

  /// Complete generated Dart source.
  final String contents;
}
