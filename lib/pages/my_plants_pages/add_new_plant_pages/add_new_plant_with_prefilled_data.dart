import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../widgets/custom_snackbar.dart';
import '../../HelpWithLocalization.dart';
import '../../calendar_pages/calendar_functions.dart';
import '../other/plant.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddNewPlantWithPrefilledData extends StatefulWidget {
  final dynamic plant;

  const AddNewPlantWithPrefilledData({super.key, required this.plant});

  @override
  _AddNewPlantWithPrefilledDataState createState() => _AddNewPlantWithPrefilledDataState();
}

class _AddNewPlantWithPrefilledDataState extends State<AddNewPlantWithPrefilledData> {
  final List<String> plantTypes = [
    'Cacti/Succulents',
    'Tropical Plants',
    'Climbing Plants',
    'Flowering Plants',
    'Trees/Palms',
    'Herbs',
    'Others'
  ];
  final List<String> difficulties = [
    'Easy',
    'Medium',
    'Difficult',
  ];

  final List<String> lightRequirements = [
    'Direct Light',
    'Indirect Light',
    'Partial Shade',
    'Low Light',
  ];
  final List<String> waterRequirements = [
    'Low',
    'Medium',
    'High',
  ];

  final DatabaseReference dbRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
    'https://plant-friends-app-default-rtdb.europe-west1.firebasedatabase.app/',
  ).ref();
  final FirebaseStorage storage = FirebaseStorage.instance;

  late final TextEditingController _edtNameController = TextEditingController(text: widget.plant['name']);
  late final TextEditingController _edtScienceNameController = TextEditingController(text: widget.plant['scientifical_name']);
  final TextEditingController _edtDateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()));

  late StreamSubscription<DatabaseEvent> _plantSubscription;
  List<Plant> plantList = [];
  List<Plant> filteredPlantList = [];
  File? _plantImage;

  String? _selectedPlantType;
  String? _selectedDifficulty;
  String? _selectedLightRequirement;
  String? _selectedWaterRequirement;

  TextEditingController _customWaterIntervalController = TextEditingController();
  bool _isCustomWaterInterval = false;

  bool _isImagePicked = false;
  String _identifiedPlant = '';


  // Function to get the current user's userId on FirebaseAuth
  String? _getUserId() {
    User? user = FirebaseAuth.instance
        .currentUser; // Get the currently logged-in user
    return user?.uid; // Return the userId (null if the user is not signed in)
  }


  @override
  void initState() {
    super.initState();

    String? currentUserId = _getUserId();

    _plantSubscription = dbRef
        .child("Plants")
        .onValue
        .listen((event) {
      final List<Plant> updatedPlantList = [];
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        data.forEach((key, value) {
          PlantData plantData = PlantData.fromJSON(value as Map<dynamic, dynamic>);
          if (plantData.userId == currentUserId) {
            updatedPlantList.add(Plant(key: key, plantData: plantData));
          }
        });
      }
      if (mounted) {
        setState(() {
          _selectedLightRequirement = lightRequirements.contains(widget.plant['light'])
              ? widget.plant['light']
              : null;

          _selectedWaterRequirement = waterRequirements.contains(widget.plant['water'])
              ? widget.plant['water']
              : null;

          _selectedDifficulty = difficulties.contains(widget.plant['difficulty'])
              ? widget.plant['difficulty']
              : null;

          _selectedPlantType = plantTypes.contains(widget.plant['type'])
              ? widget.plant['type']
              : null;
        });
      }

    });
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
            buttonTheme: const ButtonThemeData(
                textTheme: ButtonTextTheme.primary),
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


  void _resetForm() {
    // Clear the text fields
    _edtNameController.clear();
    _edtScienceNameController.clear();
    _edtDateController.clear();

    // Reset selected image
    setState(() {
      _plantImage = null;
      _isImagePicked = false;
    });
  }




  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    final localizations = AppLocalizations.of(context)!;

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
                Text(
                  localizations.takeOrPickPhoto,
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
                      label: localizations.camera,
                      onTap: () =>
                          Navigator.of(context).pop(ImageSource.camera),
                    ),
                    _buildOptionCard(
                      icon: Icons.photo_library_rounded,
                      label: localizations.gallery,
                      onTap: () =>
                          Navigator.of(context).pop(ImageSource.gallery),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        }
    );

    if (mounted) {
      if (selectedSource != null) {
        final pickedFile = await picker.pickImage(source: selectedSource);
        if (pickedFile != null) {
          setState(() {
            _plantImage = File(pickedFile.path); // Save the selected image
            _isImagePicked = true;
          });
        }
        print('Image successfully picked: ${_plantImage?.path}');
      } else {
        setState(() {
          _isImagePicked = false; // No image selected
        });
        print('No image selected');
      }
    }
  }

  Widget _buildOptionCard(
      {required IconData icon, required String label, required Function() onTap}) {
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 50,
                color: const Color(0xFF388E3C),
              ),
              const SizedBox(height: 10),
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

      // Get the current user's userId (can be null if the user is not signed in)
      String? userId = _getUserId();

      if (userId == null) {
        print("Error: User is not logged in. Cannot upload image.");
        return null; // Return null or handle the error as needed
      }

      // Create a unique filename for the image
      String fileName = DateTime
          .now()
          .millisecondsSinceEpoch
          .toString();
      Reference ref = FirebaseStorage.instance.ref().child('plants/$fileName');

      // Set metadata (optional, but recommended)
      final SettableMetadata metadata = SettableMetadata(
        contentType: 'image/jpeg',
        // Make sure to specify the correct content type
        customMetadata: {
          'userId': userId, // Add the userId to the metadata
        },
      );

      // Upload the file to Firebase Storage with metadata
      UploadTask uploadTask = ref.putFile(imageFile, metadata);

      // Monitor upload progress (optional)
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = (snapshot.bytesTransferred / snapshot.totalBytes) *
            100;
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
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.addNewPlant,
          style: Theme
              .of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: Theme
            .of(context)
            .scaffoldBackgroundColor,
      ),
      body: _buildAddPlantBottomSheet(),
    );
  }

  // Dein vollständiges _buildAddPlantBottomSheet hier einfügen!

  Widget _buildAddPlantBottomSheet() {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    CalenderFunctions calenderFunctions = CalenderFunctions();
    final localizations = AppLocalizations.of(context)!;

    return DraggableScrollableSheet(
      expand: true,
      initialChildSize: 1.0,
      maxChildSize: 1.0,
      minChildSize: 1.0,
      builder: (context, scrollController) {
        print("Building DraggableScrollableSheet");
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery
                .of(context)
                .viewInsets
                .bottom,
            left: 16.0,
            right: 16.0,
            top: 20.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 35),

                // Show the selected image immediately after selection
                _isImagePicked && _plantImage != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  // Rounded corners for image

                  child: Image.file(
                    _plantImage!,
                    height: 200,
                    width: double.infinity, // Make image responsive
                    fit: BoxFit.cover,
                  ),
                )
                    : Text(
                  localizations.noPhotoSelected,
                  style: TextStyle(
                    fontSize: 17.0,
                    color: isDarkMode ? Colors.grey : Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                if (_identifiedPlant.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      '${localizations.identifiedPlant} $_identifiedPlant',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                const SizedBox(height: 15),

                // Modern spacing and styling for input fields
                TextField(
                  controller: _edtNameController,
                  decoration: InputDecoration(
                    labelText: localizations.name,
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
                    labelText: localizations.scientificName,
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
                        labelText: localizations.dateOfPurchase,
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.green, width: 2.0),
                        ),
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          color: isDarkMode ? Colors.grey : Colors
                              .green, // Modern icon coloring
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Dropdown Menu für Pflanzenart
                DropdownButtonFormField<String>(
                  value: _selectedPlantType,
                  hint: Text(
                    localizations.selectPlantType,
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey : Colors.black,
                    ),
                  ),
                  items: plantTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(
                        HelpWithLocalization.getLocalizedPlantType(type, localizations),
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPlantType = newValue ?? plantTypes[0];
                    });
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2.0),
                    ),
                    labelText: localizations.plantType,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 15),
/*
                DropdownButtonFormField<String>(
                  value: widget.plant['difficulty'],
                  hint: Text(
                    'Select Difficulty',
                    style: TextStyle(
                        color: isDarkMode ? Colors.grey : Colors.black),
                  ),
                  items: difficulties.map((String difficulty) {
                    return DropdownMenuItem<String>(
                      value: difficulty,
                      child: Text(
                        difficulty,
                        style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedDifficulty = newValue ??
                          difficulties[0]; // Set default value if null
                    });
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2.0),
                    ),
                    labelText: "Difficulty",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,),
                  ),
                ),
                const SizedBox(height: 15),
*/
                // Dropdown Menu für Lichtanforderungen
                DropdownButtonFormField<String>(
                  value: _selectedLightRequirement, // <-- Nutze den State
                  hint: Text(
                    localizations.selectLightRequirement,
                    style: TextStyle(color: isDarkMode ? Colors.grey : Colors.black),
                  ),
                  items: lightRequirements.map((String light) {
                    return DropdownMenuItem<String>(
                      value: light,
                      child: Text(
                        HelpWithLocalization.getLocalizedLight(light, localizations), // Optional: Lokalisierung
                        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedLightRequirement = newValue; // Direkt updaten, null ist auch erlaubt
                    });
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2.0),
                    ),
                    labelText: localizations.lightRequirement,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Dropdown Menu für Wasseranforderungen
                DropdownButtonFormField<String>(
                  value: _selectedWaterRequirement,  // <- Nur noch der State-Wert
                  hint: Text(
                    localizations.selectWaterRequirement,
                    style: TextStyle(color: isDarkMode ? Colors.grey : Colors.black),
                  ),
                  items: [
                    ...waterRequirements.map((String water) {
                      return DropdownMenuItem<String>(
                        value: water,
                        child: Text(
                          HelpWithLocalization.getLocalizedWater(water, localizations), // Lokalisierung, falls nötig
                          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                        ),
                      );
                    }).toList(),
                    DropdownMenuItem<String>(
                      value: localizations.custom,
                      child: Text(
                        localizations.custom,
                        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                      ),
                    ),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      if (newValue == localizations.custom) {
                        _isCustomWaterInterval = true;
                        _selectedWaterRequirement = localizations.custom; // Sicherstellen, dass auch State gesetzt wird
                      } else {
                        _isCustomWaterInterval = false;
                        _selectedWaterRequirement = newValue;
                      }
                    });
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2.0),
                    ),
                    labelText: localizations.waterRequirement,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),

                if (_isCustomWaterInterval)
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: TextField(
                      controller: _customWaterIntervalController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: localizations.enterWateringInterval,
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
                  ),
                const SizedBox(height: 15),


                // Row containing the Add photo and Save buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // Space out buttons
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20), // Modern padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          foregroundColor: isDarkMode ? Colors.grey : Colors
                              .green,
                        ),
                        child: Icon(
                          Icons.camera_alt_rounded,
                          size: 40,
                          color: isDarkMode ? Colors.green.shade800 : Colors
                              .green, // Icon adapts to theme
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            // Lade die englischen Strings direkt am Anfang
                            _selectedPlantType = HelpWithLocalization.getEnglishPlantType(_selectedPlantType!, localizations);
                            _selectedLightRequirement = HelpWithLocalization.getEnglishLight(_selectedLightRequirement!, localizations);
                            _selectedWaterRequirement = HelpWithLocalization.getEnglishWater(_selectedWaterRequirement!, localizations);

                            if (_edtNameController.text.isEmpty ||
                                _edtScienceNameController.text.isEmpty ||
                                _edtDateController.text.isEmpty ||
                                _selectedPlantType == null ||
                                //_selectedDifficulty == null ||
                                _selectedLightRequirement == null ||
                                _selectedWaterRequirement == null) {

                              // Show warning banner if any required field is missing
                              CustomSnackbar snackbar = CustomSnackbar(context);
                              snackbar.showMessage(localizations.fillRequiredFields, MessageType.error);
                              return; // Exit the function early
                            }
                            // Show loading indicator while saving the data
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              // Prevent closing the dialog by tapping outside
                              builder: (BuildContext context) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<
                                        Color>(Color(
                                        0xFF388E3C)), // Green color for loading
                                  ),
                                );
                              },
                            );

                            String? imageUrl;

                            // Check if the image is picked and upload if it is
                            if (_isImagePicked && _plantImage != null) {
                              imageUrl =
                              await _uploadImageToFirebase(_plantImage!);
                            } else {
                              // No image is picked, so set imageUrl to null (or "" if preferred)
                              imageUrl =
                              null; // null instead of " " due to null check operator
                            }

                            // Debug print statement to ensure imageUrl is set
                            print("Image URL: $imageUrl");

                            // Retrieve the userId
                            String? userId = _getUserId();
                            // Debug print statement to ensure userId is set
                            print("User ID: $userId");

                            // Ensure that userId is not null before saving
                            if (userId != null) {
                              Map<String, dynamic> data = {
                                "name": _edtNameController.text,
                                "science_name": _edtScienceNameController
                                    .text,
                                "date": _edtDateController.text,
                                "image_url": imageUrl,
                                "user_id": userId,
                                "water": _selectedWaterRequirement,
                                "type": _selectedPlantType,
                                "light": _selectedLightRequirement,
                                "difficulty": _selectedDifficulty
                              };

                              // Debug print statement to ensure data map is created correctly
                              print("Data: $data");

                              // Save plant details to Firebase and get the reference
                              DatabaseReference newPlantRef = dbRef.child(
                                  "Plants").push();

                              await newPlantRef.set(data);
                              String newPlantId = newPlantRef.key!;
                              // Call event creation functions
                              if(_isCustomWaterInterval){
                                int waterInterval = int.tryParse(_customWaterIntervalController.text) ?? 5;
                                await calenderFunctions.createNewEventsWateringCustom(
                                  newPlantId,
                                  _edtNameController.text,
                                  waterInterval,
                                );
                              }else{
                                await calenderFunctions.createNewEventsWatering(
                                  newPlantId,
                                  _edtNameController.text,
                                  _selectedWaterRequirement!,
                                );
                              }
                              await newPlantRef.update({
                                "custom_water_interval": int.tryParse(_customWaterIntervalController.text) ?? 5,
                              });

                              /*
                              // Assuming a default day interval for fertilizing (e.g., 30 days)
                              int fertilizingInterval = 30; // You can change this as needed
                              await calenderFunctions
                                  .createNewEventsFertilizing(
                                newPlantId, // Pass the plant ID if available
                                _edtNameController.text, // Use plant name
                                fertilizingInterval, // Use the fertilizing interval
                              );

                               */

                              if (mounted) {
                                Navigator.pop(context);
                                CustomSnackbar snackbar = CustomSnackbar(
                                    context);
                                snackbar.showMessage(
                                    localizations.plantDetailsUpdatedSuccessfully,
                                    MessageType.success);
                                // Reset the form fields after successfully saving the plant
                                _resetForm();
                                Navigator.pop(context);
                              }
                            } else {
                              if (mounted) {
                                Navigator.pop(context); // Close loading dialog
                                CustomSnackbar snackbar = CustomSnackbar(
                                    context);
                                snackbar.showMessage(
                                    localizations.failedToGetUserId,
                                    MessageType.error);
                              }
                            }
                          } catch (error) {
                            if (mounted) {
                              Navigator.pop(context);
                              CustomSnackbar snackbar = CustomSnackbar(context);
                              snackbar.showMessage(
                                  '${localizations.failedToUpdatePlantDetails} $error',
                                  MessageType.error);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          // Modern button padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Rounded button corners
                          ),
                          foregroundColor: Colors.white,
                          backgroundColor: isDarkMode
                              ? Colors.green.shade800
                              : Colors.green,
                          elevation: 5, // Button color adapted to theme
                        ),
                        child: Text(
                          localizations.save,
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
        );
      },
    );
  }
}