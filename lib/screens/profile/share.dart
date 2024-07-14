import 'package:flutter/material.dart';
import 'package:scooter_app/screens/profile/widget/language_constants.dart';
import 'package:scooter_app/theme/appcolors.dart';
import 'package:scooter_app/theme/textstyles.dart';
import 'package:scooter_app/widgets/social_networks.dart';

class ShareScreen extends StatefulWidget {
  const ShareScreen({super.key});

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  List<String> images = [
    'assets/images/telegram.png',
    'assets/images/instagram.png',
    'assets/images/map.png',
    'assets/images/call.png',
  ];

  @override
  Widget build(BuildContext context) {
    List<String> titles = [
      'Telegram',
      'Instagram',
      translation(context).joylashuv,
      translation(context).telefonRaqam,
    ];
    List<String> descriptions = [
      translation(context).bizniTelegramdagiRasmiySahifamizObunaBoling,
      translation(context).bizniInstagramdagiRasmiySahifamizObunaBoling,
      translation(context).fargonaViloyati,
      '+998 90 150 51 77 \n+998 90 150 51 77',
    ];
    return Scaffold(
      backgroundColor: AppColors.grey,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 0, 0),
        child: Column(
          children: [
            const SizedBox(height: 18),
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
                  translation(context).bizgaBoglanish,
                  style: TextStyles.s25w500kanitblack,
                ),
                const SizedBox(
                  height: 50,
                  width: 50,
                )
              ],
            ),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: () => Utils.openTelegramm(),
              child: MyListTile(
                  images: images[0],
                  titles: titles[0],
                  descriptions: descriptions[0]),
            ),
            GestureDetector(
              onTap: () => Utils.openInstagramm(),
              child: MyListTile(
                  images: images[1],
                  titles: titles[1],
                  descriptions: descriptions[1]),
            ),
            GestureDetector(
              onTap: () => Utils.openMap(),
              child: MyListTile(
                  images: images[2],
                  titles: titles[2],
                  descriptions: descriptions[2]),
            ),
            GestureDetector(
              onTap: () => Utils.openTelephone(),
              child: MyListTile(
                  images: images[3],
                  titles: titles[3],
                  descriptions: descriptions[3]),
            ),
          ],
        ),
      ),
    );
  }
}

class MyListTile extends StatelessWidget {
  const MyListTile({
    super.key,
    required this.images,
    required this.titles,
    required this.descriptions,
  });

  final String images;
  final String titles;
  final String descriptions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 12, 8),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: AppColors.white,
        leading: Image.asset(images),
        title: Text(
          titles,
          style: TextStyles.s17w500kanitblack,
        ),
        subtitle: Text(descriptions),
      ),
    );
  }
}
