import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../model/category_model.dart';
import '../../model/enum.dart';
import '../../services/category_service.dart';
import '../../utils/icon_list.dart';
import '../../utils/color_list.dart';

class CreatCategoriesViewModel extends ChangeNotifier {
  int selectedValue = 0; // 0: Thu, 1: Chi
  bool showPlusButtonIcon = true;
  bool showPlusButtonColor = true;
  IconData? selectedIcon;
  Color? selectedColor; // Biến để lưu màu được chọn

  final TextEditingController nameCategory = TextEditingController();
  final CategoryService _categoryService = CategoryService();
  bool enableButton = false;

  bool get isEmptyName => nameCategory.text.isEmpty;
  bool get isEmptyIcon => selectedIcon == null;
  bool get isEmptyColor => selectedColor == null;

  List<IconData> get currentIconsList => selectedValue == 0 ? incomeIcons : expenseIcons;
  List<Color> get colors => colors_list;

  CreatCategoriesViewModel() {
    nameCategory.addListener(updateButtonState);
  }

  void updateButtonState() {
    enableButton = !isEmptyName && !isEmptyIcon && !isEmptyColor;
    notifyListeners();
  }

  void resetSelectedIcon() {
    selectedIcon = null;
    notifyListeners();
  }

  void setSelectedValue(int value) {
    selectedValue = value;
    resetSelectedIcon(); // Đặt lại biểu tượng khi thay đổi loại danh mục
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

  void resetFields() {
    nameCategory.clear();
    selectedIcon = null;
    selectedColor = null;
    enableButton = false;
    showPlusButtonIcon = true;
    showPlusButtonColor = true;
    notifyListeners();
  }

  Future<Category?> createCategory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final newCategory = Category(
        categoryId: "",
        userId: user.uid,
        name: nameCategory.text,
        type: selectedValue == 0 ? TransactionType.income : TransactionType.expense,
        icon: selectedIcon.toString(),
        color: selectedColor.toString(),
        createdAt: DateTime.now()
      );

      try {
        await _categoryService.createCategory(newCategory);
        return newCategory; // Trả về danh mục vừa tạo
      } catch (e) {

        print('Error creating category: $e');
        return null;
      }
    }
    return null;
  }
}