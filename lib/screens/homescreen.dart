import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:scooter_app/screens/favourite.dart';
import 'package:scooter_app/screens/home/home.dart';
import 'package:scooter_app/screens/profile/profile.dart';
import 'package:scooter_app/screens/profile/widget/language_constants.dart';
import 'package:scooter_app/screens/shop/shop.dart';
import 'package:scooter_app/theme/appcolors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  List screens = [
    const Home(),
    const Favourite(),
    const Shop(),
    const Profile(),
  ];
  List<String> images = [
    'assets/images/home.png',
    'assets/images/favourite.png',
    'assets/images/shop.png',
    'assets/images/profile.png',
  ];

  @override
  Widget build(BuildContext context) {
    List<String> labels = [
      translation(context).boshSahifa,
      translation(context).sevimlilar,
      translation(context).buyurtmalar,
      translation(context).kabinet,
    ];

    return Scaffold(
      backgroundColor: AppColors.grey,
      body: screens[currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: SalomonBottomBar(
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.deepBlue,
          currentIndex: currentIndex,
          onTap: (value) {
            currentIndex = value;
            setState(() {});
          },
          items: List.generate(
            images.length,
            (index) => SalomonBottomBarItem(
              activeIcon: SizedBox(
                width: 22,
                child: Image.asset(
                  images[index],
                  color: Colors.blue,
                ),
              ),
              icon: SizedBox(
                width: 22,
                child: Image.asset(
                  images[index],
                ),
              ),
              title: Text(
                labels[index],
                style: const TextStyle(fontFamily: 'Kanit'),
              ),
              selectedColor: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }
}
