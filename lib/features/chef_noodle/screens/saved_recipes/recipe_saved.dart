import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:chef_noodle/features/chef_noodle/screens/generate_recipe/widgets/custom_loader.dart';
import 'package:chef_noodle/utils/constants/colors.dart';
import 'package:chef_noodle/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SavedRecipePage extends StatefulWidget {
  final String recipeId;

  SavedRecipePage({required this.recipeId});

  @override
  _SavedRecipePageState createState() => _SavedRecipePageState();
}

class _SavedRecipePageState extends State<SavedRecipePage> {
  bool isBookmarked = true;
  bool _isLoading = true;
  String _dietType = '';
  String allergens = '';
  String servings = '';
  String nutritionInformation = '';
  Map<String, dynamic>? _recipeData;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _fetchRecipeData();
  }

//   Future<String?> getImageUrl(String userId, String recipeId) async {
//   try {
//     final imagesRef = FirebaseStorage.instance.ref('images/$userId/$recipeId');
//     final result = await imagesRef.listAll();

//     if (result.items.isNotEmpty) {
//       // You can choose to return the first image URL or apply your own logic
//       final firstImageRef = result.items.first;
//       return await firstImageRef.getDownloadURL(); // Get the URL
//     } else {
//       print('No images found for this recipe.');
//       return null; // No images found
//     }
//   } catch (e) {
//     print('Error fetching images: $e');
//     return null; // Return null in case of an error
//   }
// }

  Future<void> _fetchRecipeData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User not logged in');
      return;
    }

    final userId = user.uid;
    final recipeId = widget.recipeId;
    final recipesCollection =
        FirebaseFirestore.instance.collection('savedRecipes');

    try {
      final recipeDoc = await recipesCollection.doc('$userId-$recipeId').get();

      if (recipeDoc.exists) {
        setState(() {
          _recipeData = recipeDoc.data() as Map<String, dynamic>?;
          imageUrl = _recipeData?['imageUrl'];
          _dietType =
              _recipeData?['diet'] ?? ''; // Fetching the stored image URL
          _isLoading = false;
        });

        print('Recipe Data: $_recipeData');
        print("Image URL: $imageUrl");
      } else {
        print('Recipe not found for recipeId: $recipeId');
      }
    } catch (e) {
      print('Error fetching recipe data: $e');
    }
  }

  Future<void> _toggleBookmark() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return; // Ensure user is logged in

    final userId = user.uid;
    final recipeId = widget.recipeId; // Use the passed recipeId
    final recipesCollection =
        FirebaseFirestore.instance.collection('savedRecipes');

    if (isBookmarked) {
      // Remove from Firestore and delete image from Firebase Storage
      try {
        final docSnapshot =
            await recipesCollection.doc('$userId-$recipeId').get();
        if (docSnapshot.exists) {
          final recipeData = docSnapshot.data() as Map<String, dynamic>?;
          final imageUrl = recipeData?['imageUrl'];

          if (imageUrl != null && imageUrl.isNotEmpty) {
            // Remove the image from Firebase Storage
            await FirebaseStorage.instance.refFromURL(imageUrl).delete();
            print('Image deleted from storage: $imageUrl');
          }

          await recipesCollection.doc('$userId-$recipeId').delete();
          print('Recipe removed from Firestore');
        }

        Fluttertoast.showToast(
          msg: "Removed from saved recipes",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: TColors.primary,
          textColor: TColors.secondary,
          fontSize: 14.0,
        );
      } catch (e) {
        print('Error removing recipe or image: $e');
      }
    } else {
      // Save to Firestore with the existing image URL
      try {
        // Prepare recipe data with the image URL
        final recipeDataWithImage = {
          ...?_recipeData, // Use null-aware operator to avoid null exception
          'imageUrl': imageUrl ?? '', // Store the existing image URL
        };

        await recipesCollection
            .doc('$userId-$recipeId')
            .set(recipeDataWithImage);
        print('Recipe saved in Firestore: $recipeDataWithImage');

        Fluttertoast.showToast(
          msg: "Recipe has been saved",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: TColors.primary,
          textColor: TColors.secondary,
          fontSize: 14.0,
        );
      } catch (e) {
        print('Error saving recipe: $e');
      }
    }

    setState(() {
      isBookmarked = !isBookmarked; // Toggle bookmark state
    });
  }

  Future<String?> uploadImage(
      File imageFile, String userId, String recipeId) async {
    try {
      // Create a reference to Firebase Storage
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('images/$userId/$recipeId/${imageFile.path.split('/').last}');

      // Upload the file
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL of the uploaded image
      final downloadUrl = await snapshot.ref.getDownloadURL();
      print('Image uploaded to storage: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null; // In case of an error
    }
  }

  void _showStoryPopup(String story) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    padding: const EdgeInsets.all(18.0),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        const Text(
                          'Chef Noodle says...',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          story,
                          style: const TextStyle(color: Colors.black),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 15,
                right: 15,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showHint(String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: MediaQuery.of(context).viewInsets.bottom + 50,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFuntions.isDarkMode(context);

    return Scaffold(
      backgroundColor: Colors.lightGreen,
      appBar: AppBar(
        backgroundColor:
            dark ? const Color.fromARGB(255, 47, 70, 21) : TColors.secondary,
        title: Text(
          _recipeData != null
              ? _recipeData!['title'] ?? 'Something Special!'
              : 'Working on it...',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: "Nunito",
            color: dark ? Colors.white : Colors.black,
          ),
        ),
        iconTheme: IconThemeData(color: dark ? Colors.white : Colors.black),
        actions: [
          if (_dietType.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap: () {
                  _showHint(_dietType == 'Vegetarian'
                      ? 'This recipe is 100% Vegetarian'
                      : 'This recipe contains Non-Vegetarian items');
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: TColors.secondary, // Background color of the circle
                  ),
                  padding:
                      const EdgeInsets.all(2.0), // Padding inside the circle
                  child: Image.asset(
                    _dietType == 'Vegetarian'
                        ? 'assets/icons/veg_icon.png'
                        : 'assets/icons/non_veg_icon.png',
                    width: 30,
                    height: 30,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          _isLoading
              ? CustomLoader()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      if (imageUrl !=
                          null) // Use imageUrl instead of imageFiles
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  imageUrl!), // Use NetworkImage here
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.6),
                                BlendMode.darken,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Servings: ${_recipeData?['servings'] ?? 'N/A'}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: TColors.secondary,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              if (_recipeData?['story'] !=
                                                  null) {
                                                _showStoryPopup(
                                                    _recipeData!['story']);
                                              }
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                              decoration: const BoxDecoration(
                                                color: Colors.orange,
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(14),
                                                  bottomRight:
                                                      Radius.circular(14),
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/logos/chef_noodle_logo.png',
                                                    width: 40,
                                                    height: 40,
                                                  ),
                                                  const SizedBox(width: 6),
                                                  const Text(
                                                    'Chef Noodle\nsays...',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'Potential Allergens: ${_recipeData?['allergens'] ?? 'None'}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: TColors.secondary,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      if (_recipeData?[
                                              'nutritionInformation'] !=
                                          null)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Nutritional Information per serving:',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: TColors.secondary,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            for (var entry in _recipeData![
                                                    'nutritionInformation']
                                                .entries)
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4),
                                                child: Text(
                                                  '○ ${entry.key}: ${entry.value}',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: TColors.secondary,
                                                  ),
                                                ),
                                              ),
                                            const SizedBox(height: 16),
                                          ],
                                        )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      // The rest of your code...

                      Container(
                        color: dark
                            ? const Color.fromARGB(255, 47, 70, 21)
                            : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              Text(
                                'Ingredients:',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: dark ? Colors.white : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              for (var ingredient
                                  in _recipeData?['ingredients'] ?? [])
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                    '○ $ingredient',
                                    style: TextStyle(
                                        color:
                                            dark ? Colors.white : Colors.black),
                                  ),
                                ),
                              const SizedBox(height: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Instructions:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: dark ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  for (var i = 0;
                                      i <
                                          (_recipeData?['instructions']
                                                  ?.length ??
                                              0);
                                      i++)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: Text(
                                        '${i + 1}. ${_recipeData!['instructions'][i]}',
                                        style: TextStyle(
                                            color: dark
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                    ),
                                  const SizedBox(height: 64),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          Positioned(
            bottom: 16,
            right: 16,
            child: GestureDetector(
              onTap: _toggleBookmark,
              child: CircleAvatar(
                backgroundColor: Colors.orange,
                radius: 25,
                child: FaIcon(
                  isBookmarked
                      ? FontAwesomeIcons.solidBookmark
                      : FontAwesomeIcons.bookmark,
                  color: Colors.black,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
