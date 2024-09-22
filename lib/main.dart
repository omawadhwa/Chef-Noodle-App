import 'package:chef_noodle/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chef_noodle/app.dart';
import 'package:chef_noodle/utils/theme/theme.dart';
import 'package:chef_noodle/controllers/theme_controller.dart';
import 'package:firebase_core/firebase_core.dart'; //

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase here
  runApp(const App());
} 