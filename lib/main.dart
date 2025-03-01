import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_friends/pages/calendar_pages/calendar_page.dart';
import 'package:plant_friends/pages/my_plants_pages/my_plants_page.dart';
import 'package:plant_friends/pages/profile_pages/other/locale_provider.dart';
import 'package:plant_friends/pages/profile_pages/profile_page.dart';
import 'package:plant_friends/pages/welcome_pages/test_auth_page.dart';
import 'package:plant_friends/pages/wiki_pages/wiki_page.dart';
import 'package:plant_friends/themes/dark_theme.dart';
import 'package:plant_friends/themes/light_theme.dart';
import 'package:plant_friends/themes/theme_provider.dart';
import 'package:plant_friends/widgets/custom_button_outlined_small.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase/firebase_api.dart';
import 'firebase/firebase_options.dart';

import 'l10n/l10n.dart';
import 'package:plant_friends/pages/tutorial_pages/tutorial_page.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider())
      ],
      child: const MyApp()
  )
  );


}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      title: 'Plant Friends',
      theme: lightTheme(context),
      darkTheme: darkTheme(context),
      themeMode: themeProvider.themeMode,
      debugShowCheckedModeBanner: false,
      supportedLocales: L10n.all,
      locale: localeProvider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },


      home: const TestAuthPage(),
    );
  }
}

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key});

  @override
  CustomNavigationBarState createState() => CustomNavigationBarState();
}

class CustomNavigationBarState extends State<CustomNavigationBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const MyPlantsPage(),
    const CalendarPage(),
    const WikiPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _checkFirstLogin();
  }

  /// Prüft, ob der aktuelle Benutzer den Hinweis schon gesehen hat
  Future<void> _checkFirstLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) return; // Falls kein Nutzer angemeldet ist, nichts tun

    String tutorialKey = 'hasSeenTutorialHint_${user.uid}';
    bool hasSeenTutorialHint = prefs.getBool(tutorialKey) ?? false;

    if (!hasSeenTutorialHint) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          _showTutorialHint();
        }
      });

      // Speichert den Status pro Benutzer
      prefs.setBool(tutorialKey, true);
    }
  }

  /// Zeigt einen Dialog mit dem Hinweis auf das Tutorial an
  void _showTutorialHint() {
    final localizations = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(localizations.welcomeTutorial),
          content: Text(localizations.descriptionTutorial),
          actions: [
            CustomButtonOutlinedSmall(
              onTap: () {
                Navigator.pop(context); // Dialog schließen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TutorialPage()),
                );
              },
              text: localizations.tutorialYes,
            ),
            const SizedBox(height: 20),
            CustomButtonOutlinedSmall(
              onTap: () {
                Navigator.pop(context); // Dialog schließen
              },
              text: localizations.later,
            )
          ],
        );
      },
    );
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: const Color(0xFF5aa06f),
        buttonBackgroundColor: const Color(0xFF388E3C),
        height: 80,
        index: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          CurvedNavigationBarItem(
            child: Icon(FluentIcons.leaf_three_24_regular,
                color: isDarkMode ? Colors.white : Colors.black.withOpacity(0.5)),

            label: localizations.myPlants,
              labelStyle: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black.withOpacity(0.5),
              ),
          ),
          CurvedNavigationBarItem(
            child: Icon(LineIcons.calendarWithWeekFocus,
                color: isDarkMode ? Colors.white : Colors.black.withOpacity(0.5)),
            label: localizations.calendar,
              labelStyle: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black.withOpacity(0.5),
              ),
          ),
          CurvedNavigationBarItem(
            child: Icon(LineIcons.bookOpen,
                color: isDarkMode ? Colors.white : Colors.black.withOpacity(0.5)),
            label: localizations.plantWiki,
              labelStyle: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black.withOpacity(0.5),
              ),

          ),
          CurvedNavigationBarItem(
            child: Icon(FluentIcons.person_accounts_20_regular,
                color: isDarkMode ? Colors.white : Colors.black.withOpacity(0.5)),
            label: localizations.profile,
              labelStyle: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black.withOpacity(0.5),
              ),
          ),
        ],
        animationDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}
