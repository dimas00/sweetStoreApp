import 'dart:ffi';

class Usuario{
  final Long? id_usuario;
  final String nome;
  final String email;
  final String senha;
  final String cpf;
  final String telefone;
  final String data_cadastro;
  final bool ativo;

  Usuario({
    this.id_usuario,
    required this.nome,
    required this.email,
    required this.senha,
    required this.cpf,
    required this.telefone,
    required this.data_cadastro,
    required this.ativo});


}