import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../data/transaction.dart';
import '../view_model/home_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Transaction> transactions = [
    Transaction(
      icon: FontAwesomeIcons.shoppingCart,
      name: 'Mua sắm',
      date: DateTime.now(),
      amount: -3000000,
      type: TransactionType.expense,
    ),
    Transaction(
      icon: FontAwesomeIcons.moneyBillAlt,
      name: 'Lương tháng 4',
      date: DateTime.now().subtract(Duration(days: 2)),
      amount: 5000000,
      type: TransactionType.income,
    ),
    //Thêm các giao dịch khác nếu cần
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => HomeScreenViewModel(transactions: transactions),
        child: SafeArea(
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<HomeScreenViewModel>(
      builder: (context, viewModel, _) {
        return Stack(
          children: [
            Column(
              children: [
                _buildHeader(viewModel),
                Expanded(
                    child: _buildRecentTransactions(viewModel),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(HomeScreenViewModel viewModel) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: const BoxDecoration(
        color: Colors.deepPurpleAccent,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Column(
          children: [
            Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Container(
                        width: 60,
                        height: 60,
                        child: Image.asset('assets/images/logo.png'),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Container(
                        width: 250,
                        height: 40,
                        child: TextField(

                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Tìm kiếm ở đây',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            suffixIcon: Icon(FontAwesomeIcons.search, color: Colors.deepPurple,),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: IconButton(
                        onPressed: () {
                          // Xử lý sự kiện khi nhấn vào biểu tượng thông báo
                        },
                        icon: Icon(
                          FontAwesomeIcons.bell,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                  ),
                ],
              ),
            SizedBox(height: 20),
            Container(
              width: 320,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.deepPurple,
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
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng số dư',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      viewModel.totalBalance,
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                FontAwesomeIcons.arrowCircleUp,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Thu nhập:',
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            SizedBox(width: 5),
                            Text(
                              viewModel.totalIncome,
                              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                FontAwesomeIcons.arrowCircleDown,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Chi tiêu:',
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            SizedBox(width: 5),
                            Text(
                              viewModel.totalExpense,
                              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions(HomeScreenViewModel viewModel) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Giao dịch gần đây',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Xử lý khi nhấn vào nút 'Xem tất cả'
                    Navigator.of(context).pushNamed('/transaction-history');
                  },
                  child: Text(
                    'Xem tất cả',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return ListTile(
                    leading: Icon(transaction.icon),
                    title: Text(transaction.name),
                    subtitle: Text(
                      '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
                    ),
                    trailing: Text(
                      '${transaction.amount > 0 ? '+' : '-'}${transaction.amount.abs()} VNĐ',
                      style: TextStyle(
                        color: transaction.type == TransactionType.income
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );

  }
}
