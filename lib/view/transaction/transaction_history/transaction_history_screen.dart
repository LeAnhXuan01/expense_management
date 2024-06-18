import 'package:expense_management/widget/custom_header_2.dart';
import 'package:flutter/material.dart';
import '../../../model/transaction_model.dart';

class TransactionHistoryScreen extends StatefulWidget {
  final List<Transaction> transactions;

  TransactionHistoryScreen({required this.transactions});

  @override
  _TransactionHistoryScreenState createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String? _selectedFilter;
  String? _selectedSort;
  bool _hasInteracted = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: _buildFilterDrawer(context),
      body: Column(
        children: [
          CustomHeader_2(
            rightAction: IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
                // Handle search action
              },
            ),
            title: 'Lịch sử giao dịch',
            leftAction: IconButton(
              icon: Icon(Icons.filter_list, color: Colors.white),
              onPressed: () {
                _scaffoldKey.currentState?.openEndDrawer();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDrawer(BuildContext context) {
    return Drawer(
      width: 350,
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
            Text(
              'Loại:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                _buildFilterButton('Tất cả'),
                _buildFilterButton('Thu'),
                _buildFilterButton('Chi'),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Sắp xếp:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                _buildSortButton('Giao dịch mới nhất'),
                _buildSortButton('Giao dịch cũ nhất'),
                _buildSortButton('Giá cao nhất'),
                _buildSortButton('Giá thấp nhất'),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: _hasInteracted
                        ? () {
                            setState(() {
                              _selectedFilter = null;
                              _selectedSort = null;
                              _hasInteracted = false;
                            });
                          }
                        : null,
                    child: Text(
                      'Thiết lập lại',
                      style: TextStyle(
                          color: _hasInteracted == true
                              ? Colors.white
                              : Colors.black54),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: _hasInteracted
                        ? () {
                            // Áp dụng bộ lọc và sắp xếp
                            Navigator.of(context).pop();
                          }
                        : null,
                    child: Text(
                      'Áp dụng',
                      style: TextStyle(
                          color: _hasInteracted == true
                              ? Colors.white
                              : Colors.black54),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String filter) {
    bool isSelected = _selectedFilter == filter;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = filter;
          _hasInteracted = true;
        });
      },
      child: Container(
        width: 150,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? Border.all(color: Colors.red) : null,
        ),
        child: Center(
          child: Text(
            filter,
            style: TextStyle(
              color: isSelected ? Colors.red : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSortButton(String sort) {
    bool isSelected = _selectedSort == sort;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSort = sort;
          _hasInteracted = true;
        });
      },
      child: Container(
        width: 150,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? Border.all(color: Colors.red) : null,
        ),
        child: Center(
          child: Text(
            sort,
            style: TextStyle(
              color: isSelected ? Colors.red : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
