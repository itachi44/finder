import 'package:flutter/material.dart';

class ManagePostsPage extends StatefulWidget {
  final dynamic db;
  ManagePostsPage({Key key, this.db}) : super(key: key);

  @override
  _ManagePostsPageState createState() => _ManagePostsPageState();
}

class _ManagePostsPageState extends State<ManagePostsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          "Manage your posts",
          style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.height / 51,
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
      body: Center(child: Text("manage your posts here")),
    ));
  }
}
