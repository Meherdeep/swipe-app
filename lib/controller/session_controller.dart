import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swipe_app/data/agora_user.dart';
import 'package:swipe_app/data/globals.dart';
import 'package:swipe_app/utils/utils.dart';

class SessionController extends ValueNotifier<Globals> {
  SessionController()
      : super(Globals(
          engine: null,
          minTwoSelected: false,
          matchedUsers: [],
          currentIndex: 1,
          selectedList: [],
          selectedIndex: [],
          likedUsers: [],
          allUsers: [],
          messages: [],
        ));

  Future<void> initializeEngine() async {
    try {
      value = value.copyWith(
        engine: await RtcEngine.createWithConfig(
          RtcEngineConfig(appId),
        ),
      );
      print('Rtc Engine initialized');
    } catch (e) {
      print('Error occured white initializing : $e');
    }

    await value.engine.enableVideo();
    await value.engine.enableAudio();
  }

  void startVideoPreview() async {
    await value.engine.enableVideo();
    await value.engine.startPreview();
  }

  void stopVideoPreview() async {
    await value.engine.stopPreview();
  }

  Future<void> joinVideoChannel(int channelIndex) async {
    int uid;
    var user = FirebaseAuth.instance.currentUser;
    var db = await FirebaseFirestore.instance.collection('user').get();
    int index = db.docs.indexWhere((element) => element.data()['email'] == user.email);
    await FirebaseFirestore.instance.collection('user').get().then((value) async {
      uid = await value.docs[index].data()['uid'];
    });
    String channelName;
    print('matched user uid ${value.matchedUsers[channelIndex].uid}');
    if (value.matchedUsers[channelIndex].uid < uid) {
      channelName = uid.toString() + value.matchedUsers[channelIndex].uid.toString();
    } else {
      channelName = value.matchedUsers[channelIndex].uid.toString() + uid.toString();
    }
    print('channel name: $channelName');
    await value.engine.joinChannel(null, channelName, null, uid);
  }

  Future<void> leaveVideoChannel(int index) async {
    await value.engine.leaveChannel();
    int remoteUserIndex = value.allUsers.indexWhere((element) => element.uid == value.matchedUsers[0].uid);
    List<AgoraUser> tempList = value.allUsers;
    tempList[remoteUserIndex] = tempList[remoteUserIndex].copyWith(isAvailable: true);
    value = value.copyWith(allUsers: tempList);

    List<AgoraUser> tempList2 = value.matchedUsers;
    tempList2.removeAt(0);
    value = value.copyWith(matchedUsers: tempList2);

    joinVideoChannel(0);
  }

  Future<void> onForwardAction(int index) async {
    await value.engine.leaveChannel();

    int remoteUid = value.matchedUsers[0].uid;
    value = value.copyWith(likedUsers: [...value.likedUsers, remoteUid]);
    value.likedUsers.forEach((element) {
      print('Liked User: $element');
    });

    List<AgoraUser> tempList = value.matchedUsers;
    tempList.removeAt(0);
    value = value.copyWith(matchedUsers: tempList);

    joinVideoChannel(0);

    // int index = value.matchedUsers.indexWhere((element) => element.uid == remoteUid);
    // value = value.copyWith(likedUsers: [...value.likedUsers, remoteUid]);
    // print('Liked users: ${value.likedUsers}');
    // await value.engine.leaveChannel();
    // List<AgoraUser> tempList = value.allUsers;
    // tempList[index] = tempList[index].copyWith(isAvailable: true);
    // value = value.copyWith(allUsers: tempList);
    // value.matchedUsers.removeAt(0);
    // joinVideoChannel(0);
  }

  void matchUserInterests() async {
    print('printing user interests');
    int count = 0;
    var user = FirebaseAuth.instance.currentUser;
    var db = await FirebaseFirestore.instance.collection('user').get();
    int index = db.docs.indexWhere((element) => element.data()['email'] == user.email);
    print('USER INDEX: $index');
    await FirebaseFirestore.instance.collection('user').get().then((val) {
      for (var i = 0; i < val.docs.length; i++) {
        for (var j = 0; j < val.docs[i].data()['interests'].length; j++) {
          if (i != index) {
            if (val.docs[i].data()['interests'].contains(val.docs[index].data()['interests'][j])) {
              count++;
            }
          }
        }
        if (count >= 1) {
          value = value.copyWith(matchedUsers: [...value.matchedUsers, AgoraUser(uid: val.docs[i].data()['uid'], isAvailable: true)]);
        }
        count = 0;
      }
    });
  }

  void createClient() async {
    String username;
    await FirebaseFirestore.instance.collection('user').get().then((value) {
      username = value.docs[3].data()['email'];
      print(username);
    });
    value = value.copyWith(client: await AgoraRtmClient.createInstance(appId));
    value.client.onMessageReceived = (AgoraRtmMessage message, String peerId) {
      print("Message received : " + message.text);
      _logPeer(message.text);
    };
    value.client.onConnectionStateChanged = (int state, int reason) {
      print('Connection state changed: ' + state.toString() + ', reason: ' + reason.toString());
      if (state == 5) {
        value.client.logout();
        print('Logout.');
      }
    };
    toggleLogin(username);
  }

  void toggleLogin(String username) async {
    try {
      await value.client.login(null, username);
      print('Login success: ' + username);
    } catch (errorCode) {
      print('Login error: ' + errorCode.toString());
    }
  }

  Future<void> toggleJoinChannel(int remoteChannelName) async {
    String channelName;
    if (remoteChannelName < value.localUid) {
      channelName = value.localUid.toString() + remoteChannelName.toString();
    } else {
      channelName = remoteChannelName.toString() + value.localUid.toString();
    }
    try {
      value = value.copyWith(channel: await _createChannel(channelName));
      await value.channel.join();
      print('Join channel success.');
    } catch (errorCode) {
      print('Join channel error: ' + errorCode.toString());
    }
  }

  void leaveRtmChannel() async {
    await value.channel.leave();
    value = value.copyWith(messages: []);
  }

  Future<AgoraRtmChannel> _createChannel(String name) async {
    AgoraRtmChannel channel = await value.client.createChannel(name);
    channel.onMemberJoined = (AgoraRtmMember member) {
      print("Member joined: " + member.userId + ', channel: ' + member.channelId);
    };
    channel.onMemberLeft = (AgoraRtmMember member) {
      print("Member left: " + member.userId + ', channel: ' + member.channelId);
    };
    channel.onMessageReceived = (AgoraRtmMessage message, AgoraRtmMember member) {
      print('Chanel Message Received : ' + message.text);
      _logPeer(message.text);
    };
    return channel;
  }

  void createEvents() async {
    value.engine.setEventHandler(
      RtcEngineEventHandler(
        error: (code) {
          final info = 'onError: $code';
          print(info);
        },
        joinChannelSuccess: (channel, uid, elapsed) {
          final info = 'onJoinChannel: $channel, uid: $uid';
          print(info);
          value = value.copyWith(localUid: uid);
        },
        leaveChannel: (stats) {
          value = value.copyWith(allUsers: []);
          print('leaveChannel');
        },
        userJoined: (uid, elapsed) {
          final info = 'userJoined: $uid';
          print(info);
          value = value.copyWith(allUsers: [...value.allUsers, AgoraUser(uid: uid, isAvailable: true)]);
        },
        userOffline: (uid, reason) {
          final info = 'userOffline: $uid , reason: $reason';
          print(info);
          _removeUser(uid: uid);
        },
      ),
    );
  }

  void _removeUser({int uid}) {
    List<AgoraUser> tempList = [];
    tempList = value.allUsers;
    for (int i = 0; i < tempList.length; i++) {
      if (tempList[i].uid == uid) {
        tempList.remove(tempList[i]);
      }
    }
    value = value.copyWith(allUsers: tempList);
  }

  void toggleSendChannelMessage(String text) async {
    if (text.isEmpty) {
      print('Please input text to send.');
      return;
    }
    try {
      await value.channel.sendMessage(AgoraRtmMessage.fromText(text));
      _log(text);
    } catch (errorCode) {
      print('Send channel message error: ' + errorCode.toString());
    }
  }

  void _logPeer(String info) {
    info = '%' + info;
    print(info);
    value = value.copyWith(messages: [info, ...value.messages]);
  }

  void _log(String info) {
    print(info);
    value = value.copyWith(messages: [info, ...value.messages]);
  }
}
