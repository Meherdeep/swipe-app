import 'package:flutter/material.dart';
import 'package:swipe_app/controller/session_controller.dart';
import 'package:swipe_app/data/interestclass.dart';
import 'package:swipe_app/data/user.dart';
import 'package:swipe_app/helper/style.dart';
import 'package:swipe_app/pages/interests/griditem.dart';
import 'package:swipe_app/pages/widgets/verticalSpacer.dart';

class AddYourInterests extends StatefulWidget {
  final String emailId;
  final String password;
  final int uuid;
  final SessionController controller;

  const AddYourInterests({Key key, this.emailId, this.password, this.uuid, this.controller}) : super(key: key);

  @override
  _AddYourInterestsState createState() => _AddYourInterestsState();
}

class _AddYourInterestsState extends State<AddYourInterests> {
  List<InterestClass> itemList = [];

  @override
  void initState() {
    loadList();
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.value = widget.controller.value.copyWith(selectedList: [], selectedIndex: []);
    super.dispose();
  }

  loadList() {
    itemList = [];
    itemList.add(InterestClass(index: 0, imageUrl: 'assets/interests/trips.jpg', title: 'Trips'));
    itemList.add(InterestClass(index: 1, imageUrl: 'assets/interests/movies.jpg', title: 'Movies'));
    itemList.add(InterestClass(index: 2, imageUrl: 'assets/interests/sports.jpg', title: 'Sports'));
    itemList.add(InterestClass(index: 3, imageUrl: 'assets/interests/board_games.jpg', title: 'Board Games'));
    itemList.add(InterestClass(index: 4, imageUrl: 'assets/interests/music.jpg', title: 'Music'));
    itemList.add(InterestClass(index: 5, imageUrl: 'assets/interests/photography.jpg', title: 'Photography'));
  }

  final List selectedInterests = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Choose your interests',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Please select at least 2 interests',
                  style: smallMutedTextStyle,
                  textAlign: TextAlign.left,
                ),
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).orientation == Orientation.landscape ? 3 : 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: (2 / 3),
                  ),
                  itemCount: itemList.length,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return GridItem(
                      interestClass: itemList[index],
                      isSelected: (bool value) {
                        setState(() {
                          if (value) {
                            widget.controller.value = widget.controller.value.copyWith(
                              selectedList: [...widget.controller.value.selectedList, itemList[index]],
                              selectedIndex: [...widget.controller.value.selectedIndex, index],
                            );
                          } else {
                            widget.controller.value.selectedList.remove(itemList[index]);
                            final tempList = widget.controller.value.selectedList;
                            tempList.remove(itemList[index]);
                            widget.controller.value = widget.controller.value.copyWith(selectedList: [...tempList]);

                            widget.controller.value.selectedIndex.remove(index);
                            final tempList2 = widget.controller.value.selectedIndex;
                            tempList2.remove(index);
                            widget.controller.value = widget.controller.value.copyWith(selectedIndex: [...tempList2]);
                          }
                          if (widget.controller.value.selectedList.length >= 2) {
                            widget.controller.value = widget.controller.value.copyWith(minTwoSelected: true);
                          }
                        });
                        print(widget.controller.value.selectedList.map((e) => e.title));
                        print("$index : $value");
                      },
                    );
                  },
                ),
                VerticalSpacer(
                  percentage: 0.05,
                ),
                AddUser(
                  emailId: widget.emailId,
                  password: widget.password,
                  uuid: widget.uuid,
                  interestId: widget.controller.value.selectedIndex,
                  controller: widget.controller,
                ),
                VerticalSpacer(
                  percentage: 0.05,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
