import 'package:expense_management/model/transfer_model.dart';
import 'package:expense_management/model/wallet_model.dart';
import 'package:expense_management/utils/utils.dart';
import 'package:expense_management/view/transfer/create_transfer_screen.dart';
import 'package:expense_management/widget/custom_snackbar_1.dart';
import 'package:expense_management/widget/custom_snackbar_2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../model/enum.dart';
import '../../view_model/wallet/wallet_view_model.dart';
import '../../widget/custom_header_3.dart';
import '../transfer/transfer_history_screen.dart';
import 'create_wallet_screen.dart';
import 'edit_wallet_screen.dart';

class WalletScreen extends StatefulWidget {
  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WalletViewModel(),
      child: Consumer<WalletViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: Column(
              children: [
                CustomHeader_3(
                  title: 'Ví tiền',
                  action: GestureDetector(
                    onTap: () {
                      setState(() {
                        viewModel.isSearching = true;
                      });
                    },
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                  isSearching: viewModel.isSearching,
                  onSearchChanged: (query) {
                    setState(() {
                      viewModel.searchQuery = query;
                      viewModel.filterWallets(query);
                    });
                  },
                  onSearchClose: () {
                    setState(() {
                      viewModel.isSearching = false;
                      viewModel.searchQuery = '';
                      viewModel.searchController.clear();
                      viewModel.filterWallets('');
                    });
                  },
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Tổng cộng:',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${viewModel.formattedTotalBalance} ₫',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TransferHistoryScreen())).then((_) {
                          // Cập nhật ví khi quay lại từ màn hình lịch sử chuyển khoản
                          final walletViewModel = Provider.of<WalletViewModel>(
                              context,
                              listen: false);
                          walletViewModel.loadWallets();
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.green,
                            ),
                            child: Icon(FontAwesomeIcons.clockRotateLeft,
                                color: Colors.white),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Lịch sử chuyển\nkhoản',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final newTransfer = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateTransferScreen(),
                          ),
                        );
                        if (newTransfer != null && newTransfer is Transfer) {
                          await viewModel.loadWallets();
                        }
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.green,
                            ),
                            child: Icon(FontAwesomeIcons.rightLeft,
                                color: Colors.white),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Giao dịch chuyển\nkhoản mới',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: viewModel.wallets.isEmpty && viewModel.isSearching
                      ? Center(
                          child: Text(
                            'Không có kết quả tìm kiếm nào.',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: viewModel.wallets.length,
                          itemBuilder: (context, index) {
                            final wallet = viewModel.wallets[index];
                            return Dismissible(
                              key: Key(wallet.walletId),
                              // Khóa duy nhất cho mỗi ví
                              direction: DismissDirection.endToStart,
                              // Chỉ cho phép vuốt từ phải sang trái
                              confirmDismiss: (direction) async {
                                if (wallet.isDefault) {
                                  CustomSnackBar_1.show(
                                      context, 'Ví này không thể xóa');
                                  return false;
                                }
                                // Hiển thị hộp thoại xác nhận
                                return await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Chú ý'),
                                      content: RichText(
                                        text: TextSpan(
                                            text: 'Nếu bạn xóa ví này, ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16),
                                            children: [
                                              TextSpan(
                                                text:
                                                    'tất cả các ghi chép liên quan cũng sẽ bị xóa và không thể khôi phục',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              TextSpan(
                                                text:
                                                    '. Bạn có thực sự muốn xóa không?',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        16), // Màu đen cho phần văn bản bình thường
                                              ),
                                            ]),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: Text('Không',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 18)),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(false); // Không xóa
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Có',
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 18)),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(true); // Xác nhận xóa
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              onDismissed: (direction) async {
                                // Xóa ví
                                await viewModel.deleteWallet(wallet.walletId);
                                CustomSnackBar_2.show(
                                    context, '${wallet.name} đã bị xóa');
                              },
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                              child: Card(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  leading: Container(
                                    width: 55,
                                    height: 55,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: parseColor(wallet.color),
                                    ),
                                    child: Icon(
                                      parseIcon(wallet.icon),
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                  title: Text(
                                    wallet.name,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    // Giới hạn chỉ hiển thị tối đa 1 dòng
                                    overflow: TextOverflow
                                        .ellipsis, // Hiển thị dấu ba chấm khi vượt quá 1 dòng
                                  ),
                                  subtitle: Text(
                                    '${formatAmount(wallet.initialBalance, wallet.currency)} ${wallet.currency == Currency.VND ? '₫' : '\$'}',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  trailing: wallet.excludeFromTotal
                                      ? Icon(Icons.remove_circle,
                                          color: Colors.red)
                                      : null,
                                  onTap: () async {
                                    final updatedWallet = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditWalletScreen(wallet: wallet),
                                      ),
                                    );
                                    if (updatedWallet != null &&
                                        updatedWallet is Wallet) {
                                      await viewModel.loadWallets();
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                final newWallet = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateWalletScreen(),
                  ),
                );
                if (newWallet != null && newWallet is Wallet) {
                  await viewModel.loadWallets();
                }
              },
              child: Icon(Icons.add, color: Colors.white),
              backgroundColor: Colors.green,
              shape: CircleBorder(),
            ),
          );
        },
      ),
    );
  }
}
