// import 'package:expense_management/widget/custom_header_1.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../model/transaction_model.dart';
// import '../../../view_model/transaction/transaction_history_view_model.dart';
// import '../../../utils/utils.dart';
// import '../../model/enum.dart';
// import 'component/image_detail_screen.dart';
// import 'edit_transaction_screen.dart';
//
// class DetailTransactionScreen extends StatefulWidget {
//   final Transactions transaction;
//
//   const DetailTransactionScreen({super.key, required this.transaction});
//
//   @override
//   _DetailTransactionScreenState createState() => _DetailTransactionScreenState();
// }
//
// class _DetailTransactionScreenState extends State<DetailTransactionScreen> {
//   late Transactions _transaction;
//
//   @override
//   void initState() {
//     super.initState();
//     _transaction = widget.transaction;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final viewModel = Provider.of<TransactionHistoryViewModel>(context, listen: false);
//
//     // Lấy dữ liệu ví và danh mục sử dụng các phương thức mới
//     final wallet = viewModel.getWalletByTransaction(_transaction);
//     final category = viewModel.getCategoryByTransaction(_transaction);
//
//     String walletName = 'Không có ví';
//     IconData walletIcon = Icons.account_balance_wallet;
//     Color walletColor = Colors.grey;
//
//     if (wallet != null) {
//       walletName = wallet.name;
//       walletIcon = parseIcon(wallet.icon);
//       walletColor = parseColor(wallet.color);
//     }
//
//     String categoryName = 'Không có danh mục';
//     IconData categoryIcon = Icons.category;
//     Color categoryColor = Colors.grey;
//
//     if (category != null) {
//       categoryName = category.name;
//       categoryIcon = parseIcon(category.icon);
//       categoryColor = parseColor(category.color);
//     }
//
//     // Định dạng số tiền, ngày và giờ
//     final formattedAmount = formatAmount(_transaction.amount, _transaction.currency);
//     final formattedDate = formatDate(_transaction.date);
//     final formattedTime = formatHour(_transaction.hour);
//
//     return Scaffold(
//       body: Column(
//         children: [
//           CustomHeader_1(
//             title: 'Chi tiết giao dịch',
//             action: IconButton(
//               icon: Icon(Icons.edit, color: Colors.white),
//               onPressed: () async {
//                 final updatedTransaction = await Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => EditTransactionScreen(
//                       transaction: _transaction,
//                     ),
//                   ),
//                 );
//
//                 if (updatedTransaction != null) {
//                   // setState(() {
//                   //   _transaction = updatedTransaction;
//                   // });
//                   Navigator.pop(context, updatedTransaction);
//                 }
//               },
//             ),
//           ),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Số tiền',
//                       style: TextStyle(fontSize: 18),
//                     ),
//                     Text(
//                       '${formatInitialBalance(_transaction.amount, _transaction.currency)} ${_transaction.currency == Currency.VND ? '₫' : '\$'}',
//                       style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                     Divider(),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Ví tiền',
//                           style: TextStyle(fontSize: 18),
//                         ),
//                         SizedBox(height: 8),
//                         // Khoảng cách giữa Text và ListTile
//                         ListTile(
//                           leading: CircleAvatar(
//                             backgroundColor: walletColor,
//                             child: Icon(walletIcon, color: Colors.white),
//                           ),
//                           title: Text(walletName,
//                               style: TextStyle(
//                                   fontSize: 18, fontWeight: FontWeight.w500)),
//                         ),
//                       ],
//                     ),
//                     Divider(),
//                     Text('Danh mục', style: TextStyle(fontSize: 18)),
//                     ListTile(
//                       leading: CircleAvatar(
//                         backgroundColor: categoryColor,
//                         child: Icon(categoryIcon, color: Colors.white),
//                       ),
//                       title: Text(categoryName,
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.w500)),
//                     ),
//                     Divider(),
//                     Text('Ngày', style: TextStyle(fontSize: 18)),
//                     Text('$formattedDate',
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.w500)),
//                     Divider(),
//                     Text('Giờ', style: TextStyle(fontSize: 18)),
//                     Text('$formattedTime',
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.w500)),
//                     if (_transaction.note.isNotEmpty) ...[
//                       SizedBox(height: 16),
//                       Text(
//                         'Ghi chú',
//                         style: TextStyle(fontSize: 18),
//                       ),
//                       Text(_transaction.note,
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.w500)),
//                     ],
//                     if (_transaction.images.isNotEmpty) ...[
//                       SizedBox(height: 16),
//                       Text(
//                         'Hình ảnh',
//                         style: TextStyle(fontSize: 18),
//                       ),
//                       SizedBox(
//                         height: 200, // Đặt chiều cao của GridView
//                         child: GridView.builder(
//                           shrinkWrap: true,
//                           physics: NeverScrollableScrollPhysics(),
//                           itemCount: _transaction.images.length,
//                           gridDelegate:
//                           SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 4, // Số cột trong lưới
//                             crossAxisSpacing: 10,
//                           ),
//                           itemBuilder: (context, index) {
//                             return GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => ImageDetailScreen(
//                                       imageUrls: _transaction.images,
//                                       initialIndex: index,
//                                     ),
//                                   ),
//                                 );
//                               },
//                               child: Image.network(
//                                 _transaction.images[index],
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (context, error, stackTrace) {
//                                   return Icon(Icons.error, color: Colors.red);
//                                 },
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
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
