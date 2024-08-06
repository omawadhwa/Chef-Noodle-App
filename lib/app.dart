// app.dart
import 'package:chef_noodle/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chef_noodle/utils/theme/theme.dart';
import 'package:chef_noodle/controllers/theme_controller.dart'; // Add this import
import 'package:chef_noodle/features/chatbot_arya/screens/chat_screen.dart'; // Add this import

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());

    return Obx(() => GetMaterialApp(
          themeMode: themeController.themeMode.value,
          debugShowCheckedModeBanner: false,
          theme: TAppTheme().lightTheme,
          darkTheme: TAppTheme().darkTheme,
          home: const SplashScreen(),
        ));
  }
}
