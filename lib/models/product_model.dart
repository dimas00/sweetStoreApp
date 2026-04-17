class ProductModel {
  final int id;
  final String nome;
  final String descricao;
  final double preco;
  final String imagemUrl;

  ProductModel({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.imagemUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      preco: (json['preco'] as num).toDouble(),
      imagemUrl: json['imagemUrl'] ?? "",
    );
  }
}