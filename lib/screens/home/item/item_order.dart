import 'package:flutter/material.dart';
import 'package:scooter_app/theme/appcolors.dart';

class MyItemOrderWidget extends StatelessWidget {
  final String image;
  final String name;
  final String cost;
  final String hot;
  final int star;
  const MyItemOrderWidget({
    super.key,
    required this.image,
    required this.name,
    required this.cost,
    required this.star,
    required this.hot,
  });

  @override
  Widget build(BuildContext context) {
    String stringhot = hot;
    String stringcost = cost;
    int intValuehot = int.parse(stringhot);
    int intValuehcost = int.parse(stringcost);
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Container(
              width: 150,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(image),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontFamily: 'Kanit',
                    ),
                  ),
                  Text(
                    '⭐ $star',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        '\$ $cost',
                        style: TextStyle(
                            fontSize: 20,
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
                              '\$ $hot',
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: AppColors.deepBlue,
                                  fontFamily: 'Kanit'),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
