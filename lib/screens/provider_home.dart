import 'package:flutter/material.dart';
import 'package:finder/components/nav_drawer.dart';

class ProviderHomePage extends StatefulWidget {
  final dynamic db;

  ProviderHomePage({Key key, this.db}) : super(key: key);

  @override
  _ProviderHomePageState createState() => _ProviderHomePageState();
}

class _ProviderHomePageState extends State<ProviderHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  double width;

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xf9faf9), borderRadius: BorderRadius.circular(20)),
      width: double.infinity,
      padding: EdgeInsets.only(right: 15, top: 20, bottom: 20, left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Manage your',
            style: TextStyle(color: Colors.black87, fontSize: 25),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'service',
            style: TextStyle(
                color: Colors.black, fontSize: 40, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 1.28,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(244, 243, 243, 1),
                    borderRadius: BorderRadius.circular(15)),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black87,
                      ),
                      hintText: "Search you're looking for",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                ),
              ),
              IconButton(
                icon: Icon(Icons.tune,
                    color: Color(0xFF162A49),
                    size: MediaQuery.of(context).size.width / 13),
                splashColor: Colors.transparent,
                onPressed: () {
                  print("yh");
                },
              )
            ],
          ),
        ],
      ),
    );
  }

//chip
  Widget _chip(String text, Color bcolor, Color textColor, double fontSize,
      dynamic alignment,
      {double height = 0, bool isPrimaryCard = false}) {
    return Container(
      alignment: alignment,
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.height / 89.6,
          vertical: height),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        //color: bcolor.withAlpha(isPrimaryCard ? 200 : 50),
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: fontSize),
      ),
    );
  }

  //cardInfo
  Widget _cardInfo(
      String title, String description1, Color textColor, Color primary,
      {bool isPrimaryCard = false}) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.height / 180),
            width: MediaQuery.of(context).size.width * .40,
            alignment: Alignment.topCenter,
            child: Text(
              title,
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height / 46,
                  fontWeight: FontWeight.bold,
                  color: textColor),
            ),
          ),
          SizedBox(height: 5),
          _chip(description1, primary, textColor,
              MediaQuery.of(context).size.height / 50, Alignment.center,
              height: MediaQuery.of(context).size.height / 180,
              isPrimaryCard: isPrimaryCard),
        ],
      ),
    );
  }

  Widget _card(
      {Color primary = Colors.white,
      String imgPath,
      String chipText1 = '',
      String chipText2 = '',
      double h,
      double w,
      double iconTop,
      double iconLeft,
      Widget backWidget,
      dynamic page,
      double textCardBottom,
      double textCardLeft,
      Color textColor = const Color(0xFF162A49),
      Color chipColor = Colors.white,
      bool isPrimaryCard = false}) {
    return AnimatedContainer(
      duration: const Duration(seconds: 500),
      curve: Curves.easeIn,
      child: InkWell(
        onTap: () {},
        child: Container(
            height: h,
            width: w,
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.height / 59.73,
                vertical: MediaQuery.of(context).size.height / 44.8),
            decoration: BoxDecoration(
                color: primary.withAlpha(200),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      offset: Offset(0, 2),
                      spreadRadius: 1,
                      blurRadius: 1,
                      color: Colors.grey.shade500)
                ]),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: Container(
                child: Stack(
                  children: <Widget>[
                    backWidget,
                    Positioned(
                        top: iconTop,
                        left: iconLeft,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0), //or 15.0
                          child: Container(
                            height: MediaQuery.of(context).size.height / 12.8,
                            width: MediaQuery.of(context).size.height / 12.8,
                            color: Colors.white,
                            child: Icon(
                                isPrimaryCard
                                    ? Icons.settings
                                    : Icons.add_circle,
                                color: Color(0xFF162A49), //TODO : icon color
                                size:
                                    MediaQuery.of(context).size.height / 17.92),
                          ),
                        )),
                    //C'est le container des textes
                    Positioned(
                      bottom: textCardBottom,
                      left: textCardLeft,
                      child: _cardInfo(
                          chipText1, chipText2, textColor, chipColor,
                          isPrimaryCard: isPrimaryCard),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }

//small container
  Positioned _smallContainer(Color primary, double top, double left,
      {double radius = 10}) {
    return Positioned(
        top: top,
        left: left,
        child: CircleAvatar(
          radius: radius,
          backgroundColor: primary.withAlpha(255),
        ));
  }

//circular container
  Widget _circularContainer(double height, Color color,
      {Color borderColor = Colors.transparent, double borderWidth = 2}) {
    return Container(
      height: height,
      width: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: borderColor, width: borderWidth),
      ),
    );
  }

//decoration container
  Widget _decorationContainer(Color primary, double top, double left) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: top,
          left: left,
          child: CircleAvatar(
            maxRadius: MediaQuery.of(context).size.height / 1.792,
            backgroundColor: primary.withAlpha(255),
          ),
        ),
        _smallContainer(primary, 20, 90),
        Positioned(
          top: MediaQuery.of(context).size.height / 44.8,
          right: -MediaQuery.of(context).size.height / 29.87,
          child: _circularContainer(0, Colors.transparent,
              borderColor: Colors.white),
        )
      ],
    );
  }

  Widget _featuredRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            _card(
                primary: Color(0x2980b9),
                backWidget: _decorationContainer(
                    Colors.white,
                    MediaQuery.of(context).size.height / 17.92,
                    -MediaQuery.of(context).size.height / 29.87),
                chipColor: Colors.grey,
                chipText1: "Manage posts",
                chipText2: "",
                iconTop: MediaQuery.of(context).size.height / 44.8,
                iconLeft: MediaQuery.of(context).size.height / 89.6,
                textCardBottom: MediaQuery.of(context).size.height / 89.6,
                textCardLeft: MediaQuery.of(context).size.height / 89.6,
                h: MediaQuery.of(context).size.height / 4.5,
                w: MediaQuery.of(context).size.width * 0.42,
                page: "ManagePost",
                isPrimaryCard: true,
                imgPath: "assets/images/onboarding1.jpeg"),
            _card(
                primary: Color(0x2980b9),
                backWidget: _decorationContainer(
                    Colors.white,
                    MediaQuery.of(context).size.height / 17.92,
                    -MediaQuery.of(context).size.height / 29.87),
                chipColor: Colors.grey,
                chipText1: "Create new Post",
                page: "NewPost",
                iconTop: MediaQuery.of(context).size.height / 44.8,
                iconLeft: MediaQuery.of(context).size.height / 89.6,
                textCardBottom: MediaQuery.of(context).size.height / 89.6,
                textCardLeft: MediaQuery.of(context).size.height / 89.6,
                h: MediaQuery.of(context).size.height / 4.5,
                w: MediaQuery.of(context).size.width * 0.42,
                chipText2: "",
                imgPath: "assets/images/onboarding1.jpeg"),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(children: [
      _buildHeader(),
      SizedBox(height: 10),
      _featuredRow(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      drawer: NavDrawer(widget.db),
      appBar: AppBar(
        actions: [
          Padding(
            padding:
                const EdgeInsets.only(left: 0, right: 20, top: 10, bottom: 10),
            child: Stack(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.notifications_outlined,
                    color: Color(0xFF162A49),
                    size: 26,
                  ),
                  onPressed: () {
                    print("yh");
                  },
                ),
                Positioned(
                  top: 0.0,
                  right: -5.0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.red),
                    alignment: Alignment.center,
                    child: Text('18'),
                  ),
                )
              ],
            ),
          )
        ],
        elevation: 0,
        backgroundColor: Color(0xf9faf9),
        leading: IconButton(
          icon: Icon(Icons.menu,
              color: Color(0xFF162A49),
              size: MediaQuery.of(context).size.width / 13),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
      ),
      body: Center(
        child: _buildContent(),
      ),
    ));
  }
}
