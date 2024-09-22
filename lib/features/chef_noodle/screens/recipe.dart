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

class RecipePage extends StatefulWidget {
  final String cuisines;
  final String dietaryRestrictions;
  final String ingredients;
  final String preferences;
  final List<XFile> imageFiles;

  RecipePage({
    required this.cuisines,
    required this.dietaryRestrictions,
    required this.ingredients,
    required this.preferences,
    required this.imageFiles,
  });

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  bool isBookmarked = false;
  String _recipeText = '';
  bool _isLoading = true;
  Map<String, dynamic>? _recipeData;
  String _dietType = '';

  @override
  void initState() {
    super.initState();
    _getRecipe();
  }

  Future<void> _getRecipe() async {
    const apiKey = 'AIzaSyCoKAEzw1W3mLG2wyd-iJMyJvp68YGT8WY';
    final model = GenerativeModel(
      model: 'gemini-1.5-pro',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.9,
        topK: 64,
        topP: 0.95,
        maxOutputTokens: 8192,
        responseMimeType: 'text/plain',
      ),
    );

    String prompt = '''
    You are Cat who's a chef that travels around the world a lot, and your travels inspire recipes. Recommend a recipe for me based on the provided image/images only if provided.
    The recipe should only contain real, edible ingredients.
    Adhere to food safety and handling best practices like ensuring that poultry is fully cooked.

    I'm in the mood for the following types of cuisine: ${widget.cuisines}

    I have the following dietary restrictions: ${widget.dietaryRestrictions}

    Optionally also include the following ingredients: ${widget.ingredients}

    I also have these additional preferences: ${widget.preferences}

    After providing the recipe, explain creatively why the recipe is good based on only the ingredients used in the recipe. 
    Tell a short story of a travel experience that inspired the recipe.

    Provide a summary of how many people the recipe will serve and always give the nutritional information per serving too.
    List out any ingredients that are potential allergens.
    ''';

    const formatting =
        """Return the recipe in JSON using the following structure:
    {
      "diet": \$dietType,
      "title": \$recipeTitle,
      "ingredients": \$ingredients,
      "instructions": \$instructions,
      "id": \$uniqueId,
      "description": \$description,
      "cuisine": \$cuisineType,
      "allergens": \$allergens,
      "servings": \$servings,
      "story": \$story,
    }
    Don't miss out on anything!
    diet must be either Non-Vegetarian or Vegetarian and of type String.
    uniqueId should be unique and of type String.
    title, description, cuisine, allergens, servings and story should be of String type,
    ingredients and instructions should be of type List<String>.
    nutritionInformation should be of type Map<String, String> and must always be given I repeat! 

    If allergens is None then mention it as 'None as such'.
    Don't give the response starting with (```json) and ending with (```).""";

    List<Part> contentParts = [
      TextPart(prompt),
      TextPart(formatting),
    ];

    for (var imageFile in widget.imageFiles) {
      final imageBytes = await File(imageFile.path).readAsBytes();
      contentParts.add(DataPart('image/jpeg', imageBytes));
    }

    try {
      final chat = model.startChat(history: [
        Content.multi(contentParts),
      ]);

      final response = await chat.sendMessage(Content.text(''));

      print('Raw Response: ${response.text}');

      if (response.text != null) {
        try {
          _recipeData = jsonDecode(response.text!);
          print('Parsed Recipe Data: $_recipeData');
          _dietType = _recipeData?['diet'] ?? '';
        } catch (e) {
          print('Error parsing JSON: $e');
          _recipeData = null;
        }
      } else {
        _recipeData = null;
      }

      setState(() {
        _isLoading = false;
        _recipeText = _recipeData != null
            ? 'Recipe data loaded successfully.'
            : 'No recipe data available.';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _recipeText = 'Error: $e';
      });
    }
  }

  Future<void> _toggleBookmark() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return; // Ensure user is logged in

    final userId = user.uid;
    final recipeId = _recipeData?['id'];
    final recipesCollection =
        FirebaseFirestore.instance.collection('savedRecipes');

    if (isBookmarked) {
      // Remove from Firestore and delete image from Firebase Storage
      try {
        // Get the document snapshot before deletion
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

          // Now delete the Firestore document
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
      // Save to Firestore and upload the image to Firebase Storage
      try {
        String? imageUrl;
        if (widget.imageFiles.isNotEmpty) {
          final File imageFile = File(widget.imageFiles.first.path);
          imageUrl = await uploadImage(imageFile, userId, recipeId);
        }

        // Prepare recipe data with the image URL
        final recipeDataWithImage = {
          ..._recipeData!,
          'imageUrl': imageUrl ?? '', // Store the image URL if available
        };

        // Save the recipe data to Firestore
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
        print('Error saving recipe or uploading image: $e');
      }
    }

    setState(() {
      isBookmarked = !isBookmarked; // Toggle bookmark state
    });
  }

  Future<String?> uploadImage(
      File imageFile, String userId, String recipeId) async {
    try {
      String fileName =
          'image_$recipeId${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('images/$userId/$recipeId/$fileName');

      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      final downloadUrl = await snapshot.ref.getDownloadURL();
      print('Image uploaded to storage: $downloadUrl');

      // Store the download URL in Firestore
      await FirebaseFirestore.instance
          .collection('savedRecipes')
          .doc('$userId-$recipeId')
          .set(
              {
            'imageUrl': downloadUrl,
            'diet': _dietType,
          },
              SetOptions(
                  merge: true)); // Use merge to avoid overwriting existing data

      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
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
                      if (widget.imageFiles.isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                                  FileImage(File(widget.imageFiles.first.path)),
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
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
            child: _isLoading
                ? SizedBox.shrink() // Hide the bookmark icon when loading
                : GestureDetector(
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
