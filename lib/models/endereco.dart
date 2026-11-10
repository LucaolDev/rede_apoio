class Endereco {
  const Endereco({
    required this.cep,
    required this.logradouro,
    required this.bairro,
    required this.cidade,
    required this.uf,
  });

  final String cep;
  final String logradouro;
  final String bairro;
  final String cidade;
  final String uf;

  factory Endereco.fromJson(Map<String, dynamic> json) {
    final cep = json['cep'] as String;
    final cidade = json['localidade'] as String;
    final uf = json['uf'] as String;
    if (cep.isEmpty || cidade.isEmpty || uf.isEmpty) {
      throw const FormatException('Endereço incompleto');
    }

    return Endereco(
      cep: cep,
      logradouro: json['logradouro'] as String? ?? '',
      bairro: json['bairro'] as String? ?? '',
      cidade: cidade,
      uf: uf,
    );
  }

  Map<String, String> toJson() => {
    'cep': cep,
    'logradouro': logradouro,
    'bairro': bairro,
    'localidade': cidade,
    'uf': uf,
  };

  String get municipio => '$cidade · $uf';
}
