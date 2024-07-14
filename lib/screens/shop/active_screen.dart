
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scooter_app/screens/home/item/item_order.dart';
import 'package:scooter_app/screens/profile/widget/language_constants.dart';
import 'package:scooter_app/screens/shop/shop_item_view_admin.dart';
import 'package:scooter_app/theme/appcolors.dart';
import 'package:scooter_app/user.dart';

class ActiveScreen extends StatelessWidget {
  final bool admin;
  const ActiveScreen({super.key, required this.admin});

  @override
  Widget build(BuildContext context) {
    final userId = currentUser()!.uid;

    Future<QuerySnapshot> adminfuture() async {
      return await FirebaseFirestore.instance
          .collection('buy')
          .where('get', isEqualTo: false)
          .orderBy('timestamp', descending: true)
          .get();
    }

    Future<QuerySnapshot> future() async {
      return await FirebaseFirestore.instance
          .collection('buy')
          .where('userId', isEqualTo: userId)
          .where('get', isEqualTo: false)
          .orderBy('timestamp', descending: true)
          .get();
    }

    return FutureBuilder<QuerySnapshot>(
      future: admin == true ? adminfuture() : future(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.deepBlue,
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(translation(context).hozirchaFaolBuyurtmalarMavjudEmas),
          );
        }

        final items = snapshot.data!.docs;

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index].data() as Map<String, dynamic>;
            return GestureDetector(
              onTap: () {
                admin == true
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ShopItemViewAdmin(
                            data: item,
                          ),
                        ),
                      )
                    : () {};
              },
              child: MyItemOrderWidget(
                image: item['image'],
                name: item['name'],
                cost: item['cost'],
                star: item['star'],
                hot: item['cost'],
              ),
            );
          },
        );
      },
    );
  }
}