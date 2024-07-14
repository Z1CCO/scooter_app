import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: constant_identifier_names
const String LANGUAGE_CODE = 'languageCode';

// ignore: constant_identifier_names
const String UZBEK = 'uz';
// ignore: constant_identifier_names
const String RUSSKIY = 'ru';

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(LANGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String languageCode = prefs.getString(LANGUAGE_CODE) ?? UZBEK;
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case UZBEK:
      return const Locale(UZBEK, 'UZ');
    case RUSSKIY:
      return const Locale(RUSSKIY, 'RU');
    default:
      return const Locale(UZBEK, 'UZ');
  }
}

AppLocalizations translation(BuildContext context){
  return AppLocalizations.of(context)!;
}