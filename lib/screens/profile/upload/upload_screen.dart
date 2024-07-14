import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scooter_app/main.dart';
import 'package:scooter_app/screens/profile/upload/create_new_item.dart';
import 'package:uuid/uuid.dart';

String postId = const Uuid().v4();

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  File? imageFilefirst;
  File? imageFilesecond;
  File? imageFilethrees;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _costController = TextEditingController();
  final _numberController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool isUploading = false;
  bool icLoading = false;

  void handleChooseFromGallery() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 500,
      maxWidth: 500,
    );
    if (file != null) setState(() => imageFilefirst = File(file.path));
  }

  void handleChooseFromGallery2() async {
    final file1 = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 500,
      maxWidth: 500,
    );
    if (file1 != null) setState(() => imageFilesecond = File(file1.path));
  }

  void handleChooseFromGallery3() async {
    final file2 = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 500,
      maxWidth: 500,
    );
    if (file2 != null) setState(() => imageFilethrees = File(file2.path));
  }

  void clearImage() => setState(() {
        imageFilefirst = null;
        imageFilesecond = null;
        imageFilethrees = null;
      });

  Future<File> compressImage(File image, String postId) async {
    final fileBytes = await image.readAsBytes();
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    final decodedImage = img.decodeImage(fileBytes);
    final compressedImage = File("$path/image$postId.jpg")
      ..writeAsBytesSync(
        img.encodeJpg(decodedImage!, quality: 85),
      );
    return compressedImage;
  }

  Future<String> uploadImage(File image, String postId) async {
    UploadTask uploadTask = storageRef.child("post_$postId.jpg").putFile(image);
    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  void handleSubmit() async {
    setState(() => isUploading = true);

    // Compress each image individually and get the compressed files
    File compressedImage1 = await compressImage(imageFilefirst!, "1_$postId");
    File compressedImage2 = await compressImage(imageFilesecond!, "2_$postId");
    File compressedImage3 = await compressImage(imageFilethrees!, "3_$postId");

    // Upload each compressed image and get the download URLs
    String mediaUrl1 = await uploadImage(compressedImage1, "1_$postId");
    String mediaUrl2 = await uploadImage(compressedImage2, "2_$postId");
    String mediaUrl3 = await uploadImage(compressedImage3, "3_$postId");

    // Create the post in Firestore with the download URLs
    createPostInFirestore(
      category: category ??
          'xato', // You can replace this with your actual category or make it dynamic
      number: _numberController.text,
      description: _descriptionController.text,
      name: _nameController.text,
      cost: _costController.text,
      mediaUrl1: mediaUrl1,
      mediaUrl2: mediaUrl2,
      mediaUrl3: mediaUrl3,
    );

    _descriptionController.clear();
    _costController.clear();
    _numberController.clear();
    _nameController.clear();
    imageFilefirst = null;
    imageFilesecond = null;
    imageFilethrees = null;
    isUploading = false;
    postId = const Uuid().v4();
    setState(() {});
  }

  createPostInFirestore({
    required String mediaUrl1,
    required String mediaUrl2,
    required String mediaUrl3,
    required String description,
    required String name,
    required String number,
    required String cost,
    required String category,
  }) {
    FirebaseFirestore.instance.collection('posts').doc(postId).set({
      'timestamp': FieldValue.serverTimestamp(),
      'postId': postId,
      'name': name,
      'description': description,
      'mediaUrl1': mediaUrl1,
      'mediaUrl2': mediaUrl2,
      'mediaUrl3': mediaUrl3,
      'cost': cost,
      'category': category,
      'number': number,
      'hot': cost,
      'costnumber': 0,
      'star': 0,
      'type': type ?? 'zapchast',
      'color1': true,
      'color2': true,
      'color3': true,
      'color4': true,
      'color5': true,
      'like' : [],
    });
    Navigator.pop(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CreateNewItem(
      imagesecond: imageFilesecond,
      imagethrees: imageFilethrees,
      uploading: isUploading,
      imagefirst: imageFilefirst,
      name: _nameController,
      cost: _costController,
      number: _numberController,
      discription: _descriptionController,
      onPressed: handleChooseFromGallery,
      onPressed2: handleChooseFromGallery2,
      onPressed3: handleChooseFromGallery3,
      handleSubmit: handleSubmit,
    );
  }
}
