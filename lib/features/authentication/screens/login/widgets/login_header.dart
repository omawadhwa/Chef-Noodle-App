import 'package:flutter/material.dart';
import 'package:arya/utils/constants/image_strings.dart';
import 'package:arya/utils/constants/sizes.dart';
import 'package:arya/utils/constants/text_strings.dart';
import 'package:arya/utils/helpers/helper_functions.dart';

class TLoginHeader extends StatelessWidget {
  const TLoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFuntions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Image(height: 200, image: AssetImage(TImages.piramalLogo)),
        Text(TTexts.loginTitle,
            style: Theme.of(context).textTheme.headlineMedium),
        // const SizedBox(height: TSizes.sm),
        // Text(TTexts.loginSubTitle,
        //     style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
