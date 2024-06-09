import 'package:flutter/material.dart';

class CategoryListTab extends StatelessWidget {
  final String title;

  const CategoryListTab({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Thay thế với danh sách thực tế hoặc danh sách mẫu
    List<String> categories = ['Danh mục 1', 'Danh mục 2', 'Danh mục 3'];

    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(categories[index]),
          onTap: () {
            // Xử lý khi nhấn vào danh mục
          },
        );
      },
    );
  }
}
