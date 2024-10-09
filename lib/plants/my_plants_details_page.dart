import 'dart:async';
import 'dart:io';
import 'dart:ui';
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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.plant.plantData!.name!,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
        ),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            color: isDarkMode ? Colors.white70 : Colors.black.withOpacity(0.6),
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
            color: isDarkMode ? Colors.white70 : Colors.black.withOpacity(0.6),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text(
                      'Confirm Deletion',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    content: const Text(
                        'Are you sure you want to delete this plant?',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          deletePlant();
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                            'Delete',
                            style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
              child: widget.plant.plantData!.imageUrl != null
           ? Image.network(
                  widget.plant.plantData!.imageUrl!,
                  fit: BoxFit.cover,
              )
                  : const Icon(
                  Icons.image,
                  size: 150,
                  color: Colors.grey),
           ),
          // Foreground content
          Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.55,
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode ? Colors.black.withOpacity(0.5) : Colors.grey.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      isEditing ? buildEditView() : buildDetailView(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  }

  Widget buildEditView() {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        const SizedBox(height: 10),
        // Display and edit plant image
        if (imageUrl != null)
          GestureDetector(
            onTap: () => _showFullImageDialog(context),
            child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.network(
              imageUrl!,
              height: 150,
              width: 150,
              fit: BoxFit.cover,
            ),
          ),
        )
        else
          Column(
            children: [
              const Icon(Icons.image, size: 100, color: Colors.grey),
              const SizedBox(height: 10),
              Text(
                "No photo selected yet",
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade700,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        // Display the current image
        const SizedBox(height: 20),

        OutlinedButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.camera_alt_rounded),
          label: const Text("Select a photo"),
          style: OutlinedButton.styleFrom(
            foregroundColor: isDarkMode ? Colors.green.shade200 : Colors.green.shade700,
            side: BorderSide(
              color: isDarkMode ? Colors.green.shade200 : Colors.green.shade700,
              width: 2,
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 20),

        TextField(
          controller: _nameController,
          enabled: isEditing,
          decoration: InputDecoration(
            labelText: "Name",
            labelStyle: TextStyle(
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
              fontSize: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: isDarkMode ? Colors.green.shade300 : Colors.green.shade600,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        const SizedBox(height: 20),

        TextField(
          controller: _scienceNameController,
          enabled: isEditing,
          decoration: InputDecoration(
            labelText: "Scientific Name",
            labelStyle: TextStyle(
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
              fontSize: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: isDarkMode ? Colors.green.shade300 : Colors.green.shade600,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        const SizedBox(height: 20),

        GestureDetector(
          onTap: () => _selectDate(context),
          child: AbsorbPointer(
            child: TextField(
              controller: _dateController,
              enabled: isEditing,
              decoration: InputDecoration(
                labelText: "Date",
                labelStyle: TextStyle(
                  color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                  fontSize: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                suffixIcon: Icon(
                    Icons.calendar_today,
                    color: isDarkMode ? Colors.green.shade300 : Colors.green.shade600,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.green.shade300 : Colors.green.shade600,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
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
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: isDarkMode ? Colors.green.shade300 : Colors.green.shade700,
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
                "Save changes",
                style: TextStyle(fontSize: 16),
            ),
          ),
      ],
    ),
      ),
    );
  }

  Widget buildDetailView() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedDate = formatter.format(
        DateTime.parse(widget.plant.plantData!.date!));

    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          const SizedBox(height: 20),
          Text(
          "Name: ${widget.plant.plantData!.name}",
          style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 18),
        ),
          const SizedBox(height: 20),
          Text(
          "Scientific Name: ${widget.plant.plantData!.scienceName}",
          style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 18
          ),
        ),
          const SizedBox(height: 20),
          Text(
          "Date: $formattedDate",
          style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 18),
        ),
      ],
     ),
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
  void _showFullImageDialog(BuildContext context) {
    final imageUrl = widget.plant.plantData?.imageUrl ?? '';

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent, // Makes the background transparent
          child: Stack(
            children: [
              // Blurred background
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8), // Blur effect
                  child: Container(
                    color: Colors.black.withOpacity(0.6), // Semi-transparent background
                  ),
                ),
              ),
              // Center the image
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0), // Rounded corners
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    height: MediaQuery.of(context).size.height * 0.60,
                    width: MediaQuery.of(context).size.width * 0.90,
                  ),
                ),
              ),
              // Minimal close button at the top-right corner
              Positioned(
                top: 30,
                right: 20,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.close, color: Colors.white, size: 24),
                  ),
                ),
              ),
              // Floating "View URL" button at the bottom-left corner
              Positioned(
                bottom: 30,
                left: 20,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.black,
                          title: const Text(
                            'Image URL',
                            style: TextStyle(color: Colors.white),
                          ),
                          content: Text(
                            imageUrl,
                            style: const TextStyle(color: Colors.white),
                          ),
                          actions: [
                            TextButton(
                              child: const Text(
                                'Close',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  label: const Text(
                    'View URL',
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: const Icon(Icons.link, color: Colors.white),
                  backgroundColor: Colors.black.withOpacity(0.7),
                  elevation: 0, // Remove shadow for a flat look
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Done solve edit page bug issue
/// Done icon colors(edit, trash, save)
/// Done beautify edit the container
/// Done color of container for plant details is changed for dark mode and light mode
/// Done calender when you want to add new plant
/// TODO: Fix Android gradle, copy paste Lauras gradle- ANDROID EMULATOR
/// TODO: upgrade apple to 13, as it is currently using 12
