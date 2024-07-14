import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scooter_app/screens/homescreen.dart';
import 'package:scooter_app/screens/profile/widget/language_constants.dart';
import 'package:scooter_app/theme/appcolors.dart';
import 'package:scooter_app/theme/textstyles.dart';
import 'package:scooter_app/widgets/login_button.dart';
import 'package:scooter_app/widgets/my_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nickNameController = TextEditingController();

  bool isLoading = false;
  bool isLogin = true;
  bool _disposed = false; // Add a flag to track disposal

  @override
  void initState() {
    super.initState();
    checkUserLoggedIn();
  }

  @override
  void dispose() {
    _disposed = true; // Set the flag to true on dispose
    super.dispose();
  }

  void checkUserLoggedIn() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (!_disposed) {
        if (user != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        } else {
          setState(() {
            isLogin = true;
          });
        }
      }
    });
  }

  Future<void> handleAuth() async {
    try {
      if (!_disposed) {
        setState(() {
          isLoading = true;
        });
      }

      if (!_disposed && !isLogin && nickNameController.text.trim().length < 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(translation(context).ismKamidaUchtaHarfliBolishiKerak),
          ),
        );
        setState(() {
          isLoading = false;
        });
        return;
      }

      UserCredential userCredential;
      if (!_disposed && isLogin) {
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        log('Kirish muvaffaqiyatli: ${userCredential.user?.uid}');
      } else if (!_disposed) {
        userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        log('Ro\'yxatdan o\'tish muvaffaqiyatli: ${userCredential.user?.uid}');

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user?.uid)
            .set({
          'name': nickNameController.text.trim(),
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
          'id': userCredential.user?.uid,
          'admin': false,
        });
      }

      if (!_disposed) {
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      log('${translation(context).xato}  ${e.message}');
      if (!_disposed) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          // ignore: use_build_context_synchronously
          SnackBar(content: Text('${translation(context).xato} ${e.message}')),
        );
      }
    } finally {
      if (!_disposed) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 120),
            SizedBox(
              height: 120,
              child: Image.asset('assets/images/logo.png'),
            ),
            const SizedBox(height: 40),
            Text(
              isLogin
                  ? translation(context).kirish
                  : translation(context).royxatdanOtish,
              style: TextStyles.s25w500kanitblack,
            ),
            const SizedBox(height: 10),
            if (!isLogin)
              MyTextField(
                controller: nickNameController,
                hint: translation(context).ism,
              ),
            const SizedBox(height: 10),
            MyTextField(
              controller: emailController,
              hint: translation(context).elektronPochta,
            ),
            const SizedBox(height: 10),
            MyTextField(
              controller: passwordController,
              hint: translation(context).parol,
            ),
            const SizedBox(height: 18),
            LoginElevatedButton(
              onTap: () async {
                await handleAuth();
              },
            ),
            const SizedBox(height: 80),
            GestureDetector(
              onTap: () {
                if (!_disposed) {
                  // Check if widget is still mounted
                  setState(() {
                    isLogin = !isLogin;
                  });
                }
              },
              child: Text(
                isLogin
                    ? translation(context)
                        .haliRoyxatdanOtmangansizmiBuYerdaroyxatdanOtish
                    : translation(context).sizRoyxatdanOtgansizmiBuYergakirish,
                style: TextStyles.s18w500kanitblue,
              ),
            ),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 12.0),
                child: Center(
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      color: AppColors.deepBlue,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
