import 'package:firebase_auth/firebase_auth.dart';

User? currentUser() {
  return FirebaseAuth.instance.currentUser;
}