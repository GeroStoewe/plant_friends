import 'dart:async';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:line_icons/line_icons.dart';

import 'my_plants_details_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  final TextEditingController _edtNameController = TextEditingController();
  final TextEditingController _edtScienceNameController =
      TextEditingController();
  final TextEditingController _edtDateController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  late StreamSubscription<DatabaseEvent> _plantSubscription;
  List<Plant> plantList = [];
  List<Plant> filteredPlantList = [];

  @override
  void initState() {
    super.initState();

    _searchController.addListener(_onSearchChanged);

    _plantSubscription = dbRef.child("Plants").onValue.listen((event) {
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

  void _onSearchChanged(){
    setState(() {
      filteredPlantList = plantList.where((plant) => plant.plantData!.name!.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          plant.plantData!.scienceName!.toLowerCase().contains(_searchController.text.toLowerCase())).toList();
    });
  }

/*
  void deletePlant(Plant plant) {
    dbRef.child("Plants").child(plant.key!).remove().then((value) {
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Plant deleted successfully')),
        );
        setState(() {
          plantList.remove(plant);
        });
      }
    }).catchError((error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete plant: $error')),
        );
      }
    });
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Plants",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: "Search your plants",
              labelStyle: const TextStyle(color: Colors.black),
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
                ? const Center(child:Text("No plants available to be searched"))
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
              color: Colors.green,
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
                ElevatedButton(
                  onPressed: () {
                    Map<String, dynamic> data = {
                      "name": _edtNameController.text,
                      "science_name": _edtScienceNameController.text,
                      "date": _edtDateController.text,
                    };

                    dbRef.child("Plants").push().set(data).then((value) {
                      if (mounted) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text("Plant details updated successfully")),
                        );
                      }
                    }).catchError((error) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
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
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MyPlantsDetailsPage(plant: plant, dbRef: dbRef),
          ),
        );

        if (result == true) {
          setState(() {});
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(FluentIcons.camera_24_regular,
                size: 50,
                color: Colors.green,
                semanticLabel: "photo",
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.plantData!.name!,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    plant.plantData!.scienceName!,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(LineIcons.calendarWithWeekFocus,
                          size: 16, color: Colors.grey),
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
            IconButton(icon: const Icon(
              Icons.delete,
              color: Colors.grey,
            ),
            onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
/// TODO: Add a photo to solve dark background color in dark mode.
/// TODO: add photo function when you call onTap function. Use icon button or elevated button
/// TODO: add edit symbol to the plant widget
/// TODO: change the structure of delete and edit functions.