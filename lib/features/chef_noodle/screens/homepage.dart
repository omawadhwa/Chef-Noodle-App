import "package:chef_noodle/features/chef_noodle/screens/generate_dish.dart";
import "package:chef_noodle/features/chef_noodle/screens/generate_recipe.dart";
import "package:flutter/material.dart";
import "package:flutter_html/flutter_html.dart";
import "package:get/get.dart";
import "package:get/get_core/src/get_main.dart";

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showCustomDialog(context);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Chef Noodle'),
      ),
      body: Center(
        child: Text('Welcome to Chef Noodle!'),
      ),
    );
  }

  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents closing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/logos/chef_noodle_logo.png', width: 150, height: 150),
              SizedBox(height: 16),
              Text(
                "Hello, food lover! I'm Chef Noodle.",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Here to help you create dishes that are out of this world.',
                style: TextStyle(
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Get.to(() => GenerateRecipePage());
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Create a Recipe', style: TextStyle(fontSize: 14, fontFamily: "Nunito")),
                ),
              ),
              SizedBox(height: 8),
              Text('or', style: TextStyle(fontWeight: FontWeight.w400)),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Get.to(() => GenerateDishPage());
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Help me Make this Dish', style: TextStyle(fontSize: 14, fontFamily: "Nunito")),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
