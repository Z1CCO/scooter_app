import 'package:url_launcher/url_launcher.dart';

class Utils {
  Utils._();

  static Future<void> openMap() async {
    String googleMapUrl =
        'https://www.google.com/maps/search/?api=1&query=40.546898,70.951453';
    // ignore: deprecated_member_use
    if (await canLaunch(googleMapUrl)) {
      // ignore: deprecated_member_use
      await launch(googleMapUrl);
    }
  }

  static Future<void> openInstagramm() async {
    String instaUrl = 'https://www.instagram.com/zikrilloxon.x/';
// ignore: deprecated_member_use
    if (await canLaunch(instaUrl)) {
      // ignore: deprecated_member_use
      await launch(instaUrl);
    }
  }

  static Future<void> openTelegramm() async {
    String telegramUrl = 'https://t.me/z1krilloxon';
// ignore: deprecated_member_use
    if (await canLaunch(telegramUrl)) {
      // ignore: deprecated_member_use
      await launch(telegramUrl);
    }
  }

  static Future<void> openTelephone() async {
    final Uri url = Uri(
      scheme: 'tel',
      path: "+998901505177",
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}
