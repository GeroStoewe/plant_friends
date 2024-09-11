import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:plant_friends/pages/plant_detail_page.dart';
import 'package:plant_friends/pages/wiki_plantdetail_page.dart';

import '../models/plant_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage> {
  final DatabaseReference dbRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://plant-friends-app-default-rtdb.europe-west1.firebasedatabase.app',
  ).ref();

  final TextEditingController _edtNameController = TextEditingController();
  final TextEditingController _edtScienceNameController = TextEditingController();
  final TextEditingController _edtDateController = TextEditingController();
  File? _imageFile; // To store the selected image file
  late StreamSubscription<DatabaseEvent> _plantSubscription;
  List<Plant> plantList = [];

  @override
  void initState() {
    super.initState();
    _plantSubscription = dbRef.child("Plants").onValue.listen((event) {
      final List<Plant> updatedPlantList = [];
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        data.forEach((key, value) {
          PlantData plantData = PlantData.fromJSON(value as Map<dynamic, dynamic>);
          updatedPlantList.add(Plant(key: key, plantData: plantData));
        });
      }

      setState(() {
        plantList = updatedPlantList;
      });
    });
  }

  @override
  void dispose() {
    _plantSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Plant Directory"),
      ),
      body: plantList.isEmpty
          ? const Center(child: Text('No plants available'))
          : ListView.builder(
        itemCount: plantList.length,
        itemBuilder: (context, index) {
          return plantWidget(plantList[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          plantDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Method to pick an image
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path); // Update the image file state
      });
    } else {
      print("No image selected");
    }
  }

  // Method to upload image to Firebase Storage and return the download URL
  Future<String?> _uploadImage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef = FirebaseStorage.instance.ref().child('plant_images/$fileName.jpg');
      final uploadTask = await storageRef.putFile(imageFile);
      return await uploadTask.ref.getDownloadURL(); // Get download URL of the uploaded image
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  void plantDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _edtNameController,
                      decoration: const InputDecoration(labelText: "Name"),
                    ),
                    TextField(
                      controller: _edtScienceNameController,
                      decoration: const InputDecoration(labelText: "Scientific Name"),
                    ),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: TextField(
                          controller: _edtDateController,
                          decoration: const InputDecoration(
                            labelText: "Date",
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _imageFile != null // Check if an image is selected
                        ? Image.file(
                      _imageFile!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    )
                        : const SizedBox.shrink(), // Show nothing if no image is selected
                    ElevatedButton(
                      onPressed: () async {
                        await _pickImage(); // Trigger image picker
                        setState(() {}); // Update UI with selected image
                      },
                      child: const Text("Pick an Image"),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        if (_imageFile != null) {
                          // Start the image upload process
                          String? imageUrl = await _uploadImage(_imageFile!);

                          if (imageUrl != null) {
                            // Prepare the data to save in the database
                            Map<String, dynamic> data = {
                              "name": _edtNameController.text,
                              "science_name": _edtScienceNameController.text,
                              "date": _edtDateController.text,
                              "image_url": imageUrl, // Store image URL in the database
                            };

                            // Save the plant data to Firebase Realtime Database
                            dbRef.child("Plants").push().set(data).then((value) {
                              Navigator.of(context).pop(); // Close the dialog after saving
                            });
                          } else {
                            // Handle error if image upload fails
                            print("Failed to upload image");
                          }
                        } else {
                          // Handle case if no image is selected
                          print("No image selected");
                        }
                      },
                      child: const Text("Save new Plant"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
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
      _edtDateController.text = formattedDate;
    }
  }

  Widget plantWidget(Plant plant) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlantDetailPage(plant: plant, dbRef: dbRef),
          ),
        );

        if (result == true) {
          setState(() {}); // Trigger a rebuild to refresh the data
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            plant.plantData!.image_url != null && plant.plantData!.image_url!.isNotEmpty
                ? Image.network(
              plant.plantData!.image_url!, // Load image from URL
              height: 50,
              width: 50,
              fit: BoxFit.cover, // Optionally adjust the image fit
            )
                : const Icon(
              Icons.local_florist,
              size: 50,
              color: Colors.green,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.plantData!.name!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    plant.plantData!.science_name!,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(
                        plant.plantData!.date!,
                        style: const TextStyle(
                          color: Colors.grey,
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
    );
  }
}