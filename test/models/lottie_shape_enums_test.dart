import 'package:dotdart/src/models/lottie_shape_enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LottieTrimPathMode', () {
    test('when converting Lottie values, it should map supported modes exhaustively', () {
      expect(
        (
          LottieTrimPathMode.fromValue(1),
          LottieTrimPathMode.fromValue(2),
          LottieTrimPathMode.fromValue(3),
        ),
        (LottieTrimPathMode.parallel, LottieTrimPathMode.sequential, null),
      );
    });
  });
}
