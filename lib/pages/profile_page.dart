import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:plant_friends/pages/edit_profile_page.dart';
import 'package:plant_friends/themes/colors.dart';
import 'package:plant_friends/themes/theme_provider.dart';
import 'package:plant_friends/widgets/custom_button.dart';
import 'package:plant_friends/widgets/custom_profile_button.dart';
import 'package:plant_friends/widgets/profile_menu_button.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key,}) : super(key: key);

  // Variables
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: Theme.of(context).textTheme.labelMedium),
        actions: [
          IconButton(
              onPressed: themeProvider.toggleTheme,
              color: Colors.white,
              iconSize: 30,
              icon: Icon(isDarkMode ? LineAwesomeIcons.sun : LineAwesomeIcons.moon
              )
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 5),
              Stack(
                children: [
                  SizedBox(
                  width: 160,
                  height: 160,
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            width: 8,
                            color: isDarkMode ? darkSeaGreen : darkGreyGreen
                        )
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: Image.asset("lib/profileImages/1_plant_profile.jpg")
                    ),
                  ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: isDarkMode ? darkSeaGreen : darkGreyGreen
                      ),
                      child: Icon(
                        LineAwesomeIcons.pencil_alt_solid,
                        size: 28.0,
                        color: isDarkMode ? Colors.black87 : Colors.white70,
                      ),
                    ),
                  )
                ]
                ),
              const SizedBox(height: 20),
              Text(
                  "${user!.displayName}", 
                  style: Theme.of(context).textTheme.headlineMedium
              ),
              const SizedBox(height: 5),
              Text(
                  "${user!.email}", 
                  style: Theme.of(context).textTheme.bodyLarge
              ),
              const SizedBox(height: 30),
              CustomProfileButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfilePage()));
                  },
                  width: 180,
                  height: 60,
                  text: "Edit Profile"
              ),
              const SizedBox(height: 35),
              Divider(
                  thickness: 0.5,
                  color: isDarkMode
                      ? dmDarkGrey
                      : lmLightGrey
              ),
              const SizedBox(height: 10),

              // MENU
              ProfileMenuButton(
                onTap: () {},
                text: "Settings",
                icon: LineAwesomeIcons.cog_solid,
              ),
              const SizedBox(height: 5),
              ProfileMenuButton(
                onTap: () {},
                text: "Plant Details",
                icon: Icons.account_circle,
              ),
              const SizedBox(height: 5),
              ProfileMenuButton(
                onTap: () {},
                text: "User Management",
                icon: LineAwesomeIcons.user_circle,
              ),
              const SizedBox(height: 10),
              Divider(
                  thickness: 0.5,
                  color: isDarkMode
                      ? dmDarkGrey
                      : lmLightGrey
              ),
              const SizedBox(height: 10),
              ProfileMenuButton(
                onTap: () {},
                text: "Information",
                icon: LineAwesomeIcons.info_circle_solid,
              ),
              const SizedBox(height: 5),
              ProfileMenuButton(
                onTap: logout,
                text: "Logout",
                icon: Icons.logout_rounded,
                endIcon: false,
                textColor: isDarkMode ? Colors.red : Colors.redAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void logout() {
    FirebaseAuth.instance.signOut();
    GoogleSignIn().signOut();
  }
}