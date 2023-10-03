// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, prefer_typing_uninitialized_variables, unused_local_variable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:vy_money/data/model/category/category_model.dart';

import 'package:vy_money/data/model/transaction/add_date.dart';
import 'package:vy_money/db/category/category_db.dart';
import 'package:vy_money/screens/add_transcations/add_screen.dart';
import 'package:vy_money/colors/colors.dart';
import 'package:vy_money/screens/profile/profile_screen.dart';
import 'package:vy_money/screens/transactions/transcation_screen.dart';
import 'package:vy_money/screens/home/components.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var history;
  final box = Hive.box<AddData>('data');
  @override
  void initState() {
    super.initState();
    //to update the greeting every minute
    Timer.periodic(Duration(minutes: 1), (timer) {
      updateGreeting();
    });
  }

  @override
  Widget build(BuildContext context) {
    CategoryDb.instance.refreshUI();
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      extendBody: true,
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (context, value, child) {
            final items = box.values.toList().reversed.toList();// Reverse the list
             items.sort((a, b) => b.datetime.compareTo(a.datetime)); // Sorting the list according to latest date 
            final itemCount = items.length > 6 ? 6 : items.length;
            return SingleChildScrollView(
              child: Column(
                children: [
                  head(),
                  transaction(context),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      history = items[index];
                      return getTransactionList(history, index, context);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void showDeleteConfirmationDialog(AddData history) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                history.delete(); // Perform the deletion
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Widget getTransactionList(AddData history, int index, BuildContext context) {
    return Slidable(
        key: UniqueKey(),
        endActionPane: ActionPane(
          motion: DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (ctx) {
                showDeleteConfirmationDialog(history);
              },
              backgroundColor: Color.fromARGB(255, 246, 5, 5),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
            SlidableAction(
              onPressed: (ctx) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddScreen(editData: history),
                  ),
                );
              },
              backgroundColor: Color(0xFF21B7CA),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
          ],
        ),
        child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return InfoDialog(history: history);
                },
              );
            },
            child: list(index, history)));
  }

  Padding list(int index, AddData history) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: GestureDetector(
        child: ListTile(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                history.category.toString(),
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
              Text(
                history.heading,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 88, 88, 88)),
              ),
            ],
          ),
          trailing: SizedBox(
            width: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  history.mode,
                  style: TextStyle(fontSize: 16),
                ),
                Text('₹${history.amount}',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: history.type == CategoryType.income.toString()
                            ? incomeColor
                            : expenseColor)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InfoDialog extends StatelessWidget {
  final AddData history;

  const InfoDialog({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text('Transaction Details')),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text('Category :',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(
                ' ${history.category.toString()}',
                style: TextStyle(fontSize: 17),
              ),
            ],
          ),
           SizedBox(height: 5,),
          Row(
            children: [
              Text('Mode       :',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(
                ' ${history.mode}',
                style: TextStyle(fontSize: 17),
              ),
            ],
          ),
           SizedBox(height: 5,),

          Row(
            children: [
              Text('Details     :',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(
                ' ${history.heading}',
                style: TextStyle(fontSize: 17),
              ),
            ],
          ),
           SizedBox(height: 5,),

          Row(
            children: [
              Text('Amount   :',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(
                ' ₹${history.amount}',
                style: TextStyle(fontSize: 17),
              ),
            ],
          ),
           SizedBox(height: 5,),

          Row(
            children: [
              Text('Date         :',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(
                ' ${DateFormat('MMM d, yyyy').format(history.datetime)}',
                style: TextStyle(fontSize: 17),
              ),
            ],
          ), // Format the date as needed
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
