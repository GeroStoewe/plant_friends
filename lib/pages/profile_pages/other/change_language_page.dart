import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:plant_friends/pages/profile_pages/other/locale_provider.dart';
import 'package:plant_friends/widgets/custom_card_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../themes/colors.dart';
import '../../../themes/theme_provider.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/custom_profile_button.dart';
import '../../authentication_pages/auth_page.dart';
import '../../authentication_pages/forgot_password_page.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangeLanguagePage extends StatefulWidget {
  const ChangeLanguagePage({Key? key}) : super(key: key);

  @override
  _ChangeLanguagePageState createState() => _ChangeLanguagePageState();
}

class _ChangeLanguagePageState extends State<ChangeLanguagePage> {
  bool isLoading = false;

  changeLanguage(String localeCode) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      localeProvider.setLocale(localeCode);
      setState(() {
        isLoading = false;
        });
      });
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
          localizations.changeLanguage,
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
            iconSize: 28 * textScaleFactor,
            icon:
            Icon(isDarkMode ? LineAwesomeIcons.sun : LineAwesomeIcons.moon),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              alignment: Alignment.center,
              padding: isLargePhone(context) ? const EdgeInsets.all(15.0) : const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomCardButton(
                          image: Image.asset("lib/images/profile/united-states.png"),
                          text: "English",
                          onTap: () => changeLanguage('en'),
                          ),
                      ),
                      Expanded(
                        child: CustomCardButton(
                          image: Image.asset("lib/images/profile/germany.png"),
                          text: "Deutsch",
                          onTap: () => changeLanguage('de'),
                        ),
                        ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomCardButton(
                          image: Image.asset("lib/images/profile/france.png"),
                          text: "Français",
                          onTap: () => changeLanguage('fr'),
                        ),
                      ),
                      Expanded(
                        child: CustomCardButton(
                          image: Image.asset("lib/images/profile/italy.png"),
                          text: "Italiano",
                          onTap: () => changeLanguage('it'),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomCardButton(
                          image: Image.asset("lib/images/profile/spain.png"),
                          text: "Español",
                          onTap: () => changeLanguage('es'),
                        ),
                      ),
                    ],
                  )
        ],
      ),
            )
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
    ]
    )
    );
  }
}
