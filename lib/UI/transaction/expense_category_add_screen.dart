// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../data/category_item.dart';
// import '../../view_model/transaction/expense_category_add_view_model.dart';
// import '../../widget/custom_header.dart';
// import 'catalog_creation_screen.dart';
//
// class ExpenseCategoryAddScreen extends StatefulWidget {
//   const ExpenseCategoryAddScreen({Key? key}) : super(key: key);
//
//   @override
//   State<ExpenseCategoryAddScreen> createState() => _ExpenseCategoryAddScreenState();
// }
//
// class _ExpenseCategoryAddScreenState extends State<ExpenseCategoryAddScreen> {
//   late ExpenseCategoryAddViewModel _viewModel;
//   List<CategoryItem_2> expenseCategories = []; // Danh sách danh mục chi tiêu
//   @override
//   void initState() {
//     super.initState();
//     _viewModel = Provider.of<ExpenseCategoryAddViewModel>(context, listen: false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => ExpenseCategoryAddViewModel(),
//       child: Scaffold(
//         body: Consumer<ExpenseCategoryAddViewModel>(
//           builder: (context, viewModel, child) {
//             return Stack(
//               children: [
//                 Column(
//                   children: [
//                     CustomHeader(title: 'Thêm danh mục chi tiêu'),
//                     Expanded(
//                       child: SingleChildScrollView(
//                         child: Container(
//                           height: 750, // Adjust height according to your needs
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 10),
//                             child: GridView.builder(
//                               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: 3,
//                               ),
//                               itemCount: expenseCategories.length,
//                               itemBuilder: (BuildContext context, int index) {
//                                 final category = expenseCategories[index];
//                                 return GestureDetector(
//                                   onTap: () {
//                                     _viewModel.setSelectedCategoryIndex(index);
//                                   },
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(20),
//                                       color: _viewModel.selectedCategoryIndex == index ? iconColors[index % iconColors.length] : null,
//                                     ),
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         Container(
//                                           width: 80,
//                                           height: 80,
//                                           decoration: BoxDecoration(
//                                             shape: BoxShape.circle,
//                                             color: iconColors[index % iconColors.length],
//                                           ),
//                                           child: Icon(
//                                             category.icon,
//                                             color: Colors.white,
//                                             size: 45,
//                                           ),
//                                         ),
//                                         Text(
//                                           category.name,
//                                           textAlign: TextAlign.center,
//                                           style: TextStyle(fontSize: 14, color: _viewModel.selectedCategoryIndex == index ? Colors.white : Colors.black),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             );
//           },
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () async {
//             // Chuyển đến CreatCategoriesScreen và nhận dữ liệu khi quay lại
//             final Map<String, dynamic>? newCategoryData = await Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => CreatCategoriesScreen(),
//               ),
//             );
//             // Xử lý dữ liệu được nhận
//             if (newCategoryData != null) {
//               setState(() {
//                 // Tạo một đối tượng CategoryItem_2 từ dữ liệu nhận được
//                 CategoryItem_2 newCategory = CategoryItem_2(
//                   name: newCategoryData['name'],
//                   icon: IconData(newCategoryData['icon'], fontFamily: 'MaterialIcons'), // Chú ý: Sử dụng IconData để tạo biểu tượng từ mã codePoint
//                   color: Color(newCategoryData['color']),
//                 );
//                 // Thêm đối tượng danh mục mới vào danh sách incomeCategories
//                 incomeCategories.add(newCategory);
//               });
//             }
//           },
//           child: Icon(Icons.add),
//           backgroundColor: Colors.grey,
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//       ),
//     );
//   }
// }
//
// List<Color> iconColors = [
//   Colors.blue,
//   Colors.red,
//   Colors.green,
//   Colors.orange,
//   Colors.purple,
// ];

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/category_item.dart';

class ExpenseCategoryAddScreen extends StatefulWidget {
  final CategoryItem? category;
  const ExpenseCategoryAddScreen({super.key, this.category});

  @override
  State<ExpenseCategoryAddScreen> createState() => _ExpenseCategoryScreenState();
}

class _ExpenseCategoryScreenState extends State<ExpenseCategoryAddScreen> {
  int _selectedCategoryIndex = -1; // Không có danh mục nào được chọn ban đầu

  List<CategoryItem> categories = [];

  @override
  void initState() {
    super.initState();
    categories = List.from(expenseCategories); // Sao chép danh sách danh mục hiện có
    if (widget.category != null) {
      categories.add(widget.category!); // Thêm danh mục mới vào danh sách nếu nó không null
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Expense Categories'),
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

