import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plant_friends/test_home_page.dart';
import 'package:plant_friends/welcomePages/welcome_pages_controller.dart'; // Importiere den WelcomePagesController

class TestAuthPage extends StatelessWidget {
  const TestAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Falls der Benutzer eingeloggt ist, leite zur HomePage weiter
            return TestHomePage(); // Hier könntest du deine tatsächliche HomePage einfügen
          } else {
            // Falls der Benutzer nicht eingeloggt ist, zeige die Willkommensseiten (mit Swipe)
            return const WelcomePagesController(); // Nutze den PageView Controller
          }
        },
      ),
    );
  }
}
