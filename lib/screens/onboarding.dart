import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Color(0xfff2f3f7),
          body: Center(
            child: Text("onboarding screens..."),
          ),
        ),
      ),
    );
  }
}
