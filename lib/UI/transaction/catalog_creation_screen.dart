// import 'package:expense_management/widget/custom_ElevatedButton_2.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import '../../data/category_item.dart';
// import '../../widget/custom_header.dart';
// import 'component/catalog_color_screen.dart';
// import 'component/icon_category_screen.dart';
// import 'expense_category_add_screen.dart';
// import 'income_category_add_screen.dart';
//
//
// class CreatCategoriesScreen extends StatefulWidget {
//   const CreatCategoriesScreen({super.key});
//
//   @override
//   State<CreatCategoriesScreen> createState() => _CreatCategoriesState();
// }
//
// class _CreatCategoriesState extends State<CreatCategoriesScreen> {
//   int _selectedValue = 0; // 0: Thu, 1: Chi
//   bool _showPlusButton = true;
//   // Biến để theo dõi xem một biểu tượng có được chọn hay không
//   IconData? selectedIcon;
//   int _selectedColorIndex = -1; // Biến để lưu chỉ một index của màu đang được chọn
//   Color? _selectedColor; // Biến để lưu màu được chọn
//   bool _isButtonEnabled = false; // Biến để kiểm tra xem nút "Lưu" có được kích hoạt hay không
//   final TextEditingController _nameCategory = TextEditingController();
//
//   bool get isEmptyName => _nameCategory.text.isEmpty;
//   bool get isEmptyIcon => selectedIcon == null;
//   bool get isEmptyColor => _selectedColor == null;
//
//   bool showErrorName = false;
//   bool showErrorIcon = false;
//   bool showErrorColor = false;
//
//   final List<IconData> _incomeIcons = [
//     FontAwesomeIcons.moneyBillAlt,
//     FontAwesomeIcons.wallet,
//     FontAwesomeIcons.coins,
//     FontAwesomeIcons.bank,
//     FontAwesomeIcons.donate,
//   ];
//
//   final List<IconData> _expenseIcons = [
//     FontAwesomeIcons.shoppingCart,
//     FontAwesomeIcons.home,
//     FontAwesomeIcons.car,
//     FontAwesomeIcons.utensils,
//     FontAwesomeIcons.medkit,
//   ];
//
//   final List<Color> _colors = [
//     Colors.red,
//     Colors.blue,
//     Colors.green,
//     Colors.yellow,
//     Colors.orange,
//     Colors.purple,
//     Colors.teal,
//     Colors.pink,
//     Colors.indigo,
//     Colors.brown,
//     Colors.deepPurpleAccent,
//     Colors.cyanAccent,
//     Colors.black
//   ];
//
//   List<IconData> get _currentIconsList =>
//       _selectedValue == 0 ? _incomeIcons : _expenseIcons;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           CustomHeader(title: 'Tạo danh mục'),
//           Expanded(
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       Stack(
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.only(left: 70),
//                             child: TextField(
//                                 onChanged: (value) {
//                                   setState(() {
//                                     showErrorName = false;
//                                   });
//                                 },
//                                 controller: _nameCategory,
//                                 decoration: InputDecoration(
//                                   labelText: 'Tên danh mục',
//                                   errorText: showErrorName ? 'Nhập tên danh mục' : null,
//                                 ),
//                               ),
//                           ),
//                           if (selectedIcon != null)
//                             Positioned(
//                               left: 2.0,
//                               top: 13.0,
//                               child: Container(
//                                 width: 50,
//                                 height: 50,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: _selectedColor ?? Colors.blueGrey.shade200,
//                                 ),
//                                 child: Icon(
//                                   selectedIcon,
//                                   color: Colors.white,
//                                   size: 24,
//                                 ),
//                               ),
//                             ),
//                           if(selectedIcon == null)
//                             Positioned(
//                               left: 2.0,
//                               top: 13.0,
//                               child: Container(
//                                 width: 50,
//                                 height: 50,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: _selectedColor ?? Colors.blueGrey.shade200,
//                                 ),
//                                 child: Icon(
//                                   FontAwesomeIcons.plus,
//                                   color: Colors.white,
//                                   size: 24,
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//
//                       SizedBox(height: 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Radio(
//                             value: 0,
//                             groupValue: _selectedValue,
//                             onChanged: (value) {
//                               setState(() {
//                                 _selectedValue = value as int;
//                               });
//                             },
//                           ),
//                           Text('Thu nhập',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.black.withOpacity(0.7),
//                             ),
//                           ),
//                           SizedBox(width: 50),
//                           Radio(
//                             value: 1,
//                             groupValue: _selectedValue,
//                             onChanged: (value) {
//                               setState(() {
//                                 _selectedValue = value as int;
//                               });
//                             },
//                           ),
//                           Text('Chi tiêu',
//                             style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.black.withOpacity(0.7),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 20),
//                       Row(
//                         children: [
//                           Text(
//                             'Biểu tượng',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.black.withOpacity(0.7),
//                             ),
//                           ),
//                           SizedBox(width: 10),
//                           if (isEmptyIcon && showErrorIcon)
//                             Text(
//                               'Chọn một biểu tượng danh mục',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.red,
//                               ),
//                             ),
//                         ],
//                       ),
//
//                       GridView.builder(
//                         shrinkWrap: true,
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 3, // Số cột trong lưới
//                           mainAxisSpacing: 30, // Khoảng cách giữa các dòng
//                           crossAxisSpacing: 30, // Khoảng cách giữa các cột
//                           childAspectRatio: 1, // Tỷ lệ khung hình của mỗi mục trong lưới
//                         ),
//                         itemCount: _currentIconsList.length + (_showPlusButton ? 1 : 0),
//                         itemBuilder: (BuildContext context, int index) {
//                           if (index == _currentIconsList.length && _showPlusButton) {
//                             return GestureDetector(
//                               onTap: () async {
//                                 // Xử lý khi nhấn vào nút 'Plus'
//                                 // Navigator.of(context).pushNamed('/icon-category');
//                                 // Chuyển sang màn hình danh mục biểu tượng và nhận biểu tượng đã chọn từ đó
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute<IconData?>(
//                                     builder: (context) => IconCategoryScreen(),
//                                   ),
//                                 ).then((selectedIcon) {
//                                   if (selectedIcon != null) {
//                                     setState(() {
//                                       this.selectedIcon = selectedIcon;
//                                       print("NHAN THANH CONG");
//                                     });
//                                   }
//                                 });
//
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.all(20.0),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: Colors.yellow,
//                                   ),
//                                   child: Icon(
//                                     FontAwesomeIcons.ellipsis,
//                                     color: Colors.white,
//                                     size: 30,
//                                   ),
//                                 ),
//                               ),
//                             );
//                           } else {
//                             return GestureDetector(
//                               onTap: () {
//                                 // Xử lý khi chọn biểu tượng
//                                 setState(() {
//                                   selectedIcon = _currentIconsList[index];
//                                 });
//                               },
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   border: selectedIcon == _currentIconsList[index] ? Border.all(color: Colors.black, width: 1.0) : null, // Thêm border chỉ khi được chọn
//                                 ),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: selectedIcon == _currentIconsList[index]
//                                             ? (_selectedColor ?? Colors.blueGrey.shade200)
//                                             : Colors.blueGrey.shade200,
//                                     ),
//                                     child: Icon(
//                                       _currentIconsList[index],
//                                       size: 45,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }
//                         },
//                       ),
//                       SizedBox(height: 40),
//                       Row(
//                         children: [
//                           Text(
//                             'Màu sắc',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.black.withOpacity(0.7),
//                             ),
//                           ),
//                           SizedBox(width: 10),
//                           if (isEmptyColor && showErrorColor)
//                             Text(
//                               'Chọn màu danh mục',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.red,
//                               ),
//                             ),
//                         ],
//                       ),
//                       SizedBox(height: 10),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Container(
//                               height: 50, // Điều chỉnh chiều cao của hàng màu sắc
//                               child: ListView.builder(
//                                 scrollDirection: Axis.horizontal, // Chỉ định scroll theo chiều ngang
//                                 itemCount: _colors.length, // Số lượng màu sắc muốn hiển thị
//                                 // itemCount: _availableColors.length, // Số lượng màu sắc muốn hiển thị
//                                 itemBuilder: (BuildContext context, int index) {
//                                   return GestureDetector(
//                                     onTap: () async  {
//                                       // Xử lý khi chọn màu sắc
//                                       setState(() {
//                                         _selectedColorIndex = index;
//                                         _selectedColor = _colors[index]; // Cập nhật màu được chọn
//                                       });
//                                     },
//                                     child: Container(
//                                       margin: EdgeInsets.only(right: 15), // Khoảng cách giữa các màu sắc
//                                       width: 40, // Điều chỉnh chiều rộng của mỗi màu sắc
//                                       decoration: BoxDecoration(
//                                         color: _colors[index], // Sử dụng màu sắc từ danh sách màu sắc (_colors)
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: _selectedColorIndex == index
//                                           ? Icon(Icons.check, color: Colors.white, size: 24) // Hiển thị biểu tượng check cho shade được chọn
//                                           : null, // Không hiển thị biểu tượng check cho các shade khác,
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () async {
//                               // Xử lý khi nhấn vào nút 'Plus'
//                               final selectedColor = await Navigator.of(context).push<Color?>(
//                                 MaterialPageRoute(
//                                   builder: (context) => CatalogColorScreen(colors: _colors,  initialColor: _selectedColor),
//                                 ),
//                               );
//                               if (selectedColor != null) {
//                                 setState(() {
//                                   // Cập nhật màu được chọn nếu có
//                                   _selectedColorIndex = _colors.indexOf(selectedColor);
//                                   _selectedColor = selectedColor;
//                                 });
//                               }
//                             },
//                             child: Container(
//                               width: 40, // Điều chỉnh chiều rộng của nút 'Plus'
//                               height: 40, // Điều chỉnh chiều cao của nút 'Plus'
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.blueGrey.shade200,
//                               ),
//                               child: Icon(
//                                 Icons.add,
//                                 color: Colors.white,
//                                 size: 30,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 30),
//                       CustomElevatedButton_2(
//                           text: 'Thêm',
//                           onPressed: (){
//                           // Kiểm tra xem tất cả các trường thông tin đã được nhập đúng chưa
//                           if (!isEmptyName && !isEmptyIcon && !isEmptyColor) {
//                             // Nếu không có lỗi, thêm danh mục mới và chuyển sang màn hình thích hợp
//                             // Tạo một đối tượng Category mới
//                             CategoryItem newCategory = CategoryItem(
//                               name: _nameCategory.text,
//                               icon: selectedIcon ?? Icons.category,
//                               color: _selectedColor ?? Colors.grey,
//                             );
//                             // Chuyển đến màn hình IncomeCategoryAddScreen hoặc ExpenseCategoryAddScreen
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => _selectedValue == 0
//                                     ? IncomeCategoryAddScreen(category: newCategory)
//                                     : ExpenseCategoryAddScreen(category: newCategory),
//                               ),
//                             );
//
//                             // Thực hiện thêm danh mục mới
//                           } else {
//                             // Nếu có lỗi, hiển thị thông báo lỗi
//                             setState(() {
//                               showErrorName = isEmptyName;
//                               showErrorIcon = isEmptyIcon;
//                               showErrorColor = isEmptyColor;
//                             });
//                           }
//                         },
//                       )
//
//                     ],
//                   ),
//                 ),
//               ),
//           ),
//         ],
//       ),
//     );
//   }
// }
