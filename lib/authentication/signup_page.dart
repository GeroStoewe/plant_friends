import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:plant_friends/authentication/square_tile.dart';
import '../../themes/colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

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
                    'lib/authentication/images/signup_wallpaper.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            Positioned(
                top: size.height * 0.42,
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
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 5),
                          Text("Create your Account",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineMedium),
                          const SizedBox(height: 20),
                          CustomTextField(
                              controller: fullnameController,
                              icon: Icons.person_outline_rounded,
                              hintText: "Full Name",
                              obscureText: false),
                          const SizedBox(height: 15),
                          CustomTextField(
                              controller: usernameController,
                              icon: Icons.alternate_email_rounded,
                              hintText: "Email Address",
                              obscureText: false),
                          const SizedBox(height: 15),
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
                          const SizedBox(height: 20),
                          CustomButton(onTap: signup, text: "SIGN UP"),
                          const SizedBox(height: 25),
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
                                            : lmDarkGrey),
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
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SquareTile(
                                  onTap: signUpWithGoogle,
                                  imagePath:
                                      'lib/authentication/images/google_logo.png'),
                              SquareTile(
                                  imagePath: isDarkMode
                                      ? 'lib/authentication/images/apple_logo_dark_mode.png'
                                      : 'lib/authentication/images/apple_logo_light_mode.png'),
                              SquareTile(
                                  imagePath: isDarkMode
                                      ? 'lib/authentication/images/x_logo_dark_mode.png'
                                      : 'lib/authentication/images/x_logo_light_mode.png'),
                            ],
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: Center(
                              child: Text.rich(TextSpan(children: [
                                TextSpan(
                                    text: "Already have an Account? ",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: isDarkMode
                                            ? dmLightGrey
                                            : lmDarkGrey)),
                                TextSpan(
                                    text: "Login",
                                    style: TextStyle(
                                        fontSize: 18,
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
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
