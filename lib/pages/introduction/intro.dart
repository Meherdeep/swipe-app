import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:swipe_app/pages/login_signup/login.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  List assetName = ['splash_screen1.webp', 'splash_screen2.webp', 'splash_screen3.webp'];
  List titleText = ['Find Your Match', 'Discover Each Other', 'Plan A Date'];
  List bodyText = [
    'Sign up for free and meet people from all across the world',
    'Match with people of shared interests',
    'Plan your perfect date. Chat and pick a convenient spot'
  ];
  List backgroundColor = [Color(0xFFe7a819), Color(0xFFff7283), Color(0xFF668bca)];
  List btnColor = [Color(0xFFDE920C), Color(0xFFFEB5CD), Color(0xFF81A2D2)];

  PageController _controller = PageController(initialPage: 0, keepPage: false);

  Widget pageView({
    String assetName,
    String titleText,
    String bodyText,
    Color backgroundColor,
    Color btnColor,
    double index,
  }) {
    return Container(
      color: backgroundColor,
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                ),
                Container(
                  alignment: Alignment.topCenter,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    'assets/$assetName',
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.5,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                Text(
                  titleText,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w700,
                    fontSize: 30,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    bodyText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontSize: 15,
                    ),
                    maxLines: 3,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                RawMaterialButton(
                  onPressed: () {
                    if (index?.toInt() == 2) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    } else {}
                    _controller.jumpToPage((index + 1).toInt());
                  },
                  elevation: 10,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(color: btnColor, borderRadius: const BorderRadius.all(Radius.circular(10)), boxShadow: [
                      BoxShadow(
                        color: Colors.black26.withOpacity(0.2),
                        spreadRadius: 4,
                        blurRadius: 5,
                      )
                    ]),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Next',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'OpenSans',
                              fontSize: 20,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 18,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                DotsIndicator(
                  dotsCount: 3,
                  position: index,
                  decorator: DotsDecorator(color: Colors.white60, activeColor: Colors.white),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: PageView.builder(
          controller: _controller,
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (context, index) {
            return pageView(
              assetName: assetName[index],
              backgroundColor: backgroundColor[index],
              bodyText: bodyText[index],
              btnColor: btnColor[index],
              index: index.toDouble(),
              titleText: titleText[index],
            );
          },
        ),
      ),
    );
  }
}
