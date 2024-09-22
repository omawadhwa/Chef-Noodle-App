import 'package:chef_noodle/features/chef_noodle/authentication/screens/signup/signup_page.dart';
import 'package:chef_noodle/features/chef_noodle/screens/home_page.dart';
import 'package:chef_noodle/utils/constants/colors.dart';
import 'package:chef_noodle/utils/helpers/helper_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
  // Validate fields
  if (_emailController.text.trim().isEmpty) {
    Get.snackbar('Error', 'Please enter your email.');
    return;
  }
  if (_passwordController.text.trim().isEmpty) {
    Get.snackbar('Error', 'Please enter your password.');
    return;
  }

  try {
    final UserCredential userCredential =
        await _auth.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      // Fetch user's display name
      String userName = user.displayName ?? 'User'; // Default to 'User' if no display name

      // Successful login, and email is verified
      Get.snackbar('Login Success', 'Welcome back!',
          snackPosition: SnackPosition.BOTTOM);

      // Navigate to HomePage with userEmail and userName
      Get.off(() => HomePage(userEmail: user.email!, userName: userName));
    } else {
      // Email not verified
      Get.snackbar('Error', 'Please verify your email first.');
    }
  } on FirebaseAuthException catch (e) {
    // Handle specific Firebase Auth exceptions
    if (e.code == 'user-not-found') {
      Get.snackbar('Error', 'No user found with this email.');
    } else if (e.code == 'wrong-password') {
      Get.snackbar('Error', 'Incorrect password.');
    } else {
      Get.snackbar('Error', e.message ?? 'An error occurred');
    }
  }
}


  @override
  Widget build(BuildContext context) {
    final dark = THelperFuntions.isDarkMode(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height, // Set the minimum height to full screen
        ),
        child: IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset('assets/logos/chef_noodle_logo.png', width: 120,),
                        ],
                      ),
                      const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('Welcome Back',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                      labelText: 'Email', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: 'Password', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 60),
                GestureDetector(
                  onTap: _login, // Trigger the login functionality
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: TColors.secondary, // Replace with your desired color
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black, width: 0.7),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: "Nunito",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Get.to(() => SignUpPage()),
                  child: Text(
                    'Don\'t have an account? Sign up',
                    style: TextStyle(
                      color: dark ? Colors.white : Colors.black,
                      fontSize: 15,
                      decoration:
                          TextDecoration.underline, // Adds the underline
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
          ),
      );
  }
}
