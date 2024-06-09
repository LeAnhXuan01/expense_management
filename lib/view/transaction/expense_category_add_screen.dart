import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../model/category_model.dart';
import 'creat_categories_screen.dart';

class ExpenseCategoryAddScreen extends StatefulWidget {
  final Category? category;
  const ExpenseCategoryAddScreen({super.key, this.category});

  @override
  State<ExpenseCategoryAddScreen> createState() => _ExpenseCategoryAddScreenState();
}

class _ExpenseCategoryAddScreenState extends State<ExpenseCategoryAddScreen> {
  late List<Category> categories = [];
  int _selectedCategoryIndex = -1;

  void _selectCategory(Category selectedCategory) {
    Navigator.pop(context, selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh mục chi tiêu'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategoryIndex = index;
                });
                _selectCategory(category);
              },
              onLongPress: () {
                _showOptionsDialog(context, category);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: _selectedCategoryIndex == index ? Color(int.parse(category.color!)) : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(int.parse(category.color!)),
                      ),
                      child: Icon(
                        IconData(
                          int.parse(category.icon!),
                          fontFamily: 'FontAwesomeSolid', // Đảm bảo fontFamily phù hợp với FontAwesome
                          fontPackage: 'font_awesome_flutter',
                        ), // Chuyển đổi mã điểm thành IconData
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      category.name!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: _selectedCategoryIndex == index ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () async {
          final newCategory = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatCategoriesScreen(initialSelectedValue: 1), // Pass initial value 1 for "Expense"
            ),
          );
          if (newCategory != null && newCategory is Category) {
            setState(() {
              categories.add(newCategory);
            });
          }
        },
        child: const Icon(FontAwesomeIcons.plus, color: Colors.white,),
      ),

    );
  }

  void _showOptionsDialog(BuildContext context, Category category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Lựa chọn cho: ${category.name}'),
          actions: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade300,
                        border: Border.all(color: Colors.deepPurpleAccent)),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Sửa',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade300,
                        border: Border.all(color: Colors.deepPurpleAccent)),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Xóa',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

}
