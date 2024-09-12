import 'package:flutter/material.dart';
import 'package:plant_friends/authentication/login_page.dart';
import 'package:plant_friends/authentication/square_tile.dart';

import '../../themes/colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});

  // Variables
  final usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  width: size.width,
                  height: size.height * 0.45,
                  child: Image.asset(
                    'lib/authentication/images/forgotpassword_wallpaper.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            Positioned(
                top: size.height * 0.42,
                child: Container(
                  width: size.width,
                  height: size.height * 0.58,
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0)
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 5),
                          Text(
                              "Reset your Password",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineMedium
                          ),
                          const SizedBox(height: 50),
                          CustomTextField(
                              controller: usernameController,
                              icon: Icons.alternate_email_rounded,
                              hintText: "Please enter your Email Address",
                              obscureText: false
                          ),
                          const SizedBox(height: 30),
                          CustomButton(
                              onTap: resetPassword,
                              text: "RESET PASSWORD"
                          ),
                          const SizedBox(height: 250),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()
                                  )
                              );
                            },
                            child: Center(
                              child: Text.rich(
                                  TextSpan(
                                      children: [
                                        TextSpan(
                                            text: "Already have an Account? ",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: isDarkMode ? dmLightGrey : lmDarkGrey
                                            )
                                        ),
                                        TextSpan(
                                            text: "Login",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Theme.of(context).hintColor
                                            )
                                        )
                                      ]
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }

  void resetPassword() {}
}