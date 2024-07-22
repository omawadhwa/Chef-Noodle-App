import 'package:flutter/material.dart';

class TColors{
  TColors._();

  //app basic colors
  static const Color primary = Color(0XFFF26E24);
  static const Color secondary = Color(0xFF8E8E93);
  static const Color accent = Color(0xFFF5F5F5);

  //gradient colors
  static const Gradient linearGradient = LinearGradient(
    begin: Alignment(0.0, 0.0),
    end: Alignment(0.707, -0.707),
    colors: [
      Color(0xffff9a9e),
      Color(0xfffad0c4),
      Color(0xfffad0c4),
    ]
  );

  //text colors
  static const Color textprimary = Color(0xFFF26E24);
  static const Color textsecondary = Color(0xFF303030);
  static const Color textWhite = Colors.white;
  static const Color darkBlue = Color(0xFF124E7D);
  static const Color lightUserText = Color(0xFFFFFFFF);
  static const Color lightBotText = Color(0xFF4D4D4D);
  static const Color darkUserText = Color(0xFFFFFFFF);
  static const Color darkBotText = Color(0xFFFFFFFF);

  //background colors
  static const Color light = Color(0xFFF6F6F6);
  static const Color dark = Color(0xFF212324);
  static const Color primaryBackground = Color(0xFFF3F5FF);
  static const Color dark_bg = Color(0xFF2C2C2C);
  static const Color light_bg = Color(0xFFF3F5FF);
  static const Color lightUserTextBox = Color(0xFF124E7D);
  static const Color lightBotTextBox = Color(0xFFF1F1F1);
  static const Color darkUserTextBox = Color(0xFFF26E24);
  static const Color darkBotTextBox = Color(0xFF666666);

  //background container colors
  static const Color lightContainer = Color(0xFFF6F6F6);
  static Color darkContainer = TColors.white.withOpacity(0.1);

  //button colors
  static const Color buttonprimary = Color(0xFF4b68ff);
  static const Color buttonSecondary = Color(0xFF6C757D);
  static const Color buttonDisabled = Color(0xFFC4C4C4);

  //border colors
  static const Color borderPrimary = Color(0xFFD9D9D9);
  static const Color borderSecondary = Color(0xFFE6E6E6);

  //error and validation colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF1976D2);

  //neutral shades
  static const Color black = Color(0xFF232323);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF666666);
  static const Color grey = Color(0xFF4D4D4D);
  static const Color softGrey = Color(0xFFF4F4F4);
  static const Color lightGrey = Color(0xFFF6F6F6);
  static const Color white = Color(0xFFFFFFFF);
}