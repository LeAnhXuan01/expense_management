import 'package:expense_management/model/category_model.dart';
import 'package:expense_management/model/enum.dart';
import 'package:expense_management/model/transaction_model.dart';
import 'package:expense_management/view_model/transaction/edit_transaction_view_model.dart';
import 'package:expense_management/view_model/transaction/transaction_history_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../utils/utils.dart';
import '../../widget/custom_ElevatedButton_2.dart';
import '../../widget/custom_header_4.dart';
import '../../widget/custom_snackbar_2.dart';
import 'component/expense_category_screen.dart';
import 'component/image_detail_screen.dart';
import 'component/income_category_screen.dart';
import 'component/wallet_list_screen.dart';

class EditTransactionScreen extends StatefulWidget {
  final Transactions transaction;

  EditTransactionScreen({required this.transaction});

  @override
  _EditTransactionScreenState createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  late EditTransactionViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = EditTransactionViewModel();
    _viewModel.initialize(widget.transaction);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _viewModel,
      child: Consumer<EditTransactionViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: Column(
              children: [
                CustomHeader_4(
                  rightAction: IconButton(
                    icon: Icon(Icons.check, color: Colors.white),
                    onPressed: viewModel.enableButton
                        ? () async {
                            final updatedTransaction =
                                await viewModel.updateTransaction(
                                    widget.transaction.transactionId, context);
                            if (updatedTransaction != null) {
                              await CustomSnackBar_2.show(
                                  context, 'Cập nhật thành công');
                              Navigator.pop(context, updatedTransaction);
                            }
                          }
                        : null,
                  ),
                  title: viewModel.transactionTypeTitle,
                  onTitleChanged: (String? newTitle) {
                    viewModel.updateTransactionTypeTitle(newTitle!);
                  },
                  leftAction: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
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
                                    labelText: 'Số tiền',
                                  ),
                                  keyboardType: TextInputType.number,
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
                                      viewModel.transactionTypeTitle ==
                                              'Thu nhập'
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                          Category category = viewModel
                                              .frequentCategories[index];
                                          bool isSelected = category ==
                                              viewModel.selectedCategory;
                                          return GestureDetector(
                                            onTap: () {
                                              viewModel.setSelectedCategory(
                                                  category);
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: isSelected
                                                        ? parseColor(
                                                            category.color)
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      )
                                    : Center(
                                        child: CircularProgressIndicator()),
                            ],
                          ),
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
                          SizedBox(height: 16),
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
                          SizedBox(height: 16),
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
                          SizedBox(height: 16),
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
                          if (viewModel.existingImageUrls.isNotEmpty ||
                              viewModel.newImages.isNotEmpty)
                            GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10,
                              ),
                              itemCount: viewModel.existingImageUrls.length +
                                  viewModel.newImages.length,
                              itemBuilder: (context, index) {
                                if (index <
                                    viewModel.existingImageUrls.length) {
                                  // Hiển thị ảnh từ URL
                                  final imageUrl =
                                      viewModel.existingImageUrls[index];
                                  return Stack(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ImageDetailScreen(
                                                imageUrls:
                                                    viewModel.existingImageUrls,
                                                imageFiles: viewModel.newImages,
                                                initialIndex: index,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Image.network(
                                          imageUrl,
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
                                            viewModel.removeImage(imageUrl);
                                            setState(
                                                () {}); // Cập nhật giao diện sau khi xóa ảnh
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
                                } else {
                                  // Hiển thị ảnh từ tệp cục bộ
                                  final fileIndex = index -
                                      viewModel.existingImageUrls.length;
                                  final file = viewModel.newImages[fileIndex];
                                  return Stack(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ImageDetailScreen(
                                                imageUrls:
                                                    viewModel.existingImageUrls,
                                                imageFiles: viewModel.newImages,
                                                initialIndex: index,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Image.file(
                                          file,
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 2,
                                        child: GestureDetector(
                                          onTap: () {
                                            viewModel.removeNewImage(file);
                                            setState(
                                                () {}); // Cập nhật giao diện sau khi xóa ảnh
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
                                }
                              },
                            ),
                          SizedBox(height: 16),
                          CustomElevatedButton_2(
                            onPressed: viewModel.enableButton
                                ? () async {
                                    final updatedTransaction =
                                        await viewModel.updateTransaction(
                                            widget.transaction.transactionId, context);
                                    if (updatedTransaction != null) {
                                      await CustomSnackBar_2.show(
                                          context, 'Cập nhật thành công');
                                      Navigator.pop(
                                          context, updatedTransaction);
                                    }
                                  }
                                : null,
                            text: 'Lưu giao dịch',
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
