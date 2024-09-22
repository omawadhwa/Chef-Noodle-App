import 'dart:async';
import 'package:chef_noodle/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomLoader extends StatefulWidget {
  @override
  _CustomLoaderState createState() => _CustomLoaderState();
}

class _CustomLoaderState extends State<CustomLoader> {
  final List<IconData> _icons = [
    FontAwesomeIcons.pizzaSlice,
    FontAwesomeIcons.drumstickBite,
    FontAwesomeIcons.carrot,
    FontAwesomeIcons.egg,
    FontAwesomeIcons.martiniGlassCitrus,
  ];

  final List<Color> _colors = [
    Color.fromARGB(255, 255, 196, 0),      // Pizza
    Colors.red,         // Chicken
    Colors.orange,      // Carrot
    Colors.blue,        // Egg
    Colors.purple,      // Whiskey
  ];

  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _icons.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(

      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: TColors.secondary,
          border: Border.all(
            color: _colors[_currentIndex], // Border color changes with icon
            width: 5,
          ),
        ),
        child: Center(
          child: FaIcon(
            _icons[_currentIndex],
            size: 40,
            color: _colors[_currentIndex], // Icon color changes accordingly
          ),
        ),
      ),
    );
  }
}
