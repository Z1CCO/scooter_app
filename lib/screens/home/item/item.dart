import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scooter_app/screens/home/item/item_view.dart';
import 'package:scooter_app/theme/appcolors.dart';
import 'package:shimmer/shimmer.dart';

class MyItemWidget extends StatelessWidget {
  final String category;
  final String id;
  final String name;
  const MyItemWidget({
    super.key,
    required this.category,
    required this.id,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('posts').doc(id).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          String stringhot = data['hot'];
          String stringcost = data['cost'];
          int intValuehot = int.parse(stringhot);
          int intValuehcost = int.parse(stringcost);
          if (data['category'] == category) {
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ItemView(
                    data: data,
                    name: name,
                  ),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 160,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              data['mediaUrl1'],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        data['name'],
                        style:
                            const TextStyle(fontSize: 20, fontFamily: 'Kanit'),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${data['star'] == null ? data['star'] / data['costnumber'] : 0} (${data['costnumber']})',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0, top: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$ ${data['cost']}',
                              style: TextStyle(
                                  decoration: intValuehcost > intValuehot
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  color: intValuehcost > intValuehot
                                      ? AppColors.red
                                      : AppColors.deepBlue,
                                  fontFamily: 'Kanit'),
                            ),
                            const SizedBox(width: 8),
                            intValuehcost > intValuehot
                                ? Text(
                                    '\$ ${data['hot']}',
                                    style: const TextStyle(
                                        color: AppColors.deepBlue,
                                        fontFamily: 'Kanit'),
                                  )
                                : const SizedBox(),
                            const Spacer(),
                            const Icon(Icons.favorite_outline_rounded)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        } else {
          return Shimmer.fromColors(
            period: const Duration(milliseconds: 500),
            baseColor: Colors.grey[400]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
    );
  }
}
