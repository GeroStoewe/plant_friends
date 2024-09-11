import 'dart:async';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/plant_model.dart';

class PlantDetailPageTest extends StatefulWidget {
  final Plant plant;
  final DatabaseReference dbRef;

  const PlantDetailPageTest({super.key, required this.plant, required this.dbRef});

  @override
  State<PlantDetailPageTest> createState() => _PlantDetailPageTestState();
}

class _PlantDetailPageTestState extends State<PlantDetailPageTest> {
  bool isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _scienceNameController;
  late TextEditingController _dateController;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.plant.plantData!.name);
    _scienceNameController = TextEditingController(text: widget.plant.plantData!.science_name);
    _dateController = TextEditingController(text: widget.plant.plantData!.date);
    _imageFile = widget.plant.plantData?.image_url != null ? File(widget.plant.plantData!.image_url!) : null;
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
              deletePlant();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: widget.plant.plantData!.image_url != null
                ? Image.network(
              widget.plant.plantData!.image_url!,
              fit: BoxFit.cover,
            )
                : const Icon(Icons.image, size: 150, color: Colors.grey),
          ),
          // Foreground content
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.55,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
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
        if (_imageFile != null)
          GestureDetector(
            onTap: () => _showFullImageDialog(context),
            child: Image.file(
              _imageFile!,
              height: 150,
              width: 150,
              fit: BoxFit.cover,
            ),
          )
        else
          const Icon(Icons.image, size: 150, color: Colors.grey),
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
              decoration: InputDecoration(
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
            child: const Text("Save Changes"),
          ),
      ],
    );
  }

  Widget buildDetailView() {
    // Formatieren des Datums für die Anzeige
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedDate = formatter.format(DateTime.parse(widget.plant.plantData!.date!));

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            "Name: ${widget.plant.plantData!.name}",
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          Text(
            "Scientific Name: ${widget.plant.plantData!.science_name}",
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          Text(
            "Date: $formattedDate",
            style: const TextStyle(fontSize: 18),
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
      "image_url": _imageFile != null ? _imageFile!.path : widget.plant.plantData?.image_url,
    };
    widget.dbRef.child("Plants").child(widget.plant.key!).update(updatedData).then((value) {
      Navigator.pop(context, true); // Return to HomeScreen with result
    });
  }

  void deletePlant() {
    widget.dbRef.child("Plants").child(widget.plant.key!).remove().then((value) {
      Navigator.pop(context, true); // Return to HomeScreen with result
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

  void _showFullImageDialog(BuildContext context) {
    final imageUrl = widget.plant.plantData?.image_url ?? '';

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
                    child: Row(
                      children: [
                        const Icon(Icons.link, color: Colors.white),
                        const SizedBox(width: 8),
                        const Text(
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
