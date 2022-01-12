import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:finder/components/dialog.dart';
import 'package:finder/screens/search_result.dart';
import 'package:finder/helper/db/mongodb.dart';

const double minHeight = 80;
const double iconStartSize = 44;
const double iconEndSize = 120;
const double iconStartMarginTop = 36;
const double iconEndMarginTop = 80;
const double iconsVerticalSpacing = 24;
const double iconsHorizontalSpacing = 16;

class BottomNav extends StatefulWidget {
  final dynamic db;

  BottomNav({Key key, this.db}) : super(key: key);
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> with TickerProviderStateMixin {
  AnimationController _controller;

  double get maxHeight => MediaQuery.of(context).size.height;
  double get headerTopMargin =>
      lerp(20, 20 + MediaQuery.of(context).padding.top);
  double get headerFontSize => lerp(14, 24);
  double get itemBorderRadius => lerp(8, 24);
  double get iconLeftBorderRadius => itemBorderRadius;
  double get iconRightBorderRadius => lerp(8, 0);
  double get iconSize => lerp(iconStartSize, iconEndSize);

  double iconTopMargin(int index) =>
      lerp(iconStartMarginTop,
          iconEndMarginTop + index * (iconsVerticalSpacing + iconEndSize)) +
      headerTopMargin;

  double iconLeftMargin(int index) =>
      lerp(index * (iconsHorizontalSpacing + iconStartSize), 0);

  TextEditingController searchController = TextEditingController();
  TextEditingController minSize = TextEditingController();
  TextEditingController maxSize = TextEditingController();
  TextEditingController minPrice = TextEditingController();
  TextEditingController maxPrice = TextEditingController();
  bool houseValue = false;
  bool apartmentValue = false;

  dynamic makeAsearch(requestObject) async {
    var result = await MongoDatabase.search(requestObject, widget.db);

    return result;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double lerp(double min, double max) =>
      lerpDouble(min, max, _controller.value);

  Widget _buildSheetHeader({double fontSize, double topMargin}) {
    return Positioned(
      top: topMargin,
      child: Text(
        'Search with filters',
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize * 1.1,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          height: lerp(minHeight, maxHeight),
          left: 0,
          right: 0,
          bottom: 0,
          child: GestureDetector(
            //onTap: _toggle,
            onVerticalDragUpdate: _handleDragUpdate,
            onVerticalDragEnd: _handleDragEnd,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 12),
              decoration: const BoxDecoration(
                color: Color(0xFF162A49),
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: MediaQuery.of(context).size.width / 1.4,
                    right: 0,
                    bottom: MediaQuery.of(context).size.height / 23.2,
                    child: InkWell(
                      onTap: _toggle,
                      child: Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: MediaQuery.of(context).size.height / 29,
                      ),
                    ),
                  ),
                  _buildSheetHeader(
                    fontSize: headerFontSize,
                    topMargin: headerTopMargin,
                  ),
                  _buildExpandedEventItem(
                    topMargin: iconTopMargin(0),
                    leftMargin: iconLeftMargin(0),
                    height: iconSize,
                    isVisible: _controller.status == AnimationStatus.completed,
                    borderRadius: itemBorderRadius,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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

  Widget _buildSearchBar() {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 187.5,
                bottom: MediaQuery.of(context).size.height / 81.2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height / 100),
                TextField(
                  textInputAction: TextInputAction.search,
                  autofocus: false,
                  controller: searchController,
                  style: TextStyle(color: Color(0xFF162A49)),
                  keyboardType: TextInputType.text,
                  onSubmitted: (value) async {
                    var searchedValue = searchController.text;
                    var minSizeValue = minSize.text;
                    var maxSizeValue = maxSize.text;
                    var minPriceValue = minPrice.text;
                    var maxPriceValue = maxPrice.text;

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
                    } else if (!RegExp(r'^[0-9]{0,}$').hasMatch(minSizeValue) ||
                        !RegExp(r'^[0-9]{0,}$').hasMatch(maxSizeValue) ||
                        !RegExp(r'^[0-9]{0,}$').hasMatch(minPriceValue) ||
                        !RegExp(r'^[0-9]{0,}$').hasMatch(maxPriceValue)) {
                      print("input error");
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDialogBox(
                              title: "Input error",
                              description:
                                  "please enter correct values for the filters.",
                              btnText: "Close",
                            );
                          });
                    } else {
                      showSpinner(context, "Searching...");

                      dynamic requestObject = {};
                      requestObject["searchedValue"] = searchedValue;
                      if (minSizeValue != "") {
                        requestObject["minSize"] = minSizeValue;
                      } else {
                        requestObject["minSize"] = 100;
                      }
                      if (maxSizeValue != "") {
                        requestObject["maxSize"] = maxSizeValue;
                      } else {
                        requestObject["maxSize"] = 10000;
                      }
                      if (minPriceValue != "") {
                        requestObject["minPrice"] = minPriceValue;
                      } else {
                        requestObject["minPrice"] = 100;
                      }
                      if (maxPriceValue != "") {
                        requestObject["maxPrice"] = maxPriceValue;
                      } else {
                        requestObject["maxPrice"] = 999999999999;
                      }
                      if (houseValue == true) {
                        requestObject["category"] = "house";
                      } else if (apartmentValue == true) {
                        requestObject["category"] = "apartment";
                      } else {
                        requestObject["category"] = "";
                      }
                      dynamic resultList = await makeAsearch(requestObject);
                      searchController.text = minSize.text =
                          maxSize.text = minPrice.text = maxPrice.text = "";
                      apartmentValue = false;
                      houseValue = false;
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => SearchResultPage(
                                searchResult: resultList,
                                db: widget.db,
                              )));
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'City, district or description',
                    contentPadding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.height / 90,
                        right: MediaQuery.of(context).size.height / 90),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide:
                            BorderSide(color: Color(0xFF162A49), width: 1.0)),
                    labelStyle: TextStyle(color: Color(0xFF162A49)),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xFF162A49),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildFilterItem() {
    return Column(
      children: <Widget>[filterItem()],
    );
  }

  Widget filterItem() {
    return Container(
        child: Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height / 162.4),
        Text("Filters:",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            )),
        SizedBox(height: MediaQuery.of(context).size.height / 54),
        Text("Category"),
        Row(children: [
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width / 37.5),
            child: Row(
              children: [
                Text("House"),
                Checkbox(
                  value: houseValue,
                  onChanged: (bool value) {
                    setState(() {
                      apartmentValue = false;
                      houseValue = value;
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 54),
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width / 6.25),
            child: Row(
              children: [
                Text("Apartment"),
                Checkbox(
                  value: apartmentValue,
                  onChanged: (bool value) {
                    setState(() {
                      houseValue = false;
                      apartmentValue = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ]),
        SizedBox(height: MediaQuery.of(context).size.height / 81),
        Row(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 15,
                      bottom: MediaQuery.of(context).size.height / 81),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height / 30,
                    child: TextFormField(
                      controller: minSize,
                      keyboardType: TextInputType.number,
                      onTap: () {},
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.height / 100,
                              right: MediaQuery.of(context).size.height / 100),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.0)),
                          labelStyle: TextStyle(color: Colors.grey),
                          labelText: '100'),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / 55,
                  bottom: MediaQuery.of(context).size.height / 67.5),
              child: Text("< size <",
                  style: TextStyle(
                    color: Color(0xFF162A49),
                    fontSize: MediaQuery.of(context).size.height / 50.75,
                    fontWeight: FontWeight.w500,
                  )),
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.height / 54,
                      bottom: MediaQuery.of(context).size.height / 81),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height / 30,
                    child: TextFormField(
                      controller: maxSize,
                      keyboardType: TextInputType.number,
                      onTap: () {},
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.height / 100,
                              right: MediaQuery.of(context).size.height / 100),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.0)),
                          labelStyle: TextStyle(color: Colors.grey),
                          labelText: '10000'),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height / 81),
        Row(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 25,
                      bottom: MediaQuery.of(context).size.height / 81),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height / 30,
                    child: TextFormField(
                      controller: minPrice,
                      keyboardType: TextInputType.number,
                      onTap: () {},
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.height / 100,
                              right: MediaQuery.of(context).size.height / 100),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.0)),
                          labelStyle: TextStyle(color: Colors.grey),
                          labelText: '100'),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / 25,
                  bottom: MediaQuery.of(context).size.height / 67.5),
              child: Text("< price <",
                  style: TextStyle(
                    color: Color(0xFF162A49),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  )),
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 25,
                      bottom: MediaQuery.of(context).size.height / 81),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height / 30,
                    child: TextFormField(
                      controller: maxPrice,
                      keyboardType: TextInputType.number,
                      onTap: () {},
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.height / 100,
                              right: MediaQuery.of(context).size.height / 100),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.0)),
                          labelStyle: TextStyle(color: Colors.grey),
                          labelText: '10000'),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    ));
  }

  Widget _buildExpandedEventItem(
      {double topMargin,
      double leftMargin,
      double height,
      bool isVisible,
      double borderRadius}) {
    return Stack(
      children: [
        Positioned(
          top: MediaQuery.of(context).size.height / 7,
          left: leftMargin,
          right: 0,
          // height: 85,
          child: AnimatedOpacity(
            opacity: isVisible ? 1 : 0,
            duration: Duration(milliseconds: 200),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                color: Colors.white,
              ),
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / 37.5,
                  right: MediaQuery.of(context).size.width / 37.5,
                  top: 0,
                  bottom: 0),
              child: _buildSearchBar(),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 4,
          left: leftMargin,
          right: 0,
          // height: 85,
          child: AnimatedOpacity(
            opacity: isVisible ? 1 : 0,
            duration: Duration(milliseconds: 200),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                color: Colors.white,
              ),
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / 37.5,
                  right: MediaQuery.of(context).size.width / 37.5,
                  top: 0,
                  bottom: 0),
              child: _buildFilterItem(),
            ),
          ),
        ),
      ],
    );
  }

  void _toggle() {
    final bool isOpen = _controller.status == AnimationStatus.completed;
    _controller.fling(velocity: isOpen ? -2 : 2);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _controller.value -= details.primaryDelta / maxHeight;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;

    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / maxHeight;
    if (flingVelocity < 0.0)
      _controller.fling(velocity: math.max(2.0, -flingVelocity));
    else if (flingVelocity > 0.0)
      _controller.fling(velocity: math.min(-2.0, -flingVelocity));
    else
      _controller.fling(velocity: _controller.value < 0.5 ? -2.0 : 2.0);
  }
}
