import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scooter_app/screens/home/widgets/uploadtextfield.dart';
import 'package:scooter_app/screens/profile/widget/selectimage.dart';
import 'package:scooter_app/theme/appcolors.dart';
import 'package:scooter_app/theme/textstyles.dart';
import 'package:scooter_app/widgets/login_button.dart';

String? category;
String? type;

// ignore: must_be_immutable
class CreateNewItem extends StatefulWidget {
  bool uploading;
  File? imagefirst;
  File? imagesecond;
  File? imagethrees;
  TextEditingController name;
  TextEditingController discription;
  TextEditingController cost;
  TextEditingController number;
  VoidCallback onPressed;
  VoidCallback onPressed2;
  VoidCallback onPressed3;
  VoidCallback handleSubmit;

  CreateNewItem({
    super.key,
    required this.name,
    required this.cost,
    required this.discription,
    required this.onPressed,
    required this.onPressed2,
    required this.onPressed3,
    required this.number,
    required this.uploading,
    required this.handleSubmit,
    this.imagefirst,
    this.imagesecond,
    this.imagethrees,
  });

  @override
  State<CreateNewItem> createState() => _CreateNewItemState();
}

class _CreateNewItemState extends State<CreateNewItem> {
  int selected = 0;
  int selectedScooter = 0;

  Widget customRadio(String text, int index) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.black, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor:
              (selected == index) ? AppColors.deepBlue : Colors.blue.shade100),
      onPressed: () {
        selected = index;
        category = text;

        setState(() {});
      },
      child: Text(
        text,
        style: (selected == index)
            ? TextStyles.s16w500kanitwhite
            : TextStyles.s16w500kanitgrey,
      ),
    );
  }

  Widget customScooter(Widget icon, int index) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.black, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: (selectedScooter == index)
                ? AppColors.deepBlue
                : Colors.blue.shade100),
        onPressed: () {
          selectedScooter = index;

          setState(() {});
        },
        child: icon);
  }

  @override
  Widget build(BuildContext context) {
    selectedScooter == 1
        ? type = 'Mototsikl'
        : selectedScooter == 2
            ? type = 'Skuter'
            : selectedScooter == 3
                ? type = 'Velosiped'
                : type = 'Samakat';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 7,
        shadowColor: Colors.grey,
        backgroundColor: AppColors.deepBlue,
        iconTheme: const IconThemeData(
          color: AppColors.white,
        ),
        title: const Text(
          'Mahsulot qo\'shish',
          style: TextStyles.s25w500kanitwhite,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              widget.uploading == true
                  ? const LinearProgressIndicator(
                      color: Colors.red,
                    )
                  : const SizedBox(),
              Row(
                children: [
                  SelectImages(
                    onTap: widget.onPressed,
                    image: widget.imagefirst,
                  ),
                  const SizedBox(width: 4),
                  SelectImages(
                    onTap: widget.onPressed2,
                    image: widget.imagesecond,
                  ),
                  const SizedBox(width: 4),
                  SelectImages(
                    image: widget.imagethrees,
                    onTap: widget.onPressed3,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UploadTextField(
                      widget: widget.name,
                      hint: 'nomi',
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: UploadTextField(
                        widget: widget.discription,
                        hint: 'haqida',
                      ),
                    ),
                    UploadTextField(
                      keyboardType: TextInputType.number,
                      widget: widget.cost,
                      hint: 'narxi',
                    ),
                    const SizedBox(height: 10),
                    UploadTextField(
                      keyboardType: TextInputType.number,
                      widget: widget.number,
                      hint: 'soni',
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: customRadio('Skuter', 1)),
                        const SizedBox(width: 10),
                        Expanded(child: customRadio('Zapchast', 2)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    selected == 1
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: customScooter(
                                    Image.asset('assets/images/sportiv.png'),
                                    1),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: customScooter(
                                    Image.asset(
                                        'assets/images/scooter.png'),
                                    2),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: customScooter(
                                    Image.asset('assets/images/velik.png'),
                                    3),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: customScooter(
                                    Image.asset('assets/images/samakat.png'),
                                    4),
                              ),
                            ],
                          )
                        : const SizedBox(),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LoginElevatedButton(
          onTap: widget.imagefirst == null ? () {} : widget.handleSubmit,
          text: 'Joylash',
        ),
      ),
    );
  }
}
