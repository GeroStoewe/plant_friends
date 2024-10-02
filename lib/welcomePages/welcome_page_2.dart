import 'package:flutter/material.dart';
import 'package:plant_friends/authentication/LoginOrSignupPage.dart';
import 'package:plant_friends/authentication/login_page.dart';
import 'package:plant_friends/authentication/signup_page.dart';
import 'package:plant_friends/themes/colors.dart';
import 'package:plant_friends/widgets/custom_button.dart';

class WelcomePage2 extends StatelessWidget {
  const WelcomePage2({Key? key}) : super(key: key);

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
                  height: size.height * 0.5,
                  child: Image.asset(
                    'lib/welcomePages/images/wallpaper_welcome_page2.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            Positioned(
              top: size.height * 0.48,
              child: Container(
                width: size.width,
                height: size.height * 0.52,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        "Ready to get started?",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Create an account or log in to manage your plants today.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: isDarkMode ? dmLightGrey : lmDarkGrey,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Login Button
                      CustomButton(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignupPage(
                                        onTap: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const LoginOrSignupPage(),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        text: "Login",
                      ),
                      const SizedBox(height: 20),

                      // Sign Up Button
                      CustomButton(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignupPage(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginOrSignupPage(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        text: "Sign Up",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}