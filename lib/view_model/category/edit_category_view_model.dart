import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../model/category_model.dart';
import '../../model/enum.dart';
import '../../services/category_service.dart';
import '../../utils/icon_list.dart';
import '../../utils/color_list.dart';
import '../../utils/utils.dart';

class EditCategoriesViewModel extends ChangeNotifier {
  bool showPlusButtonIcon = true;
  bool showPlusButtonColor = true;
  IconData? selectedIcon;
  Color? selectedColor;

  final TextEditingController nameCategory = TextEditingController();
  final CategoryService _categoryService = CategoryService();
  bool enableButton = false;

  bool get isEmptyName => nameCategory.text.isEmpty;
  bool get isEmptyIcon => selectedIcon == null;
  bool get isEmptyColor => selectedColor == null;

  List<IconData> currentIconsList = incomeIcons;
  List<Color> get colors => colors_list;

  EditCategoriesViewModel() {
    nameCategory.addListener(updateButtonState);
  }

  void initializeFields(Category category) {
    nameCategory.text = category.name;
    selectedIcon =  parseIcon(category.icon);
    selectedColor = parseColor(category.color);
    currentIconsList = category.type == TransactionType.income ? incomeIcons : expenseIcons;
    showPlusButtonIcon = true;
    showPlusButtonColor = true;
    updateButtonState();
  }

  void updateButtonState() {
    enableButton = !isEmptyName && !isEmptyIcon && !isEmptyColor;
    notifyListeners();
  }

  void toggleShowPlusButtonIcon() {
    showPlusButtonIcon = !showPlusButtonIcon;
    notifyListeners();
  }

  void toggleShowPlusButtonColor() {
    showPlusButtonColor = !showPlusButtonColor;
    notifyListeners();
  }

  void setSelectedIcon(IconData icon) {
    selectedIcon = icon;
    updateButtonState();
  }

  void setSelectedColor(Color color) {
    selectedColor = color;
    updateButtonState();
  }

  Future<Category?> updateCategory(String categoryId, DateTime createdAt) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final updatedCategory = Category(
          categoryId: categoryId, // Sử dụng categoryId được truyền vào
          userId: user.uid,
          name: nameCategory.text,
          type: currentIconsList == incomeIcons ? TransactionType.income : TransactionType.expense,
          icon: selectedIcon.toString(),
          color: selectedColor.toString(),
          createdAt: createdAt,
      );

      try {
        await _categoryService.updateCategory(updatedCategory);
        return updatedCategory;
      } catch (e) {
        print('Error updating category: $e');
        return null;
      }
    }
    return null;
  }

}
