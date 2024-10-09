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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

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
                        child: const Text('Cancel'),
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
                        child: const Text('Delete'),
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
                  fit: BoxFit.cover, //TODO:find an alternative for cover to see the full image fitting in the frame
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
                  color: isDarkMode ? Colors.black : Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: isEditing ? buildEditView() : buildDetailView(),
                ),
              ),
            ),
          ],
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
          GestureDetector(
            onTap: () => _showFullImageDialog(context),
            child: Image.network(
              imageUrl!,
              height: 150,
              width: 150,
              fit: BoxFit.cover,
            ),
        )
        else
          const Text("No photo selected yet"),
          const Icon(Icons.image,
          size: 150,
          color: Colors.grey),
        // Display the current image
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _pickImage,
          // Call the function to select and update the image URL
          // Logic to update imageUrl goes here (e.g., open image picker)
          // After selecting an image, assign the new URL to imageUrl variable
          // imageUrl = newUrl;
          child: const Text('Select a photo'),
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

    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          const SizedBox(height: 20),
        // Display the plant image if it exists
/*          if (widget.plant.plantData!.imageUrl != null &&
            widget.plant.plantData!.imageUrl!.isNotEmpty)
          Image.network(
            widget.plant.plantData!.imageUrl!,
            height: 150,
            width: 150,// Adjust height as needed
            fit: BoxFit.cover, // Ensure the image scales properly
          )
        else
          const Text(
            "No photo available",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        const SizedBox(height: 20), */
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
          backgroundColor: Colors.black.withOpacity(0.7),
          child: Stack(
            children: [
              ClipRRect(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.50,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                child: GestureDetector(
                  onTap: () {
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
                  child: Container(
                    color: Colors.black.withOpacity(0.7),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: const Row(
                      children: [
                        Icon(Icons.link, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'View URL',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}