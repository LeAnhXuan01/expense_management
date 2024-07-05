import 'dart:io';
import 'package:expense_management/widget/custom_header_4.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:expense_management/model/enum.dart';
import 'package:expense_management/widget/custom_ElevatedButton_2.dart';
import '../../model/category_model.dart';
import '../../utils/utils.dart';
import '../../view_model/transaction/create_transaction_view_model.dart';
import '../../widget/custom_snackbar_2.dart';
import 'component/expense_category_screen.dart';
import 'component/image_detail_screen.dart';
import 'component/income_category_screen.dart';
import 'component/wallet_list_screen.dart';

class CreateTransactionScreen extends StatefulWidget {
  @override
  State<CreateTransactionScreen> createState() =>
      _CreateTransactionScreenState();
}

class _CreateTransactionScreenState extends State<CreateTransactionScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CreateTransactionViewModel(),
      child: Consumer<CreateTransactionViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: Column(
              children: [
                CustomHeader_4(
                  leftAction: IconButton(
                    icon: Icon(Icons.check, color: Colors.white),
                    onPressed: viewModel.enableButton
                        ? () async {
                            final newTransaction =
                                await viewModel.createTransaction(context);
                            if (newTransaction != null) {
                              await CustomSnackBar_2.show(
                                  context, 'Tạo thành công');
                              viewModel.resetFields();
                            }
                          }
                        : null,
                  ),
                  title: viewModel.transactionTypeTitle,
                  onTitleChanged: (String? newTitle) {
                    viewModel.updateTransactionTypeTitle(newTitle!);
                  },
                  rightAction: IconButton(
                    icon: Icon(Icons.delete, color: Colors.white),
                    onPressed: () {
                      viewModel.resetFields();
                    },
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                flex: 2,
                                child: TextField(
                                  controller: viewModel.amountController,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(15),
                                  ],
                                  onChanged: (value) {
                                    viewModel.setAmount(
                                        double.tryParse(value) ?? 0.0);
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Số tiền', hintText: '0'
                                  ),
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: viewModel.isIncomeTabSelected ? Colors.green : Colors.red,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                flex: 1,
                                child: DropdownButtonFormField<Currency>(
                                  value: viewModel.selectedCurrency,
                                  items:
                                      Currency.values.map((Currency currency) {
                                    return DropdownMenuItem<Currency>(
                                      value: currency,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(currency == Currency.VND
                                              ? 'VND'
                                              : 'USD'),
                                          Text(currency == Currency.VND
                                              ? '₫'
                                              : '\$'),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (Currency? value) {
                                    if (value != null) {
                                      viewModel.setSelectedCurrency(value);
                                    }
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Đơn vị tiền tệ',
                                  ),
                                  selectedItemBuilder: (BuildContext context) {
                                    return Currency.values
                                        .map((Currency currency) {
                                      return Row(
                                        children: [
                                          Text(currency == Currency.VND
                                              ? '₫'
                                              : '\$'),

                                        ],
                                      );
                                    }).toList();
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                            // Để loại bỏ padding mặc định
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: viewModel.selectedCategory != null
                                    ? parseColor(
                                        viewModel.selectedCategory!.color)
                                    : Colors.grey,
                              ),
                              child: viewModel.selectedCategory != null
                                  ? Icon(
                                      parseIcon(
                                          viewModel.selectedCategory!.icon),
                                      color: Colors.white,
                                      size: 30,
                                    )
                                  : Icon(
                                      Icons.category,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                            ),
                            title: viewModel.selectedCategory != null
                                ? Text(
                                    viewModel.selectedCategory!.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 18),
                                  )
                                : Text(
                                    'Chọn danh mục',
                                    style: TextStyle(fontSize: 18),
                                  ),
                            trailing: Text(
                              'Tất cả  >',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: () async {
                              final selectedCategory = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      viewModel.isIncomeTabSelected
                                          ? IncomeCategoryScreen()
                                          : ExpenseCategoryScreen(),
                                ),
                              );
                              if (selectedCategory != null) {
                                viewModel.setSelectedCategory(selectedCategory);
                              }
                            },
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Danh mục hay dùng',
                                  style: TextStyle(fontSize: 18)),
                              GestureDetector(
                                onTap: () {
                                  viewModel.toggleShowPlusButtonCategory();
                                },
                                child: Icon(
                                  viewModel.showPlusButtonCategory
                                      ? Icons.arrow_drop_down
                                      : Icons.arrow_drop_up,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          if (viewModel.showPlusButtonCategory)
                            viewModel.isFrequentCategoriesLoaded
                                ? GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3, // Số cột của grid
                                      childAspectRatio:
                                          1, // Tỷ lệ chiều rộng / chiều cao của mỗi item
                                    ),
                                    itemCount:
                                        viewModel.frequentCategories.length,
                                    itemBuilder: (context, index) {
                                      Category category =
                                          viewModel.frequentCategories[index];
                                      bool isSelected = category ==
                                          viewModel.selectedCategory;
                                      return GestureDetector(
                                        onTap: () {
                                          viewModel
                                              .setSelectedCategory(category);
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: isSelected
                                                    ? parseColor(category.color)
                                                    : Colors.transparent,
                                                shape: BoxShape.rectangle,
                                              ),
                                              child: Container(
                                                width: 45,
                                                height: 45,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: parseColor(
                                                      category.color),
                                                ),
                                                child: Icon(
                                                  parseIcon(category.icon),
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              category.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                : Center(child: CircularProgressIndicator()),
                          Divider(),
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                            // Để loại bỏ padding mặc định
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: viewModel.selectedWallet != null
                                    ? parseColor(
                                        viewModel.selectedWallet!.color)
                                    : Colors.grey,
                              ),
                              child: viewModel.selectedWallet != null
                                  ? Icon(
                                      parseIcon(viewModel.selectedWallet!.icon),
                                      color: Colors.white,
                                      size: 30,
                                    )
                                  : Icon(
                                      Icons.account_balance_wallet,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                            ),
                            title: viewModel.selectedWallet != null
                                ? Text(
                                    viewModel.selectedWallet!.name,
                                    style: TextStyle(fontSize: 20),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : Text(
                                    'Chọn ví tiền',
                                    style: TextStyle(fontSize: 20),
                                  ),
                            trailing: Text(
                              'Tất cả  >',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: () async {
                              final selectedWallet = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WalletListScreen(),
                                ),
                              );
                              if (selectedWallet != null) {
                                viewModel.setSelectedWallet(selectedWallet);
                              }
                            },
                          ),
                          Divider(),
                          Row(
                            children: [
                              Flexible(
                                flex: 2,
                                child: TextFormField(
                                  controller: viewModel.dateController,
                                  readOnly: true,
                                  onTap: () async {
                                    final DateTime? picked =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: viewModel.selectedDate,
                                      firstDate: DateTime(1999),
                                      lastDate: DateTime.now(),
                                    );
                                    if (picked != null &&
                                        picked != viewModel.selectedDate) {
                                      viewModel.setSelectedDate(picked);
                                    }
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Chọn ngày',
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: TextFormField(
                                  controller: viewModel.hourController,
                                  readOnly: true,
                                  onTap: () async {
                                    final TimeOfDay? picked =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: viewModel.selectedHour,
                                    );
                                    if (picked != null &&
                                        picked != viewModel.selectedHour) {
                                      viewModel.setSelectedHour(picked);
                                    }
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Chọn giờ',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          TextField(
                            controller: viewModel.noteController,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(400),
                            ],
                            onChanged: (value) {
                              viewModel.setNote(value);
                            },
                            decoration: InputDecoration(
                              labelText: 'Ghi chú',
                            ),
                            keyboardType: TextInputType.text,
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await viewModel.captureImage(context);
                                  },
                                  child: Center(child: Icon(Icons.camera_alt)),
                                ),
                              ),
                              Flexible(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await viewModel
                                        .pickImageFromGallery(context);
                                  },
                                  child:
                                      Center(child: Icon(Icons.photo_library)),
                                ),
                              ),
                            ],
                          ),
                          if (viewModel.images.isNotEmpty)
                            GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10,
                              ),
                              itemCount: viewModel.images.length,
                              itemBuilder: (context, index) {
                                final imagePath = viewModel.images[index].path;
                                return Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ImageDetailScreen(
                                              imageFiles: viewModel.images
                                                  .map((image) =>
                                                      File(image.path))
                                                  .toList(),
                                              initialIndex: index,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Image.file(
                                        File(imagePath),
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          viewModel.removeImage(imagePath);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.remove_circle,
                                            color: Colors.red,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          SizedBox(height: 16),
                          CustomElevatedButton_2(
                            onPressed: viewModel.enableButton
                                ? () async {
                                    final newTransaction = await viewModel
                                        .createTransaction(context);
                                    if (newTransaction != null) {
                                      await CustomSnackBar_2.show(
                                          context, 'Tạo thành công');
                                      viewModel.resetFields();
                                    }
                                  }
                                : null,
                            text: 'Tạo giao dịch',
                          ),
                        ],
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
