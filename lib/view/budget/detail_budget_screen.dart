import 'package:expense_management/view/budget/edit_budget_screen.dart';
import 'package:expense_management/widget/custom_header_1.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../model/budget_model.dart';
import '../../model/enum.dart';
import '../../model/transaction_model.dart';
import '../../utils/previous_period.dart';
import '../../utils/utils.dart';
import '../../view_model/budget/detail_budget_view_model.dart';
import 'component/previous_period_details_screen.dart';

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
                              EditBudgetScreen(budget: widget.budget),
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
                      padding: EdgeInsets.all(0.0),
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
                          title: Text(
                              viewModel.totalExpenditure > widget.budget.amount
                                  ? 'Bội chi'
                                  : 'Hạn mức còn lại'),
                          trailing: Text(
                            '${formatTotalBalance((widget.budget.amount - viewModel.totalExpenditure).abs())} ₫',
                            style: TextStyle(
                              color: viewModel.totalExpenditure >
                                      widget.budget.amount
                                  ? Colors.red
                                  : Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        // Thanh tiến trình
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 20.0),
                          child: LinearProgressIndicator(
                            value: viewModel.totalExpenditure /
                                widget.budget.amount,
                            color: viewModel.totalExpenditure >
                                    widget.budget.amount
                                ? Colors.red
                                : Colors.blue,
                          ),
                        ),
                        // Thời gian
                        ListTile(
                          title: Text('Thời gian'),
                          trailing: viewModel.isExpired
                              ? Text(
                                  'Hết hạn',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.red,
                                  ),
                                )
                              : viewModel.budget.repeat == Repeat.Daily
                                  ? Text(
                                      '${formatDate_2(viewModel.currentPeriodStart)}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    )
                                  : Text(
                                      '${formatDate_2(viewModel.currentPeriodStart)} - ${formatDate_2(viewModel.currentPeriodEnd)}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                        ),
                        // Còn bao ngày
                        if (viewModel.budget.repeat != Repeat.Daily &&
                            viewModel.isExpired != true &&
                            !_isSameDay(
                                viewModel.currentPeriodEnd, DateTime.now()))
                          ListTile(
                            title: Text('Số ngày còn lại'),
                          trailing: Text(
                              '${viewModel.remainingDays} ngày',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        Divider(),
                        // Thực tế chi tiêu
                        GestureDetector(
                          onTap: () => _showToolTip(_toolTipKey1),
                          child: Tooltip(
                            key: _toolTipKey1,
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
                                    child: Icon(FontAwesomeIcons.question,
                                        color: Colors.white, size: 13),
                                  ),
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
                            key: _toolTipKey2,
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
                                    child: Icon(FontAwesomeIcons.question,
                                        color: Colors.white, size: 13),
                                  ),
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
                            key: _toolTipKey3,
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
                                    child: Icon(FontAwesomeIcons.question,
                                        color: Colors.white, size: 13),
                                  ),
                                ],
                              ),
                              trailing: Text(
                                '${formatTotalBalance(viewModel.projectedSpending)} ₫',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: viewModel.projectedSpending >
                                          viewModel.budget.amount
                                      ? Colors.red
                                      : Colors.green,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Divider(),
                        if (viewModel.previousPeriods.isNotEmpty)
                          ListTile(
                            title: Text('Hạn mức chi tiêu các kỳ trước'),
                            trailing: viewModel.showPreviousPeriods
                                ? Icon(Icons.arrow_drop_down)
                                : Icon(Icons.arrow_drop_up),
                            onTap: () => viewModel.toggleShowPreviousPeriods(),
                          ),
                        if (viewModel.showPreviousPeriods)
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, bottom: 8.0),
                            child: Column(
                              children: viewModel.previousPeriods.map((period) {
                                return GestureDetector(
                                  onTap: () => _showPreviousPeriodDetails(
                                      context, period, viewModel),
                                  child: Card(
                                    color: Colors.grey[300],
                                    child: ListTile(
                                      title: Center(
                                        child: Text(
                                          isSameDate(period.startDate, period.endDate)
                                              ? '${formatDate_2(period.startDate)}'
                                              : '${formatDate_2(period.startDate)} - ${formatDate_2(period.endDate)}',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      // subtitle: Text(
                                      //   period.isOverBudget
                                      //       ? 'Bội chi: ${formatTotalBalance(period.remainingBudget.abs())} ₫'
                                      //       : 'Hạn mức còn lại: ${formatTotalBalance(period.remainingBudget)} ₫',
                                      //   style: TextStyle(
                                      //     color: period.isOverBudget ? Colors.red : Colors.black,
                                      //   ),
                                      // ),
                                      // trailing: SizedBox(
                                      //   width: 100, // Provide a fixed width for the progress indicator
                                      //   child: LinearProgressIndicator(
                                      //     value: period.totalExpenditure / viewModel.budget.amount,
                                      //     color: period.isOverBudget ? Colors.red : Colors.blue,
                                      //   ),
                                      // ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        if (viewModel.filteredTransactions.isNotEmpty)
                          ListTile(
                          title: Text('Chi tiết giao dịch chi tiêu'),
                          trailing: viewModel.showTransactions
                              ? Icon(Icons.arrow_drop_down)
                              : Icon(Icons.arrow_drop_up),
                          onTap: () => viewModel.toggleShowTransactions(),
                        ),

                        // Chi tiết giao dịch chi tiêu
                        if (viewModel.showTransactions)
                          ...viewModel.groupedTransactions.entries.map((entry) {
                            String date = entry.key;
                            List<Transactions> transactions = entry.value;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
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
                                   return Card(
                                      color: Colors.grey[300],
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: category != null
                                              ? parseColor(category.color)
                                              : Colors.grey,
                                          child: category != null
                                              ? Icon(parseIcon(category.icon),
                                              color: Colors.white)
                                              :  Icon(Icons.category, color: Colors.white),
                                        ),
                                        title: Text(category != null ? category.name : 'Không có danh mục'),
                                        subtitle: Text(
                                            '(${wallet?.name})\n${formatHour(transaction.hour)}'),
                                        trailing: Text(
                                          '${formatAmount_2(transaction.amount)} ₫',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.red),
                                        ),
                                      ),
                                    );
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

  void _showPreviousPeriodDetails(BuildContext context, PreviousPeriod period,
      DetailBudgetViewModel viewModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviousPeriodDetailsScreen(
          period: period,
          viewModel: viewModel,
        ),
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

}
