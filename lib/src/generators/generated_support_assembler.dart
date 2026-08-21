import 'package:dart_style/dart_style.dart';

/// Assembles declarations shared by dotdart-generated namespace libraries.
class GeneratedSupportAssembler {
  GeneratedSupportAssembler();

  /// Produces the complete, formatted `dotdart.g.dart` source.
  String assemble() {
    final buffer = StringBuffer()
      ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND')
      ..writeln('// *****************************************************')
      ..writeln('//  dotdart')
      ..writeln('// *****************************************************')
      ..writeln()
      ..writeln('// coverage:ignore-file')
      ..writeln()
      ..writeln('/// Controls automatic playback for generated Lottie widgets.')
      ..writeln('enum LottiePlayback {')
      ..writeln('  /// Plays the animation once and keeps the final frame visible.')
      ..writeln('  once,')
      ..writeln()
      ..writeln('  /// Repeats the animation continuously.')
      ..writeln('  loop,')
      ..writeln('}');

    return DartFormatter(
      languageVersion: DartFormatter.latestLanguageVersion,
    ).format(buffer.toString());
  }
}
