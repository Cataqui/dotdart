/// Thrown when multiple assets produce the same generated symbol.
class DotdartNamespaceCollisionException implements Exception {
  const DotdartNamespaceCollisionException(this.message);

  /// Actionable conflict description.
  final String message;

  @override
  String toString() => 'DotdartNamespaceCollisionException: $message';
}
