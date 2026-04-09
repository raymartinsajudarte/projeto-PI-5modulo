import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String title;

  const HeaderWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child:  Icon(
              Icons.arrow_back,
              color: Color(0xFF158F00),
            ),
          ),

           SizedBox(width: 12),

          Expanded(
            child: Center(
              child: Text(
                title,
                style:  TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF158F00),
                ),
              ),
            ),
          ),

          SizedBox(width: 24), // balanceamento
        ],
      ),
    );
  }
}