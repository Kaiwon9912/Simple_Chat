import 'package:chat_app/services/friend/friend_service.dart';
import 'package:flutter/material.dart';
class RequestTile extends StatelessWidget {
  final String SenderName;
  final String SenderID;
  const RequestTile({super.key,required this.SenderName, required this.SenderID});


  @override
  Widget build(BuildContext context) {
  void AcceptRequest()
  {
    FriendService().addFriend(SenderID);
    FriendService().deleteRequest(SenderID);
  }


    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.grey.shade300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                Image.asset('lib/images/user.png', height: 50,),
                const SizedBox(width: 20,),
                Text(SenderName),
              ],
            )
          ),

          Container(
            child: Row(
              children: [
                IconButton(
                  onPressed: ()=>AcceptRequest(),
                  icon: Icon(Icons.check_circle,size: 30,),
                  color: Colors.green,
                ),
                IconButton(onPressed: ()=>FriendService().deleteRequest(SenderID), icon: Icon(Icons.delete,color: Colors.red,size: 30,))
              ],
            ),
          )
        ],
      ),
    );
  }
}

