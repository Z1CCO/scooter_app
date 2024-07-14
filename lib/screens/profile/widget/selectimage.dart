import 'dart:io';

import 'package:flutter/material.dart';

class SelectImages extends StatelessWidget {
  const SelectImages({
    super.key,
    required this.image,
    required this.onTap,
  });

  final File? image;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2.0),
            image: image == null
                ? const DecorationImage(
                    image: AssetImage('assets/images/upload.png'),
                  )
                : DecorationImage(
                    image: FileImage(
                      File(image!.path),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
