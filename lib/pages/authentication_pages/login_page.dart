import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../themes/colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/square_tile.dart';
import 'forgot_password_page.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    double textScaleFactor = size.width / 400;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context)!;

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
                      'lib/images/authentication/login_wallpaper.jpg',
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
                            Text(localizations.loginTitle,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontSize: 28 * textScaleFactor,
                                ),
                            ),
                            SizedBox(height: size.height * 0.025),
                            CustomTextField(
                                controller: usernameController,
                                icon: Icons.alternate_email_rounded,
                                hintText: localizations.email,
                                obscureText: false),
                            SizedBox(height: size.height * 0.02),
                            CustomTextField(
                              controller: passwordController,
                              icon: Icons.lock_outline_rounded,
                              hintText: localizations.password,
                              obscureText: !isPasswordVisible,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  size: 18 * textScaleFactor,
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
                            SizedBox(height: size.height * 0.01),
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
                                          text: localizations.forgotPasswordQuestion,
                                          style: TextStyle(
                                              fontSize: 14 * textScaleFactor,
                                              color: isDarkMode
                                                  ? dmLightGrey
                                                  : lmDarkGrey)),
                                      TextSpan(
                                          text: localizations.resetHere,
                                          style: TextStyle(
                                              fontSize: 16 * textScaleFactor,
                                              color: Theme.of(context).hintColor))
                                    ])),
                                  ]),
                            ),
                            SizedBox(height: size.height * 0.02),
                            CustomButton(onTap: login, text: localizations.login),
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
                                    localizations.continueWithQuestion,
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
                                      onTap: loginWithGoogle,
                                      imagePath:
                                          'lib/images/authentication/google_logo.png'),
                            ),
                            SizedBox(height: size.height * 0.02),
                            GestureDetector(
                              onTap: widget.onTap,
                              child: Center(
                                child: Text.rich(TextSpan(children: [
                                  TextSpan(
                                      text: localizations.newQuestion,
                                      style: TextStyle(
                                          fontSize: 16 * textScaleFactor,
                                          color: isDarkMode
                                              ? dmLightGrey
                                              : lmDarkGrey)),
                                  TextSpan(
                                      text: localizations.createAccount,
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

  void login() async {
    final emailRegex = RegExp(
      r'^[^@]+@[^@]+\.[^@]+$',
      caseSensitive: false,
    );

    final localizations = AppLocalizations.of(context)!;

    if (usernameController.text.isEmpty) {
      showErrorMessage(localizations.emailEmptyErrorMessage);
      return;
    } else if (!emailRegex.hasMatch(usernameController.text)) {
      showErrorMessage(localizations.emailInvalidErrorMessage);
      return;
    } else if (passwordController.text.isEmpty) {
      showErrorMessage(localizations.passwordEmptyErrorMessage);
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
    final localizations = AppLocalizations.of(context)!;

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
                  child: Text(localizations.ok,
                      style: Theme.of(context).textTheme.displaySmall))
            ],
          );
        });
  }

  loginWithGoogle() async {
    final localizations = AppLocalizations.of(context)!;

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
    snackbar.showMessage('${localizations.loggedInMessage} ${gUser.email}', MessageType.success);
    } catch (e) {
      // Handle errors
      debugPrint('Google Login Error: $e');
      showErrorMessage('${localizations.googleLoginError} ${e.toString()}');
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
  }
}
