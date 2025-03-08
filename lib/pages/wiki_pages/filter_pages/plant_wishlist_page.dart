import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlantWishListPage extends StatefulWidget {
  const PlantWishListPage({super.key});

  @override
  _PlantWishListPageState createState() => _PlantWishListPageState();
}

class _PlantWishListPageState extends State<PlantWishListPage> {
  final DatabaseReference dbRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://plant-friends-app-default-rtdb.europe-west1.firebasedatabase.app/',
  ).ref();

  late StreamSubscription<DatabaseEvent> _wishlistSubscription;
  Set<String> wishlist = {};
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid; // Benutzer-ID abrufen
    _fetchWishlist();
  }

  @override
  void dispose() {
    _wishlistSubscription.cancel();
    super.dispose();
  }

  // Wishlist aus Firebase abrufen
  void _fetchWishlist() {
    if (userId == null) return;

    _wishlistSubscription = dbRef.child("Wishlists").child(userId!).onValue.listen((event) {
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

  // Pflanze aus der Wunschliste entfernen
  void _removeFromWishlist(String plantName) {
    if (userId == null) return;

    dbRef.child("Wishlists").child(userId!).child(plantName).remove();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.myWishlist,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: wishlist.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              localizations.wishlistEmpty,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'lib/images/wiki/category/wish-list.png',
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      )
          : ListView(
        children: wishlist.map((plantName) {
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
                    borderRadius: BorderRadius.circular(16), // Abgerundete Ecken
                    child: Image.asset(
                      'lib/images/wiki/category/wishlist-plant.png', // Immer dasselbe Bild
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16), // Abstand zwischen Bild und Text
                  Expanded(
                    child: Text(
                      plantName, // Pflanzenname
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      _removeFromWishlist(plantName);
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
