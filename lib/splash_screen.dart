import 'package:arya/utils/constants/colors.dart';
import 'package:arya/utils/constants/sizes.dart';
import 'package:arya/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  final Function onLoaded;

  const SplashScreen({Key? key, required this.onLoaded}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = THelperFuntions.isDarkMode(context);
    // Simulate loading time
    Future.delayed(const Duration(seconds: 3), () {
      onLoaded();
    });

    return Scaffold(
      backgroundColor:
          dark ? TColors.dark : TColors.primary, // Or any color you want
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Splash image
            Image.asset(
              'assets/logos/splash_bg.png', // Adjust size as needed
            ), // Spacing between image and text
            // Welcome text
            Text(
              "Welcome to Arya!",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: dark ? TColors.primary : TColors.dark,
                fontFamily: 'Nunito', // Text color
              ),
            ),
            Text(
              'Powered by Piramal Finance',
              style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: TSizes.fontSizeSm,
                  color: dark ? TColors.primary : Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
