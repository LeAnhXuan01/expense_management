import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isBalanceVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: _buildBody(),
        ),

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
    User? user = FirebaseAuth.instance.currentUser;
    String displayName = user != null ? user.email!.split('@')[0] : 'Người dùng';

    return Container(
      width: double.infinity,
      height: 230,
      decoration: const BoxDecoration(
        color: Colors.lightBlueAccent,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Column(
          children: [
            Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Container(
                        width: 70,
                        height: 70,
                        child: Image.asset('assets/images/logo.png'),
                      ),
                    ),
                  ),
                  SizedBox(width: 30),
                  Expanded(
                    flex: 3,
                    child: Text(
                        'Chào, $displayName!',
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

  Widget _buildBalance() {
    String balance = _isBalanceVisible ? '10TR VNĐ' : '*****';
    return Container(
      width: 380,
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
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tổng số dư',
                  style: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w400),
                ),
                Text(
                  balance,
                  style: TextStyle(color: Colors.green, fontSize: 26, fontWeight: FontWeight.w900),
                ),
              ],
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
      ),
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
            title: 'Quản lý hóa đơn',
            onTap: () {
              Navigator.of(context).pushNamed('/bill-list');
            },
          ),
          _buildUtilityCard(
            icon: Icons.category,
            title: 'Quản lý danh mục',
            onTap: () {
              Navigator.of(context).pushNamed('/category-list');
            },
          ),
          _buildUtilityCard(
            icon: Icons.wallet,
            title: 'Quản lý ví tiền',
            onTap: () {
              Navigator.of(context).pushNamed('/wallets');
            },
          ),
          _buildUtilityCard(
            icon: Icons.account_balance_wallet,
            title: 'Lập hạn mức chi tiêu',
            onTap: () {
              Navigator.of(context).pushNamed('/budget-list');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUtilityCard({required IconData icon, required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.green),
              SizedBox(height: 10),
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
