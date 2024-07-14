import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scooter_app/screens/home/item/item_view.dart';
import 'package:scooter_app/screens/profile/widget/language_constants.dart';
import 'package:scooter_app/theme/appcolors.dart';
import 'package:scooter_app/screens/home/item/item_order.dart';

class Search extends StatefulWidget {
  final String name;
  const Search({super.key, required this.name});

  @override
  // ignore: library_private_types_in_public_api
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  List<String> searchResults = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void searchFirestore(String searchText) {
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('name')
        .where('name', isEqualTo: searchText)
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        searchResults.clear();
        for (var doc in querySnapshot.docs) {
          searchResults
              .add(doc.id); // Firebase document IDlarini natijalarga qo'shish
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: Container(
          width: 40,
          height: 40,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.fromLTRB(10, 4, 0, 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Image.asset('assets/images/back.png'),
          ),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          onChanged: (value) {
            if (value.isNotEmpty) {
              searchFirestore(value);
            } else {
              setState(() {
                searchResults.clear();
              });
            }
          },
          decoration: InputDecoration(
            isDense: true,
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(
                'assets/images/search.png',
                width: 10,
                height: 10,
              ),
            ),
            hintText: translation(context).qidirish,
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      body: searchResults.isEmpty
          ? Center(
              child: Text(
                translation(context).hechQandayMalumotTopilmadi,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(searchResults[index])
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.deepBlue,
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                            translation(context).malumotOlishdaXatolikYuzBerdy),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data == null) {
                      return  Center(
                        child: Text(
                            translation(context).hechQandayMalumotTopilmadi),
                      );
                    }

                    // DocumentSnapshot dan data() ni chaqirib, Map<String, dynamic> ni oling
                    var documentData =
                        snapshot.data!.data() as Map<String, dynamic>;

                    String title = documentData['name'];
                    String cost = documentData['cost'];
                    String hot = documentData['hot'];
                    String image = documentData['mediaUrl1'];
                    int star = documentData['star'];

                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ItemView(
                            data: documentData,
                            name: widget
                                .name, // Bu yerda data ni Map<String, dynamic> formatida foydalaning
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
  }
}
