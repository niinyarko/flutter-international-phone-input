import 'package:flutter/material.dart';
import 'package:international_phone_input/src/country.dart';
import 'package:international_phone_input/src/phone_service.dart';

class InternationalPhoneInputText extends StatefulWidget {
  final Function(
      {String number,
      String internationalizedPhoneNumber,
      String isoCode}) onValidPhoneNumber;
  final String hintText;
  final String errorText;
  final TextStyle errorStyle;
  final TextStyle hintStyle;
  final int errorMaxLines;

  const InternationalPhoneInputText(
      {Key key,
      this.hintText,
      this.errorText,
      this.errorStyle,
      this.hintStyle,
      this.errorMaxLines,
      this.onValidPhoneNumber})
      : super(key: key);

  @override
  _InternationalPhoneInputTextState createState() =>
      _InternationalPhoneInputTextState();
}

class _InternationalPhoneInputTextState
    extends State<InternationalPhoneInputText> {
  TextEditingController controller = TextEditingController();
  List<Country> countries;
  bool isValid = false;
  String controlNumber = '';

  @override
  void initState() {
    super.initState();
    PhoneService.fetchCountryData(
            context, 'packages/international_phone_input/assets/countries.json')
        .then((list) {
      setState(() {
        countries = list;
      });
    });
  }

  void onChanged() {
    if (isValid && controller.text.length > controlNumber.length) {
      setState(() {
        controller.text = controlNumber;
      });
    }
    if (countries != null) {
      _validatePhoneNumber(controller.text, countries).then((fullNumber) {
        if (fullNumber != null) {
          setState(() {
            controlNumber = fullNumber.substring(1);
          });
        }
      });
    }
    controller.selection =
        TextSelection.collapsed(offset: controller.text.length);
    return;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

//TO DO : prevent onValidNumber from being called twice
  Future<String> _validatePhoneNumber(
      String number, List<Country> countries) async {
    print('validation func launched');
    String fullNumber;
    if (number != null && number.isNotEmpty) {
      //This step to avoid calling async function on the whole list of countries
      List<Country> potentialCountries =
          PhoneService.getPotentialCountries(number, countries);
      if (potentialCountries != null) {
        for (var country in potentialCountries) {
          //isolate local number before parsing. Using length-1 to cut the '+'
          String localNumber = number.substring(country.dialCode.length - 1);
          // TO DO: switch value back after validation
          print('isValid launched: ${country.code}');

          isValid =
              await PhoneService.parsePhoneNumber(localNumber, country.code);
          print('isValid value : $isValid');
          if (isValid) {
            fullNumber = await PhoneService.getNormalizedPhoneNumber(
                localNumber, country.code);
            widget.onValidPhoneNumber(
                number: localNumber,
                internationalizedPhoneNumber: fullNumber,
                isoCode: country.code);
          }
        }
      }
    }
    return fullNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Text('+ '),
          ),
        ),
        Expanded(
          child: TextField(
            keyboardType: TextInputType.phone,
            controller: controller,
            onChanged: (content) {
              onChanged();
            },
            decoration: InputDecoration(
              hintText: widget.hintText ?? "please enter a valid phone number",
              errorText: widget.errorText ?? null,
              hintStyle: widget.hintStyle ?? null,
              errorStyle: widget.errorStyle ?? null,
              errorMaxLines: widget.errorMaxLines ?? 3,
            ),
          ),
        ),
      ],
    );
  }
}
