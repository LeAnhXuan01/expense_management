import 'package:flutter/material.dart';
import '../../model/category_model.dart';

class IncomeCategoryAddViewModel extends ChangeNotifier {
  late List<Category> categories;
  int _selectedCategoryIndex = -1;

  int get selectedCategoryIndex => _selectedCategoryIndex;

  Category? _newlyAddedCategory;
  Category? get  newlyAddedCategory => _newlyAddedCategory;


  void init(List<Category> incomeCategories) {
    categories = List.from(incomeCategories);
  }

  void selectCategory(int index) {
    _selectedCategoryIndex = index;
    notifyListeners();
  }

  void addCategory(Category newCategory) {
    categories.add(newCategory);
    _newlyAddedCategory = newCategory;
    notifyListeners();
  }
}
