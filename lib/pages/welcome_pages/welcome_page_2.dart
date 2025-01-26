import 'package:flutter/material.dart';

import '../../themes/colors.dart';
import '../../widgets/custom_button.dart';
import '../authentication_pages/auth_page.dart';

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
                    'lib/images/welcome/images/wallpaper_welcome_page2.jpg',
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
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double textScaleFactor = 1.0;
                        double buttonWidthScaleFactor = 1.0;

                        // Passe den Text und die Button-Größe je nach Höhe an
                        if (constraints.maxHeight < 400) {
                          textScaleFactor = 0.85;
                          buttonWidthScaleFactor = 0.9;
                        } else if (constraints.maxHeight < 300) {
                          textScaleFactor = 0.75;
                          buttonWidthScaleFactor = 0.8;
                        }

                        return Padding(
                          padding: EdgeInsets.all(size.width * 0.05), // Dynamisches Padding
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                "Ready to get started?",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(fontSize: 24 * textScaleFactor),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                "Create an account or log in to manage your plants today.",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontSize: 16 * textScaleFactor,
                                  color: isDarkMode ? dmLightGrey : lmDarkGrey,
                                ),
                              ),
                              const SizedBox(height: 40),

                              // Login Button
                              SizedBox(
                                width: size.width * buttonWidthScaleFactor, // Dynamische Button-Breite
                                child: CustomButton(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const AuthPage(),
                                      ),
                                    );
                                  },
                                  text: "Login",
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Sign Up Button
                              SizedBox(
                                width: size.width * buttonWidthScaleFactor, // Dynamische Button-Breite
                                child: CustomButton(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                        const AuthPage(showSignupPage: true),
                                      ),
                                    );
                                  },
                                  text: "Sign Up",
                                ),
                              ),

                              // Optional: Zurück-Icon oder weitere Widgets
                            ],
                          ),
                        );
                      },
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
}
