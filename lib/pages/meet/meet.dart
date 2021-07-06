import 'package:flutter/material.dart';
import 'package:swipe_app/controller/session_controller.dart';
import 'package:swipe_app/data/agora_user.dart';
import 'package:swipe_app/helper/style.dart';
import 'package:swipe_app/pages/widgets/bottomNavBar.dart';
import 'package:swipe_app/pages/widgets/verticalSpacer.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
import 'package:tcard/tcard.dart';

class MeetPage extends StatefulWidget {
  final SessionController controller;
  const MeetPage({Key key, this.controller}) : super(key: key);

  @override
  _MeetPageState createState() => _MeetPageState();
}

class _MeetPageState extends State<MeetPage> {
  TCardController _controller = TCardController();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  String username;

  @override
  void initState() {
    widget.controller.joinVideoChannel(0);
    widget.controller.createEvents();
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.value.engine.leaveChannel();
    widget.controller.value.engine.destroy();
    super.dispose();
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    list.add(rtc_local_view.SurfaceView());
    widget.controller.value.matchedUsers.forEach((AgoraUser agoraUser) {
      if (agoraUser.isAvailable) {
        list.add(rtc_remote_view.SurfaceView(uid: agoraUser.uid));
        agoraUser.copyWith(isAvailable: false);
      }
    });
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  Widget _localVideoView(view) {
    return Container(
      height: 150,
      width: 120,
      child: view,
    );
  }

  List<Widget> tinderCards() {
    final List<Widget> tcards = List.generate(widget.controller.value.matchedUsers.length, (index) {
      print('Number of users: ${widget.controller.value.matchedUsers.length}');
      final views = _getRenderViews();
      return Container(
          child: Stack(
        children: <Widget>[
          _videoView(rtc_remote_view.SurfaceView(uid: widget.controller.value.matchedUsers[index].uid)),
          Align(alignment: Alignment(0.95, -0.95), child: _localVideoView(views[0])),
        ],
      ));
    });
    return tcards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ValueListenableBuilder(
        valueListenable: widget.controller,
        builder: (ctx, value, child) {
          return Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VerticalSpacer(
                  percentage: 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 10),
                  child: Text(
                    'Shoot your shot',
                    style: bigHeadingStyle.copyWith(fontSize: 24),
                    textAlign: TextAlign.left,
                  ),
                ),
                VerticalSpacer(
                  percentage: 0.03,
                ),
                Container(
                  height: MediaQuery.of(ctx).size.height * 0.8,
                  width: double.infinity,
                  child: widget.controller.value.matchedUsers.length > 0
                      ? TCard(
                          controller: _controller,
                          lockYAxis: true,
                          cards: tinderCards(),
                          onBack: (index, info) async {
                            print("Nah : $index, $info");
                            await widget.controller.leaveVideoChannel(index);
                          },
                          slideSpeed: 15,
                          onForward: (index, info) async {
                            print("Yay : $index , ${info.direction}, ${info.cardIndex}");
                            info.direction == SwipDirection.Left
                                ? await widget.controller.leaveVideoChannel(index)
                                : await widget.controller.onForwardAction(index);
                          },
                        )
                      : Center(
                          child: Text('Try again later'),
                        ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        controller: widget.controller,
      ),
    );
  }
}
