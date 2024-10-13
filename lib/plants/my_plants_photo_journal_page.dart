import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:plant_friends/themes/colors.dart';

import '../widgets/custom_snackbar.dart';

class PhotoJournalPage extends StatefulWidget {
  List<Map<String, String?>> photoJournal = [];
  final String? plantID;

  PhotoJournalPage({super.key, required this.plantID});

  @override
  State<PhotoJournalPage> createState() => _PhotoJournalPageState();
}

class _PhotoJournalPageState extends State<PhotoJournalPage> {
  final DatabaseReference dbRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://plant-friends-app-default-rtdb.europe-west1.firebasedatabase.app/',
  ).ref();
  final FirebaseStorage storage = FirebaseStorage.instance;
  File? _plantImage;
  final TextEditingController _edtDateController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _fetchPhotoJournalEntries();
  }
  Future<void> _fetchPhotoJournalEntries() async {
    dbRef.child('PhotoJournal').orderByChild('plantID').equalTo(widget.plantID).once().then((snapshot) {
      if (snapshot.snapshot.value != null) {
        Map<dynamic, dynamic> entries = snapshot.snapshot.value as Map<dynamic, dynamic>;

        setState(() {
          widget.photoJournal = entries.entries.map((entry) {
            Map<String, String?> newEntry = Map<String, String?>.from(entry.value as Map);
            newEntry['key'] = entry.key;
            return newEntry;
          }).toList();

          widget.photoJournal.sort((a, b) {
            final dateFormat = DateFormat('dd MMM yyyy');
            DateTime dateA = dateFormat.parse(a['date']!);
            DateTime dateB = dateFormat.parse(b['date']!);


            return dateB.compareTo(dateA);
          });
        });
      }
    }).catchError((error) {
    });
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        // Check if the current theme is dark or light
        final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

        return Theme(
          data: isDarkMode
              ? ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.green, // Header background color
              onPrimary: Colors.white, // Header text color
              surface: Colors.black,  // Background color
              onSurface: Colors.white, // Date text color
            ),
            dialogBackgroundColor: Colors.black, // Background color of the dialog
          )
              : ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green, // Header background color
              onPrimary: Colors.white, // Header text color
              surface: Colors.white,  // Background color
              onSurface: Colors.black, // Date text color
            ),
          ),
          child: child ?? Container(),
        );
      },
    );

    if (selectedDate != null) {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formattedDate = formatter.format(selectedDate);
      _edtDateController.text = formattedDate;
    }
  }


  Future<void> _addPhoto() async {
    DateTime? selectedDate;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    String? imageUrl = "";

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  _plantImage != null
                      ? Image.file(_plantImage!, height: 200)
                      : Text(
                    "No photo selected yet",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: isDarkMode ? Colors.grey : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Date Field
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextField(
                        controller: _edtDateController,
                        decoration: InputDecoration(
                          labelText: "Date",
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green, width: 2.0),
                          ),
                          suffixIcon: Icon(
                            Icons.calendar_today,
                            color: isDarkMode ? Colors.grey : Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // "Add a new plant photo" Button with Camera Icon
                  OutlinedButton.icon(
                    onPressed: () async {
                      await _pickImage();
                      setDialogState(() {}); // Update Dialog UI
                    },
                    icon: const Icon(Icons.camera_alt_rounded, color: Colors.green),
                    label: const Text(
                      "Add a new plant photo",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.green, // Ensures color visibility
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.green),
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (_plantImage == null) {
                      // Show error if no image is selected
                      CustomSnackbar snackbar = CustomSnackbar(context);
                      snackbar.showMessage('Please select an image before adding.', MessageType.info);
                      return; // Prevent further execution
                    }

                    if (_edtDateController.text.isEmpty) {
                      // Show error if no date is selected
                      CustomSnackbar snackbar = CustomSnackbar(context);
                      snackbar.showMessage('Please select a date before adding.', MessageType.info);

                      return; // Prevent further execution
                    }

                    // Show loading dialog
                    showDialog(
                      context: context,
                      barrierDismissible: false, // Prevent closing the dialog by tapping outside
                      builder: (BuildContext context) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF388E3C)), // Green color for loading
                          ),
                        );
                      },
                    );

                    // At this point, both image and date should be selected
                    imageUrl = await _uploadImageToFirebase(_plantImage!);

                    if (imageUrl != null) {
                      DateTime selectedDate = DateFormat('yyyy-MM-dd').parse(_edtDateController.text);
                      await _saveEntryToFirebase(imageUrl!, selectedDate);
                    }

                    Navigator.of(context).pop();  // Close the loading dialog

                    Navigator.of(context).pop();  // Close the main dialog after saving
                  },
                  child: const Text('Add Photo', style: TextStyle(color: seaGreen)),
                ),
              ],
            );
          },
        );
      },
    );
  }


  // Separate Firebase save logic into its own method
  Future<void> _saveEntryToFirebase(String imageUrl, DateTime selectedDate) async {
    String formattedDate = DateFormat('dd MMM yyyy').format(selectedDate);



    // New entry map
    Map<String, String?> newEntry = {
      'url': imageUrl,
      'date': formattedDate,
      'plantID': widget.plantID ?? 'Unknown Plant ID',
    };

    try {
      // Add the entry to Firebase
      DatabaseReference newEntryRef = dbRef.child("PhotoJournal").push();
      await newEntryRef.set(newEntry);

      // Update the state after saving to Firebase
      setState(() {
        newEntry['key'] = newEntryRef.key!;
        widget.photoJournal.insert(0, newEntry);
      });
      print('Photo entry saved successfully to Firebase.');
    } catch (e) {
      print('Error saving entry to Firebase: $e');
    }
  }

  void _deletePhoto(int index) {
    String? entryKey = widget.photoJournal[index]['key'];
    String? imageUrl = widget.photoJournal[index]['url'];  // Bild-URL extrahieren

    if (entryKey != null && imageUrl != null) {
      // Löschen des Bildes aus Firebase Storage
      Reference imageRef = FirebaseStorage.instance.refFromURL(imageUrl);

      // Löschen des Eintrags in der Datenbank und der Datei im Storage
      dbRef.child('PhotoJournal').child(entryKey).remove().then((_) async {
        try {
          // Bild aus Firebase Storage löschen
          await imageRef.delete();

          setState(() {
            widget.photoJournal.removeAt(index); // Update die UI
          });
        } catch (e) {
          CustomSnackbar snackbar = CustomSnackbar(context);
          snackbar.showMessage('Error deleting photo from storage: $e', MessageType.error);
        }
      }).catchError((error) {
        CustomSnackbar snackbar = CustomSnackbar(context);
        snackbar.showMessage('Error deleting photo from database: $error', MessageType.error);
      });
    } else {
      CustomSnackbar snackbar = CustomSnackbar(context);
      snackbar.showMessage('Error: Missing key or image URL for this photo entry.', MessageType.error);
    }
  }

  Future<String?> _uploadImageToFirebase(File imageFile) async {
    try {
      print("Upload started...");

      // Generate a unique filename for the image
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = FirebaseStorage.instance.ref().child('plantsPhotoJournal/$fileName');

      // Set optional metadata
      final SettableMetadata metadata = SettableMetadata(
        contentType: 'image/jpeg', // Ensure correct content-type
      );

      // Upload file to Firebase Storage with metadata
      UploadTask uploadTask = ref.putFile(imageFile, metadata);

      // Monitor upload progress (optional)
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        print("Upload progress: $progress%");
      });

      // Wait for the upload to complete
      await uploadTask;

      // Get the download URL and return it
      String downloadUrl = await ref.getDownloadURL();

      print("Upload complete! Download URL: $downloadUrl");
      return downloadUrl;

    } catch (e) {
      print("Error uploading image: $e");
      return null; // Return null in case of an error
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    final selectedSource = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Choose Image Source",
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
      },
    );

    if (mounted && selectedSource != null) {
      final pickedFile = await picker.pickImage(source: selectedSource);
      if (pickedFile != null) {
        setState(() {
          _plantImage = File(pickedFile.path); // Save the selected image
        });
        print('Image successfully picked: ${_plantImage?.path}');
      } else {
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
            mainAxisSize: MainAxisSize.min, // Ensure the icon and text are compact
            children: [
              Icon(
                icon,
                size: 50,
                color: const Color(0xFF388E3C), // Use accent color for the icons
              ),
              const SizedBox(height: 10), // Space between icon and text
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
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Photo Journal',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: widget.photoJournal.isEmpty
            ? const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.local_florist, // Pflanzen-Icon
                size: 60,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'No photos yet. \nAdd some photos to document \nyour plant\'s progress.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        )
            : ListView.builder(
          itemCount: widget.photoJournal.length,
          itemBuilder: (context, index) {
            return _buildTimelineTile(
              date: widget.photoJournal[index]['date']!,
              imageUrl: widget.photoJournal[index]['url']!,
              isFirst: index == 0,
              isLast: index == widget.photoJournal.length - 1,
              onTap: () => _showPhotoOverlay(widget.photoJournal[index]['url']!),
              isDarkMode: isDarkMode,
              onDelete: () => _confirmDelete(index), // Löschfunktion übergeben
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPhoto,
        child: const Icon(Icons.add_a_photo),
        backgroundColor: seaGreen,
      ),
    );

  }

  bool isLoading = true; // Zustandsvariable, die verfolgt, ob das Bild geladen wird

  Widget _buildTimelineTile({
    required String date,
    required String imageUrl,
    required bool isFirst,
    required bool isLast,
    required VoidCallback onTap,
    required bool isDarkMode,
    required VoidCallback onDelete,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            _buildTimelineDot(isFirst, isLast),
            if (!isLast) _buildDashedLine(),
          ],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: isDarkMode ? dmCardBG : lmCardBG,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Photo taken on $date',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              onPressed: onDelete, // Trigger the delete function
                              icon: const Icon(Icons.delete, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            imageUrl,
                            width: double.infinity,
                            height: 150,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                // Bild ist geladen
                                return child;
                              } else {
                                // Zeige den Ladeindikator an
                                return const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(seaGreen), // Grüner Ladeindikator
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineDot(bool isFirst, bool isLast) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: seaGreen,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 2),
      ),
    );
  }

  Widget _buildDashedLine() {
    return SizedBox(
      height: 180,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final boxHeight = constraints.constrainHeight();
          const dashHeight = 5.0;
          const dashSpace = 4.0;
          final dashCount = (boxHeight / (dashHeight + dashSpace)).floor();

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(dashCount, (_) {
              return Container(
                width: 2,
                height: dashHeight,
                color: Colors.lightGreen.shade900,
              );
            }),
          );
        },
      ),
    );
  }

  void _showPhotoOverlay(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Stack(
            children: [
              Container(
                color: Colors.black.withOpacity(0.7),
              ),
              Dialog(
                backgroundColor: Colors.transparent,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
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

  // Confirm deletion of photo
  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you really want to delete this photo entry?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel', style: TextStyle(color: seaGreen)),
            ),
            TextButton(
              onPressed: () {
                _deletePhoto(index); // Delete the photo if confirmed
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Yes', style: TextStyle(color: seaGreen)),
            ),
          ],
        );
      },
    );
  }
}
