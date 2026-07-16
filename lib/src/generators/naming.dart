/// Shared helpers for deriving class and accessor names from file paths.
class Naming {
  Naming._();

  /// Derives a PascalCase widget class name from a source asset path.
  ///
  /// `assets/icons/cross.svg` → `Cross`
  /// `assets/lottie/swipe_up_phone_animation.json` → `SwipeUpPhoneAnimation`
  static String widgetClassName(String sourcePath) {
    final name = sourcePath.split('/').last.split('.').first;
    return name
        .split(RegExp(r'[_\s-]+'))
        .map((s) => s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : '')
        .join();
  }

  /// Derives a lowerCamelCase accessor name from a source asset path.
  ///
  /// `assets/icons/cross.svg` → `cross`
  /// `assets/icons/exclamation_circle.svg` → `exclamationCircle`
  /// `assets/lottie/swipe_up_phone_animation.json` → `swipeUpPhoneAnimation`
  static String accessorName(String sourcePath) {
    final name = sourcePath.split('/').last.split('.').first;
    final parts = name.split(RegExp(r'[_\s-]+')).where((s) => s.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    return parts.first.toLowerCase() +
        parts.skip(1).map((s) => '${s[0].toUpperCase()}${s.substring(1).toLowerCase()}').join();
  }

  /// Derives a PascalCase namespace name from a source folder path segment.
  ///
  /// `icons` → `Icons`
  /// `my_icons` → `MyIcons`
  static String namespaceNameFromFolder(String folderSegment) {
    return folderSegment
        .split(RegExp(r'[_\s-]+'))
        .where((s) => s.isNotEmpty)
        .map((s) => '${s[0].toUpperCase()}${s.substring(1).toLowerCase()}')
        .join();
  }
}
