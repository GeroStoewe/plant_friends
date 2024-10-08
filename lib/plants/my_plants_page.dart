import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';
// import 'package:permission_handler/permission_handler.dart'; //optional
import 'my_plants_details_page.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:line_icons/line_icons.dart';
import 'plant.dart';

class MyPlantsPage extends StatefulWidget {
  const MyPlantsPage({super.key});

  @override
  State<MyPlantsPage> createState() => _MyPlantsPageState();
}

class _MyPlantsPageState extends State<MyPlantsPage> {
  final DatabaseReference dbRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
    'https://plant-friends-app-default-rtdb.europe-west1.firebasedatabase.app/',
  ).ref();
  final FirebaseStorage storage = FirebaseStorage.instance;

  final TextEditingController _edtNameController = TextEditingController();
  final TextEditingController _edtScienceNameController =
  TextEditingController();
  final TextEditingController _edtDateController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  late StreamSubscription<DatabaseEvent> _plantSubscription;
  List<Plant> plantList = [];
  List<Plant> filteredPlantList = [];
  File? _plantImage;

  @override
  void initState() {
    super.initState();

    _searchController.addListener(_onSearchChanged);
    _plantSubscription = dbRef
        .child("Plants")
        .onValue
        .listen((event) {
      final List<Plant> updatedPlantList = [];
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        data.forEach((key, value) {
          PlantData plantData =
          PlantData.fromJSON(value as Map<dynamic, dynamic>);
          updatedPlantList.add(Plant(key: key, plantData: plantData));
        });
      }

      setState(() {
        plantList = updatedPlantList;
        filteredPlantList = updatedPlantList;
      });
    });
  }

  @override
  void dispose() {
    _plantSubscription.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      filteredPlantList = plantList.where((plant) =>
      plant.plantData!.name!.toLowerCase().contains(
          _searchController.text.toLowerCase()) ||
          plant.plantData!.scienceName!.toLowerCase().contains(
              _searchController.text.toLowerCase())).toList();
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    final selectedSource = await showModalBottomSheet<ImageSource>(
        context: context,
        builder: (BuildContext context) {
          return Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded),
                title: const Text("Take a photo of your plant"),
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded),
                title: const Text("Choose a picture from your gallery"),
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
            ],
          );
        }
    );

    if (mounted && selectedSource != null) {
      final pickedFile = await picker.pickImage(source: selectedSource);
      if (pickedFile != null) {
        setState(() {
          _plantImage = File(pickedFile.path); // Save the selected image
        });
      }
    }
  }

  Future<String> _uploadImageToFirebase(File imageFile) async {
    // Create a unique filename for the image
    String fileName = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    Reference ref = storage.ref().child('plants/$fileName');

    // Upload the file to Firebase Storage
    await ref.putFile(imageFile);
    // Retrieve and return the download URL
    String downloadUrl = await ref.getDownloadURL();

    return downloadUrl; // Return the URL for saving to the database
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Plants",
          style: Theme
              .of(context)
              .textTheme
              .headlineMedium,
        ),
      ),
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Find your plants",
                labelStyle: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black),
                prefixIcon: const Icon(Icons.search),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Colors.green,
                      width: 2.0
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                // Change the border color when the search bar is focused
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Colors.green,
                      width: 2.0
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredPlantList.isEmpty
                ? const Center(
                child: Text("No plants available to be searched"))
                : ListView.builder(
              itemCount: filteredPlantList.length,
              itemBuilder: (context, index) {
                return plantWidget(filteredPlantList[index]);
              },
            ),
          )
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          plantDialog();
        },
        child: Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            color: Color(0xFF388E3C),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text(
              '+',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w200,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void plantDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
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
                  decoration:
                  const InputDecoration(labelText: "Scientific Name"),
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
                // show the selected image
                _plantImage != null ? Image.file(
                  _plantImage!,
                  height: 200,
                )
                    : const Text("No photo selected yet"),
                TextButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.camera_alt_rounded),
                  label: const Text("Add a plant photo"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Upload the image to Firebase and get the URL
                    String imageUrl = await _uploadImageToFirebase(
                        _plantImage!);

                    // Save plant details to Firebase Realtime Database
                    Map<String, dynamic> data = {
                      "name": _edtNameController.text,
                      "science_name": _edtScienceNameController.text,
                      "date": _edtDateController.text,
                      "image_url": imageUrl // Include the image URL
                    };

                    dbRef.child("Plants").push().set(data).then((value) {
                      if (mounted) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text(
                              "Plant details updated successfully")),
                        );
                      }
                    }).catchError((error) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(
                              "Failed to update plant details: $error")),
                        );
                      }
                    });
                  },
                  child: const Text("Save new plant"),
                ),
              ],
            ),
          ),
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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MyPlantsDetailsPage(
                  plant: plant, dbRef: dbRef),
          ),
        );

        if (result == true) {
          setState(() {});
        }
      },
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.black.withOpacity(0.5) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            if (!isDarkMode) ...[
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ] else
              ...[
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                await _pickImage();
                if (_plantImage != null) {
                  String imageUrl = await _uploadImageToFirebase(_plantImage!);
                  setState(() {
                    plant.plantData!.imageUrl = imageUrl;
                  });
                }
              },
              child: Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: plant.plantData!.imageUrl != null ? ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.network(
                        plant.plantData!.imageUrl!,
                        fit: BoxFit.cover,
                      ),
                    ) : const Icon(FluentIcons.camera_24_regular,
                      size: 50,
                      color: Color(0xFF388E3C),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.plantData!.name!,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    plant.plantData!.scienceName!,
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey.shade400 : Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                          LineIcons.calendarWithWeekFocus,
                          size: 16,
                          color: isDarkMode ? Colors.grey.shade400 : Colors
                              .grey),
                      const SizedBox(width: 5),
                      Text(
                        plant.plantData!.date!,
                        style: TextStyle(
                          color: isDarkMode ? Colors.grey.shade400 : Colors
                              .grey,
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
/// TODO: change the structure of code according to OOP
