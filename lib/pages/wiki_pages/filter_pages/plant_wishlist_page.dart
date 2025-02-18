import 'package:flutter/material.dart';
import '../../wiki_pages/other/wiki_page_filter_result_page.dart';

class PlantWishListPage extends StatelessWidget {
  final Set<String> wishlist;
  final List<dynamic> plantData;
  final VoidCallback onClearWishlist;

  const PlantWishListPage({
    required this.wishlist,
    required this.plantData,
    required this.onClearWishlist,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final wishlistPlants = plantData.where((plant) => wishlist.contains(plant['name'])).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
        actions: [
          if (wishlist.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_forever, color: Colors.red),
              onPressed: onClearWishlist, // Directly call the function to clear the wishlist
            ),
        ],
      ),
      body: wishlistPlants.isEmpty
          ? const Center(child: Text('Your wishlist is empty.'))
          : ListView(
        children: wishlistPlants.map((plant) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(plant['name']),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  // Call the function to remove the plant from the wishlist
                  // You might need to pass the plant name or ID to the callback
                  // For example: onRemoveFromWishlist(plant['name']);
                  Navigator.pop(context); // Only pop if you want to navigate back
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}