import 'package:flutter/material.dart';
import 'package:swipe_app/controller/session_controller.dart';
import 'package:swipe_app/pages/widgets/bottomNavBar.dart';

class OneToOneChatPage extends StatefulWidget {
  final SessionController controller;
  final int remoteUserUid;
  const OneToOneChatPage({Key key, this.controller, this.remoteUserUid}) : super(key: key);

  @override
  _OneToOneChatPageState createState() => _OneToOneChatPageState();
}

class _OneToOneChatPageState extends State<OneToOneChatPage> {
  TextEditingController messagingController = TextEditingController();

  @override
  void dispose() {
    widget.controller.leaveRtmChannel();
    super.dispose();
  }

  Widget _buildInfoList() {
    return Expanded(
      child: Container(
        child: widget.controller.value.messages.isNotEmpty
            ? ListView.builder(
                reverse: true,
                itemBuilder: (context, i) {
                  return Container(
                    child: ListTile(
                      title: Align(
                        alignment: widget.controller.value.messages[i].startsWith('%') ? Alignment.bottomLeft : Alignment.bottomRight,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.green[300],
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          child: Column(
                            crossAxisAlignment:
                                widget.controller.value.messages[i].startsWith('%') ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                            children: [
                              widget.controller.value.messages[i].startsWith('%')
                                  ? Text(
                                      widget.controller.value.messages[i].substring(1),
                                      maxLines: 10,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(color: Colors.black),
                                    )
                                  : Text(
                                      widget.controller.value.messages[i],
                                      maxLines: 10,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(color: Colors.black),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: widget.controller.value.messages.length,
              )
            : Container(),
      ),
    );
  }

  Widget _buildSendChannelMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.75,
          child: TextFormField(
            showCursor: true,
            enableSuggestions: true,
            textCapitalization: TextCapitalization.sentences,
            controller: messagingController,
            decoration: InputDecoration(
              hintText: 'Comment...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.grey, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.grey, width: 2),
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(40)),
              border: Border.all(
                color: Colors.blue,
                width: 2,
              )),
          child: IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: () async {
              widget.controller.toggleSendChannelMessage(messagingController.text);
              messagingController.clear();
            },
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavBar(
          controller: widget.controller,
        ),
        appBar: AppBar(
          title: Text(widget.remoteUserUid.toString()),
        ),
        body: ValueListenableBuilder(
          valueListenable: widget.controller,
          builder: (context, value, child) {
            return SafeArea(
              child: Column(
                children: [
                  _buildInfoList(),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.bottomCenter,
                    child: _buildSendChannelMessage(),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
