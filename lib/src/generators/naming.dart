import 'dotdart_naming_exception.dart';

/// Shared helpers for deriving class and accessor names from file paths.
class Naming {
  Naming._();

  /// Derives a PascalCase widget class name from a source asset path.
  ///
  /// `assets/icons/cross.svg` → `Cross`
  /// `assets/lottie/swipe_up_phone_animation.json` → `SwipeUpPhoneAnimation`
  static String widgetClassName(String sourcePath) {
    final words = _wordsFromPath(sourcePath);
    final identifier = words.map(_capitalize).join();
    _validate(identifier, sourcePath: sourcePath, role: 'widget class');
    return identifier;
  }

  /// Derives a lowerCamelCase accessor name from a source asset path.
  ///
  /// `assets/icons/cross.svg` → `cross`
  /// `assets/icons/exclamation_circle.svg` → `exclamationCircle`
  /// `assets/lottie/swipe_up_phone_animation.json` → `swipeUpPhoneAnimation`
  static String accessorName(String sourcePath) {
    final words = _wordsFromPath(sourcePath);
    final identifier = words.first.toLowerCase() + words.skip(1).map(_capitalize).join();
    _validate(identifier, sourcePath: sourcePath, role: 'accessor');
    return identifier;
  }

  /// Derives a PascalCase namespace name from a source folder path segment.
  ///
  /// `icons` → `Icons`
  /// `my_icons` → `MyIcons`
  static String namespaceNameFromFolder(String folderSegment) {
    final words = _words(folderSegment);
    final identifier = words.map(_capitalize).join();
    _validate(identifier, sourcePath: folderSegment, role: 'namespace');
    return identifier;
  }

  static const _reservedWords = {
    'abstract',
    'as',
    'assert',
    'async',
    'await',
    'base',
    'break',
    'case',
    'catch',
    'class',
    'const',
    'continue',
    'covariant',
    'default',
    'deferred',
    'do',
    'dynamic',
    'else',
    'enum',
    'export',
    'extends',
    'extension',
    'external',
    'factory',
    'false',
    'final',
    'finally',
    'for',
    'function',
    'get',
    'hide',
    'if',
    'implements',
    'import',
    'in',
    'interface',
    'is',
    'late',
    'library',
    'mixin',
    'new',
    'null',
    'of',
    'on',
    'operator',
    'part',
    'required',
    'rethrow',
    'return',
    'sealed',
    'set',
    'show',
    'static',
    'super',
    'switch',
    'sync',
    'this',
    'throw',
    'true',
    'try',
    'typedef',
    'var',
    'void',
    'when',
    'while',
    'with',
    'yield',
  };

  static String _capitalize(String word) {
    return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
  }

  static List<String> _wordsFromPath(String sourcePath) {
    final filename = sourcePath.split('/').last;
    final extensionIndex = filename.lastIndexOf('.');
    final basename = extensionIndex <= 0 ? filename : filename.substring(0, extensionIndex);
    return _words(basename);
  }

  static List<String> _words(String value) {
    final words = value.split(RegExp('[^A-Za-z0-9]+')).where((word) => word.isNotEmpty).toList();
    if (words.isEmpty) {
      throw DotdartNamingException('Cannot derive a Dart identifier from "$value".');
    }
    if (RegExp('^[0-9]').hasMatch(words.first)) {
      throw DotdartNamingException('Generated identifiers cannot begin with a digit: "$value".');
    }
    return words;
  }

  static void _validate(String identifier, {required String sourcePath, required String role}) {
    if (!RegExp(r'^[A-Za-z_$][A-Za-z0-9_$]*$').hasMatch(identifier)) {
      throw DotdartNamingException('$sourcePath produces invalid $role identifier "$identifier".');
    }
    if (_reservedWords.contains(identifier.toLowerCase())) {
      throw DotdartNamingException('$sourcePath produces reserved $role identifier "$identifier".');
    }
  }
}
