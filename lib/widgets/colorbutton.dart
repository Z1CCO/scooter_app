import 'package:flutter/material.dart';
import 'package:scooter_app/theme/appcolors.dart';

class ColorButton extends StatefulWidget {
  final int index;
  final Color color;
  const ColorButton({
    super.key,
    required this.index,
    required this.color,
  });

  @override
  State<ColorButton> createState() => _ColorButtonState();
}

class _ColorButtonState extends State<ColorButton> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        selected = widget.index;
        setState(() {});
      },
      child: CircleAvatar(
        radius: 30,
        backgroundColor:
            (selected == widget.index) ? widget.color : AppColors.white,
        child: CircleAvatar(
          backgroundColor: AppColors.white,
          radius: 27.5,
          child: CircleAvatar(
            radius: 25,
            backgroundColor: widget.color,
          ),
        ),
      ),
    );
  }
}
