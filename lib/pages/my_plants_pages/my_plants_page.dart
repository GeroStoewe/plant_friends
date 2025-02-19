import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:http/http.dart' as http;

import '../../themes/colors.dart';
import '../../widgets/custom_button_outlined_small.dart';
import 'add_new_plant_pages/add_new_plant.dart';
import 'add_new_plant_pages/add_new_plant_with_wiki_data.dart';
import 'my_plants_details_page.dart';
import 'other/plant.dart';

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
  final FirebaseStorage storage = FirebaseStorage.instance;

  final TextEditingController _edtNameController = TextEditingController();
  final TextEditingController _edtScienceNameController =
  TextEditingController();
  final TextEditingController _edtDateController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  late StreamSubscription<DatabaseEvent> _plantSubscription;
  List<Plant> plantList = [];
  List<Plant> filteredPlantList = [];
  File? _plantImage;



  // Function to get the current user's userId on FirebaseAuth
  String? _getUserId() {
    User? user = FirebaseAuth.instance.currentUser; // Get the currently logged-in user
    return user?.uid; // Return the userId (null if the user is not signed in)
  }

  @override
  void initState() {
    super.initState();

    _searchController.addListener(_onSearchChanged);
    String? currentUserId = _getUserId(); // Aktuelle UserID holen
    _plantSubscription = dbRef
        .child("Plants")
        .onValue
        .listen((event) {
      final List<Plant> updatedPlantList = [];
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        data.forEach((key, value) {
          PlantData plantData = PlantData.fromJSON(value as Map<dynamic, dynamic>);
          // Hier prüfen, ob die user_id mit der aktuellen UserID übereinstimmt
          if (plantData.userId == currentUserId) {
            updatedPlantList.add(Plant(key: key, plantData: plantData));
          }
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

    // Dispose of the text controllers used for the plant form
    _edtNameController.dispose();
    _edtScienceNameController.dispose();
    _edtDateController.dispose();

    // Set the plant image to null to clean up
    _plantImage = null;

    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      filteredPlantList = plantList.where((plant) =>
      plant.plantData!.name!.toLowerCase().contains(
          _searchController.text.toLowerCase()) ||
          plant.plantData!.scienceName!.toLowerCase().contains(
              _searchController.text.toLowerCase())).toList();
    });
  }

  Future<void> _identifyPlantWithApi(String imagePath) async {
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

      setState(() {
        _identifiedPlant = data['results'][0]['species']['scientificName'] ?? 'Unknown Plant';
      });

      print('Plant identified: $data');
    } else {
      final errorData = await response.stream.bytesToString();
      print('Error by plant identification: ${response.statusCode}');
      print('Error Details: $errorData');
    }
  }

  bool _isImagePicked = false;
  String _identifiedPlant = '';

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

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
                const Text(
                  "Take or pick a plant photo",
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
                      label: "Camera",
                      onTap: () => Navigator.of(context).pop(ImageSource.camera),
                    ),
                    _buildOptionCard(
                      icon: Icons.photo_library_rounded,
                      label: "Gallery",
                      onTap: () => Navigator.of(context).pop(ImageSource.gallery),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        }
    );

    if (mounted) {
      if (selectedSource != null) {
        final pickedFile = await picker.pickImage(source: selectedSource);
        if (pickedFile != null) {
          setState(() {
            _plantImage = File(pickedFile.path);// Save the selected image
            _isImagePicked = true;
          });
        }
        print('Image successfully picked: ${_plantImage?.path}');
        await _identifyPlantWithApi(_plantImage!.path);
      } else {
        setState(() {
          _isImagePicked = false; // No image selected
        });
        print('No image selected');
      }
    }
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

  Future<String?> _uploadImageToFirebase(File imageFile) async {
    try {
      print("Upload started...");

      // Get the current user's userId (can be null if the user is not signed in)
      String? userId = _getUserId();

      if (userId == null) {
        print("Error: User is not logged in. Cannot upload image.");
        return null; // Return null or handle the error as needed
      }

      // Create a unique filename for the image
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = FirebaseStorage.instance.ref().child('plants/$fileName');

      // Set metadata (optional, but recommended)
      final SettableMetadata metadata = SettableMetadata(
        contentType: 'image/jpeg', // Make sure to specify the correct content type
        customMetadata: {
          'userId': userId,  // Add the userId to the metadata
        },
      );

      // Upload the file to Firebase Storage with metadata
      UploadTask uploadTask = ref.putFile(imageFile, metadata);

      // Monitor upload progress (optional)
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        print("Upload progress: $progress%");
      });

      // Wait until the upload is complete
      await uploadTask;

      // Retrieve and return the download URL
      String downloadUrl = await ref.getDownloadURL();

      print("Upload completed! Download URL: $downloadUrl");
      return downloadUrl;

    } catch (e) {
      print("Error uploading image: $e");
      return null; // Return null if an error occurs
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Plants",
          style: Theme
              .of(context)
              .textTheme
              .headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Find your plants",
                labelStyle: TextStyle(

                  color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700,
                  fontSize: 16,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.green),
                filled: true,
                fillColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: isDarkMode ? Colors.grey.shade700 : Colors.green,
                      width: 1.5
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
                contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
              ),
            ),
          ),
          Expanded(
            child: filteredPlantList.isEmpty
                ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
                  Image.asset(
                    'lib/images/my_plants/plant_not_found.png',
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 16),
                Text(
                "No plants found in the search",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
           )

                : ListView.builder(
              itemCount: filteredPlantList.length,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemBuilder: (context, index) {

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: plantWidget(filteredPlantList[index]),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          showAddPlantOptions(context); // Zeigt den Dialog an
        },
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF4CAF50) : const Color(0xFF388E3C),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '+',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w300,
                color: isDarkMode ? Colors.black : Colors.white,
              ),
            ),
          ),
        ),
      ),

    );
  }

  void showAddPlantOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add new plant'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5, // Set button width to 50% of screen width
                  child: CustomButtonOutlinedSmall(
                    text: 'I have all the data for my plant',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNewPlantPage(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5, // Set button width to 50% of screen width
                  child: CustomButtonOutlinedSmall(
                    text: 'I need help',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddNewPlantWithWiki(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }





  Widget plantWidget(Plant plant) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MyPlantsDetailsPage(
                    plant: plant, dbRef: dbRef),
          ),
        );

        if (result == true) {
          setState(() {});
        }
      },
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            if (!isDarkMode) ...[
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ] else
              ...[
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                await _pickImage();
                if (_plantImage != null) {
                  String? oldImageUrl = plant.plantData?.imageUrl;

                  // If there is an image URL, delete the image from Firebase Storage
                  if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
                    await FirebaseStorage.instance.refFromURL(oldImageUrl).delete();
                  }

                  String? imageUrl = await _uploadImageToFirebase(_plantImage!);


                  if (imageUrl != null) {
                    // Step 2: Update the plant data in Firebase with the new image URL
                    Map<String, dynamic> updatedData = {
                      "image_url": imageUrl,
                      // Updating just the image URL in Firebase
                    };
                    // Firebase key stored in plant.key
                    DatabaseReference plantRef = dbRef.child("Plants").child(
                        plant.key!);
                    await plantRef.update(updatedData);

                    setState(() {
                      plant.plantData!.imageUrl = imageUrl;
                      _isImagePicked = true;
                    });
                  }
                }
              },
              child: Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 4,
                        color: isDarkMode ? darkSeaGreen : darkGreyGreen,
                      ),
                    ),
                    child: ClipOval(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: plant.plantData!.imageUrl != null && plant.plantData!.imageUrl!.isNotEmpty
                            ? Image.network(
                          plant.plantData!.imageUrl!, // Display the network image if it exists
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(seaGreen),
                                ),
                              ),
                            );

                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'lib/images/profile/noPlant_plant.webp',
                              fit: BoxFit.cover,
                            );
                          },
                        )
                            : Image.asset(
                          'lib/images/profile/noPlant_plant.webp', // Fallback to the asset image if no URL
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),// Camera icon overlay
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDarkMode ? darkSeaGreen : darkGreyGreen,
                      ),
                      child: Icon(Icons.camera_alt_rounded,
                        size: 14.0,
                        color: isDarkMode ? Colors.black87 : Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.plantData!.name!,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    plant.plantData!.scienceName!,
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey.shade400 : Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                          LineIcons.calendarWithWeekFocus,
                          size: 16,
                          color: isDarkMode ? const Color(0xFFB0BEC5) : Colors
                              .grey),
                      const SizedBox(width: 5),
                      Text(
                        plant.plantData!.date!,
                        style: TextStyle(
                          color: isDarkMode ? const Color(0xFFB0BEC5) : Colors
                              .grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
