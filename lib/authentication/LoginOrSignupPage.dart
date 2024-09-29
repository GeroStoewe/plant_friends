import 'package:flutter/material.dart';
import 'package:plant_friends/authentication/login_page.dart';
import 'package:plant_friends/authentication/signup_page.dart';

class LoginOrSignupPage extends StatefulWidget {
  const LoginOrSignupPage({super.key});

  @override
  State<LoginOrSignupPage> createState() => _LoginOrSignupPageState();
}

class _LoginOrSignupPageState extends State<LoginOrSignupPage> {
  bool showLoginPage = true;

  // Funktion, um zwischen Login und Signup hin- und herzuschalten
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showLoginPage
          ? LoginPage(onTap: togglePages) // Übergabe der onTap-Funktion an LoginPage
          : SignupPage(onTap: togglePages), // Übergabe der onTap-Funktion an SignupPage
    );
  }
}
