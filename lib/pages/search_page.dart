import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'chat_page.dart';

class SearchPage extends StatefulWidget {
  @override

  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  void _search() {
    setState(() {
      _searchQuery = _searchController.text.trim();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search users...',
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _search,
          ),
        ],
      ),
      body: _buildSearchResults(),
    );
  }

  Widget _buildSearchResults() {
    if (_searchQuery.isEmpty) {
      return Center(child: Text('Enter a username or email to search'));
    }
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final List<DocumentSnapshot> docs = snapshot.data!.docs;
        final filteredDocs = docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final username = data['username'] as String;
          final email = data['email'] as String;
          return (username.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              email.toLowerCase().contains(_searchQuery.toLowerCase())) &&
              email.toLowerCase() != _auth.currentUser!.email ;
        }).toList();

        if (filteredDocs.isEmpty) {
          return Center(child: Text('No users found'));
        }

        return ListView(
          children: filteredDocs
              .map<Widget>((doc) => _buildUserListItem(context, doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(BuildContext context, DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    return ListTile(
      title: Text(data['username']),
      subtitle: Text(data['email']),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(

              UserID: data['uid'],
              Username: data['username'],
            ),
          ),
        );
      },
    );
  }
}
