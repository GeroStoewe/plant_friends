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
import '../widgets/custom_snackbar.dart';

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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(25)),
        ),
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Take or pick a plant photo",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOptionCard(
                      icon: Icons.camera_alt_rounded,
                      label: "Camera",
                      onTap: () => Navigator.of(context).pop(ImageSource.camera),
                    ),
                    _buildOptionCard(
                      icon: Icons.photo_library_rounded,
                      label: "Gallery",
                      onTap: () => Navigator.of(context).pop(ImageSource.gallery),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
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

  Widget _buildOptionCard({required IconData icon, required String label, required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Rounded edges
        ),
        elevation: 4, // Shadow to make it stand out
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding inside the card
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ensure the icon and text are compact
            children: [
              Icon(
                icon,
                size: 50,
                color: const Color(0xFF388E3C), // Use accent color for the icons
              ),
              const SizedBox(height: 10), // Space between icon and text
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _uploadImageToFirebase(File imageFile) async {
    try {
      print("Upload started...");

      // Create a unique filename for the image
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = FirebaseStorage.instance.ref().child('plants/$fileName');

      // Set metadata (optional, but recommended)
      final SettableMetadata metadata = SettableMetadata(
        contentType: 'image/jpeg', // Make sure to specify the correct content type
      );

      // Upload the file to Firebase Storage with metadata
      UploadTask uploadTask = ref.putFile(imageFile, metadata);

      // Monitor upload progress (optional)
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        print("Upload progress: $progress%");
      });

      // Wait until the upload is complete
      await uploadTask;

      // Retrieve and return the download URL
      String downloadUrl = await ref.getDownloadURL();

      print("Upload completed! Download URL: $downloadUrl");
      return downloadUrl;

    } catch (e) {
      print("Error uploading image: $e");
      return null; // Return null if an error occurs
    }
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
              .headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Find your plants",
                labelStyle: TextStyle(

                  color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700,
                  fontSize: 16,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.green),
                filled: true,
                fillColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: isDarkMode ? Colors.grey.shade700 : Colors.green,
                      width: 1.5
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
                contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
              ),
            ),
          ),
          Expanded(
            child: filteredPlantList.isEmpty
                ? Center(

              child: Text(
                "No plants available to be searched",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),            )
                : ListView.builder(
              itemCount: filteredPlantList.length,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemBuilder: (context, index) {

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: plantWidget(filteredPlantList[index]),
                );
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
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF4CAF50) : const Color(0xFF388E3C),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '+',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w200,
                color: isDarkMode ? Colors.black : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void plantDialog() {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0), // Rounded corners for modern look
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white, // Adapt to theme
                  borderRadius: BorderRadius.circular(15.0), // Consistent rounded corners
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Show the selected image immediately after selection
                      _plantImage != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(10), // Rounded corners for image

                        child: Image.file(
                          _plantImage!,
                          height: 200,
                          width: double.infinity, // Make image responsive
                          fit: BoxFit.cover,
                        ),
                      )
                          : Text(

                        "No photo selected yet. Tap the camera icon to upload.",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: isDarkMode ? Colors.grey : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Modern spacing and styling for input fields
                      TextField(
                        controller: _edtNameController,
                        decoration: InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold, // Bold label for modern feel
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green, width: 2.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: _edtScienceNameController,
                        decoration: InputDecoration(
                          labelText: "Scientific Name",
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green, width: 2.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: TextField(
                            controller: _edtDateController,
                            decoration: InputDecoration(
                              labelText: "Date",
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                              border: const OutlineInputBorder(),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green, width: 2.0),
                              ),
                              suffixIcon: Icon(
                                Icons.calendar_today,
                                color: isDarkMode ? Colors.grey : Colors.green, // Modern icon coloring
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Row containing the Add photo and Save buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space out buttons
                        children: [
                          Flexible(
                            child:
                            // Add a new plant photo button
                            TextButton(
                              onPressed: () async {
                                await _pickImage();
                                setState(() {}); // Rebuild when image is selected
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Modern padding
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                foregroundColor: isDarkMode ? Colors.grey : Colors.green,
                              ),
                              child: Icon(
                                Icons.camera_alt_rounded,
                                size: 40,
                                color: isDarkMode ? Colors.grey : Colors.green, // Icon adapts to theme
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: ElevatedButton(
                              onPressed: () async {
                                String? imageUrl = "";
                                if (_plantImage != null) {
                                  imageUrl = await _uploadImageToFirebase(_plantImage!);

                                  Map<String, dynamic> data = {
                                    "name": _edtNameController.text,
                                    "science_name": _edtScienceNameController.text,
                                    "date": _edtDateController.text,
                                    "image_url": imageUrl,
                                  };

                                  dbRef.child("Plants").push().set(data).then((value) {
                                    if (mounted) {
                                      CustomSnackbar snackbar = CustomSnackbar(context);
                                          snackbar.showMessage('Plant details updated successfully', MessageType.success);
                                          Navigator.pop(context);
                                    }
                                  }).catchError((error) {
                                    if (mounted) {
                                      Navigator.pop(context);
                                      CustomSnackbar snackbar = CustomSnackbar(context);
                                      snackbar.showMessage('Failed to update plant details: $error', MessageType.error);

                                    }
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Modern button padding
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10), // Rounded button corners
                                ),
                                foregroundColor: Colors.white,
                                backgroundColor: isDarkMode
                                    ? Colors.grey.shade600
                                    : Colors.green,
                                elevation: 5, // Button color adapted to theme
                              ),
                              child: const Text(
                                "Save plant",
                                style: TextStyle(fontSize: 16.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: isDarkMode ? ThemeData.light().copyWith(
            colorScheme: ColorScheme.dark(
            primary: Colors.green,
            surface: Colors.grey[800]!,
            onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.black,
          )
          : ThemeData.light().copyWith(
            primaryColor: Colors.green,
            hintColor: Colors.green,
            colorScheme: const ColorScheme.light(primary: Colors.green),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child ?? Container(),
        );
      },
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
          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
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
                  color: Colors.black.withOpacity(0.2),
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
                  String? imageUrl = await _uploadImageToFirebase(_plantImage!);
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
                          color: isDarkMode ? const Color(0xFFB0BEC5) : Colors
                              .grey),
                      const SizedBox(width: 5),
                      Text(
                        plant.plantData!.date!,
                        style: TextStyle(
                          color: isDarkMode ? const Color(0xFFB0BEC5) : Colors
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