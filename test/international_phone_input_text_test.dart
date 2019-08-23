import 'package:flutter_test/flutter_test.dart';
import 'package:international_phone_input/international_phone_input.dart';

// NOTE: the test pass using flutter test, but pub test will fail due to a dart error
void main() {
  group('generate potential dial codes from user input', () {
    test('lenght=1', () {
      String testNumber = '32475888999';
      var length1 = PhoneService.generatePotentialDialCodes(testNumber, 0, 1);
      expect(length1, ['+3']);
    });
    test('lenght=2', () {
      String testNumber = '32475888999';
      var length1 = PhoneService.generatePotentialDialCodes(testNumber, 0, 2);
      expect(length1, ['+3', '+32']);
    });
    test('lenght=3', () {
      String testNumber = '32475888999';
      var length1 = PhoneService.generatePotentialDialCodes(testNumber, 0, 3);
      expect(length1, ['+3', '+32', '+324']);
    });
    test('lenght=4', () {
      String testNumber = '32475888999';
      var length1 = PhoneService.generatePotentialDialCodes(testNumber, 0, 4);
      expect(length1, ['+3', '+32', '+324', '+3247']);
    });
  });

  group('match user input with potential countries', () {
    var americanSamoa = Country(
        name: 'American Samoa',
        flagUri: 'dummy',
        code: 'AS',
        dialCode: '+1684');
    var belgium =
        Country(name: 'Belgium', flagUri: 'dummy', code: 'BE', dialCode: '+32');
    var canada = Country(
      name: 'Canada',
      flagUri: 'dummy',
      code: 'CA',
      dialCode: '+1',
    );
    var countries = [americanSamoa, belgium, canada];

    test('give several countries with partially matching dialCodes', () {
      var listCountries = PhoneService.getPotentialCountries('1684', countries);
      expect(listCountries, [canada, americanSamoa]);
    });
  });

  // TO DO: see why async await syntax not working
  // This test is async and has external dep. If this test is not the last, it will fail
  test('parse phone number', () {
    PhoneService.parsePhoneNumber('477555666', 'BE').then((result) {
      expect(result, true);
      PhoneService.parsePhoneNumber('47755566', 'BE').then((result) {
        expect(result, false);
        PhoneService.parsePhoneNumber('47755566', 'BE').then((result) {
          expect(result, false);
        });
      });
    });
  });

  // Should be tested but see comment of previous text. Also: it's the
  // same function underlying the the test in the other test file.
  /* test('normalized phone number', () {
    PhoneService.getNormalizedPhoneNumber('475999888', 'be').then((result) {
      expect(result, '+32475999888');
    });
  });*/
}
