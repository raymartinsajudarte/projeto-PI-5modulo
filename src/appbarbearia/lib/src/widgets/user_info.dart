import 'package:flutter/material.dart';

class UserInfoWidget extends StatelessWidget {
  final String userName;
  final String userNameComplete;
  final bool editable; // para indicar se o avat é editavel ou não

  const UserInfoWidget({
    required this.userName,
    required this.userNameComplete,
    this.editable = false, // padrão = não editável
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         SizedBox(height: 40),

        Stack(
          children: [
             CircleAvatar(radius: 50),

            if (editable) 
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding:  EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child:  Icon(
                    Icons.camera_alt,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),

        SizedBox(height: 12),

        Text(
          userNameComplete,
          style: const TextStyle(fontSize: 18),
        ),

        Text(
          userName,
          style: const TextStyle(fontSize: 12),
        ),

        const SizedBox(height: 15),
      ],
    );
  }
}