import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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

 /* // Add item to wishlist
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
  } */

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

/*  // Clear entire wishlist
  void _clearWishlist() {
    if (userId == null) return;

    dbRef
        .child("Wishlists")
        .child(userId!)
        .remove()
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wishlist cleared')),
      );
    });
  } */

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final wishlistPlants = widget.plantData
        .where((plant) => wishlist.contains(plant['name']))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Wishlist",
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
      body: wishlistPlants.isEmpty
          ? Center(
          child:
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                const Text(
                  'Your wishlist is empty. \n '
                      'Go to Wiki and tap the heart \n '
                      'button to add plants.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                  const SizedBox(height: 16),
                  Image.asset(
                  'lib/images/wiki/category/wish-list.png',
                  width: 300,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16),

                ]
              )
          )
            :ListView(
            children: wishlistPlants.map((plant) {
            return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
            children: [
            ClipRRect(
            borderRadius: BorderRadius.circular(12), // Rounded image
            child: Image.asset(
            'lib/images/wiki/category/wishlist-plant.png',
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            ),
           ),
            const SizedBox(width: 16), // Space between image and text
            Expanded(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(
            plant['name' ],
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            ),
           ),
            const SizedBox(height: 4),
            ],
           ),
          ),
            IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () {
            _removeFromWishlist(plant['name']);
            },
          ),
        ],
       ),
      ),
     );
    }).toList(),
   ),
  );
 }
}
