import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomElavatedButton_1 extends StatelessWidget {
  final String text;
  final dynamic Function() onPressed;

  const CustomElavatedButton_1({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
            onPressed: (){
              // Gọi hàm onPressed và lấy giá trị trả về
              final result = onPressed();
              // Xử lý kết quả (nếu cần)
              print('Result: $result');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
              fixedSize: Size(360, 50),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
        ),
    );
  }
}

