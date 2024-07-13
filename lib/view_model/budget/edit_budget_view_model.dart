import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_management/model/budget_model.dart';
import 'package:expense_management/model/category_model.dart';
import 'package:expense_management/model/wallet_model.dart';
import 'package:expense_management/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../model/enum.dart';
import '../../services/budget_service.dart';
import '../../widget/custom_snackbar_1.dart';

class EditBudgetViewModel extends ChangeNotifier {
  final BudgetService _budgetService = BudgetService();
  final TextEditingController amountController;
  final TextEditingController nameController;
  final TextEditingController startDateController;
  final TextEditingController endDateController;
  List<Category> categories = [];
  List<Category> selectedCategories = [];
  List<Wallet> wallets = [];
  List<Wallet> selectedWallets = [];
  Repeat selectedRepeat = Repeat.Monthly;
  DateTime startDate = DateTime.now();
  DateTime? endDate;
  bool enableButton = false;
  Budget budget;

  EditBudgetViewModel(this.budget)
      : amountController =
            TextEditingController(text: formatTotalBalance(budget.amount)),
        nameController = TextEditingController(text: budget.name),
        startDateController =
            TextEditingController(text: formatDate(budget.startDate)),
        endDateController =
            TextEditingController(text: formatDate(budget.endDate)) {
    amountController.addListener(() {
      formatAmount_3(amountController);
    });
    initializeData();
    selectedRepeat = budget.repeat;
    startDate = budget.startDate;
    endDate = budget.endDate;
    updateButtonState();
  }

  Map<String, Category> categoryMap = {};
  Map<String, Wallet> walletMap = {};

  Category? getCategoryById(String categoryId) {
    return categoryMap[categoryId];
  }

  Wallet? getWalletById(String walletId) {
    return walletMap[walletId];
  }

  List<Repeat> get repeatOptions => Repeat.values;

  String getRepeatBudgetString(Repeat repeatBudget) {
    switch (repeatBudget) {
      case Repeat.Daily:
        return 'Hàng ngày';
      case Repeat.Weekly:
        return 'Hàng tuần';
      case Repeat.Monthly:
        return 'Hàng tháng';
      case Repeat.Quarterly:
        return 'Hàng quý';
      case Repeat.Yearly:
        return 'Hàng năm';
      default:
        return '';
    }
  }

  String getCategoriesText(
      List<Category> selectedCategories, List<Category> allCategories) {
    if (selectedCategories.length == 0 ||
        selectedCategories.length == allCategories.length)
      return 'Tất cả danh mục chi tiêu';
    if (selectedCategories.length == 1) return selectedCategories[0].name;
    if (selectedCategories.length == 2)
      return '${selectedCategories[0].name}, ${selectedCategories[1].name}';
    return '${selectedCategories[0].name}, ${selectedCategories[1].name} + ${selectedCategories.length - 2} danh mục';
  }

  String getWalletsText(List<Wallet> selectedWallets, List<Wallet> allWallets) {
    if (selectedWallets.length == 0 ||
        selectedWallets.length == allWallets.length) return 'Tất cả ví tiền';
    if (selectedWallets.length == 1) return selectedWallets[0].name;
    if (selectedWallets.length == 2)
      return '${selectedWallets[0].name}, ${selectedWallets[1].name}';
    return '${selectedWallets[0].name}, ${selectedWallets[1].name} + ${selectedWallets.length - 2} ví tiền';
  }

  Future<void> initializeData() async {
    await Future.wait([
      loadCategories(),
      loadWallets(),
    ]);

    selectedCategories = budget.categoryId
        .map((id) => getCategoryById(id))
        .whereType<Category>()
        .toList();
    selectedWallets = budget.walletId
        .map((id) => getWalletById(id))
        .whereType<Wallet>()
        .toList();
    notifyListeners();
  }

  Future<void> loadCategories() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        QuerySnapshot categorySnapshot = await FirebaseFirestore.instance
            .collection('categories')
            .where('userId', isEqualTo: currentUser.uid)
            .where('type', isEqualTo: Type.expense.index)
            .get();
        categories = categorySnapshot.docs
            .map((doc) => Category.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
        categoryMap = {
          for (var category in categories) category.categoryId: category
        };
        notifyListeners();
      }
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  Future<void> loadWallets() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        QuerySnapshot walletSnapshot = await FirebaseFirestore.instance
            .collection('wallets')
            .where('userId', isEqualTo: currentUser.uid)
            .get();
        wallets = walletSnapshot.docs
            .map((doc) => Wallet.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
        walletMap = {for (var wallet in wallets) wallet.walletId: wallet};
        notifyListeners();
      }
    } catch (e) {
      print('Error loading wallets: $e');
    }
  }

  void updateButtonState() {
    enableButton = amountController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        endDate != null;
    notifyListeners();
  }

  void setWallets(List<Wallet> wallets) {
    selectedWallets = wallets;
    notifyListeners();
  }

  void setCategories(List<Category> categories) {
    selectedCategories = categories;
    notifyListeners();
  }

  void setSelectedRepeat(Repeat value) {
    selectedRepeat = value;
    notifyListeners();
  }

  void setStartDate(DateTime value) {
    startDate = value;
    updateDateControllers();
    notifyListeners();
  }

  void setEndDate(DateTime value) {
    endDate = value;
    updateDateControllers();
    updateButtonState();

    notifyListeners();
  }

  void updateDateControllers() {
    startDateController.text = formatDate(startDate);
    endDateController.text = endDate != null ? formatDate(endDate!) : '';
  }

  Future<Budget?> updateBudget(BuildContext context) async {
    try {
      final cleanedAmount = amountController.text.replaceAll('.', '');
      final amount = double.parse(cleanedAmount);

      // Tạo danh sách categoryId từ selectedCategories
      List<String> categoryIdList =
          selectedCategories.map((category) => category.categoryId).toList();

      // Tạo danh sách walletId từ selectedWallets
      List<String> walletIdList =
          selectedWallets.map((wallet) => wallet.walletId).toList();

      // Kiểm tra tính hợp lệ của ngày kết thúc
      bool isValid = true;
      String message = '';

      if(selectedRepeat == Repeat.Daily){
        if (endDate!.isBefore(startDate)) {
          isValid = false;
          message = 'Ngày kết thúc phải lớn hơn ngày ${formatDate(startDate)}';
        }
      }
      else if (selectedRepeat == Repeat.Weekly) {
        if (endDate!.isBefore(startDate.add(Duration(days: 6)))) {
          isValid = false;
          message =
              'Ngày kết thúc phải lớn hơn ngày ${formatDate(startDate.add(Duration(days: 6)))}';
        }
      } else if (selectedRepeat == Repeat.Monthly) {
        if (endDate!.isBefore(startDate.add(Duration(days: 29)))) {
          isValid = false;
          message =
              'Ngày kết thúc phải lớn hơn ngày ${formatDate(startDate.add(Duration(days: 29)))}';
        }
      } else if (selectedRepeat == Repeat.Quarterly) {
        if (endDate!.isBefore(startDate.add(Duration(days: 89)))) {
          isValid = false;
          message =
              'Ngày kết thúc phải lớn hơn ngày ${formatDate(startDate.add(Duration(days: 89)))}';
        }
      } else if (selectedRepeat == Repeat.Yearly) {
        if (endDate!.isBefore(startDate.add(Duration(days: 364)))) {
          isValid = false;
          message =
              'Ngày kết thúc phải lớn hơn ngày ${formatDate(startDate.add(Duration(days: 364)))}';
        }
      }

      if (!isValid) {
        CustomSnackBar_1.show(context, message);
        return null;
      }

      Budget updatedBudget = Budget(
        budgetId: budget.budgetId,
        userId: budget.userId,
        amount: amount,
        name: nameController.text,
        categoryId: categoryIdList,
        walletId: walletIdList,
        startDate: startDate,
        endDate: endDate!,
        repeat: selectedRepeat,
        createdAt: budget.createdAt,
      );

      await _budgetService.updateBudget(updatedBudget);
      return updatedBudget;
    } catch (e) {
      print('Error updating budget: $e');
      return null;
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    nameController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }
}
