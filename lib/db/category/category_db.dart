// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:vy_money/data/model/category/category_model.dart';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
const CATEGORY_DB_NAME = 'category-database';

abstract class CategoryDbFunctions {
  Future<List<CategoryModel>> getCategories();
  Future<void> insertCategory(CategoryModel value);
  Future<void> deleteCategory(String categoryID);
}

class CategoryDb implements CategoryDbFunctions {
  CategoryDb.internal(){
    // _initializeDefaultCategories();
  }

  static CategoryDb instance = CategoryDb.internal();

  factory CategoryDb() {
    return CategoryDb.instance;
  }

  ValueNotifier<List<CategoryModel>> incomeCategoryListListner =
      ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseCategoryListListner =
      ValueNotifier([]);

 

  @override
  Future<void> insertCategory(CategoryModel value) async {
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    if (!categoryDB.containsKey(value.id)) {
    await categoryDB.put(value.id, value);
    refreshUI();
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    return categoryDB.values.toList();
  }

  Future<void> refreshUI() async {
    final _allCategories = await getCategories();
    incomeCategoryListListner.value.clear();
    expenseCategoryListListner.value.clear();

    await Future.forEach(
      _allCategories,
      (CategoryModel category) {
        if (category.type == CategoryType.income) {
          
          incomeCategoryListListner.value.add(category);
        } else {
          expenseCategoryListListner.value.add(category);
        }
      },
    );

    incomeCategoryListListner.notifyListeners();
    expenseCategoryListListner.notifyListeners();
  }

  @override
  Future<void> deleteCategory(String categoryID) async {
    final _categoryDb = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await _categoryDb.delete(categoryID);
    refreshUI();
  }
}
