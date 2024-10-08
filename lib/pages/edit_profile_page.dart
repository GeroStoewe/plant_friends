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
  final TextEditingController currPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isLoading = false;
  String? updatedEmail;
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
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.all(size.width * 0.05),
                    child: Column(
                        children: [
                      const SizedBox(height: 25),
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
                      const SizedBox(height: 40),
                      Form(
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                text: TextSpan(
                                  text: "Change Your ",
                                  style: Theme.of(context).textTheme.displayLarge,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "Full Name",
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                                controller: fullnameController,
                                icon: Icons.person_outline_rounded,
                                hintText: "New Full Name",
                                obscureText: false),
                            const SizedBox(height: 30),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                text: TextSpan(
                                  text: "Change Your ",
                                  style: Theme.of(context).textTheme.displayLarge,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "Email Address",
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                                controller: usernameController,
                                icon: Icons.alternate_email_rounded,
                                hintText: "New Email Address",
                                obscureText: false),
                            const SizedBox(height: 15),
                            CustomTextField(
                              controller: currPasswordController,
                              icon: Icons.lock_outline_rounded,
                              hintText: "Current Password",
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
                            const SizedBox(height: 30),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                text: TextSpan(
                                  text: "Change Your ",
                                  style: Theme.of(context).textTheme.displayLarge,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "Password",
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              controller: currPasswordController,
                              icon: Icons.lock_outline_rounded,
                              hintText: "Current Password",
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
                            const SizedBox(height: 15),
                            CustomTextField(
                              controller: newPasswordController,
                              icon: Icons.lock_outline_rounded,
                              hintText: "New Password",
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
                            const SizedBox(height: 30),
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
            ]
          ),
        ));
  }

  Future<void> reAuthenticateUser(User user) async {
    String email = user.email!;
    String password = currPasswordController.text;

    AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);

    await user.reauthenticateWithCredential(credential);
  }

  Future<void> saveChanges() async {
    setState(() {
      isLoading = true;
    });

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Check if the full name field is not empty and update display name
        if (fullnameController.text.isNotEmpty) {
          await user.updateDisplayName(fullnameController.text);
        }

        // Check if the email field is not empty and has changed
        if (usernameController.text.isNotEmpty && usernameController.text != user.email) {
          // Ensure that the current password field is filled
          if (currPasswordController.text.isEmpty) {
            showMessage("Please enter your current password to change your email.");
            return;
          }

          // Re-authenticate the user before changing email
          await reAuthenticateUser(user);

          // Store the updated email temporarily
          updatedEmail = usernameController.text;

          // Send a verification email before updating the email
          await user.verifyBeforeUpdateEmail(updatedEmail!);

          // Notify the user to verify their email
          showMessage("A verification email has been sent to $updatedEmail. Please verify the email to complete the update.");
        }

        // Check if the current password is filled for password change
        if (newPasswordController.text.isNotEmpty) {
          // Validate new password
          if (currPasswordController.text.isEmpty) {
            showMessage("Please enter a new password.");
            return;
          }

          if (currPasswordController.text == newPasswordController.text) {
            showMessage("The new password must be different from the current password.");
            return;
          }

          // Re-authenticate the user before changing password
          await reAuthenticateUser(user);
          await user.updatePassword(newPasswordController.text);
        }

        // Show success message if at least one field was updated
        if (fullnameController.text.isNotEmpty || usernameController.text.isNotEmpty || currPasswordController.text.isNotEmpty || newPasswordController.text.isNotEmpty) {
          showMessage("Profile updated successfully");

          // Return updated values to the previous screen
          Navigator.pop(context, {
            'displayName': fullnameController.text.isNotEmpty ? fullnameController.text : user.displayName,
            'email': updatedEmail ?? user.email,
          });
        } else {
          showMessage("No changes made");
        }
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
