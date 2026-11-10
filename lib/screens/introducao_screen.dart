import 'package:flutter/material.dart';

import '../data/dados_locais.dart';
import '../widgets/componentes.dart';
import 'inicio_screen.dart';

class IntroducaoScreen extends StatefulWidget {
  const IntroducaoScreen({super.key, required this.dados});

  final DadosLocais dados;

  @override
  State<IntroducaoScreen> createState() => _IntroducaoScreenState();
}

class _IntroducaoScreenState extends State<IntroducaoScreen> {
  static const _paginas = [
    _PaginaIntroducao(
      icone: Icons.groups_outlined,
      titulo: 'Organize o apoio do bairro',
      descricao:
          'Reúna os recursos que a comunidade pode mobilizar em situações de emergência.',
    ),
    _PaginaIntroducao(
      icone: Icons.location_on_outlined,
      titulo: 'Cadastre um recurso',
      descricao:
          'Descreva o que está disponível e consulte o CEP para preencher o endereço.',
    ),
    _PaginaIntroducao(
      icone: Icons.list_alt_outlined,
      titulo: 'Encontre o que foi cadastrado',
      descricao:
          'Filtre os registros e abra um item para ver a descrição e o endereço.',
    ),
  ];

  int _pagina = 0;
  bool _pularIntroducao = false;
  bool _salvando = false;
  bool _erro = false;

  Future<void> _avancar() async {
    if (_pagina == _paginas.length - 1) {
      await _finalizar();
    } else {
      setState(() => _pagina++);
    }
  }

  Future<void> _finalizar() async {
    setState(() {
      _salvando = true;
      _erro = false;
    });
    try {
      await widget.dados.salvarPreferenciaIntroducao(_pularIntroducao);
    } catch (_) {
      if (mounted) {
        setState(() {
          _salvando = false;
          _erro = true;
        });
      }
      return;
    }
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => InicioScreen(dados: widget.dados),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final ultima = _pagina == _paginas.length - 1;

    return Scaffold(
      appBar: AppBar(title: const Text('Introdução')),
      body: ConteudoCentralizado(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Etapa ${_pagina + 1} de ${_paginas.length}',
              style: tema.textTheme.labelLarge,
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(value: (_pagina + 1) / _paginas.length),
            const SizedBox(height: 24),
            _paginas[_pagina],
            if (ultima) ...[
              const SizedBox(height: 12),
              CheckboxListTile(
                title: const Text('Não mostrar novamente'),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                value: _pularIntroducao,
                onChanged: _salvando
                    ? null
                    : (valor) =>
                          setState(() => _pularIntroducao = valor ?? false),
              ),
            ],
            if (_erro)
              Text(
                'Não foi possível salvar a preferência. Tente novamente.',
                style: TextStyle(color: tema.colorScheme.error),
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _pagina == 0 || _salvando
                      ? null
                      : () => setState(() => _pagina--),
                  child: const Text('Voltar'),
                ),
                ElevatedButton(
                  onPressed: _salvando ? null : _avancar,
                  child: Text(ultima ? 'Começar' : 'Avançar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PaginaIntroducao extends StatelessWidget {
  const _PaginaIntroducao({
    required this.icone,
    required this.titulo,
    required this.descricao,
  });

  final IconData icone;
  final String titulo;
  final String descricao;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Painel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icone, size: 56, color: tema.colorScheme.primary),
          const SizedBox(height: 24),
          Text(titulo, style: tema.textTheme.headlineMedium),
          const SizedBox(height: 10),
          Text(descricao, style: tema.textTheme.bodyLarge),
        ],
      ),
    );
  }
}
