import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flood_survival_app/config/routes.dart';
import 'package:flood_survival_app/screens/auth/login_screen.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  static User? get currentUser => _auth.currentUser;

  // Check if user is logged in
  static bool get isLoggedIn => currentUser != null;

  // Sign out
  static Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  // Check authentication state and redirect accordingly
  static void checkAuthState(BuildContext context) {
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    });
  }
}
