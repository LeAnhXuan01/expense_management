import 'package:expense_management/widget/custom_ElevatedButton_2.dart';
import 'package:expense_management/widget/custom_header_1.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreatBudgetScreen extends StatefulWidget {
  @override
  _CreatBudgetScreenState createState() => _CreatBudgetScreenState();
}

class _CreatBudgetScreenState extends State<CreatBudgetScreen> {
  final TextEditingController _amountController = TextEditingController(text: '0');
  final TextEditingController _nameController = TextEditingController();
  String? _selectedCategory;
  String? _selectedWallet;
  String? _selectedRepeat = 'Không lặp lại';
  DateTime? _startDate = DateTime.now();
  DateTime? _endDate;

  final List<String> _categories = ['Danh mục 1', 'Danh mục 2', 'Danh mục 3'];
  final List<String> _wallets = ['Ví 1', 'Ví 2', 'Ví 3'];
  final List<String> _repeatOptions = [
    'Không lặp lại',
    'Hàng ngày',
    'Hàng tuần',
    'Hàng tháng',
    'Hàng quý',
    'Hàng năm'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomHeader_1(title: 'Lập hạn mức'),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Số tiền',
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Tên hạn mức',
                      ),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      items: _categories
                          .map((category) => DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Danh mục',
                      ),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedWallet,
                      items: _wallets
                          .map((wallet) => DropdownMenuItem<String>(
                        value: wallet,
                        child: Text(wallet),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedWallet = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Ví',
                      ),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedRepeat,
                      items: _repeatOptions
                          .map((option) => DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedRepeat = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Lặp lại',
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Ngày bắt đầu',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _startDate!,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null && pickedDate != _startDate)
                          setState(() {
                            _startDate = pickedDate;
                          });
                      },
                      controller: TextEditingController(
                        text: _startDate != null ? DateFormat('dd/MM/yyyy').format(_startDate!) : '',
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Ngày kết thúc',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null)
                          setState(() {
                            _endDate = pickedDate;
                          });
                      },
                      controller: TextEditingController(
                        text: _endDate != null ? DateFormat('dd/MM/yyyy').format(_endDate!) : 'Không xác định',
                      ),
                    ),
                    SizedBox(height: 32),
                    Center(
                      child: CustomElevatedButton_2(
                        onPressed: () {
                          // Lưu logic sẽ ở đây
                        },
                        text: 'Lưu',
                      ),
                    ),
                  ],
                ),

            ),
          ),
        ],
      ),
    );
  }
}
