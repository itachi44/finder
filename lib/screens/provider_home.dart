import 'package:finder/helper/db/mongodb.dart';
import 'package:flutter/material.dart';
import 'package:finder/components/nav_drawer.dart';
import 'package:finder/components/tabs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:finder/components/dialog.dart';
import 'package:finder/screens/search_result.dart';
import 'package:finder/screens/create_post.dart';
import 'package:finder/screens/manage_posts.dart';
import 'package:finder/screens/error_page.dart';

import 'dart:io';

class ProviderHomePage extends StatefulWidget {
  final dynamic db;

  ProviderHomePage({Key key, this.db}) : super(key: key);

  @override
  _ProviderHomePageState createState() => _ProviderHomePageState();
}

class _ProviderHomePageState extends State<ProviderHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  double width;
  dynamic latestPosts = [];
  dynamic initialPosts = [];
  dynamic provider;
  TextEditingController filterStartDate = TextEditingController();
  TextEditingController filterEndDate = TextEditingController();
  TextEditingController searchController = TextEditingController();
  dynamic filterQuery = {};
  void checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}
    } on SocketException catch (_) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => ErrorPage(db: widget.db)));
    }
  }

  void loadLatestPosts() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    provider = preferences.getString("providerUsername");
    latestPosts = await getLatestPosts(context, provider);
  }

  @override
  void initState() {
    super.initState();
    checkConnection();
    filterStartDate.text = "";
    loadLatestPosts();
  }

  showSpinner(BuildContext context, dynamic content) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF162A49)),
          ),
          Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.height / 179.2),
              child: Text(content)),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

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
                    controller: searchController,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.black87,
                        ),
                        hintText: "Search you're looking for",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                    onSubmitted: (value) async {
                      var searchedValue = searchController.text;
                      if (searchedValue == "") {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialogBox(
                                title: "No entry",
                                description:
                                    "Search either a city, a district or a description",
                                btnText: "Close",
                              );
                            });
                      } else {
                        showSpinner(context, "Searching...");
                        filterQuery["searchedValue"] = searchedValue;
                        dynamic result = await MongoDatabase.providerSearch(
                            filterQuery, widget.db);
                        searchController.text = "";
                        print(result);
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                SearchResultPage(searchResult: result)));
                      }
                    }),
              ),
              IconButton(
                icon: Icon(Icons.tune,
                    color: Color(0xFF162A49),
                    size: MediaQuery.of(context).size.width / 13),
                splashColor: Colors.transparent,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return _buildFilterSelection();
                      });
                },
              )
            ],
          ),
        ],
      ),
    );
  }
//filter modal

  Widget _buildFilterSelection() {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: <Widget>[
            Container(
              padding:
                  EdgeInsets.only(left: 20, top: 15, right: 20, bottom: 20),
              margin: EdgeInsets.only(top: 45),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        offset: Offset(0, 10),
                        blurRadius: 10),
                  ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Choose filters to apply",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF162A49)),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Start date",
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2.3,
                      child: TextFormField(
                          controller: filterStartDate,
                          style: TextStyle(color: Colors.black),
                          readOnly: true,
                          keyboardType: TextInputType.text,
                          onTap: () async {
                            DateTime pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101));

                            if (pickedDate != null) {
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);

                              setState(() {
                                filterStartDate.text = formattedDate;
                              });
                            } else {
                              print("Date is not selected");
                            }
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.height / 90,
                                  right:
                                      MediaQuery.of(context).size.height / 90),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 0.0)),
                              labelStyle: TextStyle(color: Colors.grey),
                              prefixIcon: Icon(
                                Icons.date_range,
                                color: Colors.blue,
                              ),
                              labelText: '2021-09-09'),
                          //autovalidate: true,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "veuillez entrer la date.";
                            } else {
                              return null;
                            }
                          }),
                    ),
                  ),
                  Text(
                    "End date",
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2.3,
                      child: TextFormField(
                          controller: filterEndDate,
                          style: TextStyle(color: Colors.black),
                          readOnly: true,
                          keyboardType: TextInputType.text,
                          onTap: () async {
                            DateTime pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101));

                            if (pickedDate != null) {
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);

                              setState(() {
                                filterEndDate.text = formattedDate;
                              });
                            } else {
                              print("Date is not selected");
                            }
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.height / 90,
                                  right:
                                      MediaQuery.of(context).size.height / 90),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 0.0)),
                              labelStyle: TextStyle(color: Colors.grey),
                              prefixIcon: Icon(
                                Icons.date_range,
                                color: Colors.blue,
                              ),
                              labelText: '2021-09-09'),
                          //autovalidate: true,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "veuillez entrer la date.";
                            } else {
                              return null;
                            }
                          }),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            if ((filterStartDate.text.isNotEmpty &&
                                    filterEndDate.text.isEmpty) ||
                                (filterStartDate.text.isEmpty &&
                                    filterEndDate.text.isNotEmpty)) {
                              Navigator.of(context).pop();

                              print("Be sure to enter the start and end date");
                            } else if (filterStartDate.text.isNotEmpty &&
                                filterEndDate.text.isNotEmpty) {
                              if (DateFormat("yyyy-MM-dd")
                                  .parse(filterStartDate.text)
                                  .isBefore(DateFormat("yyyy-MM-dd")
                                      .parse(filterEndDate.text))) {
                                Navigator.of(context).pop();

                                print(
                                    "Start date must be lower than the end date");
                              }
                            } else {
                              if (filterStartDate.text != "") {
                                filterQuery["startDate"] = filterStartDate.text;
                              } else {
                                filterQuery["startDate"] = null;
                              }
                              if (filterEndDate.text != "") {
                                filterQuery["endDate"] = filterEndDate.text;
                              } else {
                                filterQuery["endDate"] = null;
                              }
                              print(filterQuery);
                              searchController.text = "";
                              filterEndDate.text = "";
                              filterStartDate.text = "";
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text(
                            "Apply",
                            style: TextStyle(fontSize: 18, color: Colors.green),
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Close",
                            style: TextStyle(fontSize: 18, color: Colors.red),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
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
        onTap: () {
          if (page == "NewPost") {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => NewPostPage(db: widget.db)));
          } else if (page == "ManagePost") {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    ManagePostsPage(db: widget.db)));
          }
        },
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
                h: MediaQuery.of(context).size.height / 5.4,
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
                h: MediaQuery.of(context).size.height / 5.4,
                w: MediaQuery.of(context).size.width * 0.42,
                chipText2: "",
                imgPath: "assets/images/onboarding1.jpeg"),
          ],
        ),
      ),
    );
  }

//latest posts section
  Future getLatestPosts(context, provider) async {
    latestPosts = await MongoDatabase.getLatestPosts(provider, widget.db);
    return latestPosts;
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  bool isInside(initItems, item) {
    bool state = false;
    for (var i = 0; i < initItems.length; i++) {
      if (initItems[i] == item) {
        state = true;
      }
    }
    return state;
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    //ajouter un nouvel élément
    print(latestPosts.length);
    print(initialPosts.length);
    if (latestPosts.length > initialPosts.length) {
      print("here");
      initialPosts.add((latestPosts[initialPosts.length]));
      if (mounted) setState(() {});
      _refreshController.loadComplete();
    } else {
      _refreshController.loadNoData();
    }
  }

  Widget _buildCard(
      {String img,
      String title,
      dynamic date,
      dynamic price,
      dynamic location}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Positioned(
            child: ClipRRect(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(1),
                right: Radius.circular(1),
              ),
              child: Image.asset(
                'assets/images/onboarding2.jpeg',
                height: 70,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: 360,
            height: 70,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white30, width: 1.5),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 95),
                  child: Container(
                    width: 250,
                    child: Text(title,
                        textAlign: TextAlign.center,
                        //overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16)),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(left: 120),
                  child: Row(
                    children: <Widget>[
                      Text(
                        formatter.format(date).substring(0, 10),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(width: 20),
                      Text(
                        price.toString() + "\$",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                //SizedBox(height: 10),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(left: 100),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.place, color: Colors.grey.shade400, size: 16),
                      Expanded(
                        child: Text(
                          location,
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyle(color: Color(0xFF162A49), fontSize: 13),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  final DateFormat formatter = DateFormat('dd-MM-yyyy');

  Widget _buildLatestPosts() {
    if (latestPosts == null) {
      return Container(
        height: MediaQuery.of(context).size.height / 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                    child: Text("No data at the moment...",
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height / 40))),
              ],
            )
          ],
        ),
      );
    } else {
      return FutureBuilder<dynamic>(
          future: getLatestPosts(context, provider),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                  height: MediaQuery.of(context).size.height / 5,
                  child: Center(
                    child: Text(
                      "Loading data...",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ));
            } else {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                if (latestPosts.length >= 4) {
                  for (var i = 0; i < 4; i++) {
                    if (!isInside(initialPosts, latestPosts[i])) {
                      initialPosts.add(latestPosts[i]);
                    }
                  }
                } else {
                  for (var i = 0; i < latestPosts.length; i++) {
                    if (!isInside(initialPosts, latestPosts[i])) {
                      initialPosts.add(latestPosts[i]);
                    }
                  }
                }
                return _buildPostsList();
              }
            }
          });
    }
  }

  Widget _buildPostsList() {
    return Container(
      height: MediaQuery.of(context).size.height / 4.5,
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("Pull up to load");
            } else if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("Failed to load! click to restart");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("free to load more");
            } else if (mode == LoadStatus.noMore) {
              body = Text("no more data");
            }
            return Container(
              height: 25.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.builder(
          itemBuilder: (c, i) => InkWell(
            onTap: () {},
            child: _buildCard(
                //img: result["img"], //TODO: handle images
                title: initialPosts[i]["title"],
                date: initialPosts[i]["date"],
                price: initialPosts[i]["price"],
                location: initialPosts[i]["country"] +
                    ", " +
                    initialPosts[i]["city"] +
                    ", " +
                    initialPosts[i]["district"]),
          ),
          //itemExtent: 100.0,
          itemCount: initialPosts.length,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(children: [
      _buildHeader(),
      SizedBox(height: 10),
      _featuredRow(),
      SizedBox(height: 10),
      Tabs("Latest posts"),
      SizedBox(height: 10),
      _buildLatestPosts()
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
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
