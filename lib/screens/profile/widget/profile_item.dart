import 'package:flutter/material.dart';
import 'package:scooter_app/theme/textstyles.dart';

class ProfileItemWidget extends StatelessWidget {
  final Color colors;
  final String image;
  final String text;
  final bool icon;
  const ProfileItemWidget({
    super.key,
    required this.image,
    required this.icon,
    required this.text, required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 55,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 22,
            width: 22,
            child: Image.asset(
              image,
              color: colors,
            ),
          ),
          const SizedBox(width: 12),
          Text(text, style: TextStyles.s17w500kanitblack),
          const Spacer(),
          icon == true
              ? Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.grey.shade300,
                  size: 28,
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
