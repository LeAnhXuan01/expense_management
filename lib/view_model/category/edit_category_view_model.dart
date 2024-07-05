import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../model/category_model.dart';
import '../../model/enum.dart';
import '../../services/category_service.dart';
import '../../utils/icon_list.dart';
import '../../utils/color_list.dart';
import '../../utils/utils.dart';

class EditCategoryViewModel extends ChangeNotifier {
  final CategoryService _categoryService = CategoryService();
  final TextEditingController nameCategory = TextEditingController();

  IconData? selectedIcon;
  Color? selectedColor;
  bool showPlusButtonIcon = true;
  bool showPlusButtonColor = true;
  bool enableButton = false;

  bool get isEmptyName => nameCategory.text.isEmpty;
  bool get isEmptyIcon => selectedIcon == null;
  bool get isEmptyColor => selectedColor == null;

  List<IconData> currentIconsList = incomeIcons;
  List<Color> get colors => colors_list;

  EditCategoryViewModel() {
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

  void setSelectedIcon(IconData icon) {
    selectedIcon = icon;
    updateButtonState();
  }

  void setSelectedColor(Color color) {
    selectedColor = color;
    updateButtonState();
  }

  void toggleShowPlusButtonIcon() {
    showPlusButtonIcon = !showPlusButtonIcon;
    notifyListeners();
  }

  void toggleShowPlusButtonColor() {
    showPlusButtonColor = !showPlusButtonColor;
    notifyListeners();
  }

  Future<Category?> updateCategory(String categoryId, DateTime createdAt) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final updatedCategory = Category(
          categoryId: categoryId,
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
