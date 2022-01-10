import 'package:flutter/material.dart';
import 'package:finder/helper/db/mongodb.dart';
import 'package:finder/components/loading.dart';

class SeePostPage extends StatefulWidget {
  final dynamic post;
  final dynamic db;
  SeePostPage({Key key, this.db, this.post}) : super(key: key);

  @override
  _SeePostPageState createState() => _SeePostPageState();
}

class _SeePostPageState extends State<SeePostPage> {
  dynamic completePost;

  buildResult() async {
    var postCopy = Map.from(widget.post);
    completePost = await MongoDatabase.getImages(postCopy, widget.db);
    print(postCopy);
  }

  Widget _buildPost() {
    return Center(
      child: Text("post here"),
    );
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
              return _buildPost();
            }
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: _buildContent()));
  }
}
