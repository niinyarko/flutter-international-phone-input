# international_phone_input

International Phone Number Input For Flutter

<img src="https://raw.githubusercontent.com/niinyarko/flutter-international-phone-input/master/screenshots/screen1.png" width="240"/>
<img src="https://raw.githubusercontent.com/niinyarko/flutter-international-phone-input/master/screenshots/screen2.png" width="240"/>

## Usage

Just put the component in your application.

```dart

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
          initialSelection: phoneIsoCode
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


```

## Contributions

Contributions of any kind are more than welcome! Feel free to fork and improve international_phone_input in any way you want, make a pull request, or open an issue.
