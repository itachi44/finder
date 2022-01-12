import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:finder/screens/provider_home.dart';

class CustomDialogBox extends StatefulWidget {
  final String title, description, btnText;
  final dynamic color;
  final dynamic pageToGo;
  final dynamic db;

  const CustomDialogBox(
      {Key key,
      this.title,
      this.description,
      this.btnText,
      this.color = Colors.red,
      this.pageToGo,
      this.db})
      : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width / 18.75,
              top: MediaQuery.of(context).size.width / 6,
              right: MediaQuery.of(context).size.height / 40.5,
              bottom: MediaQuery.of(context).size.height / 40.5),
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 18),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height / 40.5,
                    fontWeight: FontWeight.w600,
                    color: widget.color),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 54,
              ),
              Text(
                widget.description,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height / 58),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 37,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                    onPressed: () {
                      if (widget.pageToGo != "") {
                        if (widget.pageToGo == "provider_home") {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ProviderHomePage(db: widget.db)));
                        } else {
                          Navigator.of(context).pop();
                        }
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(
                      widget.btnText,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height / 45),
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
