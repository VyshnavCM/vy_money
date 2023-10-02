import 'package:flutter/material.dart';
import 'package:vy_money/colors/colors.dart';
import 'package:vy_money/screens/add_category/add_category_screen.dart';
import 'package:vy_money/screens/add_category/category_add_popup.dart';
import 'package:vy_money/screens/add_transcations/add_screen.dart';
import 'package:vy_money/screens/home/home_screen.dart';
import 'package:vy_money/screens/profile/profile_screen.dart';
import 'package:vy_money/screens/statistics/statistics_screen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int indexColor = 0;
  List screen = [
    const HomeScreen(),
    AnalysisPage(),
    const Category(),
    const Profile()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: mainBackgroundColor,
      body: screen[indexColor],
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          if (indexColor == 2) {
            showCategoryAddPopup(context);
          } else {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddScreen()));
                
          }
        },
        shape: const CircleBorder(),
        backgroundColor: primaryColor,
        
        child: const Icon(
          Icons.add,
          color: Color.fromARGB(255, 255, 255, 255),
          size: 25,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color:backgroundCardCOlor ,
        clipBehavior: Clip.antiAlias,
        height: 60,
        // shadowColor: Color.fromARGB(255, 255, 255, 255),
        shape: const CircularNotchedRectangle(),
        // elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                  onTap: () {
                    setState(() {
                      indexColor = 0;
                    });
                  },
                  child: Icon(
                    Icons.home,
                    size: 30,
                    color: indexColor == 0 ? primaryColor : Colors.white,
                  )),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      indexColor = 1;
                    });
                  },
                  child: Icon(
                    Icons.bar_chart_outlined,
                    size: 30,
                    color: indexColor == 1 ? primaryColor : Colors.white,
                  )),
              const SizedBox(
                width: 30,
              ),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      indexColor = 2;
                    });
                  },
                  child: Icon(
                    Icons.category_outlined,
                    size: 30,
                    color: indexColor == 2 ? primaryColor : Colors.white,
                  )),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      indexColor = 3;
                    });
                  },
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: indexColor == 3 ? primaryColor : Colors.white,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
