import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sweet_store/App_widget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // Garante que os bindings do Flutter estão prontos antes de carregar o .env
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env"); // Carrega as variáveis

  runApp(const AppWidget());
}
