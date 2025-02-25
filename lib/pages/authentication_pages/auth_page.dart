import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
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
            return const CustomNavigationBar();
          } else {
            return LoginOrSignupPage(showSignupPage: showSignupPage);
          }
        },
      ),
    );
  }
}
