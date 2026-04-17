import 'package:flutter/material.dart';
import 'package:sweet_store/screens/android/carrinho.dart';
import 'package:sweet_store/screens/android/home.dart';
import 'package:sweet_store/services/session_manager.dart';

import 'screens/android/login.dart';
import 'screens/android/splash_page.dart';

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
      routes: {'/login': (_) => Login(), '/home': (_) => Home()},
      home: Home(),
    );
  }
}
