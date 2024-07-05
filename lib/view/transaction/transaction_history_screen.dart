import 'package:expense_management/model/enum.dart';
import 'package:expense_management/widget/custom_header_5.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/transaction_model.dart';
import '../../utils/utils.dart';
import '../../view_model/transaction/transaction_history_view_model.dart';
import '../../view_model/wallet/wallet_view_model.dart';
import '../../widget/custom_ElevatedButton_2.dart';
import '../../widget/custom_snackbar_2.dart';
import 'edit_transaction_screen.dart';

class TransactionHistoryScreen extends StatefulWidget {
  @override
  _TransactionHistoryScreenState createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TransactionHistoryViewModel(),
      child: Consumer<TransactionHistoryViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            endDrawer: _buildFilterDrawer(context, viewModel),
            body: Column(
              children: [
                CustomHeader_5(
                  title: 'Lịch sử giao dịch',
                  filterAction: Builder(
                    builder: (context) => IconButton(
                      icon: Icon(Icons.filter_list, color: Colors.white),
                      onPressed: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                    ),
                  ),
                  searchAction: IconButton(
                    icon: Icon(Icons.search, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        viewModel.isSearching = true;
                      });
                    },
                  ),
                  isSearching: viewModel.isSearching,
                  onSearchChanged: (query) {
                    viewModel.searchTransactions(query);
                  },
                  onSearchClose: () {
                    viewModel.isSearching = false;
                    viewModel.clearSearch();
                  },
                ),
                Expanded(
                  child: _buildTransactionList(viewModel),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTransactionList(TransactionHistoryViewModel viewModel) {
    if (viewModel.transactions.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (viewModel.filteredTransactions.isEmpty) {
      return Center(
        child: Text('Không có kết quả phù hợp với bộ lọc.'),
      );
    }
    return ListView.builder(
      itemCount: viewModel.groupedTransactions.length,
      itemBuilder: (context, index) {
        String date = viewModel.groupedTransactions.keys.elementAt(index);
        List<Transactions> transactions =
        viewModel.groupedTransactions[date]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                date,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...transactions.map((transaction) {
              final wallet = viewModel.getWalletByTransaction(transaction);
              final category = viewModel.getCategoryByTransaction(transaction);

              String walletName = 'Không có ví';

              if (wallet != null) {
                walletName = wallet.name;
              }

              String categoryName = 'Không có danh mục';
              IconData categoryIcon = Icons.category;
              Color categoryColor = Colors.grey;

              if (category != null) {
                categoryName = category.name;
                categoryIcon = parseIcon(category.icon);
                categoryColor = parseColor(category.color);
              }

              final formattedAmount =
              formatAmount(transaction.amount, transaction.currency);
              final formattedTime = formatHour(transaction.hour);
              final note = transaction.note;

              return Dismissible(
                key: Key(transaction.transactionId),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) async {
                  final walletViewModel =
                  Provider.of<WalletViewModel>(context, listen: false);
                  await viewModel.deleteTransaction(
                      transaction.transactionId, walletViewModel);
                  CustomSnackBar_2.show(
                    context,
                    'Đã xóa giao dịch',
                  );
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                child: Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 22,
                      backgroundColor: categoryColor,
                      child: Icon(
                        categoryIcon,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${categoryName}',
                          style: TextStyle(fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5),
                        Text(
                          '(${walletName})',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (note.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              note,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                          ),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Text(formattedTime),
                        if (transaction.images.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Icon(Icons.image,
                                size: 16, color: Colors.grey[700]),
                          ),
                      ],
                    ),
                    trailing: Text(
                      '${formatAmount_2(transaction.amount, transaction.currency)} ${transaction.currency == Currency.VND ? '₫' : '\$'}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: transaction.type == TransactionType.income
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditTransactionScreen(transaction: transaction),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          viewModel.loadTransactions();
                        });
                      }
                    },
                  ),
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }

  Widget _buildFilterDrawer(
      BuildContext context, TransactionHistoryViewModel viewModel) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Text(
              'Bộ lọc tìm kiếm:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Divider(),
            ListTile(
              title: Text('Khoảng thời gian'),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                DateTimeRange? picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                  initialDateRange: viewModel.selectedDateRange,
                );
                if (picked != null) {
                  viewModel.filterByDateRange(picked);
                  Navigator.of(context).pop();
                }
              },
            ),
            ListTile(
              title: Text('Ví'),
              trailing: Icon(Icons.account_balance_wallet),
              onTap: () async {
                await showDialog<String>(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: Center(child: Text('Chọn ví')),
                      children: viewModel.walletMap.entries.map((entry) {
                        final wallet = entry.value;
                        final isSelected =
                            entry.key == viewModel.selectedWalletId;
                        return SimpleDialogOption(
                          onPressed: () {
                            Navigator.pop(
                                context, entry.key); // Select wallet
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: parseColor(wallet.color),
                              child: Icon(
                                parseIcon(wallet.icon),
                                color: Colors.white,
                              ),
                            ),
                            title: Text(wallet.name),
                            trailing: isSelected
                                ? Icon(Icons.check, color: Colors.green)
                                : null,
                          ),
                        );
                      }).toList(),
                    );
                  },
                ).then((selectedWalletId) {
                  if (selectedWalletId != null) {
                    viewModel.filterByWallet(selectedWalletId);
                  }
                });
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text('Loại'),
              trailing: DropdownButton<String>(
                value: viewModel.selectedTypeFilter,
                items: [
                  DropdownMenuItem(
                    value: 'Tất cả',
                    child: Text('Tất cả'),
                  ),
                  DropdownMenuItem(
                    value: 'Thu nhập',
                    child: Text('Thu nhập'),
                  ),
                  DropdownMenuItem(
                    value: 'Chi tiêu',
                    child: Text('Chi tiêu'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    viewModel.filterByType(value);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
            // ListTile(
            //   title: Text('Sắp xếp'),
            //   trailing: DropdownButton<String>(
            //     value: viewModel.currentSortCriteria,
            //     items: [
            //       DropdownMenuItem(
            //         value: 'date',
            //         child: Text('Theo ngày'),
            //       ),
            //       DropdownMenuItem(
            //         value: 'amount',
            //         child: Text('Theo số tiền'),
            //       ),
            //     ],
            //     onChanged: (value) {
            //       if (value != null) {
            //         viewModel.setCurrentSortCriteria(value);
            //         if (value == 'date') {
            //           viewModel.sortTransactionsByDate();
            //         } else if (value == 'amount') {
            //           viewModel.sortTransactionsByAmount();
            //         }
            //         Navigator.of(context).pop();
            //       }
            //     },
            //   ),
            // ),
            CustomElevatedButton_2(
              text: 'Xóa bộ lọc',
              onPressed: () {
                viewModel.clearFilters();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
