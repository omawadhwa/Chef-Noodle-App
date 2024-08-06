import 'package:chef_noodle/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:chef_noodle/utils/theme/custom_themes/checkbox_theme.dart';
import 'package:chef_noodle/utils/theme/custom_themes/elevated_button_theme.dart';
import 'package:chef_noodle/utils/theme/custom_themes/outlined_button_theme.dart';
import 'package:chef_noodle/utils/theme/custom_themes/text_field_theme.dart';
import 'package:chef_noodle/utils/theme/custom_themes/text_theme.dart';
import 'package:chef_noodle/utils/theme/custom_themes/appbar_theme.dart';
import 'package:chef_noodle/utils/theme/custom_themes/bottom_sheet_theme.dart';

class TAppTheme{
  // TAppTheme._();

   ThemeData lightTheme = ThemeData(
    // useMaterial3: true,
    fontFamily: 'Nunito',
    brightness: Brightness.light,
    primaryColor: TColors.primary,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TTextTheme.lightTextTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
    checkboxTheme: TCheckboxTheme.lightCheckboxTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
  );
   ThemeData darkTheme = ThemeData(
    // useMaterial3: true,
    fontFamily: 'Nunito',
    brightness: Brightness.dark,
    primaryColor: TColors.primary,
    scaffoldBackgroundColor: Colors.black,
    textTheme: TTextTheme.darkTextTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    appBarTheme: TAppBarTheme.darkAppBarTheme,
    bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme,
    checkboxTheme: TCheckboxTheme.darkCheckboxTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,
  );
}