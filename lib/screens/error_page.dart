import 'package:flutter/material.dart';
import 'package:finder/screens/customer_home.dart';
import 'package:finder/screens/login.dart';

import 'dart:io';

class ErrorPage extends StatefulWidget {
  final dynamic pageToGo;

  const ErrorPage({Key key, this.pageToGo = "/"}) : super(key: key);

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  _getPage(dynamic page) {
    switch (page) {
      case "/customerHome":
        return (context) => CustomerHomePage();
        break;
      case "/logIn":
        return (context) => LogInPage();
      default:
        return (context) => CustomerHomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            child: Image.asset('assets/images/no-connection.gif'),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 2.5,
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(60),
                topRight: Radius.circular(60),
              ),
            ),
            child: Column(
              children: [
                Text(
                  "Ooops! 😓",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "No internet connection found. Check your connection or try again.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                MaterialButton(
                  onPressed: () async {
                    try {
                      final result = await InternetAddress.lookup('google.com');
                      if (result.isNotEmpty &&
                          result[0].rawAddress.isNotEmpty) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: _getPage(widget.pageToGo)));
                      }
                    } on SocketException catch (_) {}
                  },
                  height: 45,
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.orange.shade400,
                  child: Text(
                    "Try Again",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
