import 'package:flutter/material.dart';
import 'package:plant_friends/pages/tutorial_pages/tutorial_functions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({super.key});

  @override
  _TutorialPageState createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  final TutorialFunctions tutorialFunctions = TutorialFunctions();

  @override
  void dispose() {
    tutorialFunctions.closeTutorial();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double paddingValue = screenWidth * 0.05;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/images/tutorial/wallpaper_tutorial.png',
              fit: BoxFit.cover,
              color: isDarkMode ? Colors.black.withOpacity(0.6) : Colors.black.withOpacity(0.0),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingValue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDarkMode ? Colors.white10 : Colors.black12,
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: isDarkMode ? Colors.white : Colors.black,
                          size: screenWidth * 0.07,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  Text(
                    localizations.welcomeToTutorial,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    localizations.tutorialText,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Text(
                    localizations.startedTutorial,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        if (!TutorialFunctions.isTutorialActive) {
                          OverlayState overlayState = Overlay.of(context)!;
                          TutorialFunctions tutorialFunctions = TutorialFunctions();
                          tutorialFunctions.showStep(context, overlayState);
                        }
                      },
                      label: Text(
                        localizations.startTutorial,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      icon: const Icon(Icons.quiz, color: Colors.white),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
