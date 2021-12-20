import 'package:flutter/material.dart';
import 'package:international_phone_input/src/country.dart';
import 'package:international_phone_input/src/phone_service.dart';

class InternationalPhoneInputText extends StatefulWidget {
  final Function(
          String number, String? internationalizedPhoneNumber, String? isoCode)?
      onValidPhoneNumber;
  final String? hintText;
  final TextStyle? hintStyle;
  final int? errorMaxLines;
  final String? labelText;

  const InternationalPhoneInputText(
      {Key? key,
      this.hintText,
      this.hintStyle,
      this.errorMaxLines,
      this.onValidPhoneNumber,
      this.labelText})
      : super(key: key);

  @override
  _InternationalPhoneInputTextState createState() =>
      _InternationalPhoneInputTextState();
}

class _InternationalPhoneInputTextState
    extends State<InternationalPhoneInputText> {
  TextEditingController controller = TextEditingController();
  List<Country>? countries;
  bool? isValid = false;
  String controlNumber = '';
  bool performValidation = true;

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
    // if user keeps inputting number, block the value to the last valid
    // number input
    if (isValid! && controller.text.length > controlNumber.length) {
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

  Future<String?> _validatePhoneNumber(
      String number, List<Country>? countries) async {
    String? fullNumber;
    if (number != null && number.isNotEmpty) {
      //This step to avoid calling async function on the whole list of countries
      List<Country> potentialCountries =
          PhoneService.getPotentialCountries(number, countries);
      if (potentialCountries != null) {
        for (var country in potentialCountries) {
          //isolate local number before parsing. Using length-1 to cut the '+'
          String localNumber = number.substring(country.dialCode!.length - 1);
          isValid =
              await PhoneService.parsePhoneNumber(localNumber, country.code!);
          if (isValid!) {
            fullNumber = await PhoneService.getNormalizedPhoneNumber(
                localNumber, country.code!);
            widget.onValidPhoneNumber!(localNumber, fullNumber, country.code);
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
                hintText: widget.hintText ?? null,
                hintStyle: widget.hintStyle ?? null,
                errorMaxLines: widget.errorMaxLines ?? 3,
                labelText: widget.labelText ?? 'Enter your phone number'),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
