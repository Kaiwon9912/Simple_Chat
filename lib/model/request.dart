class Request {
  final String senderID;
  final String senderEmail;
  final String senderName;
  Request({
    required this.senderID,
    required this.senderEmail,
    required this.senderName,
  });
  Map<String, dynamic> toMap()
  {
      return {
          'senderID': senderID,
          'senderEmail': senderEmail,
          'senderName': senderName

      };
  }
}
