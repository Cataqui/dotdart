/// Thrown when an asset path cannot produce safe Dart identifiers.
class DotdartNamingException implements FormatException {
  const DotdartNamingException(this.message);

  @override
  final String message;

  @override
  int? get offset => null;

  @override
  Object? get source => null;

  @override
  String toString() => 'DotdartNamingException: $message';
}
