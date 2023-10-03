import 'package:flutter/material.dart';
import 'package:vy_money/data/model/category/category_model.dart';
import 'package:vy_money/db/category/category_db.dart';
import 'package:vy_money/screens/add_transcations/add_screen.dart';

class ExpenseCategoryList extends StatefulWidget {
  const ExpenseCategoryList({super.key});

  @override
  State<ExpenseCategoryList> createState() => _ExpenseCategoryListState();
}

class _ExpenseCategoryListState extends State<ExpenseCategoryList> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CategoryDb().expenseCategoryListListner,
      builder: (BuildContext ctx, List<CategoryModel> newList, Widget? _) {
        final filteredList =
            newList.where((category) => !category.isDeleted).toList();

        // Filter out deleted items and user-added items
        final userAddedCategories = newList
            .where((category) =>
                !category.isDeleted &&
                !defaultExpenseCategory.contains(category))
            .toList();

        // Concatenate default items and user-added items
        final mergedList = [...defaultExpenseCategory, ...userAddedCategories];

        // Add default categories to the filtered list if they are not present
        for (final defaultCategory in defaultExpenseCategory) {
          if (!filteredList
              .any((category) => category.id == defaultCategory.id)) {
            filteredList.add(defaultCategory);
          }
        }
        return ListView.builder(
          itemBuilder: (context, index) {
            final category = mergedList[index];
            final isDefaultCategory = defaultExpenseCategory.contains(category);
            return Padding(
              padding: const EdgeInsets.only(left: 15),
              child: ListTile(
                title: Text(category.name),
                trailing: isDefaultCategory
                    ? null // Remove the delete icon for default items
                    : IconButton(
                        onPressed: () {
                          // Actually delete user-added items
                          CategoryDb.instance.deleteCategory(category.id);
                        },
                        icon: const Icon(Icons.delete),
                      ),
              ),
            );
          },
          itemCount: mergedList.length,
        );
      },
    );
  }
}
