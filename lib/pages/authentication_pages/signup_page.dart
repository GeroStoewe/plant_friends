import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../themes/colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/square_tile.dart';

class SignupPage extends StatefulWidget {
  final Function()? onTap;

  const SignupPage({super.key, required this.onTap});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // Variables
  final fullnameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textScaleFactor = size.width / 400;
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
                    height: size.height * 0.5,
                    child: Image.asset(
                      'lib/images/authentication/signup_wallpaper.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              Positioned(
                  top: size.height * 0.4,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: size.width,
                    decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(40.0),
                            topRight: Radius.circular(40.0))),
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(size.width * 0.04),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: size.height * 0.0025),
                            Text("Create your Account",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontSize: 28 * textScaleFactor
                                )),
                            SizedBox(height: size.height * 0.025),
                            CustomTextField(
                                controller: fullnameController,
                                icon: Icons.person_outline_rounded,
                                hintText: "Full Name",
                                obscureText: false),
                            SizedBox(height: size.height * 0.02),
                            CustomTextField(
                                controller: usernameController,
                                icon: Icons.alternate_email_rounded,
                                hintText: "Email Address",
                                obscureText: false),
                            SizedBox(height: size.height * 0.02),
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
                            SizedBox(height: size.height * 0.025),
                            CustomButton(onTap: signup, text: "SIGN UP"),
                            SizedBox(height: size.height * 0.025),
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                      thickness: 0.8,
                                      color: isDarkMode
                                          ? dmDarkGrey
                                          : lmLightGrey),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Text(
                                    "Or continue with",
                                    style: TextStyle(
                                        color: isDarkMode
                                            ? dmLightGrey
                                            : lmDarkGrey,
                                    fontSize: 18 * textScaleFactor),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                      thickness: 0.8,
                                      color: isDarkMode
                                          ? dmDarkGrey
                                          : lmLightGrey),
                                ),
                              ],
                            ),
                            SizedBox(height: size.height * 0.02),
                            SizedBox(
                              height: size.height * 0.1,
                              width: size.width * 0.2,
                              child: SquareTile(
                                      onTap: signUpWithGoogle,
                                      imagePath:
                                          'lib/images/authentication/google_logo.png'
                              ),
                            ),
                            SizedBox(height: size.height * 0.02),
                            GestureDetector(
                              onTap: widget.onTap,
                              child: Center(
                                child: Text.rich(TextSpan(children: [
                                  TextSpan(
                                      text: "Already have an Account? ",
                                      style: TextStyle(
                                          fontSize: 16 * textScaleFactor,
                                          color: isDarkMode
                                              ? dmLightGrey
                                              : lmDarkGrey)),
                                  TextSpan(
                                      text: "Login",
                                      style: TextStyle(
                                          fontSize: 18 * textScaleFactor,
                                          color: Theme.of(context).hintColor))
                                ])),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.6),
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

  void signup() async {
    final emailRegex = RegExp(
      r'^[^@]+@[^@]+\.[^@]+$',
      caseSensitive: false,
    );

    if (fullnameController.text.isEmpty) {
      showErrorMessage('Full name cannot be empty');
      return;
    } else if (usernameController.text.isEmpty) {
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
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: usernameController.text, password: passwordController.text);

      User? user = userCredential.user;

      if (user != null) {
        await user.updateDisplayName(fullnameController.text);

        final prefs = await SharedPreferences.getInstance();
        final now = DateTime.now().toIso8601String();
        await prefs.setString('joinDate', now);

        await user.reload();
        user = FirebaseAuth.instance.currentUser;
      }
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

  signUpWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    if (gUser == null) return;

    final GoogleSignInAuthentication gAuth = await gUser.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
