import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomSnackBar_2 {
  static show(
      BuildContext context,
      String message, {
        Duration duration = const Duration(seconds: 2),
        String actionLabel = '',
        VoidCallback? onActionPressed,
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(FontAwesomeIcons.check, color: Colors.green),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                message,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: duration,
        action: onActionPressed != null
            ? SnackBarAction(
          label: actionLabel,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          onPressed: onActionPressed,
        )
            : null,
      ),
    );
  }
}