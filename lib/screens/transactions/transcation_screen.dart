// // ignore_for_file: unused_import, prefer_const_constructors, prefer_typing_uninitialized_variables

// import 'package:flutter/material.dart';
// import 'package:vy_money/data/model/category/category_model.dart';
// import '../../colors/colors.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:vy_money/data/model/transaction/add_date.dart';
// import 'package:vy_money/screens/add_transcations/add_screen.dart';
// import 'package:vy_money/screens/profile/profile_screen.dart';
// import 'package:vy_money/screens/transactions/transcation_screen.dart';
// import 'package:vy_money/screens/home/components.dart';

// TextEditingController searchController = TextEditingController();


// class Transactions extends StatefulWidget {
//   const Transactions({super.key});

//   @override
//   State<Transactions> createState() => _TransactionsState();
// }

// class _TransactionsState extends State<Transactions> {
//   var history;
//   final box = Hive.box<AddData>('data');
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Transactions'),
//         centerTitle: true,
//       ),
//       body: SafeArea(
         
//         child: mainContainer(context)),
//     );
//   }

//   Padding mainContainer(BuildContext context) {
//     return Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: CustomScrollView(
//           slivers: [
            
//             SliverToBoxAdapter(
//               child:  searchBox(),
//             ),
//             SliverList(
//                 delegate: SliverChildBuilderDelegate(
//               (context, index) {
//                 history = box.values.toList()[index];
//                 return Expanded(child: getListFull(history, index));
//               },
//               childCount: box.length,
//             ))
//           ],
//         ));
//   }

// }
//   Padding searchBox() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: SizedBox(
//                   height: 40,
//                   width: 10,
//                   child: TextField(
//                     controller: searchController,
//                     decoration: InputDecoration(
//                       contentPadding: const EdgeInsets.symmetric(
//                           vertical: 10, horizontal: 19),
//                       hoverColor: Colors.white,
//                       // labelText: 'Search',
//                       suffixIcon: IconButton(
//                         icon: const Icon(Icons.search),
//                         onPressed: () {
//                           // searchAndUpdateStudents(searchController.text);
//                           //  FocusScope.of(context).unfocus();
//                           // FocusScopeNode currentFocus = FocusScope.of(context);
//                           // if (!currentFocus.hasPrimaryFocus) {
//                           //   currentFocus.unfocus();
//                           // }
//                         },
//                       ),
//                       border: OutlineInputBorder(
//                         borderSide: const BorderSide(
//                           color: Colors.white,
//                           width: 5.0,
//                         ),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       filled: true,
//                       hintStyle: const TextStyle(
//                           color: Color.fromARGB(255, 112, 110, 110)),
//                       hintText: "Search transaction",
//                       fillColor: Colors.white,
//                     ),
//                   ),
//                 ),
//     );
//   }

// Row topBar(BuildContext context) {
//   return Row(
//     children: [
//       IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(Icons.arrow_back)),
//       const SizedBox(
//         width: 95,
//       ),
//       const Text(
//         "Transcations",
//         style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
//       ),
//     ],
//   );
// }

// Widget getListFull(AddData history, int index) {
//   return Dismissible(
//       key: UniqueKey(),
//       onDismissed: (direction) {
//         history.delete();
//       },
//       child: listFull(index, history));
// }

// ListTile listFull(int index, AddData history) {
//   return ListTile(
//     title: Text(
//       history.category,
//       style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
//     ),
//     subtitle: Text(
//       history.heading,
//       style: TextStyle(
//           fontSize: 17, fontWeight: FontWeight.w600, color: Colors.grey),
//     ),
//     trailing: SizedBox(
//       width: 200,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             history.mode,
//             style: TextStyle(fontSize: 16),
//           ),
//           Text('₹${history.amount}',
//               style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w600,
//                   color:
//                       history.type == CategoryType.income.toString()  ? incomeColor : expenseColor)),
//         ],
//       ),
//     ),
//   );
// }
