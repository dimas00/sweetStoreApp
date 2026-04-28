import 'package:flutter/material.dart';
import 'package:sweet_store/features/auth/register_page.dart';
import 'package:sweet_store/features/cart/cart_page.dart';
import 'package:sweet_store/features/home/home_page.dart';
import 'package:sweet_store/features/auth/session_manager.dart';
import 'package:sweet_store/features/user/user_page.dart';

import 'features/addrees/address_page.dart';
import 'features/auth/login_page.dart';
import 'core/splash_page.dart';
import 'features/checkout/checkout_page.dart';

// 🔥 1. Importe o main.dart para ter acesso à navigatorKey global
import '../main.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  void initState() {
    super.initState();

    SessionManager.onLogout = () {
      // Como importamos o main.dart, ele já enxerga a chave global aqui
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/login',
            (route) => false,
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
      ),
      routes: {
        '/login': (_) => const Login(),
        '/home': (_) => const Home(),
        '/cart': (_) => const Carrinho(),
        '/user': (_) => const UserPage(),
        '/checkout': (_) => const CheckoutPage(),
        '/addrees': (_) => const AddressPage(),
        '/register': (_) => const RegisterPage()
      },
      home: const SplashPage(),
    );
  }
}