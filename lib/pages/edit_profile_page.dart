import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../themes/colors.dart';
import '../themes/theme_provider.dart';
import '../widgets/custom_profile_button.dart';
import '../widgets/custom_text_field.dart';

enum MessageType { success, error, info }

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
  String? photoURL;

  File? plantImage;

  @override
  void initState() {
    super.initState();
    fetchJoinDate();
    loadCurrentUser();
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

  Future<void> loadCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        photoURL = user.photoURL; // Load the current photo URL if available
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    bool isDarkMode = Theme
        .of(context)
        .brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ScrollbarTheme(
        data: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(seaGreen), // Set scrollbar thumb color to green
    trackColor: WidgetStateProperty.all(Colors.grey.shade300), // Set track color
    ),
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,  // Setzt die AppBar-Farbe auf den Hintergrund
              elevation: 0,  // Entfernt den Schatten der AppBar
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(LineAwesomeIcons.angle_left_solid,
                    color: isDarkMode ? dmLightGrey : lmLightGrey),
              ),
              title: Text(
                "Edit Profile",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: isDarkMode ? Colors.white : Colors.black,  // Dynamische Farbe für Dark und Light Mode
                ),
              ),
              actions: [
                IconButton(
                    onPressed: isLoading ? null : themeProvider.toggleTheme,
                    color: isDarkMode ? Colors.white : Colors.black,  // Farbe des Icons dynamisch
                    iconSize: 30,
                    icon: Icon(
                        isDarkMode ? LineAwesomeIcons.sun : LineAwesomeIcons.moon)),
              ],
            ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Stack(
                children: [
                  Scrollbar(
                    child: SingleChildScrollView(
                      child: Container(
                          padding: EdgeInsets.all(size.width * 0.05),
                          child: Column(
                              children: [
                                const SizedBox(height: 25),
                                GestureDetector(
                                  onTap: pickImage,
                                  child: Stack(children: [
                                    SizedBox(
                                      width: 160,
                                      height: 160,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: 8,
                                                color:
                                                isDarkMode
                                                    ? darkSeaGreen
                                                    : darkGreyGreen)),
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                100.0),
                                            child: plantImage != null
                                                ? Image.file(
                                              plantImage!,
                                              fit: BoxFit.cover,
                                            )
                                                : (photoURL != null
                                                ? Image.network(
                                              photoURL!,
                                              fit: BoxFit.cover,
                                            )
                                                : Image.asset(
                                                "lib/profileImages/1_plant_profile.jpg")
                                    )))),
                                    Positioned(
                                      bottom: 5,
                                      right: 5,
                                      child: Container(
                                        width: 45,
                                        height: 45,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30.0),
                                            color: isDarkMode
                                                ? darkSeaGreen
                                                : darkGreyGreen),
                                        child: Icon(
                                          LineAwesomeIcons.camera_solid,
                                          size: 28.0,
                                          color: isDarkMode ? Colors.black87 : Colors
                                              .white70,
                                        ),
                                      ),
                                    )
                                  ]),
                                ),
                                const SizedBox(height: 40),
                                Form(
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: RichText(
                                          text: TextSpan(
                                            text: "Change Your ",
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .displayLarge,
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: "Full Name",
                                                style: TextStyle(
                                                  color: Theme
                                                      .of(context)
                                                      .primaryColor,
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
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .displayLarge,
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: "Email Address",
                                                style: TextStyle(
                                                  color: Theme
                                                      .of(context)
                                                      .primaryColor,
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
                                            color: Theme
                                                .of(context)
                                                .hintColor,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              isPasswordVisible =
                                              !isPasswordVisible;
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
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .displayLarge,
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: "Password",
                                                style: TextStyle(
                                                  color: Theme
                                                      .of(context)
                                                      .primaryColor,
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
                                            color: Theme
                                                .of(context)
                                                .hintColor,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              isPasswordVisible =
                                              !isPasswordVisible;
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
                                            color: Theme
                                                .of(context)
                                                .hintColor,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              isPasswordVisible =
                                              !isPasswordVisible;
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 35),
                                      CustomProfileButton(
                                          onPressed: saveChanges,
                                          width: 180,
                                          height: 80,
                                          text: "SAVE",
                                          color: Theme.of(context).primaryColor,
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
                                                        color: Theme
                                                            .of(context)
                                                            .hintColor
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
                  ),
                  if (isLoading)
                    Container(
                      color: Colors.black.withOpacity(0.7),
                      child: Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme
                                    .of(context)
                                    .primaryColor)),
                      ),
                    )
                ]
            ),
          )),
    );
  }

  Future<void> reAuthenticateUser(User user) async {
    String email = user.email!;
    String password = currPasswordController.text;

    AuthCredential credential = EmailAuthProvider.credential(
        email: email, password: password);

    await user.reauthenticateWithCredential(credential);
  }

  Future<void> saveChanges() async {
    setState(() {
      isLoading = true;
    });

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
        // Upload the image to Firebase Storage
        try {
          if (plantImage != null) {
            // Define Firebase Storage path
            Reference storageRef = FirebaseStorage.instance
                .ref()
                .child('profile_images')
                .child('${user.uid}.jpg');

            // Upload the file
            UploadTask uploadTask = storageRef.putFile(plantImage!);
            TaskSnapshot snapshot = await uploadTask;

            // Get the download URL of the uploaded image
            String downloadURL = await snapshot.ref.getDownloadURL();

            // Update user's profile with new photo URL
            await user.updatePhotoURL(downloadURL);

            setState(() {
              photoURL = downloadURL; // Set the new photoURL
            });
          }

        // Check if the full name field is not empty and update display name
        if (fullnameController.text.isNotEmpty) {
          await user.updateDisplayName(fullnameController.text);
          showMessage(
            "Your full name was changed successfully.",
            MessageType.success,
          );
        }

        // Check if the email field is not empty and has changed
        if (usernameController.text.isNotEmpty &&
            usernameController.text != user.email) {
          // Ensure that the current password field is filled
          if (currPasswordController.text.isEmpty) {
            showMessage(
              "Please enter your password to change your email.",
              MessageType.error,
            );
            setState(() {
              isLoading = false;
            });
            return;
          }

          // Re-authenticate the user before changing email
          await reAuthenticateUser(user);

          // Store the updated email temporarily
          updatedEmail = usernameController.text;

          // Send a verification email before updating the email
          await user.verifyBeforeUpdateEmail(updatedEmail!);

          // Notify the user to verify their email
          showMessage(
            "A verification email has been sent to $updatedEmail. Please verify the email to complete the update.",
            MessageType.info,
          );
        }

        // Check if the current password is filled for password change
        if (newPasswordController.text.isNotEmpty) {
          // Validate new password
          if (currPasswordController.text.isEmpty) {
            showMessage(
              "Please enter a new password to change your current password.",
              MessageType.error,
            );
            setState(() {
              isLoading = false;
            });
            return;
          }

          if (currPasswordController.text == newPasswordController.text) {
            showMessage(
              "You entered the same password!? The new password must be different from the current password.",
              MessageType.error,
            );
            setState(() {
              isLoading = false;
            });
            return;
          }

          // Re-authenticate the user before changing password
          await reAuthenticateUser(user);
          await user.updatePassword(newPasswordController.text);

          showMessage(
            "Your password was changed successfully.",
            MessageType.success,
          );
        }

        // Show success message if at least one field was updated
        if (fullnameController.text.isNotEmpty ||
            usernameController.text.isNotEmpty ||
            currPasswordController.text.isNotEmpty ||
            newPasswordController.text.isNotEmpty ||
            plantImage != null) {

          // Return updated values to the previous screen
          Navigator.pop(context, {
            'displayName': fullnameController.text.isNotEmpty
                ? fullnameController.text
                : user.displayName,
            'email': updatedEmail ?? user.email,
            'photoURL': photoURL ?? user.photoURL
          });
        } else {
          showMessage(
            "No changes made...",
            MessageType.info,
          );
          setState(() {
            isLoading = false;
          });
        }
      } on FirebaseAuthException catch (e) {
        showMessage(
          e.message ?? "An error occurred!",
          MessageType.error,
        );
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        showMessage(
          "An error occurred while updating profile! Please contact the support for help.",
          MessageType.error);
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void showMessage(String message, MessageType type) {
    // Determine the background color and icon based on the message type
    Color backgroundColor;
    IconData icon;
    IconData iconClose = Icons.close_rounded;

    switch (type) {
      case MessageType.error:
        backgroundColor = Colors.redAccent;
        icon = Icons.error_outline_rounded;
        break;
      case MessageType.info:
        backgroundColor = Colors.blueAccent; // Color for info messages
        icon = Icons.info_outline_rounded; // Icon for info messages
        break;
      case MessageType.success:
      default:
        backgroundColor = Theme.of(context).primaryColor;
        icon = Icons.check_circle_outline_rounded;
        break;
    }

    // Reference to ScaffoldMessenger
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // Show the Snackbar
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          const SizedBox(width: 7.5),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
            ),
          ),
          GestureDetector(
            onTap: () {
              scaffoldMessenger.hideCurrentSnackBar(); // Close the snackbar
            },
            child: Icon(
              iconClose,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      duration: const Duration(seconds: 3),
    );

    scaffoldMessenger.showSnackBar(snackBar);
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();

    final selectedSource = await showModalBottomSheet<ImageSource>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Choose image source",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildOptionCard(
                      icon: Icons.camera_alt_rounded,
                      label: "Camera",
                      onTap: () => Navigator.of(context).pop(ImageSource.camera),
                    ),
                    buildOptionCard(
                      icon: Icons.photo_library_rounded,
                      label: "Gallery",
                      onTap: () => Navigator.of(context).pop(ImageSource.gallery),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        }
    );

    if (mounted && selectedSource != null) {
      final pickedFile = await picker.pickImage(source: selectedSource);
      if (pickedFile != null) {
        setState(() {
          plantImage = File(pickedFile.path); // Save the selected image
        });
      }
    }
  }

  Widget buildOptionCard({required IconData icon, required String label, required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Rounded edges
        ),
        elevation: 4, // Shadow to make it stand out
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding inside the card
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ensure the icon and text are compact
            children: [
              Icon(
                icon,
                size: 50,
                color: const Color(0xFF388E3C), // Use accent color for the icons
              ),
              const SizedBox(height: 10), // Space between icon and text
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
