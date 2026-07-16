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
    this.documentation,
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

  /// Consumer-facing description emitted on generated widget fields.
  final String? documentation;

  /// Emits this parameter in a named function or constructor signature.
  String get signature {
    if (required) return 'required $type $name';
    if (defaultValue != null) return '$type $name = $defaultValue';
    return '$type $name';
  }

  /// Emits the constructor initializer for an instance field.
  String get constructorInitializer {
    if (name == 'key') return 'super.key';
    if (required) return 'required this.$name';
    if (defaultValue != null) return 'this.$name = $defaultValue';
    return 'this.$name';
  }

  /// Emits this parameter as a generated widget field, or null for `key`.
  String? get fieldDeclaration {
    if (name == 'key') return null;
    final buffer = StringBuffer();
    if (documentation != null) {
      buffer.writeln('  /// $documentation');
    }
    buffer.writeln('  final $type $name;');
    return buffer.toString();
  }
}
