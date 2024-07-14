import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scooter_app/screens/home/item/item_view.dart';
import 'package:scooter_app/screens/profile/widget/language_constants.dart';
import 'package:scooter_app/theme/appcolors.dart';
import 'package:scooter_app/user.dart';
import 'package:scooter_app/screens/home/item/item_order.dart';
import 'package:shimmer/shimmer.dart';

class Favourite extends StatefulWidget {
  const Favourite({super.key});

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  late final Future? _future;

  @override
  void initState() {
    _future = getActivityuser();
    super.initState();
  }

  Future getActivityuser() async {
    await FirebaseFirestore.instance
        .collection('posts')
        .where('like', arrayContains: currentUser()!.email)
        .get()
        .then(
          // ignore: avoid_function_literals_in_foreach_calls
          (value) => value.docs.forEach(
            (element) {
              posts.add(element.reference.id);
            },
          ),
        );
  }

  List<String> posts = [];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser()!.uid)
            .get(),
        builder: (context, snapshot) {
          final data = snapshot.data?.data();
          return SafeArea(
            child: FutureBuilder(
                future: _future,
                builder: (context, snapshot) {
                  return Scaffold(
                    backgroundColor: AppColors.grey,
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      title: Text(
                        translation(context).sevimlilar,
                        style: const TextStyle(fontFamily: 'Kanit', fontSize: 30),
                      ),
                    ),
                    body: ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        return FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('posts')
                              .doc(posts[index])
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Shimmer.fromColors(
                                direction: ShimmerDirection.ttb,
                                period: const Duration(milliseconds: 400),
                                baseColor: Colors.grey[500]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  margin: const EdgeInsets.all(8),
                                  width: double.infinity,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            }
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  translation(context)
                                      .malumotOlishdaXatolikYuzBerdy,
                                ),
                              );
                            }
                            if (!snapshot.hasData || snapshot.data == null) {
                              return Center(
                                child: Text(
                                  translation(context)
                                      .hechQandayMalumotTopilmadi,
                                ),
                              );
                            }

                            // DocumentSnapshot dan data() ni chaqirib, Map<String, dynamic> ni oling
                            var documentData =
                                snapshot.data!.data() as Map<String, dynamic>;

                            String title = documentData['name'];
                            String cost = documentData['cost'];
                            String image = documentData['mediaUrl1'];
                            int star = documentData['star'];
                            String hot = documentData['hot'];

                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ItemView(
                                    data: documentData,
                                    name: data!['name'],
                                  ),
                                ),
                              ),
                              child: MyItemOrderWidget(
                                image: image,
                                name: title,
                                cost: cost,
                                star: star,
                                hot: hot,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                }),
          );
        });
  }
}
