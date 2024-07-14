import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scooter_app/screens/home/item/myeditcolor.dart';
import 'package:scooter_app/theme/appcolors.dart';
import 'package:scooter_app/theme/textstyles.dart';
import 'package:scooter_app/widgets/my_textfield.dart';

class EditItemScreen extends StatefulWidget {
  final String id;
  const EditItemScreen({super.key, required this.id});

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  TextEditingController costController = TextEditingController();
  TextEditingController hotController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  List<bool> colors = [
    false,
    false,
    false,
    false,
    false
  ]; // Qo'shimcha: Rang holatlari

  List texts = [
    'Oq',
    'Qora',
    'Qizil',
    'Yashil',
    'Ko\'k',
  ];

  @override
  void initState() {
    super.initState();
    _loadItemData();
  }

  // Qo'shimcha funksiya: Ma'lumotlarni yuklash
  void _loadItemData() async {
    var doc = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.id)
        .get();
    var data = doc.data() as Map<String, dynamic>;

    nameController.text = data['name'];
    numberController.text = data['number'];
    costController.text = data['cost'];
    descriptionController.text = data['description'];
    hotController.text = data['hot'];

    setState(() {
      colors = [
        data['color1'],
        data['color2'],
        data['color3'],
        data['color4'],
        data['color5'],
      ];
    });
  }

  // Firebase yangilash funksiyasiga ranglarni qo'shish
  void updateFirebase() {
    FirebaseFirestore.instance.collection('posts').doc(widget.id).update({
      'name': nameController.text,
      'number': numberController.text,
      'cost': costController.text,
      'description': descriptionController.text,
      'hot': hotController.text,
      'color1': colors[0],
      'color2': colors[1],
      'color3': colors[2],
      'color4': colors[3],
      'color5': colors[4],
    });
    Navigator.pop(context);
  }

  Widget _myText(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyles.s17w500kanitblack,
      ),
    );
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('O\'chirish'),
          content: const Text('Rostdan ham xabarni o\'chirmoqchimisiz'),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Yo\'q',
                style: TextStyles.s17w500kanitblack,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: _deleteMessage,
              child: const Text(
                'Ha',
                style: TextStyles.s17w500kanitred,
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteMessage() async {
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.id)
          .delete();
    // ignore: empty_catches
    } catch (e) {
    }
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.white),
        backgroundColor: AppColors.deepBlue,
        title: const Text(
          'Tahrirlash',
          style: TextStyles.s25w500kanitwhite,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: _showAlertDialog,
            icon: const Icon(
              Icons.delete,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // Ma'lumotlarni yuklashdan keyin barcha kontrollarni o'zgartiramiz
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('posts')
                    .doc(widget.id)
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
                    return const Text('Xatolik yuz berdi');
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Text('Ma\'lumot topilmadi');
                  }

                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  return Column(
                    children: [
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        height: 200,
                        child: Image.network(data['mediaUrl1']),
                      ),
                      const SizedBox(height: 12),
                      _myText('Ranglar'),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          colors.length,
                          (index) => MyEditColor(
                            initialCheck: colors[index],
                            text: texts[index],
                            onChanged: (value) {
                              setState(() {
                                colors[index] = value;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _myText('nomi'),
                      const SizedBox(height: 12),
                      MyTextField(
                        controller: nameController,
                        hint: data['name'],
                      ),
                      const SizedBox(height: 12),
                      _myText('tavsif'),
                      const SizedBox(height: 12),
                      MyTextField(
                        controller: descriptionController,
                        hint: data['description'],
                      ),
                      const SizedBox(height: 12),
                      _myText('soni'),
                      const SizedBox(height: 12),
                      MyTextField(
                        controller: numberController,
                        hint: data['number'],
                      ),
                      const SizedBox(height: 12),
                      _myText('narxi'),
                      const SizedBox(height: 12),
                      MyTextField(
                        controller: costController,
                        hint: data['cost'],
                      ),
                      const SizedBox(height: 12),
                      _myText('chegirma'),
                      const SizedBox(height: 12),
                      MyTextField(
                        controller: hotController,
                        hint: data['hot'],
                      ),
                      const SizedBox(height: 12),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: updateFirebase, // UpdateFirebase funksiyasini chaqirish
        backgroundColor: AppColors.deepBlue,
        child: const Icon(
          Icons.done_all_rounded,
          color: AppColors.white,
        ),
      ),
    );
  }
}
