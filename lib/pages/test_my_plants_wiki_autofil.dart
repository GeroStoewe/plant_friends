import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WikiSearchPage extends StatefulWidget {
  @override
  _WikiSearchPageState createState() => _WikiSearchPageState();
}

class _WikiSearchPageState extends State<WikiSearchPage> {
  // Controller for the plant name and acquisition date
  final TextEditingController plantNameController = TextEditingController();
  final TextEditingController acquisitionDateController = TextEditingController();

  // Controllers for wiki fields
  final TextEditingController scientificalNameController = TextEditingController();
  final TextEditingController waterNeedsController = TextEditingController();
  final TextEditingController lightNeedsController = TextEditingController();
  final TextEditingController difficultyController = TextEditingController();
  final TextEditingController plantTypeController = TextEditingController();

  // For search functionality
  final TextEditingController searchController = TextEditingController();
  List<dynamic> wikiEntries = [];
  List<dynamic> filteredEntries = [];
  dynamic selectedPlant; // Track selected plant from Wiki
  bool showWiki = false;
  bool isLoading = true;
  bool isWikiDataFilled = false; // Controls whether fields are editable or not
  bool isOneButtonPressed = false;

  @override
  void initState() {
    super.initState();
    fetchWikiEntries();
  }

  @override
  void dispose() {
    plantNameController.dispose();
    acquisitionDateController.dispose();
    scientificalNameController.dispose();
    waterNeedsController.dispose();
    lightNeedsController.dispose();
    difficultyController.dispose();
    plantTypeController.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchWikiEntries() async {
    final response = await http.get(Uri.parse('https://laura194.github.io/plant_api/plantData.json'));

    if (response.statusCode == 200) {
      setState(() {
        wikiEntries = json.decode(response.body);
        filteredEntries = wikiEntries;
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load wiki entries');
    }
  }

  void updateSearch(String query) {
    setState(() {
      filteredEntries = wikiEntries.where((entry) {
        final name = entry['name']?.toLowerCase() ?? '';
        final scientificName = entry['scientifical_name']?.toLowerCase() ?? '';
        final searchLower = query.toLowerCase();
        return name.contains(searchLower) || scientificName.contains(searchLower);
      }).toList();
    });
  }

  void fillFieldsWithWikiData(dynamic selectedPlant) {
    setState(() {
      this.selectedPlant = selectedPlant;

      // Setze den wissenschaftlichen Namen
      String scientificalName = selectedPlant['scientifical_name'] ?? '';
      String name = selectedPlant['name'] ?? '';
      scientificalNameController.text = scientificalName + (name.isNotEmpty ? ' ($name)' : '');

      // Setze die anderen Felder
      waterNeedsController.text = selectedPlant['water'] ?? '';
      lightNeedsController.text = selectedPlant['light'] ?? '';
      difficultyController.text = selectedPlant['difficulty'] ?? '';
      plantTypeController.text = selectedPlant['type'] ?? '';

      // Setze die Felder als nicht editierbar, nachdem Wiki-Daten gefüllt sind
      isWikiDataFilled = true;

      // Verberge die Wiki-Suche nach der Auswahl
      showWiki = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Plant Entry')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: plantNameController,
                decoration: const InputDecoration(
                  labelText: 'Plant Name',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: acquisitionDateController,
                decoration: const InputDecoration(
                  labelText: 'Acquisition Date',
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showWiki = true;
                        isWikiDataFilled = false; // Reset editable fields
                        isOneButtonPressed = true;
                      });
                    },
                    child: const Text('Get Data from Wiki'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showWiki = false;
                        isWikiDataFilled = false; // Make fields editable
                        isOneButtonPressed = true;
                        // Clear the fields for manual entry
                        scientificalNameController.clear();
                        waterNeedsController.clear();
                        lightNeedsController.clear();
                        difficultyController.clear();
                        plantTypeController.clear();
                      });
                    },
                    child: const Text('Enter Data Manually'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (showWiki) ...[
                // Wrap the search bar and wiki list in a Container with a border
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          labelText: 'Search Wiki Entries',
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (value) => updateSearch(value),
                      ),
                      const SizedBox(height: 10),
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Container(
                        height: 200, // Scrollable area height
                        child: ListView.builder(
                          itemCount: filteredEntries.length,
                          itemBuilder: (context, index) {
                            final entry = filteredEntries[index];
                            return ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  entry['image_url'],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(entry['name'] ?? 'No Name'),
                              subtitle: Text(entry['scientifical_name'] ?? 'No Scientific Name'),
                              onTap: () {
                                fillFieldsWithWikiData(entry);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
              if (!showWiki && isOneButtonPressed || isWikiDataFilled  ) ...[
                // Show fields only when not showing Wiki or Wiki data is filled
                TextField(
                  controller: scientificalNameController,
                  decoration: const InputDecoration(
                    labelText: 'Scientifical Name',
                  ),
                  enabled: !isWikiDataFilled, // Disable if Wiki data is filled
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: waterNeedsController,
                  decoration: const InputDecoration(
                    labelText: 'Water Needs',
                  ),
                  enabled: !isWikiDataFilled, // Disable if Wiki data is filled
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: lightNeedsController,
                  decoration: const InputDecoration(
                    labelText: 'Light Needs',
                  ),
                  enabled: !isWikiDataFilled, // Disable if Wiki data is filled
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: difficultyController,
                  decoration: const InputDecoration(
                    labelText: 'Difficulty',
                  ),
                  enabled: !isWikiDataFilled, // Disable if Wiki data is filled
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: plantTypeController,
                  decoration: const InputDecoration(
                    labelText: 'Plant Type',
                  ),
                  enabled: !isWikiDataFilled, // Disable if Wiki data is filled
                ),
                const SizedBox(height: 20),
              ],
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Submit the form
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
