import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../../themes/colors.dart';
import '../../../widgets/custom_button_outlined_small.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../wiki_pages/other/wiki_new_plant_request_form.dart';
import '../../wiki_pages/wiki_plant_details_page.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddNewPlantWithWiki extends StatefulWidget {
  const AddNewPlantWithWiki({super.key});

  @override
  _AddNewPlantWithWikiState createState() => _AddNewPlantWithWikiState();
}

class _AddNewPlantWithWikiState extends State<AddNewPlantWithWiki> {
  final TextEditingController searchController = TextEditingController();
  bool _isImagePicked = false;
  String _identifiedPlant = '';

  Future<void> _identifyPlantWithApi(String imagePath) async {
    final localizations = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      barrierDismissible: false, // Der Nutzer kann den Dialog nicht schließen
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(seaGreen),
          ),
        );
      },
    );

    try {
      final apiKey = '2b10i3KvRsGFF7xGiCaTQRWe';
      final project = 'all';
      final url = Uri.parse(
        'https://my-api.plantnet.org/v2/identify/$project?api-key=$apiKey',
      );

      final request = http.MultipartRequest('POST', url)
        ..files.add(await http.MultipartFile.fromPath('images', imagePath));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final data = json.decode(responseData);

        if (data['results'] == null || data['results'].isEmpty) {
          throw Exception('Keine Pflanze gefunden.');
        }

      final identifiedPlant = data['results'][0]['species']['scientificName'] ?? localizations.unknownPlant;


        setState(() {
          _identifiedPlant = identifiedPlant;
          searchController.text = identifiedPlant.split(' ')[0]; // Automatisch in die Suchzeile einfügen
        });

        print('Plant identified: $data');

        CustomSnackbar(context).showMessage(
          'Plant successfully identified.',
          MessageType.success,
        );
      } else {
        throw Exception('No plant could be identified.');
      }
    } catch (e) {
      CustomSnackbar(context).showMessage(
        e.toString(),
        MessageType.error,
      );
    } finally {
      // Ladebalken entfernen
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    }
  }



  Future<void> _pickImage(BuildContext context) async {
    File? _plantImage;
    final ImagePicker picker = ImagePicker();
    final localizations = AppLocalizations.of(context)!;

    final selectedSource = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AutoSizeText(
                localizations.takeOrPickPhoto,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
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
                    onTap: () => Navigator.of(context).pop(ImageSource.gallery),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );

    if (selectedSource != null) {
      final pickedFile = await picker.pickImage(source: selectedSource);
      if (pickedFile != null) {
        setState(() {
          _plantImage = File(pickedFile.path);
          _isImagePicked = true;
        });
        print('Image successfully picked: ${_plantImage?.path}');
        await _identifyPlantWithApi(_plantImage!.path);
        // Rufe hier die API-Funktion auf, wenn nötig.
      } else {
        print('No image selected');
      }
    }
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String label,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.myPlants,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          TextButton.icon(
            icon: const Icon(
              Icons.search,
              color: seaGreen,
            ),
            label: Text(
              localizations.aiRecognition,
              style: TextStyle(
                color: seaGreen,
                fontSize: 12,
              ),
            ),
            onPressed: () async {
              await _pickImage(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: _FilteredPlantList(searchController: searchController),
          ),
        ],
      ),
    );
  }
}



  class _FilteredPlantList extends StatefulWidget {
  const _FilteredPlantList({super.key, required this.searchController});
  final TextEditingController searchController; // Controller als Parameter
  @override
  _FilteredPlantListState createState() => _FilteredPlantListState();
}
class _FilteredPlantListState extends State<_FilteredPlantList> {
  List<dynamic> plantData = [];
  List<dynamic> filteredPlantData = [];
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchAndFilterPlantData();

    // Hinzufügen eines Listeners zu `widget.searchController`
    widget.searchController.addListener(() {
      updateSearch(widget.searchController.text);
    });
  }

  @override
  void dispose() {
    // Entferne den Listener vor der Entsorgung des Widgets
    widget.searchController.removeListener(() {
      updateSearch(widget.searchController.text);
    });
    super.dispose();
  }

  Future<void> fetchAndFilterPlantData() async {
    final localizations = AppLocalizations.of(context)!;
    final response = await http.get(Uri.parse('https://laura194.github.io/plant_api/plantData.json'));

    if (response.statusCode == 200) {
      List<dynamic> allPlantData = json.decode(response.body);
      setState(() {
        plantData = allPlantData;
        filteredPlantData = plantData;
        isLoading = false;
      });
    } else {
      throw Exception(localizations.failedToLoadData);
    }
  }

  void updateSearch(String query) {
    setState(() {
      filteredPlantData = plantData.where((plant) {
        final name = plant['name']?.toLowerCase() ?? '';
        final scientificalName = plant['scientifical_name']?.toLowerCase() ?? '';
        final searchLower = query.toLowerCase();
        return name.contains(searchLower) || scientificalName.contains(searchLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: widget.searchController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: localizations.searchByName,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: seaGreen, // Farbe des Rahmens, wenn fokussiert
                  width: 2.0, // Dicke des Rahmens
                ),
              ),
            ),
          ),

        ),
        Expanded(
          child: isLoading
              ? const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(seaGreen),
            ),
          )
              : filteredPlantData.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  localizations.noPlantsMatch,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5, // Set button width to 50% of screen width
                    child: CustomButtonOutlinedSmall(
                      text: localizations.request,
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
              : ListView.builder(
            itemCount: filteredPlantData.length,
            itemBuilder: (context, index) {
              final plant = filteredPlantData[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
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
                        return const SizedBox(
                          width: 65,
                          height: 65,
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(seaGreen),
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
                title: Text(plant['name'] ?? localizations.noName),
                subtitle: Text(
                  plant['scientifical_name'] ?? 'N/A',
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
    );
  }
}