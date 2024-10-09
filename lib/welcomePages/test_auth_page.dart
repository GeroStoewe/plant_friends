import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plant_friends/test_home_page.dart';
import 'package:plant_friends/welcomePages/welcome_page_1.dart';


class TestAuthPage extends StatelessWidget {
  const TestAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return TestHomePage(); // TODO: Change with actual HomePage
            } else {
              return const WelcomePage1();
            }
          }
      ),
    );
  }
}