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

  String phoneNumber;
  String phoneIsoCode;


  void onPhoneNumberChange(String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      phoneNumber = number;
      phoneIsoCode = isoCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('International Phone Input Example'),
      ),
      body: Center(
        child: InternationalPhoneInput(
          onPhoneNumberChange: onPhoneNumberChange,
          initialPhoneNumber: phoneNumber,
          initialSelection: phoneIsoCode,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
