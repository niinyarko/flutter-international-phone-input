import 'package:flutter/material.dart';
import 'package:international_phone_input/international_phone_input.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String phoneNumber = '68699698';
  String? phoneIsoCode = '+373';
  bool visible = false;
  String? confirmedNumber = '';

  void onPhoneNumberChange(String number, String? internationalizedPhoneNumber,
      String? isoCode, String? dialCode) {
    print(number);
    setState(() {
      phoneNumber = number;
      phoneIsoCode = isoCode;
    });
  }

  onValidPhoneNumber(
    String number,
    String? internationalizedPhoneNumber,
    String? isoCode,
  ) {
    setState(() {
      visible = true;
      confirmedNumber = internationalizedPhoneNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('International Phone Input Example'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            InternationalPhoneInput(
              //decoration: InputDecoration.collapsed(hintText: '(123) 123-1234'),
              onPhoneNumberChange: onPhoneNumberChange,
              initialPhoneNumber: phoneNumber,
              initialSelection: phoneIsoCode,
              enabledCountries: {
                '+373': 'MD',
                '+40': 'RO',
                '+7': 'RU',
                '+374':'AM',
              },
              showCountryCodes: true,
              showCountryFlags: true,
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.black,
            ),
            SizedBox(height: 50),
           /*  InternationalPhoneInputText(
              onValidPhoneNumber: onValidPhoneNumber,
            ), */
            Visibility(
              child: Text('$confirmedNumber'),
              visible: visible,
            ),
            Spacer(flex: 2),
            ElevatedButton(onPressed: () {}, child: Text('Submmit'))
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
