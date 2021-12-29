import 'package:flutter/material.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Color(0xfff2f3f7),
          body: Center(
            child: Text("intro page..."),
          ),
        ),
      ),
    );
  }
}
