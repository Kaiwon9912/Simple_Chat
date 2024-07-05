import 'package:flutter/material.dart';
class MessageTile extends StatelessWidget {
  final String username;
  final String message;
  final bool isCurrentUser;
  const MessageTile({super.key,required this.message, required this.username, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: isCurrentUser?MainAxisAlignment.end:MainAxisAlignment.start,
      children: [
        if (!isCurrentUser)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Image.asset(
              'lib/images/user.png',
              height: 45,
            ),
          ),
        Flexible(
          fit: FlexFit.loose,
          child: Container(

            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top:10,right: 10,left: 10),
            decoration: BoxDecoration(
              color: isCurrentUser?Colors.blue:Colors.blueGrey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(message,softWrap: true,style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),
          ),
        ),
      ],
    );
  }
}
