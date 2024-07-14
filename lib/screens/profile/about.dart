import 'package:flutter/material.dart';
import 'package:scooter_app/screens/profile/widget/appversion.dart';
import 'package:scooter_app/screens/profile/widget/language_constants.dart';
import 'package:scooter_app/theme/appcolors.dart';
import 'package:scooter_app/theme/textstyles.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 0, 0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.fromLTRB(10, 4, 0, 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset('assets/images/back.png'),
                    ),
                  ),
                  Text(
                    translation(context).ilovaHaqida,
                    style: TextStyles.s25w500kanitblack,
                  ),
                  const SizedBox(
                    height: 50,
                    width: 50,
                  )
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  translation(context).ilovaHaqidaMalumot,
                  style: TextStyles.s17w500kanitblack,
                ),
              ),
              const AppVersion(),
            ],
          ),
        ),
      ),
    );
  }
}
