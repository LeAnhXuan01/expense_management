import 'package:expense_management/utils/utils.dart';
import 'package:expense_management/view/budget/create_budget_screen.dart';
import 'package:expense_management/widget/custom_snackbar_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../model/budget_model.dart';
import '../../model/category_model.dart';
import '../../model/wallet_model.dart';
import '../../view_model/budget/budget_list_view_model.dart';
import '../../widget/custom_header_1.dart';
import '../../widget/custom_header_3.dart';
import 'detail_budget_screen.dart';

class BudgetListScreen extends StatefulWidget {
  const BudgetListScreen({Key? key}) : super(key: key);

  @override
  State<BudgetListScreen> createState() => _BudgetListScreenState();
}

class _BudgetListScreenState extends State<BudgetListScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BudgetListViewModel(),
      child: Consumer<BudgetListViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: Colors.grey[350],
            body: Column(
              children: [
                CustomHeader_3(
                  title: 'Danh sách hạn mức',
                  action: GestureDetector(
                    onTap: () {
                      setState(() {
                        viewModel.isSearching = true;
                      });
                    },
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                  isSearching: viewModel.isSearching,
                  onSearchChanged: (query) {
                    setState(() {
                      viewModel.searchQuery = query;
                      viewModel.filterBudgets(query);
                    });
                  },
                  onSearchClose: () {
                    setState(() {
                      viewModel.isSearching = false;
                      viewModel.searchQuery = '';
                      viewModel.searchController.clear();
                      viewModel.filterBudgets('');
                    });
                  },
                ),
                Expanded(
                  child: viewModel.budgets.isEmpty && viewModel.isSearching
                      ? Center(
                          child: Text(
                            'Không có kết quả tìm kiếm nào.',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                      : viewModel.budgets.isEmpty
                          ? Center(
                              child: Text(
                                'Không có hạn mức chi tiêu nào',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              itemCount: viewModel.budgets.length,
                              itemBuilder: (context, index) {
                                final budget = viewModel.budgets[index];
                                final budgetCategories = budget.categoryId
                                    .map((id) => viewModel.getCategoryById(id))
                                    .whereType<Category>()
                                    .toList();
                                final budgetWallets = budget.walletId
                                    .map((id) => viewModel.getWalletById(id))
                                    .whereType<Wallet>()
                                    .toList();

                                return FutureBuilder<double>(
                                  future: viewModel.calculateSpentAmount(
                                      budget.categoryId, budget.walletId),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    }

                                    final spentAmount = snapshot.data ?? 0.0;
                                    final progress = _calculateProgress(
                                        budget.amount, spentAmount);
                                    final daysLeft = _calculateDaysLeft(
                                        budget.startDate, budget.endDate);
                                    final amountLeft =
                                        budget.amount - spentAmount;

                                    return Dismissible(
                                      key: Key(budget.budgetId),
                                      // Replace with your budget ID
                                      direction: DismissDirection.endToStart,
                                      confirmDismiss: (direction) async {
                                        return await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Xác nhận'),
                                              content: Text(
                                                  'Bạn có muốn xóa hạn mức này không?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(false);
                                                  },
                                                  child: Text('Không',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(true);
                                                  },
                                                  child: Text('Có',
                                                      style: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      onDismissed: (direction) {
                                        viewModel.deleteBudget(budget.budgetId);
                                        CustomSnackBar_2.show(
                                            context, 'Đã xóa hạn mức');
                                      },
                                      background: Container(
                                        color: Colors.red,
                                        alignment: Alignment.centerRight,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Icon(Icons.delete,
                                            color: Colors.white),
                                      ),
                                      child: Card(
                                        margin: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          onTap: () async {
                                            final result = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailBudgetScreen(
                                                        budget: budget),
                                              ),
                                            );
                                            if (result != null) {
                                              viewModel.loadBudgets();
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Display selected categories
                                                Row(
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        for (int i =
                                                                budgetCategories
                                                                        .take(3)
                                                                        .length -
                                                                    1;
                                                            i >= 0;
                                                            i--)
                                                          Transform.translate(
                                                            offset: Offset(
                                                                i * 10.0, 0),
                                                            // Điều chỉnh mức độ chồng lấn
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right:
                                                                          2.0),
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 16,
                                                                backgroundColor:
                                                                    parseColor(
                                                                        budgetCategories[i]
                                                                            .color),
                                                                child: Icon(
                                                                  parseIcon(
                                                                      budgetCategories[
                                                                              i]
                                                                          .icon),
                                                                  color: Colors
                                                                      .white,
                                                                  size: 16,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                    SizedBox(width: 25.0),
                                                    // Khoảng cách giữa các CircleAvatar và text
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 5.0),
                                                        child: Text(
                                                          viewModel
                                                              .getCategoriesText(
                                                                  budget
                                                                      .categoryId),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                // Display selected wallets
                                                Row(
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        for (int i =
                                                                budgetWallets
                                                                        .take(3)
                                                                        .length -
                                                                    1;
                                                            i >= 0;
                                                            i--)
                                                          Transform.translate(
                                                            offset: Offset(
                                                                i * 10.0, 0),
                                                            // Điều chỉnh mức độ chồng lấn
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right:
                                                                          2.0),
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 16,
                                                                backgroundColor:
                                                                    parseColor(
                                                                        budgetWallets[i]
                                                                            .color),
                                                                child: Icon(
                                                                  parseIcon(
                                                                      budgetWallets[
                                                                              i]
                                                                          .icon),
                                                                  color: Colors
                                                                      .white,
                                                                  size: 18,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                    SizedBox(width: 25.0),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 5.0),
                                                        child: Text(
                                                          viewModel
                                                              .getWalletsText(
                                                                  budget
                                                                      .walletId),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  'Tên hạn mức: ${budget.name}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                    'Hạn mức: ${formatTotalBalance(budget.amount)} ₫',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16)),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        '${_formatDate(budget.startDate)} - ${_formatDate(budget.endDate)}'),
                                                    Text('Còn $daysLeft ngày.'),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                LinearProgressIndicator(
                                                  value: progress,
                                                  color: amountLeft < 0
                                                      ? Colors.red
                                                      : Colors.blue,
                                                ),
                                                SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      amountLeft < 0
                                                          ? 'Bội chi: ${formatTotalBalance(amountLeft.abs())} ₫'
                                                          : 'Hạn mức còn lại: ${formatTotalBalance(amountLeft)} ₫',
                                                      style: TextStyle(
                                                        color: amountLeft < 0
                                                            ? Colors.red
                                                            : Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                final newBudget = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateBudgetScreen(),
                  ),
                );
                if (newBudget != null && newBudget is Budget) {
                  await viewModel.loadBudgets();
                }
              },
              child: Icon(Icons.add, color: Colors.white),
              backgroundColor: Colors.green,
              shape: CircleBorder(),
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
}
