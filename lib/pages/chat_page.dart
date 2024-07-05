

import 'package:chat_app/component/styled_textfield.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:chat_app/services/friend/friend_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../component/message_tile.dart';

class ChatPage extends StatefulWidget {

  final String UserID;
  final String Username;

  const ChatPage(
      {super.key, required this.UserID, required this.Username});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FriendService _friendService = FriendService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String status = '';

  @override
  void initState() {
    super.initState();
    _checkFriendStatus();
  }

  void _checkFriendStatus() async {
    String result = await _friendService.friendStatus(
      _firebaseAuth.currentUser!.uid,
      widget.UserID,
    );
    setState(() {
      status = result;


    });
  }

  void sendMessage() async {
    if (status != 'Friend') {

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Friend Required'),
            content: Text('You need to become friends before sending a message.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return; // Dừng hàm nếu người dùng chưa là bạn bè
    }
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.Username, widget.UserID, _messageController.text);
      _messageController.clear();
    }
  }

  void toggleFriendStatus() async {
   print(status);
    if (status=='Friend'|| status=='Requested') {
      if(status=='Friend') FriendService().unFriend(widget.UserID);
     await _friendService.cancelFriendRequest(_firebaseAuth.currentUser!.uid,widget.UserID);

    } else {

      await _friendService.sendFriendRequest( widget.UserID,false);
    }
    _checkFriendStatus(); // Re-check the status after updating
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(widget.Username),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.info),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Center(
              child: Image.asset('lib/images/user.png'),
            ),
        ElevatedButton(
          onPressed: toggleFriendStatus,
          child: Text(
            {
              'Friend': 'Unfriend',
              'Requested': 'Cancel Request',
              'None': 'Add friend',
              'Accept': 'Accept request',
            }[status] ?? 'Add friend',
          ),
        )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _chatService.getMessages(widget.UserID, _firebaseAuth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('ERROR');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          return ListView(
              children: snapshot.data!.docs.map((document) =>
                  _buildMessageItem(document)).toList());
        });
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var currentUser = (data['senderID'] == _firebaseAuth.currentUser!.uid);
    return MessageTile(message: data['message'], username: data['senderName'], isCurrentUser: currentUser);
  }

  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
          child: StyledTextfield(
            ObscureText: false,
            hintText: 'Enter message',
            controller: _messageController,
          ),
        ),
        IconButton(onPressed: sendMessage, icon: Icon(Icons.send,size: 40,))
      ],
    );
  }
}
