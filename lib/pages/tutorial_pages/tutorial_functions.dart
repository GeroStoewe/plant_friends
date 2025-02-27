import 'package:flutter/material.dart';
import 'package:plant_friends/widgets/custom_button_outlined_small.dart';

class TutorialFunctions {
  OverlayEntry? overlayEntry;
  int currentStepIndex = 0;
  static bool isTutorialActive = false;

  final List<Map<String, String>> tutorialSteps = [
    {
      'image': 'lib/images/tutorial/1_profile.png',
      'text': 'Click on icon in the top right corner to switch to light/dark mode. You can edit your information, take the plant quiz, and start the tutorial.',
    },
    {
      'image': 'lib/images/tutorial/1_1_quiz.png',
      'text': 'If you want to know which plants suit your conditions take the quiz!',
    },
    {
      'image': 'lib/images/tutorial/2_plant_wiki.png',
      'text': 'This is a wiki with the most common house plants. You can filter your search with different options. After clicking on All Plants...'
    },
    {
      'image': 'lib/images/tutorial/3_plant_wiki_wishes.png',
      'text': '...you can see the list of all plants in the wiki. Click on the heart next to a plant to mark it as a wish. Click on wishlist...',
    },
    {
      'image': 'lib/images/tutorial/4_plant_wiki_wishlist.png',
      'text': '...to get to your wishlist. You can remove wishes with the bin icon.',
    },
    {
      'image': 'lib/images/tutorial/4_1_plant_wiki_plant_request.png',
      'text': 'If you cannot find a plant in the wiki you can request its addition by clicking here.',
    },
    {
      'image': 'lib/images/tutorial/4_2_my_plants_empty.png',
      'text': 'This space shows a list of your personal plants. It is currently empty. To add a plant...',
    },
    {
      'image': 'lib/images/tutorial/5_add_new_plant_decision_help_1.png',
      'text': '....click on the plus button in the bottom right corner. If you need help...',
    },
    {
      'image': 'lib/images/tutorial/7_add_new_plant_help_1.png',
      'text': '...you can use information from the wiki to fill out the form. You can use AI recognition for your new plant as well.',
    },
    {
      'image': 'lib/images/tutorial/8_add_new_plant_help_2.png',
      'text': 'To let AI recognize your new plant you can use a photo from your gallery or take a new one.',
    },
    {
      'image': 'lib/images/tutorial/9_add_new_plant_decision_no_help.png',
      'text': 'If you do not need help with information about your new plant choose the other option.',
    },
    {
      'image': 'lib/images/tutorial/10_add_plant_2.png',
      'text': 'Fill out the form, upload a picture if you like and save the information.',
    },
    {
      'image': 'lib/images/tutorial/14_my_plants.png',
      'text': 'You can now see your new plant in the list of your plants. By clicking on it you get to the detail page of your plant.',
    },
    {
      'image': 'lib/images/tutorial/11_my_plants_detail.png',
      'text': 'You can edit information or add photos to the journal. By clicking the orange icon you can signify that you watered your plant.',
    },
    {
      'image': 'lib/images/tutorial/12_my_plants_detail_watering_done.png',
      'text': 'The plant is now marked as watered. This is also visible in your calendar.',
    },
    {
      'image': 'lib/images/tutorial/12_1_photo_journal.png',
      'text': 'This is the photo journal of your new plant. Click on the button in the right corner to add photos.',
    },
    {
      'image': 'lib/images/tutorial/13_my_plants_detail_edit.png',
      'text': 'If you edit information of your plant make sure to save the changes.',
    },
    {
      'image': 'lib/images/tutorial/15_calendar_unwatered.png',
      'text': 'This is the calendar where you can see when your plants need to get watered. The x shows that your plant is not watered yet.',
    },
    {
      'image': 'lib/images/tutorial/16_calendar_watered.png',
      'text': 'By clicking on the x you can mark it was watered. It is now marked as watered.',
    },
    {
      'image': 'lib/images/tutorial/windowsill.webp',
      'text': 'Congratulations! You have completed the tutorial. Enjoy using the app!',
    },
  ];

  void closeTutorial() {
    overlayEntry?.remove();
    overlayEntry = null;
    isTutorialActive = false;
  }

  void showStep(BuildContext context, OverlayState overlayState) {
    isTutorialActive = true;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                                tutorialSteps[currentStepIndex]['image']!,
                                height: screenHeight * 0.5,
                                width: null, // Entfernt die feste Breite
                                fit: BoxFit.contain,
                                alignment: Alignment.center, // Zentriert das Bild innerhalb der Umrandung
                              ),
                            ),
                          )
                          ,
                          SizedBox(height: screenHeight * 0.03),
                          Text(
                            tutorialSteps[currentStepIndex]['text']!,
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
                                  text: 'Back',
                                  onTap: () {
                                    currentStepIndex--;
                                    closeTutorial();
                                    showStep(context, overlayState);
                                  },
                                ),
                              CustomButtonOutlinedSmall(
                                text: currentStepIndex < tutorialSteps.length - 1 ? 'Next' : 'Finish',
                                onTap: () {
                                  if (currentStepIndex < tutorialSteps.length - 1) {
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

  TutorialFunctions tutorialFunctions = TutorialFunctions();
  OverlayState overlayState = Overlay.of(context)!;
  tutorialFunctions.showStep(context, overlayState);
}
