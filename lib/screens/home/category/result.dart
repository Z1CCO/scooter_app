import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scooter_app/theme/appcolors.dart';
import 'package:scooter_app/theme/textstyles.dart';
import 'package:scooter_app/screens/home/item/item.dart';

class ResultScreen extends StatefulWidget {
  final String type;
  final String title;
  final String name;
  const ResultScreen(
      {super.key, required this.type, required this.name, required this.title});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late final Future? _future;

  @override
  void initState() {
    _future = getActivityuser();
    super.initState();
  }

  Future getActivityuser() async {
    await FirebaseFirestore.instance
        .collection('posts')
        .where('type', isEqualTo: widget.type)
        .get()
        .then(
          // ignore: avoid_function_literals_in_foreach_calls
          (value) => value.docs.forEach(
            (element) {
              items.add(element.reference.id);
            },
          ),
        );
  }

  List items = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.deepBlue,
              ),
            );
          }

          return Scaffold(
            backgroundColor: AppColors.grey,
            appBar: AppBar(
              iconTheme: const IconThemeData(
                color: AppColors.white,
              ),
              backgroundColor: AppColors.deepBlue,
              title: Text(
                widget.title,
                style: TextStyles.s25w500kanitwhite,
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 12, 12, 0),
              child: GridView.builder(
                itemCount: items.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 10,
                  childAspectRatio: 2 / 3,
                  mainAxisSpacing: 0,
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) => MyItemWidget(
                  category: 'Skuter',
                  id: items[index],
                  name: widget.name,
                ),
              ),
            ),
          );
        });
  }
}
