import 'package:expense_management/view/transfer/wallet_selection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:expense_management/widget/custom_ElevatedButton_2.dart';
import 'package:expense_management/widget/custom_header_1.dart';
import '../../utils/utils.dart';
import '../../view_model/transfer/create_transfer_view_model.dart';
import '../../widget/custom_snackbar_2.dart';

class CreateTransferScreen extends StatefulWidget {
  @override
  State<CreateTransferScreen> createState() => _CreateTransferScreenState();
}

class _CreateTransferScreenState extends State<CreateTransferScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TransferViewModel(),
      child: Scaffold(
        body: Column(
          children: [
            CustomHeader_1(title: 'Tạo chuyển khoản'),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Consumer<TransferViewModel>(
                  builder: (context, viewModel, child) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return WalletSelectionDialog(
                                  wallets: viewModel.wallets,
                                  onSelect: (wallet) {
                                    viewModel.setSelectedFromWallet(wallet);
                                  },
                                );
                              },
                            );
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Chọn tài khoản nguồn',
                            ),
                            child: viewModel.selectedFromWallet != null
                                ? Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                      parseColor(viewModel.selectedFromWallet!.color)
                                  ),
                                  child: Icon(
                                    parseIcon(viewModel.selectedFromWallet!.icon),
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(viewModel.selectedFromWallet!.name),
                              ],
                            )
                                : Text('Chọn tài khoản'),
                          ),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return WalletSelectionDialog(
                                  wallets: viewModel.wallets
                                      .where((wallet) =>
                                          wallet !=
                                          viewModel.selectedFromWallet)
                                      .toList(),
                                  onSelect: (wallet) {
                                    viewModel.setSelectedToWallet(wallet);
                                  },
                                );
                              },
                            );
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Chọn tài khoản đích',
                            ),
                            child: viewModel.selectedToWallet != null
                                ? Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                         parseColor(viewModel.selectedToWallet!.color)
                                  ),
                                  child: Icon(
                                    parseIcon(viewModel.selectedToWallet!.icon),
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(viewModel.selectedToWallet!.name),
                              ],
                            )
                                : Text('Chọn tài khoản'),
                          ),
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
                                controller: viewModel.amountController,
                                decoration: InputDecoration(
                                    labelText: 'Số tiền chuyển khoản'),
                                style: TextStyle(fontSize: 25, color: Colors.green, fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,

                                keyboardType: TextInputType.number,
                                onChanged: (_) => viewModel.updateButtonState,
                              ),
                            ),

                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(top:20.0),
                                child: Text(
                                  'VND',
                                  style: TextStyle(
                                    fontSize: 25,
                                  ),
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
                                readOnly: true,
                                controller: viewModel.dateController,
                                onTap: () async {
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: viewModel.selectedDate,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime.now(),
                                  );
                                  if (picked != null &&
                                      picked != viewModel.selectedDate) {
                                    viewModel.setSelectedDate(picked);
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: 'Ngày',
                                  suffixIcon: Icon(Icons.calendar_today),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Flexible(
                              flex: 1,
                              child: TextFormField(
                                readOnly: true,
                                controller: viewModel.hourController,
                                onTap: () async {
                                  final TimeOfDay? picked = await showTimePicker(
                                    context: context,
                                    initialTime: viewModel.selectedHour,
                                  );
                                  if (picked != null && picked != viewModel.selectedHour) {
                                    viewModel.setSelectedHour(picked);
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: 'Giờ',
                                  suffixIcon: Icon(Icons.access_time),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(400),
                          ],
                          controller: viewModel.noteController,
                          decoration: InputDecoration(labelText: 'Ghi chú'),
                        ),
                        SizedBox(height: 20),
                        CustomElevatedButton_2(
                          onPressed: viewModel.enableButton
                              ? () async {
                                  final newTransfer =
                                      await viewModel.createTransfer(context);
                                  if (newTransfer != null) {
                                    CustomSnackBar_2.show(
                                        context, 'Chuyển khoản thành công');
                                    await Future.delayed(Duration(seconds: 2));
                                    Navigator.pop(context, newTransfer);
                                    viewModel.resetFields();
                                  }
                                }
                              : null,
                          text: 'Lưu',
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
