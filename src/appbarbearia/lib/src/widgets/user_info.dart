import 'package:flutter/material.dart';

class UserInfoWidget extends StatelessWidget {

  final String userName;
  final String userNameComplete; 

  const UserInfoWidget({
    required this.userName,
    required this.userNameComplete,
    super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:Center(
        child: Column(
          children: [
            SizedBox(height: 40),
            CircleAvatar(radius: 50,),
            SizedBox(height: 12),
            Text(userName, style: TextStyle(fontSize: 12),),
            Text(userNameComplete, style: TextStyle(fontSize: 18),),
            SizedBox(height: 15),
          ],
        ),
      )
      );
  }
}