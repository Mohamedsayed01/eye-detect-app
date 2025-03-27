import 'package:flutter/material.dart';

class CustomTextFrom extends StatelessWidget {
  final String hinttext;
  final TextEditingController mycontroller;
  final String? Function(String?)? validator;
  final dynamic obscureText;
  const CustomTextFrom({super.key, required this.hinttext, required this.mycontroller, this.validator, required this.obscureText,});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: mycontroller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hinttext,
        hintStyle: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 20,
        ),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
