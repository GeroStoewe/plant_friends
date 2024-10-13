import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:plant_friends/authentication/forgot_password_page.dart';
import 'package:plant_friends/widgets/custom_button.dart';
import 'package:plant_friends/widgets/custom_card.dart';
import 'package:plant_friends/widgets/custom_profile_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../authentication/auth_page.dart';
import '../themes/colors.dart';
import '../themes/theme_provider.dart'; // For formatting the date

class UserInformationPage extends StatefulWidget {
  const UserInformationPage({Key? key}) : super(key: key);

  @override
  _UserInformationPageState createState() => _UserInformationPageState();
}

class _UserInformationPageState extends State<UserInformationPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  String? displayName;
  String? email;
  String joinDate = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchJoinDate();
    loadUserData();
  }

  Future<void> fetchJoinDate() async {
    final prefs = await SharedPreferences.getInstance();
    String? dateString = prefs.getString('joinDate');

    if (dateString != null) {
      DateTime dateTime = DateTime.parse(dateString);
      setState(() {
        joinDate = DateFormat('dd/MM/yyyy').format(dateTime);
      });
    } else {
      setState(() {
        joinDate = 'Not available';
      });
    }
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
          isLoading = false;
        });
      }
    }
  }

  Future<void> deleteAccount() async {
    final User? user = FirebaseAuth.instance.currentUser; // Fetch the current user here
    if (user != null) {
      try {
        await user.delete();  // Deletes the user
        await FirebaseAuth.instance.signOut(); // Signs out the user
        await GoogleSignIn().signOut(); // Signs out of Google
        // Navigate to Auth Page or show confirmation
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AuthPage()),
        );
      } on FirebaseAuthException catch (e) {
        // Handle errors here
        print("Error deleting account: ${e.message}");
        // Optionally show a dialog with the error
      }
    } else {
      print("No user currently signed in.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(LineAwesomeIcons.angle_left_solid,
              color: isDarkMode ? dmLightGrey : lmLightGrey),
        ),
        title: Text(
          "User Information",
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: isDarkMode
                ? Colors.white
                : Colors.black, // Dynamic color for dark and light mode
          ),
        ),
        actions: [
          IconButton(
            onPressed: isLoading ? null : themeProvider.toggleTheme,
            color: isDarkMode ? Colors.white : Colors.black,
            iconSize: 30,
            icon:
            Icon(isDarkMode ? LineAwesomeIcons.sun : LineAwesomeIcons.moon),
          ),
        ],
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: loadUserData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomCard(
                      headline: "Full Name",
                      icon: Icons.person_outline_rounded,
                      text: "$displayName",
                    ),
                    const SizedBox(height: 10),
                    CustomCard(
                      headline: "E-Mail",
                      icon: Icons.email_rounded,
                      text: "$email",
                    ),
                    const SizedBox(height: 10),
                    CustomCard(
                      headline: "User ID",
                      icon: Icons.account_box_rounded,
                      text: user!.uid,
                    ),
                    const SizedBox(height: 10),
                    CustomCard(
                      headline: "Joined At",
                      icon: Icons.calendar_today_rounded,
                      text: joinDate,
                    ),
                    const SizedBox(height: 40),
                    // Password Reset Button
                    CustomProfileButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordPage()));

                          loadUserData();
                        },
                        width: 200,
                        height: 60,
                        text: "Reset Password",
                        color: Theme.of(context).primaryColor
                    ),
                    const SizedBox(height: 30),
                    CustomProfileButton(
                        onPressed: deleteAccount,
                        width: 200,
                        height: 60,
                        text: "Delete Account",
                        color: Colors.redAccent
                    ),
                  ],
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
                      Theme.of(context).primaryColor),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
