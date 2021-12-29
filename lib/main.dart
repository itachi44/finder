import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finder/screens/onboarding.dart';
import 'package:finder/screens/customer_home.dart';
import 'package:finder/screens/provider_home.dart';
import 'package:finder/screens/intro.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var firtTime = preferences.getBool("firstTime");
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: firtTime == true ? IntroPage() : OnboardingPage(),
    routes: {
      '/Onboarding': (context) => OnboardingPage(),
      '/Home': (context) => IntroPage()
    },
  ));
}
