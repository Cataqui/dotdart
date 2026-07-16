import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import '../generators/generated_asset_spec.dart';
import 'dotdart_config.dart';

/// Parses and validates the `dotdart:` section of a pubspec.
class DotdartConfigParser {
  DotdartConfigParser._();

  /// Returns null when dotdart is not configured.
  static DotdartConfig? parse(String pubspecContent) {
    final document = loadYaml(pubspecContent);
    if (document is! YamlMap) return null;
    final rawConfig = document['dotdart'];
    if (rawConfig == null) return null;
    if (rawConfig is! YamlMap) {
      throw const FormatException('dotdart must be a YAML map.');
    }

    final knownKeys = {'output', for (final type in DotdartAssetType.values) type.configKey};
    for (final key in rawConfig.keys) {
      if (key is! String || !knownKeys.contains(key)) {
        throw FormatException('Unknown dotdart configuration key "$key".');
      }
    }

    final outputValue = rawConfig['output'];
    if (outputValue != null && outputValue is! String) {
      throw const FormatException('dotdart.output must be a relative directory path.');
    }
    final outputDir = _normalize(outputValue as String? ?? 'lib/gen/', fieldName: 'dotdart.output');
    if (outputDir.isEmpty) {
      throw const FormatException('dotdart.output cannot be the package root.');
    }

    final inputs = <DotdartAssetType, List<String>>{};
    final allInputs = <String>{};
    for (final type in DotdartAssetType.values) {
      final rawInputs = rawConfig[type.configKey];
      if (rawInputs == null) {
        inputs[type] = const [];
        continue;
      }
      if (rawInputs is! YamlList) {
        throw FormatException('dotdart.${type.configKey} must be a list of relative paths.');
      }
      final normalizedInputs = <String>[];
      for (final rawInput in rawInputs) {
        if (rawInput is! String) {
          throw FormatException('dotdart.${type.configKey} entries must be relative paths.');
        }
        final input = _normalize(rawInput, fieldName: 'dotdart.${type.configKey}');
        if (input.isEmpty) {
          throw FormatException('dotdart.${type.configKey} entries cannot target the package root.');
        }
        if (!allInputs.add(input)) {
          throw FormatException('Duplicate dotdart input "$input".');
        }
        normalizedInputs.add(input);
      }
      inputs[type] = List.unmodifiable(normalizedInputs);
    }

    if (inputs.values.every((paths) => paths.isEmpty)) {
      throw const FormatException('dotdart must configure at least one asset input.');
    }

    return DotdartConfig(outputDir: outputDir, inputs: Map.unmodifiable(inputs));
  }

  static String _normalize(String path, {required String fieldName}) {
    final normalized = p.posix.normalize(path.trim());
    if (normalized.isEmpty || normalized == '.') return '';
    if (p.posix.isAbsolute(normalized) || normalized == '..' || normalized.startsWith('../')) {
      throw FormatException('$fieldName must stay inside the package. Received "$path".');
    }
    return normalized;
  }
}
