// ignore_for_file: prefer_const_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:vy_money/colors/colors.dart';
import 'package:vy_money/db/category/category_db.dart';
import 'package:vy_money/screens/add_category/expense_category.list.dart';
import 'package:vy_money/screens/add_category/income_category_list.dart';
import 'package:vy_money/widgets/bottomnav.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    CategoryDb().refreshUI();
    super.initState();
  }

  int indexTypeColor = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: mainBackgroundColor,
      body: SafeArea(
        
        child: Column(
          children: [
            topBar(),
            TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              tabs: const [
                Tab(
                  child: Text('Income',style: TextStyle(fontSize: 17),),
                ),
                Tab(
                  text: 'Expense',
                ),
              ],
            ),SizedBox(height: 15,),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  IncomeCategoryList(),
                  ExpenseCategoryList(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  

  Padding topBar() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Category',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
