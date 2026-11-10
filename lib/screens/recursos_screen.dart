import 'package:flutter/material.dart';

import '../data/dados_locais.dart';
import '../models/recurso.dart';
import '../widgets/componentes.dart';
import 'cadastro_screen.dart';
import 'detalhe_screen.dart';

class RecursosScreen extends StatefulWidget {
  const RecursosScreen({super.key, required this.dados});

  final DadosLocais dados;

  @override
  State<RecursosScreen> createState() => _RecursosScreenState();
}

class _RecursosScreenState extends State<RecursosScreen> {
  List<Recurso> _recursos = [];
  String _busca = '';
  bool _carregando = true;
  bool _erro = false;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() {
      _carregando = true;
      _erro = false;
    });
    try {
      final recursos = await widget.dados.listarRecursos();
      if (!mounted) return;
      setState(() {
        _recursos = recursos;
        _carregando = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _erro = true;
        _carregando = false;
      });
    }
  }

  Future<void> _abrirCadastro() async {
    final cadastrado = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => CadastroScreen(dados: widget.dados),
      ),
    );
    if (!mounted || cadastrado != true) return;
    setState(() => _busca = '');
    await _carregar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recursos'),
        actions: [
          IconButton(
            onPressed: _carregando ? null : _abrirCadastro,
            tooltip: 'Cadastrar recurso',
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ConteudoCentralizado(child: _conteudo()),
    );
  }

  Widget _conteudo() {
    if (_carregando) return const Center(child: CircularProgressIndicator());
    if (_erro) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Não foi possível carregar os registros locais.'),
            TextButton(
              onPressed: _carregar,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }
    if (_recursos.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Painel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.inventory_2_outlined, size: 36),
                const SizedBox(height: 12),
                const Text(
                  'Nenhum recurso cadastrado.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _abrirCadastro,
                  child: const Text('Cadastrar recurso'),
                ),
              ],
            ),
          ),
        ],
      );
    }

    final visiveis = _recursos
        .where((recurso) => recurso.correspondeA(_busca))
        .toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: TextField(
            onChanged: (valor) => setState(() => _busca = valor),
            decoration: const InputDecoration(
              labelText: 'Buscar recursos',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        Expanded(
          child: visiveis.isEmpty
              ? const Center(child: Text('Nenhum recurso corresponde à busca.'))
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                  itemCount: visiveis.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, indice) {
                    final recurso = visiveis[indice];
                    return Card(
                      margin: EdgeInsets.zero,
                      child: ListTile(
                        leading: const Icon(Icons.place_outlined),
                        title: Text(recurso.nome),
                        subtitle: Text(recurso.endereco.municipio),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => DetalheScreen(recurso: recurso),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
