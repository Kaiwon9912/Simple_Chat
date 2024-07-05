import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String receiverID;
  final String message;
  final String senderName;
  final Timestamp timestamp;

  Message({
    required this.senderID,
    required this.receiverID,
    required  this.message,
    required  this.senderName,
    required this.timestamp
  });
  Map<String, dynamic> toMap()
  {
    return {
      'senderID':senderID,
      'receiverID':receiverID,
      'message':message,
      'senderName': senderName,
      'timestamp':timestamp,
    };
  }
}
