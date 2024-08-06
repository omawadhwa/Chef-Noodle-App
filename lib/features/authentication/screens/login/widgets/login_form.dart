import 'dart:ffi';

import 'package:chef_noodle/controllers/theme_controller.dart';
import 'package:chef_noodle/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chef_noodle/utils/constants/sizes.dart';
import 'package:chef_noodle/utils/constants/text_strings.dart';
import 'package:chef_noodle/features/chatbot_arya/screens/chat_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TLoginForm extends StatefulWidget {
  const TLoginForm({
    super.key,
  });

  @override
  State<TLoginForm> createState() => _TLoginFormState();
}

class _TLoginFormState extends State<TLoginForm> {
  bool obsure = true;
  final email = TextEditingController();
  final password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final dark = THelperFuntions.isDarkMode(context);
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [
            // email
            TextFormField(
              controller: email,
              validator: (value) {
                if (value == "") {
                  return "Please enter email";
                }
                if (value != "test.arya@piramal.com") {
                  return "Email is incorrect";
                }
                return null;
              },
              style: TextStyle(color: dark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_rounded),
                  labelText: TTexts.email,
                  floatingLabelStyle:
                      TextStyle(color: dark ? Colors.white : Colors.black),
                  labelStyle: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: dark ? Colors.white : Colors.black)),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // password
            TextFormField(
              controller: password,
              validator: (value) {
                if (value == "") {
                  return "Please enter password";
                }
                if (value != "arya_test@piramal*#") {
                  return "Password is incorrect";
                }
                return null;
              },
              style: TextStyle(color: dark ? Colors.white : Colors.black),
              obscureText: obsure,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_rounded),
                labelText: TTexts.password,
                floatingLabelStyle:
                    TextStyle(color: dark ? Colors.white : Colors.black),
                labelStyle: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: dark ? Colors.white : Colors.black),
                suffixIcon: GestureDetector(
                    onTap: () {
                      obsure = !obsure;
                      setState(() {});
                    },
                    child: Icon(!obsure
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded)),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),

            // remember me and forget password
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     // remember me
            //     Row(
            //       children: [
            //         Checkbox(value: true, onChanged: (value) {}),
            //         const Text(TTexts.rememberMe),
            //       ],
            //     ),

            //     // forget password
            //     TextButton(
            //       onPressed: () {},
            //       child: const Text(TTexts.forgotPassword),
            //     ),
            //   ],
            // ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // signin button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setBool("isAuthenticated", true);
                    final ThemeController themeController =
                        Get.put(ThemeController());
                    Get.offAll(() => ChatScreen(
                          themeMode: themeController.themeMode.value,
                          toggleThemeMode: themeController.toggleThemeMode,
                        ));
                  }
                },
                child: const Text(TTexts.signIn),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwItems),
            // create account button
            // SizedBox(
            //   width: double.infinity,
            //   child: OutlinedButton(
            //     onPressed: () {},
            //     child: const Text(TTexts.createAccount),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
