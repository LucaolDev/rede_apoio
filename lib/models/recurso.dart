import 'endereco.dart';

class Recurso {
  const Recurso({
    required this.nome,
    required this.descricao,
    required this.numero,
    required this.endereco,
  });

  final String nome;
  final String descricao;
  final String numero;
  final Endereco endereco;

  factory Recurso.fromJson(Map<String, dynamic> json) {
    return Recurso(
      nome: json['nome'] as String,
      descricao: json['descricao'] as String,
      numero: json['numero'] as String,
      endereco: Endereco.fromJson(json['endereco'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'descricao': descricao,
    'numero': numero,
    'endereco': endereco.toJson(),
  };

  bool correspondeA(String busca) {
    final termo = busca.trim().toLowerCase();
    return [
      nome,
      descricao,
      endereco.cidade,
    ].any((campo) => campo.toLowerCase().contains(termo));
  }
}
