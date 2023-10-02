// ignore_for_file: unused_import, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:vy_money/data/model/category/category_model.dart';
import 'package:vy_money/screens/home/home_screen.dart';
import '../../colors/colors.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vy_money/data/model/transaction/add_date.dart';
import 'package:vy_money/screens/add_transcations/add_screen.dart';
import 'package:vy_money/screens/profile/profile_screen.dart';
import 'package:vy_money/screens/transactions/transcation_screen.dart';
import 'package:vy_money/screens/home/components.dart';

import 'package:intl/intl.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  _TransactionHistoryPageState createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Box<AddData> box = Hive.box<AddData>('data');

  // Filters
  bool showIncome = true;
  bool showExpense = true;
  DateTime? selectedDate;
  DateTime? startDate;
  DateTime? endDate;
  DateTimeRange? selectedDateRange;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {
      if (_tabController.index == 0) {
        showIncome = true;
        showExpense = true;
      } else if (_tabController.index == 1) {
        showIncome = true;
        showExpense = false;
      } else if (_tabController.index == 2) {
        showIncome = false;
        showExpense = true;
      }
    });
  }

  List<AddData> getFilteredTransactions() {
    return box.values.where((transaction) {
      final isIncome = transaction.type == CategoryType.income.toString();
      if (!showIncome && isIncome) return false; // Filter income
      if (!showExpense && !isIncome) return false; // Filter expense

      // Extract date part from transaction datetime
      final transactionDate = DateTime(
        transaction.datetime.year,
        transaction.datetime.month,
        transaction.datetime.day,
      );

      if (selectedDate != null) {
        // Extract date part from selectedDate
        final selectedDateOnly = DateTime(
          selectedDate!.year,
          selectedDate!.month,
          selectedDate!.day,
        );

        // Compare date parts
        if (transactionDate != selectedDateOnly) {
          return false; // Date filter
        }
      }

      if (startDate != null && endDate != null) {
        // Extract date part from selectedDateRange start and end dates
        final startDateOnly = DateTime(
          startDate!.year,
          startDate!.month,
          startDate!.day,
        );
        final endDateOnly = DateTime(
          endDate!.year,
          endDate!.month,
          endDate!.day,
        );

        // Compare date parts
        if (transactionDate.isBefore(startDateOnly) ||
            transactionDate.isAfter(endDateOnly)) {
          return false; // Date range filter
        }
      }

      return true;
    }).toList();
  }

  void _refreshList() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: mainBackgroundColor,
        centerTitle: true,
        title: const Text(
          'Transaction History',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              child: Text(
                'All',
                style: TextStyle(fontSize: 17),
              ),
            ),
            Tab(
              child: Text(
                'Income',
                style: TextStyle(fontSize: 17),
              ),
            ),
            Tab(
              child: Text(
                'Expense',
                style: TextStyle(fontSize: 17),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildDateFilter(),
          Expanded(
            child: _buildTransactionList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDateFilter() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            style: const ButtonStyle(elevation: MaterialStatePropertyAll(10)),
            onPressed: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null) {
                setState(() {
                  selectedDate = pickedDate;
                  startDate = null;
                  endDate = null;
                  selectedDateRange = null;
                });
              }
            },
            child: Text(selectedDate == null
                ? 'Select Date'
                : DateFormat('d MMM yy').format(selectedDate!)),
          ),
          ElevatedButton(
            style: const ButtonStyle(elevation: MaterialStatePropertyAll(10)),
            onPressed: () async {
              DateTimeRange? pickedDateRange = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
                currentDate: selectedDateRange?.start ?? DateTime.now(),
                initialDateRange: startDate != null && endDate != null
                    ? DateTimeRange(start: startDate!, end: endDate!)
                    : null,
              );
              if (pickedDateRange != null) {
                setState(() {
                  selectedDateRange = pickedDateRange;
                  startDate = pickedDateRange.start;
                  endDate = pickedDateRange.end;
                  selectedDate = null;
                });
              }
            },
            child: Text(
              selectedDateRange != null
                  ? '${DateFormat('dd-MMM-yy').format(selectedDateRange!.start)} - ${DateFormat('dd-MMM-yy').format(selectedDateRange!.end)}'
                  : 'Select Date Range',
            ),
          ),
          IconButton(
            style: const ButtonStyle(elevation: MaterialStatePropertyAll(10)),
            onPressed: () {
              setState(() {
                selectedDate = null;
                startDate = null;
                endDate = null;
                selectedDateRange = null;
              });
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    final filteredTransactions = getFilteredTransactions();
    // Sort the transactions by date in descending order
    filteredTransactions.sort((a, b) => b.datetime.compareTo(a.datetime));

    if (filteredTransactions.isEmpty) {
      return const Center(
        child: Text('No transactions found.'),
      );
    }
    
  void showDeleteConfirmationDialog(AddData transaction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              child:const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child:const Text('Confirm'),
              onPressed: () {
                transaction.delete(); 
                _refreshList();// Perform the deletion
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
    return ListView.builder(
      itemCount: filteredTransactions.length,
      itemBuilder: (ctx, index) {
        final transaction = filteredTransactions[index];

        return Slidable(
          key: UniqueKey(),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: (ctx) {
                  showDeleteConfirmationDialog(transaction);
                  // transaction.delete();
                  // _refreshList();
                },
                backgroundColor: const Color.fromARGB(255, 246, 5, 5),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
              SlidableAction(
                onPressed: (ctx) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddScreen(editData: transaction),
                    ),
                  );
                },
                backgroundColor: const Color(0xFF21B7CA),
                foregroundColor: Colors.white,
                icon: Icons.edit,
                label: 'Edit',
              ),
            ],
          ),
          child: ListTile(
             onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return InfoDialog(history: transaction);
                },
              );
            },
            title: Text(transaction.category,
                style: const TextStyle(fontSize: 18)),
            subtitle: Text(
              DateFormat('MMM d, yyyy').format(transaction.datetime),
            ),
            trailing: SizedBox(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    transaction.mode,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text('₹${transaction.amount}',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color:
                              transaction.type == CategoryType.income.toString()
                                  ? incomeColor
                                  : expenseColor)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
