import 'package:finder/screens/error_page.dart';
import 'package:flutter/material.dart';
import 'package:finder/components/bottom_nav.dart';
import 'package:finder/components/sliding_cards.dart';
import 'package:finder/components/tabs.dart';
import 'package:finder/screens/see_all.dart';
import 'package:finder/screens/login.dart';
import 'dart:io';

class Header extends StatelessWidget {
  final dynamic db;
  Header(this.db);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Finder',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
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
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => LogInPage(db: db)));
            },
          ),
        ],
      ),
    );
  }
}

class CustomerHomePage extends StatefulWidget {
  final dynamic db;

  CustomerHomePage({Key key, this.db}) : super(key: key);

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
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => SeeAllPage(
                      db: widget.db,
                    )));
          },
        ));
  }

  void checkConnection() async {
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}
    } on SocketException catch (_) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => ErrorPage(db: widget.db)));
    }
  }

  @override
  initState() {
    super.initState();
    checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 8),
                  Header(widget.db),
                  SizedBox(height: 20),
                  Tabs("Recents"),
                  SizedBox(height: 4),
                  SlidingCards(),
                  seeAll(),
                ],
              ),
            ),
            BottomNav(db: widget.db), //use this or ScrollableExhibitionSheet
          ],
        ),
      ),
    );
  }
}
