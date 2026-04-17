import 'package:flutter/cupertino.dart';

class LoginController {
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  String _login = '';
  String _senha = '';


  void setLogin(String value) => _login = value;
  void setSenha(String value) => _senha = value;


  String get login => _login;
  String get senha => _senha;

  Future<String?> auth() async {
    isLoading.value = true;

    await Future.delayed(Duration(seconds: 2));

    isLoading.value = false;

    // simulação de sucesso
    if (_login == 'admin' && _senha == '123') {
      return "token_fake_123";
    }

    // falha
    return null;
  }
}