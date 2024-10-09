import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plant_friends/themes/colors.dart';

class PhotoJournalPage extends StatefulWidget {
  List<Map<String, String>> photoJournal = [];
  final String? plantID;

  PhotoJournalPage({super.key, required this.plantID});

  @override
  State<PhotoJournalPage> createState() => _PhotoJournalPageState();
}

class _PhotoJournalPageState extends State<PhotoJournalPage> {
  final String fixedPhotoUrl = 'https://media.istockphoto.com/id/1063250818/de/foto/bunte-tropische-bl%C3%A4tter-muster-der-schlange-pflanze-oder-mutter-in-law-zunge-und-sukkulente.jpg?s=2048x2048&w=is&k=20&c=RM4nv73VrNnTdXVR7kKtJSlonxRSee4wj78GtSJYf-4=';

  final DatabaseReference dbRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://plant-friends-app-default-rtdb.europe-west1.firebasedatabase.app/',
  ).ref();
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    _fetchPhotoJournalEntries();
  }
  Future<void> _fetchPhotoJournalEntries() async {
    dbRef.child('PhotoJournal').orderByChild('plantID').equalTo(widget.plantID).once().then((snapshot) {
      Map<dynamic, dynamic> entries = snapshot.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        widget.photoJournal = entries.entries.map((entry) {
          Map<String, String> newEntry = Map<String, String>.from(entry.value);
          newEntry['key'] = entry.key;  // Save the key for deletion
          return newEntry;
        }).toList();
      });
        });
  }

  Future<void> _addPhoto() async {
    TextEditingController urlController = TextEditingController();
    DateTime? selectedDate;

    // Öffnet einen Dialog für URL und Datumseingabe
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Photo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: urlController,
                decoration: const InputDecoration(
                  labelText: 'Photo URL',
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
                    selectedDate = pickedDate;
                  }
                },
                child: const Text('Pick Date'),
              ),
              if (selectedDate != null)
                Text('Selected Date: ${DateFormat('dd MMM yyyy').format(selectedDate!)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Abbrechen
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (urlController.text.isNotEmpty && selectedDate != null) {
                  Navigator.of(context).pop(); // Dialog schließen
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a URL and select a date.')),
                  );
                }
              },
              child: const Text('Add Photo'),
            ),
          ],
        );
      },
    );

    if (urlController.text.isNotEmpty && selectedDate != null) {
      String formattedDate = DateFormat('dd MMM yyyy').format(selectedDate!);

      // Neuen Eintrag erstellen
      Map<String, String> newEntry = {
        'url': urlController.text,
        'date': formattedDate,
        'plantID': widget.plantID ?? 'Unknown Plant ID',
      };

      // Eintrag zur Firebase-Datenbank hinzufügen
      DatabaseReference newEntryRef = dbRef.child("PhotoJournal").push();
      newEntryRef.set(newEntry).then((_) {
        setState(() {
          newEntry['key'] = newEntryRef.key!;
          widget.photoJournal.insert(0, newEntry);
        });
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding photo: $error')),
        );
      });
    }
  }


  void _deletePhoto(int index) {
    String? entryKey = widget.photoJournal[index]['key'];

    if (entryKey != null) {
      dbRef.child('PhotoJournal').child(entryKey).remove().then((_) {
        setState(() {
          widget.photoJournal.removeAt(index);
        });
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting photo: $error')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Missing key for this photo entry.')),
      );
    }
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
