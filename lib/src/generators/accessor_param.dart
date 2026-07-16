/// Describes a single constructor parameter on a generated widget.
///
/// Used by `NamespaceAssembler` to emit the correct method signature
/// on the `$Namespace` accessor class.
class AccessorParam {
  const AccessorParam({
    required this.name,
    required this.type,
    this.defaultValue,
    this.required = false,
  });

  /// Parameter name as it appears in the constructor (e.g. `width`, `color1`).
  final String name;

  /// Dart type expression (e.g. `double?`, `Color?`, `bool`).
  final String type;

  /// Default value expression as a Dart literal (e.g. `true`) or null.
  final String? defaultValue;

  /// When true, the parameter must be named and required
  /// (emitted as `required this.xxx`).
  final bool required;
}
