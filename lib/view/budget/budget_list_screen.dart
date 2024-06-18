import 'package:expense_management/widget/custom_header_1.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Budget {
  final String name;
  final String category;
  final String wallet;
  final double amount;
  final double spent;
  final DateTime startDate;
  final DateTime? endDate;
  final String repeat;

  Budget({
    required this.name,
    required this.category,
    required this.wallet,
    required this.amount,
    required this.spent,
    required this.startDate,
    this.endDate,
    required this.repeat,
  });
}

class BudgetListScreen extends StatelessWidget {
  final List<Budget> spendingLimits = [
    Budget(
      name: 'Limit 1',
      category: 'Food',
      wallet: 'Wallet 1',
      amount: 500,
      spent: 250,
      startDate: DateTime.now().subtract(Duration(days: 10)),
      endDate: DateTime.now().add(Duration(days: 20)),
      repeat: 'Hàng tháng',
    ),
    Budget(
      name: 'Limit 2',
      category: 'Transport',
      wallet: 'Wallet 2',
      amount: 300,
      spent: 150,
      startDate: DateTime.now().subtract(Duration(days: 5)),
      endDate: DateTime.now().add(Duration(days: 15)),
      repeat: 'Không lặp lại',
    ),
    // Thêm dữ liệu mẫu khác nếu cần
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomHeader_1(title: 'Danh sách hạn mức'),
          Expanded(
            child: ListView.builder(
              itemCount: spendingLimits.length,
              itemBuilder: (context, index) {
                final limit = spendingLimits[index];
                final progress = limit.spent / limit.amount;
            
                return Card(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          limit.name,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text('Danh mục: ${limit.category}'),
                        Text('Ví: ${limit.wallet}'),
                        Text('Số tiền: \$${limit.amount.toStringAsFixed(2)}'),
                        Text('Đã chi: \$${limit.spent.toStringAsFixed(2)}'),
                        Text('Lặp lại: ${limit.repeat}'),
                        Text('Ngày bắt đầu: ${DateFormat('dd/MM/yyyy').format(limit.startDate)}'),
                        Text('Ngày kết thúc: ${limit.endDate != null ? DateFormat('dd/MM/yyyy').format(limit.endDate!) : 'Không xác định'}'),
                        SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey.shade300,
                          color: Colors.green,
                        ),
                        SizedBox(height: 4),
                        Text('${(progress * 100).toStringAsFixed(1)}% đã chi tiêu'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.pushNamed(context, '/creat-budget');
        },
        child: Icon(Icons.add, color: Colors.white,),
      ),
    );
  }
}

