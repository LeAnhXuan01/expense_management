import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../model/category_model.dart';
import '../../services/category_service.dart';

class CategoryListViewModel extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  final CategoryService _categoryService = CategoryService();
  List<Category> _incomeCategories = [];
  List<Category> _expenseCategories = [];
  List<Category> _filteredIncomeCategories = [];
  List<Category> _filteredExpenseCategories = [];
  bool isSearching = false;
  String searchQuery = "";

  List<Category> get incomeCategories => _filteredIncomeCategories;
  List<Category> get expenseCategories => _filteredExpenseCategories;

  CategoryListViewModel() {
    loadCategories();
  }

  Future<void> loadCategories() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await _categoryService.addDefaultCategories(user.uid);
        await _categoryService.addFixedCategories(user.uid);
        _incomeCategories = await _categoryService.getIncomeCategories(user.uid);
        _expenseCategories = await _categoryService.getExpenseCategories(user.uid);

        _filteredIncomeCategories = _incomeCategories;
        _filteredExpenseCategories = _expenseCategories;

        notifyListeners();
      } catch (e) {
        print("Error loading categories: $e");
      }
    }
  }

  void filterCategories(String query) {
    if (query.isEmpty) {
      _filteredIncomeCategories = _incomeCategories;
      _filteredExpenseCategories = _expenseCategories;
    } else {
      _filteredIncomeCategories = _incomeCategories.where((category) {
        return category.name.toLowerCase().contains(query.toLowerCase());
      }).toList();

      _filteredExpenseCategories = _expenseCategories.where((category) {
        return category.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  Future<void> deleteCategory(String categoryId) async {
    try {
      await _categoryService.deleteCategory(categoryId);
      await loadCategories();  // Refresh the categories after deleting
    } catch (e) {
      print("Error deleting category: $e");
    }
  }
}

