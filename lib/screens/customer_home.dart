import 'package:finder/screens/error_page.dart';
import 'package:flutter/material.dart';
import 'package:finder/components/bottom_nav.dart';
import 'package:finder/components/sliding_cards.dart';
import 'package:finder/components/tabs.dart';
import 'dart:io';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Finder',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 100),
          ElevatedButton(
            child: Text(
              'I\'m a provider',
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 1,
                fontSize: MediaQuery.of(context).size.height / 45,
              ),
            ),
            style: ElevatedButton.styleFrom(
                primary: Color(0xFF162A49),
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                )),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class CustomerHomePage extends StatefulWidget {
  CustomerHomePage({Key key}) : super(key: key);

  @override
  _CustomerHomePageState createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  Widget seeAll() {
    return Padding(
        padding: EdgeInsets.only(left: 20),
        child: ElevatedButton(
          child: Text(
            'See all',
            style: TextStyle(
              color: Color(0xFF162A49),
              fontSize: 20,
            ),
          ),
          style: ElevatedButton.styleFrom(
              primary: Color(0xfff),
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              )),
          onPressed: () {},
        ));
  }

  void checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}
    } on SocketException catch (_) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => ErrorPage()));
    }
  }

  @override
  initState() {
    super.initState();
    checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 8),
                Header(),
                SizedBox(height: 40),
                Tabs(),
                SizedBox(height: 8),
                SlidingCards(),
                seeAll(),
              ],
            ),
          ),
          BottomNav(), //use this or ScrollableExhibitionSheet
        ],
      ),
    );
  }
}
