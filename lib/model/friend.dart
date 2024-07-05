class Friend{
  final String userID;
  final String username;
  final lastMessage;

  Friend({
    required this.userID,
    required this.username,
    required this.lastMessage
  });
    Map<String, dynamic> toMap()
    {
      return {
        'userID':userID,
        'username': username,
        'lastMessage': lastMessage
      };
    }

}