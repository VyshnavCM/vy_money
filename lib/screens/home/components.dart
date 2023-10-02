// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unused_local_variable, unused_import

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vy_money/colors/colors.dart';
import 'package:vy_money/data/model/category/category_model.dart';
import 'package:vy_money/data/model/profile/profile_model.dart';
import 'package:vy_money/data/utility.dart';
import 'package:vy_money/data/model/transaction/add_date.dart';
import 'package:vy_money/screens/transactions/all_transaction_screen.dart';
import 'package:vy_money/screens/transactions/transcation_screen.dart';

// Widget getList(AddData history, int index) {
//   return Dismissible(
//       key: UniqueKey(),
//       onDismissed: (direction) {
//         history.delete();
//       },
//       child: list(index, history));
// }

// Widget getList(AddData history, int index) {
//   return Dismissible(
//       key: UniqueKey(),
//       onDismissed: (direction) {
//         history.delete();
//       },
//       child: list(index, history));
// }

Padding transaction(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(left: 15, right: 10),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(
        'Recent transactions',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      TextButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) =>  TransactionHistoryPage()));
          },
          child: Text(
            'See all',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 88, 88, 88)),
          )),
    ]),
  );
}

Widget head() {
  return SizedBox(
    height: 320,
    child: Stack(
      children: [
        Column(
          children: [
            Container(
              width: double.infinity,
              height: 220,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 14, 23, 16),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
              ),
              child: ValueListenableBuilder(
                valueListenable:
                    Hive.box<UserProfile>('user_profile').listenable(),
                builder: (context, Box<UserProfile> box, _) {
                  final userProfile = box.get(0);
                  String greeting = updateGreeting();
                  return Stack(
                    children: [
                      Positioned(
                        top: 20,
                        left: 320,
                        child: CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.amber,
                          child: CircleAvatar(
                            radius: 23,
                            backgroundImage: AssetImage(
                                'assets/avatar${userProfile!.avatarIndex}.png'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              greeting,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w100),
                            ),
                            Text(
                              userProfile.name,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        amountCard()
      ],
    ),
  );
}

String updateGreeting() {
  DateTime now = DateTime.now();
  String greeting = '';

  if (now.hour < 12) {
    greeting = 'Good morning';
  } else if (now.hour < 17) {
    greeting = 'Good afternoon';
  } else {
    greeting = 'Good evening';
  }
  return greeting;
}

Positioned amountCard() {
  return Positioned(
    top: 120,
    left: 37,
    child: Container(
      height: 170,
      width: 320,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Total Balance',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 7,
          ),
          Center(
            child: Text(
              '₹ ${total()}',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 18,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 13,
                          backgroundColor: Color.fromARGB(255, 26, 108, 101),
                          child: Icon(
                            Icons.arrow_downward_rounded,
                            color: Colors.white,
                            size: 17,
                          ),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text(
                          'Expense',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '₹${expense()}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 13,
                          backgroundColor: Color.fromARGB(255, 26, 108, 101),
                          child: Icon(
                            Icons.arrow_upward_rounded,
                            color: Colors.white,
                            size: 17,
                          ),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text(
                          'Income',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '₹${income()}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 2,
          ),
        ],
      ),
    ),
  );
}
