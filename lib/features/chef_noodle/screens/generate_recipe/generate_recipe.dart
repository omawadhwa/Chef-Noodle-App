import 'dart:async';
import 'dart:io';
import 'package:chef_noodle/features/chef_noodle/screens/generate_recipe/widgets/selection_box.dart';
import 'package:chef_noodle/features/chef_noodle/screens/recipe.dart';
import 'package:chef_noodle/utils/constants/colors.dart';
import 'package:chef_noodle/utils/constants/sizes.dart';
import 'package:chef_noodle/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class GenerateRecipePage extends StatefulWidget {
  @override
  _GenerateRecipePageState createState() => _GenerateRecipePageState();
}

class _GenerateRecipePageState extends State<GenerateRecipePage> {
  final FocusNode _focusNode = FocusNode();
  final ImagePicker _picker = ImagePicker();
  List<XFile> _imageFiles = [];
  Map<XFile, bool> _showDeleteIcon =
      {}; // Track which images should show delete icon
  Map<XFile, Timer?> _deleteIconTimers = {}; // Track timers for each image
  final TextEditingController _preferencesController = TextEditingController();
  final ValueNotifier<Set<String>> _stapleIngredientsNotifier =
      ValueNotifier({});
  final ValueNotifier<Set<String>> _moodNotifier = ValueNotifier({});
  final ValueNotifier<Set<String>> _dietaryRestrictionsNotifier =
      ValueNotifier({});

  // Method to reset all inputs
  void _resetPreferences() {
    setState(() {
      _imageFiles.clear();
      _showDeleteIcon.clear();
      _deleteIconTimers.forEach((key, timer) => timer?.cancel());
      _deleteIconTimers.clear();
      _preferencesController.clear();
      _stapleIngredientsNotifier.value.clear();
      _moodNotifier.value.clear();
      _dietaryRestrictionsNotifier.value.clear();
      // Reset other state variables if needed
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _imageFiles.add(image);
        _showDeleteIcon[image] = false;
        _deleteIconTimers[image] = null;
      });
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a picture'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_album),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _onImageTapped(XFile imageFile) {
    setState(() {
      _showDeleteIcon[imageFile] = true;
    });

    // Cancel any existing timer
    _deleteIconTimers[imageFile]?.cancel();

    // Start a new timer
    _deleteIconTimers[imageFile] = Timer(Duration(seconds: 3), () {
      setState(() {
        _showDeleteIcon[imageFile] = false;
      });
    });
  }

  void _deleteImage(XFile imageFile) {
    setState(() {
      _imageFiles.remove(imageFile);
      _showDeleteIcon.remove(imageFile);
      _deleteIconTimers[imageFile]?.cancel();
      _deleteIconTimers.remove(imageFile);
    });
  }

  void _showResetConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reset Preferences'),
          content: Text('Are you sure you want to reset your preferences?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'No',
                style: TextStyle(fontSize: 15),
              ),
            ),
            TextButton(
              onPressed: () {
                _resetPreferences();
                Navigator.of(context).pop(); // Close the dialog after resetting
              },
              child: Text(
                'Yes',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _stapleIngredientsNotifier.dispose();
    _moodNotifier.dispose();
    _dietaryRestrictionsNotifier.dispose();
    super.dispose();
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
        backgroundColor: TColors.primary,
        toolbarHeight: 80,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset('assets/logos/chef_noodle_logo.png',
                width: 60, height: 60),
            SizedBox(width: TSizes.spaceBtwItems),
            Text(
              'Meowdy! Let\'s get cooking',
              style: TextStyle(fontFamily: "Nunito", color: Colors.white),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 40,
                    top: 40,
                  ),
                  child: Text(
                    'Tell me what ingredients you have and what you are feelin, and I\'ll create a recipe for you ~',
                    style: TextStyle(fontSize: 18, color: dark ? Colors.white : Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Container(
                color: dark ? const Color.fromARGB(255, 47, 70, 21) : Colors.white,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create a Recipe',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: dark
                            ? Colors.white
                            : const Color.fromARGB(255, 150, 148, 145),
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: dark ? Color.fromARGB(75, 231, 231, 231) : const Color.fromARGB(76, 35, 35, 35),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'I have these ingredients :\nclick to upload image',
                              style: TextStyle(
                                fontSize: 18,
                                color: dark
                                    ? Colors.white
                                    : const Color.fromARGB(255, 150, 148, 145),
                              ),
                            ),
                            SizedBox(height: 16),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                ..._imageFiles.map((imageFile) {
                                  return GestureDetector(
                                    onTap: () => _onImageTapped(imageFile),
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: 96,
                                          height: 96,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                              image: FileImage(
                                                  File(imageFile.path)),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        if (_showDeleteIcon[imageFile] ?? false)
                                          Positioned(
                                            top: 30,
                                            right: 30,
                                            child: GestureDetector(
                                              onTap: () =>
                                                  _deleteImage(imageFile),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.red
                                                      .withOpacity(0.7),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: Colors.white,
                                                    size: 30,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                if (_imageFiles.isNotEmpty)
                                  GestureDetector(
                                    onTap: () =>
                                        _showImageSourceActionSheet(context),
                                    child: Container(
                                      width: 96,
                                      height: 96,
                                      decoration: BoxDecoration(
                                        color: TColors.secondary,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.add,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  GestureDetector(
                                    onTap: () =>
                                        _showImageSourceActionSheet(context),
                                    child: Container(
                                      width: 96,
                                      height: 96,
                                      decoration: BoxDecoration(
                                        color: TColors.secondary,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.image,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SelectionBox(
                      title: 'I also have these staple ingredients :',
                      options: [
                        'Oil',
                        'Butter',
                        'Flour',
                        'Salt',
                        'Pepper',
                        'Sugar',
                        'Milk',
                        'Vinegar'
                      ],
                      selectedOptionsNotifier: _stapleIngredientsNotifier,
                    ),
                    const SizedBox(height: 15),
                    SelectionBox(
                      title: 'I\'m in the mood for :',
                      options: [
                        'Italian',
                        'Mexican',
                        'French',
                        'Indian',
                        'Chinese',
                        'Japanese',
                        'Turkish',
                        'Moroccan',
                        'American'
                      ],
                      selectedOptionsNotifier: _moodNotifier,
                    ),
                    const SizedBox(height: 15),
                    SelectionBox(
                      title: 'I have the following dietary restrictions :',
                      options: [
                        'Vegetarian',
                        'Less Spicy',
                        'Low Carb',
                        'No Sugar',
                        'Vegan',
                        'Less Salt'
                      ],
                      selectedOptionsNotifier: _dietaryRestrictionsNotifier,
                    ),
                    const SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(
                        color: TColors.secondary,
                        border: Border.all(
                          color: const Color.fromARGB(76, 35, 35, 35),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: TextField(
                        focusNode: _focusNode,
                        style: TextStyle(color: Colors.black),
                        controller: _preferencesController,
                        maxLines: 5,
                        decoration: InputDecoration(
                            border: InputBorder
                                .none, // Removes the border when not focused
                            enabledBorder: InputBorder
                                .none, // Removes the border when not focused
                            focusedBorder: InputBorder.none,
                            hintText: 'Add any additional preferences here...',
                            hintStyle: TextStyle(color: Colors.black)),
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Reset Button
                        GestureDetector(
                          onTap: _showResetConfirmationDialog,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border:
                                  Border.all(color: Colors.black, width: 0.7),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.arrowsRotate,
                                  color: Colors.black,
                                  size: 14,
                                ),
                                SizedBox(width: 8),
                                Text('Reset My Preferences',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontFamily: "Nunito")),
                              ],
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            // Collect the selected options
                            final selectedCuisines =
                                _moodNotifier.value.join(', ');
                            final selectedDietaryRestrictions =
                                _dietaryRestrictionsNotifier.value.join(', ');
                            final selectedIngredients =
                                _stapleIngredientsNotifier.value.join(', ');
                            final additionalPreferences = _preferencesController.text;


                            // Navigate to the RecipePage with the collected data
                            Get.to(() => RecipePage(
                                  cuisines: selectedCuisines,
                                  dietaryRestrictions: selectedDietaryRestrictions,
                                  ingredients: selectedIngredients,
                                  preferences: additionalPreferences,
                                  imageFiles: _imageFiles,
                                ));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: TColors.secondary,
                              borderRadius: BorderRadius.circular(15),
                              border:
                                  Border.all(color: Colors.black, width: 0.7),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FaIcon(FontAwesomeIcons.wandMagicSparkles,
                                    color: Colors.black, size: 14),
                                SizedBox(width: 8),
                                Text('Create Recipe',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontFamily: "Nunito")),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
