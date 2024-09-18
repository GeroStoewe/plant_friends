import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plant_friends/plants/firebase_options.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:plant_friends/themes/dark_theme.dart';
import 'package:plant_friends/themes/light_theme.dart';

import 'package:plant_friends/plants/my_plants_page.dart';

import 'calendar/calendar_page.dart';
import 'plantwiki/plant_wiki_page.dart';
import 'account/account_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const MyPlantsPage(),
    const CalendarPage(),
    const PlantWikiPage(),
    const AccountPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Shows the current page based on index
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent, // Background behind the navbar
        color: const Color(0xFF388E3C), // Curved navbar color
        buttonBackgroundColor: const Color(0xFF388E3C), // Color of the active button
        height: 68, // Height of the navbar
        index: _selectedIndex, // Current selected index
        onTap: _onItemTapped, // Callback for taps
        items: const [
          CurvedNavigationBarItem(
            child: Icon(Icons.local_florist_sharp, color: Color(0xFFF5F5DC)),// Warm orange color),
            label: 'My Plants',
              labelStyle: TextStyle(color: Color(0xFFF5F5DC))
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.calendar_today, color: Color(0xFFF5F5DC)),
            label: 'Calendar',
              labelStyle: TextStyle(color: Color(0xFFF5F5DC))
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.book, color: Color(0xFFF5F5DC)),
            label: 'Plant-Wiki',
              labelStyle: TextStyle(color: Color(0xFFF5F5DC))
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.account_circle, color: Color(0xFFF5F5DC)),
            label: 'Account',
              labelStyle: TextStyle(color: Color(0xFFF5F5DC))
          ),
        ],
        animationDuration: const Duration(milliseconds: 300), // Animation duration
      ),
    );
  }
}
