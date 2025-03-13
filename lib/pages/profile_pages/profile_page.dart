import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:plant_friends/pages/profile_pages/other/about_page.dart';
import 'package:plant_friends/pages/profile_pages/other/change_language_page.dart';
import 'package:plant_friends/pages/profile_pages/profile_page_edit.dart';
import 'package:plant_friends/pages/profile_pages/other/user_information_page.dart';
import 'package:plant_friends/pages/quiz_pages/quiz_test_page.dart';
import 'package:plant_friends/pages/tutorial_pages/tutorial_page.dart';
import 'package:plant_friends/pages/suggestion_pages/suggestion_pages.dart';
import 'package:plant_friends/themes/colors.dart';
import 'package:plant_friends/themes/theme_provider.dart';
import 'package:plant_friends/widgets/custom_profile_button.dart';
import 'package:plant_friends/widgets/profile_menu_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../wiki_pages/filter_pages/plant_wishlist_page.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Variables
  String? displayName;
  String? email;
  String? photoURL;
  bool isLoading = false;
  bool isDataLoaded = false;

  ScrollController scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadUserData();
    scrollController.addListener(onScroll);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> loadUserData() async {
    final localizations = AppLocalizations.of(context)!;

    setState(() {
      isLoading = true;
    });

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await user.reload();
      user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await Future.delayed(Duration(seconds: 1));

        setState(() {
          displayName = user!.displayName ?? localizations.anonymous;
          email = user.email;
          photoURL = user.photoURL;
          isLoading = false;
          isDataLoaded = true;
        });
      }
    }
  }

  void onScroll() {
    if (scrollController.position.pixels < -100 && !isLoading) {
      loadUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    Size size = MediaQuery.of(context).size;
    double textScaleFactor = size.width / 400;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    bool isLargePhone(BuildContext context) {
      double width = MediaQuery.of(context).size.width;
      return width > 400;
    }
    final localizations = AppLocalizations.of(context)!;

    return ScrollbarTheme(
      data: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(seaGreen),
        // Set scrollbar thumb color to green
        trackColor:
        WidgetStateProperty.all(Colors.grey.shade300), // Set track color
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          // Setzt die AppBar-Farbe auf den Hintergrund
          elevation: 0,
          // Entfernt den Schatten der AppBar
          title: Text(
            localizations.profile,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: isDarkMode
                  ? Colors.white
                  : Colors
                  .black, // Dynamische Farbe für Dark und Light Mode
            ),
          ),
          actions: [
            IconButton(
                onPressed: isLoading ? null : themeProvider.toggleTheme,
                color: isDarkMode ? Colors.white : Colors.black,
                // Farbe des Icons dynamisch
                iconSize: 28 * textScaleFactor,
                icon: Icon(
                    isDarkMode ? LineAwesomeIcons.sun : LineAwesomeIcons.moon)),
          ],
        ),
        body: Stack(children: [
          RefreshIndicator(
            onRefresh: loadUserData,
            color: seaGreen,
            child: Scrollbar(
              child: SingleChildScrollView(
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                    children: [
                      GestureDetector(
                        onTap: isLoading
                            ? null
                            : () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfilePage()));

                          loadUserData();
                        },
                        child: Stack(children: [
                          SizedBox(
                            width: isLargePhone(context) ? 120 : 80,
                            height: isLargePhone(context) ? 120 : 80,
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 6,
                                      color: isDarkMode
                                          ? darkSeaGreen
                                          : darkGreyGreen)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: photoURL != null
                                    ? Image.network(
                                  photoURL!,
                                  // Show the network image if available
                                  fit: BoxFit.cover,
                                )
                                    : Image.asset(
                                    "lib/images/profile/1_plant_profile.jpg"), // Default image
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            right: 5,
                            child: Container(
                              width: isLargePhone(context) ? 35 : 25,
                              height: isLargePhone(context) ? 35 : 25,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  color:
                                  isDarkMode ? darkSeaGreen : darkGreyGreen),
                              child: Icon(
                                LineAwesomeIcons.pencil_alt_solid,
                                size: 24.0 * textScaleFactor,
                                color:
                                isDarkMode ? Colors.black87 : Colors.white70,
                              ),
                            ),
                          )
                        ]),
                      ),
                      Padding(
                          padding: isLargePhone(context) ? const EdgeInsets.all(20.0) : const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Text("$displayName",
                                  style: Theme.of(context).textTheme.headlineSmall),
                              SizedBox(height: size.height * 0.0001),
                              Text("$email",
                                  style: Theme.of(context).textTheme.bodyLarge),
                              SizedBox(height: size.height * 0.03),
                              CustomProfileButton(
                                  onPressed: isLoading
                                      ? null
                                      : () async {
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditProfilePage()));

                                    loadUserData();
                                  },
                                  width: 160 * textScaleFactor,
                                  height: 50 * textScaleFactor,
                                  text: localizations.editProfile,
                                  color: Theme.of(context).primaryColor),
                              SizedBox(height: size.height * 0.025),
                              Divider(
                                  thickness: 0.5,
                                  color: isDarkMode ? dmDarkGrey : lmLightGrey),

                              // MENU
                              ProfileMenuButton(
                                onTap: isLoading
                                    ? null
                                    : () async {
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UserInformationPage()));
                                },
                                text: localizations.userInformation,
                                icon: LineAwesomeIcons.user_circle,
                              ),
                              ProfileMenuButton(
                                onTap: isLoading
                                    ? null
                                    : () async {
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChangeLanguagePage()));
                                },
                                text: localizations.changeLanguage,
                                icon: Icons.language,
                              ),
                              ProfileMenuButton(
                                onTap: isLoading
                                    ? null
                                    : () async {
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const QuizTestPage()));
                                },
                                text: localizations.plantQuiz,
                                icon: LineAwesomeIcons.question_circle,
                              ),
                              ProfileMenuButton(
                                onTap: isLoading
                                    ? null
                                    : () async {
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const TutorialPage()));
                                },
                                text: localizations.tutorial,
                                icon: LineAwesomeIcons.play_circle,
                              ),
                              ProfileMenuButton(
                                onTap: isLoading
                                    ? null
                                    : () async {
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const PlantWishListPage()));
                                },
                                text: localizations.wishlistTitle,
                                icon: LineAwesomeIcons.heart,
                              ),
                              //TODO
                              ProfileMenuButton(
                                onTap: isLoading
                                    ? null
                                    : () async {
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const SuggestionsPage()));
                                },
                                text: localizations.suggestions,
                                icon: LineAwesomeIcons.lightbulb_solid,
                              ),

                              SizedBox(height: size.height * 0.01),
                              Divider(
                                  thickness: 0.5,
                                  color: isDarkMode ? dmDarkGrey : lmLightGrey),
                              SizedBox(height: size.height * 0.005),
                              ProfileMenuButton(
                                onTap: isLoading
                                    ? null
                                    : () async {
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AboutPage()));

                                  loadUserData();
                                },
                                text: localizations.about,
                                icon: LineAwesomeIcons.info_circle_solid,
                              ),
                              ProfileMenuButton(
                                onTap: isLoading ? null : logout,
                                text: localizations.logout,
                                icon: Icons.logout_rounded,
                                endIcon: false,
                                textColor: isDarkMode ? Colors.red : Colors.redAccent,
                              ),
                            ],
                          )
                      )
                    ]
                ),
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: isDarkMode ? Colors.black : Colors.white,
              child: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor)),
              ),
            )
        ]),
      ),
    );
  }

  void logout() {
    FirebaseAuth.instance.signOut();
    GoogleSignIn().signOut();
  }
}