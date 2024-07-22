import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:arya/common/styles/spacing_styles.dart';
import 'package:arya/common/widgets/login_signup/form_divider.dart';
import 'package:arya/common/widgets/login_signup/social_buttons.dart';
import 'package:arya/features/authentication/screens/login/widgets/login_form.dart';
import 'package:arya/features/authentication/screens/login/widgets/login_header.dart';
import 'package:arya/utils/constants/sizes.dart';
import 'package:arya/utils/constants/text_strings.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              //logo, title & sub title
              const TLoginHeader(),

              //Form
              const TLoginForm(),

              //Divider
              TFormDivider(dividerText: TTexts.orSignInWith.capitalize!),
              const SizedBox(height: TSizes.spaceBtwSections),

              //Footer
              const TSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
