import 'package:flutter/material.dart';
import 'package:sweet_store/screens/android/home.dart';

import 'screens/android/login.dart';
import 'screens/android/splash/splash_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        title: "App Mobile",
        home: Home(),

      // initialRoute: '/splash',
      // routes: {
      //   '/splash': (_) => const SplashPage(),
      //   '/login': (_)=>  Login(),
      //   // '/carrinho': (_)=> Carrinho(),
      //   // '/itemPage': (_) => ItemPage(),
      // },
        );
  }
}
