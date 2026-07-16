import 'dart:io';

import 'package:path/path.dart' as p;

/// Validates generated output paths and dotdart file ownership.
class GeneratedOutputPath {
  GeneratedOutputPath._();

  /// Exact first line written to every dotdart-generated source file.
  static const ownershipHeader = '// GENERATED CODE - DO NOT MODIFY BY HAND';

  /// Returns whether [contents] belongs to dotdart.
  static bool isDotdartOwned(String contents) {
    final lines = contents.split('\n');
    return lines.length >= 3 &&
        lines[0] == ownershipHeader &&
        lines[1] == '// *****************************************************' &&
        lines[2] == '//  dotdart';
  }

  /// Rejects a manifest package root that escapes the active workspace.
  static void validatePackageRoot({required String packageRoot, required String workspaceRoot}) {
    final resolvedWorkspace = Directory(p.normalize(p.absolute(workspaceRoot))).resolveSymbolicLinksSync();
    final resolvedPackage = Directory(p.normalize(p.absolute(packageRoot))).resolveSymbolicLinksSync();
    if (resolvedPackage != resolvedWorkspace && !p.isWithin(resolvedWorkspace, resolvedPackage)) {
      throw FormatException('dotdart package root is outside the active workspace: "$packageRoot".');
    }
  }

  /// Resolves a package-relative path and rejects traversal or symlink escapes.
  static String resolve({required String packageRoot, required String relativePath}) {
    final normalizedRoot = p.normalize(p.absolute(packageRoot));
    final normalizedRelative = p.normalize(relativePath);
    if (p.isAbsolute(normalizedRelative) || normalizedRelative == '..' || normalizedRelative.startsWith('../')) {
      throw FormatException('Generated output must stay inside the package: "$relativePath".');
    }
    final target = p.normalize(p.join(normalizedRoot, normalizedRelative));
    if (target != normalizedRoot && !p.isWithin(normalizedRoot, target)) {
      throw FormatException('Generated output must stay inside the package: "$relativePath".');
    }

    final existingAncestor = _nearestExistingAncestor(File(target).parent);
    final resolvedAncestor = existingAncestor.resolveSymbolicLinksSync();
    final resolvedRoot = Directory(normalizedRoot).resolveSymbolicLinksSync();
    if (resolvedAncestor != resolvedRoot && !p.isWithin(resolvedRoot, resolvedAncestor)) {
      throw FormatException('Generated output resolves outside the package: "$relativePath".');
    }
    if (FileSystemEntity.typeSync(target, followLinks: false) == FileSystemEntityType.link) {
      final resolvedTarget = Link(target).resolveSymbolicLinksSync();
      if (resolvedTarget != resolvedRoot && !p.isWithin(resolvedRoot, resolvedTarget)) {
        throw FormatException('Generated output file resolves outside the package: "$relativePath".');
      }
    }
    return target;
  }

  static Directory _nearestExistingAncestor(Directory directory) {
    var current = directory;
    while (!current.existsSync()) {
      final parent = current.parent;
      if (parent.path == current.path) break;
      current = parent;
    }
    return current;
  }
}
