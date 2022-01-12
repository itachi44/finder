import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:finder/screens/provider_home.dart';

class MessageDialog extends StatefulWidget {
  final dynamic provider;

  const MessageDialog({Key key, this.provider}) : super(key: key);

  @override
  _MessageDialogState createState() => _MessageDialogState();
}

class _MessageDialogState extends State<MessageDialog> {
  TextEditingController contact = TextEditingController();
  TextEditingController message = TextEditingController();

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
          padding: EdgeInsets.only(left: 20, top: 15, right: 20, bottom: 20),
          margin: EdgeInsets.only(top: 45),
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
                "Reserve with the provider",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Enter your contact information.",
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                      controller: contact,
                      style: TextStyle(color: Colors.black),
                      keyboardType: TextInputType.text,
                      onTap: () async {},
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.height / 90,
                              right: MediaQuery.of(context).size.height / 90),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.0)),
                          labelStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(
                            Icons.contact_phone_outlined,
                            color: Colors.blue,
                          ),
                          labelText: 'phone or email adress'),
                      //autovalidate: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "This field may not be empty.";
                        } else {
                          return null;
                        }
                      }),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Perhaps you would like to leave him a message?",
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.height / 112),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.height / 89.6,
                      right: MediaQuery.of(context).size.height / 89.6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                          height: MediaQuery.of(context).size.height / 100),
                      TextFormField(
                        controller: message,
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.height / 90,
                                right: MediaQuery.of(context).size.height / 90,
                                bottom:
                                    MediaQuery.of(context).size.height / 25),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.0)),
                            labelStyle: TextStyle(color: Colors.grey),
                            labelText: 'Write your message.'),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 22,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "submit",
                        style: TextStyle(fontSize: 18, color: Colors.green),
                      )),
                  TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "close",
                        style: TextStyle(fontSize: 18, color: Colors.red),
                      )),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
