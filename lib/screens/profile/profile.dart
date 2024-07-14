import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scooter_app/screens/login/login.dart';
import 'package:scooter_app/screens/profile/about.dart';
import 'package:scooter_app/screens/profile/editprofile.dart';
import 'package:scooter_app/screens/profile/share.dart';
import 'package:scooter_app/screens/profile/upload/upload_screen.dart';
import 'package:scooter_app/screens/profile/widget/language.dart';
import 'package:scooter_app/screens/profile/widget/language_constants.dart';
import 'package:scooter_app/screens/profile/widget/profile_item.dart';
import 'package:scooter_app/theme/appcolors.dart';
import 'package:scooter_app/theme/textstyles.dart';
import 'package:scooter_app/user.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late final Future<DocumentSnapshot<Map<String, dynamic>>> _future;

  @override
  void initState() {
    _future = getActivityuser();
    super.initState();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getActivityuser() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser()!.uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
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
          return Center(
              child: Text('${translation(context).xato} ${snapshot.error}'));
        }

        if (snapshot.hasData &&
            snapshot.data != null &&
            snapshot.data!.exists) {
          final data = snapshot.data!.data();
          if (data == null) {
            return Center(child: Text(translation(context).malumotTopilmadi));
          }

          return Scaffold(
            backgroundColor: AppColors.grey,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    Stack(
                      children: [
                        const SizedBox(width: 115, height: 115),
                        const CircleAvatar(
                          radius: 55,
                          backgroundImage: NetworkImage(
                            'https://images.pexels.com/photos/2379005/pexels-photo-2379005.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: FloatingActionButton(
                            backgroundColor: Colors.lightBlueAccent.shade700,
                            mini: true,
                            heroTag: null, // Hero animatsiyasidan chiqarish
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const EditProfile(),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/images/editline.png',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      data['name'] ?? 'Ism yo\'q',
                      style: const TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade200,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        data['email'] ?? 'Email yo\'q',
                        style: TextStyle(
                          color: Colors.lightBlueAccent.shade700,
                          fontFamily: 'Satisfy',
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditProfile(),
                        ),
                      ),
                      child: ProfileItemWidget(
                        image: 'assets/images/edit.png',
                        icon: true,
                        text: translation(context).profilniTahrirlash,
                        colors: AppColors.deepBlue,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ShareScreen(),
                        ),
                      ),
                      child: ProfileItemWidget(
                        image: 'assets/images/share.png',
                        icon: true,
                        text: translation(context).koproq,
                        colors: Colors.amber,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AboutScreen(),
                        ),
                      ),
                      child: ProfileItemWidget(
                        image: 'assets/images/about.png',
                        icon: true,
                        text: translation(context).haqida,
                        colors: AppColors.green,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LocaleScreen(),
                        ),
                      ),
                      child: ProfileItemWidget(
                        image: 'assets/images/translate.png',
                        icon: true,
                        text: translation(context).til,
                        colors: AppColors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        bool confirmLogout = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              backgroundColor: Colors.white,
                              title: Text(
                                translation(context).chiqish,
                                style: TextStyles.s25w500kanitblack,
                              ),
                              content: Text(
                                translation(context)
                                    .haqiqatdanHamTizimdanChiqmoqchimisiz,
                                style: TextStyles.s17w500kanitblack,
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text(
                                    translation(context).yoq,
                                    style: TextStyles.s17w500kanitblack,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: Text(
                                    translation(context).chiqish,
                                    style: TextStyles.s17w500kanitred,
                                  ),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirmLogout == true) {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushReplacement(
                            // ignore: use_build_context_synchronously
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        }
                      },
                      child: ProfileItemWidget(
                        colors: AppColors.red,
                        image: 'assets/images/logout.png',
                        icon: false,
                        text: translation(context).chiqish,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: data['admin'] == true
                ? FloatingActionButton(
                    backgroundColor: Colors.lightBlueAccent.shade700,
                    heroTag: 'uploadHero', // Noyob heroTag qo'shildi
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UploadImage(),
                      ),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 30,
                      color: AppColors.white,
                    ),
                  )
                : const SizedBox(),
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
