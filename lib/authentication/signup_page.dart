import 'package:flutter/material.dart';
import 'package:plant_friends/authentication/login_page.dart';
import 'package:plant_friends/authentication/square_tile.dart';

import '../../themes/colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  // Variables
  final fullnameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

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
                          topRight: Radius.circular(30.0)
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 5),
                          Text(
                              "Create your Account",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineMedium
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                              controller: fullnameController,
                              icon: Icons.person_outline_rounded,
                              hintText: "Full Name",
                              obscureText: false
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(
                              controller: usernameController,
                              icon: Icons.alternate_email_rounded,
                              hintText: "Email Address",
                              obscureText: false
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(
                              controller: passwordController,
                              icon: Icons.lock_outline_rounded,
                              hintText: "Password",
                              obscureText: true
                          ),
                          const SizedBox(height: 20),
                          CustomButton(
                              onTap: signup,
                              text: "SIGN UP"
                          ),
                          const SizedBox(height: 25),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                      thickness: 0.5,
                                      color: isDarkMode ? dmDarkGrey : lmLightGrey
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Text(
                                    "Or continue with",
                                    style: TextStyle(
                                        color: isDarkMode ? dmLightGrey : lmDarkGrey
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                      thickness: 0.5,
                                      color: isDarkMode ? dmDarkGrey : lmLightGrey
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SquareTile(imagePath: 'lib/authentication/images/google_logo.png'),
                              SquareTile(imagePath: isDarkMode ? 'lib/authentication/images/apple_logo_dark_mode.png' : 'lib/authentication/images/apple_logo_light_mode.png'),
                              SquareTile(imagePath: isDarkMode ? 'lib/authentication/images/x_logo_dark_mode.png' : 'lib/authentication/images/x_logo_light_mode.png'),
                            ],
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()
                                  )
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
                                                color: isDarkMode ? dmLightGrey : lmDarkGrey
                                            )
                                        ),
                                        TextSpan(
                                            text: "Login",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Theme.of(context).hintColor
                                            )
                                        )
                                      ]
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }

  void signup() {}
}