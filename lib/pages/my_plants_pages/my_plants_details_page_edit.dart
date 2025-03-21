import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../themes/colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_number_field.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/custom_text_field.dart';
import '../HelpWithLocalization.dart';
import '../calendar_pages/calendar_functions.dart';
import 'other/plant.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyPlantsDetailsEditPage extends StatefulWidget {
  final Plant plant;

  const MyPlantsDetailsEditPage({Key? key, required this.plant}) : super(key: key);

  @override
  State<MyPlantsDetailsEditPage> createState() => _MyPlantsDetailsEditPageState();
}

class _MyPlantsDetailsEditPageState extends State<MyPlantsDetailsEditPage> {
  final DatabaseReference dbRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://plant-friends-app-default-rtdb.europe-west1.firebasedatabase.app/',
  ).ref();

  final TextEditingController _edtNameController = TextEditingController();
  final TextEditingController _edtScienceNameController = TextEditingController();
  final TextEditingController _edtDateController = TextEditingController();
  File? _plantImage;
  final TextEditingController _customWaterIntervalController = TextEditingController();


  String _selectedDifficulty = "Easy"; // Default value for difficulty
  String _selectedLight = "Direct Light"; // Default value for light
  String _selectedWater = "Low"; // Default value for water
  String _selectedPlantType = "Cacti/Succulents"; // Default value for plant type
  int? previousWaterInterval;

  @override
  void initState() {
    super.initState();

    _edtNameController.text = widget.plant.plantData!.name!;
    _edtScienceNameController.text = widget.plant.plantData!.scienceName!;
    _customWaterIntervalController.text = widget.plant.plantData!.customWaterInterval.toString();
    _edtDateController.text = widget.plant.plantData!.date!;
    _selectedDifficulty = widget.plant.plantData!.difficulty ?? "Easy";
    _selectedLight = widget.plant.plantData!.light ?? "Direct Light";
    _selectedWater = widget.plant.plantData!.water ?? "Low";
    _selectedPlantType = widget.plant.plantData!.type ?? "Cacti/Succulents";
    previousWaterInterval = widget.plant.plantData!.customWaterInterval ?? 5;
  }

  Future<void> _deletePlant() async {
    final localizations = AppLocalizations.of(context)!;

    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.deletePlant),
        content: Text(localizations.sureDeleting), //and fertilizing events
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(localizations.cancel, style: const TextStyle(color: seaGreen)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(localizations.delete, style: const TextStyle(color: seaGreen)),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      try {
        // Show loading indicator during deletion process
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(seaGreen)),
            );
          },
        );

        // Get the imageUrl from the plant data
        String? imageUrl = widget.plant.plantData?.imageUrl;  // Assuming the imageUrl is stored under 'imageUrl'

        // If there is an image URL, delete the image from Firebase Storage
        if (imageUrl != null && imageUrl.isNotEmpty) {
          try {
            await FirebaseStorage.instance.refFromURL(imageUrl).delete();
          } catch (e) {
            CustomSnackbar snackbar = CustomSnackbar(context);
            snackbar.showMessage('${localizations.errorDeleting} $e', MessageType.error);
          }
        }

        // Delete the plant from the database
        await dbRef.child("Plants").child(widget.plant.key!).remove();

        // Delete associated calendar events
        await CalenderFunctions().deleteAllEventsForPlant(widget.plant.key!);

        // Delete photo journal entries for this plant (if applicable)
        await _deleteAllEntriesForPlantAndImages(widget.plant.key!);

        // Hide the loading indicator
        if (mounted) {
          Navigator.pop(context); // Dismiss the loading dialog
          CustomSnackbar snackbar = CustomSnackbar(context);
          snackbar.showMessage(localizations.deletedSuccessfully, MessageType.success);

          // Navigate to MyPlantsPage after deletion
          Navigator.pop(context);
          Navigator.pop(context);
        }
      } catch (error) {
        // Hide the loading indicator in case of an error
        if (mounted) {
          Navigator.pop(context); // Dismiss the loading dialog
          CustomSnackbar snackbar = CustomSnackbar(context);
          snackbar.showMessage('${localizations.failedToDelete} $error', MessageType.error);

        }
      }
    }
  }

  Future<void> _deleteAllEntriesForPlantAndImages(String plantID) async {
    final localizations = AppLocalizations.of(context)!;

    try {
      final snapshot = await dbRef
          .child('PhotoJournal')
          .orderByChild('plantID')
          .equalTo(plantID)
          .once();

      if (snapshot.snapshot.value != null) {
        Map<dynamic, dynamic> entries = snapshot.snapshot.value as Map<dynamic, dynamic>;

        for (var entryKey in entries.keys) {
          Map<dynamic, dynamic> entry = entries[entryKey];
          String? imageUrl = entry['url'];

          if (imageUrl != null && imageUrl.isNotEmpty) {
            try {
              final filePath = Uri.parse(imageUrl).pathSegments.last;

              final ref = FirebaseStorage.instance.ref(filePath);
              await ref.getMetadata();

              await ref.delete();
            } catch (e) {
            }
          }

          await dbRef.child('PhotoJournal').child(entryKey).remove();
        }
      } else {
      }
    } catch (e) {
      CustomSnackbar snackbar = CustomSnackbar(context);
      snackbar.showMessage('${localizations.errorDeletingEntries} $e', MessageType.error);

    }
  }


  String _extractImagePathFromUrl(String imageUrl) {
    Uri uri = Uri.parse(imageUrl);
    String path = uri.path;
    path = path.replaceFirst('/o/', '').replaceAll('%2F', '/');
    return path;
  }



  Future<void> _updatePlant(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;
    String originalWaterNeeds = widget.plant.plantData!.water ?? localizations.low; // Original water needs
    bool waterNeedsChanged = originalWaterNeeds != _selectedWater;
    int? originalCustomWaterInterval = widget.plant.plantData!.customWaterInterval ?? 5;
    bool customWaterIntervalChanged = originalCustomWaterInterval != int.tryParse(_customWaterIntervalController.text);

    Map<String, dynamic> data = {};

    // Show loading indicator while saving the data
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing the dialog by tapping outside
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF388E3C)), // Green color for loading
          ),
        );
      },
    );

    // Check if a new image has been selected
    if (_plantImage != null) {
      String? imageUrl = widget.plant.plantData?.imageUrl;

      // If there is an image URL, delete the image from Firebase Storage
      if (imageUrl != null && imageUrl.isNotEmpty) {
        try {
          await FirebaseStorage.instance.refFromURL(imageUrl).delete();
        } catch (e) {
          CustomSnackbar snackbar = CustomSnackbar(context);
          snackbar.showMessage('${localizations.errorDeletingImages} $e', MessageType.error);
        }
      }

      // Upload the new image and get its URL
      String? newImageUrl = await _uploadImageToFirebase(_plantImage!);
      data = {
        "name": _edtNameController.text,
        "science_name": _edtScienceNameController.text,
        "date": _edtDateController.text,
        "difficulty": _selectedDifficulty,
        "light": _selectedLight,
        "water": _selectedWater,
        "type": _selectedPlantType,
        "custom_water_interval": int.tryParse(_customWaterIntervalController.text) ?? 5, // Convert to int
        "image_url": newImageUrl, // Set the new image URL in the data
      };
    } else {
      // If no new image was selected, retain the existing data
      data = {
        "name": _edtNameController.text,
        "science_name": _edtScienceNameController.text,
        "date": _edtDateController.text,
        "difficulty": _selectedDifficulty,
        "light": _selectedLight,
        "water": _selectedWater,
        "type": _selectedPlantType,
        "custom_water_interval": int.tryParse(_customWaterIntervalController.text) ?? 5, // Convert to int
      };
    }

    try {


      if (waterNeedsChanged || customWaterIntervalChanged) {
        // Show a dialog that informs the user about the event changes
        bool? shouldProceed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(localizations.waterEventsUpdate), //and Fertilizing
            content: Text(localizations.waterNeedsChanged),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Close only the dialog
                },
                child: Text(localizations.cancel, style: const TextStyle(color: Color(0xFF388E3C))),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Proceed with updating events
                },
                child: Text(localizations.proceed, style: const TextStyle(color: Color(0xFF388E3C))),
              ),
            ],
          ),
        );

        // If user cancels, stop further actions
        if (shouldProceed != true) {
          Navigator.pop(context); // Dismiss the loading dialog
          return; // Only closes the dialog, not the whole page
        }

        // Show loading indicator during event deletion and creation
        showDialog(
          context: context,
          barrierDismissible: false, // Prevent closing the dialog by tapping outside
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(seaGreen),
              ),
            );
          },
        );

        try {
          // Delete existing events
          await CalenderFunctions().deleteAllEventsForPlant(widget.plant.key!);
          int? currentWaterInterval = int.tryParse(_customWaterIntervalController.text);
          print("Current water interval: ${currentWaterInterval ?? 'not set'}");
          print("Selected water : ${_selectedWater ?? 'not set'}");


          if (customWaterIntervalChanged || _selectedWater == "Custom") {
            int? currentWaterInterval = int.tryParse(_customWaterIntervalController.text);
            if (currentWaterInterval == null) {
              // Setze hier eine sinnvolle Default-Logik oder wirf eine Exception
              print("Fehler: currentWaterInterval ist null");
              currentWaterInterval = 5;  // Falls das ein sinnvoller Default ist
            }




            await CalenderFunctions().createNewEventsWateringCustom(
              widget.plant.key!,
              _edtNameController.text,
              currentWaterInterval,
            );
          }


          /*
          // Create new fertilizing events
          await CalenderFunctions().createNewEventsFertilizing(
            widget.plant.key!,
            _edtNameController.text,
            30,
          );
          */

          // Update the plant data in the database
          await dbRef.child("Plants").child(widget.plant.key!).update(data);

          // Show success message
          if (mounted) {
            CustomSnackbar snackbar = CustomSnackbar(context);
            snackbar.showMessage(localizations.wateringEventsUpdatedSuccessfully, MessageType.success); // and fertilizing
          }
        } catch (e) {
          // Handle error and show error message
          if (mounted) {
            CustomSnackbar snackbar = CustomSnackbar(context);
            snackbar.showMessage('${localizations.updatingEventsError} $e', MessageType.error);
          }
        } finally {
          if (mounted) {
            Navigator.pop(context); // Dismiss the event loading dialog
          }
        }
      }

      if (mounted) {
        CustomSnackbar snackbar = CustomSnackbar(context);
        snackbar.showMessage(localizations.plantDetailsUpdatedSuccessfully, MessageType.success);

        // Navigate to MyPlantsPage after saving changes
        Navigator.pop(context); // Pop to MyPlantsDetailsEditPage
        Navigator.pop(context); // Pop to previous page
      }
    } catch (error) {
      if (mounted) {
        CustomSnackbar snackbar = CustomSnackbar(context);
        snackbar.showMessage('${localizations.failedToUpdatePlantDetails} $error', MessageType.error);
      }
    } finally {
      if (mounted) {
        Navigator.pop(context); // Dismiss the initial loading dialog
      }
    }
  }



  Future<String?> _uploadImageToFirebase(File imageFile) async {
    try {

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
      });

      // Wait until the upload is complete
      await uploadTask;

      // Retrieve and return the download URL
      String downloadUrl = await ref.getDownloadURL();

      return downloadUrl;

    } catch (e) {
      return null; // Return null if an error occurs
    }
  }



  Future<void> _selectDate(BuildContext context) async {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: isDarkMode
              ? ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: seaGreen, // Header background color in dark mode
              onPrimary: Colors.black, // Header text color in dark mode
              onSurface: seaGreen, // Selected date color in dark mode
            ),
            dialogBackgroundColor: Colors.grey[900], // Date picker background in dark mode
          )
              : ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: seaGreen, // Header background color in light mode
              onPrimary: Colors.white, // Header text color in light mode
              onSurface: seaGreen, // Selected date color in light mode
            ),
            dialogBackgroundColor: Colors.white, // Date picker background in light mode
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formattedDate = formatter.format(selectedDate);
      _edtDateController.text = formattedDate;
    }
  }



  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    String imageUrl = widget.plant.plantData!.imageUrl ?? '';
    final localizations = AppLocalizations.of(context)!;
    String defaultImageUrl =
        'https://firebasestorage.googleapis.com/v0/b/plant-friends-app.appspot.com/o/placeholder_plant%2FnoPlant_plant.webp?alt=media&token=6c20d3e6-4b8c-4b59-a677-2340202020a7';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.editPlant,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deletePlant,
            tooltip: localizations.deletePlant,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Center(
                  child: Stack(
                    children: [
                      SizedBox(
                        width: 160,
                        height: 160,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 8,
                              color: isDarkMode ? darkSeaGreen : darkGreyGreen,
                            ),
                          ),
                          child: ClipOval(
                            child: _plantImage != null
                                ? Image.file(
                              _plantImage!,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            )
                                : Image.network(
                              imageUrl.isNotEmpty
                                  ? imageUrl
                                  : defaultImageUrl,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) {
                                return const Icon(
                                  Icons.error,
                                  size: 60,
                                  color: Colors.red,
                                );
                              },
                              loadingBuilder: (context, child,
                                  loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return const SizedBox(
                                    width: 120,
                                    height: 120,
                                    child: Center(
                                      child:
                                      CircularProgressIndicator(),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: isDarkMode
                                ? darkSeaGreen
                                : darkGreyGreen,
                          ),
                          child: Icon(
                            LineAwesomeIcons.pencil_alt_solid,
                            size: 28.0,
                            color: isDarkMode
                                ? Colors.black87
                                : Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Name Input with Green Label
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  localizations.plantName,
                  style: const TextStyle(
                    fontSize: 16,
                    color: seaGreen, // Green color for label
                  ),
                ),
              ),
              const SizedBox(height: 5),
              CustomTextField(
                controller: _edtNameController,
                icon: Icons.local_florist,
                hintText: localizations.enterPlantName,
                obscureText: false,
              ),
              const SizedBox(height: 15),

              // Scientific Name Input with Green Label
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  localizations.scientificName,
                  style: const TextStyle(
                    fontSize: 16,
                    color: seaGreen, // Green color for label
                  ),
                ),
              ),
              const SizedBox(height: 5),
              CustomTextField(
                controller: _edtScienceNameController,
                icon: Icons.science,
                hintText: localizations.enterScientificName,
                obscureText: false,
              ),
              const SizedBox(height: 15),

              // Date Input with Green Label
                Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  localizations.dateOfPurchase,
                  style: const TextStyle(
                    fontSize: 16,
                    color: seaGreen, // Green color for label
                  ),
                ),
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: CustomTextField(
                    controller: _edtDateController,
                    icon: Icons.calendar_today,
                    hintText: localizations.selectDateOfPurchase,
                    obscureText: false,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Dropdown section label with Green color
                Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  localizations.plantCareInformation,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: seaGreen, // Green color for label
                  ),
                ),
              ),
              const SizedBox(height: 15),
// Plant Type Dropdown with Green Label
              DropdownButtonFormField<String>(
                value: _selectedPlantType,
                decoration: InputDecoration(
                  labelText: localizations.plantType,
                  labelStyle: const TextStyle(color: seaGreen),
                  filled: true,
                  fillColor: isDarkMode
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.1),
                  prefixIcon: Icon(
                    Icons.eco_sharp,
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.3)
                        : Colors.black.withOpacity(0.5),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: [
                  "Cacti/Succulents",
                  "Tropical Plants",
                  "Climbing Plants",
                  "Flowering Plants",
                  "Trees/Palms",
                  "Herbs",
                  "Others",
                ].map((String type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(HelpWithLocalization.getLocalizedPlantType(type, localizations)),
                  );
                }).toList(),

                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPlantType = newValue!;
                  });
                },
              ),

              const SizedBox(height: 15),

/*
              // Difficulty Dropdown with Green Label
              DropdownButtonFormField<String>(
                value: _selectedDifficulty,
                decoration: InputDecoration(
                  labelText: "Difficulty",
                  labelStyle: const TextStyle(color: seaGreen), // Green color
                  filled: true,
                  fillColor: isDarkMode
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.1),
                  prefixIcon: Icon(
                    Icons.star,
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.3)
                        : Colors.black.withOpacity(0.5),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: "Easy", child: Text("Easy")),
                  DropdownMenuItem(value: "Medium", child: Text("Medium")),
                  DropdownMenuItem(value: "Difficult", child: Text("Hard")),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDifficulty = newValue!;
                  });
                },
              ),
              const SizedBox(height: 15),
*/
              // Light Dropdown with Green Label
              DropdownButtonFormField<String>(
                value: _selectedLight,
                decoration: InputDecoration(
                  labelText: localizations.lightRequirement,
                  labelStyle: const TextStyle(color: seaGreen), // Green color
                  filled: true,
                  fillColor: isDarkMode
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.1),
                  prefixIcon: Icon(
                    Icons.wb_sunny_outlined,
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.3)
                        : Colors.black.withOpacity(0.5),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),

                items: [
                  "Direct Light",
                  "Indirect Light",
                  "Partial Shade",
                  "Low Light"
                ].map((light) {
                  return DropdownMenuItem<String>(
                    value: light,
                    child: Text(
                      HelpWithLocalization.getLocalizedLight(light, localizations), // Hier die Lokalisierung
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                }).toList(),

                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLight = newValue!; // Hier bleibt die technische (englische) Bezeichnung gespeichert
                  });
                },
              ),

              const SizedBox(height: 15),

              // Water Dropdown with Green Label
              DropdownButtonFormField<String>(
                value: _selectedWater,
                decoration: InputDecoration(
                  labelText: localizations.waterRequirement,
                  labelStyle: const TextStyle(color: Colors.green), // Deine Farbe
                  filled: true,
                  fillColor: isDarkMode
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.1),
                  prefixIcon: Icon(
                    Icons.water_drop_rounded,
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.3)
                        : Colors.black.withOpacity(0.5),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: [
                  'Low',
                  'Medium',
                  'High',
                  'Custom',  // Custom bleibt hier im Value Englisch
                ].map((water) {
                  return DropdownMenuItem<String>(
                    value: water,
                    child: Text(
                      HelpWithLocalization.getLocalizedWater(water, localizations), // Lokalisierung hier
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedWater = newValue!;
                    if (_selectedWater != "Custom") {
                      _customWaterIntervalController.clear();  // <- das sorgt dafür, dass es leer ist, wenn kein Custom
                    } else if (_customWaterIntervalController.text.isEmpty) {
                      _customWaterIntervalController.text = "5"; // Standardwert bei Wechsel auf Custom
                    }
                  });
                }
                ,
              ),



              // Conditional field for custom water interval
              if (_selectedWater == "Custom") ...[
                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    localizations.wateringIntervalDays,
                    style: const TextStyle(
                      fontSize: 16,
                      color: seaGreen, // Green color for label
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                CustomNumberField(
                  controller: _customWaterIntervalController,
                  icon: Icons.water_drop_outlined,
                  hintText: localizations.enterWateringInterval,
                  obscureText: false,
                ),
              ],


              const SizedBox(height: 20),

              Center(
                child: CustomButton(
                  text: localizations.saveChanges,
                  onTap: () => _updatePlant(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
                  localizations.chooseImageSource,
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
                      onTap: () => Navigator.of(context).pop(ImageSource.camera),
                    ),
                    _buildOptionCard(
                      icon: Icons.photo_library_rounded,
                      label: localizations.gallery,
                      onTap: () =>
                        Navigator.of(context).pop(ImageSource.gallery)
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
          _plantImage = File(pickedFile.path);
        });
      }
    }
  }
}
