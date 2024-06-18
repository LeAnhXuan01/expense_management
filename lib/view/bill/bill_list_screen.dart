import 'package:expense_management/widget/custom_header_1.dart';
import 'package:flutter/material.dart';

class BillListScreen extends StatefulWidget {
  @override
  _BillListScreenState createState() => _BillListScreenState();
}

class _BillListScreenState extends State<BillListScreen> {
  Future<void> _showDeleteAllConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận xóa'),
          content: Text('Bạn có chắc chắn muốn xóa tất cả các nhắc nhở không?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  void _showNoRemindersToDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Không có nhắc nhở'),
          content: Text('Không có nhắc nhở nào để xóa.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomHeader_1(
            title: 'Danh sách hóa đơn',
            action: IconButton(
              icon: Icon(Icons.delete, color: Colors.white),
              onPressed: () {
                _showDeleteAllConfirmationDialog(context);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.of(context).pushNamed('/creat-bill');
        },
      ),
    );
  }
}
