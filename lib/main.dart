import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finder/screens/onboarding.dart';
import 'package:finder/screens/customer_home.dart';
import 'package:finder/screens/error_page.dart';
import 'package:finder/helper/db/mongodb.dart';
import 'dart:io';

Future<void> main() async {
  //assurons nous aue la liaison entre les widgets et le moteur flutter est faites
  WidgetsFlutterBinding.ensureInitialized();
  //tester la connectivité
  var isConnected = false;
  dynamic db;
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      isConnected = true;
      db = await MongoDatabase.connect();
    }
  } on SocketException catch (_) {
    isConnected = false;
  }
  //faire la connexion à la bd au démarrage de l'application
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var firstTime = preferences.getBool("firstTime");

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: firstTime == true && isConnected == true
        ? CustomerHomePage(
            db: db,
          )
        : firstTime == null && isConnected == true
            ? OnboardingPage()
            : ErrorPage(),
    routes: {
      '/Onboarding': (context) => OnboardingPage(),
      '/CustomerHomePage': (context) => CustomerHomePage(),
      '/ErrorPage': (context) => ErrorPage()
    },
  ));
}
