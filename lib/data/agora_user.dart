class AgoraUser {
  int uid;
  bool isAvailable;

  AgoraUser({this.uid, this.isAvailable});

  AgoraUser copyWith({
    int uid,
    bool isAvailable,
  }) {
    return AgoraUser(
      uid: uid ?? this.uid,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
