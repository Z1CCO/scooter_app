
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scooter_app/screens/home/item/item_order.dart';
import 'package:scooter_app/screens/profile/widget/language_constants.dart';
import 'package:scooter_app/screens/shop/shop_item_view_admin.dart';
import 'package:scooter_app/theme/appcolors.dart';
import 'package:scooter_app/theme/textstyles.dart';
import 'package:scooter_app/user.dart';

class DoneScreen extends StatefulWidget {
  final bool admin;
  const DoneScreen({super.key, required this.admin});

  @override
  State<DoneScreen> createState() => _DoneScreenState();
}

class _DoneScreenState extends State<DoneScreen> {
  @override
  Widget build(BuildContext context) {
    final userId = currentUser()!.uid;

    void addReating(itemID, selectReating, id) {
      FirebaseFirestore.instance.collection('posts').doc(itemID).update({
        'star': FieldValue.increment(selectReating),
        'costnumber': FieldValue.increment(1),
      });
      FirebaseFirestore.instance.collection('buy').doc(id).update({
        'voice': true,
      });
      setState(() {});
    }

    void showRatingDialog(BuildContext context, Map<String, dynamic> item) {
      showDialog(
        context: context,
        builder: (context) {
          int selectedRating = 1;
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(translation(context).mahsulotnibaholash),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(5, (index) {
                        return Column(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.star,
                                color: index < selectedRating
                                    ? Colors.yellow
                                    : Colors.grey,
                                size: 30,
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedRating = index + 1;
                                });
                              },
                            ),
                          ],
                        );
                      }),
                    ),
                    const SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        child: item['voice'] != true
                            ? Text(translation(context)
                                .mahsulotnifaqatbirmartabaholashingizmumkin)
                            : Text(translation(context)
                                .sizmahsulotniavvalbaholagansiz),
                      ),
                    )
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      translation(context).bekorQilish,
                      style: TextStyles.s17w500kanitblack,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (item['voice'] != true) {
                        addReating(
                          item['productId'],
                          selectedRating,
                          item['id'],
                        );
                      } else {}

                      Navigator.of(context).pop();
                    },
                    child: Text(
                      item['voice'] != true
                          ? translation(context).baholash
                          : 'Ok',
                      style: TextStyles.s18w500kanitblue,
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
    }

    Future<QuerySnapshot> adminfuture() async {
      return await FirebaseFirestore.instance
          .collection('buy')
          .where('get', isEqualTo: true)
          .orderBy('timestamp', descending: true)
          .get();
    }

    Future<QuerySnapshot> future() async {
      return await FirebaseFirestore.instance
          .collection('buy')
          .where('userId', isEqualTo: userId)
          .where('get', isEqualTo: true)
          .orderBy('timestamp', descending: true)
          .get();
    }

    return FutureBuilder<QuerySnapshot>(
      future: widget.admin == true ? adminfuture() : future(),
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
            child: Text(
              translation(context).hozirchaBajarilganBuyurtmalarMavjudEmas,
            ),
          );
        }

        final items = snapshot.data!.docs;

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index].data() as Map<String, dynamic>;
            return GestureDetector(
              onTap: () {
                widget.admin == true
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ShopItemViewAdmin(
                            data: item,
                          ),
                        ),
                      )
                    : showRatingDialog(context, item);
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
