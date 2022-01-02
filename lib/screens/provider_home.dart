import 'package:flutter/material.dart';

class ProviderHomePage extends StatefulWidget {
  ProviderHomePage({Key key}) : super(key: key);

  @override
  _ProviderHomePageState createState() => _ProviderHomePageState();
}

class _ProviderHomePageState extends State<ProviderHomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Text("Provider home page"),
      ),
    ));
  }
}
