import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scooter_app/screens/home/category/category.dart';
import 'package:scooter_app/screens/home/chat.dart';
import 'package:scooter_app/screens/home/grid_scooter.dart';
import 'package:scooter_app/screens/home/grid_spareparts.dart';
import 'package:scooter_app/screens/home/masterscreen.dart';
import 'package:scooter_app/screens/home/search.dart';
import 'package:scooter_app/screens/home/walletscreen.dart';
import 'package:scooter_app/screens/home/widgets/carouselpopular.dart';
import 'package:scooter_app/screens/profile/widget/language_constants.dart';
import 'package:scooter_app/theme/appcolors.dart';
import 'package:scooter_app/theme/textstyles.dart';
import 'package:scooter_app/user.dart';
import 'package:scooter_app/widgets/circle_container.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selected = 0;

  Widget _tabButton(String text, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = index;
        });
      },
      child: Column(
        children: [
          Text(
            text,
            style: TextStyles.s17w500kanitblack,
          ),
          const SizedBox(height: 4),
          Container(
            height: 4,
            width: 120,
            color: selected == index ? AppColors.black : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildBody(data) {
    switch (selected) {
      case 0:
        return GridScooter(
          user: data,
        );
      case 1:
        return GridSpareParts(
          user: data,
        );
      case 2:
        return MasterScreen(
          user: data,
        );
      default:
        return Container(); // Agar masofaviy xatolik yuz bering, qayta ishlang
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> texts = [
      translation(context).skuterlar,
      translation(context).zapchastlar,
      translation(context).ustaXizmati,
    ];

    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser()!.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final data = snapshot.data!.data();
            return Scaffold(
              backgroundColor: AppColors.grey,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 80,
                            child: Image.asset('assets/images/logo.png'),
                          ),
                          const Spacer(),
                          data!['admin']
                              ? GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => WalletScreen(),
                                    ),
                                  ),
                                  child: const MyCircleContainerWidget(
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Icon(
                                          Icons.account_balance_wallet_rounded),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatScreen(
                                  user: data!,
                                ),
                              ),
                            ),
                            child: MyCircleContainerWidget(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Image.asset('assets/images/chat.png'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Search(
                                    name: data!['name'],
                                  ),
                                ),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width - 105,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Image.asset(
                                          'assets/images/search.png'),
                                    ),
                                    Text(
                                      translation(context).qidirish,
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CategoryScreen(
                                  name: data!['name'],
                                ),
                              ),
                            ),
                            child: Container(
                              // Expanded ni olib tashladim
                              margin: const EdgeInsets.only(left: 12),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              height: 50,
                              child: Image.asset('assets/images/drawer.png'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    CarouselPopularWidget(
                      userAdmin: data!['admin'],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 24, 18, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _tabButton(texts[0], 0),
                          _tabButton(texts[1], 1),
                          _tabButton(texts[2], 2),
                        ],
                      ),
                    ),
                    _buildBody(data),
                  ],
                ),
              ),
            );
          }
          {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.deepBlue,
              ),
            );
          }
        });
  }
}
