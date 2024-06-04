// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import '../../data/color_data.dart';
// import '../../data/icon_data.dart';
// import '../../model/category_model.dart';
// import '../../services/category_service.dart';
// import '../../widget/custom_ElevatedButton_2.dart';
// import '../../widget/custom_header.dart';
// import 'component/catalog_color_screen.dart';
// import 'component/icon_category_screen.dart';
//
// class EditCategoryScreen extends StatefulWidget {
//   final Category category;
//
//   const EditCategoryScreen({super.key, required this.category});
//
//   @override
//   State<EditCategoryScreen> createState() => _EditCategoryScreenState();
// }
//
// class _EditCategoryScreenState extends State<EditCategoryScreen> {
//   int _selectedValue = 0; // 0: Income, 1: Expense
//   bool _showPlusButton = true;
//   IconData? selectedIcon;
//   int _selectedColorIndex = -1;
//   Color? _selectedColor;
//   final TextEditingController _nameCategory = TextEditingController();
//
//   bool get isEmptyName => _nameCategory.text.isEmpty;
//
//   bool get isEmptyIcon => selectedIcon == null;
//
//   bool get isEmptyColor => _selectedColor == null;
//
//   bool showErrorName = false;
//   bool showErrorIcon = false;
//   bool showErrorColor = false;
//
//   List<IconData> _incomeIcons = incomeIcons;
//   List<IconData> _expenseIcons = expenseIcons;
//   List<Color> _colors = colors;
//
//   List<IconData> get _currentIconsList =>
//       _selectedValue == 0 ? _incomeIcons : _expenseIcons;
//
//   @override
//   void initState() {
//     super.initState();
//     _nameCategory.text = widget.category.name!;
//     selectedIcon = IconData(int.parse(widget.category.icon!),
//         fontFamily: 'FontAwesomeSolid', fontPackage: 'font_awesome_flutter');
//     _selectedColor = Color(int.parse(widget.category.color!));
//     _selectedColorIndex = _colors.indexOf(_selectedColor!);
//     _selectedValue = widget.category.type == 'income' ? 0 : 1;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           CustomHeader(title: 'Chỉnh sửa danh mục'),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Stack(
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.only(left: 70),
//                           child: TextField(
//                             onChanged: (value) {
//                               setState(() {
//                                 showErrorName = false;
//                               });
//                             },
//                             controller: _nameCategory,
//                             decoration: InputDecoration(
//                               labelText: 'Tên danh mục',
//                               errorText:
//                                   showErrorName ? 'Nhập tên danh mục' : null,
//                             ),
//                           ),
//                         ),
//                         if (selectedIcon != null)
//                           Positioned(
//                             left: 2.0,
//                             top: 13.0,
//                             child: Container(
//                               width: 50,
//                               height: 50,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color:
//                                     _selectedColor ?? Colors.blueGrey.shade200,
//                               ),
//                               child: Icon(
//                                 selectedIcon,
//                                 color: Colors.white,
//                                 size: 24,
//                               ),
//                             ),
//                           ),
//                         if (selectedIcon == null)
//                           Positioned(
//                             left: 2.0,
//                             top: 13.0,
//                             child: Container(
//                               width: 50,
//                               height: 50,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color:
//                                     _selectedColor ?? Colors.blueGrey.shade200,
//                               ),
//                               child: Icon(
//                                 FontAwesomeIcons.plus,
//                                 color: Colors.white,
//                                 size: 24,
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     // Xóa phần radio button và thay thế bằng tên loại danh mục
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Loại danh mục:',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.black.withOpacity(0.7),
//                           ),
//                         ),
//                         SizedBox(width: 10),
//                         Text(
//                           widget.category.type == 'income'
//                               ? 'Thu nhập'
//                               : 'Chi tiêu',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.black.withOpacity(0.7),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     Row(
//                       children: [
//                         Text(
//                           'Biểu tượng',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.black.withOpacity(0.7),
//                           ),
//                         ),
//                         SizedBox(width: 10),
//                         if (isEmptyIcon && showErrorIcon)
//                           Text(
//                             'Chọn một biểu tượng danh mục',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.red,
//                             ),
//                           ),
//                       ],
//                     ),
//                     GridView.builder(
//                       shrinkWrap: true,
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 3,
//                         mainAxisSpacing: 30,
//                         crossAxisSpacing: 30,
//                         childAspectRatio: 1,
//                       ),
//                       itemCount:
//                           _currentIconsList.length + (_showPlusButton ? 1 : 0),
//                       itemBuilder: (BuildContext context, int index) {
//                         if (index == _currentIconsList.length &&
//                             _showPlusButton) {
//                           return GestureDetector(
//                             onTap: () async {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute<IconData?>(
//                                   builder: (context) => IconCategoryScreen(),
//                                 ),
//                               ).then((selectedIcon) {
//                                 if (selectedIcon != null) {
//                                   setState(() {
//                                     this.selectedIcon = selectedIcon;
//                                   });
//                                 }
//                               });
//                             },
//                             child: Padding(
//                               padding: const EdgeInsets.all(20.0),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: Colors.yellow,
//                                 ),
//                                 child: Icon(
//                                   FontAwesomeIcons.ellipsis,
//                                   color: Colors.white,
//                                   size: 30,
//                                 ),
//                               ),
//                             ),
//                           );
//                         } else {
//                           return GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 selectedIcon = _currentIconsList[index];
//                               });
//                             },
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 border: selectedIcon == _currentIconsList[index]
//                                     ? Border.all(
//                                         color: Colors.black, width: 1.0)
//                                     : null,
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color:
//                                         selectedIcon == _currentIconsList[index]
//                                             ? (_selectedColor ??
//                                                 Colors.blueGrey.shade200)
//                                             : Colors.blueGrey.shade200,
//                                   ),
//                                   child: Icon(
//                                     _currentIconsList[index],
//                                     size: 45,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         }
//                       },
//                     ),
//                     SizedBox(height: 40),
//                     Row(
//                       children: [
//                         Text(
//                           'Màu sắc',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.black.withOpacity(0.7),
//                           ),
//                         ),
//                         SizedBox(width: 10),
//                         if (isEmptyColor && showErrorColor)
//                           Text(
//                             'Chọn màu danh mục',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.red,
//                             ),
//                           ),
//                       ],
//                     ),
//                     SizedBox(height: 10),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Container(
//                             height: 50,
//                             child: ListView.builder(
//                               scrollDirection: Axis.horizontal,
//                               itemCount: _colors.length,
//                               itemBuilder: (BuildContext context, int index) {
//                                 return GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       _selectedColorIndex = index;
//                                       _selectedColor = _colors[index];
//                                     });
//                                   },
//                                   child: Container(
//                                     margin: EdgeInsets.only(right: 15),
//                                     width: 40,
//                                     decoration: BoxDecoration(
//                                       color: _colors[index],
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: _selectedColorIndex == index
//                                         ? Icon(Icons.check,
//                                             color: Colors.white, size: 24)
//                                         : null,
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () async {
//                             final selectedColor =
//                                 await Navigator.of(context).push<Color?>(
//                               MaterialPageRoute(
//                                 builder: (context) => CatalogColorScreen(
//                                     colors: _colors,
//                                     initialColor: _selectedColor),
//                               ),
//                             );
//                             if (selectedColor != null) {
//                               setState(() {
//                                 _selectedColorIndex =
//                                     _colors.indexOf(selectedColor);
//                                 _selectedColor = selectedColor;
//                               });
//                             }
//                           },
//                           child: Container(
//                             width: 40,
//                             height: 40,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.blueGrey.shade200,
//                             ),
//                             child: Icon(
//                               Icons.add,
//                               color: Colors.white,
//                               size: 30,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 30),
//                     CustomElevatedButton_2(
//                       text: 'Lưu',
//                       onPressed: () async {
//                         if (!isEmptyName && !isEmptyIcon && !isEmptyColor) {
//                           Category updatedCategory = Category(
//                             id: widget.category.id,
//                             name: _nameCategory.text,
//                             icon: selectedIcon!.codePoint.toString(),
//                             color: _selectedColor!.value.toString(),
//                             type: _selectedValue == 0 ? 'income' : 'expense',
//                           );
//                           await CategoryService()
//                               .updateCategory(updatedCategory);
//                           Navigator.pop(context, updatedCategory);
//                         } else {
//                           setState(() {
//                             showErrorName = isEmptyName;
//                             showErrorIcon = isEmptyIcon;
//                             showErrorColor = isEmptyColor;
//                           });
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
