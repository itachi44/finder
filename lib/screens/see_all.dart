import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:finder/screens/see_post.dart';
import 'package:finder/components/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:finder/helper/db/mongodb.dart';

class SeeAllPage extends StatefulWidget {
  final dynamic db;
  SeeAllPage({Key key, this.db}) : super(key: key);

  @override
  _SeeAllPageState createState() => _SeeAllPageState();
}

class _SeeAllPageState extends State<SeeAllPage> with TickerProviderStateMixin {
  bool _showBackToTopButton = false;
  ScrollController _scrollController = ScrollController();
  dynamic searchResultList;
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  dynamic posts;
  dynamic initialPosts = [];

  void initState() {
    loadPosts();
    super.initState();
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

  Future getAllPosts(context) async {
    var posts = await MongoDatabase.getAllPosts(widget.db);
    return posts;
  }

  void loadPosts() async {
    posts = await getAllPosts(context);
    setState(() {
      posts = posts;
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

  Widget _buildCard(
      {String title, dynamic date, dynamic price, dynamic location}) {
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
                "assets/images/onboarding2.jpeg",
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

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    // await getAllPosts(context);
    setState(() {});
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    if (posts.length > initialPosts.length) {
      initialPosts.add((posts[initialPosts.length]));
      if (mounted) setState(() {});
      _refreshController.loadComplete();
    } else {
      _refreshController.loadNoData();
    }
  }

  Widget _buildPostsList() {
    return Container(
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
            onTap: () {
              dynamic data = posts[i];
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      SeePostPage(post: data, db: widget.db)));
            },
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

  bool isInside(initItems, item) {
    bool state = false;
    for (var i = 0; i < initItems.length; i++) {
      if (initItems[i] == item) {
        state = true;
      }
    }
    return state;
  }

  Widget _buildContent() {
    if (posts == null || posts.length == 0) {
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
          future: getAllPosts(context),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SkeletonLoading();
            } else {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                if (posts.length >= 6) {
                  for (var i = 0; i < 6; i++) {
                    if (!isInside(initialPosts, posts[i])) {
                      initialPosts.add(posts[i]);
                    }
                  }
                } else {
                  for (var i = 0; i < posts.length; i++) {
                    if (!isInside(initialPosts, posts[i])) {
                      initialPosts.add(posts[i]);
                    }
                  }
                }
                return _buildPostsList();
              }
            }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                "See all posts",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
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
            resizeToAvoidBottomInset: false,
            //backgroundColor: Color(0xfff2f3f7),
            floatingActionButton: _showBackToTopButton == false
                ? null
                : FloatingActionButton(
                    onPressed: _scrollToTop,
                    child: Icon(Icons.arrow_upward),
                  ),
            body: _buildContent()));
  }
}
