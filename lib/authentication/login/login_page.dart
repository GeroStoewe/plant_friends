import 'package:flutter/material.dart';
import 'package:plant_friends/authentication/login/square_tile.dart';
import 'package:plant_friends/themes/colors.dart';
import 'package:plant_friends/widgets/custom_button.dart';
import 'package:plant_friends/widgets/custom_text_field.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // Variables
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

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
                Image.asset(
                  'lib/images/auth_Img/login_wallpaper.jpg',
                  width: size.width,
                  height: size.height * 0.45,
                  fit: BoxFit.cover,
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
                    child: Column(
                      children: [
                        const SizedBox(height: 5),
                        Text(
                            "Welcome to PlantFriends",
                            style: Theme.of(context).textTheme.headlineMedium
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                            controller: usernameController,
                            icon: Icons.alternate_email_rounded,
                            hintText: "Email Address",
                            obscureText: false
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                            controller: passwordController,
                            icon: Icons.lock_outline_rounded,
                            hintText: "Password",
                            obscureText: true
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text.rich(
                                    TextSpan(
                                        children: [
                                          TextSpan(
                                              text: "Forgot Password? ",
                                              style: TextStyle(
                                                  color: isDarkMode ? dmLightGrey : lmDarkGrey
                                              )
                                          ),
                                          TextSpan(
                                              text: "Reset Here",
                                              style: TextStyle(
                                                  color: Theme.of(context).hintColor
                                              )
                                          )
                                        ]
                                    )
                                ),
                              ]
                            ),
                          ),
                        const SizedBox(height: 15),
                        CustomButton(
                            onTap: login,
                            text: "LOGIN"
                        ),
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  thickness: 0.5,
                                  color: isDarkMode ? dmDarkGrey : lmLightGrey
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Text(
                                  "Or continue with",
                                  style: TextStyle(
                                    color: isDarkMode ? dmLightGrey : lmDarkGrey
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                    thickness: 0.5,
                                    color: isDarkMode ? dmDarkGrey : lmLightGrey
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SquareTile(imagePath: 'lib/authentication/login/images/google_logo.png'),
                            SquareTile(imagePath: isDarkMode ? 'lib/authentication/login/images/apple_logo_dark_mode.png' : 'lib/authentication/login/images/apple_logo_light_mode.png'),
                            SquareTile(imagePath: isDarkMode ? 'lib/authentication/login/images/x_logo_dark_mode.png' : 'lib/authentication/login/images/x_logo_light_mode.png'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {},
                          child: Center(
                              child: Text.rich(
                                  TextSpan(
                                      children: [
                                        TextSpan(
                                            text: "New to PlantFriends? ",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: isDarkMode ? dmLightGrey : lmDarkGrey
                                            )
                                        ),
                                        TextSpan(
                                            text: "Create Account",
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
                )
            ),
          ],
        ),
      ),
    );
  }

  void login() {}
}
