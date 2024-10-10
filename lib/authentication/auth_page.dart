import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:plant_friends/authentication/login_page.dart';
import 'package:plant_friends/main.dart';
import 'package:plant_friends/pages/profile_page.dart';
import 'package:plant_friends/test_home_page.dart';
import 'LoginOrSignupPage.dart';

class AuthPage extends StatelessWidget {
  final bool showSignupPage;

  const AuthPage({super.key, this.showSignupPage = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const CustomNavigationBar(); // TODO: Change with actual HomePage
          } else {
            return LoginOrSignupPage(showSignupPage: showSignupPage);
          }
        },
      ),
    );
  }
}
