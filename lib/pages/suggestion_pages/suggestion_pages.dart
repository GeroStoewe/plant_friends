import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_friends/widgets/custom_button.dart';
import 'package:plant_friends/widgets/custom_snackbar.dart';


class SuggestionsPage extends StatefulWidget {
  const SuggestionsPage({super.key});

  @override
  _SuggestionsPageState createState() => _SuggestionsPageState();
}

class _SuggestionsPageState extends State<SuggestionsPage> {
  final DatabaseReference dbRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
    'https://plant-friends-app-default-rtdb.europe-west1.firebasedatabase.app/',
  ).ref();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _featureController = TextEditingController();
  final TextEditingController _improvementController = TextEditingController();
  final TextEditingController _plantCareController = TextEditingController();
  final TextEditingController _technicalController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid; // Get current user ID
  }

  // Save suggestions to Firebase
  void _saveSuggestions() {
    // Check if all fields are empty
    if (_featureController.text.isEmpty &&
        _improvementController.text.isEmpty &&
        _plantCareController.text.isEmpty &&
        _technicalController.text.isEmpty &&
        _commentsController.text.isEmpty) {
      // Show SnackBar warning
      CustomSnackbar snackbar = CustomSnackbar(context);
      snackbar.showMessage(
          ('Empty forms are not allowed. Please provide feedback.'),
          MessageType.error);
      return; // Exit the function early
    }

    // Proceed with saving if the form is valid and user ID is available
    if (_formKey.currentState!.validate() && userId != null) {
      final suggestionsRef = dbRef.child("Suggestions").child(userId!).push();

      suggestionsRef.set({
        "featureSuggestion": _featureController.text,
        "improvementSuggestion": _improvementController.text,
        "plantCareSuggestion": _plantCareController.text,
        "technicalSuggestion": _technicalController.text,
        "additionalComments": _commentsController.text,
        "timestamp": ServerValue.timestamp,
      }).then((_) {
        CustomSnackbar snackbar = CustomSnackbar(context);
        snackbar.showMessage(
            ('Thank you for sharing your feedback!'),
            MessageType.success);
        _clearForm();
        Navigator.pop(context);
      }).catchError((error) {
        CustomSnackbar snackbar = CustomSnackbar(context);
        snackbar.showMessage(
            'Failed to save suggestions $error', MessageType.error);
      });
    }
  }

  // Clear form fields
  void _clearForm() {
    _featureController.clear();
    _improvementController.clear();
    _plantCareController.clear();
    _technicalController.clear();
    _commentsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.suggestions,
          style: Theme
              .of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade700, Colors.green.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 10,
      ),
      body: Container(
        decoration: BoxDecoration(
          //color: Theme.of(context).scaffoldBackgroundColor,
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Colors.black, Colors.grey.shade900]
                : [Colors.teal.shade50, Colors.green.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  // Feature Suggestions
                  Text(
                  localizations.featureSuggestions,
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode
                        ? Colors.green
                        : Colors.teal.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                TextSelectionTheme(
                  data: const TextSelectionThemeData(
                      selectionHandleColor: Colors.grey,
                      selectionColor: Colors.blueGrey), // Text selection color
                  child: TextFormField(
                    controller: _featureController,
                    cursorColor: isDarkMode
                        ? Colors.green
                        : Colors.teal.shade800,
                    decoration: InputDecoration(
                      hintText: localizations.featureSuggestionsHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Colors.black), // Default border color
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Colors.green), // Border color when focused
                      ),
                      focusColor:
                      Colors.green, // Cursor and selection handle color
                    ),
                    maxLines: 3,
                  ),
                ),
                const SizedBox(height: 16),

                // Improvement Suggestions
                Text(
                  localizations.improvementSuggestions,
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode
                        ? Colors.green
                        : Colors.teal.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                TextSelectionTheme(
                  data: const TextSelectionThemeData(
                      selectionHandleColor: Colors.grey,
                      selectionColor: Colors.blueGrey),
                  // Text selection color
                  child: TextFormField(
                    controller: _improvementController,
                    cursorColor: isDarkMode
                        ? Colors.green
                        : Colors.teal.shade800,
                    decoration: InputDecoration(
                      hintText: localizations.improvementSuggestionsHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Colors.black), // Default border color
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Colors.green), // Border color when focused
                      ),
                      focusColor:
                      Colors.green, // Cursor and selection handle color
                    ),
                    maxLines: 3,
                  ),
                ),
                const SizedBox(height: 16),

                // Plant Care Suggestions
                Text(
                  localizations.plantCareSuggestions,
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode
                        ? Colors.green
                        : Colors.teal.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                TextSelectionTheme(
                  data: const TextSelectionThemeData(
                      selectionHandleColor: Colors.grey,
                      selectionColor: Colors.blueGrey),
                  // Text selection color
                  child: TextFormField(
                    controller: _plantCareController,
                    cursorColor: isDarkMode
                        ? Colors.green
                        : Colors.teal.shade800,
                    decoration: InputDecoration(
                      hintText: localizations.plantCareSuggestionsHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Colors.black), // Default border color
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Colors.green), // Border color when focused
                      ),
                      focusColor:
                      Colors.green, // Cursor and selection handle color
                    ),
                    maxLines: 3,
                  ),
                ),
                const SizedBox(height: 16),

                // Technical Feedback
                Text(
                  localizations.technicalFeedback,
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode
                        ? Colors.green
                        : Colors.teal.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                TextSelectionTheme(
                  data: const TextSelectionThemeData(
                      selectionHandleColor: Colors.grey,
                      selectionColor: Colors.blueGrey),
                  // Text selection color
                  child: TextFormField(
                    controller: _technicalController,
                    cursorColor: isDarkMode
                        ? Colors.green
                        : Colors.teal.shade800,
                    decoration: InputDecoration(
                      hintText: localizations.technicalFeedbackHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Colors.black), // Default border color
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Colors.green), // Border color when focused
                      ),
                      focusColor:
                      Colors.green, // Cursor and selection handle color
                    ),
                    maxLines: 3,
                  ),
                ),
                  const SizedBox(height: 16),

                  // Additional Comments
                  Text(
                    localizations.additionalComments,
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode
                          ? Colors.green
                          : Colors.teal.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                TextSelectionTheme(
                  data: const TextSelectionThemeData(
                      selectionHandleColor: Colors.grey,
                      selectionColor: Colors.blueGrey),
                  // Text selection color
                  child: TextFormField(
                    controller: _commentsController,
                    cursorColor: isDarkMode
                        ? Colors.green
                        : Colors.teal.shade800,
                    decoration: InputDecoration(
                      hintText: localizations.additionalCommentsHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Colors.black), // Default border color
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Colors.green), // Border color when focused
                      ),
                      focusColor:
                      Colors.green, // Cursor and selection handle color
                    ),
                    maxLines: 3,
                  ),
                ),
                  const SizedBox(height: 24),

                  // Submit Button
                  Center(
                      child: CustomButton(
                          onTap: _saveSuggestions,
                          text: localizations.submit)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
