import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plant_friends/authentication/forgot_password_page.dart';
import 'package:plant_friends/authentication/signup_page.dart';
import 'package:plant_friends/authentication/square_tile.dart';
import 'package:plant_friends/themes/colors.dart';
import 'package:plant_friends/widgets/custom_button.dart';
import 'package:plant_friends/widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Variables
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordVisible = false;

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
                    'lib/authentication/images/login_wallpaper.jpg',
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
                          Text("Welcome to PlantFriends",
                              textAlign: TextAlign.center,
                              style:
                                  Theme.of(context).textTheme.headlineMedium),
                          const SizedBox(height: 20),
                          CustomTextField(
                              controller: usernameController,
                              icon: Icons.alternate_email_rounded,
                              hintText: "Email Address",
                              obscureText: false
                          ),
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
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordPage()));
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
                          const SizedBox(height: 15),
                          CustomButton(onTap: login, text: "LOGIN"),
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
                              const SquareTile(
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
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignupPage()));
                            },
                            child: Center(
                              child: Text.rich(TextSpan(children: [
                                TextSpan(
                                    text: "New to PlantFriends? ",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: isDarkMode
                                            ? dmLightGrey
                                            : lmDarkGrey)),
                                TextSpan(
                                    text: "Create Account",
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
          ],
        ),
      ),
    );
  }

  void login() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("Fields cannot be empty"),
          );
        },
      );
      return;
    }

    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: usernameController.text, password: passwordController.text);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        wrongEmailMessage();
      } else if (e.code == 'wrong-password') {
        wrongPasswordMessage();
      }
    }
  }

  void wrongEmailMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("Incorrect Email"),
          );
        });
  }

  void wrongPasswordMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("Incorrect Password"),
          );
        });
  }
}

// TODO: If red text and no alert box
/*
class _LoginPageState extends State<LoginPage> {
  // Variables
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordVisible = false;

  String emailErrorMessage = '';
  String passwordErrorMessage = '';
  String generalErrorMessage = '';

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
                    'lib/authentication/images/login_wallpaper.jpg',
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

                  // Padding and ScrollView
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 5),
                          Text(
                            "Welcome to PlantFriends",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 20),

                          // Email Input
                          CustomTextField(
                              controller: usernameController,
                              icon: Icons.alternate_email_rounded,
                              hintText: "Email Address",
                              obscureText: false
                          ),

                          // Email Error Message
                          if (emailErrorMessage.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                emailErrorMessage,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 14),
                              ),
                            ),
                          const SizedBox(height: 20),

                          // Password Input
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

                          // Password Error Message
                          if (passwordErrorMessage.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                passwordErrorMessage,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 14),
                              ),
                            ),

                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordPage()));
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
                          const SizedBox(height: 15),

                          // Login Button
                          CustomButton(onTap: login, text: "LOGIN"),

                          // General Error Message
                          if (generalErrorMessage.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Text(
                                generalErrorMessage,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 14),
                              ),
                            ),

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
                              const SquareTile(
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
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignupPage()));
                            },
                            child: Center(
                              child: Text.rich(TextSpan(children: [
                                TextSpan(
                                    text: "New to PlantFriends? ",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: isDarkMode
                                            ? dmLightGrey
                                            : lmDarkGrey)),
                                TextSpan(
                                    text: "Create Account",
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
          ],
        ),
      ),
    );
  }

  void login() async {
    setState(() {
      emailErrorMessage = '';
      passwordErrorMessage = '';
      generalErrorMessage = '';
    });

    if (usernameController.text.isEmpty) {
      setState(() {
        emailErrorMessage = 'Email cannot be empty';
      });
      return;
    }

    if (passwordController.text.isEmpty) {
      setState(() {
        passwordErrorMessage = 'Password cannot be empty';
      });
      return;
    }

    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: usernameController.text, password: passwordController.text);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        setState(() {
          generalErrorMessage = 'Incorrect Email';
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          generalErrorMessage = 'Incorrect Password';
        });
      }
    }
  }
}

 */