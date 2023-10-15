// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:vy_money/widgets/bottomnav.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async {
    await Future.delayed(const Duration(milliseconds: 3000), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const BottomNav()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(3, 10, 5, 1),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 200,
            ),
            SizedBox(
                height: 300,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 70,
                    ),
                    Image.asset('assets/Splash_image_2.png'),
                  ],
                )),
            const SizedBox(
              height: 50,
            ),
            const Text(
              '" Empower Your Finances, \n Effortlessly Manage Every Penny "',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 19),
            )
          ],
        ),
      ),
    );
  }
}
