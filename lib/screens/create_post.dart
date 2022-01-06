import 'package:flutter/material.dart';

class NewPostPage extends StatefulWidget {
  final dynamic db;
  NewPostPage({Key key, this.db}) : super(key: key);

  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          "Create a new post",
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
      body: Center(child: Text("create new post here")),
    ));
  }
}
