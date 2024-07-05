import 'package:chat_app/component/request_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class RequestPage extends StatelessWidget {
   RequestPage({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Friend Request'),

      ),
        body: _buildRequestList(),
    );
  }

  Widget _buildRequestList() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('friend_request').doc(_auth.currentUser?.uid).collection('request').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('ERROR');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          return ListView(
              children: snapshot.data!.docs
                  .map<Widget>((doc) => _buildRequestListItem(context,doc))
                  .toList());
        });
  }

  Widget _buildRequestListItem(BuildContext context, DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

      return RequestTile(SenderName: data['senderName'], SenderID: data['senderID']);

  }
}
