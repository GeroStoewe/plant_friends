import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../widgets/custom_text_field.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RequestPlantFormPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController plantNameController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  final DatabaseReference dbRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://plant-friends-app-default-rtdb.europe-west1.firebasedatabase.app',
  ).ref();

  RequestPlantFormPage({super.key});

  Future<void> _submitRequest(BuildContext context) async {
    final email = emailController.text;
    final plantName = plantNameController.text;
    final notes = notesController.text;
    final localizations = AppLocalizations.of(context)!;

    if (email.isEmpty || plantName.isEmpty) {
      CustomSnackbar snackbar = CustomSnackbar(context);
      snackbar.showMessage('', MessageType.info);
      return;
    }

    try {
      final newRequestRef = dbRef.child('requests').push();
      await newRequestRef.set({
        'email': email,
        'plantName': plantName,
        'notes': notes,
      });
      CustomSnackbar snackbar = CustomSnackbar(context);
      snackbar.showMessage(localizations.requestSuccessfully, MessageType.success);

      // Clear the form fields
      emailController.clear();
      plantNameController.clear();
      notesController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.failedToSubmitRequest)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.requestPlant),
        backgroundColor: Colors.green,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.growPlantDatabase,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  localizations.ifPlantMissing,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: emailController,
                  icon: Icons.email,
                  hintText: localizations.yourEmail,
                  obscureText: false,
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: plantNameController,
                  icon: Icons.local_florist,
                  hintText: localizations.plantName,
                  obscureText: false,
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: notesController,
                  icon: Icons.note,
                  hintText: localizations.additionalNotes,
                  obscureText: false,
                ),
                const SizedBox(height: 32),
                Center(
                  child: CustomButton(
                    text: localizations.submitRequest,
                    onTap: () => _submitRequest(context),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
