import 'package:flutter/material.dart';
class FriendTile extends StatelessWidget {
  final String Username, UserID, lastMessage;
  const FriendTile({super.key,required this.Username,required this.UserID, required this.lastMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 1
          ),
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset('lib/images/user.png', height: 50,),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Username,style: TextStyle(fontSize: 18),),
              Text(lastMessage,style: TextStyle(fontSize: 14,color: Colors.grey),),
            ],
          ),

        ],
      ),
    );
  }
}
