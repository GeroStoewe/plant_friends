import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plant_friends/themes/colors.dart';

class PhotoJournalPage extends StatefulWidget {
  final List<Map<String, String>> photoJournal;

  const PhotoJournalPage({super.key, required this.photoJournal});

  @override
  State<PhotoJournalPage> createState() => _PhotoJournalPageState();
}

class _PhotoJournalPageState extends State<PhotoJournalPage> {
  // URL des Standardfotos, das immer hinzugefügt wird
  final String fixedPhotoUrl = 'https://media.istockphoto.com/id/1063250818/de/foto/bunte-tropische-bl%C3%A4tter-muster-der-schlange-pflanze-oder-mutter-in-law-zunge-und-sukkulente.jpg?s=2048x2048&w=is&k=20&c=RM4nv73VrNnTdXVR7kKtJSlonxRSee4wj78GtSJYf-4=';

  // Function to add a new photo with date
  Future<void> _addPhoto() async {
    // Formatierung des Datums in dd MMM yyyy (z. B. 08 Oct 2024)
    String formattedDate = DateFormat('dd MMM yyyy').format(DateTime.now());

    setState(() {
      widget.photoJournal.insert(0, {
        'url': fixedPhotoUrl,
        'date': formattedDate,
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    // Check if the current theme is dark mode
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Journal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: widget.photoJournal.isEmpty
            ? const Center(
          child: Text('No photos yet. Add some photos to document your plant\'s progress.'),
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
              isDarkMode: isDarkMode, // Pass the isDarkMode variable to the tile builder
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

  // Widget to build a timeline tile for each photo entry
  // Update the signature of _buildTimelineTile to accept isDarkMode
  Widget _buildTimelineTile({
    required String date,
    required String imageUrl,
    required bool isFirst,
    required bool isLast,
    required VoidCallback onTap,
    required bool isDarkMode, // Added parameter
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            _buildTimelineDot(isFirst, isLast),
            if (!isLast) _buildDashedLine(), // Custom dotted line
          ],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: onTap, // Show overlay on image tap
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: isDarkMode ? dmCardBG : lmCardBG, // Set card background based on theme
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Photo taken on $date',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget to build a timeline dot
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

  // Custom Widget für eine gepunktete Linie
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
                color: Colors.lightGreen.shade900, // Farbe der gepunkteten Linie
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
          onTap: () => Navigator.of(context).pop(), // Schließt das Overlay bei einem Klick irgendwo auf den Bildschirm
          child: Stack(
            children: [
              // Dunkler Hintergrund
              Container(
                color: Colors.black.withOpacity(0.7), // 70% Transparenz für den Hintergrund
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


}
