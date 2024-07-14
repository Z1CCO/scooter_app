import 'package:flutter/material.dart';
import 'package:scooter_app/theme/appcolors.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.keytype,
  });

  final TextEditingController controller;
  final TextInputType? keytype;
  final String hint;
  @override
  Widget build(BuildContext context) {
    OutlineInputBorder borderedTextField(Color color) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(
          color: color,
        ),
      );
    }

    return TextField(
      keyboardType: keytype ?? TextInputType.emailAddress,
      controller: controller,
      cursorColor: Colors.blue,
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        enabledBorder: borderedTextField(AppColors.black),
        focusedBorder: borderedTextField(AppColors.deepBlue),
      ),
    );
  }
}
