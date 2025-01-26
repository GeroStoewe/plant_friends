import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:plant_friends/pages/profile_pages/other/about_page.dart';
import 'package:plant_friends/pages/profile_pages/profile_page_edit.dart';
import 'package:plant_friends/pages/profile_pages/other/user_information_page.dart';
import 'package:plant_friends/pages/quiz_pages/quiz_test_page.dart';
import 'package:plant_friends/themes/colors.dart';
import 'package:plant_friends/themes/theme_provider.dart';
import 'package:plant_friends/widgets/custom_profile_button.dart';
import 'package:plant_friends/widgets/profile_menu_button.dart';
import 'package:provider/provider.dart';

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
  void initState() {
    super.initState();
    loadUserData();
    scrollController.addListener(onScroll);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> loadUserData() async {
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
          displayName = user!.displayName ?? 'Anonymous';
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
    Size size = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
            "Profile",
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
                iconSize: 28,
                icon: Icon(
                    isDarkMode ? LineAwesomeIcons.sun : LineAwesomeIcons.moon)),
          ],
        ),
        body: Stack(children: [
          RefreshIndicator(
            onRefresh: loadUserData,
            child: Scrollbar(
              child: SingleChildScrollView(
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
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
                            width: 120,
                            height: 120,
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
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  color:
                                      isDarkMode ? darkSeaGreen : darkGreyGreen),
                              child: Icon(
                                LineAwesomeIcons.pencil_alt_solid,
                                size: 26.0,
                                color:
                                    isDarkMode ? Colors.black87 : Colors.white70,
                              ),
                            ),
                          )
                        ]),
                      ),
                      const SizedBox(height: 20),
                      Text("$displayName",
                          style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 2),
                      Text("$email",
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 25),
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
                          width: 140,
                          height: 40,
                          text: "Edit Profile",
                          color: Theme.of(context).primaryColor),
                      const SizedBox(height: 20),
                      Divider(
                          thickness: 0.5,
                          color: isDarkMode ? dmDarkGrey : lmLightGrey),
                      const SizedBox(height: 5),

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
                        text: "User Information",
                        icon: LineAwesomeIcons.user_circle,
                      ),
                      const SizedBox(height: 2),
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
                        text: "Plant Quiz",
                        icon: LineAwesomeIcons.question_circle,
                      ),
                      const SizedBox(height: 5),
                      Divider(
                          thickness: 0.5,
                          color: isDarkMode ? dmDarkGrey : lmLightGrey),
                      const SizedBox(height: 5),
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
                        text: "About",
                        icon: LineAwesomeIcons.info_circle_solid,
                      ),
                      const SizedBox(height: 2),
                      ProfileMenuButton(
                        onTap: isLoading ? null : logout,
                        text: "Logout",
                        icon: Icons.logout_rounded,
                        endIcon: false,
                        textColor: isDarkMode ? Colors.red : Colors.redAccent,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.7),
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
