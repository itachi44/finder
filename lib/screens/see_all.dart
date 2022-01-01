import 'package:flutter/material.dart';
import 'package:finder/components/scrollable_post.dart';

class SeeAllPage extends StatefulWidget {
  @override
  _SeeAllPageState createState() => _SeeAllPageState();
}

class _SeeAllPageState extends State<SeeAllPage> {
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
            body: Container(
              child: ScrollablePostView(),
            )));
  }
}
