// // ViewModel
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/category_item.dart';

class CreatCategoriesViewModel extends ChangeNotifier {
  int _selectedValue = 0; // 0: Thu, 1: Chi
  bool _showPlusButton = true;
  IconData? _selectedIcon;
  int _selectedColorIndex = -1;
  Color? _selectedColor;
  CategoryItem? _category;
  final TextEditingController _nameCategory = TextEditingController();

  int get selectedValue => _selectedValue;
  bool get showPlusButton => _showPlusButton;
  IconData? get selectedIcon => _selectedIcon;
  int get selectedColorIndex => _selectedColorIndex;
  Color? get selectedColor => _selectedColor;
  CategoryItem? get category => _category;
  TextEditingController get nameCategory => _nameCategory;

  bool get isEmptyName => _nameCategory.text.isEmpty;
  bool get isEmptyIcon => _selectedIcon == null;
  bool get isEmptyColor => _selectedColor == null;

  bool showErrorName = false;
  bool showErrorIcon = false;
  bool showErrorColor = false;

  final List<IconData> _incomeIcons = [
    Icons.money,
    Icons.wallet_giftcard,
    Icons.attach_money,
    Icons.account_balance,
    Icons.card_giftcard,
  ];

  final List<IconData> _expenseIcons = [
    Icons.shopping_cart,
    Icons.home,
    Icons.directions_car,
    Icons.fastfood,
    Icons.local_hospital,
  ];

  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.brown,
    Colors.deepPurpleAccent,
    Colors.cyanAccent,
    Colors.black,
  ];

  List<IconData> get currentIconsList =>
      _selectedValue == 0 ? _incomeIcons : _expenseIcons;

  void setSelectedValue(int value) {
    _selectedValue = value;
    notifyListeners();
  }

  void toggleShowPlusButton() {
    _showPlusButton = !_showPlusButton;
    notifyListeners();
  }

  void setSelectedIcon(IconData? icon) {
    _selectedIcon = icon;
    notifyListeners();
  }

  void setSelectedColorIndex(int index) {
    _selectedColorIndex = index;
    notifyListeners();
  }

  void setSelectedColor(Color? color) {
    _selectedColor = color;
    notifyListeners();
  }

  void setNameCategory(String name) {
    _nameCategory.text = name;
    notifyListeners();
  }

  void clearTextController() {
    _nameCategory.clear();
    notifyListeners();
  }

  void setShowErrorName(bool value) {
    showErrorName = value;
    notifyListeners();
  }

  void setShowErrorIcon(bool value) {
    showErrorIcon = value;
    notifyListeners();
  }

  void setShowErrorColor(bool value) {
    showErrorColor = value;
    notifyListeners();
  }

  void setCategory(CategoryItem category) {
    _category = category;
    notifyListeners();
  }

  void updateCategory(CategoryItem category) {
    _category = category;
    notifyListeners();
  }

  void resetErrors() {
    showErrorName = false;
    showErrorIcon = false;
    showErrorColor = false;
    notifyListeners();
  }

  void clearSelectedValues() {
    _selectedIcon = null;
    _selectedColor = null;
    _selectedColorIndex = -1;
    notifyListeners();
  }

  List<CategoryItem> _incomeCategories = [];
  List<CategoryItem> _expenseCategories = [];

  List<CategoryItem> get incomeCategories => _incomeCategories;
  List<CategoryItem> get expenseCategories => _expenseCategories;

  void addIncomeCategory(CategoryItem category) {
    _incomeCategories.add(category);
    notifyListeners();
  }

  void addExpenseCategory(CategoryItem category) {
    _expenseCategories.add(category);
    notifyListeners();
  }
}




