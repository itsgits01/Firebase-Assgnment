import 'package:firebase_assgnment/pages/home_page.dart';
import 'package:firebase_assgnment/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //if user is logged in
          if (snapshot.hasData) {
            return Homepage();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
