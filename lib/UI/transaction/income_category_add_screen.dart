import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import thư viện cloud_firestore
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/category_item.dart';

class IncomeCategoryAddScreen extends StatefulWidget {
  @override
  State<IncomeCategoryAddScreen> createState() => _IncomeCategoryAddScreenState();
}

class _IncomeCategoryAddScreenState extends State<IncomeCategoryAddScreen> {
  int _selectedCategoryIndex = -1;
  List<CategoryItem> categories = []; // Danh sách danh mục hiện tại

  @override
  void initState() {
    super.initState();
    // Gọi hàm để lấy danh sách danh mục từ Cloud Firestore
    _fetchCategories();
  }

  // Hàm để lấy danh sách danh mục từ Cloud Firestore
  void _fetchCategories() async {
    // Tham chiếu đến collection "categories" trong Cloud Firestore
    var snapshot = await FirebaseFirestore.instance.collection('categories').get();
    // Xử lý kết quả trả về
    setState(() {
      // Chuyển đổi dữ liệu từ snapshot thành danh sách các đối tượng CategoryItem
      categories = snapshot.docs.map((doc) => CategoryItem.fromMap(doc.data())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Income Categories'),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
            itemCount: categories.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Số lượng cột trong GridView
            ),
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategoryIndex = index;
                  });
                  // Xử lý khi chọn danh mục
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: _selectedCategoryIndex == index ? category.color : null, // Đặt màu nền của container tùy thuộc vào danh mục có được chọn hay không
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: category.color,
                        ),
                        child: Icon(
                          IconData(int.parse(category.icon), fontFamily: 'FontAwesome'), // Chuyển đổi icon từ mã sang IconData
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        category.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: _selectedCategoryIndex == index ? Colors.white : Colors.black),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to Create Categories screen
            Navigator.pushNamed(context, '/creat-categories');
          },
          child: Icon(FontAwesomeIcons.plus),
        )
    );
  }
}
