import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scooter_app/screens/home/item/edititem.dart';
import 'package:scooter_app/screens/home/item/item.dart';

class GridSpareParts extends StatefulWidget {
  final Map<String, dynamic> user;
  const GridSpareParts({super.key, required this.user});

  @override
  State<GridSpareParts> createState() => _GridSparePartsState();
}

class _GridSparePartsState extends State<GridSpareParts> {
  late final Future? _future;

  @override
  void initState() {
    _future = getActivityuser();
    super.initState();
  }

  Future getActivityuser() async {
    await FirebaseFirestore.instance
        .collection('posts')
        .where('category', isEqualTo: 'Zapchast')
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
        future: _future,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: GridView.builder(
              itemCount: posts.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 10,
                childAspectRatio: 2 / 3,
                mainAxisSpacing: 0,
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) => GestureDetector(
                onLongPress: widget.user['admin']
                    ? () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditItemScreen(
                              id: posts[index],
                            ),
                          ),
                        )
                    : () {},
                child: MyItemWidget(
                  category: 'Zapchast',
                  id: posts[index],
                  name: widget.user['name'],
                ),
              ),
            ),
          );
        });
  }
}
