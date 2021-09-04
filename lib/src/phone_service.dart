import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:international_phone_input/src/country.dart';
import 'package:libphonenumber/libphonenumber.dart';
import 'package:flutter/services.dart';

class PhoneService {
  static List<Country> getPotentialCountries(
      String number, List<Country>? countries) {
    List<Country> result = [];
    if (number.length > 0 && number.length < 5) {
      List<String> potentialCodes =
          generatePotentialDialCodes(number, 0, number.length);
      for (var code in potentialCodes) {
        for (var country in countries!) {
          if (code == country.dialCode) {
            result.add(country);
          }
        }
      }
    }
    if (number.length >= 5) {
      String intlCode = number.substring(0, 4);
      List<String> potentialCodes = generatePotentialDialCodes(intlCode, 0, 4);
      for (var code in potentialCodes) {
        for (var country in countries!) {
          if (code == country.dialCode) {
            result.add(country);
          }
        }
      }
    }
    return result;
  }

  static List<String> generatePotentialDialCodes(
      String number, int index, int length) {
    List<String> digits = number.split('');
    List<String> potentialCodes = [];
    String aggregate = '+${digits[index]}';
    potentialCodes.add(aggregate);
    while (index < length - 1) {
      index += 1;
      aggregate = aggregate + digits[index];
      potentialCodes.add(aggregate);
    }
    return potentialCodes;
  }

  static Future<bool?> parsePhoneNumber(String number, String iso) async {
    try {
      bool? isValid = await PhoneNumberUtil.isValidPhoneNumber(
          phoneNumber: number, isoCode: iso);
      return isValid;
    } on PlatformException {
      return false;
    }
  }

  static Future<String?> getNormalizedPhoneNumber(
      String number, String iso) async {
    try {
      String? normalizedNumber = await PhoneNumberUtil.normalizePhoneNumber(
          phoneNumber: number, isoCode: iso);

      return normalizedNumber;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<Country>> fetchCountryData(
      BuildContext context, String jsonFile) async {
    var list = await DefaultAssetBundle.of(context).loadString(jsonFile);
    List<Country> elements = [];
    var jsonList = json.decode(list);
    jsonList.forEach((s) {
      Map elem = Map.from(s);
      elements.add(Country(
          name: elem['en_short_name'],
          code: elem['alpha_2_code'],
          dialCode: elem['dial_code'],
          flagUri: 'assets/flags/${elem['alpha_2_code'].toLowerCase()}.png'));
    });
    return elements;
  }
}
