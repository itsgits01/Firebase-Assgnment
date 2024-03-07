import "package:firebase_assgnment/pages/login_page.dart";
import "package:firebase_assgnment/widgets/custom_textfield.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmpass = TextEditingController();

  void signup() async {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    if (passController.text != confirmpass.text) {
      Navigator.pop(context);
      displayMessage("Password don't match");
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, password: passController.text);
          if(context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Register to Our App!'),
                const SizedBox(
                  height: 20,
                ),
                Icon(
                  Icons.lock,
                  size: 100,
                ),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                    controller: passController,
                    hintText: "password",
                    obscureText: true),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                    controller: confirmpass,
                    hintText: "confirm password",
                    obscureText: true),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: signup,
                  child: Text('Sign up'),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have a account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        child: Text('Sign in'))
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
