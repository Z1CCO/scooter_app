import 'package:flutter/material.dart';

class MyCircleContainerWidget extends StatelessWidget {
  final Widget child;
  const MyCircleContainerWidget({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.white,
      ),
      child: child,
    );
  }
}
