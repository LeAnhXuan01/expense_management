import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../view/home_screen.dart';
import '../view/statistics/statistics_screen.dart';
import '../view/transaction/add_transaction_screen.dart';
import '../view/transaction/transaction_history/transaction_history_screen.dart';
import '../view/user/profile_screen.dart';


class Bottom extends StatefulWidget {
  const Bottom({Key? key}) : super(key: key);

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int selectedIndex = 0;

  final List<Widget> screens = [HomeScreen(), TransactionHistoryScreen(transactions: [],), AddTransactionScreen(), StatisticsScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Ngăn chặn Scaffold thay đổi kích thước để tránh bàn phím
      body: screens[selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {
            // isExpanded = !isExpanded;
            selectedIndex = 2;
          });
        },
        child: AnimatedOpacity(
            duration: Duration(milliseconds: 300),
            opacity: selectedIndex == 2 ? 1.0 : 0.5,
            child: Icon(
                FontAwesomeIcons.plus,
                color: Colors.white)
        ),
        backgroundColor: selectedIndex == 2 ? Colors.green : Colors.grey,
        shape: CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: SizedBox(
        height: 55,
        child: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBottomNavigationBarItem(FontAwesomeIcons.house, 0),
              _buildBottomNavigationBarItem(FontAwesomeIcons.list, 1),
              SizedBox(width: 20),
              _buildBottomNavigationBarItem(FontAwesomeIcons.chartSimple, 3),
              _buildBottomNavigationBarItem(FontAwesomeIcons.user, 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBarItem(IconData icon, int index) {
    return GestureDetector(
      onTap: (){
        setState(() {
          selectedIndex = index;
        });
      },
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 300),
        opacity: selectedIndex == index ? 1.0 : 0.5,
        child: Icon(
          icon,
          color: selectedIndex == index ? Colors.green : Colors.grey,
        ),
      ),
    );
  }
}


