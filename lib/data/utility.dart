import 'package:hive/hive.dart';
import 'package:vy_money/data/model/category/category_model.dart';
import 'package:vy_money/data/model/transaction/add_date.dart';

int totals = 0;
final box = Hive.box<AddData>('data');

// int total() {
//   var history2 = box.values.toList();
//   List a = [0, 0];
//   for (var i = 0; i < history2.length; i++) {
//     a.add(history2[i].type == CategoryType.income.toString() 
//         ? int.parse(history2[i].amount)
//         : int.parse(history2[i].amount) * -1);
//   }
//   totals = a.reduce((value, element) => value + element);
//   return totals;
// }

// int income() {
//   var history2 = box.values.toList();
//   List a = [0, 0];
//   for (var i = 0; i < history2.length; i++) {
//     a.add(history2[i].type == CategoryType.income.toString()  ? int.parse(history2[i].amount) : 0);
//   }
//   totals = a.reduce((value, element) => value + element);
//   return totals;
// }

// int expense() {
//   var history2 = box.values.toList();
//   List a = [0, 0];
//   for (var i = 0; i < history2.length; i++) {
//     a.add(history2[i].type == CategoryType.income.toString()  ? 0 : int.parse(history2[i].amount));
//   }
//   totals = a.reduce((value, element) => value + element);
//   return totals;
// }




int total() {
  var history2 = box.values.toList();
  List a = [0, 0];
  final currentDate = DateTime.now();
  for (var i = 0; i < history2.length; i++) {
    final transactionDate = history2[i].datetime;
    if (transactionDate.year == currentDate.year &&
        transactionDate.month == currentDate.month) {
      a.add(history2[i].type == CategoryType.income.toString()
          ? int.parse(history2[i].amount)
          : int.parse(history2[i].amount) * -1);
    }
  }
  totals = a.reduce((value, element) => value + element);
  return totals;
}

int income() {
  var history2 = box.values.toList();
  List a = [0, 0];
  final currentDate = DateTime.now();
  for (var i = 0; i < history2.length; i++) {
    final transactionDate = history2[i].datetime;
    if (transactionDate.year == currentDate.year &&
        transactionDate.month == currentDate.month) {
      a.add(history2[i].type == CategoryType.income.toString()
          ? int.parse(history2[i].amount)
          : 0);
    }
  }
  totals = a.reduce((value, element) => value + element);
  return totals;
}

int expense() {
  var history2 = box.values.toList();
  List a = [0, 0];
  final currentDate = DateTime.now();
  for (var i = 0; i < history2.length; i++) {
    final transactionDate = history2[i].datetime;
    if (transactionDate.year == currentDate.year &&
        transactionDate.month == currentDate.month) {
      a.add(history2[i].type == CategoryType.income.toString()
          ? 0
          : int.parse(history2[i].amount));
    }
  }
  totals = a.reduce((value, element) => value + element);
  return totals;
}
