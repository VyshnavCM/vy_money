// // ignore_for_file: prefer_const_constructors

// ignore_for_file: library_private_types_in_public_api
// import 'package:month_year_picker/month_year_picker.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vy_money/colors/colors.dart';
import 'package:vy_money/data/model/category/category_model.dart';
import 'package:vy_money/data/model/transaction/add_date.dart'; // Import your transaction model
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import 'package:intl/intl.dart'; // Import the 'intl' package for date formatting

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime? selectedMonth;
  DateTimeRange? selectedDateRange;
  List<AddData>? transactions; // Make transactions nullable

  @override
  void initState() {
    super.initState();
    _loadTransactions();
    _tabController = TabController(length: 2, vsync: this);
    // selectedMonth = DateTime.now();
  }

  Future<void> _loadTransactions() async {
    // Open your Hive box where transactions are stored
    var transactionBox = await Hive.openBox<AddData>('data');
    // Retrieve the transactions from the Hive box
    transactions = transactionBox.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: mainBackgroundColor,
        title: const Text(
          'Statistics',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Income'),
            Tab(text: 'Expense'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Filter Options (Month Selector and Date Range Picker)
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: const ButtonStyle(
                      elevation: MaterialStatePropertyAll(10)),
                  onPressed: () async {
                    DateTime? pickedDate = await showMonthPicker(
                        context: context,
                        initialDate: selectedMonth ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                        selectedMonthBackgroundColor: primaryColor,
                        roundedCornersRadius: 10);
                    if (pickedDate != null && pickedDate != selectedMonth) {
                      setState(() {
                        // Set the selected month to the picked month and year
                        selectedMonth = pickedDate;
                        selectedDateRange =
                            null; // Clear the date range filter when selecting a month
                      });
                    }
                  },
                  child: Text(
                    selectedMonth != null
                        ? DateFormat('MMMM yyyy').format(selectedMonth!)
                        : 'Select a month',
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                ElevatedButton(
                  style: const ButtonStyle(
                    elevation: MaterialStatePropertyAll(10),
                  ),
                  onPressed: () async {
                    DateTimeRange? pickedDateRange = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                      currentDate: selectedDateRange?.start ?? DateTime.now(),
                      initialDateRange: selectedDateRange ??
                          DateTimeRange(
                              start: DateTime.now(), end: DateTime.now()),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            primaryColor: Colors.blue, // Your primary color
                            colorScheme:
                                const ColorScheme.light(primary: Colors.blue),
                            buttonTheme: const ButtonThemeData(
                                textTheme: ButtonTextTheme.primary),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickedDateRange != null) {
                      setState(() {
                        selectedDateRange = pickedDateRange;
                        selectedMonth =
                            null; // Clear the month filter when selecting a date range
                      });
                    }
                  },
                  child: Text(
                    selectedDateRange != null
                        ? '${DateFormat('dd-MMM-yy').format(selectedDateRange!.start)} - ${DateFormat('dd-MMM-yy').format(selectedDateRange!.end)}'
                        : 'Select a date range',
                  ),
                ),
              ],
            ),
          ),
          // SfCircularChart
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildChart(CategoryType.income.toString()),
                _buildChart(CategoryType.expense.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(String type) {
    if (selectedDateRange == null && selectedMonth == null) {
      return const Center(
        child: Text(
          'Select a time period',
          style: TextStyle(fontSize: 15),
        ),
      );
    }
    if (transactions != null && transactions!.isEmpty) {
      return const Center(
        child: Text(
          'No transactions available for the selected period.',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    // Create a map to aggregate amounts by category
    final Map<String, double> categoryAmountMap = {};
    double totalAmount = 0;
    // Iterate through transactions to aggregate amounts
    for (var transaction in transactions!) {
      if (transaction.type == type && _filterTransaction(transaction)) {
        final category = transaction.category;
        final amount = double.parse(transaction.amount);
        totalAmount += amount;
        // Checking if the category exists in the map
        if (categoryAmountMap.containsKey(category)) {
          // Add the amount to the existing category
          categoryAmountMap[category] =
              (categoryAmountMap[category] ?? 0) + amount;
        } else {
          // Initialize the category with the amount
          categoryAmountMap[category] = amount;
        }
      }
    }

    // Creating a list of chart data points from the aggregated map
    final List<ChartData> chartData = categoryAmountMap.entries.map((entry) {
      return ChartData(entry.key, entry.value / totalAmount);
    }).toList();

    //Sorting the ChartData to show according to totala mount of each category
    chartData.sort((a, b) => b.amount.compareTo(a.amount));

    if (chartData.isEmpty) {
      return const Center(
        child: Text(
          'No data available for the selected time period.',
          style: TextStyle(fontSize: 15),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 350,
                  child: SfCircularChart(
                    title: ChartTitle(
                      text: 'Total amount ₹$totalAmount',
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                      alignment: ChartAlignment.center,
                    ),
                    series: <CircularSeries>[
                      DoughnutSeries<ChartData, String>(
                        dataSource: chartData,
                        xValueMapper: (ChartData data, _) => data.category,
                        yValueMapper: (ChartData data, _) => data.amount,
                        dataLabelMapper: (ChartData data, _) =>
                            '${data.category} \n${(data.amount * 100).toStringAsFixed(1)}%',
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          labelPosition: ChartDataLabelPosition.outside,
                          labelIntersectAction: LabelIntersectAction.shift,
                          overflowMode: OverflowMode.trim,
                          connectorLineSettings: ConnectorLineSettings(
                              type: ConnectorType.curve, length: '15%'),
                        ),
                        radius: '65%',
                        innerRadius: '60%',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    height: 30,
                    child: Text(
                      'Category List',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                _buildCategoryList(type, categoryAmountMap, totalAmount),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryList(
      String type, Map<String, double> categoryAmountMap, double totalAmount) {
    // Convert the categoryAmountMap to a list of entries
    final List<MapEntry<String, double>> categoryEntries =
        categoryAmountMap.entries.toList();

    // Sort the entries by amount in descending order
    categoryEntries.sort((a, b) => b.value.compareTo(a.value));

    final categoryList = categoryEntries.map((entry) {
      final transactionsInCategory =
          transactions!.where((t) => t.category == entry.key).toList();
      return GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => CategoryDialog(
              category: entry.key,
              transactions: transactionsInCategory,
              selectedMonth: selectedMonth,
              selectedDateRange: selectedDateRange,
            ),
          );
        },
        child: ListTile(
          title: Text(entry.key),
          trailing: Text(
            '₹${entry.value.toStringAsFixed(2)} (${(entry.value / totalAmount * 100).toStringAsFixed(2)}%)',
            style: TextStyle(
                color: type == CategoryType.income.toString()
                    ? incomeColor
                    : expenseColor,
                fontSize: 15),
          ),
        ),
      );
    }).toList();

    if (categoryList.isEmpty) {
      return const Center(
        child: Text('No categories available for the selected filters.'),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        ...categoryList,
      ],
    );
  }

  bool _filterTransaction(AddData transaction) {
    if (selectedMonth != null) {
      // Filter transactions by selected month
      return transaction.datetime.year == selectedMonth!.year &&
          transaction.datetime.month == selectedMonth!.month;
    }
    if (selectedDateRange != null) {
      // Filter transactions by selected date range
      return transaction.datetime.isAfter(
              selectedDateRange!.start.subtract(const Duration(days: 1))) &&
          transaction.datetime
              .isBefore(selectedDateRange!.end.add(const Duration(days: 1)));
    }
    return true;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class ChartData {
  final String category;
  final double amount;

  ChartData(this.category, this.amount);
}

class CategoryDialog extends StatelessWidget {
  final String category;
  final List<AddData> transactions;
  final DateTime? selectedMonth;
  final DateTimeRange? selectedDateRange;

  const CategoryDialog({
    super.key,
    required this.category,
    required this.transactions,
    required this.selectedMonth,
    required this.selectedDateRange,
  });
  List<AddData> filterTransactions() {
    // Filter transactions based on selectedMonth or selectedDateRange
    return transactions.where((transaction) {
      if (selectedMonth != null) {
        // Filter by selected month
        return transaction.datetime.year == selectedMonth!.year &&
            transaction.datetime.month == selectedMonth!.month;
      } else if (selectedDateRange != null) {
        // Filter by selected date range
        final start = selectedDateRange!.start;
        final end = selectedDateRange!.end;
        return transaction.datetime
                .isAfter(start.subtract(const Duration(days: 1))) &&
            transaction.datetime.isBefore(end.add(const Duration(days: 1)));
      }
      return true; // Default to true if no filters are selected
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredTransactions = filterTransactions();
    final sortedTransactions = [
      ...filteredTransactions
    ]; // Create a copy of the transactions list
    sortedTransactions
        .sort((a, b) => a.datetime.compareTo(b.datetime)); // Sort by date
    final calculatedHeight = transactions.length * 45.0;
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                  child: Text(
                'All trasactions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
              Center(
                child: Text(
                  ' $category',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              const SizedBox(height: 8),
              SizedBox(
                height: calculatedHeight > 400 ? 400 : calculatedHeight,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: sortedTransactions.length,
                  itemBuilder: (context, index) {
                    final transaction = sortedTransactions[index];
                    return ListTile(
                      leading: Text(
                        DateFormat('dd-MMM-yy').format(transaction.datetime),
                        style: const TextStyle(fontSize: 15),
                      ),
                      title: Row(
                        children: [
                          const SizedBox(
                            width: 7,
                          ),
                          Text(' ₹${transaction.amount}'),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(transaction.heading)
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
