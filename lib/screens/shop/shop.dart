import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scooter_app/screens/profile/widget/language_constants.dart';
import 'package:scooter_app/screens/shop/active_screen.dart';
import 'package:scooter_app/screens/shop/done_screen.dart';
import 'package:scooter_app/theme/appcolors.dart';
import 'package:scooter_app/user.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser()!.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData || snapshot.data?.data() == null) {
              return Center(
                child: Text(
                  translation(context).malumotTopilmadi,
                ),
              );
            }
            final data = snapshot.data!.data() as Map<String, dynamic>;

            return Scaffold(
              backgroundColor: AppColors.grey,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 40.0,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent,
                    ),
                    child: TabBar(
                      physics: const NeverScrollableScrollPhysics(),
                      labelStyle: const TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Kanit'),
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: Colors.black,
                      dividerColor: Colors.transparent,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(
                          text: translation(context).faol,
                        ),
                        Tab(
                          text: translation(context).yuborildi,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: TabBarView(
                  children: [
                    ActiveScreen(
                      admin: data['admin'],
                    ),
                    DoneScreen(
                      admin: data['admin'],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

