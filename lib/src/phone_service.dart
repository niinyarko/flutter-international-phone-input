import 'package:libphonenumber/libphonenumber.dart';
import 'package:flutter/services.dart';

class PhoneService {
  static Future<bool> parsePhoneNumber(String number, String iso) async {
    try {
      bool isValid = await PhoneNumberUtil.isValidPhoneNumber(
          phoneNumber: number, isoCode: iso);
      return isValid;
    } on PlatformException {
      return false;
    }
  }

  static Future<String> getNormalizedPhoneNumber(
      String number, String iso) async {
    bool isValidPhoneNumber = await parsePhoneNumber(number, iso);

    if (isValidPhoneNumber) {
      String normalizedNumber = await PhoneNumberUtil.normalizePhoneNumber(
          phoneNumber: number, isoCode: iso);

      return normalizedNumber;
    }

    return null;
  }
}
