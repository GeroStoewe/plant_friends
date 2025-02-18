import 'package:flutter/material.dart';

class PlantWishListPage extends StatelessWidget {
  final Set<String> wishlist;
  final List<dynamic> plantData;

  const PlantWishListPage({required this.wishlist, required this.plantData, super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistPlants = plantData.where((plant) => wishlist.contains(plant['name'])).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
      ),
      body: wishlistPlants.isEmpty
          ? const Center(child: Text('Your wishlist is empty.'))
          : ListView.builder(
        itemCount: wishlistPlants.length,
        itemBuilder: (context, index) {
          final plant = wishlistPlants[index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
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
              '${plant['scientifical_name'] ?? 'N/A'}',
              style: const TextStyle(color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}

//TODO: fix the list

