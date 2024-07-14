import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scooter_app/screens/profile/widget/language_constants.dart';
import 'package:scooter_app/theme/appcolors.dart';
import 'package:scooter_app/theme/textstyles.dart';
import 'package:scooter_app/user.dart';
import 'package:scooter_app/widgets/my_textfield.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController controller = TextEditingController();

  late final Future _future;

  @override
  void initState() {
    _future = getActivityuser();
    super.initState();
  }

  Future getActivityuser() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser()!.uid)
        .get();
  }

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

        if (snapshot.hasError) {
          return Center(child: Text('Xatolik yuz berdi: ${snapshot.error}'));
        }
        if (snapshot.hasData &&
            snapshot.data != null &&
            snapshot.data!.exists) {
          final data = snapshot.data!.data();
          if (data == null) {
            return Center(
                child: Text(
              translation(context).malumotTopilmadi,
            ));
          }

          return Scaffold(
            backgroundColor: AppColors.grey,
            body: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 45,
                        height: 45,
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
                      Text(
                        translation(context).profilniSozlash,
                        style: TextStyles.s25w500kanitblack,
                      ),
                      const SizedBox(
                        height: 50,
                        width: 50,
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  const CircleAvatar(
                    backgroundColor: Colors.amber,
                    radius: 45,
                    backgroundImage: AssetImage('assets/images/logo.png'),
                  ),
                  const SizedBox(height: 60),
                  MyTextField(
                    controller: controller,
                    hint: data['name'],
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.lightBlueAccent.shade700,
              heroTag: 'uploadHero', // Noyob heroTag qo'shildi
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser()!.uid)
                    .update({
                  'name': controller.text.trim(),
                });
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.done_all_rounded,
                size: 30,
                color: AppColors.white,
              ),
            ),
          );
        } else {
          return Center(
            child: Text(
              translation(context).malumotTopilmadi,
            ),
          );
        }
      },
    );
  }
}
