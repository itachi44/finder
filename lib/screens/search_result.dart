import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:finder/screens/see_post.dart';

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
    //buildResult();
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
      {String title, dynamic date, dynamic price, dynamic location}) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height / 101.5),
      child: Stack(
        children: [
          Positioned(
            child: ClipRRect(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(1),
                right: Radius.circular(1),
              ),
              child: Image.asset(
                "assets/images/onboarding2.jpeg",
                height: MediaQuery.of(context).size.height / 8,
                width: MediaQuery.of(context).size.width / 3.75,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.05,
            height: MediaQuery.of(context).size.height / 8,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFF162A49), width: 1.5),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 4),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: Text(title,
                        textAlign: TextAlign.center,
                        //overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height / 50.75)),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 81),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 3),
                  child: Row(
                    children: <Widget>[
                      Text(
                        formatter.format(date).substring(0, 10),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: MediaQuery.of(context).size.height / 67.5,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 18.75),
                      Text(
                        price.toString() + "\$",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: MediaQuery.of(context).size.height / 67.5,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                //SizedBox(height: 10),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 3.75),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.place,
                          color: Colors.grey.shade400,
                          size: MediaQuery.of(context).size.height / 50.75),
                      Expanded(
                        child: Text(
                          location,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Color(0xFF162A49),
                              fontSize:
                                  MediaQuery.of(context).size.height / 62.5),
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
                    dynamic data = searchResultList[position];
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            SeePostPage(post: data, db: widget.db)));
                  },
                  child: resultCard(
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          "Results",
          style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.height / 50.75,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF162A49),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: _buildResult(),
      floatingActionButton: _showBackToTopButton == false
          ? null
          : FloatingActionButton(
              onPressed: _scrollToTop,
              child: Icon(Icons.arrow_upward),
            ),
    ));
  }
}
