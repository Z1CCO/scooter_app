import 'package:flutter/material.dart';
import 'package:scooter_app/screens/profile/widget/language_constants.dart';
import 'package:scooter_app/theme/appcolors.dart';
import 'package:scooter_app/theme/textstyles.dart';

class LoginElevatedButton extends StatelessWidget {
  final String? text;
  final VoidCallback onTap;
  const LoginElevatedButton({
    this.text,
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          foregroundColor: AppColors.white,
          backgroundColor: AppColors.deepBlue,
        ),
        onPressed: onTap,
        child: Text(
          text ?? translation(context).kirish,
          style: TextStyles.s25w500kanitwhite,
        ),
      ),
    );
  }
}
