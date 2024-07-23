import 'package:arya/controllers/theme_controller.dart';
import 'package:arya/features/chatbot_arya/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:arya/features/authentication/screens/login/login.dart';
import 'package:arya/utils/constants/colors.dart';
import 'package:arya/utils/constants/sizes.dart';
import 'package:arya/utils/helpers/helper_functions.dart';
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
        Get.off(() => const LoginScreen());
      } else if (isAuthenticated) {
        final ThemeController themeController = Get.put(ThemeController());
        Get.off(() => ChatScreen(
              themeMode: themeController.themeMode.value,
              toggleThemeMode: themeController.toggleThemeMode,
            ));
      }
      // Use Get.off to navigate
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
