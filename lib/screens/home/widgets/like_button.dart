
import 'package:flutter/material.dart';
import 'package:scooter_app/theme/appcolors.dart';

// ignore: must_be_immutable
class LikeButton extends StatelessWidget {
  final bool islike;
  void Function()? onTap;
  LikeButton({
    super.key,
    required this.islike,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        islike ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
        color: islike ? AppColors.red : AppColors.black,
      ),
    );
  }
}
