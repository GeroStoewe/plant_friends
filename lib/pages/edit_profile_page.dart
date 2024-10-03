import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:plant_friends/pages/profile_page.dart';
import 'package:plant_friends/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../themes/colors.dart';
import '../widgets/custom_profile_button.dart';
import '../widgets/custom_text_field.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Variables
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = false;
  String joinDate = '';

  @override
  void initState() {
    super.initState();
    fetchJoinDate();
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(LineAwesomeIcons.angle_left_solid,
                color: Colors.white70),
          ),
          title: Text("Edit Profile",
              style: Theme.of(context).textTheme.labelMedium),
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(size.width * 0.05),
              child: Column(children: [
                const SizedBox(height: 30),
                Stack(children: [
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 8,
                              color:
                                  isDarkMode ? darkSeaGreen : darkGreyGreen)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: Image.asset(
                              "lib/profileImages/1_plant_profile.jpg")),
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
                          color: isDarkMode ? darkSeaGreen : darkGreyGreen),
                      child: Icon(
                        LineAwesomeIcons.camera_solid,
                        size: 28.0,
                        color: isDarkMode ? Colors.black87 : Colors.white70,
                      ),
                    ),
                  )
                ]),
                const SizedBox(height: 50),
                Form(
                  child: Column(
                    children: [
                      CustomTextField(
                          controller: fullnameController,
                          icon: Icons.person_outline_rounded,
                          hintText: "Full Name",
                          obscureText: false),
                      const SizedBox(height: 20),
                      CustomTextField(
                          controller: usernameController,
                          icon: Icons.alternate_email_rounded,
                          hintText: "Email Address",
                          obscureText: false),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: passwordController,
                        icon: Icons.lock_outline_rounded,
                        hintText: "Password",
                        obscureText: !isPasswordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).hintColor,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 35),
                      CustomProfileButton(
                          onPressed: saveChanges,
                          width: 180,
                          height: 80,
                          text: "SAVE"
                      ),
                      const SizedBox(height: 270),
                      Text.rich(
                        TextSpan(
                          text: "Joined: ",
                          style: TextStyle(
                              fontSize: 20,
                              color: isDarkMode
                                  ? dmLightGrey
                                  : lmDarkGrey
                          ),
                          children: [
                            TextSpan(
                              text: joinDate,
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Theme.of(context).hintColor
                              )
                            ),
                          ]
                        )
                      )
                    ],
                  ),
                )
              ])),
        ));
  }

  Future<void> saveChanges() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Update the user's display name
        await user.updateDisplayName(fullnameController.text);

        // Optionally, update the email if it has changed
        if (usernameController.text != user.email) {
          await user.verifyBeforeUpdateEmail(usernameController.text);
        }

        // Optionally, update the password if it is not empty
        if (passwordController.text.isNotEmpty) {
          await user.updatePassword(passwordController.text);
        }

        // Show success message
        showMessage("Profile updated successfully");
      } on FirebaseAuthException catch (e) {
        showMessage(e.message ?? "An error occurred");
      } catch (e) {
        showMessage("An error occurred while updating profile");
      }
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
