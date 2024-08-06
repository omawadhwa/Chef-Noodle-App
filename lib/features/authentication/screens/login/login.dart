import 'package:chef_noodle/utils/constants/colors.dart';
import 'package:chef_noodle/utils/constants/image_strings.dart';
import 'package:chef_noodle/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chef_noodle/common/styles/spacing_styles.dart';
import 'package:chef_noodle/common/widgets/login_signup/form_divider.dart';
import 'package:chef_noodle/common/widgets/login_signup/social_buttons.dart';
import 'package:chef_noodle/features/authentication/screens/login/widgets/login_form.dart';
import 'package:chef_noodle/features/authentication/screens/login/widgets/login_header.dart';
import 'package:chef_noodle/utils/constants/sizes.dart';
import 'package:chef_noodle/utils/constants/text_strings.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final dark = THelperFuntions.isDarkMode(context);

    return Scaffold(
      backgroundColor: dark ? TColors.dark_bg : TColors.white,
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(TImages.bg_vector), fit: BoxFit.cover)),
        child: const SingleChildScrollView(
          child: Padding(
            padding: TSpacingStyle.paddingWithAppBarHeight,
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                //logo, title & sub title
                TLoginHeader(),

                //Form
                TLoginForm(),

                //Divider
                // TFormDivider(dividerText: TTexts.orSignInWith.capitalize!),
                // const SizedBox(height: TSizes.spaceBtwSections),

                // //Footer
                // const TSocialButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
