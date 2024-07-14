import 'package:flutter/material.dart';

class MyEditColor extends StatefulWidget {
  final bool initialCheck;
  final String text;
  final ValueChanged<bool> onChanged; // Qo'shimcha

  const MyEditColor({
    super.key,
    required this.initialCheck,
    required this.text,
    required this.onChanged, // Qo'shimcha
  });

  @override
  State<MyEditColor> createState() => _MyEditColorState();
}

class _MyEditColorState extends State<MyEditColor> {
  late bool check;

  @override
  void initState() {
    super.initState();
    check = widget.initialCheck;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              check = !check;
              widget.onChanged(
                  check); // Qo'shimcha: onChanged funksiyasini chaqirish
            });
          },
          child: Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(12),
            ),
            child: check ? const Icon(Icons.check) : const SizedBox(),
          ),
        ),
        Text(widget.text)
      ],
    );
  }
}
