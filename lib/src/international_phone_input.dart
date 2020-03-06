//library international_phone_input;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:international_phone_input/src/phone_service.dart';

import 'country.dart';

class InternationalPhoneInput extends StatefulWidget {
  final void Function(String phoneNumber, String internationalizedPhoneNumber,
      String isoCode) onPhoneNumberChange;
  final String initialPhoneNumber;
  final String initialSelection;
  final String errorText;
  final String hintText;
  final String labelText;
  final TextStyle errorStyle;
  final TextStyle hintStyle;
  final TextStyle labelStyle;
  final int errorMaxLines;
  final List<String> enabledCountries;

  InternationalPhoneInput(
      {this.onPhoneNumberChange,
      this.initialPhoneNumber,
      this.initialSelection,
      this.errorText,
      this.hintText,
      this.labelText,
      this.errorStyle,
      this.hintStyle,
      this.labelStyle,
      this.enabledCountries = const [],
      this.errorMaxLines});

  static Future<String> internationalizeNumber(String number, String iso) {
    return PhoneService.getNormalizedPhoneNumber(number, iso);
  }

  @override
  _InternationalPhoneInputState createState() =>
      _InternationalPhoneInputState();
}

class _InternationalPhoneInputState extends State<InternationalPhoneInput> {
  Country selectedItem;
  List<Country> countries = [];
  bool isValid = false;
  bool performValidation = true;
  String controlNumber = '';

  String errorText;
  String hintText;
  String labelText;

  TextStyle errorStyle;
  TextStyle hintStyle;
  TextStyle labelStyle;

  int errorMaxLines;

  bool hasError = false;

  _InternationalPhoneInputState();

  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    errorText = widget.errorText ?? 'Please enter a valid phone number';
    hintText = widget.hintText ?? 'eg. 244056345';
    labelText = widget.labelText;
    errorStyle = widget.errorStyle;
    hintStyle = widget.hintStyle;
    labelStyle = widget.labelStyle;
    errorMaxLines = widget.errorMaxLines;

    controller.text = widget.initialPhoneNumber;

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
        countries = list;
        selectedItem = preSelectedItem;
      });
    });
  }

  void onChanged() {
    // if user keeps inputting number, block the value to the last valid
    // number input
    if (isValid && controller.text.length > controlNumber.length) {
      setState(() {
        controller.text = controlNumber;
      });
    }

    // block execution of validation of user keeps inputting numbers
    if (controller.text == controlNumber) {
      setState(() {
        performValidation = false;
      });
    } else {
      setState(() {
        performValidation = true;
      });
    }

    if (performValidation) {
      _validatePhoneNumber(controller.text, countries).then((fullNumber) {
        if (fullNumber != null) {
          setState(() {
            controlNumber = fullNumber.substring(1);
          });
        }
      });
    }
    // place cursor at end of text string
    controller.selection =
        TextSelection.collapsed(offset: controller.text.length);
    return;
  }

  Future<String> _validatePhoneNumber(
      String number, List<Country> countries) async {
    String fullNumber;
    if (number != null && number.isNotEmpty) {
      //This step to avoid calling async function on the whole list of countries
      List<Country> potentialCountries =
          PhoneService.getPotentialCountries(number, countries);

      if (potentialCountries != null) {
        for (var country in potentialCountries) {
          //isolate local number before parsing. Using length-1 to cut the '+'
          String localNumber = number.substring(country.dialCode.length - 1);
          isValid =
              await PhoneService.parsePhoneNumber(localNumber, country.code);
          if (isValid) {
            fullNumber = await PhoneService.getNormalizedPhoneNumber(
                localNumber, country.code);
            widget.onPhoneNumberChange(localNumber, fullNumber, country.code);
          }
        }
      }
    }
    return fullNumber;
  }

  Future<List<Country>> _fetchCountryData() async {
    var list = await DefaultAssetBundle.of(context)
        .loadString('packages/international_phone_input/assets/countries.json');
    List<dynamic> jsonList = json.decode(list);

    List<Country> countries = List<Country>.generate(jsonList.length, (index) {
      Map<String, String> elem = Map<String, String>.from(jsonList[index]);
      if (widget.enabledCountries.isEmpty) {
        return Country(
            name: elem['en_short_name'],
            code: elem['alpha_2_code'],
            dialCode: elem['dial_code'],
            flagUri: 'assets/flags/${elem['alpha_2_code'].toLowerCase()}.png');
      } else if (widget.enabledCountries.contains(elem['alpha_2_code']) ||
          widget.enabledCountries.contains(elem['dial_code'])) {
        return Country(
            name: elem['en_short_name'],
            code: elem['alpha_2_code'],
            dialCode: elem['dial_code'],
            flagUri: 'assets/flags/${elem['alpha_2_code'].toLowerCase()}.png');
      } else {
        return null;
      }
    });

    countries.removeWhere((value) => value == null);

    return countries;
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
                  onChanged();
                },
                items:
                    countries.map<DropdownMenuItem<Country>>((Country value) {
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
            controller: controller,
            onChanged: (content) {
              onChanged();
            },
            decoration: InputDecoration(
              hintText: hintText,
              labelText: labelText,
              errorText: hasError ? errorText : null,
              hintStyle: hintStyle ?? null,
              errorStyle: errorStyle ?? null,
              labelStyle: labelStyle,
              errorMaxLines: errorMaxLines ?? 3,
            ),
          ))
        ],
      ),
    );
  }
}
