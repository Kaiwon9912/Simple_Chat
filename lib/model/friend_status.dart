class FriendStatus{
  final String userID;
  final bool request;

  FriendStatus({
    required this.userID,
    required this.request,
});
  Map<String, dynamic> toMap()
  {
    return {
      'userID':userID,
      'request':request,
    };
  }

}