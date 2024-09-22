// app.dart
import 'package:chef_noodle/features/chef_noodle/authentication/screens/login/login_page.dart';
import 'package:chef_noodle/features/chef_noodle/authentication/screens/signup/signup_page.dart';
import 'package:chef_noodle/features/chef_noodle/screens/home_page.dart';
import 'package:chef_noodle/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chef_noodle/utils/theme/theme.dart';
import 'package:chef_noodle/controllers/theme_controller.dart'; // Add this import
import 'package:google_generative_ai/google_generative_ai.dart'; // Add this import

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    final geminiVisionProModel;

    return GetMaterialApp(
      themeMode: themeController.themeMode.value,
      debugShowCheckedModeBanner: false,
      theme: TAppTheme().lightTheme,
      darkTheme: TAppTheme().darkTheme,
      home: const SplashScreen(),
    );
  }
}
