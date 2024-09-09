import 'package:flutter/material.dart';

class PlantDetailPage extends StatelessWidget {
  final dynamic plant;

  const PlantDetailPage({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SizedBox(
        height: size.height,
        child: Stack(
          children: [
            backgroundImageAndHeader(size, context),
            backButton(size, context),
            Positioned(
              bottom: 0,
              child: Container(
                height: size.height * 0.55,
                width: size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        nameAndScientificName(),
                        const SizedBox(height: 30),
                        plantInfo(),
                        const SizedBox(height: 20), // Space for the description if needed
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container backgroundImageAndHeader(Size size, BuildContext context) {
    return Container(
      height: size.height * 0.50,
      width: size.width,
      child: GestureDetector(
        onTap: () {
          _showFullImageDialog(context);
        },
        child: ClipRRect(
          child: Image.network(
            plant['image_url'] ?? '',
            height: size.height * 0.50,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Positioned backButton(Size size, BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top, // Adjust for safe area
      left: 20,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget nameAndScientificName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          plant['name'] ?? 'No name',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Scientific Name: ${plant['scientifical_name'] ?? 'N/A'}',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Row plantInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        infoCard(
          icon: Icons.wb_sunny,
          color: Colors.green,
          backgroundColor: Colors.green.withOpacity(0.5),
          title: 'Light',
          value: plant['light'] ?? 'N/A',
        ),
        infoCard(
          icon: Icons.water_drop,
          color: Colors.blue,
          backgroundColor: Colors.blue.withOpacity(0.5),
          title: 'Water',
          value: plant['water'] ?? 'N/A',
        ),
        infoCard(
          icon: Icons.star,
          color: Colors.orange,
          backgroundColor: Colors.orange.withOpacity(0.5),
          title: 'Difficulty',
          value: plant['difficulty'] ?? 'N/A',
        ),
      ],
    );
  }

  Widget infoCard({
    required IconData icon,
    required Color color,
    required Color backgroundColor,
    required String title,
    required String value,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: backgroundColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 30,
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFullImageDialog(BuildContext context) {
    final imageUrl = plant['image_url'] ?? '';
    final shortenedUrl = imageUrl.length > 20 ? '${imageUrl.substring(0, 20)}...' : imageUrl;

    showDialog(
      context: context,
      barrierDismissible: true, // Allows closing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black.withOpacity(0.7), // Dark background
          child: Stack(
            children: [
              ClipRRect(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.50,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.black,
                          title: const Text(
                            'Image URL',
                            style: TextStyle(color: Colors.white),
                          ),
                          content: Text(
                            imageUrl,
                            style: const TextStyle(color: Colors.white),
                          ),
                          actions: [
                            TextButton(
                              child: const Text(
                                'Close',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the URL dialog
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    color: Colors.black.withOpacity(0.7),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(
                      shortenedUrl,
                      style: const TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
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
