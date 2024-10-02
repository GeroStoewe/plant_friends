import 'dart:async';
import 'dart:io';
import 'package:plant_friends/plants/plant.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class MyPlantsDetailsPage extends StatefulWidget {
  final Plant plant;
  final DatabaseReference dbRef;

  const MyPlantsDetailsPage({super.key, required this.plant, required this.dbRef});

  @override
  State<MyPlantsDetailsPage> createState() => _MyPlantsDetailsPage();
}

class _MyPlantsDetailsPage extends State<MyPlantsDetailsPage> {
  bool isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _scienceNameController;
  late TextEditingController _dateController;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.plant.plantData!.name);
    _scienceNameController =
        TextEditingController(text: widget.plant.plantData!.scienceName);
    _dateController = TextEditingController(text: widget.plant.plantData!.date);
    imageUrl = widget.plant.plantData!.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plant.plantData!.name!),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (isEditing) {
                saveChanges();
              }
              setState(() {
                isEditing = !isEditing;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Deletion'),
                    content: const Text(
                        'Are you sure you want to delete this plant?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                      TextButton(
                        child: const Text('Delete'),
                        onPressed: () {
                          deletePlant();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isEditing ? buildEditView() : buildDetailView(),
      ),
    );
  }

  Widget buildEditView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        // Display and edit plant image
        if (imageUrl != null)
          Image.network(imageUrl!, height: 200, fit: BoxFit.cover,)
        else
          const Text("No image selected"),
        // Display the current image
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _pickImage,
          // Call the function to select and update the image URL
          // Logic to update imageUrl goes here (e.g., open image picker)
          // After selecting an image, assign the new URL to imageUrl variable
          // imageUrl = newUrl;
          child: const Text('Select Image'),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _nameController,
          enabled: isEditing,
          decoration: const InputDecoration(
            labelText: "Name",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _scienceNameController,
          enabled: isEditing,
          decoration: const InputDecoration(
            labelText: "Scientific Name",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: AbsorbPointer(
            child: TextField(
              controller: _dateController,
              enabled: isEditing,
              decoration: const InputDecoration(
                labelText: "Date",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (isEditing)
          ElevatedButton(
            onPressed: () {
              saveChanges();
            },
            child: const Text("Save changes"),
          ),
      ],
    );
  }

  Widget buildDetailView() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedDate = formatter.format(
        DateTime.parse(widget.plant.plantData!.date!));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        // Display the plant image if it exists
        if (widget.plant.plantData!.imageUrl != null &&
            widget.plant.plantData!.imageUrl!.isNotEmpty)
          Image.network(
            widget.plant.plantData!.imageUrl!,
            height: 200, // Adjust height as needed
            fit: BoxFit.cover, // Ensure the image scales properly
          )
        else
          const Text(
            "No image available",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        const SizedBox(height: 20),
        Text(
          "Name: ${widget.plant.plantData!.name}",
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 20),
        Text(
          "Scientific Name: ${widget.plant.plantData!.scienceName}",
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 20),
        Text(
          "Date: $formattedDate",
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }

  void saveChanges() {
    Map<String, dynamic> updatedData = {
      "name": _nameController.text,
      "science_name": _scienceNameController.text,
      "date": _dateController.text,
      "image_url": imageUrl ?? widget.plant.plantData?.imageUrl,
    };

    widget.dbRef.child("Plants").child(widget.plant.key!)
        .update(updatedData)
        .then((value) {
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Plant details updated successfully')),
        );
      }
    }).catchError((error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update plant details: $error')),
        );
      }
    });
  }

  void deletePlant() {
    widget.dbRef.child("Plants").child(widget.plant.key!).remove().then((
        value) {
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Plant deleted successfully')),
        );
      }
    }).catchError((error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete plant: $error')),
        ); // Return to HomeScreen with result
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formattedDate = formatter.format(selectedDate);
      _dateController.text = formattedDate;
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(
        source: ImageSource.gallery);

    if (pickedImage != null) {
      File imageFile = File(pickedImage
          .path); // Convert XFile to File to work with Firebase Storage

      try {
        // Create a reference to Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('plant_photos/${DateTime
            .now()
            .millisecondsSinceEpoch}.jpg');

        // Upload the file to Firebase Storage
        final uploadTask = storageRef.putFile(imageFile);
        await uploadTask.whenComplete(() => null);

        // Get the downloadable URL after the upload
        final downloadUrl = await storageRef.getDownloadURL();

        if (mounted) {
          setState(() {
            imageUrl =
                downloadUrl; // Save the download URL to display the image
          });

          // Show success feedback to the user
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image uploaded successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          // Show error feedback to the user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error uploading image: $e')),
          );
        }
      }
    } else {
      if (mounted) {
        // Handle when no image is selected
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No image selected')),
        );
      }
    }
  }
}