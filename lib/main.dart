// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:vy_money/colors/colors.dart';
import 'package:vy_money/data/model/category/category_model.dart';
import 'package:vy_money/data/model/profile/profile_model.dart';
import 'package:vy_money/data/model/transaction/add_date.dart';
import 'package:vy_money/db/category/category_db.dart';
import 'package:vy_money/screens/instroduction/introduction_screen.dart';
import 'package:vy_money/screens/splash/splash_screen.dart';
import 'package:vy_money/screens/statistics/statistics_screen.dart';
import 'package:vy_money/widgets/bottomnav.dart';
import 'package:hive_flutter/hive_flutter.dart';


void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(AddDataAdapter());
  Hive.registerAdapter(CategoryTypeAdapter());
  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(UserProfileAdapter());
  Hive.registerAdapter(PresetAvatarAdapter());
  var userBox = await Hive.openBox<UserProfile>('user_profile');
  var presetBox = await Hive.openBox<PresetAvatar>('preser_avatar');
  await Hive.openBox<AddData>('data');
  
  if(userBox.isEmpty){
    userBox.add(UserProfile('User', 1));
  }

  if(presetBox.isEmpty){
    presetBox.add(PresetAvatar('assets/avatar1.png'));
  }
  

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VY Money',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        useMaterial3: true,
      ),
      home:const IntroductionScreenPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

