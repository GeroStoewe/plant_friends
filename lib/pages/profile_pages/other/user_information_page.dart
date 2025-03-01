import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../themes/colors.dart';
import '../../../themes/theme_provider.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/custom_profile_button.dart';
import '../../authentication_pages/auth_page.dart';
import '../../authentication_pages/forgot_password_page.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchJoinDate();
    loadUserData();
  }

  Future<void> fetchJoinDate() async {
    final localizations = AppLocalizations.of(context)!;

    final prefs = await SharedPreferences.getInstance();
    String? dateString = prefs.getString('joinDate');

    if (dateString != null) {
      DateTime dateTime = DateTime.parse(dateString);
      setState(() {
        joinDate = DateFormat('dd/MM/yyyy').format(dateTime);
      });
    } else {
      setState(() {
        joinDate = localizations.notAvailable;
      });
    }
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
    Size size = MediaQuery.of(context).size;
    double textScaleFactor = size.width / 400;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    bool isLargePhone(BuildContext context) {
      double width = MediaQuery.of(context).size.width;
      return width > 400;
    }
    final localizations = AppLocalizations.of(context)!;

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
        title: AutoSizeText(
          localizations.userInformation,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: isDarkMode
                ? Colors.white
                : Colors.black, // Dynamic color for dark and light mode
          ),
          maxFontSize: 26,
        ),
        actions: [
          IconButton(
            onPressed: isLoading ? null : themeProvider.toggleTheme,
            color: isDarkMode ? Colors.white : Colors.black,
            iconSize: 28 * textScaleFactor,
            icon:
            Icon(isDarkMode ? LineAwesomeIcons.sun : LineAwesomeIcons.moon),
          ),
        ],
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: loadUserData,
            color: seaGreen,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                padding: isLargePhone(context) ? const EdgeInsets.all(15.0) : const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomCard(
                      headline: localizations.fullName,
                      icon: Icons.person_outline_rounded,
                      text: "$displayName",
                    ),
                    SizedBox(height: size.height * 0.01),
                    CustomCard(
                      headline: localizations.emailProfile,
                      icon: Icons.email_rounded,
                      text: "$email",
                    ),
                    SizedBox(height: size.height * 0.01),
                    CustomCard(
                      headline: localizations.userId,
                      icon: Icons.account_box_rounded,
                      text: user!.uid,
                    ),
                    SizedBox(height: size.height * 0.01),
                    CustomCard(
                      headline: localizations.joinedAt,
                      icon: Icons.calendar_today_rounded,
                      text: joinDate,
                    ),
                    SizedBox(height: size.height * 0.03),
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
                        width: isLargePhone(context) ? 200 : 180,
                        height: isLargePhone(context) ? 60 : 50,
                        text: localizations.resetPasswordButton,
                        color: Theme.of(context).primaryColor
                    ),
                    SizedBox(height: size.height * 0.03),
                    CustomProfileButton(
                        onPressed: deleteAccount,
                        width: isLargePhone(context) ? 200 : 180,
                        height: isLargePhone(context) ? 60 : 50,
                        text: localizations.deleteAccount,
                        color: Colors.redAccent
                    ),
                  ],
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
                      Theme.of(context).primaryColor),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
