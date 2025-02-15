import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../themes/colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/square_tile.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Variables
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ScrollbarTheme(
        data: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(seaGreen),
    // Set scrollbar thumb color to green
    trackColor:
    WidgetStateProperty.all(Colors.grey.shade300), // Set track color
    ),
      child: Scaffold(
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
                      'lib/images/authentication/login_wallpaper.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              Positioned(
                  top: size.height * 0.42,
                  child: Scrollbar(
                    child: Container(
                      width: size.width,
                      height: size.height * 0.58,
                      decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0))),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 5),
                              Text("Welcome to PlantFriends",
                                  textAlign: TextAlign.center,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall),
                              const SizedBox(height: 25),
                              CustomTextField(
                                  controller: usernameController,
                                  icon: Icons.alternate_email_rounded,
                                  hintText: "Email Address",
                                  obscureText: false),
                              const SizedBox(height: 20),
                              CustomTextField(
                                controller: passwordController,
                                icon: Icons.lock_outline_rounded,
                                hintText: "Password",
                                obscureText: !isPasswordVisible,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Theme.of(context).hintColor,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isPasswordVisible = !isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const ForgotPasswordPage()));
                                },
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text.rich(TextSpan(children: [
                                        TextSpan(
                                            text: "Forgot Password? ",
                                            style: TextStyle(
                                                color: isDarkMode
                                                    ? dmLightGrey
                                                    : lmDarkGrey)),
                                        TextSpan(
                                            text: "Reset Here",
                                            style: TextStyle(
                                                color: Theme.of(context).hintColor))
                                      ])),
                                    ]),
                              ),
                              const SizedBox(height: 20),
                              CustomButton(onTap: login, text: "LOGIN"),
                              const SizedBox(height: 30),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                          thickness: 0.5,
                                          color: isDarkMode
                                              ? dmDarkGrey
                                              : lmLightGrey),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Text(
                                        "Or continue with",
                                        style: TextStyle(
                                            color: isDarkMode
                                                ? dmLightGrey
                                                : lmDarkGrey,
                                            fontSize: 18),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                          thickness: 0.5,
                                          color: isDarkMode
                                              ? dmDarkGrey
                                              : lmLightGrey),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: 80,
                                child: SquareTile(
                                        onTap: loginWithGoogle,
                                        imagePath:
                                            'lib/images/authentication/google_logo.png'),
                              ),
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: widget.onTap,
                                child: Center(
                                  child: Text.rich(TextSpan(children: [
                                    TextSpan(
                                        text: "New to PlantFriends? ",
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: isDarkMode
                                                ? dmLightGrey
                                                : lmDarkGrey)),
                                    TextSpan(
                                        text: "Create Account",
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Theme.of(context).hintColor))
                                  ])),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.7),
                  child: Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor)),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  void login() async {
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
    } else if (passwordController.text.isEmpty) {
      showErrorMessage('Password cannot be empty');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: usernameController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      showErrorMessage(e.code);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: darkGreyGreen,
            title: Center(
                child: Text(message,
                    style: Theme.of(context).textTheme.displayMedium)),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK",
                      style: Theme.of(context).textTheme.displaySmall))
            ],
          );
        });
  }

  loginWithGoogle() async {
    setState(() {
      isLoading = true; // loading indicator
    });

    try {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    if (gUser == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken:
          gAuth.accessToken,
          idToken: gAuth.idToken
      );
      // Sign in with Google credentials
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Autofill the email field with the Google account's email
      usernameController.text = gUser.email;

    // A success message or navigate to the next screen
    CustomSnackbar snackbar = CustomSnackbar(context);
    snackbar.showMessage('Logged in as ${gUser.email}', MessageType.success);
    } catch (e) {
      // Handle errors
      debugPrint('Google Login Error: $e');
      showErrorMessage('Failed to login with Google: ${e.toString()}');
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
  }
}
