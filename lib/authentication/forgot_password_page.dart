import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plant_friends/authentication/auth_page.dart';
import '../../themes/colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // Variables
  final usernameController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  width: size.width,
                  height: size.height * 0.45,
                  child: Image.asset(
                    'lib/authentication/images/forgotpassword_wallpaper.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            backButton(size, context),
            Positioned(
              top: size.height * 0.42,
              child: Container(
                width: size.width,
                height: size.height * 0.58,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 5),
                        Text(
                          "Reset your Password",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 40),
                        CustomTextField(
                          controller: usernameController,
                          icon: Icons.alternate_email_rounded,
                          hintText: "Please enter your Email Address",
                          obscureText: false,
                        ),
                        const SizedBox(height: 30),
                        CustomButton(
                          onTap: resetPassword,
                          text: "RESET PASSWORD",
                        ),
                        const SizedBox(height: 260),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AuthPage(),
                              ),
                            );
                          },
                          child: Center(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Already have an Account? ",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: isDarkMode ? dmLightGrey : lmDarkGrey,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Login",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future resetPassword() async {
    final emailRegex = RegExp(
      r'^[^@]+@[^@]+\.[^@]+$',
      caseSensitive: false,
    );

    if (usernameController.text.isEmpty) {
      showErrorMessage('Email address cannot be empty');
      return;
    } else if (!emailRegex.hasMatch(usernameController.text)) {
      showErrorMessage('Invalid email address format');
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ),
        );
      },
    );

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: usernameController.text.trim(),
      );
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthPage()),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showErrorMessage(e.code);
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: darkGreyGreen,
          title: Center(
            child: Text(message, style: Theme.of(context).textTheme.displayMedium),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK", style: Theme.of(context).textTheme.displaySmall),
            ),
          ],
        );
      },
    );
  }

  Positioned backButton(Size size, BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Positioned(
      top: MediaQuery.of(context).padding.top, // Adjust for safe area
      left: 20,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: GestureDetector(
          onTap: () {
            print("BBP");
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: isDarkMode ? dmLightGrey : lmDarkGrey,
          ),
        ),
      ),
    );
  }
}
