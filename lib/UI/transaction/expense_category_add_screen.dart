// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import '../../model/category_model.dart';
// import '../../services/category_service.dart';
// import 'catalog_creation_screen.dart';
// import 'edit_category_screen.dart';
//
// class ExpenseCategoryAddScreen extends StatefulWidget {
//   final Category? category;
//   const ExpenseCategoryAddScreen({super.key, this.category});
//
//   @override
//   State<ExpenseCategoryAddScreen> createState() => _ExpenseCategoryAddScreenState();
// }
//
// class _ExpenseCategoryAddScreenState extends State<ExpenseCategoryAddScreen> {
//   late List<Category> categories = [];
//   int _selectedCategoryIndex = -1;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchCategories();
//   }
//
//   void _fetchCategories() async {
//     final fetchedCategories = await CategoryService().getExpenseCategories();
//     setState(() {
//       categories = fetchedCategories;
//     });
//   }
//
//   void _selectCategory(Category selectedCategory) {
//     Navigator.pop(context, selectedCategory);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Danh mục chi tiêu'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: GridView.builder(
//           itemCount: categories.length,
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 3,
//           ),
//           itemBuilder: (context, index) {
//             final category = categories[index];
//             return GestureDetector(
//               onTap: () {
//                 setState(() {
//                   _selectedCategoryIndex = index;
//                 });
//                 _selectCategory(category);
//               },
//               onLongPress: () {
//                 _showOptionsDialog(context, category);
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: _selectedCategoryIndex == index ? Color(int.parse(category.color!)) : null,
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       width: 65,
//                       height: 65,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Color(int.parse(category.color!)),
//                       ),
//                       child: Icon(
//                         IconData(
//                           int.parse(category.icon!),
//                           fontFamily: 'FontAwesomeSolid', // Đảm bảo fontFamily phù hợp với FontAwesome
//                           fontPackage: 'font_awesome_flutter',
//                         ), // Chuyển đổi mã điểm thành IconData
//                         color: Colors.white,
//                         size: 40,
//                       ),
//                     ),
//                     const SizedBox(height: 3),
//                     Text(
//                       category.name!,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: _selectedCategoryIndex == index ? Colors.white : Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           final newCategory = await Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => CreatCategoriesScreen(initialSelectedValue: 1), // Pass initial value 1 for "Expense"
//             ),
//           );
//           if (newCategory != null && newCategory is Category) {
//             setState(() {
//               categories.add(newCategory);
//             });
//           }
//         },
//         child: const Icon(FontAwesomeIcons.plus),
//       ),
//
//     );
//   }
//
//   void _showOptionsDialog(BuildContext context, Category category) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Lựa chọn cho: ${category.name}'),
//           actions: [
//             Row(
//               children: [
//                 Expanded(
//                   flex: 1,
//                   child: Container(
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: Colors.grey.shade300,
//                         border: Border.all(color: Colors.deepPurpleAccent)),
//                     child: TextButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                         _editCategory(category);
//                       },
//                       child: Text(
//                         'Sửa',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.w500,
//                           fontSize: 18,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   flex: 1,
//                   child: Container(
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: Colors.grey.shade300,
//                         border: Border.all(color: Colors.deepPurpleAccent)),
//                     child: TextButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                         _deleteCategory(category);
//                       },
//                       child: const Text(
//                         'Xóa',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.w500,
//                           fontSize: 18,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         );
//       },
//     );
//   }
//
// void _editCategory(Category category) async {
//   final editedCategory = await Navigator.push<Category>(
//     context,
//     MaterialPageRoute(
//       builder: (context) => EditCategoryScreen(category: category),
//     ),
//   );
//
//   if (editedCategory != null) {
//     setState(() {
//       final index = categories.indexWhere((c) => c.id == editedCategory.id);
//       if (index != -1) {
//         categories[index] = editedCategory;
//       }
//     });
//   }
// }
//
//   void _deleteCategory(Category category) async {
//     final rowsAffected = await CategoryService().deleteCategory(category.id!);
//     if (rowsAffected > 0) {
//       setState(() {
//         categories.removeWhere((c) => c.id == category.id);
//       });
//     }
//   }
//
// }
