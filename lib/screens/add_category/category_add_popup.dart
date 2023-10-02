// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, no_leading_underscores_for_local_identifiers, unused_import

import 'package:flutter/material.dart';
import 'package:vy_money/colors/colors.dart';
import 'package:vy_money/data/model/category/category_model.dart';
import 'package:vy_money/db/category/category_db.dart';
import 'package:vy_money/screens/add_transcations/add_screen.dart';

ValueNotifier<CategoryType> selectedCategoryNotifier =
    ValueNotifier(CategoryType.income);

Future<void> showCategoryAddPopup(BuildContext context) async {
  final _nameEditingController = TextEditingController();
  
  
  showDialog(
    context: context,
    builder: (ctx) {
      return SimpleDialog(
        title:const Center(child:Text('Add Category')),
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              maxLength: 16,
              controller: _nameEditingController,
              decoration: const InputDecoration(
                hintText: 'Category name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RadioButton(title: 'Income', type: CategoryType.income),
                SizedBox(
                  width: 10,
                ),
                RadioButton(title: 'Expense', type: CategoryType.expense)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
              ),
              onPressed: () {
                final _name = _nameEditingController.text.trim();
                if (_name.isEmpty) {
                  return;
                }
                final _type = selectedCategoryNotifier.value;
                final _category = CategoryModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: _name,
                  type: _type,
                );

                CategoryDb.instance.insertCategory(_category);
                
                Navigator.of(ctx).pop();
              },
              child:const Text('Add',style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      );
    },
  );
}

class RadioButton extends StatelessWidget {
  final String title;
  final CategoryType type;
  const RadioButton({
    required this.title,
    required this.type,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
            valueListenable: selectedCategoryNotifier,
            builder: (BuildContext ctx, CategoryType newCategory, Widget? _) {
              return Radio<CategoryType>(
                value: type,
                groupValue: newCategory,
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  selectedCategoryNotifier.value = value;
                  selectedCategoryNotifier.notifyListeners();
                },
              );
            }),
        Text(title)
      ],
    );
  }
}
