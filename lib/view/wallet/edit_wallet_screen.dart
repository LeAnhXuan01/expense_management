import 'package:expense_management/widget/custom_header_1.dart';
import 'package:expense_management/widget/custom_snackbar_1.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../model/enum.dart';
import '../../model/wallet_model.dart';
import '../../utils/color_list.dart';
import '../../utils/icon_list.dart';
import '../../view_model/wallet/edit_wallet_view_model.dart';
import '../../widget/custom_ElevatedButton_2.dart';
import '../../widget/custom_snackbar_2.dart';

class EditWalletScreen extends StatefulWidget {
  final Wallet wallet;

  EditWalletScreen({required this.wallet});

  @override
  State<EditWalletScreen> createState() => _EditWalletScreenState();
}

class _EditWalletScreenState extends State<EditWalletScreen> {
  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<EditWalletViewModel>(context, listen: false);
    viewModel.initialize(widget.wallet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<EditWalletViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              CustomHeader_1(
                title: 'Sửa ví tiền',
                action: IconButton(
                  icon: Icon(Icons.check, color: Colors.white),
                  onPressed: viewModel.enableButton
                      ? () async {
                          final updatedWallet = await viewModel.updateWallet(widget.wallet.walletId, widget.wallet.createdAt);
                          if (updatedWallet != null) {
                            await CustomSnackBar_2.show(
                                context, 'Cập nhật thành công');
                            Navigator.pop(context, updatedWallet);
                          } else {
                            CustomSnackBar_1.show(
                                context, 'Có lỗi xảy ra khi cập nhật ví');
                          }
                        }
                      : null,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 70),
                              child: TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(50),
                                ],
                                controller: viewModel.walletNameController,
                                decoration:
                                    InputDecoration(
                                        labelText: 'Tên ví'
                                    ),
                                maxLines: null,
                                onChanged: (_) => viewModel.updateButtonState(),
                              ),
                            ),
                            if (viewModel.selectedIcon != null)
                              Positioned(
                                left: 2.0,
                                top: 5.0,
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: viewModel.selectedColor ??
                                        Colors.blueGrey.shade200,
                                  ),
                                  child: Icon(
                                    viewModel.selectedIcon,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            if (viewModel.selectedIcon == null)
                              Positioned(
                                left: 2.0,
                                top: 5.0,
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: viewModel.selectedColor ??
                                        Colors.blueGrey.shade200,
                                  ),
                                  child: Icon(
                                    FontAwesomeIcons.question,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Flexible(
                              flex: 2,
                              child: TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(15),
                                ],
                                controller: viewModel.initialBalanceController,
                                decoration:
                                    InputDecoration(labelText: 'Số dư ban đầu', hintText: '0'),
                                textAlign: TextAlign.start,
                                keyboardType: TextInputType.number,
                                onChanged: (_) => viewModel.updateButtonState(),
                              ),
                            ),
                            SizedBox(width: 10),
                            Flexible(
                              flex: 1,
                              child: DropdownButtonFormField<Currency>(
                                value: viewModel.selectedCurrency,
                                items: Currency.values.map((Currency currency) {
                                  return DropdownMenuItem<Currency>(
                                    value: currency,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(currency == Currency.VND
                                            ? 'VND'
                                            : 'USD'
                                        ),
                                        Text( currency == Currency.VND
                                            ? '₫'
                                            : '\$',
                                        )
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  viewModel.setSelectedCurrency(newValue!);

                                },
                                decoration: InputDecoration(
                                    labelText: 'Đơn vị tiền tệ'),
                                selectedItemBuilder: (BuildContext context){
                                  return Currency.values.map((Currency currency) {
                                    return Row(
                                      children: [
                                        Text(currency == Currency.VND ? '₫' : '\$'),
                                      ],
                                    );
                                  }).toList();
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              'Biểu tượng',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                viewModel.toggleShowPlusButtonIcon();
                              },
                              child: Icon(
                                viewModel.showPlusButtonIcon
                                    ? Icons.arrow_drop_down
                                    : Icons.arrow_drop_up,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        if (viewModel.showPlusButtonIcon)
                          GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 1,
                            ),
                            itemCount: walletIcons.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  viewModel.setSelectedIcon(walletIcons[index]);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: viewModel.selectedIcon ==
                                            walletIcons[index]
                                        ? Border.all(
                                            color: Colors.black, width: 1.0)
                                        : null,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: viewModel.selectedIcon ==
                                                walletIcons[index]
                                            ? (viewModel.selectedColor ??
                                                Colors.blueGrey.shade200)
                                            : Colors.blueGrey.shade200,
                                      ),
                                      child: Icon(
                                        walletIcons[index],
                                        size: 38,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        SizedBox(height: 40),
                        Row(
                          children: [
                            Text(
                              'Màu sắc:',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                viewModel.toggleShowPlusButtonColor();
                              },
                              child: Icon(
                                viewModel.showPlusButtonColor
                                    ? Icons.arrow_drop_down
                                    : Icons.arrow_drop_up,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        if (viewModel.showPlusButtonColor)
                          GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7,
                              mainAxisSpacing: 15,
                              crossAxisSpacing: 15,
                            ),
                            itemCount: colors_list.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  viewModel
                                      .setSelectedColor(colors_list[index]);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: colors_list[index],
                                    shape: BoxShape.circle,
                                  ),
                                  child: viewModel.selectedColor ==
                                          colors_list[index]
                                      ? Icon(Icons.check,
                                          color: Colors.white, size: 24)
                                      : null,
                                ),
                              );
                            },
                          ),
                        SizedBox(height: 10),
                        SwitchListTile(
                          title: Text('Không bao gồm trong tổng số dư'),
                          value: viewModel.excludeFromTotal,
                          onChanged: (bool value) {
                            viewModel.setExcludeFromTotal(value);
                          },
                        ),
                        SizedBox(height: 20),
                        CustomElevatedButton_2(
                          text: 'Cập nhật',
                          onPressed: viewModel.enableButton
                              ? () async {
                                  final updatedWallet =
                                      await viewModel.updateWallet(widget.wallet.walletId, widget.wallet.createdAt);
                                  if (updatedWallet != null) {
                                    await CustomSnackBar_2.show(context,
                                        'Cập nhật thành công');
                                    Navigator.pop(context, updatedWallet);
                                  } else {
                                    CustomSnackBar_1.show(context,
                                        'Có lỗi xảy ra khi cập nhật ví');
                                  }
                                }
                              : null,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
