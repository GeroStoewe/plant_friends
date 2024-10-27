import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:plant_friends/pages/about_page.dart';
import 'package:plant_friends/pages/edit_profile_page.dart';
import 'package:plant_friends/pages/user_information_page.dart';
import 'package:plant_friends/quiz/quiz_test_page.dart';
import 'package:plant_friends/themes/colors.dart';
import 'package:plant_friends/themes/theme_provider.dart';
import 'package:plant_friends/widgets/custom_profile_button.dart';
import 'package:plant_friends/widgets/profile_menu_button.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

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
        thumbColor: MaterialStateProperty.all(seaGreen),
        trackColor: MaterialStateProperty.all(Colors.grey.shade300),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          title: Text(
            "Profile",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          actions: [
            IconButton(
              onPressed: isLoading ? null : themeProvider.toggleTheme,
              color: isDarkMode ? Colors.white : Colors.black,
              iconSize: size.width * 0.07,
              icon: Icon(isDarkMode ? LineAwesomeIcons.sun : LineAwesomeIcons.moon),
            ),
          ],
        ),
        body: Stack(
          children: [
            RefreshIndicator(
              onRefresh: loadUserData,
              child: Scrollbar(
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05,
                      vertical: size.height * 0.03,
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: isLoading
                              ? null
                              : () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditProfilePage()),
                            );
                            loadUserData();
                          },
                          child: Stack(
                            children: [
                              Container(
                                width: size.width * 0.32,
                                height: size.width * 0.32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 6,
                                    color: isDarkMode ? darkSeaGreen : darkGreyGreen,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100.0),
                                  child: photoURL != null
                                      ? Image.network(
                                    photoURL!,
                                    fit: BoxFit.cover,
                                  )
                                      : Image.asset("lib/profileImages/1_plant_profile.jpg"),
                                ),
                              ),
                              Positioned(
                                bottom: 5,
                                right: 5,
                                child: Container(
                                  width: size.width * 0.09,
                                  height: size.width * 0.09,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: isDarkMode ? darkSeaGreen : darkGreyGreen,
                                  ),
                                  child: Icon(
                                    LineAwesomeIcons.pencil_alt_solid,
                                    size: size.width * 0.06,
                                    color: isDarkMode ? Colors.black87 : Colors.white70,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: size.height * 0.03),
                        Text(
                          "$displayName",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        SizedBox(height: size.height * 0.01),
                        Text(
                          "$email",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        SizedBox(height: size.height * 0.03),
                        CustomProfileButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditProfilePage()),
                            );
                            loadUserData();
                          },
                          width: size.width * 0.4,
                          height: size.height * 0.06,
                          text: "Edit Profile",
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(height: size.height * 0.03),
                        Divider(thickness: 0.5, color: isDarkMode ? dmDarkGrey : lmLightGrey),
                        SizedBox(height: size.height * 0.01),
                        ProfileMenuButton(
                          onTap: isLoading
                              ? null
                              : () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => UserInformationPage()),
                            );
                          },
                          text: "User Information",
                          icon: LineAwesomeIcons.user_circle,
                        ),
                        ProfileMenuButton(
                          onTap: isLoading
                              ? null
                              : () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const QuizTestPage()),
                            );
                          },
                          text: "Plant Quiz",
                          icon: LineAwesomeIcons.question_circle,
                        ),
                        Divider(thickness: 0.5, color: isDarkMode ? dmDarkGrey : lmLightGrey),
                        ProfileMenuButton(
                          onTap: isLoading
                              ? null
                              : () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AboutPage()),
                            );
                            loadUserData();
                          },
                          text: "About",
                          icon: LineAwesomeIcons.info_circle_solid,
                        ),
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
                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void logout() {
    FirebaseAuth.instance.signOut();
    GoogleSignIn().signOut();
  }
}
