import 'package:flutter/material.dart';
import 'package:plant_friends/pages/authentication_pages/signup_page.dart';

import 'login_page.dart';

class LoginOrSignupPage extends StatefulWidget {

  final bool showSignupPage;

  const LoginOrSignupPage({super.key, this.showSignupPage = false});

  @override
  State<LoginOrSignupPage> createState() => _LoginOrSignupPageState();
}

class _LoginOrSignupPageState extends State<LoginOrSignupPage> {
  late bool showLoginPage;

  @override
  void initState() {
    super.initState();
    showLoginPage = !widget.showSignupPage; // Initialisiere basierend auf dem übergebenen Parameter
  }


  // Funktion, um zwischen Login und Signup hin- und herzuschalten
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showLoginPage) {
      return LoginPage(onTap: togglePages);
    } else {
      return SignupPage(onTap: togglePages);
    }
  }
}
