import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../model/bill_model.dart';
import '../../model/enum.dart';
import '../../view_model/bill/edit_bill_view_model.dart';
import '../../widget/custom_ElevatedButton_2.dart';
import '../../widget/custom_header_1.dart';
import '../../widget/custom_snackbar_2.dart';

class EditBillScreen extends StatelessWidget {
  final Bill bill;

  EditBillScreen({required this.bill});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditBillViewModel(bill),
      child: Consumer<EditBillViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomHeader_1(title: 'Chỉnh sửa hóa đơn'),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: viewModel.nameController,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(50),
                        ],
                        decoration: InputDecoration(labelText: 'Tên hóa đơn'),
                        onChanged: viewModel.setName,
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<Repeat>(
                        value: viewModel.selectedRepeat,
                        items: viewModel.repeatOptions
                            .map((option) => DropdownMenuItem<Repeat>(
                          value: option,
                          child: Text(viewModel.getRepeatString(option)),
                        ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            viewModel.setSelectedRepeat(value);
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Lặp lại',
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Flexible(
                            flex: 2,
                            child: TextFormField(
                              controller: viewModel.dateController,
                              readOnly: true,
                              onTap: () async {
                                final DateTime? picked = await showDatePicker(
                                  locale: const Locale('vi', 'VN'),
                                  context: context,
                                  initialDate: viewModel.selectedDate,
                                  firstDate: DateTime(1999),
                                  lastDate: DateTime(2100),
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
                                final TimeOfDay? picked = await showTimePicker(
                                  context: context,
                                  initialTime: viewModel.selectedHour,
                                  builder: (BuildContext context, Widget? child) {
                                    return Localizations.override(
                                      context: context,
                                      locale: const Locale('vi', 'VN'),
                                      child: child,
                                    );
                                  },
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
                          LengthLimitingTextInputFormatter(120),
                        ],
                        onChanged: (value) {
                          viewModel.setNote(value);
                        },
                        decoration: InputDecoration(
                          labelText: 'Ghi chú',
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 32),
                      Center(
                        child: CustomElevatedButton_2(
                          onPressed: viewModel.enableButton
                              ? () async {
                            final updatedBill = await viewModel.updateBill(bill.billId, bill.createdAt);
                            if (updatedBill != null) {
                              await CustomSnackBar_2.show(
                                  context, 'Chỉnh sửa thành công');
                              Navigator.pop(context, updatedBill);
                            }
                          }
                              : null,
                          text: 'Lưu',
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}