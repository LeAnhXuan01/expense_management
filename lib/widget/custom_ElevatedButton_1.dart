import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomElavatedButton_1 extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const CustomElavatedButton_1({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
            onPressed: onPressed,
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

