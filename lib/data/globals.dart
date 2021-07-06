import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:swipe_app/data/agora_user.dart';

import 'package:swipe_app/data/interestclass.dart';

class Globals {
  final List<InterestClass> selectedList;
  final bool minTwoSelected;
  final List<int> selectedIndex;
  final RtcEngine engine;
  final AgoraRtmClient client;
  final AgoraRtmChannel channel;
  final int localUid;
  final int currentIndex;
  final List<int> likedUsers;
  final List<AgoraUser> allUsers;
  final List<AgoraUser> matchedUsers;
  final List<String> messages;

  Globals({
    this.selectedList,
    this.minTwoSelected = false,
    this.selectedIndex,
    this.engine,
    this.client,
    this.channel,
    this.localUid,
    this.currentIndex = 1,
    this.likedUsers,
    this.allUsers,
    this.matchedUsers,
    this.messages,
  });

  Globals copyWith({
    List<InterestClass> selectedList,
    bool minTwoSelected,
    List<int> selectedIndex,
    RtcEngine engine,
    AgoraRtmClient client,
    AgoraRtmChannel channel,
    int localUid,
    int currentIndex,
    List<int> likedUsers,
    List<AgoraUser> allUsers,
    List<AgoraUser> matchedUsers,
    List<String> messages,
  }) {
    return Globals(
      selectedList: selectedList ?? this.selectedList,
      minTwoSelected: minTwoSelected ?? this.minTwoSelected,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      engine: engine ?? this.engine,
      client: client ?? this.client,
      channel: channel ?? this.channel,
      localUid: localUid ?? this.localUid,
      currentIndex: currentIndex ?? this.currentIndex,
      likedUsers: likedUsers ?? this.likedUsers,
      allUsers: allUsers ?? this.allUsers,
      matchedUsers: matchedUsers ?? this.matchedUsers,
      messages: messages ?? this.messages,
    );
  }
}
