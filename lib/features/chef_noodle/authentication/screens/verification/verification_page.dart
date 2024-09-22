import 'package:chef_noodle/features/chef_noodle/authentication/screens/login/login_page.dart';
import 'package:chef_noodle/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class VerificationPage extends StatelessWidget {
  final String email;

  VerificationPage({required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Email Verification',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'A verification email has been sent to $email. Please verify to continue.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () =>
                    Get.to(() => LoginPage()), // Navigate to LoginPage on tap
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: TColors.secondary, // Replace with your desired color
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.black, width: 0.7),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(
                        FontAwesomeIcons
                            .arrowRight, // Icon indicating navigation or "go to"
                        color: Colors.black,
                        size: 14,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Go to Login',
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
        ),
      ),
    );
  }
}
