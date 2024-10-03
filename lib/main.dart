import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plant_friends/plantWiki/wiki_filter_pages/wiki_page_filter_difficulty.dart';
import 'package:plant_friends/plants/firebase_options.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:plant_friends/plantwiki/wiki_page.dart';
import 'package:plant_friends/themes/dark_theme.dart';
import 'package:plant_friends/themes/light_theme.dart';

import 'package:plant_friends/plants/my_plants_page.dart';

import 'Services/firebase_api.dart';
import 'calendar/calendar_page.dart';
import 'plantwiki/plant_wiki_page.dart';
import 'account/account_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const NavigationBar(),
    );
  }
}

class NavigationBar extends StatefulWidget {
  const NavigationBar({super.key});

  @override
  NavigationBarState createState() => NavigationBarState();
}

class NavigationBarState extends State<NavigationBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const MyPlantsPage(),
    const CalendarPage(),
    const WikiPage(),
    const AccountPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
            label: 'My Plants',
              labelStyle: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black.withOpacity(0.5),
              ),
          ),
          CurvedNavigationBarItem(
            child: Icon(LineIcons.calendarWithWeekFocus,
                color: isDarkMode ? Colors.white : Colors.black.withOpacity(0.5)),
            label: 'Calendar',
              labelStyle: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black.withOpacity(0.5),
              ),
          ),
          CurvedNavigationBarItem(
            child: Icon(LineIcons.bookOpen,
                color: isDarkMode ? Colors.white : Colors.black.withOpacity(0.5)),
            label: 'Plant-Wiki',
              labelStyle: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black.withOpacity(0.5),
              ),
          ),
          CurvedNavigationBarItem(
            child: Icon(FluentIcons.person_accounts_20_regular,
                color: isDarkMode ? Colors.white : Colors.black.withOpacity(0.5)),
            label: 'Account',
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
