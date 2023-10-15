// ignore_for_file: unused_element, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vy_money/screens/splash/splash_screen.dart';



class IntroductionScreenPage extends StatefulWidget {
  const IntroductionScreenPage({super.key});

  @override
  _IntroductionScreenPageState createState() => _IntroductionScreenPageState();
}

class _IntroductionScreenPageState extends State<IntroductionScreenPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
    @override
  void initState() {
    super.initState();
    _checkFirstTime().then((isFirstTime) {
      if (!isFirstTime) {
        _markAsNotFirstTime();
        _navigateToSplashScreen();
      }
    });
  }

  final List<String> _imagePaths = [
    "assets/instruction1.png",
    "assets/instruction2.png",
    "assets/instruction3.png",
    
    // Add more image paths as needed.
  ];
    Future<bool> _checkFirstTime() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool isFirstTime = pref.getBool('first_time') ?? true;
    return isFirstTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: _imagePaths.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Image.asset(
                  _imagePaths[index],
                  fit: BoxFit.contain, // Cover the entire screen.
                );
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentPage > 0)
                      ElevatedButton(
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        },
                        child: const Text("Previous"),
                      ),
                    if (_currentPage < _imagePaths.length - 1)
                      ElevatedButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        },
                        child: const Text("Next"),
                      ),
                    if (_currentPage == _imagePaths.length - 1)
                      ElevatedButton(
                        onPressed: () {
                          _markAsNotFirstTime();
                          _navigateToSplashScreen();
                        },
                        child: const Text("Done"),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _markAsNotFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_time', false);
  }

  void _navigateToSplashScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const SplashScreen()));
  }
}
