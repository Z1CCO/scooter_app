
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scooter_app/theme/appcolors.dart';
import 'package:scooter_app/theme/textstyles.dart';
import 'package:scooter_app/widgets/circle_container.dart';

class ShopItemViewAdmin extends StatefulWidget {
  final Map<String, dynamic> data;
  const ShopItemViewAdmin({super.key, required this.data});

  @override
  State<ShopItemViewAdmin> createState() => _ShopItemViewAdminState();
}

class _ShopItemViewAdminState extends State<ShopItemViewAdmin> {
  bool get = false;

  @override
  void initState() {
    super.initState();
    get = widget.data['get'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 350,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Image.network(
                  widget.data['image'],
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 30,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
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
                ),
              ),
            ],
          ),
          ListTile(
            title: Text(
              widget.data['username'],
              style: TextStyles.s25w500kanitblack,
            ),
            subtitle: Text(
              widget.data['telefon'],
              style: TextStyles.s17w500kanitblack,
            ),
          ),
          ListTile(
            title: Text(
              widget.data['color'],
              style: TextStyles.s25w500kanitblack,
            ),
            subtitle: Text(
              widget.data['location'],
              style: TextStyles.s17w500kanitblack,
            ),
          ),
          ListTile(
            title: Text(
              widget.data['name'],
              style: TextStyles.s25w500kanitblack,
            ),
            subtitle: Text(
              widget.data['category'],
              style: TextStyles.s16w500kanitgrey,
            ),
            trailing: Text(
              '\$  ${widget.data['cost']}',
              style: TextStyles.s25w500kanitblack,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  get ? 'Yubrilgan' : 'Yuborilmagan',
                  style: TextStyles.s25w500kanitblack,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Switch.adaptive(
                  autofocus: true,
                  activeTrackColor: AppColors.deepBlue,
                  value: get,
                  onChanged: (newValue) {
                    setState(() {
                      get = newValue;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.deepBlue,
        onPressed: () {
          FirebaseFirestore.instance
              .collection('buy')
              .doc(widget.data['id'])
              .update({'get': get});
          Navigator.pop(context);
        },
        child: const Icon(
          Icons.done_all,
          color: AppColors.white,
        ),
      ),
    );
  }
}
