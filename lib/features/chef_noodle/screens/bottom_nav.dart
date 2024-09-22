import 'package:chef_noodle/features/chef_noodle/screens/account/user_profile.dart';
import 'package:chef_noodle/utils/constants/colors.dart';
import 'package:chef_noodle/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:chef_noodle/features/chef_noodle/screens/generate_recipe/generate_recipe.dart';

class FoodPage extends StatefulWidget {
  final String userEmail;
  final String userName;

  FoodPage({required this.userEmail, required this.userName});

  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  int _selectedIndex = Get.arguments ?? 0; // Default to 0 if no argument passed

  // Keeping the pages in a list
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      GenerateRecipePage(),
      UserProfilePage(userEmail: widget.userEmail, userName: widget.userName,), // Pass the userEmail parameter
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex, // Index of the currently selected page
        children: _pages, // Pages are stored and kept alive
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.wandMagicSparkles,
              color: _selectedIndex == 0 ? Colors.yellow : Colors.white,
              size: _selectedIndex == 0 ? 24 : 21,
            ),
            label: 'Create Recipe',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.user,
              color: _selectedIndex == 1 ? Colors.yellow : Colors.white,
              size: _selectedIndex == 1 ? 24 : 21,
            ),
            label: 'My Account',
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: TColors.success,
        selectedItemColor: Colors.yellow, // Highlighted color
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped, // Update selected page when tapped
      ),
    );
  }
}
