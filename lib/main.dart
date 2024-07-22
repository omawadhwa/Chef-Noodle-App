import 'package:arya/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:arya/app.dart';
import 'package:arya/utils/theme/theme.dart';
import 'package:arya/controllers/theme_controller.dart';
import 'package:arya/utils/features/chatbot_arya/screens/chat_screen.dart'; //

void main() {
  runApp(const App());
}

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   bool _isSplashLoaded = false;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize splash screen
//   }

//   void _onSplashLoaded() {
//     setState(() {
//       _isSplashLoaded = true;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'Arya App',
//       home:
//     );
//   }
// }
