import 'package:flutter/material.dart';
import 'package:chef_noodle/utils/constants/sizes.dart';

class TSpacingStyle{
  static const EdgeInsetsGeometry paddingWithAppBarHeight = EdgeInsets.only(
                top: TSizes.appBarHeight,
                left: TSizes.defaultSpace,
                right: TSizes.defaultSpace,
                bottom: TSizes.defaultSpace
          );
}