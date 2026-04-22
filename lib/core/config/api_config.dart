import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  // Pega a URL do .env. Se não achar, usa um fallback de segurança
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? "http://192.168.1.246:8080/SweetStore";
  }