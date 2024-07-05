import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../model/friend.dart';
import '../../model/friend_status.dart';
import '../../model/message.dart';
import '../../model/request.dart';

class FriendService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final String currentUserID = FirebaseAuth.instance.currentUser!.uid;
  Future<String> _getUsername(String userID) async {

    DocumentSnapshot userDoc = await _firebaseFirestore.collection('users').doc(userID).get();
    return userDoc.get('username');
  }

  Future<void> sendFriendRequest(String receiverId,bool isAccept) async
  {

    String username = await _getUsername(currentUserID);

    FriendStatus newFriendStatus = FriendStatus(
        userID: currentUserID,
        request: true
    );

    Request newRequest = Request(
      
      senderID: _firebaseAuth.currentUser!.uid,

      senderEmail: _firebaseAuth.currentUser!.email!,
      senderName: username,
    );
    List<String>ids = [currentUserID, receiverId];
    //sort id to make sure both user in one chat room
    ids.sort();
    String chatRoomID = ids.join("_");
    //friend status

    await _firebaseFirestore.collection('chat_rooms')
        .doc(chatRoomID)
        .collection('friend_status').doc(currentUserID).set(newFriendStatus.toMap());
    //friend request
    //if Other user are accepted request, then don't re-send it
    if(!isAccept) {
      await _firebaseFirestore.collection('friend_request')
          .doc(receiverId)
          .collection('request')
          .doc(currentUserID).set(newRequest.toMap());
    }
  }
  Future<void> deleteRequest(String senderID)
  async {
    await _firebaseFirestore.collection('friend_request')
        .doc(_firebaseAuth.currentUser?.uid)
        .collection('request')
        .doc(senderID).delete();

  }
  Future<void> cancelFriendRequest(String senderId,String receiverId) async
  {
    final String currentUserID = _firebaseAuth.currentUser!.uid;


    FriendStatus newRequest = FriendStatus(
        userID: currentUserID,
        request: false,
    );
    List<String>ids = [currentUserID, receiverId];
    //sort id to make sure both user in one chat room
    ids.sort();
    String chatRoomID = ids.join("_");
    await _firebaseFirestore.collection('chat_rooms')
        .doc(chatRoomID)
        .collection('friend_status').doc(currentUserID).set(newRequest.toMap());


  }
  Future<String> friendStatus(String senderId, String receiverId) async {
    List<String> ids = [senderId, receiverId];
    ids.sort();
    String chatRoomID = ids.join("_");

    DocumentSnapshot senderDoc = await _firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('friend_status')
        .doc(senderId)
        .get();

    DocumentSnapshot receiverDoc = await _firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('friend_status')
        .doc(receiverId)
        .get();

    if (senderDoc.exists && receiverDoc.exists) {
      bool senderRequest = senderDoc.get('request');
      bool receiverRequest = receiverDoc.get('request');
      if(senderRequest && receiverRequest)  return 'Friend';
    }
    if(senderDoc.exists) return senderDoc.get('request')?'Requested':'None';
    if(receiverDoc.exists) return receiverDoc.get('request')?'Accept':'None';
    return 'None';
  }



  Stream<QuerySnapshot> getRequest(String userID, String otherUserID) {

    return _firebaseFirestore.collection('friend_request').doc(userID)
        .collection(otherUserID)
        .snapshots();
  }

  Future<void> addFriend(String friendID) async
  {
    final String currentUserID = _firebaseAuth.currentUser!.uid;
    final String friendUsername = await _getUsername(friendID);


    sendFriendRequest(friendID,true);
    Friend newFriend = Friend(
      userID: friendID,
        username: friendUsername,
        lastMessage: 'New friend',

    );
    Friend currentUser = Friend(
        userID: currentUserID,
        username: await _getUsername(currentUserID),
        lastMessage: 'New friend'

    );

    //Add other to This.List_friend
    await _firebaseFirestore.collection('friend_list')
        .doc(currentUserID)
        .collection('list').doc(friendID).set(newFriend.toMap());


    //Add This to other User list_friend

    await _firebaseFirestore.collection('friend_list')
        .doc(friendID)
        .collection('list').doc(currentUserID).set(currentUser.toMap());

  }
  Future<void> unFriend(String friendID) async
  {



    //Delete from both user
    await _firebaseFirestore.collection('friend_list')
        .doc(currentUserID)
        .collection('list')
        .doc(friendID).delete();


    await _firebaseFirestore.collection('friend_list')
        .doc(friendID)
        .collection('list')
        .doc(currentUserID).delete();

  }
}