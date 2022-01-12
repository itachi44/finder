import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:finder/helper/db/mongodb.dart';
import 'package:finder/components/extension.dart';
import 'package:finder/components/message_dialog.dart';
import 'package:finder/components/title_text.dart';
import 'package:async/async.dart';
import 'package:charcode/charcode.dart';
import 'package:loading_indicator/loading_indicator.dart';

class SeePostPage extends StatefulWidget {
  final dynamic post;
  final dynamic db;
  final dynamic getImages;
  SeePostPage({Key key, this.db, this.post, this.getImages}) : super(key: key);

  @override
  _SeePostPageState createState() => _SeePostPageState();
}

class _SeePostPageState extends State<SeePostPage>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  dynamic completePost;
  dynamic imageCenter;
  dynamic imagePosition1;
  dynamic imagePosition2;
  dynamic imagePosition3;
  dynamic location, price, size, description, date, title, category;

  @override
  void initState() {
    super.initState();
    if (widget.getImages == false) {
      buildResult();
    } else {
      getImagesAndbuildResult();
    }
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInToLinear));
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _icon(
    IconData icon, {
    Color color = const Color(0xffa8a09b),
    double size = 20,
    double padding = 10,
    bool isOutLine = false,
    Function onPressed,
  }) {
    return Container(
      height: MediaQuery.of(context).size.height / 20,
      width: MediaQuery.of(context).size.width / 9,
      padding: EdgeInsets.all(padding),
      // margin: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        border: Border.all(
            color: const Color(0xffa8a09b),
            style: isOutLine ? BorderStyle.solid : BorderStyle.none),
        borderRadius: BorderRadius.all(Radius.circular(13)),
        color:
            isOutLine ? Colors.transparent : Theme.of(context).backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Color(0xfff8f8f8),
              blurRadius: 5,
              spreadRadius: 10,
              offset: Offset(5, 5)),
        ],
      ),
      child: Icon(icon, color: color, size: size),
    ).ripple(() {
      if (onPressed != null) {
        onPressed();
      }
    }, borderRadius: BorderRadius.all(Radius.circular(13)));
  }

  bool isLiked = false;
  Widget _appBar() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 18.75,
          vertical: MediaQuery.of(context).size.height / 81),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _icon(
            Icons.arrow_back_ios,
            color: Colors.black54,
            size: MediaQuery.of(context).size.height / 54,
            padding: MediaQuery.of(context).size.height / 67.5,
            isOutLine: true,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          _icon(isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Color(0xffF72804) : Color(0xffE1E2E4),
              size: MediaQuery.of(context).size.height / 54,
              padding: MediaQuery.of(context).size.height / 67.5,
              isOutLine: false, onPressed: () {
            setState(() {
              isLiked = !isLiked;
            });
          }),
        ],
      ),
    );
  }

  final DateFormat formatter = DateFormat('dd-MM-yyyy');

  getImagesAndbuildResult() {
    return this._memoizer.runOnce(() async {
      var postCopy = Map.from(widget.post);
      completePost = await MongoDatabase.getImages(postCopy, widget.db);
      setState(() {
        completePost = completePost;
        category = completePost["category"];
        location = completePost['country'] +
            ", " +
            completePost['city'] +
            " : " +
            completePost['district'];
        date = formatter.format(completePost["date"]).substring(0, 10);
        price = completePost["price"];
        size = completePost["size"];
        title = completePost["title"];
        description = completePost["description"];
        imageCenter = completePost["pictures"][0]["image"];
        if (completePost["pictures"].asMap().containsKey(1)) {
          imagePosition1 = completePost["pictures"][1]["image"];
        }
        if (completePost["pictures"].asMap().containsKey(2)) {
          imagePosition2 = completePost["pictures"][2]["image"];
        }
        if (completePost["pictures"].asMap().containsKey(3)) {
          imagePosition3 = completePost["pictures"][3]["image"];
        }
      });
    });
  }

  buildResult() {
    setState(() {
      completePost = widget.post;
      category = completePost["category"];
      location = completePost['country'] +
          ", " +
          completePost['city'] +
          " : " +
          completePost['district'];
      date = formatter.format(completePost["date"]).substring(0, 10);
      price = completePost["price"];
      size = completePost["size"];
      title = completePost["title"];
      description = completePost["description"];
      imageCenter = completePost["pictures"][0]["image"];
      if (completePost["pictures"].asMap().containsKey(1)) {
        imagePosition1 = completePost["pictures"][1]["image"];
      }
      if (completePost["pictures"].asMap().containsKey(2)) {
        imagePosition2 = completePost["pictures"][2]["image"];
      }
      if (completePost["pictures"].asMap().containsKey(3)) {
        imagePosition3 = completePost["pictures"][3]["image"];
      }
    });
  }

  Widget _productImage() {
    return AnimatedBuilder(
      builder: (context, child) {
        return AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: animation.value,
          child: child,
        );
      },
      animation: animation,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height / 101.5),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(32), bottom: Radius.circular(32)),
              child: Image.memory(
                base64Decode(imageCenter),
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height / 3.8,
                fit: BoxFit.fill,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _thumbnail(dynamic image) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => AnimatedOpacity(
        opacity: animation.value,
        duration: Duration(milliseconds: 500),
        child: child,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 37.5),
        child: AbsorbPointer(
          child: Container(
            height: MediaQuery.of(context).size.height / 20,
            width: MediaQuery.of(context).size.width / 6,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: MemoryImage(image),
              ),
              border: Border.all(
                color: const Color(0xffa8a09b),
              ),
              borderRadius: BorderRadius.all(Radius.circular(13)),

              // color: Theme.of(context).backgroundColor,
            ),
          ).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(13))),
        ),
      ),
    );
  }

  Widget _locationRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Icon(Icons.location_city),
            SizedBox(
              width: MediaQuery.of(context).size.width / 75,
            ),
            TitleText(
              text: "Location",
              fontSize: MediaQuery.of(context).size.height / 54,
            ),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height / 40.5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: TitleText(
                text: location,
                fontSize: MediaQuery.of(context).size.height / 58,
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _description() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Icon(Icons.description_outlined),
            SizedBox(
              width: MediaQuery.of(context).size.width / 75,
            ),
            TitleText(
              text: "Description",
              fontSize: MediaQuery.of(context).size.height / 54,
            ),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height / 40.5),
        Text(description),
      ],
    );
  }

  Widget _detailWidget() {
    return DraggableScrollableSheet(
      maxChildSize: .8,
      initialChildSize: .53,
      minChildSize: .53,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 18.75,
                  vertical: MediaQuery.of(context).size.height / 81)
              .copyWith(bottom: 0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              color: Colors.white),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height / 162.5),
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 7.5,
                    height: MediaQuery.of(context).size.height / 162.5,
                    decoration: BoxDecoration(
                        color: Color(0xffa8a09b),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 81),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TitleText(
                          text: title.toUpperCase(),
                          fontSize: MediaQuery.of(context).size.height / 32.5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 81,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              TitleText(
                                text: "\$ ",
                                fontSize:
                                    MediaQuery.of(context).size.height / 45,
                                color: Color(0xffF72804),
                              ),
                              category == "house"
                                  ? TitleText(
                                      text: price.toString(),
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              32.5,
                                    )
                                  : TitleText(
                                      text: price.toString() + " per month",
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              32.5,
                                    ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 81,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 75,
                              ),
                              TitleText(
                                text: size.toString(),
                                fontSize:
                                    MediaQuery.of(context).size.height / 37,
                              ),
                              TitleText(
                                text: "m" + String.fromCharCode($sup2),
                                fontSize:
                                    MediaQuery.of(context).size.height / 45,
                              ),
                              Spacer(),
                              Text(
                                "2022-11-10",
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height / 58,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 40.5,
                ),
                _locationRow(),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 40.5,
                ),
                _description(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _otherViewsWidget() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 10,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePosition1 != null)
              GestureDetector(
                  onTap: () {
                    setState(() {
                      var temp;
                      temp = imageCenter;
                      imageCenter = imagePosition1;
                      imagePosition1 = temp;
                    });
                  },
                  child: _thumbnail(base64Decode(imagePosition1))),
            if (imagePosition2 != null)
              GestureDetector(
                  onTap: () {
                    setState(() {
                      var temp;
                      temp = imageCenter;
                      imageCenter = imagePosition2;
                      imagePosition2 = temp;
                    });
                  },
                  child: _thumbnail(base64Decode(imagePosition2))),
            if (imagePosition3 != null)
              GestureDetector(
                  onTap: () {
                    setState(() {
                      var temp;
                      temp = imageCenter;
                      imageCenter = imagePosition3;
                      imagePosition3 = temp;
                    });
                  },
                  child: _thumbnail(base64Decode(imagePosition3))),
          ],
        ));
  }

  Widget _buildPost() {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Color(0xfffbfbfb),
            Color(0xfff7f7f7),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                _appBar(),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 81,
                ),
                _productImage(),
                _otherViewsWidget(),
              ],
            ),
            _detailWidget()
          ],
        ),
      ),
    );
  }

  final AsyncMemoizer _memoizer = AsyncMemoizer();

  Widget _buildContent() {
    if (completePost == null) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.all(
            MediaQuery.of(context).size.height / 12.5,
          ),
          child: Center(
            child: LoadingIndicator(
              indicatorType: Indicator.ballClipRotateMultiple,
              colors: const [Colors.white],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
          floatingActionButton: _floatingButton(), body: _buildPost());
    }
  }

  FloatingActionButton _floatingButton() {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return MessageDialog(
                provider: completePost["provider_id"],
                db: widget.db,
                post: completePost["_id"],
              );
            });
      },
      backgroundColor: Color(0xFF162A49),
      child: Icon(Icons.message,
          color: Theme.of(context).floatingActionButtonTheme.backgroundColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }
}
