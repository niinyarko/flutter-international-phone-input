import 'package:flutter_test/flutter_test.dart';
import 'package:international_phone_input/src/international_phone_input.dart';

void main() {
  test('validates phone number input value', () async {
    var internationalizedNumber =
        await InternationalPhoneInput.internationalizeNumber(
            '0508232165', 'gh');
    expect(internationalizedNumber, '+233508232165');
  });
}
