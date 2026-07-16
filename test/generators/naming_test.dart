import 'package:dotdart/src/generators/dotdart_naming_exception.dart';
import 'package:dotdart/src/generators/naming.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Naming', () {
    test('when a filename contains separators, it should produce lower camel case', () {
      expect(Naming.accessorName('assets/icons/arrow-left_icon.svg'), 'arrowLeftIcon');
    });

    test('when a filename begins with a digit, it should reject the identifier', () {
      expect(() => Naming.accessorName('assets/icons/3d_box.svg'), throwsA(isA<DotdartNamingException>()));
    });

    test('when a filename becomes a Dart keyword, it should reject the identifier', () {
      expect(() => Naming.accessorName('assets/icons/class.svg'), throwsA(isA<DotdartNamingException>()));
    });

    test('when a filename has multiple periods, it should retain every basename word', () {
      expect(Naming.accessorName('assets/icons/arrow.left.svg'), 'arrowLeft');
    });
  });
}
