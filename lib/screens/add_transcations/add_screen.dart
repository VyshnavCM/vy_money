// ignore_for_file: prefer_const_constructors, unrelated_type_equality_checks, unused_field, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:vy_money/colors/colors.dart';
import 'package:vy_money/data/model/category/category_model.dart';
import 'package:vy_money/data/model/transaction/add_date.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vy_money/db/category/category_db.dart';

final defaultCategories = [
  CategoryModel(
      id: '1', name: 'Salary', type: CategoryType.income, isDeleted: false),
  CategoryModel(
      id: '2', name: 'Allowence', type: CategoryType.income, isDeleted: false),
];

final defaultExpenseCategory = [
  CategoryModel(
      id: '4', name: 'Food', type: CategoryType.expense, isDeleted: false),
  CategoryModel(
      id: '3',
      name: 'Entertainment',
      type: CategoryType.expense,
      isDeleted: false),
];
 // Initialize with a default value

class AddScreen extends StatefulWidget {
  final AddData? editData;
  const AddScreen({Key? key, this.editData}) : super(key: key);

  @override
  State<AddScreen> createState() => AddScreenState();
}

// A callback function type to update the selected category type and ID
// typedef CategoryCallback = void Function(CategoryType categoryType, String categoryId);

class AddScreenState extends State<AddScreen> {
  late final AddData? editData;

  CategoryType? _selectedCategoryType;
  CategoryModel? _selectedCategoryModel;

  String? _categoryID;

  final box = Hive.box<AddData>('data');
  final _formKey = GlobalKey<FormState>();

  DateTime date = DateTime.now();
  String? selectedItem;

  String? selectedItemType = 'Expense';
  String? selectedMode = 'Account';
  bool validate = false;

  final TextEditingController headingC = TextEditingController();
  FocusNode hd = FocusNode();

  final TextEditingController amountC = TextEditingController();
  FocusNode am = FocusNode();

  final List<String> mode = ['Account', 'Cash'];

   @override
  void initState() {
    super.initState();

    hd.addListener(() {
      setState(() {});
    });
    am.addListener(() {
      setState(() {});
    });

    // Initialize the editData if it's provided
    editData = widget.editData;

    // Initialize the form fields based on editData or defaults
    if (editData != null) {
      _selectedCategoryType = editData!.type == CategoryType.income.toString()
          ? CategoryType.income
          : CategoryType.expense;
      _selectedCategoryModel = CategoryModel(
        id:'',
        name: editData!.category,
        type: _selectedCategoryType!,
      );
      // _categoryID = editData!.category;
      
      selectedMode = editData!.mode;
      headingC.text = editData!.heading;
      amountC.text = editData!.amount;
      date = editData!.datetime;
    } else {
      _selectedCategoryType = CategoryType.expense; // Default to expense type
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: mainBackgroundColor,
        body: SafeArea(
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              backgroundContainer(context),
              Positioned(
                top: 120,
                child: mainContainer(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container mainContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      height: 600,
      width: 340,
      child: Column(
        children: [
          SizedBox(height: 20),
          typeRadioButton(),
          SizedBox(height: 20),
          category(),
          SizedBox(height: 30),
          trasactionMode(),
          SizedBox(height: 30),
          heading(),
          SizedBox(height: 18),
          amountField(),
          SizedBox(height: 30),
          dateTime(),
          Spacer(),
          saveButton(),
          SizedBox(height: 25)
        ],
      ),
    );
  }

  Padding trasactionMode() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 2,
            color: Colors.grey,
          ),
        ),
        child: DropdownButton<String>(
          value: selectedMode,
          onChanged: ((value) {
            setState(() {
              selectedMode = value!;
            });
          }),
          items: mode
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e, style: TextStyle(fontSize: 18)),
                  ))
              .toList(),
          selectedItemBuilder: (BuildContext context) => mode
              .map((e) => Row(
                    children: [Text(e, style: TextStyle(fontSize: 18))],
                  ))
              .toList(),
          dropdownColor: Colors.white,
          isExpanded: true,
          underline: Container(),
        ),
      ),
    );
  }

  GestureDetector saveButton() {
    return GestureDetector(
      onTap: () {
        final _amount = amountC.text.trim();
        if (_amount.isEmpty) {
          return;
        } else {
          if (editData != null) {
            // Update the existing transaction
            editData!.type = _selectedCategoryType.toString();
            editData!.category = _selectedCategoryModel!.name;
            editData!.mode = selectedMode!;
            editData!.heading = headingC.text;
            editData!.amount = amountC.text;
            editData!.datetime = date;
            editData!.save(); // Save the changes
          } else {
            // Add a new transaction
            var add = AddData(
              _selectedCategoryType.toString(),
              _selectedCategoryModel!.name,
              selectedMode!,
              headingC.text,
              amountC.text,
              date,
            );
            box.add(add);
          }
          Navigator.of(context).pop();
        }
      },
      child: Container(
        width: 120,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: primaryColor,
        ),
        child: Text(
          widget.editData!=null?'Update':'Save',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 17,
          ),
        ),
      ),
    );
  }

  Padding dateTime() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 19),
      child: Container(
        alignment: Alignment.bottomLeft,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2, color: Colors.grey)),
        child: TextButton(
          onPressed: () async {
            DateTime? newDate = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime.now().subtract(const Duration(days: 60)),
              lastDate: DateTime.now(),
            );
            if (newDate == Null){

             return ;
            }
            
            setState(() {
            
              date = newDate!;
            });
          },
          child: Text(
            'Date : ${date.day} / ${date.month} / ${date.year}',
            style: TextStyle(fontSize: 15, color: primaryColor),
          ),
        ),
      ),
    );
  }

  Widget amountField() {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 19),
        child: TextFormField(
          key: _formKey,
          focusNode: am,
          controller: amountC,
          validator: (value) => value!.isEmpty ? 'Enter an amount' : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            labelText: 'Amount',
            labelStyle: TextStyle(fontSize: 17, color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(width: 2, color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(width: 2, color: Colors.grey),
            ),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ], 
        ),
      ),
    );
  }

  Padding amount() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 19),
      child: TextField(
        focusNode: am,
        controller: amountC,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          labelText: 'Amount',
          errorText: validate ? "Enter amount" : null,
          labelStyle: TextStyle(fontSize: 17, color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 2, color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 2, color: Colors.grey),
          ),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Padding heading() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 19),
      child: TextField(
        maxLength: 12,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        focusNode: hd,
        controller: headingC,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          labelText: 'Heading',
          labelStyle: TextStyle(fontSize: 17, color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 2, color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 2, color: Colors.grey),
          ),
        ),
      ),
    );
  }
  
  


  Padding category() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 19),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 2,
                color: Colors.grey,
              ),
            ),
            child: DropdownButton<String>(
              alignment: AlignmentDirectional.centerStart,
              value: _categoryID,
              items: ([
                if (_selectedCategoryType == CategoryType.income)
                  ...defaultCategories
                else
                  ...defaultExpenseCategory, // Show default items only for income type
                ...(_selectedCategoryType == CategoryType.income
                        ? CategoryDb().incomeCategoryListListner
                        : CategoryDb().expenseCategoryListListner)
                    .value
              ])
              .toSet()
              .map((e) {
                return DropdownMenuItem(
                  value: e.id,
                  child: Text(e.name),
                  onTap: () {
                   setState(() {
                        _selectedCategoryModel = e;
                      });
                  },
                );
              }).toList(),
              onChanged: (selectedValue) {
                setState(() {
                  _categoryID = selectedValue;
                });
              },
              hint: Text(
                'Category',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              dropdownColor: Colors.white,
              isExpanded: true,
              underline: Container(),
            ),
          ),
        ],
      ),
    );
  }

  Column backgroundContainer(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 220,
          decoration: BoxDecoration(
            color: backgroundCardCOlor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    SizedBox(
                      width: 95,
                    ),
                    Text(
                      'Add Transaction',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget typeRadioButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            Radio(
              value: CategoryType.expense,
              groupValue: _selectedCategoryType,
              onChanged: (newValue) {
                setState(() {
                  _selectedCategoryType = CategoryType.expense;
                  _categoryID = null;
                });
              },
            ),
            const Text(
              'Expense',
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
        Row(
          children: [
            Radio(
              value: CategoryType.income,
              groupValue: _selectedCategoryType,
              onChanged: (newValue) {
                setState(() {
                  _selectedCategoryType = CategoryType.income;
                  _categoryID = null;
                });
              },
            ),
            const Text(
              'Income',
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
        SizedBox(
          width: 15,
        )
      ],
    );
  }
}
