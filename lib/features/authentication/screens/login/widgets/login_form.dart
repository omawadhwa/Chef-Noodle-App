import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:arya/utils/constants/sizes.dart';
import 'package:arya/utils/constants/text_strings.dart';
import 'package:arya/utils/features/chatbot_arya/screens/chat_screen.dart';

class TLoginForm extends StatelessWidget {
  const TLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [
            // email
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email_rounded),
                labelText: TTexts.email,
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // password
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock_rounded),
                labelText: TTexts.password,
                suffixIcon: Icon(Icons.visibility_off_rounded),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),

            // remember me and forget password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // remember me
                Row(
                  children: [
                    Checkbox(value: true, onChanged: (value) {}),
                    const Text(TTexts.rememberMe),
                  ],
                ),

                // forget password
                TextButton(
                  onPressed: () {},
                  child: const Text(TTexts.forgotPassword),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // signin button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  print("Sign In button pressed");
                  Get.to(() => const ChatScreen());
                },
                child: const Text(TTexts.signIn),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwItems),
            // create account button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                child: const Text(TTexts.createAccount),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
