import 'package:flutter/material.dart';

class UserInfoWidget extends StatelessWidget {
  final String userName;
  final String userNameComplete;
  final String? imageUrl;
  final bool editable; // para indicar se o avat é editavel ou não

  const UserInfoWidget({
    required this.userName,
    required this.userNameComplete,
    this.imageUrl,
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
            CircleAvatar(
              radius: 50,
              backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
                  ? NetworkImage(imageUrl!)
                  : null,
              child: (imageUrl == null || imageUrl!.isEmpty)
                  ?  Icon(Icons.person, size: 50)
                  : null,
            ),

            if (editable)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(Icons.camera_alt, size: 14, color: Colors.white),
                ),
              ),
          ],
        ),

        SizedBox(height: 12),

        Text(userNameComplete, style:  TextStyle(fontSize: 18)),

        Text(userName, style:  TextStyle(fontSize: 12)),

        SizedBox(height: 15),
      ],
    );
  }
}
