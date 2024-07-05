import 'dart:io';
import 'package:expense_management/view/wallet/wallets_screen.dart';
import 'package:expense_management/view_model/user/edit_profile_view_model.dart';
import 'package:expense_management/view_model/wallet/wallet_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isBalanceVisible = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final walletViewModel = Provider.of<WalletViewModel>(context, listen: false);
      walletViewModel.loadWallets(); // Tải lại ví khi màn hình được hiển thị
      final profileViewModel = Provider.of<EditProfileViewModel>(context, listen: false);
      profileViewModel.loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build called');
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: _buildBody(),
    );
  }
  Widget _buildBody() {
    return  SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(),
          _buildUtilities(),
        ],
      ),
    );
  }
  Widget _buildHeader() {
    return  Consumer<EditProfileViewModel>(
        builder: (context, viewModel, child){
          User? user = FirebaseAuth.instance.currentUser;
          String displayName = viewModel.displayName ?? (user != null ? user.email!.split('@')[0] : 'Người dùng');

          return Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 35, horizontal: 5),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: viewModel.imageFile != null
                            ? FileImage(File(viewModel.imageFile!.path))
                            : (viewModel.networkImageUrl != null
                            ? NetworkImage(viewModel.networkImageUrl!)
                            : AssetImage('assets/images/profile.png')) as ImageProvider,
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          '${getGreeting()},\n$displayName!',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _buildBalance(),
                ],
              ),
            ),
          );
        }
    );
  }

  Widget _buildBalance() {
    return Consumer<WalletViewModel>(
      builder: (context, viewModel, child) {
        String balance = _isBalanceVisible ? '${viewModel.formattedTotalBalance} ₫' : '***** ₫';
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                offset: Offset(7, 5),
                blurRadius: 30,
                spreadRadius: 2,
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tổng số dư',
                  style: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w400),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        balance,
                        style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isBalanceVisible = !_isBalanceVisible;
                        });
                      },
                      icon: Icon(
                        _isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  Widget _buildUtilities() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        children: [
          _buildUtilityCard(
            icon: Icons.receipt,
            color: Colors.grey,
            title: 'Hóa đơn',
            onTap: () {
              Navigator.pushNamed(context, '/bill-list');
            },
          ),
          _buildUtilityCard(
            icon: Icons.category,
            color: Colors.green,
            title: 'Danh mục',
            onTap: () {
              Navigator.pushNamed(context, '/category-list');
            },
          ),
          _buildUtilityCard(
            icon: Icons.wallet,
            color: Colors.yellow,
            title: 'Ví tiền',
            // onTap: () {
            //   Navigator.pushNamed(context, '/wallets');
            // },
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => WalletScreen())).then((_) {
                // Cập nhật ví khi quay lại từ màn hình lịch sử chuyển khoản
                final walletViewModel = Provider.of<WalletViewModel>(context, listen: false);
                walletViewModel.loadWallets();
              });
            },
          ),
          _buildUtilityCard(
            icon: Icons.account_balance_wallet,
            color: Colors.blue,
            title: 'Lập hạn mức',
            onTap: () {
              Navigator.pushNamed(context, '/budget-list');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUtilityCard({required IconData icon, required Color color,required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 60, color: color),
              SizedBox(height: 5),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
