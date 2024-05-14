import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/category_item.dart';

class IncomeCategoryAddScreen extends StatefulWidget {
  final CategoryItem? category;
  const IncomeCategoryAddScreen({super.key, this.category});

  @override
  State<IncomeCategoryAddScreen> createState() => _IncomeCategoryAddScreenState();
}

class _IncomeCategoryAddScreenState extends State<IncomeCategoryAddScreen> {
  int _selectedCategoryIndex = -1;
  List<CategoryItem> categories = [];

  @override
  void initState() {
    super.initState();
    categories = List.from(incomeCategories); // Sử dụng bản sao của danh sách danh mục ban đầu
    if (widget.category != null) {
      categories.add(widget.category!); // Thêm danh mục mới vào danh sách nếu nó không null
    }
  }

  // void _selectCategory(CategoryItem_2 selectedCategory) {
  //   if (isCategoryExist(selectedCategory)) {
  //     Navigator.pop(context, selectedCategory);
  //   } else {
  //     Navigator.pop(context, null); // Tránh thêm danh mục vào danh sách của màn hình IncomeCategoryAddScreen
  //     Navigator.pop(context, selectedCategory); // Chuyển dữ liệu về màn hình AddTransactionScreen
  //   }
  // }
  void _selectCategory(CategoryItem selectedCategory) {
    if (isCategoryExist(selectedCategory)) {
      // Nếu danh mục đã tồn tại, chỉ đơn giản pop màn hình và trả về danh mục đã chọn
      Navigator.pop(context, selectedCategory);
    } else {
      // Nếu danh mục chưa tồn tại, thêm vào danh sách và sau đó pop màn hình
      categories.add(selectedCategory);
      Navigator.pop(context, selectedCategory);
    }
    // Gọi setState để cập nhật lại giao diện với việc chọn danh mục mới
    setState(() {
      _selectedCategoryIndex = categories.indexOf(selectedCategory);
    });
  }


  bool isCategoryExist(CategoryItem category) {
    for (CategoryItem existingCategory in categories) {
      if (existingCategory.name == category.name) {
        return true;
      }
    }
    return false;
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
                  _selectCategory(category); // Chọn danh mục và xử lý
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
                          category.icon,
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