// app.dart
import 'package:arya/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:arya/utils/theme/theme.dart';
import 'package:arya/controllers/theme_controller.dart'; // Add this import
import 'package:arya/features/chatbot_arya/screens/chat_screen.dart'; // Add this import

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
