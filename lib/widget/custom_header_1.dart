import 'package:flutter/material.dart';

class CustomHeader_1 extends StatelessWidget {
  final String title;
  final List<Widget> actions;
  const CustomHeader_1({Key? key, required this.title, this.actions = const [],}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
        color: Colors.green,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 30, top: 30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(Icons.arrow_back, color: Colors.white),
            ),
            SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Spacer(), // Đẩy các actions sang bên phải
            ...actions, // Hiển thị các actions
          ],
        ),
      ),
    );
  }
}
