import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:finder/screens/customer_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  dynamic _controller;
  dynamic _animation;

  @override
  initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 20), vsync: this)
          ..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.5)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  List<dynamic> _appartements = [
    {
      'title': 'Modern \nOnboardingPage',
      'sub_title': 'Choose From Thousands Of Items That Fits Your Choice.',
      'image': 'assets/images/onboarding1.jpeg'
    },
    {
      'title': 'Modern \nFurniture',
      'sub_title': 'Choose From Thousands Of Items That Fits Your Choice.',
      'image': 'assets/images/onboarding2.jpeg'
    },
    {
      'title': 'Modern \nFurniture',
      'sub_title': 'Choose From Thousands Of Items That Fits Your Choice.',
      'image': 'assets/images/onboarding3.jpeg'
    },
    {
      'title': 'Modern \nFurniture',
      'sub_title': 'Choose From Thousands Of Items That Fits Your Choice.',
      'image': 'assets/images/onboarding4.jpeg'
    }
  ];

  @override
  void dispose() {
    _controller.dispose();
    //_animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        onPageChanged: (int index) {
          _controller.value = 0.0;
          _controller.forward();
        },
        itemBuilder: (context, index) {
          return Container(
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(),
                  child: ScaleTransition(
                    scale: _animation,
                    child: Image.asset(
                      _appartements[index]['image'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                      padding: EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              colors: [
                            Colors.black.withOpacity(0.9),
                            Colors.black.withOpacity(0.8),
                            Colors.black.withOpacity(0.2),
                            Colors.black.withOpacity(0.1)
                          ])),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FadeInDown(
                              duration: Duration(milliseconds: 500),
                              child: Text(
                                _appartements[index]['title'],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            FadeInDown(
                                delay: Duration(milliseconds: 100),
                                duration: Duration(milliseconds: 800),
                                child: Text(
                                  _appartements[index]['sub_title'],
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 18,
                                  ),
                                )),
                            SizedBox(
                              height: 50,
                            ),
                            FadeInLeft(
                              delay: Duration(milliseconds: 100),
                              duration: Duration(milliseconds: 1000),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    onPressed: () async {
                                      SharedPreferences pref =
                                          await SharedPreferences.getInstance();
                                      pref.setBool("firstTime", true);
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  CustomerHomePage()));
                                    },
                                    color: Colors.orange,
                                    padding: EdgeInsets.only(
                                        right: 5, left: 30, top: 5, bottom: 5),
                                    child: Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Row(
                                        children: [
                                          Text(
                                            'Get Started',
                                            style: TextStyle(
                                              color: Colors.orange.shade50,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Spacer(),
                                          Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  color: Colors.orange.shade300,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          40)),
                                              child: Icon(
                                                Icons.arrow_forward,
                                                color: Colors.orange.shade100,
                                              )),
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                            SizedBox(height: 50),
                          ])),
                )
              ],
            ),
          );
        },
        itemCount: _appartements.length,
        controller: PageController(viewportFraction: 1.0),
      ),
    );
  }
}
