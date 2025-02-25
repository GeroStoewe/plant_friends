import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plant_friends/pages/wiki_pages/filter_pages/plant_wishlist_page.dart';
import 'package:plant_friends/pages/wiki_pages/other/wiki_new_plant_request_form.dart';

import '../../../themes/colors.dart';
import '../../../widgets/custom_button_outlined_small.dart';
import '../../../widgets/custom_text_field.dart';
import '../wiki_plant_details_page.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  // for wishlist items
  Set<String> wishlist = {};

  void _clearWishlist() {
    setState(() {
      wishlist.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAndFilterPlantData();
    searchController.addListener(() {
      updateSearch(searchController.text);
    });
    _fetchWishlist(); // Fetch wishlist data when the page loads
    _listenForWishlistUpdates(); // Optional: Listen for real-time updates
  }

  void _fetchWishlist() async {
    final localizations = AppLocalizations.of(context)!;

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      final snapshot = await dbRef
          .child("Wishlists")
          .child(userId)
          .get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        final wishlistData = data.keys.cast<String>().toSet(); // Extract plant names from the map

        setState(() {
          wishlist = wishlistData; // Update the local wishlist state
        });
      }
    } catch (e) {
      _showSnackbar(context, '${localizations.failedToFetchWishlist} ${e.toString()}');
    }
  }

  void _listenForWishlistUpdates() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    dbRef
        .child("Wishlists")
        .child(userId)
        .onValue
        .listen((event) {
      final data = event.snapshot.value;
      if (data != null) {
        final wishlistData = (data as Map<dynamic, dynamic>).keys.cast<String>().toSet();

        setState(() {
          wishlist = wishlistData; // Update the local wishlist state
        });
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Fetch plant data from the API
  Future<void> fetchAndFilterPlantData() async {
    final localizations = AppLocalizations.of(context)!;

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
      throw Exception(localizations.failedToLoadData);
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

  // Helper function to show a Snackbar
  void _showSnackbar(BuildContext context, String message, {VoidCallback? onUndo}) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        action: onUndo != null
            ? SnackBarAction(
          label: localizations.undo,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          onPressed: onUndo,
        )
            : null,
        dismissDirection: DismissDirection.horizontal,
        duration: const Duration(seconds: 1),
      ),
    );
  }

// Toggle a plant in the wishlist with Snackbar notification
  void toggleWishlist(String plantName) {
    final localizations = AppLocalizations.of(context)!;
    final isAdding = !wishlist.contains(plantName);

    setState(() {
      if (isAdding) {
        wishlist.add(plantName);
      } else {
        wishlist.remove(plantName);
      }
    });

    // Show Snackbar with undo option
    _showSnackbar(
      context,
      isAdding ? '$plantName ${localizations.addedToWishlist} 🌱 ' : '$plantName ${localizations.removedFromWishlist}',
      onUndo: () {
        setState(() {
          if (isAdding) {
            wishlist.remove(plantName);
          } else {
            wishlist.add(plantName);
          }
        });
      },
    );

    // Sync with Firebase
    _syncWishlistWithFirebase(plantName, isAdding);
  }

// Sync wishlist with Firebase
  void _syncWishlistWithFirebase(String plantName, bool isAdding) async {
    final localizations = AppLocalizations.of(context)!;
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      if (isAdding) {
        await dbRef
            .child("Wishlists")
            .child(userId)
            .child(plantName)
            .set(true);
      } else {
        await dbRef
            .child("Wishlists")
            .child(userId)
            .child(plantName)
            .remove();
      }
    } catch (e) {
      // Handle errors (e.g., show an error Snackbar)
      _showSnackbar(context, '${localizations.failedToUpdateWishlist} ${e.toString()}');
    }
  }

// Firebase database reference
  final DatabaseReference dbRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
    'https://plant-friends-app-default-rtdb.europe-west1.firebasedatabase.app/',
  ).ref();


  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

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
          actions: [
        Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: TextButton.icon(
          iconAlignment: IconAlignment.end,
        icon: const Icon(
          Icons.favorite,
          color: Colors.red,
          size: 28.0,
        ),
        label: Text(
          localizations.wishlistTitle,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          backgroundColor: Colors.green, // Modern button color
        ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlantWishListPage(
                  wishlist: wishlist,
                  plantData: plantData,
                  onClearWishlist: _clearWishlist,
                ),
              ),
            );
          },
        ),
        ),
          ],
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
                hintText: localizations.searchByName,
                obscureText: false,
              ),
            ),
            Expanded(
              child: filteredPlantData.isEmpty
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
                  : Scrollbar(
                child: ListView.builder(
                  itemCount: filteredPlantData.length,
                  itemBuilder: (context, index) {
                    final plant = filteredPlantData[index];
                    final plantName = plant['name'] ?? localizations.noName;

                    return ListTile(
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
                      title: Text(plant['name'] ?? localizations.noName),
                      subtitle: Text(
                        '${plant['scientifical_name'] ?? 'N/A'}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing:
                      IconButton(
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
