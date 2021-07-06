import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swipe_app/controller/session_controller.dart';
import 'package:swipe_app/helper/style.dart';
import 'package:swipe_app/pages/widgets/bottomNavBar.dart';
import 'package:swipe_app/pages/widgets/verticalSpacer.dart';

class UserProfile extends StatefulWidget {
  final SessionController controller;
  const UserProfile({Key key, this.controller}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  List<dynamic> userInterests;

  Map<int, String> interestsMap = {
    0: 'assets/interests/trips.jpg',
    1: 'assets/interests/movies.jpg',
    2: 'assets/interests/sports.jpg',
    3: 'assets/interests/board_games.jpg',
    4: 'assets/interests/music.jpg',
    5: 'assets/interests/photography.jpg'
  };

  @override
  void initState() {
    FirebaseFirestore.instance.collection('user').get().then((value) {
      setState(() {
        userInterests = value.docs[3].data()['interests'];
      });
      print(userInterests);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              child: Image.asset(
                'assets/profile/cover-pic.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.65,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/profile/profile-pic.jpg',
                          height: 150,
                        ),
                      ),
                    ),
                    VerticalSpacer(
                      percentage: 0.01,
                    ),
                    Text(
                      'Lizzie',
                      style: bigHeadingStyle.copyWith(fontSize: 24),
                    ),
                    VerticalSpacer(
                      percentage: 0.05,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Interests',
                            textAlign: TextAlign.left,
                            style: smallHeadingStyle,
                          ),
                          VerticalSpacer(
                            percentage: 0.01,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: double.infinity,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: userInterests?.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(right: 15),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.55,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.asset(
                                        interestsMap[userInterests[index]],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        controller: widget.controller,
      ),
    );
  }
}
