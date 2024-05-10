import 'package:flutter/material.dart';

class CatalogColorViewModel extends ChangeNotifier {
  Color? selectedShadeColor;

  void setSelectedShadeColor(Color? color) {
    selectedShadeColor = color;
    notifyListeners();
  }
}
