import 'package:flutter/material.dart';

class CustomLogoAuth extends StatelessWidget {
  const CustomLogoAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: 250,
        height: 250,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.grey[150],
          borderRadius: BorderRadius.circular(0),
        ),
        // image
        child: Image.asset(
          "images/eye remove.png",
          height: 250,
        ),
      ),
    );
  }
}
