import 'package:flutter/material.dart';

class CategoryListScreen extends StatefulWidget {
  @override
  _CategoryListScreenState createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý Danh mục'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Thu nhập'),
            Tab(text: 'Chi'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab thu nhập
          Container(
            child: Center(
              child: Text('Danh sách danh mục thu nhập'),
            ),
          ),
          // Tab chi
          Container(
            child: Center(
              child: Text('Danh sách danh mục chi'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Xử lý khi nhấn nút Floating Action Button
          // Điều hướng đến màn hình thêm danh mục
        },
        child: Icon(Icons.add),
      ),
    );
  }
}