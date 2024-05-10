import 'package:flutter/material.dart';
import '../../data/category_item.dart';

class IncomeCategoryAddViewModel extends ChangeNotifier {
  late List<CategoryItem> categories;
  int _selectedCategoryIndex = -1;

  int get selectedCategoryIndex => _selectedCategoryIndex;

  CategoryItem? _newlyAddedCategory;
  CategoryItem? get  newlyAddedCategory => _newlyAddedCategory;


  void init(List<CategoryItem> incomeCategories) {
    categories = List.from(incomeCategories);
  }

  void selectCategory(int index) {
    _selectedCategoryIndex = index;
    notifyListeners();
  }

  void addCategory(CategoryItem newCategory) {
    categories.add(newCategory);
    _newlyAddedCategory = newCategory;
    notifyListeners();
  }
}
