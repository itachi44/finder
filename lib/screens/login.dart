import 'package:flutter/material.dart';
import 'package:finder/helper/db/mongodb.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finder/screens/provider_home.dart';

class LogInPage extends StatefulWidget {
  final dynamic db;
  LogInPage({Key key, this.db}) : super(key: key);

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  dynamic connectProvider() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //données de test
    var userDataTest = {"username": "bamba", "password": "passer123"};

    var result = await MongoDatabase.handleConnection(userDataTest, widget.db);
    if (result.length == 1) {
      print("we can go to provider page");
      prefs.setBool("isProviderAuthenticated", true);
      prefs.setString("providerUsername", result[0]["account"]["username"]);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => ProviderHomePage()));
    } else {
      print("we should show an error message");
    }
  }

  @override
  void initState() {
    super.initState();
    //test
    connectProvider();
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
              child: Text("Login page here"),
            )));
  }
}
