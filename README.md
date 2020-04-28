# international_phone_input

International Phone Number Input For Flutter

<img src="https://raw.githubusercontent.com/niinyarko/flutter-international-phone-input/master/screenshots/screen1.png" width="240"/>
<img src="https://raw.githubusercontent.com/niinyarko/flutter-international-phone-input/master/screenshots/screen2.png" width="240"/>
<img src="https://raw.githubusercontent.com/niinyarko/flutter-international-phone-input/master/screenshots/screen3.png" width="240"/>


## Usage

Just put the component in your application.

```dart
import 'package:international_phone_input/international_phone_input.dart';

String phoneNumber;
String phoneIsoCode;

void onPhoneNumberChange(String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
       phoneNumber = number;
       phoneIsoCode = isoCode;
    });
}

// Default Widget with dropdown list
@override
 Widget build(BuildContext context) => Scaffold(
     body: Center(
       child: InternationalPhoneInput(
          onPhoneNumberChange: onPhoneNumberChange, 
          initialPhoneNumber: phoneNumber,
          initialSelection: phoneIsoCode,
          enabledCountries: ['+233', '+1']
       ),
     ),
 );

// Widget with text input only

 onValidPhoneNumber(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      confirmedNumber = internationalizedPhoneNumber;
    });
  }

@override
 Widget build(BuildContext context) => Scaffold(
     body: Center(
       child:  InternationalPhoneInputText(
         onValidPhoneNumber: onValidPhoneNumber,
        ),
     ),
 );

// Widget with decoration
// Using decoration overwrites other styles such as hintStyle, hintText, etc.

@override
 Widget build(BuildContext context) => Scaffold(
     body: Center(
       child: InternationalPhoneInput(
          decoration: InputDecoration.collapsed(hintText: '(416) 123-4567'),
          onPhoneNumberChange: onPhoneNumberChange, 
          initialPhoneNumber: phoneNumber,
          initialSelection: phoneIsoCode,
          enabledCountries: ['+233', '+1'],
          showCountryCodes: false
       ),
     ),
 );

```

## Customization

Here is a list of properties available to customize the widget:

|        Name        	|       Type      	|                 Description                	|
|:------------------:	|:---------------:	|:------------------------------------------:	|
| initialPhoneNumber 	| String          	| used to set initial phone number           	|
| initialSelection   	| String          	| used to set initial country code           	|
| errorText          	| String          	| use this to set an error message           	|
| hintText           	| String          	| sets hint                                  	|
| labelText          	| String          	| sets label                                 	|
| errorStyle         	| TextStyle       	| style applied to error message             	|
| hintStyle          	| TextStyle       	| style applied to hint                      	|
| labelStyle         	| TextStyle       	| style applied to label                     	|
| errorMaxLines      	| int             	| the maximum number of lines user can type  	|
| enabledCountries   	| List<String>    	| the list of enabled countries to display   	|
| decoration         	| InputDecoration 	| decoration applied to the TextField widget 	|
| showCountryCodes   	| bool            	| shows the country code (default true)      	|
| showCountryFlags   	| bool            	| shows. the country flags (default true)    	|
| dropdownIcon       	| Widget          	| use this to customize dropdown icon        	|

## Contributions

Contributions of any kind are more than welcome! Feel free to fork and improve international_phone_input in any way you want, make a pull request, or open an issue.
