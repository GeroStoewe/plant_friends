import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../themes/colors.dart';
import '../../../themes/theme_provider.dart';
import '../../../widgets/custom_card.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPage createState() => _AboutPage();
}

class _AboutPage extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Size size = MediaQuery.of(context).size;

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
            "About",
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: isDarkMode
                      ? Colors.white
                      : Colors.black, // Dynamic color for dark and light mode
                ),
          ),
          actions: [
            IconButton(
              onPressed: themeProvider.toggleTheme,
              color: isDarkMode ? Colors.white : Colors.black,
              iconSize: 30,
              icon: Icon(
                  isDarkMode ? LineAwesomeIcons.sun : LineAwesomeIcons.moon),
            ),
          ],
        ),
        body: Stack(children: [
          Column(
            children: [
              SizedBox(
                width: size.width,
                height: size.height * 0.45,
                child: Image.asset(
                  'lib/images/profile/about_wallpaper.jpg',
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
                          topRight: Radius.circular(30.0))),
                  child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 5),
                            CustomCard(
                              headline: "About Us",
                              icon: Icons.info_outline_rounded,
                              text: "We (Laura Voß, Lisa Kütemeier, \nAylin Oymak, Gero Stöwe) are \nstudying computer science in the \n3rd semester. We developed this \nplant app as part of the “Software \nEngineering” course. Our vision is to \nsupport plant lovers in the planning, \nselection and care of houseplants.",
                            ),
                            const SizedBox(height: 10),
                            CustomCard(
                              headline: "App Version",
                              icon: Icons.build_circle,
                              text: "1.0.0",
                            ),
                          ]))))
        ]));
  }
}
