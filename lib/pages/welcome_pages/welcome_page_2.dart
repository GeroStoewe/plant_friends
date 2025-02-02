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
                  height: size.height * 0.6,
                  child: Image.asset(
                    'lib/images/welcome/images/wallpaper_welcome_page2.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            Positioned(
              top: size.height * 0.5,
              child: Container(
                width: size.width,
                height: size.height * 0.5,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                ),
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double textScaleFactor = size.width / 400; // Normalize for different widths

                        if (constraints.maxHeight > 350) {
                          textScaleFactor *= 0.95; // Kleinere Bildschirme -> kleinerer Text
                        } else if (constraints.maxHeight < 350) {
                          textScaleFactor *= 0.75; // Noch kleinere Bildschirme
                        }

                        return Padding(
                          padding: EdgeInsets.all(size.width * 0.04), // Dynamisches Padding
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: size.height * 0.002),
                              Text(
                                "Ready to get started?",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(fontSize: 28 * textScaleFactor),
                              ),
                              SizedBox(height: size.height * 0.03),
                              Text(
                                "Create an account or log in to manage your plants today.",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontSize: 18 * textScaleFactor,
                                  color: isDarkMode ? dmLightGrey : lmDarkGrey,
                                ),
                              ),
                              SizedBox(height: size.height * 0.04),

                              // Login Button
                              SizedBox(
                                width: size.width * 0.8, // Dynamische Button-Breite
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
                              SizedBox(height: size.height * 0.025),

                              // Sign Up Button
                              SizedBox(
                                width: size.width * 0.8, // Dynamische Button-Breite
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
