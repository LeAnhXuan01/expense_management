import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'creat_transfer_screen.dart';

class TransferHistoryScreen extends StatefulWidget {
  @override
  _TransferHistoryScreenState createState() => _TransferHistoryScreenState();
}

class _TransferHistoryScreenState extends State<TransferHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lịch sử chuyển khoản')),
      body: Center(
        child: Text('Lịch sử chuyển khoản sẽ hiển thị ở đây.'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateTransferScreen()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}