import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TestHomePage extends StatelessWidget {
  TestHomePage({super.key});

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: logout,
              icon: const Icon(Icons.logout_rounded)
          )
        ],
      ),
      body: Center(
          child: Text(
              "LOGGED IN AS: ${user!.email!}",
            style: const TextStyle(fontSize: 28),
          )
      ),
    );
  }

  void logout() {
    FirebaseAuth.instance.signOut();
  }
}