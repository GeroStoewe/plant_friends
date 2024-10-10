import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:plant_friends/themes/colors.dart';

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
            // Konvertierung der Map in Map<String, String?>, um optionale Strings zu unterstützen
            Map<String, String?> newEntry = Map<String, String?>.from(entry.value as Map);
            newEntry['key'] = entry.key;  // Speichere den Schlüssel für das Löschen
            return newEntry;
          }).toList();
        });
      }
    }).catchError((error) {
      print('Error fetching photo journal entries: $error');
    });
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
              title: const Text('Add New Photo'),
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
                  TextButton.icon(
                    onPressed: () async {
                      await _pickImage();
                      setDialogState(() {}); // Update Dialog UI
                    },
                    icon: const Icon(Icons.camera_alt_rounded),
                    label: Text(
                      "Add a new plant photo",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: isDarkMode ? Colors.grey : Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setDialogState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: const Text('Pick Date'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop(); // Dialog schließen
                    if (selectedDate != null && _plantImage != null) {
                      imageUrl = await _uploadImageToFirebase(_plantImage!);
                      if (imageUrl != null) {
                        await _saveEntryToFirebase(imageUrl!, selectedDate!);
                      }
                    }
                  },
                  child: const Text('Add Photo'),
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

    // Create a new entry
    Map<String, String?> newEntry = {
      'url': imageUrl,
      'date': formattedDate,
      'plantID': widget.plantID ?? 'Unknown Plant ID',
    };

    // Add entry to Firebase
    DatabaseReference newEntryRef = dbRef.child("PhotoJournal").push();

    // Wait for Firebase save to complete
    await newEntryRef.set(newEntry);

    // Update the state only after successfully saving to Firebase
    setState(() {
      newEntry['key'] = newEntryRef.key!;
      widget.photoJournal.insert(0, newEntry);
    });
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
          print("Photo successfully deleted from storage!");

          setState(() {
            widget.photoJournal.removeAt(index); // Update die UI
          });
        } catch (e) {
          // Fehler beim Löschen aus Storage
          print('Error deleting photo from storage: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting photo from storage: $e')),
          );
        }
      }).catchError((error) {
        // Fehler beim Löschen aus der Datenbank
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting photo from database: $error')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Missing key or image URL for this photo entry.')),
      );
    }
  }

  Future<String?> _uploadImageToFirebase(File imageFile) async {
    try {
      print("Upload startet...");

      // Erstelle einen einzigartigen Dateinamen für das Bild
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = FirebaseStorage.instance.ref().child('plantsPhotoJournal/$fileName');

      // Metadaten setzen (optional, aber empfohlen)
      final SettableMetadata metadata = SettableMetadata(
        contentType: 'image/jpeg', // Stelle sicher, dass du den richtigen Content-Typ angibst
      );

      // Datei zu Firebase Storage hochladen mit Metadaten
      UploadTask uploadTask = ref.putFile(imageFile, metadata);

      // Uploadfortschritt überwachen (optional)
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        print("Uploadfortschritt: $progress%");
      });

      // Warten, bis der Upload abgeschlossen ist
      await uploadTask;

      // Download-URL abrufen und zurückgeben
      String downloadUrl = await ref.getDownloadURL();

      print("Upload abgeschlossen! Download-URL: $downloadUrl");
      return downloadUrl;

    } catch (e) {
      print("Fehler beim Hochladen des Bildes: $e");
      return null; // Gib null zurück, falls ein Fehler auftritt
    }
  }

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
        }
    );

    if (mounted && selectedSource != null) {
      final pickedFile = await picker.pickImage(source: selectedSource);
      if (pickedFile != null) {
        setState(() {
          _plantImage = File(pickedFile.path); // Save the selected image
        });
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
                                return Center(
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
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deletePhoto(index); // Delete the photo if confirmed
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
