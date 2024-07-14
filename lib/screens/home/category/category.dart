import 'package:flutter/material.dart';
import 'package:scooter_app/screens/home/category/result.dart';
import 'package:scooter_app/screens/profile/widget/language_constants.dart';
import 'package:scooter_app/theme/appcolors.dart';
import 'package:scooter_app/theme/textstyles.dart';

// ignore: must_be_immutable
class CategoryScreen extends StatelessWidget {
  final String name;
  CategoryScreen({super.key, required this.name});

  List<String> images = [
    'assets/images/sportiv.png',
    'assets/images/scooter.png',
    'assets/images/velik.png',
    'assets/images/samakat.png',
  ];

  List types = [
    'Mototsikl',
    'Skuter',
    'Velosiped',
    'Samakat',
  ];

  @override
  Widget build(BuildContext context) {
    List title = [
      translation(context).motatsikl,
      translation(context).skuter,
      translation(context).velosiped,
      translation(context).samakat,
    ];
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.white),
        backgroundColor: AppColors.deepBlue,
        title: Text(
          translation(context).kategoriya,
          style: TextStyles.s25w500kanitwhite,
        ),
      ),
      backgroundColor: Colors.grey.shade200,
      body: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: ListTile(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ResultScreen(
                  type: types[index],
                  name: name,
                  title: title[index],
                ),
              ),
            ),
            minTileHeight: 80,
            tileColor: AppColors.white,
            leading: Image.asset(
              images[index],
              color: AppColors.deepBlue,
            ),
            title: Text(
              title[index],
              style: TextStyles.s25w500kanitblack,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: AppColors.black),
            ),
          ),
        ),
      ),
    );
  }
}
