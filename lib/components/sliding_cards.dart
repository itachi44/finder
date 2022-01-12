import 'dart:convert';
import 'package:charcode/charcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:finder/screens/see_post.dart';
import 'dart:math' as math;

class SlidingCards extends StatefulWidget {
  final dynamic data;
  final dynamic db;

  SlidingCards({Key key, this.db, this.data}) : super(key: key);

  @override
  _SlidingCardsState createState() => _SlidingCardsState();
}

class _SlidingCardsState extends State<SlidingCards> {
  PageController pageController;
  double pageOffset = 0;
  final DateFormat formatter = DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    pageController = PageController(viewportFraction: 0.8);
    pageController.addListener(() {
      pageOffset = pageController.page;
    });
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.55,
      child: PageView(
        controller: pageController,
        children: <Widget>[
          for (int i = 0; i < widget.data.length; i++)
            SlidingCard(
              title: widget.data[i]["title"],
              date: formatter.format(widget.data[i]["date"]).substring(0, 10),
              price: widget.data[i]["price"].toString() + ' \$',
              size: widget.data[i]["size"].toString() +
                  "m" +
                  String.fromCharCode($sup2),
              image: base64Decode(widget.data[i]["pictures"][1]["image"]),
              index: i,
              db: widget.db,
              posts: widget.data,
              offset: pageOffset,
            ),
        ],
      ),
    );
  }
}

class SlidingCard extends StatelessWidget {
  final String title;
  final String date;
  final String price;
  final String size;
  final dynamic image;
  final dynamic db;
  final dynamic posts;
  final int index;
  final double offset;

  const SlidingCard({
    Key key,
    @required this.title,
    @required this.date,
    @required this.price,
    @required this.size,
    @required this.index,
    @required this.db,
    @required this.posts,
    @required this.image,
    @required this.offset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double gauss = math.exp(-(math.pow((offset.abs() - 0.5), 2) / 0.08));
    return Transform.translate(
      offset: Offset(-32 * gauss * offset.sign, 0),
      child: Card(
        margin: EdgeInsets.only(left: 8, right: 8, bottom: 30),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              child: Image.memory(
                image,
                height: MediaQuery.of(context).size.height * 0.3,
                alignment: Alignment(-offset.abs(), 0),
                fit: BoxFit.none,
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: CardContent(
                  title: title,
                  date: date,
                  size: size,
                  price: price,
                  posts: posts,
                  db: db,
                  offset: gauss,
                  index: index),
            ),
          ],
        ),
      ),
    );
  }
}

class CardContent extends StatelessWidget {
  final String title;
  final String date;
  final String price;
  final String size;
  final dynamic posts;
  final dynamic db;
  final int index;
  final double offset;

  const CardContent(
      {Key key,
      @required this.title,
      @required this.date,
      @required this.price,
      @required this.size,
      @required this.db,
      @required this.posts,
      @required this.index,
      @required this.offset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Transform.translate(
            offset: Offset(8 * offset, 0),
            child: Text(title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 20)),
          ),
          SizedBox(height: 8),
          Transform.translate(
            offset: Offset(32 * offset, 0),
            child: Text(
              date,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          SizedBox(height: 8),
          Transform.translate(
            offset: Offset(32 * offset, 0),
            child: Text(
              size,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Spacer(),
          Row(
            children: <Widget>[
              Transform.translate(
                offset: Offset(48 * offset, 0),
                child: ElevatedButton(
                  onPressed: () {
                    dynamic data = posts[index];
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => SeePostPage(
                              post: data,
                              db: db,
                              getImages: false,
                            )));
                  },
                  child: Transform.translate(
                    offset: Offset(24 * offset, 0),
                    child: Text(
                      'Reserve',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.1,
                        fontSize: MediaQuery.of(context).size.height / 45,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xFF162A49),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      )),
                ),
              ),
              Spacer(),
              Transform.translate(
                offset: Offset(32 * offset, 0),
                child: Text(
                  price,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(width: 16),
            ],
          )
        ],
      ),
    );
  }
}
