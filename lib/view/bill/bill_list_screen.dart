import 'package:expense_management/view/bill/create_bill_screen.dart';
import 'package:expense_management/widget/custom_snackbar_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/bill_model.dart';
import '../../view_model/bill/bill_list_view_model.dart';
import '../../widget/custom_header_3.dart';
import 'edit_bill_screen.dart';

class BillListScreen extends StatefulWidget {
  @override
  State<BillListScreen> createState() => _BillListScreenState();
}

class _BillListScreenState extends State<BillListScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BillListViewModel(),
      child: Consumer<BillListViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: Column(
              children: [
                CustomHeader_3(
                  title: 'Danh sách hóa đơn',
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
                      viewModel.filterBills(query);
                    });
                  },
                  onSearchClose: () {
                    setState(() {
                      viewModel.isSearching = false;
                      viewModel.clearSearch();
                    });
                  },
                ),
                Expanded(
                  child: _buildBillList(viewModel),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.green,
              shape: CircleBorder(),
              child: Icon(Icons.add, color: Colors.white),
              onPressed: () async {
                final newBill = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateBillScreen(),
                  ),
                );
                if (newBill != null && newBill is Bill) {
                  await viewModel.loadBills();
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildBillList(BillListViewModel viewModel) {
    if (viewModel.bills.isEmpty && viewModel.isSearching) {
      return Center(
        child: Text('Không có kết quả tìm kiếm nào',
            style: TextStyle(fontSize: 18, color: Colors.grey)),
      );
    } else if (viewModel.bills.isEmpty) {
      return Center(
        child: Text(
          'Không có hóa đơn nào',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: viewModel.bills.length,
      itemBuilder: (context, index) {
        Bill bill = viewModel.bills[index];
        return Dismissible(
          key: Key(bill.billId),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            viewModel.deleteBill(bill.billId);
            CustomSnackBar_2.show(
                context, '${bill.name} đã bị xóa');
          },
          confirmDismiss: (direction) async {
            return await _showDeleteConfirmationDialog(context);
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Tùy chỉnh khoảng cách giữa các thẻ
            elevation: 4.0,
            child: ListTile(
              title: Text(bill.name),
              trailing: Switch(
                value: bill.isActive,
                onChanged: (value) {
                  bill.isActive = value;
                  viewModel.updateActiveBill(bill);
                },
              ),
              onTap: () async {
                final updateBill = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditBillScreen(bill: bill),
                  ),
                );
                if (updateBill != null && updateBill is Bill) {
                  await viewModel.loadBills();
                }
              },
            ),
          ),
        );
      },
    );
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận'),
          content: Text('Bạn có chắc chắn muốn xóa hóa đơn này không?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
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
                Navigator.of(context).pop(true);
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
  }
}
