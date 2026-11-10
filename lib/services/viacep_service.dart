import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/endereco.dart';

class ViaCepService {
  static const _baseUrl = 'https://viacep.com.br/ws';

  Future<Endereco> buscarEndereco(String cep) async {
    final cepLimpo = cep.replaceAll(RegExp(r'[^0-9]'), '');
    if (cepLimpo.length != 8) {
      throw Exception('Informe um CEP com 8 dígitos.');
    }

    final uri = Uri.parse('$_baseUrl/$cepLimpo/json/');
    try {
      final resposta = await http
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 10));
      if (resposta.statusCode != 200) {
        throw Exception('O ViaCEP está indisponível no momento.');
      }

      final dados = jsonDecode(utf8.decode(resposta.bodyBytes));
      if (dados is! Map<String, dynamic>) {
        throw const FormatException('Resposta inesperada');
      }
      if (dados['erro'] == true || dados['erro'] == 'true') {
        throw Exception('CEP não encontrado. Confira os dígitos.');
      }
      return Endereco.fromJson(dados);
    } on TimeoutException {
      throw Exception('A consulta demorou demais.');
    } on http.ClientException {
      throw Exception('Falha de conexão. Confira sua internet.');
    } on FormatException {
      throw Exception('O ViaCEP enviou uma resposta inválida.');
    } on TypeError {
      throw Exception('O ViaCEP enviou um endereço incompleto.');
    }
  }
}
