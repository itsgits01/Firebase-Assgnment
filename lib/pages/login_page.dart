import 'package:firebase_assgnment/pages/signup_page.dart';
import 'package:firebase_assgnment/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  //sign in method

  void signin() async {
    showDialog(
        context: context,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passController.text);

      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (context.mounted) Navigator.pop(context);
      displayMessage(e.toString());
    }
  }

  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade500,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                //logo
                Icon(
                  Icons.lock,
                  size: 100,
                ),
                const SizedBox(
                  height: 50,
                ),
                Text(
                  "Welcome to login Page",
                  style: TextStyle(height: 5),
                ),
                SizedBox(height: 20),
                MyTextField(
                    controller: emailController,
                    obscureText: false,
                    hintText: "Email"),

                SizedBox(
                  height: 20,
                ),
                MyTextField(
                    controller: passController,
                    obscureText: true,
                    hintText: "Password"),

                const SizedBox(
                  height: 20,
                ),

                ElevatedButton(onPressed: signin, child: Text("Login")),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Dont't have a account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignupPage()));
                        },
                        child: Text('Sign up'))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
