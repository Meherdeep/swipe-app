import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:swipe_app/controller/session_controller.dart';
import 'package:swipe_app/pages/chat/chat_page.dart';
import 'package:swipe_app/pages/meet/meet.dart';
import 'package:swipe_app/pages/profile/profile.dart';

class BottomNavBar extends StatefulWidget {
  final SessionController controller;

  const BottomNavBar({Key key, this.controller}) : super(key: key);
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.controller,
      builder: (context, value, child) {
        return SalomonBottomBar(
          currentIndex: widget.controller.value.currentIndex,
          items: [
            SalomonBottomBarItem(
              icon: Icon(Icons.person_outline),
              title: Text("Profile"),
              selectedColor: Colors.teal,
            ),
            SalomonBottomBarItem(
              icon: Icon(Icons.favorite_border),
              title: Text("Meet"),
              selectedColor: Colors.pink,
            ),
            SalomonBottomBarItem(
              icon: Icon(Icons.message_outlined),
              title: Text("Messages"),
              selectedColor: Colors.orange,
            ),
          ],
          onTap: (i) async {
            widget.controller.value = widget.controller.value.copyWith(currentIndex: i);
            if (i == 0) {
              await widget.controller.value.engine.leaveChannel();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfile(
                    controller: widget.controller,
                  ),
                ),
              );
            } else if (i == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MeetPage(
                    controller: widget.controller,
                  ),
                ),
              );
            } else if (i == 2) {
              await widget.controller.value.engine.leaveChannel();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    controller: widget.controller,
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
