import 'package:flutter/material.dart';
import 'package:sweet_store/features/cart/cart_page.dart';
import 'package:sweet_store/features/home/home_page.dart';
import 'package:sweet_store/features/auth/session_manager.dart';
import 'package:sweet_store/features/user/user_page.dart';

import 'features/auth/login_page.dart';
import 'core/splash_page.dart';
import 'features/checkout/checkout_page.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    SessionManager.onLogout = () {
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
      ),
      navigatorKey: navigatorKey,
      routes: {'/login': (_) => Login(), '/home': (_) => Home(), '/cart': (_) => Carrinho(), '/user': (_) => UserPage(), '/checkout': (_) => CheckoutPage(), },
      home: Home(),
    );
  }
}
