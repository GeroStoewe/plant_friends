import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plant_friends/pages/wiki_pages/other/wiki_new_plant_request_form.dart';

import '../../../themes/colors.dart';
import '../../../widgets/custom_button_outlined_small.dart';
import '../../../widgets/custom_text_field.dart';
import '../wiki_plant_details_page.dart';

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

  // Store wishlist items
  Set<String> wishlist = {};

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
            case 'type':
              return plant['type']?.toLowerCase() == widget.filterValue?.toLowerCase();
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

  // Toggle a plant in the wishlist
  void toggleWishlist(String plantName) {
    setState(() {
      if (wishlist.contains(plantName)) {
        wishlist.remove(plantName);
      } else {
        wishlist.add(plantName);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return ScrollbarTheme(
      data: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(seaGreen), // Set scrollbar thumb color to green
        trackColor: WidgetStateProperty.all(Colors.grey.shade300), // Set track color
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _toTitleCase('${widget.filterType}: ${widget.filterValue ?? ''}'), // Convert to title case
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(seaGreen),))
            : Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextField(
                controller: searchController,
                icon: Icons.search,
                hintText: 'Search by name or scientific name',
                obscureText: false,
              ),
            ),
            Expanded(
              child: filteredPlantData.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'No plants match this filter.',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5, // Set button width to 50% of screen width
                        child: CustomButtonOutlinedSmall(
                          text: 'Request to Add a Plant',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RequestPlantFormPage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  : Scrollbar(
                child: ListView.builder(
                  itemCount: filteredPlantData.length,
                  itemBuilder: (context, index) {
                    final plant = filteredPlantData[index];
                    final plantName = plant['name'] ?? 'No name';

;                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8), // Rounded corners
                        child: plant['image_url'] != null
                            ? Image.network(
                          plant['image_url'],
                          width: 65,
                          height: 65,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return SizedBox(
                                width: 65,
                                height: 65,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                        : null,
                                    valueColor: const AlwaysStoppedAnimation<Color>(seaGreen),
                                  ),
                                ),
                              );
                            }
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error, color: Colors.red);
                          },
                        )
                            : const Icon(Icons.image_not_supported),
                      ),
                      title: Text(plant['name'] ?? 'No name'),
                      subtitle: Text(
                        '${plant['scientifical_name'] ?? 'N/A'}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          wishlist.contains(plantName) ? Icons.favorite : Icons.favorite_border,
                          color: wishlist.contains(plantName) ? Colors.red : null,
                        ),
                        onPressed: () {
                          toggleWishlist(plantName);
                        },
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
            ),
          ],
        ),
      ),
    );
  }

  // Converts a string to title case
  String _toTitleCase(String text) {
    return text.split(' ').map((str) {
      if (str.isEmpty) return '';
      return str[0].toUpperCase() + str.substring(1).toLowerCase();
    }).join(' ');
  }
}
