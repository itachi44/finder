import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:finder/screens/customer_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  final dynamic db;
  const OnboardingPage({Key key, this.db}) : super(key: key);

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
      'title': 'Find the appartment of your dream',
      'sub_title':
          'No need to search from left to right, Finder is here for that.',
      'image': 'assets/images/onboarding3.jpeg'
    },
    {
      'title': 'Find from anywhere',
      'sub_title':
          'Choose from hundreds of dwellings just in on click, every day, from any place.',
      'image': 'assets/images/onboarding6.jpeg'
    },
    {
      'title': 'Whatever your needs',
      'sub_title':
          'You can find apartments but also houses, which may be for rent or sale.',
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
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.height / 40.6),
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
                                    fontSize:
                                        MediaQuery.of(context).size.height /
                                            19.5,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 81,
                            ),
                            FadeInDown(
                                delay: Duration(milliseconds: 100),
                                duration: Duration(milliseconds: 800),
                                child: Text(
                                  _appartements[index]['sub_title'],
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize:
                                        MediaQuery.of(context).size.height / 45,
                                  ),
                                )),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 16,
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
                                      pref.setBool("isFirstTime", false);
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  CustomerHomePage(
                                                    db: widget.db,
                                                  )));
                                    },
                                    color: Colors.orange,
                                    padding: EdgeInsets.only(
                                        right:
                                            MediaQuery.of(context).size.width /
                                                75,
                                        left:
                                            MediaQuery.of(context).size.width /
                                                12.5,
                                        top:
                                            MediaQuery.of(context).size.height /
                                                162,
                                        bottom:
                                            MediaQuery.of(context).size.height /
                                                162),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              20,
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Row(
                                        children: [
                                          Text(
                                            'Get Started',
                                            style: TextStyle(
                                              color: Colors.orange.shade50,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  50,
                                            ),
                                          ),
                                          Spacer(),
                                          Container(
                                              padding: EdgeInsets.all(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      100),
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
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 16),
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
