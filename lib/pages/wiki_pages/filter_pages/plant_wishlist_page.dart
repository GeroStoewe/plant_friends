import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../../wiki_pages/other/wiki_page_filter_result_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class PlantWishListPage extends StatefulWidget {
  final List<dynamic> plantData;

  const PlantWishListPage({
    required this.plantData,
    super.key, required Set<String> wishlist, required void Function() onClearWishlist,
  });

  @override
  _PlantWishListPageState createState() => _PlantWishListPageState();
}

class _PlantWishListPageState extends State<PlantWishListPage> {
  final DatabaseReference dbRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
    'https://plant-friends-app-default-rtdb.europe-west1.firebasedatabase.app/',
  ).ref();

  late StreamSubscription<DatabaseEvent> _wishlistSubscription;
  Set<String> wishlist = {};
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid; // Get current user ID
    _fetchWishlist();
  }

  @override
  void dispose() {
    _wishlistSubscription.cancel();
    super.dispose();
  }

  // Fetch wishlist data from Firebase
  void _fetchWishlist() {
    if (userId == null) return;

    _wishlistSubscription = dbRef
        .child("Wishlists")
        .child(userId!)
        .onValue
        .listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          wishlist = Set<String>.from(data.keys);
        });
      } else {
        setState(() {
          wishlist = {};
        });
      }
    });
  }

  // Add item to wishlist
  void _addToWishlist(String plantName) {
    if (userId == null) return;

    dbRef
        .child("Wishlists")
        .child(userId!)
        .child(plantName)
        .set(true)
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$plantName added to wishlist')),
      );
    });
  }

  // Remove item from wishlist
  void _removeFromWishlist(String plantName) {
    if (userId == null) return;

    dbRef
        .child("Wishlists")
        .child(userId!)
        .child(plantName)
        .remove()
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$plantName removed from wishlist')),
      );
    });
  }

  // Clear entire wishlist
  void _clearWishlist() {
    if (userId == null) return;

    dbRef
        .child("Wishlists")
        .child(userId!)
        .remove()
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Wishlist cleared')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final wishlistPlants = widget.plantData
        .where((plant) => wishlist.contains(plant['name']))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
        actions: [
          if (wishlist.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_forever, color: Colors.red),
              onPressed: _clearWishlist,
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
                  _removeFromWishlist(plant['name']);
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
///
/// TODO
/// UI trash
/// errors
///
///
/// change the pic of the newly added plant with KI photos randomly or as placeholder