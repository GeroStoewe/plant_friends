import 'package:flutter/material.dart';
import 'package:plant_friends/welcomePages/welcome_page_1.dart';
import 'package:plant_friends/welcomePages/welcome_page_2.dart';

class WelcomePageToggle extends StatefulWidget {
  const WelcomePageToggle({Key? key}) : super(key: key);

  @override
  _WelcomePageToggleState createState() => _WelcomePageToggleState();
}

class _WelcomePageToggleState extends State<WelcomePageToggle> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: const [
              WelcomePage1(),
              WelcomePage2(),
            ],
          ),
          Positioned(
            bottom: 30.0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDot(0),
                const SizedBox(width: 5),
                _buildDot(1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3.0),
      height: 8.0,
      width: 8.0,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.greenAccent : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}
