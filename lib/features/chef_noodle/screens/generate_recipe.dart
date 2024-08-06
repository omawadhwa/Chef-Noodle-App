import 'package:chef_noodle/utils/constants/colors.dart';
import 'package:chef_noodle/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class GenerateRecipePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: TColors.primary,
        toolbarHeight: 80,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
          
            Image.asset('assets/logos/chef_noodle_logo.png', width: 60,height: 60,),
            SizedBox(width: TSizes.spaceBtwItems,),
            Text('Meowdy! Let\'s get cooking', style: TextStyle(fontFamily: "Nunito"),),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                color: TColors.primary
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 40, top: 60, bottom: 60,),
                child: Text(
                  'Tell me what ingredients you have and what you are feelin, and I\'ll create a recipe for you',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
            SizedBox(height: 32),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Recipe',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                    
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: TColors.black, width: 1.0,),
                        borderRadius: BorderRadius.circular(7)
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'I have these ingredients :',
                            style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 150, 148, 145)),
                          ),
                          SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              color: TColors.secondary,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Icon(Icons.image, size: 40,),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InputForm extends StatelessWidget {
  final String title;
  final IconData icon;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const InputForm({
    required this.title,
    required this.icon,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.black, width: 1.0),
          borderRadius: BorderRadius.circular(7),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: const Color.fromARGB(255, 150, 148, 145),
              ),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Icon(icon, size: 40),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: onButtonPressed,
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}