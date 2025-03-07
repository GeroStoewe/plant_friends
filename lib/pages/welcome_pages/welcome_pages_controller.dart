import 'package:flutter/material.dart';
import 'package:plant_friends/pages/welcome_pages/welcome_page_1.dart';
import 'package:plant_friends/pages/welcome_pages/welcome_page_2.dart';

class WelcomePagesController extends StatefulWidget {
  const WelcomePagesController({Key? key}) : super(key: key);

  @override
  _WelcomePagesControllerState createState() => _WelcomePagesControllerState();
}

class _WelcomePagesControllerState extends State<WelcomePagesController> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: const [
              WelcomePage1(), // Erste Willkommensseite
              WelcomePage2(), // Zweite Willkommensseite
            ],
          ),
          Positioned(
            bottom: size.height * 0.02,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                2, // Anzahl der Seiten (WelcomePage1 und WelcomePage2)
                    (index) => buildDot(index, context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDot(int index, BuildContext context) {
    return Container(
      height: 16,
      width: _currentPage == index ? 16 : 10,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: _currentPage == index
            ? Theme.of(context).primaryColor
            : Colors.grey,
      ),
    );
  }
}
