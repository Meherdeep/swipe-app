import 'package:flutter/material.dart';
import 'package:swipe_app/controller/session_controller.dart';
import 'package:swipe_app/helper/style.dart';
import 'package:swipe_app/pages/chat/one_to_one_chat.dart';
import 'package:swipe_app/pages/widgets/bottomNavBar.dart';
import 'package:swipe_app/pages/widgets/verticalSpacer.dart';

class ChatPage extends StatefulWidget {
  final SessionController controller;
  const ChatPage({Key key, this.controller}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    widget.controller.createClient();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(
        controller: widget.controller,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
              vertical: MediaQuery.of(context).size.height * 0.05,
            ),
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Liked Users',
                  style: bigHeadingStyle,
                ),
                VerticalSpacer(
                  percentage: 0.01,
                ),
                Text(
                  'Chat with all the users you swiped right',
                  style: smallHeadingStyle,
                ),
                VerticalSpacer(
                  percentage: 0.1,
                ),
                widget.controller.value.likedUsers.isEmpty
                    ? Center(
                        child: Text('You haven\'t liked any user yet'),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: widget.controller.value.likedUsers.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                await widget.controller.toggleJoinChannel(widget.controller.value.likedUsers[index]);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext contex) => OneToOneChatPage(
                                      controller: widget.controller,
                                      remoteUserUid: widget.controller.value.likedUsers[index],
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  height: 80,
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(horizontal: 1, vertical: 5),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 60,
                                        child: Icon(Icons.person),
                                      ),
                                      Text(widget.controller.value.likedUsers[index].toString())
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
