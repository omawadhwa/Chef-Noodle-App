import 'package:chef_noodle/features/chef_noodle/authentication/screens/login/login_page.dart';
import 'package:chef_noodle/features/chef_noodle/authentication/screens/verification/verification_page.dart';
import 'package:chef_noodle/utils/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:chef_noodle/utils/helpers/helper_functions.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> _signUp() async {
  // Validate input fields
  if (_nameController.text.trim().isEmpty) {
    Get.snackbar('Error', 'Name cannot be empty');
    return;
  }

  if (_emailController.text.trim().isEmpty) {
    Get.snackbar('Error', 'Email cannot be empty');
    return;
  }

  if (_passwordController.text.isEmpty) {
    Get.snackbar('Error', 'Password cannot be empty');
    return;
  }

  if (_confirmPasswordController.text.isEmpty) {
    Get.snackbar('Error', 'Please confirm your password');
    return;
  }

  if (_passwordController.text != _confirmPasswordController.text) {
    Get.snackbar('Error', 'Passwords do not match');
    return;
  }

  try {
    final UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    // Update user's display name
    User? user = userCredential.user;
    if (user != null) {
      await user.updateProfile(displayName: _nameController.text.trim());

      // Send email verification
      await user.sendEmailVerification();

      // Navigate to VerificationPage
      Get.to(() => VerificationPage(email: _emailController.text.trim()));
    }
  } on FirebaseAuthException catch (e) {
    Get.snackbar('Error', e.message ?? 'An error occurred');
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Create your Account',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                  ],
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                      labelText: 'Name', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: 'Confirm Password', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 60),
                GestureDetector(
                  onTap: _signUp, // Trigger the sign-up functionality
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: TColors.secondary, // Replace with TColors.secondary
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black, width: 0.7),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sign Up', // Update the button text here
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
                  onPressed: () => Get.to(() => LoginPage()),
                  child: Text(
                    'Already have an account? Log in',
                    style: TextStyle(
                      color: dark ? Colors.white : Colors.black,
                      fontSize: 15,
                      decoration:
                          TextDecoration.underline, // This adds the underline
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
            )
    );
  }
}
