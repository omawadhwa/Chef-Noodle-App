import 'package:chef_noodle/features/chef_noodle/screens/saved_recipes/recipe_saved.dart';
import 'package:chef_noodle/utils/constants/colors.dart';
import 'package:chef_noodle/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SavedRecipesPage extends StatelessWidget {
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
  automaticallyImplyLeading: true, // Keep the back arrow
  backgroundColor: TColors.primary, // Replace with your desired color
  toolbarHeight: 80,
  title: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Expanded(
        child: Text(
          "My Saved Recipes",
          style: const TextStyle(
            fontFamily: "Nunito",
            color: Colors.white,
            fontSize: 20, // Adjust size as needed
            fontWeight: FontWeight.bold, // Customize font weight as needed
          ),
        ),
      ),
    ],
  ),
),

      body: Container(color: dark ? const Color.fromARGB(255, 47, 70, 21) : Colors.white, child: Column(
        children: [
          Expanded(child: SavedRecipesList()),
        ],
      )),
    );
  }
}

class SavedRecipesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(
        child: Text("Please log in to view saved recipes."),
      );
    }

    final userId = user.uid;
    final recipesCollection =
        FirebaseFirestore.instance.collection('savedRecipes');

    return StreamBuilder<QuerySnapshot>(
      stream: recipesCollection
          .where(FieldPath.documentId,
              isGreaterThanOrEqualTo: '$userId-',
              isLessThanOrEqualTo: '$userId-\uf8ff')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text("Error loading saved recipes."),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text("No saved recipes found."),
          );
        }

        final savedRecipes = snapshot.data!.docs;
        final Set<String> uniqueTitles = {};

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: savedRecipes.length,
          itemBuilder: (context, index) {
            final recipeData =
                savedRecipes[index].data() as Map<String, dynamic>;
            final title = recipeData['title'] ?? 'No Title';
            final id = recipeData['id'] ?? 'No id';

            if (uniqueTitles.contains(title)) {
              return const SizedBox.shrink();
            } else {
              uniqueTitles.add(title);

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SavedRecipePage(recipeId: id),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: TColors.secondary,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.black, width: 0.7),
                  ),
                  child: Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.solidBookmark,
                        color: Colors.black,
                        size: 20,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: "Nunito",
                          ),
                          maxLines: 2, // Limit to two lines
                          overflow: TextOverflow.ellipsis, // Add ellipsis if overflow
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}


