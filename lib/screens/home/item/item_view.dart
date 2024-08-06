import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scooter_app/screens/profile/widget/language_constants.dart';
import 'package:scooter_app/theme/appcolors.dart';
import 'package:scooter_app/theme/textstyles.dart';
import 'package:scooter_app/user.dart';
import 'package:scooter_app/screens/home/item/item_header.dart';
import 'package:scooter_app/widgets/my_textfield.dart';

class ItemView extends StatefulWidget {
  final Map<String, dynamic> data;
  final String name;
  const ItemView({
    super.key,
    required this.data,
    required this.name,
  });

  @override
  State<ItemView> createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  TextEditingController locationController = TextEditingController();
  TextEditingController telController = TextEditingController();
  PageController controller = PageController();
  Color selectedColor = Colors.transparent; // Default value, might be changed
  List<Color> myColors = [];

  @override
  void initState() {
    setInitialColors();

    super.initState();
  }

  void _alertdialog(image) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          height: 440,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                  height: 160,
                  child: Image.network(
                    image,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: locationController,
                hint: translation(context).manzilShaharKochaUy,
              ),
              const SizedBox(height: 10),
              MyTextField(
                keytype: TextInputType.phone,
                controller: telController,
                hint: translation(context).telefon,
              ),
              const SizedBox(height: 10),
              Text(
                translation(context)
                    .manzilniVaTelefonRaqamniTogriVaToliqKiritish,
                style: TextStyles.s17w500kanitblack,
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                      color: AppColors.red,
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        translation(context).qaytish,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: MaterialButton(
                      color: AppColors.green,
                      onPressed: () {
                        if (_validateInput()) {
                          buy();
                        } else {
                          _showValidationError();
                        }
                      },
                      child: Text(
                        translation(context).olish,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateInput() {
    String location = locationController.text.trim();
    String telefon = telController.text.trim();
    // Telefon raqamini faqat raqamlar ekanligini tekshirish va 13 raqam uzunligini tekshirish
    RegExp telRegExp = RegExp(r'^\+998[0-9]{9}$');
    return location.isNotEmpty && telRegExp.hasMatch(telefon);
  }

  void _showValidationError() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(translation(context).xato),
          content: Text(translation(context)
              .manzilBoshBolmasligiYokiTelefonRaqamiNotogri),
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

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.check_circle_outline_outlined,
              size: 35,
            ),
          ),
          content: Text(translation(context).mahsulotQoshildi),
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

  void setInitialColors() {
    // Har bir rangni tekshirish va agar true bo'lsa, myColors ga qo'shish
    if (widget.data['color1'] == true) myColors.add(Colors.white);
    if (widget.data['color2'] == true) myColors.add(Colors.black);
    if (widget.data['color3'] == true) myColors.add(Colors.red);
    if (widget.data['color4'] == true) myColors.add(Colors.green);
    if (widget.data['color5'] == true) myColors.add(Colors.blue);

    // Birinchi rangni tanlangan rang sifatida o'rnatish
    if (myColors.isNotEmpty) {
      selectedColor = myColors[0];
    }
  }

  void changeColor(int index) {
    setState(() {
      selectedColor = myColors[index];
    });
  }

  Widget buildColorButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          for (var i = 0; i < myColors.length; i++) buildColorButton(i)
        ],
      ),
    );
  }

  Widget buildColorButton(int index) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          onPressed: () {
            changeColor(index);
          },
          icon: Icon(
            Icons.circle,
            color: myColors[index].withOpacity(0.65),
            size: 60,
          ),
        ),
        if (selectedColor == myColors[index])
          const Icon(
            Icons.check,
            color: AppColors.deepBlue,
            size: 30,
          ),
      ],
    );
  }

  void buy() {
    FirebaseFirestore.instance.collection('buy').add({
      'id': '', // Firebase tomonidan avtomatik yaratilgan ID
      'userId': currentUser()!.uid,
      'productId': widget.data['postId'],
      'username': widget.name,
      'location': locationController.text.trim(),
      'telefon': telController.text.trim(),
      'name': widget.data['name'],
      'star': widget.data['star'],
      'category': widget.data['category'],
      'cost': widget.data['hot'],
      'image': widget.data['mediaUrl1'],
      'timestamp': Timestamp.now(),
      'voice': false,
      'get': false,
    }).then((docRef) {
      String docId = docRef.id; // Yangi yaratilgan dokument ID sifatida olinadi
      // Yangi ID ni ma'lumotlarga qo'shamiz
      FirebaseFirestore.instance.collection('buy').doc(docId).update({
        'id': docId,
        'color': selectedColor == Colors.white
            ? 'oq'
            : selectedColor == Colors.black
                ? 'qora'
                : selectedColor == Colors.red
                    ? 'qizil'
                    : selectedColor == Colors.green
                        ? 'yashil'
                        : selectedColor == Colors.blue
                            ? 'ko\'k'
                            : 'yuuuuuuuu',
      });
      Navigator.pop(context); // Aktual ekran orqali qaytariladi
      Navigator.pop(context); // ItemView ekran orqali qaytariladi
      _showAlertDialog(); // Tasdiqlash oynasi chiqadi
      locationController.clear();
      telController.clear();
    }).catchError((error) {
      // Xatolik haqida foydalanuvchiga xabar berish
      // Masalan, _showErrorDialog() metod orqali
    });
  }

  @override
  Widget build(BuildContext context) {
    List images = [
      widget.data['mediaUrl1'],
      widget.data['mediaUrl2'],
      widget.data['mediaUrl3'],
    ];
    String stringhot = widget.data['hot'];
    String stringcost = widget.data['cost'];
    int intValuehot = int.parse(stringhot);
    int intValuehcost = int.parse(stringcost);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ItemHeader(
              controller: controller,
              images: images,
              widget: widget,
              like: List.from(
                widget.data['like'] ?? [],
              ),
              selectedColor: selectedColor,
            ),
            ListTile(
              title: Text(
                widget.data['name'],
                style: const TextStyle(
                  fontSize: 25,
                  fontFamily: 'Kanit',
                ),
              ),
              subtitle: Text(
                widget.data['type'],
              ),
              trailing: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '⭐ ${widget.data['star'] != 0 ? widget.data['star'] / widget.data['costnumber'] : 0} (${widget.data['costnumber']})',
                  style: const TextStyle(
                    fontSize: 25,
                    fontFamily: 'Kanit',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                style: const TextStyle(fontSize: 20),
                widget.data['description'],
              ),
            ),
            widget.data['category'] == 'Skuter'
                ? Row(
                    children: [
                      buildColorButtons(),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(36),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Row(
              children: [
                Text(
                  '\$ ${widget.data['cost']}',
                  style: TextStyle(
                    decoration: intValuehcost > intValuehot
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: intValuehcost > intValuehot
                        ? AppColors.red
                        : AppColors.deepBlue,
                    fontSize: 28,
                    fontFamily: 'Kanit',
                  ),
                ),
                const SizedBox(width: 8),
                intValuehcost > intValuehot
                    ? Text(
                        '\$ ${widget.data['hot']}',
                        style: const TextStyle(
                          color: AppColors.deepBlue,
                          fontSize: 28,
                          fontFamily: 'Kanit',
                        ),
                      )
                    : const SizedBox(),
                const Spacer(),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.deepBlue),
                    onPressed: () => _alertdialog(
                      images[0],
                    ),
                    child: const Text(
                      'Buy',
                      style: TextStyle(
                        height: -0.1,
                        color: Colors.white,
                        fontSize: 25,
                        fontFamily: 'Kanit',
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
