import 'package:flutter/material.dart';
import 'package:scooter_app/main.dart';
import 'package:scooter_app/screens/profile/widget/language_constants.dart';
import 'package:scooter_app/theme/appcolors.dart';

import 'package:scooter_app/theme/textstyles.dart';

class LocaleScreen extends StatefulWidget {
  const LocaleScreen({super.key});

  @override
  State<LocaleScreen> createState() => _LocaleScreenState();
}

class _LocaleScreenState extends State<LocaleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.white),
        backgroundColor: AppColors.deepBlue,
        title: Text(
          translation(context).til,
          style: TextStyles.s25w500kanitwhite,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Text(
              '🇺🇿',
              style: TextStyle(fontSize: 20),
            ),
            title: const Text('Uzbek'),
            onTap: () async {
              Locale locale = await setLocale('uz');
              // ignore: use_build_context_synchronously
              MyApp.setLocale(context, locale);
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Text(
              '🇷🇺',
              style: TextStyle(fontSize: 20),
            ),
            title: const Text('Russian'),
            onTap: () async {
              Locale locale0 = await setLocale('ru');
              // ignore: use_build_context_synchronously
              MyApp.setLocale(context, locale0);
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
