import 'package:flutter/material.dart';

class CustomButtonAuth extends StatelessWidget {
  final void Function()? onPressed;
  final String title ;
  const CustomButtonAuth({super.key, this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
          height: 42,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
          color: Colors.blue[300],
          textColor: Colors.black,
          onPressed: onPressed,
          child: Text(title),
    );
  }
}

