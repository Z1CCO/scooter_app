
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scooter_app/screens/home/item/item_view.dart';
import 'package:scooter_app/screens/home/widgets/like_button.dart';
import 'package:scooter_app/theme/appcolors.dart';
import 'package:scooter_app/user.dart';
import 'package:scooter_app/widgets/circle_container.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ItemHeader extends StatefulWidget {
 final Color selectedColor;
  const ItemHeader({
    super.key,
    required this.controller,
    required this.images,
    required this.like,
    required this.widget,
    required this.selectedColor,
  });

  final PageController controller;
  final List<dynamic> images;
  final List<dynamic> like;
  final ItemView widget;

  @override
  State<ItemHeader> createState() => _ItemHeaderState();
}

class _ItemHeaderState extends State<ItemHeader> {
  bool isLike = false;

  @override
  void initState() {
    super.initState();

    // Like holatini boshlang'ich holatga o'rnatish
    isLike = widget.like.contains(currentUser()?.email);

    // Ranglarni dinamik ravishda o'rnatish
  }

  void toggleLike() {
    setState(() {
      isLike = !isLike;
    });
    DocumentReference postRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.widget.data['postId']);
    if (isLike) {
      postRef.update({
        'like': FieldValue.arrayUnion([currentUser()?.email])
      });
    } else {
      postRef.update({
        'like': FieldValue.arrayRemove([currentUser()?.email])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              width: double.infinity,
              height: 350,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: PageView.builder(
                controller: widget.controller,
                itemCount: widget.images.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    widget.images[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: MyCircleContainerWidget(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset(
                            'assets/images/back.png',
                          ),
                        ),
                      ),
                    ),
                    MyCircleContainerWidget(
                      child: LikeButton(
                        islike: isLike,
                        onTap: toggleLike,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 20,
              bottom: 15,
              child: SmoothPageIndicator(
                controller: widget.controller,
                count: widget.images.length,
                effect: const ExpandingDotsEffect(
                    activeDotColor: AppColors.deepBlue),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

