// welcomePages/welcome_page_1.dart
import 'package:flutter/material.dart';
import 'package:plant_friends/welcomePages/welcome_page_2.dart';
import 'package:plant_friends/themes/colors.dart';
import 'package:plant_friends/widgets/custom_button.dart';

class WelcomePage1 extends StatelessWidget {
  const WelcomePage1({Key? key}) : super(key: key);

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
                    'lib/welcomePages/images/wallpaper_welcome_page1.jpg',
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
                        "Welcome to Plant Friends!",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Hello plant lover! ❤️ \n\nWhether you're a green thumb or just starting out, Plant Friends is your ultimate companion. With customized plant care, timely reminders, and helpful information, you'll keep your houseplants happy and healthy. \n\nLet’s make your indoor jungle thrive together! 🌿",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: isDarkMode ? dmLightGrey : lmDarkGrey,
                        ),
                      ),
                      const SizedBox(height: 40),
                      CustomButton(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WelcomePage2(),
                            ),
                          );
                        },
                        text: "Next",
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
