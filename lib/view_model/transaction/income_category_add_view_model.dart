import 'package:flutter/material.dart';

class IncomeCategoryAddViewModel extends ChangeNotifier {
  int _selectedCategoryIndex = -1;

  int get selectedCategoryIndex => _selectedCategoryIndex;

  void setSelectedCategoryIndex(int index) {
    _selectedCategoryIndex = index;
    notifyListeners();
  }
}
