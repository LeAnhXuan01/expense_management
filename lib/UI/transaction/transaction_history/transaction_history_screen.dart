// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../../../model/transaction_model.dart';
// import '../../../model/category_model.dart';
// import '../../../services/transaction_service.dart';
// import '../add_transaction_screen.dart';
//
//
// class TransactionHistoryScreen extends StatefulWidget {
//   final List<Transaction> transactions;
//
//   TransactionHistoryScreen({required this.transactions});
//
//   @override
//   _TransactionHistoryScreenState createState() =>
//       _TransactionHistoryScreenState();
// }
//
// class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
//   String? _selectedFilter;
//   String? _selectedSort;
//   bool _hasInteracted = false;
//   List<Transaction> transactions = [];
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   _fetchTransactions();
//   // }
//
//   // Future<void> _fetchTransactions() async {
//   //   TransactionService transactionService = TransactionService();
//   //   List<Transaction> fetchedTransactions =
//   //       await transactionService.getTransactions();
//   //   setState(() {
//   //     transactions = fetchedTransactions;
//   //   });
//   // }
//   //
//   // Future<Category?> _getCategory(int? categoryId) async {
//   //   if (categoryId == null) return null; // Kiểm tra categoryId null
//   //   TransactionService transactionService = TransactionService();
//   //   return await transactionService.getCategoryById(categoryId);
//   // }
//   //
//   // void _addNewTransaction(Transaction transaction) {
//   //   setState(() {
//   //     transactions.add(transaction);
//   //     transactions.sort((a, b) =>
//   //         DateTime.parse(b.dateTime!).compareTo(DateTime.parse(a.dateTime!)));
//   //   });
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         title: Text('Lịch sử giao dịch'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.home),
//             onPressed: () {
//               Navigator.of(context).pushNamed('/bottom');
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.search),
//             onPressed: () {
//               // Handle search action
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.filter_list),
//             onPressed: () {
//               _scaffoldKey.currentState?.openEndDrawer();
//             },
//           ),
//         ],
//       ),
//       endDrawer: _buildFilterDrawer(context),
//       body: transactions.isEmpty
//           ? Center(child: CircularProgressIndicator())
//           : _buildTransactionList(),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           final newTransaction = await Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => AddTransactionScreen(),
//             ),
//           );
//
//           if (newTransaction != null) {
//             setState(() {
//               transactions.insert(
//                   0, newTransaction); // Thêm giao dịch mới vào đầu danh sách
//             });
//           }
//         },
//         child: Icon(Icons.add),
//         backgroundColor: Colors.deepPurpleAccent,
//       ),
//     );
//   }
//
//   // Widget _buildTransactionList() {
//   //   Map<String, List<Transaction>> groupedTransactions = {};
//   //
//   //   for (var transaction in transactions) {
//   //     String? dateTime = transaction.dateTime;
//   //     if (dateTime != null) {
//   //       String date = dateTime.split('T')[0]; // Lấy ngày từ dateTime
//   //       if (groupedTransactions[date] == null) {
//   //         groupedTransactions[date] = [];
//   //       }
//   //       groupedTransactions[date]!.add(transaction);
//   //     }
//   //   }
//   //
//   //   return ListView.builder(
//   //     itemCount: groupedTransactions.keys.length,
//   //     itemBuilder: (context, index) {
//   //       String date = groupedTransactions.keys.elementAt(index);
//   //       List<Transaction> dailyTransactions = groupedTransactions[date]!;
//   //
//   //       return Column(
//   //         crossAxisAlignment: CrossAxisAlignment.start,
//   //         children: [
//   //           Padding(
//   //             padding: const EdgeInsets.all(8.0),
//   //             child: Text(
//   //               date,
//   //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//   //             ),
//   //           ),
//   //           ...dailyTransactions.map((transaction) {
//   //             return _buildTransactionCard(transaction);
//   //           }).toList(),
//   //         ],
//   //       );
//   //     },
//   //   );
//   // }
//
//   // Widget _buildTransactionCard(Transaction transaction) {
//   //   return FutureBuilder<Category?>(
//   //     future: _getCategory(transaction.categoryId),
//   //     builder: (context, snapshot) {
//   //       if (snapshot.connectionState == ConnectionState.waiting) {
//   //         return Center(child: CircularProgressIndicator());
//   //       } else if (snapshot.hasError || !snapshot.hasData) {
//   //         // Kiểm tra snapshot không có dữ liệu hoặc có lỗi
//   //         return Card(
//   //           margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
//   //           child: ListTile(
//   //             title: Text(
//   //               transaction.dateTime ?? 'Ngày không rõ',
//   //               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//   //             ),
//   //             subtitle: Text('Danh mục không rõ'),
//   //             trailing: Text(
//   //               'Số tiền không rõ',
//   //               style: TextStyle(
//   //                 color: Colors.grey,
//   //                 fontWeight: FontWeight.bold,
//   //                 fontSize: 16,
//   //               ),
//   //             ),
//   //           ),
//   //         );
//   //       } else {
//   //         Category? category = snapshot.data!;
//   //         return Card(
//   //           margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
//   //           child: ListTile(
//   //             title: Text(
//   //               // DateFormat('dd/MM/yyyy')
//   //               //     .format(DateTime.parse(transaction.dateTime!)),
//   //               // style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//   //               "lol"
//   //             ),
//   //             subtitle: Column(
//   //               crossAxisAlignment: CrossAxisAlignment.start,
//   //               children: [
//   //                 Row(
//   //                   children: [
//   //                     if (category.icon != null)
//   //                       Icon(
//   //                         IconData(int.parse(category.icon!),
//   //                           fontFamily: 'FontAwesomeSolid', // Đảm bảo fontFamily phù hợp với FontAwesome
//   //                           fontPackage: 'font_awesome_flutter',),
//   //                         color: category.color != null
//   //                             ? Color(int.parse(category.color!))
//   //                             : Colors.grey,
//   //                       ),
//   //                     SizedBox(width: 8),
//   //                     Text(category.name ?? 'Tên danh mục'),
//   //                   ],
//   //                 ),
//   //                 if (transaction.note != null &&
//   //                     transaction
//   //                         .note!.isNotEmpty) // Kiểm tra có ghi chú hay không
//   //                   Text(
//   //                     transaction.note!,
//   //                     style: TextStyle(fontSize: 14),
//   //                   ),
//   //               ],
//   //             ),
//   //             trailing: Text(
//   //               '${transaction.type == 'income' ? '+' : '-'}${transaction.amount}',
//   //               style: TextStyle(
//   //                 color:
//   //                     transaction.type == 'income' ? Colors.green : Colors.red,
//   //                 fontWeight: FontWeight.bold,
//   //                 fontSize: 16,
//   //               ),
//   //             ),
//   //           ),
//   //         );
//   //       }
//   //     },
//   //   );
//   // }
//
//   Widget _buildFilterDrawer(BuildContext context) {
//     return Drawer(
//       width: 350,
//       child: Padding(
//         padding: EdgeInsets.all(18),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 30),
//             Text(
//               'Bộ lọc tìm kiếm:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//             ),
//             Divider(),
//             Text(
//               'Loại:',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//             ),
//             SizedBox(height: 8),
//             Wrap(
//               spacing: 8.0,
//               runSpacing: 8.0,
//               children: [
//                 _buildFilterButton('Tất cả'),
//                 _buildFilterButton('Thu'),
//                 _buildFilterButton('Chi'),
//               ],
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Sắp xếp:',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//             ),
//             SizedBox(height: 8),
//             Wrap(
//               spacing: 8.0,
//               runSpacing: 8.0,
//               children: [
//                 _buildSortButton('Giao dịch mới nhất'),
//                 _buildSortButton('Giao dịch cũ nhất'),
//                 _buildSortButton('Giá cao nhất'),
//                 _buildSortButton('Giá thấp nhất'),
//               ],
//             ),
//             SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Expanded(
//                   flex: 1,
//                   child: ElevatedButton(
//                     onPressed: _hasInteracted
//                         ? () {
//                             setState(() {
//                               _selectedFilter = null;
//                               _selectedSort = null;
//                               _hasInteracted = false;
//                             });
//                           }
//                         : null,
//                     child: Text(
//                       'Thiết lập lại',
//                       style: TextStyle(
//                           color: _hasInteracted == true
//                               ? Colors.white
//                               : Colors.black54),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.deepPurpleAccent),
//                   ),
//                 ),
//                 SizedBox(width: 16),
//                 Expanded(
//                   flex: 1,
//                   child: ElevatedButton(
//                     onPressed: _hasInteracted
//                         ? () {
//                             // Áp dụng bộ lọc và sắp xếp
//                             Navigator.of(context).pop();
//                           }
//                         : null,
//                     child: Text(
//                       'Áp dụng',
//                       style: TextStyle(
//                           color: _hasInteracted == true
//                               ? Colors.white
//                               : Colors.black54),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.deepPurpleAccent),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFilterButton(String filter) {
//     bool isSelected = _selectedFilter == filter;
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _selectedFilter = filter;
//           _hasInteracted = true;
//         });
//       },
//       child: Container(
//         width: 150,
//         padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//         decoration: BoxDecoration(
//           color: Colors.grey[300],
//           borderRadius: BorderRadius.circular(8),
//           border: isSelected ? Border.all(color: Colors.red) : null,
//         ),
//         child: Center(
//           child: Text(
//             filter,
//             style: TextStyle(
//               color: isSelected ? Colors.red : Colors.black,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSortButton(String sort) {
//     bool isSelected = _selectedSort == sort;
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _selectedSort = sort;
//           _hasInteracted = true;
//         });
//       },
//       child: Container(
//         width: 150,
//         padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//         decoration: BoxDecoration(
//           color: Colors.grey[300],
//           borderRadius: BorderRadius.circular(8),
//           border: isSelected ? Border.all(color: Colors.red) : null,
//         ),
//         child: Center(
//           child: Text(
//             sort,
//             style: TextStyle(
//               color: isSelected ? Colors.red : Colors.black,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
