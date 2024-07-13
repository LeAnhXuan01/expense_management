import 'package:expense_management/model/enum.dart';
import 'package:expense_management/widget/custom_ElevatedButton_2.dart';
import 'package:expense_management/widget/custom_header_1.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../model/budget_model.dart';
import '../../model/category_model.dart';
import '../../model/wallet_model.dart';
import '../../utils/utils.dart';
import '../../view_model/budget/edit_budget_view_model.dart';
import '../../widget/custom_snackbar_1.dart';
import '../../widget/custom_snackbar_2.dart';
import '../../widget/multi_category_selection_dialog.dart';
import '../../widget/multi_wallet_selection_dialog.dart';

class EditBudgetScreen extends StatelessWidget {
  final Budget budget;

  EditBudgetScreen({required this.budget});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditBudgetViewModel(budget),
      child: Consumer<EditBudgetViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: Column(
              children: [
                CustomHeader_1(
                  title: 'Sửa hạn mức',
                  action: IconButton(
                    icon: Icon(Icons.check, color: Colors.white),
                    onPressed: viewModel.enableButton
                        ? () async {
                            final updatedBudget =
                                await viewModel.updateBudget(context);
                            if (updatedBudget != null) {
                              await CustomSnackBar_2.show(
                                  context, 'Cập nhật thành công');
                              Navigator.pop(context, updatedBudget);
                            } else {
                              CustomSnackBar_1.show(context,
                                  'Có lỗi xảy ra khi cập nhật hạn mức.');
                            }
                          }
                        : null,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Consumer<EditBudgetViewModel>(
                        builder: (context, model, child) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(15),
                                    ],
                                    controller: viewModel.amountController,
                                    decoration:
                                        InputDecoration(labelText: 'Số tiền'),
                                    style: TextStyle(
                                      fontSize: 28,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.right,
                                    keyboardType: TextInputType.number,
                                    onChanged: (_) =>
                                        viewModel.updateButtonState(),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Text(
                                    '₫',
                                    style: TextStyle(
                                      fontSize: 28,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: model.nameController,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(40),
                              ],
                              decoration: InputDecoration(
                                labelText: 'Tên hạn mức',
                              ),
                              onChanged: (_) => viewModel.updateButtonState(),
                            ),
                            SizedBox(height: 16),
                            ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 0),
                              leading: SizedBox(
                                width: 60,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  child: Stack(
                                    children: [
                                      if (viewModel.selectedCategories.length >
                                          2)
                                        Positioned(
                                          left: 20,
                                          child: CircleAvatar(
                                            backgroundColor: parseColor(
                                                viewModel.selectedCategories[2]
                                                    .color),
                                            child: Icon(
                                              parseIcon(viewModel
                                                  .selectedCategories[2].icon),
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                          ),
                                        ),
                                      if (viewModel.selectedCategories.length >
                                          1)
                                        Positioned(
                                          left: 10,
                                          child: CircleAvatar(
                                            backgroundColor: parseColor(
                                                viewModel.selectedCategories[1]
                                                    .color),
                                            child: Icon(
                                              parseIcon(viewModel
                                                  .selectedCategories[1].icon),
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                          ),
                                        ),
                                      if (viewModel
                                          .selectedCategories.isNotEmpty)
                                        Positioned(
                                          left: 0,
                                          child: CircleAvatar(
                                            backgroundColor: parseColor(
                                                viewModel.selectedCategories[0]
                                                    .color),
                                            child: Icon(
                                              parseIcon(viewModel
                                                  .selectedCategories[0].icon),
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              title: Text(
                                viewModel.getCategoriesText(
                                    viewModel.selectedCategories,
                                    viewModel.categories),
                                style: TextStyle(fontSize: 16),
                              ),
                              trailing: Text(
                                '>',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return MultiCategorySelectionDialog(
                                      categories: viewModel.categories,
                                      selectedCategories:
                                          viewModel.selectedCategories,
                                      onSelect: (List<Category> categories) {
                                        viewModel.setCategories(categories);
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                            SizedBox(height: 16),
                            ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 0),
                              leading: SizedBox(
                                width: 60,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  child: Stack(
                                    children: [
                                      if (viewModel.selectedWallets.length > 2)
                                        Positioned(
                                          left: 20,
                                          child: CircleAvatar(
                                            backgroundColor: parseColor(
                                                viewModel
                                                    .selectedWallets[2].color),
                                            child: Icon(
                                              parseIcon(viewModel
                                                  .selectedWallets[2].icon),
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                          ),
                                        ),
                                      if (viewModel.selectedWallets.length > 1)
                                        Positioned(
                                          left: 10,
                                          child: CircleAvatar(
                                            backgroundColor: parseColor(
                                                viewModel
                                                    .selectedWallets[1].color),
                                            child: Icon(
                                              parseIcon(viewModel
                                                  .selectedWallets[1].icon),
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                          ),
                                        ),
                                      if (viewModel.selectedWallets.isNotEmpty)
                                        Positioned(
                                          left: 0,
                                          child: CircleAvatar(
                                            backgroundColor: parseColor(
                                                viewModel
                                                    .selectedWallets[0].color),
                                            child: Icon(
                                              parseIcon(viewModel
                                                  .selectedWallets[0].icon),
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              title: Text(
                                viewModel.getWalletsText(
                                    viewModel.selectedWallets,
                                    viewModel.wallets),
                                style: TextStyle(fontSize: 16),
                              ),
                              trailing: Text(
                                '>',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return MultiWalletSelectionDialog(
                                      wallets: viewModel.wallets,
                                      selectedWallets:
                                          viewModel.selectedWallets,
                                      onSelect: (List<Wallet> wallets) {
                                        viewModel.setWallets(wallets);
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                            SizedBox(height: 16),
                            DropdownButtonFormField<Repeat>(
                              value: model.selectedRepeat,
                              items: model.repeatOptions
                                  .map((option) =>
                                      DropdownMenuItem<Repeat>(
                                        value: option,
                                        child: Text(model.getRepeatBudgetString(
                                            option)), // Convert RepeatBudget to string here
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  model.setSelectedRepeat(value);
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'Lặp lại',
                              ),
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: model.startDateController,
                              readOnly: true,
                              onTap: () async {
                                final DateTime? picked = await showDatePicker(
                                  locale: const Locale('vi', 'VN'),
                                  context: context,
                                  initialDate: viewModel.startDate,
                                  firstDate: DateTime(1999),
                                  lastDate: DateTime(2100),
                                );
                                if (picked != null &&
                                    picked != viewModel.startDate) {
                                  viewModel.setStartDate(picked);
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'Ngày bắt đầu',
                              ),
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: model.endDateController
                                ..text = model.endDateController.text.isEmpty
                                    ? 'Chưa xác định'
                                    : model.endDateController.text,
                              readOnly: true,
                              onTap: () async {
                                final DateTime? picked = await showDatePicker(
                                  locale: const Locale('vi', 'VN'),
                                  context: context,
                                  initialDate:
                                      viewModel.endDate ?? DateTime.now(),
                                  firstDate: DateTime(1999),
                                  lastDate: DateTime(2100),
                                );
                                if (picked != null &&
                                    picked != viewModel.endDate) {
                                  viewModel.setEndDate(picked);
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'Ngày kết thúc',
                                hintText: model.endDateController.text.isEmpty
                                    ? 'Chưa xác định'
                                    : '',
                              ),
                            ),
                            SizedBox(height: 30),
                            CustomElevatedButton_2(
                              text: 'Lưu',
                              onPressed: viewModel.enableButton
                                  ? () async {
                                      final updatedBudget =
                                          await viewModel.updateBudget(context);
                                      if (updatedBudget != null) {
                                        await CustomSnackBar_2.show(
                                            context, 'Cập nhật thành công');
                                        Navigator.pop(context, updatedBudget);
                                      }
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
