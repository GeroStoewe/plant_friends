import 'package:flutter/material.dart';
import 'package:plant_friends/authentication/widgets/square_tile.dart';
import 'package:plant_friends/authentication/widgets/my_button.dart';
import 'package:plant_friends/authentication/widgets/my_text_field.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // Variables
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
                        const Text(
                            "Welcome to PlantFriends",
                            style: TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.w700
                            )
                        ),
                        const SizedBox(height: 20),
                        MyTextField(
                            controller: usernameController,
                            icon: Icons.alternate_email_rounded,
                            hintText: "Email Address",
                            obscureText: false
                        ),
                        const SizedBox(height: 20),
                        MyTextField(
                            controller: passwordController,
                            icon: Icons.lock_outline_rounded,
                            hintText: "Password",
                            obscureText: true
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {},
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text.rich(
                                    TextSpan(
                                        children: [
                                          TextSpan(
                                              text: "Forgot Password? ",
                                              style: TextStyle(
                                                  color: Colors.white38
                                              )
                                          ),
                                          TextSpan(
                                              text: "Reset Here",
                                              style: TextStyle(
                                                  color: Colors.lightGreenAccent
                                              )
                                          )
                                        ]
                                    )
                                ),
                              ]
                            ),
                          ),
                        const SizedBox(height: 15),
                        MyButton(
                            onTap: login,
                            text: "LOGIN"
                        ),
                        const SizedBox(height: 25),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  thickness: 0.5,
                                  color: Colors.white24
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Text(
                                  "Or continue with",
                                  style: TextStyle(
                                    color: Colors.white38
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                    thickness: 0.5,
                                    color: Colors.white24
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SquareTile(imagePath: 'lib/images/auth_Img/google_logo.png'),
                            SquareTile(imagePath: 'lib/images/auth_Img/apple_logo_dark_mode.png'),
                            SquareTile(imagePath: 'lib/images/auth_Img/x_logo_dark_mode.png'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {},
                          child: const Center(
                              child: Text.rich(
                                  TextSpan(
                                      children: [
                                        TextSpan(
                                            text: "New to PlantFriends? ",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white38
                                            )
                                        ),
                                        TextSpan(
                                            text: "Create Account",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.lightGreenAccent
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
