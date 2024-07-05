import 'package:chat_app/services/friend/friend_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../model/friend.dart';
import '../../model/message.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String senderName,String receiverId, String message) async
  {
    final String currentUserID = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();
    Message newMessage = Message(
        senderID: currentUserID,
        senderName: senderName,
        timestamp: timestamp,
        message: message,
        receiverID: receiverId
    );
    List<String>ids = [currentUserID, receiverId];
    //sort id to make sure both user in one chat room
    ids.sort();
    String chatRoomID = ids.join("_");
    Future<String> _getUsername(String userID) async {

      DocumentSnapshot userDoc = await _firebaseFirestore.collection('users').doc(userID).get();
      return userDoc.get('username');
    }
    String receiverName = await _getUsername(receiverId);
    await _firebaseFirestore.collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .add(newMessage.toMap());

    Friend updateMessage = new Friend(
      lastMessage:message,
      userID: currentUserID,
      username: await _getUsername(currentUserID),
    );
    await _firebaseFirestore.collection('friend_list')
        .doc(receiverId)
        .collection('list').doc(currentUserID).set(updateMessage.toMap());


  }

  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    List<String>ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join("_");
    return _firebaseFirestore.collection('chat_rooms').doc(chatRoomID)
        .collection('messages').orderBy('timestamp', descending: false)
        .snapshots();
  }
}