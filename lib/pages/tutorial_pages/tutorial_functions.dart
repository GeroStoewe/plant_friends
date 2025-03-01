import 'package:flutter/material.dart';
import 'package:plant_friends/widgets/custom_button_outlined_small.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TutorialFunctions {
  OverlayEntry? overlayEntry;
  int currentStepIndex = 0;
  static bool isTutorialActive = false;

  // Liste der Bildpfade (die Texte kommen über die Localization)
  final List<String> tutorialImages = [
    'lib/images/tutorial/1_profile.png',
    'lib/images/tutorial/1_1_quiz.png',
    'lib/images/tutorial/2_plant_wiki.png',
    'lib/images/tutorial/3_plant_wiki_wishes.png',
    'lib/images/tutorial/4_plant_wiki_wishlist.png',
    'lib/images/tutorial/4_1_plant_wiki_plant_request.png',
    'lib/images/tutorial/4_2_my_plants_empty.png',
    'lib/images/tutorial/5_add_new_plant_decision_help_1.png',
    'lib/images/tutorial/7_add_new_plant_help_1.png',
    'lib/images/tutorial/8_add_new_plant_help_2.png',
    'lib/images/tutorial/9_add_new_plant_decision_no_help.png',
    'lib/images/tutorial/10_add_plant_2.png',
    'lib/images/tutorial/14_my_plants.png',
    'lib/images/tutorial/11_my_plants_detail.png',
    'lib/images/tutorial/12_my_plants_detail_watering_done.png',
    'lib/images/tutorial/12_1_photo_journal.png',
    'lib/images/tutorial/13_my_plants_detail_edit.png',
    'lib/images/tutorial/15_calendar_unwatered.png',
    'lib/images/tutorial/16_calendar_watered.png',
    'lib/images/tutorial/windowsill.webp',
  ];

  // Hilfsfunktion, die basierend auf dem aktuellen Schritt den entsprechenden Text zurückgibt.
  String getTutorialText(BuildContext context, int stepIndex) {
    final localizations = AppLocalizations.of(context)!;
    switch (stepIndex) {
      case 0:
        return localizations.tutorialStep1;
      case 1:
        return localizations.tutorialStep2;
      case 2:
        return localizations.tutorialStep3;
      case 3:
        return localizations.tutorialStep4;
      case 4:
        return localizations.tutorialStep5;
      case 5:
        return localizations.tutorialStep6;
      case 6:
        return localizations.tutorialStep7;
      case 7:
        return localizations.tutorialStep8;
      case 8:
        return localizations.tutorialStep9;
      case 9:
        return localizations.tutorialStep10;
      case 10:
        return localizations.tutorialStep11;
      case 11:
        return localizations.tutorialStep12;
      case 12:
        return localizations.tutorialStep13;
      case 13:
        return localizations.tutorialStep14;
      case 14:
        return localizations.tutorialStep15;
      case 15:
        return localizations.tutorialStep16;
      case 16:
        return localizations.tutorialStep17;
      case 17:
        return localizations.tutorialStep18;
      case 18:
        return localizations.tutorialStep19;
      case 19:
        return localizations.tutorialStep20;
      default:
        return "";
    }
  }

  void closeTutorial() {
    overlayEntry?.remove();
    overlayEntry = null;
    isTutorialActive = false;
  }

  void showStep(BuildContext context, OverlayState overlayState) {
    isTutorialActive = true;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final localizations = AppLocalizations.of(context)!;

    overlayEntry = OverlayEntry(
      builder: (context) {
        return GestureDetector(
          onTap: closeTutorial,
          behavior: HitTestBehavior.opaque,
          child: Stack(
            children: [
              Positioned(
                bottom: screenHeight * 0.05,
                left: screenWidth * 0.05,
                right: screenWidth * 0.05,
                child: Material(
                  color: Colors.transparent,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(screenWidth * 0.05),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 2),
                              borderRadius: BorderRadius.circular(17),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                tutorialImages[currentStepIndex],
                                height: screenHeight * 0.5,
                                fit: BoxFit.contain,
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          Text(
                            getTutorialText(context, currentStepIndex),
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          Row(
                            mainAxisAlignment: currentStepIndex == 0
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.spaceBetween,
                            children: [
                              if (currentStepIndex > 0)
                                CustomButtonOutlinedSmall(
                                  text: localizations.back,
                                  onTap: () {
                                    currentStepIndex--;
                                    closeTutorial();
                                    showStep(context, overlayState);
                                  },
                                ),
                              CustomButtonOutlinedSmall(
                                text: currentStepIndex < tutorialImages.length - 1
                                    ? localizations.next
                                    : localizations.finish,
                                onTap: () {
                                  if (currentStepIndex < tutorialImages.length - 1) {
                                    currentStepIndex++;
                                    closeTutorial();
                                    showStep(context, overlayState);
                                  } else {
                                    closeTutorial();
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    overlayState.insert(overlayEntry!);
  }
}

void showTutorialOverlay(BuildContext context) {
  if (TutorialFunctions.isTutorialActive) {
    return;
  }

  final TutorialFunctions tutorialFunctions = TutorialFunctions();
  final OverlayState overlayState = Overlay.of(context)!;
  tutorialFunctions.showStep(context, overlayState);
}
