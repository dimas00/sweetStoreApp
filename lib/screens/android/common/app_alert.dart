import 'package:flutter/material.dart';

class AppAlert {
  static void showError(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(20),
        ),
      );
  }

  static void showSuccess(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(

      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(80),
      ),
    );
  }

  static void showInfo(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.purple,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(80),
      ),
    );
  }
}