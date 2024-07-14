import 'package:flutter/material.dart';

class UploadTextField extends StatelessWidget {
  const UploadTextField({
    super.key,
    required this.widget,
    required this.hint,
    this.keyboardType,
  });

  final TextEditingController widget;
  final String hint;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget,
      keyboardType: keyboardType ?? TextInputType.emailAddress,
      decoration: InputDecoration(
        fillColor: Colors.blue.shade100,
        filled: true,
        hintText: hint,
        contentPadding: const EdgeInsets.all(8),
      ),
    );
  }
}
