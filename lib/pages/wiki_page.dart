import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON decoding
import 'wiki_plantdetail_page.dart'; // Import der Detailseite

class WikiPage extends StatefulWidget {
  const WikiPage({super.key});

  @override
  _WikiPageState createState() => _WikiPageState();
}

class _WikiPageState extends State<WikiPage> {
  List<dynamic> plantData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPlantData();
  }

  // Fetch plant data from the API
  Future<void> fetchPlantData() async {
    final response = await http.get(Uri.parse('https://laura194.github.io/plant_api/plantData.json'));

    if (response.statusCode == 200) {
      setState(() {
        plantData = json.decode(response.body);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load plant data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Wiki",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
        itemCount: plantData.length,
        separatorBuilder: (context, index) => const Divider(
          color: Colors.grey, // Light grey line
          thickness: 1, // Thickness of the line
          indent: 16, // Space from the start of the divider to the content
          endIndent: 16, // Space from the end of the divider to the content

        ),
        itemBuilder: (context, index) {
          final plant = plantData[index];
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
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlantDetailPage(plant: plant),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
