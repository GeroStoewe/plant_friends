import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:plant_friends/pages/wiki_plantdetail_page.dart';

class PlantFilterResultPage extends StatefulWidget {
  final String filterType;
  final String? filterValue;

  const PlantFilterResultPage({required this.filterType, this.filterValue, super.key});

  @override
  _PlantFilterResultPageState createState() => _PlantFilterResultPageState();
}

class _PlantFilterResultPageState extends State<PlantFilterResultPage> {
  List<dynamic> plantData = [];
  List<dynamic> filteredPlantData = [];
  bool isLoading = true;
  String searchQuery = '';
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAndFilterPlantData();
    searchController.addListener(() {
      updateSearch(searchController.text);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Fetch plant data from the API
  Future<void> fetchAndFilterPlantData() async {
    final response = await http.get(Uri.parse('https://laura194.github.io/plant_api/plantData.json'));

    if (response.statusCode == 200) {
      List<dynamic> allPlantData = json.decode(response.body);
      setState(() {
        plantData = allPlantData.where((plant) {
          // Filtering logic based on filterType and filterValue
          switch (widget.filterType) {
            case 'water':
              return plant['water']?.toLowerCase() == widget.filterValue?.toLowerCase();
            case 'light':
              return plant['light']?.toLowerCase() == widget.filterValue?.toLowerCase();
            case 'difficulty':
              return plant['difficulty']?.toLowerCase() == widget.filterValue?.toLowerCase();
            case 'group':
              return plant['group']?.toLowerCase() == widget.filterValue?.toLowerCase();
            case 'all':
              return true; // For 'all', show all plants
            default:
              return false;
          }
        }).toList();
        filteredPlantData = plantData; // Initialize filteredPlantData
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load plant data');
    }
  }

  // Update the filtered list based on the search query
  void updateSearch(String query) {
    setState(() {
      searchQuery = query;
      filteredPlantData = plantData.where((plant) {
        final name = plant['name']?.toLowerCase() ?? '';
        final scientificalName = plant['scientifical_name']?.toLowerCase() ?? '';
        final searchLower = searchQuery.toLowerCase();
        return name.contains(searchLower) || scientificalName.contains(searchLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Filtered Plants - ${widget.filterType} ${widget.filterValue ?? ''}',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Search by name or scientific name',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: filteredPlantData.isEmpty
                ? const Center(child: Text('No plants match this filter.'))
                : ListView.builder(
              itemCount: filteredPlantData.length,
              itemBuilder: (context, index) {
                final plant = filteredPlantData[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                    child: plant['image_url'] != null
                        ? Image.network(
                      plant['image_url'],
                      width: 65,
                      height: 65,
                      fit: BoxFit.cover,
                    )
                        : const Icon(Icons.image_not_supported),
                  ),
                  title: Text(plant['name'] ?? 'No name'),
                  subtitle: Text(
                    'Scientific Name: ${plant['scientifical_name'] ?? 'N/A'}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlantWikiDetailPage(plant: plant),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
