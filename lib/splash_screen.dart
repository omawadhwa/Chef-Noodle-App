import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:arya/features/authentication/screens/login/login.dart';
import 'package:arya/utils/constants/colors.dart';
import 'package:arya/utils/constants/sizes.dart';
import 'package:arya/utils/helpers/helper_functions.dart';

class SplashScreen extends StatelessWidget {
  final VoidCallback onLoaded;

  const SplashScreen({Key? key, required this.onLoaded}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = THelperFuntions.isDarkMode(context);

    // Simulate loading time
    Future.delayed(const Duration(seconds: 3), () {
      onLoaded(); // Call the callback to update the state in main.dart
      Get.off(() => const LoginScreen()); // Use Get.off to navigate
    });

    return Scaffold(
      backgroundColor: dark ? TColors.dark : TColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Splash image
            Image.asset(
              'assets/logos/splash_bg.png',
            ),
            // Welcome text
            Text(
              "Welcome to Arya!",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: dark ? TColors.primary : TColors.dark,
                fontFamily: 'Nunito',
              ),
            ),
            Text(
              'Powered by Piramal Finance',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: TSizes.fontSizeSm,
                color: dark ? TColors.primary : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
