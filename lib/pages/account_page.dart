import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Account",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Colors.lightGreenAccent,
      ),
        body: const Center(
          child: Text(
              "Account",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold
              )
          ),
        )
    );
  }
}