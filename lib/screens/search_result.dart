import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:finder/helper/db/mongodb.dart';
import 'package:intl/intl.dart';
import 'package:finder/components/loading.dart';

class SearchResultPage extends StatefulWidget {
  final dynamic searchResult;
  final dynamic db;
  SearchResultPage({Key key, this.searchResult, this.db}) : super(key: key);

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage>
    with TickerProviderStateMixin {
  bool _showBackToTopButton = false;
  ScrollController _scrollController = ScrollController();

  dynamic searchResultList;
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  //ScrollPhysics _physics = ClampingScrollPhysics();

  @override
  void initState() {
    super.initState();
    searchResultList = widget.searchResult;
    buildResult();
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels <= 56)
    //     setState(() => _physics = ClampingScrollPhysics());
    //   else
    //     setState(() => _physics = BouncingScrollPhysics());
    // });

    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (_scrollController.offset >= 400) {
            _showBackToTopButton = true; // show the back-to-top button
          } else {
            _showBackToTopButton = false; // hide the back-to-top button
          }
        });
      });
  }

  buildResult() async {
    var resultCopy = List.from(searchResultList);
    searchResultList = await MongoDatabase.getImages(resultCopy, widget.db);
  }

  @override
  void dispose() {
    _scrollController.dispose(); // dispose the controller
    super.dispose();
  }

  // This function is triggered when the user presses the back-to-top button
  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: Duration(milliseconds: 400), curve: Curves.linear);
  }

  Widget resultCard(
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
              child: Image.memory(
                base64Decode(img),
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: 360,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFF162A49), width: 1.5),
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

  Widget _buildResult() {
    return Container(
        child: ListView.builder(
            itemCount: searchResultList.length,
            controller: _scrollController,
            //physics: _physics,
            itemBuilder: (context, position) => InkWell(
                  onTap: () {
                    dynamic id = searchResultList[position]["id"];
                    dynamic data = searchResultList[position];
                  },
                  child: resultCard(
                      img: searchResultList[position]["pictures"][0]["image"],
                      title: searchResultList[position]["title"],
                      date: searchResultList[position]["date"],
                      price: searchResultList[position]["price"],
                      location: searchResultList[position]["country"] +
                          ", " +
                          searchResultList[position]["city"] +
                          ", " +
                          searchResultList[position]["district"]),
                )));
  }

  Widget _buildContent() {
    return FutureBuilder<dynamic>(
        future: buildResult(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SkeletonLoading();
          } else {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return _buildResult();
            }
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          "Results",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF162A49),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: _buildContent(),
      floatingActionButton: _showBackToTopButton == false
          ? null
          : FloatingActionButton(
              onPressed: _scrollToTop,
              child: Icon(Icons.arrow_upward),
            ),
    ));
  }
}
