import 'package:flutter/material.dart';

class CustomElevatedButton_2 extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;


  const CustomElevatedButton_2({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200,
        child: ElevatedButton(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurpleAccent,
          ),
        ),
      ),
    );
  }
}
