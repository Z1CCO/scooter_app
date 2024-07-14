import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselPopularWidget extends StatelessWidget {
  const CarouselPopularWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                'Mashxur',
                style: TextStyle(fontFamily: 'Kanit', fontSize: 20),
              ),
            ),
          ],
        ),
        CarouselSlider(
          items: List.generate(
            3,
            (index) => Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                  children: [
                    Container(
                      width: 140,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/images/moto.jpeg'),
                        ),
                      ),
                      child: const Align(
                        alignment: Alignment.topLeft,
                        child: Icon(Icons.favorite_outline_rounded),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Superfast',
                            style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'Kanit',
                            ),
                          ),
                          Text(
                            ' ⭐ 4.5 (124)',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Spacer(),
                          Text(
                            '\$ 700',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.green,
                                fontFamily: 'Kanit'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          options: CarouselOptions(
            height: 150,
            aspectRatio: 16 / 9,
            viewportFraction: 0.8,
            initialPage: 0,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            enlargeFactor: 0.3,
            scrollDirection: Axis.horizontal,
          ),
        ),
      ],
    );
  }
}
