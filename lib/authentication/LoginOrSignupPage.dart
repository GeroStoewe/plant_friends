import 'package:flutter/material.dart';
import 'package:plant_friends/authentication/login_page.dart';
import 'package:plant_friends/authentication/signup_page.dart';

class LoginOrSignupPage extends StatefulWidget {
  const LoginOrSignupPage({super.key});

  @override
  State<LoginOrSignupPage> createState() => _LoginOrSignupPage();
}

class _LoginOrSignupPage extends State<LoginOrSignupPage> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        onTap: togglePages
      );
    } else {
      return SignupPage(
        onTap: togglePages,
      );
    }
  }
}