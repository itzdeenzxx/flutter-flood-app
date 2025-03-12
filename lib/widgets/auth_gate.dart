import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flood_survival_app/screens/auth/login_screen.dart';

class AuthGate extends StatelessWidget {
  final Widget child;

  const AuthGate({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasData) {
          // User is logged in
          print("user ล็อกอินแล้ว");
          return child;
        } else {
          print("user ยังไม่ ล็อกอินแล้ว");
          // User is not logged in
          return const LoginScreen();
        }
      },
    );
  }
}
