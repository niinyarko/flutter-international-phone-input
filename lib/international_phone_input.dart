library international_phone_input;

import 'dart:async';
import 'dart:convert';

import 'country.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:libphonenumber/libphonenumber.dart';

class InternationalPhoneInput extends StatefulWidget {
  final void Function(String phoneNumber, String internationalizedPhoneNumber,
      String isoCode) onPhoneNumberChange;
  final String initialPhoneNumber;
  final String initialSelection;

  InternationalPhoneInput(
      {this.onPhoneNumberChange,
      this.initialPhoneNumber,
      this.initialSelection});

  static Future<String> internationalizeNumber(String number, String iso) {
    return _InternationalPhoneInputState.getNormalizedPhoneNumber(number, iso);
  }

  @override
  _InternationalPhoneInputState createState() =>
      _InternationalPhoneInputState();
}

class _InternationalPhoneInputState extends State<InternationalPhoneInput> {
  Country selectedItem;
  List<Country> itemList = [];

  String errorText;

  _InternationalPhoneInputState();

  final phoneTextController = TextEditingController();

  @override
  void initState() {
    phoneTextController.addListener(_validatePhoneNumber);
    phoneTextController.text = widget.initialPhoneNumber;

    _fetchCountryData().then((list) {
      Country preSelectedItem;

      if (widget.initialSelection != null) {
        preSelectedItem = list.firstWhere(
            (e) =>
                (e.code.toUpperCase() ==
                    widget.initialSelection.toUpperCase()) ||
                (e.dialCode == widget.initialSelection.toString()),
            orElse: () => list[0]);
      } else {
        preSelectedItem = list[0];
      }

      setState(() {
        itemList = list;
        selectedItem = preSelectedItem;
      });
    });

    super.initState();
  }

  _validatePhoneNumber() {
    String phoneText = phoneTextController.text;
    if (phoneText != null && phoneText.isNotEmpty) {
      parsePhoneNumber(phoneText, selectedItem.code).then((isValid) {
        var error = isValid ? null : 'Please enter a valid phone number';
        setState(() {
          errorText = error;
        });

        if (widget.onPhoneNumberChange != null) {
          if (isValid) {
            getNormalizedPhoneNumber(phoneText, selectedItem.code)
                .then((number) {
              widget.onPhoneNumberChange(phoneText, number, selectedItem.code);
            });
          } else {
            widget.onPhoneNumberChange('', '', selectedItem.code);
          }
        }
      });
    }
  }

  Future<List<Country>> _fetchCountryData() async {
    var list = await DefaultAssetBundle.of(context)
        .loadString('packages/international_phone_input/countries.json');
    var jsonList = json.decode(list);
    List<Country> elements = [];
    jsonList.forEach((s) {
      Map elem = Map.from(s);
      elements.add(Country(
          name: elem['en_short_name'],
          code: elem['alpha_2_code'],
          dialCode: elem['dial_code'],
          flagUri: 'flags/${elem['alpha_2_code'].toLowerCase()}.png'));
    });
    return elements;
  }

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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          DropdownButtonHideUnderline(
            child: Padding(
              padding: EdgeInsets.only(top: 8),
              child: DropdownButton<Country>(
                value: selectedItem,
                onChanged: (Country newValue) {
                  setState(() {
                    selectedItem = newValue;
                  });
                  _validatePhoneNumber();
                },
                items: itemList.map<DropdownMenuItem<Country>>((Country value) {
                  return DropdownMenuItem<Country>(
                    value: value,
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Image.asset(
                            value.flagUri,
                            width: 32.0,
                            package: 'international_phone_input',
                          ),
                          SizedBox(width: 4),
                          Text(value.dialCode)
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Flexible(
              child: TextField(
            keyboardType: TextInputType.phone,
            controller: phoneTextController,
            decoration: InputDecoration(
                hintText: 'eg. 244056345', errorText: errorText),
          ))
        ],
      ),
    );
  }
}
