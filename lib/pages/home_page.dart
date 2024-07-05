import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/request_page.dart';
import 'package:chat_app/pages/search_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../component/friend_tile.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void logOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        actions: [IconButton(onPressed: logOut, icon: Icon(Icons.logout))],

      ),
      drawer: Drawer(
        child: Column(

          children: [
            const SizedBox(height: 50),
            Center(

              child: Image.asset('lib/images/user.png'),
            ),
            const SizedBox(height: 20,),
            Text(_auth.currentUser!.email.toString(), style: TextStyle(fontSize: 24),),
           const SizedBox(height: 10),
           GestureDetector(
             onTap: ()=>Navigator.push(context,MaterialPageRoute(builder: (context)=>RequestPage())),
             child: Row(

               children: [
                 const SizedBox(width: 50,),
                 Icon(Icons.people_alt_rounded,size: 30,),
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 20),
                   child: Text('Friend request', style: TextStyle(fontSize: 20),),
                 ),
               ],
             ),
           ),
            const SizedBox(height: 10,),
            GestureDetector(
              onTap: ()=>Navigator.push(context,MaterialPageRoute(builder: (context)=>SearchPage())),
              child: Row(

                children: [
                  const SizedBox(width: 50,),
                  Icon(Icons.search,size: 30,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Search', style: TextStyle(fontSize: 20),),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      body: _buildUserList()
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
        //stream: FirebaseFirestore.instance.collection('users').snapshots(),
        stream: FirebaseFirestore.instance.collection('friend_list').doc(_auth.currentUser?.uid).collection('list').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('ERROR');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          return ListView(
              children: snapshot.data!.docs
                  .map<Widget>((doc) => _buildUserListItem(context,doc))
                  .toList());
        });
  }

  Widget _buildUserListItem(BuildContext context, DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    if (_auth.currentUser!.email != data['email']) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(

                UserID: data['userID'],
                Username: data['username'],
              ),
            ),
          );
        },
        child: FriendTile(
          Username: data['username'],
          UserID: data['userID'],
          lastMessage: data['lastMessage'],

        ),
      );
    }
    return Container();
  }
}
