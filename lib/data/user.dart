import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swipe_app/controller/session_controller.dart';
import 'package:swipe_app/helper/style.dart';
import 'package:swipe_app/pages/homepage/homepage.dart';

class AddUser extends StatelessWidget {
  final String emailId;
  final String password;
  final int uuid;
  final List<int> interestId;
  final SessionController controller;

  AddUser({this.emailId, this.password, this.uuid, this.interestId, this.controller});

  @override
  Widget build(BuildContext context) {
    CollectionReference user = FirebaseFirestore.instance.collection('user');

    Future<void> addUser() {
      return user
          .add({'email': emailId, 'uid': uuid, 'interests': interestId})
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return RawMaterialButton(
      onPressed: () async {
        if (controller.value.minTwoSelected) {
          await addUser();
          await [Permission.camera, Permission.microphone].request();
          await controller.initializeEngine();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => HomePage(
                controller: controller,
              ),
            ),
          );
        } else {
          return null;
        }
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: controller.value.minTwoSelected ? primaryColor : Colors.grey,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Continue  ',
              style: defaultButtonTextStyle,
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 18,
            )
          ],
        ),
      ),
    );
  }
}
