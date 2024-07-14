import 'package:flutter/material.dart';
import 'package:scooter_app/theme/textstyles.dart';

class AppVersion extends StatelessWidget {
  const AppVersion({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 80,
          child: Image.asset('assets/images/logo.png'),
        ),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DMD MOTORS',
              style: TextStyles.s16w500kanitgrey,
            ),
            Text(
              '1.0.0 version',
              style: TextStyles.s16w500kanitgrey,
            ),
          ],
        ),
      ],
    );
  }
}
