import 'package:flutter/material.dart';

class IconCategoryViewModel extends ChangeNotifier {
  IconData? selectedIcon;

  void setSelectedIcon(IconData? icon) {
    selectedIcon = icon;
    notifyListeners();
  }
}
