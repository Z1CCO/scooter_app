// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scooter_app/screens/profile/widget/language_constants.dart';
import 'package:scooter_app/theme/appcolors.dart';
import 'package:scooter_app/theme/textstyles.dart';
import 'package:scooter_app/widgets/login_button.dart';
import 'package:scooter_app/widgets/my_textfield.dart';

class MasterScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  const MasterScreen({required this.user, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MasterScreenState createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  TextEditingController controller = TextEditingController();
  XFile? _image1;
  XFile? _image2;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickImage(int imageNumber) async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (imageNumber == 1) {
        _image1 = pickedImage;
      } else {
        _image2 = pickedImage;
      }
    });
  }

  Future<void> _submitData() async {
    if (controller.text.isEmpty || _image1 == null || _image2 == null) {
      _showAlertDialog(
        translation(context).xato,
        translation(context).iltimosBarchaMaydonlarniToldiring,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Rasmlarni yuklash
      String imageUrl1 = await _uploadImage(_image1!);
      String imageUrl2 = await _uploadImage(_image2!);

      // Ma'lumotlarni yuborish
      await FirebaseFirestore.instance.collection('reports').add({
        'name': widget.user['name'],
        'userId': widget.user['id'],
        'email': widget.user['email'],
        'admin': widget.user['admin'],
        'description': controller.text,
        'image1': imageUrl1,
        'image2': imageUrl2,
        'timestamp': Timestamp.now(),
      });

      _showAlertDialog(translation(context).muvaffaqiyat,
          translation(context).malumotyuborildi);

      setState(() {
        controller.clear();
        _image1 = null;
        _image2 = null;
      });
    } catch (e) {
      _showAlertDialog(
        translation(context).xato,
        translation(context).malumotOlishdaXatolikYuzBerdy,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> _uploadImage(XFile image) async {
    Reference storageReference = FirebaseStorage.instance.ref().child(
        'uploads/${DateTime.now().millisecondsSinceEpoch}_${image.name}');
    UploadTask uploadTask = storageReference.putFile(File(image.path));
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Text(
            translation(context).agarSkuteringizgaBirorNarsaBolsa,
            style: TextStyles.s17w500kanitblack,
          ),
          const SizedBox(height: 30),
          MyTextField(
              controller: controller, hint: translation(context).nimaboldi),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                translation(context).rasmyuborish,
                style: TextStyles.s17w500kanitblack,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => _pickImage(1),
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(color: AppColors.black),
                  ),
                  child: _image1 == null
                      ? Image.asset('assets/images/upload.png')
                      : Image.file(
                          File(_image1!.path),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              GestureDetector(
                onTap: () => _pickImage(2),
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(color: AppColors.black),
                  ),
                  child: _image2 == null
                      ? Image.asset('assets/images/upload.png')
                      : Image.file(
                          File(_image2!.path),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          _isLoading
              ? const CircularProgressIndicator(
                  color: AppColors.deepBlue,
                )
              : LoginElevatedButton(
                  onTap: _submitData,
                  text: translation(context).yuborish,
                ),
        ],
      ),
    );
  }
}
