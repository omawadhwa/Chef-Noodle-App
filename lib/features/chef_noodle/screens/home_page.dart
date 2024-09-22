import 'package:chef_noodle/features/chef_noodle/screens/bottom_nav.dart';
import 'package:chef_noodle/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final String userEmail;
  final String userName;

  HomePage({required this.userEmail, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Chef Noodle',
          style: TextStyle(
              fontFamily: "Nunito", fontSize: 25, color: Colors.white),
        ),
        centerTitle: true,
        toolbarHeight: 80,
        backgroundColor: Color.fromARGB(255, 18, 80, 22),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(color: TColors.success),
          child: Column(
            children: [
              SizedBox(height: 50),
              Image.asset('assets/logos/chef_noodle_logo.png',
                  width: 150, height: 150),
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  "Welcome $userName!\nI'm Chef Noodle.",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Nunito",
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  'Here to help you create dishes that are out of this world.\nLet me know what\'s on your mind today!',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Nunito",
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 60),
              GestureDetector(
                onTap: () {
                  Get.to(() => FoodPage(userEmail: userEmail, userName: userName,), arguments: 0); // Pass 0 to show "Create Recipe"
                },
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: TColors.secondary,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(FontAwesomeIcons.wandMagicSparkles,
                          color: Colors.black, size: 18),
                      SizedBox(width: 8),
                      Text('Create a Recipe',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: "Nunito")),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50),
              Text('App made by Om Wadhwa :)',
                  style: TextStyle(
                      fontWeight: FontWeight.w400, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
