import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/recurso.dart';

class DadosLocais {
  final _preferencias = SharedPreferencesAsync();
  static const _chaveIntroducao = 'pular_introducao';
  static const _chaveRecursos = 'recursos_comunitarios';

  Future<bool?> lerPreferenciaIntroducao() {
    // null indica que a introdução ainda não foi concluída.
    return _preferencias.getBool(_chaveIntroducao);
  }

  Future<void> salvarPreferenciaIntroducao(bool pular) {
    return _preferencias.setBool(_chaveIntroducao, pular);
  }

  Future<List<Recurso>> listarRecursos() async {
    final registros = await _preferencias.getStringList(_chaveRecursos) ?? [];
    return registros.map((registro) {
      final json = jsonDecode(registro) as Map<String, dynamic>;
      return Recurso.fromJson(json);
    }).toList();
  }

  Future<void> adicionarRecurso(Recurso recurso) async {
    final registros = await _preferencias.getStringList(_chaveRecursos) ?? [];
    await _preferencias.setStringList(_chaveRecursos, [
      jsonEncode(recurso.toJson()),
      ...registros,
    ]);
  }
}
