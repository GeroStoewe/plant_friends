import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../calendar/calendar_functions.dart';
import '../themes/colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'plant.dart';

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

  String _selectedDifficulty = "Easy"; // Default value for difficulty
  String _selectedLight = "Direct Light"; // Default value for light
  String _selectedWater = "Low"; // Default value for water
  String _selectedPlantType = "Cacti/Succulents"; // Default value for plant type

  @override
  void initState() {
    super.initState();
    _edtNameController.text = widget.plant.plantData!.name!;
    _edtScienceNameController.text = widget.plant.plantData!.scienceName!;
    _edtDateController.text = widget.plant.plantData!.date!;
    _selectedDifficulty = widget.plant.plantData!.difficulty ?? "Easy";
    _selectedLight = widget.plant.plantData!.light ?? "Direct Light";
    _selectedWater = widget.plant.plantData!.water ?? "Low";
    _selectedPlantType = widget.plant.plantData!.type ?? "Cacti/Succulents";
  }

  Future<void> _deletePlant() async {
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Plant'),
        content: const Text('Are you sure you want to delete this plant? This will also remove all associated watering and fertilizing events.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: seaGreen)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: seaGreen)),
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
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(seaGreen),),
            );
          },
        );

        // Delete plant from database
        await dbRef.child("Plants").child(widget.plant.key!).remove();

        // Delete associated calendar events
        await CalenderFunctions().deleteAllEventsForPlant(widget.plant.key!);

        // Hide the loading indicator
        if (mounted) {
          Navigator.pop(context); // Dismiss the loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Plant deleted successfully')),
          );

          // Navigate to MyPlantsPage after deletion
          Navigator.pop(context);
          Navigator.pop(context);
        }
      } catch (error) {
        // Hide the loading indicator in case of an error
        if (mounted) {
          Navigator.pop(context); // Dismiss the loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete plant: $error')),
          );
        }
      }
    }
  }


  Future<void> _updatePlant(BuildContext context) async {
    String originalWaterNeeds = widget.plant.plantData!.water ?? "Low"; // Original water needs
    bool waterNeedsChanged = originalWaterNeeds != _selectedWater;

    Map<String, dynamic> data = {
      "name": _edtNameController.text,
      "science_name": _edtScienceNameController.text,
      "date": _edtDateController.text,
      "difficulty": _selectedDifficulty,
      "light": _selectedLight,
      "water": _selectedWater,
      "type": _selectedPlantType,
    };

    try {
      // Update the plant data in the database
      await dbRef.child("Plants").child(widget.plant.key!).update(data);

      if (waterNeedsChanged) {
        // Show a dialog that informs the user about the event changes
        bool? shouldProceed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Watering and Fertilizing Events Update'),
            content: const Text(
              'You changed the water needs. All existing watering and fertilizing events will be deleted and new ones will be created. Do you want to proceed?',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Close only the dialog
                },
                child: const Text('Cancel', style: TextStyle(color: seaGreen)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Proceed with updating events
                },
                child: const Text('Proceed', style: TextStyle(color: seaGreen)),
              ),
            ],
          ),
        );

        // If user cancels, stop further actions
        if (shouldProceed != true) {
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

          // Create new watering events
          await CalenderFunctions().createNewEventsWatering(
            widget.plant.key!,
            _edtNameController.text,
            _selectedWater,
          );

          // Create new fertilizing events
          await CalenderFunctions().createNewEventsFertilizing(
            widget.plant.key!,
            _edtNameController.text,
            30,
          );

          // Show success message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Watering and fertilizing events updated successfully'),
              ),
            );
          }
        } catch (e) {
          // Handle error and show error message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error updating events: $e'),
              ),
            );
          }
        } finally {
          // Hide the loading indicator
          if (mounted) {
            Navigator.pop(context); // Dismiss the loading dialog
          }
        }
      }


      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Plant details updated successfully")),
        );

        // Navigate to MyPlantsPage after saving changes
        Navigator.pop(context);
        Navigator.pop(context);

        // This pops back to the previous page
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update plant details: $error")),
        );
      }
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Plant',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deletePlant,
            tooltip: 'Delete Plant',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Verwende das CustomTextField für den Namen
              CustomTextField(
                controller: _edtNameController,
                icon: Icons.local_florist,
                hintText: "Name",
                obscureText: false,
              ),
              const SizedBox(height: 15),

              // Verwende das CustomTextField für den wissenschaftlichen Namen
              CustomTextField(
                controller: _edtScienceNameController,
                icon: Icons.science,
                hintText: "Scientific Name",
                obscureText: false,
              ),
              const SizedBox(height: 15),

              // Verwende ein TextField mit einem Kalender-Icon für das Datum
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: CustomTextField(
                    controller: _edtDateController,
                    icon: Icons.calendar_today,
                    hintText: "Date",
                    obscureText: false,
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Dropdown für die Schwierigkeit
              DropdownButtonFormField<String>(
                value: _selectedDifficulty,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.1),
                  prefixIcon: Icon(
                    Icons.star,
                    color: Theme.of(context).brightness == Brightness.dark
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
                  DropdownMenuItem(value: "Hard", child: Text("Hard")),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDifficulty = newValue!;
                  });
                },
              ),
              const SizedBox(height: 15),

              // Dropdown für Light
              DropdownButtonFormField<String>(
                value: _selectedLight,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.1),
                  prefixIcon: Icon(
                    Icons.wb_sunny_outlined,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.3)
                        : Colors.black.withOpacity(0.5),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: "Direct Light", child: Text("Direct Light")),
                  DropdownMenuItem(value: "Indirect Light", child: Text("Indirect Light")),
                  DropdownMenuItem(value: "Partial Shade", child: Text("Partial Shade")),
                  DropdownMenuItem(value: "Low Light", child: Text("Low Light")),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLight = newValue!;
                  });
                },
              ),
              const SizedBox(height: 15),

              // Dropdown für Water
              DropdownButtonFormField<String>(
                value: _selectedWater,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.1),
                  prefixIcon: Icon(
                    Icons.water_drop_outlined,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.3)
                        : Colors.black.withOpacity(0.5),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: "Low", child: Text("Low")),
                  DropdownMenuItem(value: "Medium", child: Text("Medium")),
                  DropdownMenuItem(value: "High", child: Text("High")),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedWater = newValue!;
                  });
                },
              ),
              const SizedBox(height: 15),

              // Dropdown für Plant Type
              DropdownButtonFormField<String>(
                value: _selectedPlantType,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.1),
                  prefixIcon: Icon(
                    Icons.eco_sharp,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.3)
                        : Colors.black.withOpacity(0.5),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: "Cacti/Succulents", child: Text("Cacti/Succulents")),
                  DropdownMenuItem(value: "Tropical Plants", child: Text("Tropical Plants")),
                  DropdownMenuItem(value: "Climbing Plants", child: Text("Climbing Plants")),
                  DropdownMenuItem(value: "Flowering Plants", child: Text("Flowering Plants")),
                  DropdownMenuItem(value: "Trees/Palms", child: Text("Trees/Palms")),
                  DropdownMenuItem(value: "Herbs", child: Text("Herbs")),
                  DropdownMenuItem(value: "Others", child: Text("Others")),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPlantType = newValue!;
                  });
                },
              ),
              const SizedBox(height: 15),
              Center(
                child: CustomButton(
                  text: 'Save Changes',
                  onTap: () => _updatePlant(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
