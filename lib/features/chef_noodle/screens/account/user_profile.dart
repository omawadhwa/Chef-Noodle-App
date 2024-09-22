import 'package:chef_noodle/features/chef_noodle/authentication/screens/login/login_page.dart';
import 'package:chef_noodle/features/chef_noodle/authentication/screens/signup/signup_page.dart';
import 'package:chef_noodle/features/chef_noodle/screens/saved_recipes/saved_recipes.dart';
import 'package:chef_noodle/utils/constants/colors.dart';
import 'package:chef_noodle/utils/constants/sizes.dart';
import 'package:chef_noodle/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfilePage extends StatelessWidget {
  final FocusNode _focusNode = FocusNode();
  final String userEmail;
  final String userName;

  UserProfilePage({required this.userEmail, required this.userName});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _handleLogoutDialog() async {

  Get.defaultDialog(
    backgroundColor: TColors.secondary,
    titlePadding: const EdgeInsets.only(top: 30, left: 16, right: 16, bottom: 20),
    title: 'Are you sure you want to logout?',
    titleStyle: const TextStyle(
      fontSize: 16, 
      color: Colors.black // Set the title font size to 16 and color to black
    ),
    radius: 20, // Set a border radius for the dialog
    content: Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0), 
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  _focusNode.unfocus();
                  Get.back(); // Close the dialog
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: TColors.secondary, // Replace with your desired color
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.black, width: 0.7),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.xmark, // Use 'times' icon for cancel
                        color: Colors.black,
                        size: 14,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'No', // Update the button text here
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: "Nunito",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () async {
                  await _handleLogout(); // Handle the logout logic
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: TColors.secondary, // Replace with your desired color
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.black, width: 0.7),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.check, // Use 'check' icon for confirmation
                        color: Colors.black,
                        size: 14,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Yes', // Update the button text here
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: "Nunito",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Future<void> _handleLogout() async {
  try {
    await _auth.signOut();
    Get.offAll(() => LoginPage()); // Navigate to the login page
  } catch (e) {
    // Handle sign out error
    Get.snackbar('Error', 'Failed to sign out');
  }
}


  Future<void> _handleRemoveAccount() async {
    TextEditingController passwordController = TextEditingController();

    Get.defaultDialog(
      backgroundColor: TColors.secondary,
      titlePadding:
          const EdgeInsets.only(top: 30, left: 16, right: 16, bottom: 20),
      titleStyle: const TextStyle(
          fontSize: 16,
          color:
              Colors.black // Set the title font size to 16 and color to black
          ),
      radius: 20, // Set a border radius for the dialog
      title: 'Are you sure you want to delete your account permanently?',
      content: Padding(
        padding: const EdgeInsets.only(
            left: 16.0, right: 16.0, bottom: 16.0), // Add padding for spacing
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    _focusNode.unfocus();
                    Get.back(); // Close the dialog
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color:
                          TColors.secondary, // Replace with your desired color
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black, width: 0.7),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.xmark, // Use 'times' icon for cancel
                          color: Colors.black,
                          size: 14,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'No', // Update the button text here
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: "Nunito",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () async {
                    Get.back(); // Close the confirmation dialog

                    // Trigger the second dialog
                    Get.defaultDialog(
                      backgroundColor: TColors.secondary,
                      titlePadding: const EdgeInsets.only(
                          top: 30, left: 16, right: 16, bottom: 20),
                      title:
                          'We need to verify whether it\'s you in order to remove your account!',
                      titleStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.black // Set the title font size to 16
                          ),
                      content: Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, bottom: 30.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              focusNode: _focusNode,
                              controller: passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                
                                labelText: 'Enter your password',
                                labelStyle: TextStyle(
                                  color: Colors
                                      .black, // Use dull black color for label
                                ),
                              ),
                              onSubmitted: (value) async {
                                if (await _verifyPassword(value)) {
                                  await _deleteAccount();
                                  Get.back(); // Close the verification dialog
                                  Get.snackbar('Success',
                                      'Your account has been deleted');
                                  Get.offAll(() =>
                                      LoginPage()); // Navigate to the login page
                                } else {
                                  Get.snackbar('Error', 'Incorrect password');
                                }
                              },
                            ),
                            const SizedBox(
                                height:
                                    20), // Add spacing between TextField and buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _focusNode.unfocus();
                                    Get.back(); // Close the dialog
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: TColors
                                          .secondary, // Replace with your desired color
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: Colors.black, width: 0.7),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons
                                              .xmark, // Icon for cancel
                                          color: Colors.black,
                                          size: 14,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Cancel', // Update button text here
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontFamily: "Nunito",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                GestureDetector(
                                  onTap: () async {
                                    String password = passwordController.text;
                                    if (await _verifyPassword(password)) {
                                      await _deleteAccount();
                                      Get.back(); // Close the verification dialog
                                      Get.snackbar('Success',
                                          'Your account has been deleted');
                                      Get.offAll(() =>
                                          SignUpPage()); // Navigate to the sign-up page
                                    } else {
                                      Get.snackbar(
                                          'Error', 'Incorrect password');
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: TColors
                                          .secondary, // Replace with your desired color
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: Colors.black, width: 0.7),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons
                                              .trashCan, // Icon for account removal
                                          color: Colors.black,
                                          size: 14,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Remove Account', // Update button text here
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontFamily: "Nunito",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      radius: 20, // Set a border radius for the dialog
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color:
                          TColors.secondary, // Replace with your desired color
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black, width: 0.7),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(
                          FontAwesomeIcons
                              .check, // Use 'check' icon for confirmation
                          color: Colors.black,
                          size: 14,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Yes', // Update the button text here
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: "Nunito",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _verifyPassword(String password) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        return false;
      }

      AuthCredential credential = EmailAuthProvider.credential(
        email: userEmail, // Use the passed userEmail here
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _deleteAccount() async {
    try {
      User? user = _auth.currentUser;
      await user?.delete();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete account');
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFuntions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.elliptical(MediaQuery.of(context).size.width, 30.0),
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: TColors.primary, // Replace with your desired color
        toolbarHeight: 80,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName, // Display the user email
                  style: const TextStyle(
                    fontFamily: "Nunito",
                    color: Colors.white,
                    fontSize: 20, // Adjust size as needed
                    fontWeight:
                        FontWeight.bold, // Customize font weight as needed
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  userEmail, // Display the user email
                  style: const TextStyle(
                    fontFamily: "Nunito",
                    color: Colors.white,
                    fontSize: 12, // Adjust size as needed
                  ),
                ),
              ],
            )
            // Space between image and text
          ],
        ),
      ),
      body: Container(
        color: dark ? const Color.fromARGB(255, 47, 70, 21) : Colors.white, // Gray background color
        padding: const EdgeInsets.all(16.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                // Navigate to the desired page
                Get.to(() => SavedRecipesPage()); // Replace with actual page
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: TColors.secondary,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black, width: 0.7),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.solidBookmark, // Bookmark icon
                          color: Colors.black,
                          size: 20,
                        ),
                        SizedBox(width: 32),
                        Text(
                          'Saved Recipes',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: "Nunito",
                          ),
                        ),
                      ],
                    ),
                    FaIcon(
                      FontAwesomeIcons.arrowRight, // Arrow without tail
                      color: Colors.black,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                _handleLogoutDialog();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: TColors.secondary,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black, width: 0.7),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.rightFromBracket, // Logout icon
                          color: Colors.black,
                          size: 20,
                        ),
                        SizedBox(width: 32),
                        Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: "Nunito",
                          ),
                        ),
                      ],
                    ),
                    FaIcon(
                      FontAwesomeIcons.arrowRight, // Arrow without tail
                      color: Colors.black,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                _handleRemoveAccount();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: TColors.secondary,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black, width: 0.7),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons
                              .trashCan, // Trash icon for remove account
                          color: Colors.black,
                          size: 20,
                        ),
                        SizedBox(width: 32),
                        Text(
                          'Remove Account',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: "Nunito",
                          ),
                        ),
                      ],
                    ),
                    FaIcon(
                      FontAwesomeIcons
                          .circleExclamation, // Alert icon for remove account
                      color: Colors.black,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 200),
             Center(
              child: Text(
                'App made by Om Wadhwa :)',
                style: TextStyle(
                  color: dark ? Colors.white :Colors.black,
                  fontSize: 14,
                  fontFamily: "Nunito",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
