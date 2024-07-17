import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scooter_app/theme/appcolors.dart';

class CarouselPopularWidget extends StatelessWidget {
  final bool userAdmin;
  const CarouselPopularWidget({super.key, required this.userAdmin});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('advertising').get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.deepBlue,
            ),
          );
        }

        final data = snapshot.data!.docs;

        return CarouselSlider(
          items: data.map((doc) {
            final imageUrl = doc['imageUrl'] ?? '';

            return GestureDetector(
              onLongPress: userAdmin
                  ? () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditCarouselSlider(
                            imageUrl: imageUrl,
                            docId: doc.id,
                          ),
                        ),
                      )
                  : () {},
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          }).toList(),
          options: CarouselOptions(
            height: 190,
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
        );
      },
    );
  }
}

class EditCarouselSlider extends StatefulWidget {
  final String imageUrl;
  final String docId;

  // ignore: prefer_const_constructors_in_immutables
  EditCarouselSlider({super.key, required this.imageUrl, required this.docId});

  @override
  // ignore: library_private_types_in_public_api
  _EditCarouselSliderState createState() => _EditCarouselSliderState();
}

class _EditCarouselSliderState extends State<EditCarouselSlider> {
  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _pickedImage = pickedImage;
    });
  }

  Future<void> _submitData() async {
    if (_pickedImage == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final imageUrl = await _uploadImage(_pickedImage!);
      await FirebaseFirestore.instance
          .collection('advertising')
          .doc(widget.docId)
          .update({
        'imageUrl': imageUrl,
      });
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> _uploadImage(XFile image) async {
    final storageReference = FirebaseStorage.instance.ref().child(
        'uploads/${DateTime.now().millisecondsSinceEpoch}_${image.name}');
    final uploadTask = storageReference.putFile(File(image.path));
    final taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Image')),
      body: Column(
        children: [
          const SizedBox(height: 50),
          Container(
            margin: const EdgeInsets.all(8),
            width: double.infinity,
            height: 240,
            child: Image.network(widget.imageUrl),
          ),
          const SizedBox(
            height: 50,
            child: Icon(Icons.repeat_outlined),
          ),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              margin: const EdgeInsets.all(8),
              width: double.infinity,
              height: 240,
              child: _pickedImage == null
                  ? Image.asset('assets/images/upload.png')
                  : Image.file(
                      File(_pickedImage!.path),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.deepBlue,
        onPressed: _submitData,
        child: _isLoading
            ? const CircularProgressIndicator(color: AppColors.white)
            : const Icon(
                Icons.check,
                color: AppColors.white,
              ),
      ),
    );
  }
}
