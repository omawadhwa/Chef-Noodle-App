import 'package:chef_noodle/controllers/theme_controller.dart';
import 'package:chef_noodle/features/chef_noodle/authentication/screens/login/login_page.dart';
import 'package:chef_noodle/features/chef_noodle/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chef_noodle/utils/constants/colors.dart';
import 'package:chef_noodle/utils/constants/sizes.dart';
import 'package:chef_noodle/utils/helpers/helper_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFuntions.isDarkMode(context);

    // Simulate loading time
    Future.delayed(const Duration(seconds: 2), () async {
      final prefs = await SharedPreferences.getInstance();
      final isAuthenticated = prefs.getBool("isAuthenticated");
      // onLoaded(); // Call the callback to update the state in main.dart
      if (isAuthenticated == null) {
        Get.off(() => LoginPage());
      } else if (isAuthenticated) {
        // final ThemeController themeController = Get.put(ThemeController());
        // Get.off(() => HomePage());
      }
      // Use Get.off to navigate
    });

    return Scaffold(
      backgroundColor: dark ? const Color.fromARGB(255, 47, 70, 21) : TColors.secondary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Splash image
            Image.asset(
              'assets/logos/chef_noodle_logo.png',
              width: 200,
              height: 200,
            ),
            // Welcome text
            Text(
              "Chef Noodle",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: dark ? Colors.white : TColors.primary,
                fontFamily: 'Nunito',
              ),
            ),
            Text(
              'Made by Om Wadhwa',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: TSizes.fontSizeSm,
                color: dark ? Colors.white : TColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
