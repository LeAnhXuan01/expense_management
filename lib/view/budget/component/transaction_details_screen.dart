import 'package:flutter/material.dart';
import '../../../utils/previous_period.dart';
import '../../../utils/utils.dart';
import '../../../view_model/budget/detail_budget_view_model.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final PreviousPeriod period;
  final DetailBudgetViewModel viewModel;

  TransactionDetailsScreen({required this.period, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết giao dịch'),
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: period.transactions.map((transaction) {
          final category = viewModel.categoryMap[transaction.categoryId];
          final wallet = viewModel.walletMap[transaction.walletId];
          if (category != null) {
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: parseColor(category.color),
                  child: Icon(parseIcon(category.icon), color: Colors.white),
                ),
                title: Text(category.name),
                subtitle: wallet != null
                    ? Text('(${wallet.name})\n${formatHour(transaction.hour)}')
                    : Text(
                    'Không có ví\n${transaction.date}\n${formatHour(transaction.hour)}'),
                trailing: Text(
                  '${formatAmount_2(transaction.amount)} ₫',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.red),
                ),
              ),
            );
          } else {
            return SizedBox.shrink(); // Ẩn transaction nếu không có category
          }
        }).toList(),
      ),
    );
  }
}
