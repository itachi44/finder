import 'package:flutter/material.dart';
import 'package:finder/helper/db/mongodb.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finder/screens/provider_home.dart';
import 'dart:async';
import 'dart:io';
import 'package:finder/components/dialog.dart';
import 'package:iconsax/iconsax.dart';
import 'package:finder/screens/error_page.dart';

class LogInPage extends StatefulWidget {
  final dynamic db;
  LogInPage({Key key, this.db}) : super(key: key);

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  int activeIndex = 0;
  TextEditingController identifierController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  dynamic connectProvider(providerData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var result = await MongoDatabase.handleConnection(providerData, widget.db);
    if (result.length == 1) {
      print("we can go to provider page");
      prefs.setBool("isProviderAuthenticated", true);
      prefs.setString("providerUsername", result[0]["account"]["username"]);
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => ProviderHomePage()));
    } else {
      print("we should show an error message");
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: "Input error",
              description: "The username or password is incorrect.",
              btnText: "Close",
            );
          });
    }
  }

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      if (this.mounted) {
        setState(() {
          activeIndex++;

          if (activeIndex == 4) activeIndex = 0;
        });
      }
    });
    super.initState();
  }

  showSpinner(BuildContext context, dynamic content) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF162A49)),
          ),
          Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.height / 179.2),
              child: Text(content)),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _buildLogIn() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                height: 280,
                child: Stack(children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: AnimatedOpacity(
                      opacity: activeIndex == 0 ? 1 : 0,
                      duration: Duration(
                        seconds: 1,
                      ),
                      curve: Curves.linear,
                      child: Image.network(
                        'https://ouch-cdn2.icons8.com/As6ct-Fovab32SIyMatjsqIaIjM9Jg1PblII8YAtBtQ/rs:fit:784:784/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvNTg4/LzNmMDU5Mzc0LTky/OTQtNDk5MC1hZGY2/LTA2YTkyMDZhNWZl/NC5zdmc.png',
                        height: 400,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: AnimatedOpacity(
                      opacity: activeIndex == 1 ? 1 : 0,
                      duration: Duration(seconds: 1),
                      curve: Curves.linear,
                      child: Image.network(
                        'https://ouch-cdn2.icons8.com/vSx9H3yP2D4DgVoaFPbE4HVf6M4Phd-8uRjBZBnl83g/rs:fit:784:784/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvNC84/MzcwMTY5OS1kYmU1/LTQ1ZmEtYmQ1Ny04/NTFmNTNjMTlkNTcu/c3Zn.png',
                        height: 400,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: AnimatedOpacity(
                      opacity: activeIndex == 2 ? 1 : 0,
                      duration: Duration(seconds: 1),
                      curve: Curves.linear,
                      child: Image.network(
                        'https://ouch-cdn2.icons8.com/fv7W4YUUpGVcNhmKcDGZp6pF1-IDEyCjSjtBB8-Kp_0/rs:fit:784:784/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvMTUv/ZjUzYTU4NDAtNjBl/Yy00ZWRhLWE1YWIt/ZGM1MWJmYjBiYjI2/LnN2Zw.png',
                        height: 400,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: AnimatedOpacity(
                      opacity: activeIndex == 3 ? 1 : 0,
                      duration: Duration(seconds: 1),
                      curve: Curves.linear,
                      child: Image.network(
                        'https://ouch-cdn2.icons8.com/AVdOMf5ui4B7JJrNzYULVwT1z8NlGmlRYZTtg1F6z9E/rs:fit:784:767/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvOTY5/L2NlMTY1MWM5LTRl/ZjUtNGRmZi05MjQ3/LWYzNGQ1MzhiOTQ0/Mi5zdmc.png',
                        height: 300,
                      ),
                    ),
                  )
                ]),
              ),
              SizedBox(
                height: 40,
              ),
              TextFormField(
                controller: identifierController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(0.0),
                  labelText: 'Username',
                  hintText: 'Username or e-mail',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.0,
                  ),
                  prefixIcon: Icon(
                    Iconsax.user,
                    color: Colors.black,
                    size: 18,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey.shade200, width: 2),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: passwordController,
                keyboardType: TextInputType.text,
                obscureText: true,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(0.0),
                  labelText: 'Password',
                  hintText: 'Password',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.0,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: Icon(
                    Iconsax.key,
                    color: Colors.black,
                    size: 18,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey.shade200, width: 2),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              MaterialButton(
                onPressed: () async {
                  try {
                    final result = await InternetAddress.lookup('google.com');
                    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                      if (_formKey.currentState.validate()) {
                        var identifier = identifierController.text;
                        var password = passwordController.text;
                        var providerData = {
                          "identifier": identifier,
                          "password": password
                        };
                        showSpinner(context, "connection");
                        connectProvider(providerData);
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialogBox(
                                title: "Input error",
                                description: "please enter correct values.",
                                btnText: "Close",
                              );
                            });
                      }
                    }
                  } on SocketException catch (_) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ErrorPage(pageToGo: "/logIn")));
                  }
                },
                height: 45,
                color: Color(0xFF162A49),
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account?',
                    style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Register',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                "LogIn",
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
            body: Center(
              child: _buildLogIn(),
            )));
  }
}
