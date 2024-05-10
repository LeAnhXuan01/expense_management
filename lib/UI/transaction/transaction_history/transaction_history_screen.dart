import 'package:flutter/material.dart';
import '../../../data/transaction.dart';


class TransactionHistoryScreen extends StatefulWidget {
  final List<Transaction> transactions;

  TransactionHistoryScreen({required this.transactions});

  @override
  _TransactionHistoryScreenState createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String _selectedFilter = 'Tất cả';
  String _selectedSort = 'Giao dịch mới nhất';
  List<Transaction> transactions = []; // Danh sách các giao dịch

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch sử giao dịch'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Handle search action
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _showFilterModalBottomSheet(context);
            },
          ),
        ],
      ),
    );
  }

  void _showFilterModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Loại:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0, // Khoảng cách giữa các nút
                    runSpacing: 8.0, // Khoảng cách giữa các dòng
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedFilter = 'Tất cả';
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: _selectedFilter == 'Tất cả' ? MaterialStateProperty.all<Color>(Colors.blue) : null,
                        ),
                        child: Text('Tất cả'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedFilter = 'Thu';
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: _selectedFilter == 'Thu' ? MaterialStateProperty.all<Color>(Colors.blue) : null,
                        ),
                        child: Text('Thu'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedFilter = 'Chi';
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: _selectedFilter == 'Chi' ? MaterialStateProperty.all<Color>(Colors.blue) : null,
                        ),
                        child: Text('Chi'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Sắp xếp:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0, // Khoảng cách giữa các nút
                    runSpacing: 8.0, // Khoảng cách giữa các dòng
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedSort = 'Giao dịch mới nhất';
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: _selectedSort == 'Giao dịch mới nhất' ? MaterialStateProperty.all<Color>(Colors.blue) : null,
                        ),
                        child: Text('Giao dịch mới nhất'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedSort = 'Giao dịch cũ nhất';
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: _selectedSort == 'Giao dịch cũ nhất' ? MaterialStateProperty.all<Color>(Colors.blue) : null,
                        ),
                        child: Text('Giao dịch cũ nhất'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedSort = 'Giá cao nhất';
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: _selectedSort == 'Giá cao nhất' ? MaterialStateProperty.all<Color>(Colors.blue) : null,
                        ),
                        child: Text('Giá cao nhất'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedSort = 'Giá thấp nhất';
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: _selectedSort == 'Giá thấp nhất' ? MaterialStateProperty.all<Color>(Colors.blue) : null,
                        ),
                        child: Text('Giá thấp nhất'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedFilter = 'Tất cả';
                            _selectedSort = 'Giao dịch mới nhất';
                          });
                          Navigator.of(context).pop();
                        },
                        child: Text('Reset'),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Apply filter and sort
                          Navigator.of(context).pop();
                        },
                        child: Text('Áp dụng'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
