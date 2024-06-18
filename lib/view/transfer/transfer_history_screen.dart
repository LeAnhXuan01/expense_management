import 'package:expense_management/view_model/wallet/wallet_view_model.dart';
import 'package:expense_management/widget/custom_ElevatedButton_2.dart';
import 'package:expense_management/widget/custom_header_1.dart';
import 'package:expense_management/widget/custom_snackbar_2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../model/transfer_model.dart';
import '../../utils/utils.dart';
import '../../view_model/transfer/transfer_history_view_model.dart';
import 'edit_transfer_screen.dart';

class TransferHistoryScreen extends StatefulWidget {
  @override
  _TransferHistoryScreenState createState() => _TransferHistoryScreenState();
}

class _TransferHistoryScreenState extends State<TransferHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TransferHistoryViewModel(),
      child: Scaffold(
        drawer: _buildFilterDrawer(context),
        body: Column(
          children: [
            CustomHeader_1(
              title: 'Lịch sử chuyển khoản',
              action: Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.filter_list, color: Colors.white),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
            ),
            Expanded(
              child: Consumer<TransferHistoryViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.transfers.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (viewModel.groupedTransfers.isEmpty) {
                    return Center(
                      child: Text('Không có kết quả phù hợp với bộ lọc.'),
                    );
                  }
                  return ListView.builder(
                    itemCount: viewModel.groupedTransfers.length,
                    itemBuilder: (context, index) {
                      String date =
                          viewModel.groupedTransfers.keys.elementAt(index);
                      List<Transfer> transfers =
                          viewModel.groupedTransfers[date]!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              date,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ...transfers.map((transfer) {
                            final fromWalletName =
                                viewModel.getWalletName(transfer.fromWallet);
                            final toWalletName =
                                viewModel.getWalletName(transfer.toWallet);
                            final formattedAmount = formatAmountTransfer(
                                transfer.amount, transfer.currency);
                            final formattedTime =
                                viewModel.formatHour(transfer.hour);

                            final fromWalletIcon =
                                viewModel.getWalletIcon(transfer.fromWallet);
                            final toWalletIcon =
                                viewModel.getWalletIcon(transfer.toWallet);
                            final fromWalletColor =
                                viewModel.getWalletColor(transfer.fromWallet);
                            final toWalletColor =
                                viewModel.getWalletColor(transfer.toWallet);

                            return Dismissible(
                              key: Key(transfer.transferId),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) async {
                                final walletViewModel = Provider.of<WalletViewModel>(context, listen: false);
                                await viewModel
                                    .deleteTransfer(transfer.transferId, walletViewModel);
                                CustomSnackBar_2.show(
                                    context,
                                    'Đã xóa giao dịch',
                                  actionLabel: 'Hoàn tác',
                                  onActionPressed: () async {
                                    await viewModel.restoreTransfer();
                                  },
                                  duration: Duration(seconds: 3),
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
                                  leading: Column(
                                    children: [
                                      Icon(FontAwesomeIcons.downLong, color: Colors.green,),
                                    ],
                                  ),
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 18,
                                            backgroundColor: fromWalletColor,
                                            child: Icon(
                                              fromWalletIcon,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Flexible(
                                            child: Text(
                                              '$fromWalletName',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 18,
                                            backgroundColor: toWalletColor,
                                            child: Icon(
                                              toWalletIcon,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Flexible(
                                            child: Text(
                                              '$toWalletName',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(formattedTime),
                                  ),
                                  trailing: Text('$formattedAmount ₫',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)
                                  ),
                                  onTap: () async {
                                    final updatedTransfer = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditTransferScreen(transfer: transfer),
                                      ),
                                    );
                                    if (updatedTransfer != null && updatedTransfer is Transfer) {
                                      await viewModel.loadTransfers();
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterDrawer(BuildContext context) {
    return Consumer<TransferHistoryViewModel>(
      builder: (context, viewModel, child) {
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
                // ListTile(
                //   title: Text('Xóa bộ lọc'),
                //   trailing: Icon(Icons.clear),
                //   onTap: () {
                //     viewModel.clearFilters();
                //     Navigator.of(context).pop();
                //   },
                // ),
                CustomElevatedButton_2(
                  text: 'Xóa bộ lọc',
                  onPressed: () {
                    viewModel.clearFilters();
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
