import 'package:expense_management/view/budget/edit_budget_screen.dart';
import 'package:expense_management/widget/custom_header_1.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../model/budget_model.dart';
import '../../model/enum.dart';
import '../../model/transaction_model.dart';
import '../../utils/utils.dart';
import '../../view_model/budget/detail_budget_view_model.dart';

class DetailBudgetScreen extends StatefulWidget {
  final Budget budget;

  DetailBudgetScreen({required this.budget});

  @override
  State<DetailBudgetScreen> createState() => _DetailBudgetScreenState();
}

class _DetailBudgetScreenState extends State<DetailBudgetScreen> {

  final GlobalKey _toolTipKey1 = GlobalKey();
  final GlobalKey _toolTipKey2 = GlobalKey();
  final GlobalKey _toolTipKey3 = GlobalKey();

  void _showToolTip(GlobalKey key) {
    final dynamic tooltip = key.currentState;
    tooltip.ensureTooltipVisible();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DetailBudgetViewModel(widget.budget),
      child: Consumer<DetailBudgetViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: Column(
              children: [
                CustomHeader_1(
                  title: 'Chi tiết hạn mức',
                  action: IconButton(
                    icon: Icon(Icons.edit, color: Colors.white),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditBudgetScreen(
                                  budget: widget.budget),
                        ),
                      );
                      if (result != null) {
                        Navigator.pop(context, result);
                      }
                    },
                  ),
                ),
                if (viewModel.transactions.isEmpty)
                  Center(child: CircularProgressIndicator())
                else
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.all(8.0),
                      children: [
                        // Tên hạn mức
                        ListTile(
                          title: Text('Tên hạn mức'),
                          trailing: Text(
                            widget.budget.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        // Số tiền hạn mức
                        ListTile(
                          title: Text('Hạn mức'),
                          trailing: Text(
                            '${formatTotalBalance(widget.budget.amount)} ₫',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        // Tổng chi tiêu
                        ListTile(
                          title: Text('Tổng chi tiêu'),
                          trailing: Text(
                            '${formatTotalBalance(viewModel.totalExpenditure)} ₫',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        // Hạn mức còn lại hoặc bội chi
                        ListTile(
                          title: Text(amountLeft(widget.budget, viewModel) < 0
                              ? 'Bội chi'
                              : 'Hạn mức còn lại'),
                          trailing: Text(
                            '${formatTotalBalance(amountLeft(widget.budget, viewModel).abs())} ₫',
                            style: TextStyle(
                                color: amountLeft(widget.budget, viewModel) < 0
                                    ? Colors.red
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                        // Thanh tiến trình
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 20.0),
                          child: LinearProgressIndicator(
                            value: _calculateProgress(
                                widget.budget.amount, viewModel.totalExpenditure),
                            color: amountLeft(widget.budget, viewModel) < 0
                                ? Colors.red
                                : Colors.blue,
                          ),
                        ),
                        // Thời gian
                        ListTile(
                          title: Text('Thời gian'),
                          trailing: Text(
                            '${_formatDate(widget.budget.startDate)} - ${_formatDate(widget.budget.endDate)}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        // Còn bao ngày
                        ListTile(
                          title: Text('Số ngày còn lại'),
                          trailing: Text(
                            '${_calculateDaysLeft(widget.budget.startDate, widget.budget.endDate)} ngày',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        Divider(),
                        // Thực tế chi tiêu
                        GestureDetector(
                          onTap: () => _showToolTip(_toolTipKey1),
                          child: Tooltip(
                            key: _toolTipKey1 ,
                            message: 'Tổng số tiền đã chi tiêu / Khoảng thời gian chi tiêu',
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            preferBelow: false, // Đặt tooltip ở phía trên nếu có thể
                            child: ListTile(
                              title: Row(
                                children: [
                                  Text('Thực tế chi tiêu'),
                                  SizedBox(width: 5),
                                  CircleAvatar(
                                      radius: 10,
                                      backgroundColor: Colors.grey,
                                      child: Icon(FontAwesomeIcons.question, color: Colors.white, size: 13,)),
                                ],
                              ),
                              trailing: Text(
                                '${formatTotalBalance(viewModel.actualSpending)} ₫/ngày',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ),
                        ),

                        // Nên chi tiêu
                        GestureDetector(
                          onTap: () => _showToolTip(_toolTipKey2),
                          child: Tooltip(
                            key: _toolTipKey2 ,
                            message: 'Số tiền còn lại của hạn mức chi / Số ngày còn lại',
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            preferBelow: false, // Đặt tooltip ở phía trên nếu có thể
                            child: ListTile(
                              title: Row(
                                children: [
                                  Text('Nên chi tiêu'),
                                  SizedBox(width: 5),
                                  CircleAvatar(
                                      radius: 10,
                                      backgroundColor: Colors.grey,
                                      child: Icon(FontAwesomeIcons.question, color: Colors.white, size: 13,)),
                                ],
                              ),
                              trailing: Text(
                                '${formatTotalBalance(viewModel.recommendedSpending)} ₫/ngày',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        // Dự kiến chi tiêu
                        GestureDetector(
                          onTap: () => _showToolTip(_toolTipKey3),
                          child: Tooltip(
                            key: _toolTipKey3 ,
                            message: 'Thực tế chi tiêu * Số ngày còn lại + Số tiền đã chi',
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            preferBelow: false, // Đặt tooltip ở phía trên nếu có thể
                            child: ListTile(
                              title: Row(
                                children: [
                                  Text('Dự kiến chi tiêu'),
                                  SizedBox(width: 5),
                                  CircleAvatar(
                                      radius: 10,
                                      backgroundColor: Colors.grey,
                                      child: Icon(FontAwesomeIcons.question, color: Colors.white, size: 13,)),
                                ],
                              ),
                              trailing: Text(
                                '${formatTotalBalance(viewModel.projectedSpending)} ₫',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                        Divider(),
                        ListTile(
                          title: Text('Chi tiết giao dịch chi tiêu'),
                          trailing: viewModel.showTransactions
                              ? Icon(Icons.arrow_drop_down)
                              : Icon(Icons.arrow_drop_up),
                          onTap: () => viewModel.toggleShowTransactions(),
                        ),
                        // Chi tiết giao dịch
                        if (viewModel.showTransactions)
                          ...viewModel.groupedTransactions.entries.map((entry) {
                            String date = entry.key;
                            List<Transactions> transactions = entry.value;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(date,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ),
                                ...transactions.map((transaction) {
                                  final category = viewModel
                                      .categoryMap[transaction.categoryId];
                                  final wallet =
                                      viewModel.walletMap[transaction.walletId];
                                  if (category != null) {
                                    return Card(
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor:
                                              parseColor(category.color),
                                          child: Icon(parseIcon(category.icon),
                                              color: Colors.white),
                                        ),
                                        title: Text(category.name),
                                        subtitle: wallet != null
                                            ? Text(
                                                '(${wallet.name})\n${formatHour(transaction.hour)}')
                                            : Text(
                                                'Không có ví\n${transaction.date}\n${formatHour(transaction.hour)}'),
                                        trailing: Text(
                                          '${formatAmount_2(transaction.amount, transaction.currency)} ${transaction.currency == Currency.VND ? '₫' : '\$'}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.red),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return SizedBox
                                        .shrink(); // Ẩn transaction nếu không có category
                                  }
                                }).toList(),
                              ],
                            );
                          }).toList(),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  double _calculateProgress(double budgetAmount, double spentAmount) {
    return spentAmount / budgetAmount;
  }

  int _calculateDaysLeft(DateTime startDate, DateTime endDate) {
    return endDate.difference(DateTime.now()).inDays;
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  double amountLeft(Budget budget, DetailBudgetViewModel viewModel) {
    return budget.amount - viewModel.totalExpenditure;
  }
}
