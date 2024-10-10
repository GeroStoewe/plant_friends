import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../widgets/custom_snackbar.dart';

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

    if (email.isEmpty || plantName.isEmpty) {
      CustomSnackbar snackbar = CustomSnackbar(context);
      snackbar.showMessage('Email and Plant name are required', MessageType.info);
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
      snackbar.showMessage('Request submitted successfully', MessageType.success);

      // Clear the form fields
      emailController.clear();
      plantNameController.clear();
      notesController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit request')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Plant Addition'),
        backgroundColor: Colors.green,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Help us grow our plant database!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'If a plant you know is missing, please submit the form below and we will consider adding it.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: emailController,
                  icon: Icons.email,
                  hintText: 'Your Email',
                  obscureText: false,
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: plantNameController,
                  icon: Icons.local_florist,
                  hintText: 'Plant Name',
                  obscureText: false,
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: notesController,
                  icon: Icons.note,
                  hintText: 'Additional Notes (Optional)',
                  obscureText: false,
                ),
                const SizedBox(height: 32),
                Center(
                  child: CustomButton(
                    text: 'Submit Request',
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
