import 'package:flutter/material.dart';
import 'package:plant_friends/themes/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomePage1 extends StatelessWidget {
  const WelcomePage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context)!;

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
                    'lib/images/welcome/images/wallpaper_welcome_page1.jpg',
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
                            localizations.welcome,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontSize: 26 * textScaleFactor,
                            ),
                          ),
                          SizedBox(height: size.height * 0.03),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Text(
                                localizations.greetings,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontSize: 18 * textScaleFactor, // Dynamische Schriftgröße
                                  color: isDarkMode ? dmLightGrey : lmDarkGrey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
