import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finder/screens/onboarding.dart';
import 'package:finder/screens/customer_home.dart';
import 'package:finder/screens/provider_home.dart';
import 'package:finder/screens/intro.dart';
import 'package:finder/helper/db/mongodb.dart';

Future<void> main() async {
  //assurons nous aue la liaison entre les widgets et le moteur flutter est faites
  WidgetsFlutterBinding.ensureInitialized();
  //faire la connexion à la bd au démarrage de l'application
  await MongoDatabase.connect();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var firtTime = preferences.getBool("firstTime");

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: firtTime == true ? IntroPage() : OnboardingPage(),
    routes: {
      '/Onboarding': (context) => OnboardingPage(),
      '/Intro': (context) => IntroPage()
    },
  ));
}
