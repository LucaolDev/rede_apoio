import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/dados_locais.dart';
import '../models/endereco.dart';
import '../models/recurso.dart';
import '../services/viacep_service.dart';
import '../widgets/componentes.dart';
import '../widgets/endereco_resumo.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key, required this.dados});

  final DadosLocais dados;

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formulario = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _descricao = TextEditingController();
  final _cep = TextEditingController();
  final _numero = TextEditingController();
  final _viaCep = ViaCepService();
  bool _consultando = false;
  Endereco? _endereco;
  String? _erroConsulta;
  bool _salvando = false;
  bool _erroAoSalvar = false;

  @override
  void dispose() {
    _nome.dispose();
    _descricao.dispose();
    _cep.dispose();
    _numero.dispose();
    super.dispose();
  }

  Future<void> _consultarCep() async {
    if (_salvando || _consultando) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _consultando = true;
      _endereco = null;
      _erroConsulta = null;
    });
    try {
      final endereco = await _viaCep.buscarEndereco(_cep.text);
      if (!mounted) return;
      setState(() => _endereco = endereco);
    } catch (erro) {
      if (!mounted) return;
      setState(() {
        _erroConsulta = erro.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) setState(() => _consultando = false);
    }
  }

  void _alterarCep(String _) {
    if (_endereco == null && _erroConsulta == null) return;
    setState(() {
      _endereco = null;
      _erroConsulta = null;
    });
  }

  Future<void> _salvar() async {
    final endereco = _endereco;
    if (_salvando ||
        endereco == null ||
        !_formulario.currentState!.validate()) {
      return;
    }
    setState(() {
      _salvando = true;
      _erroAoSalvar = false;
    });

    final recurso = Recurso(
      nome: _nome.text.trim(),
      descricao: _descricao.text.trim(),
      numero: _numero.text.trim(),
      endereco: endereco,
    );
    try {
      await widget.dados.adicionarRecurso(recurso);
    } catch (_) {
      if (mounted) {
        setState(() {
          _salvando = false;
          _erroAoSalvar = true;
        });
      }
      return;
    }
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final bloqueado = _consultando || _salvando;

    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar recurso')),
      body: ConteudoCentralizado(
        child: Form(
          key: _formulario,
          canPop: !_salvando,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text('Informações do recurso', style: tema.textTheme.titleLarge),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nome,
                enabled: !_salvando,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Nome do recurso'),
                validator: (valor) => (valor ?? '').trim().isEmpty
                    ? 'Informe o nome do recurso.'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descricao,
                enabled: !_salvando,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'O que pode oferecer?',
                ),
                validator: (valor) => (valor ?? '').trim().isEmpty
                    ? 'Descreva o apoio oferecido.'
                    : null,
              ),
              const SizedBox(height: 24),
              Text('Localização', style: tema.textTheme.titleLarge),
              const SizedBox(height: 12),
              TextField(
                controller: _cep,
                enabled: !bloqueado,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.search,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 8,
                onChanged: _alterarCep,
                onSubmitted: (_) => _consultarCep(),
                decoration: const InputDecoration(
                  labelText: 'CEP',
                  hintText: '01001000',
                  counterText: '',
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: bloqueado ? null : _consultarCep,
                child: Text(
                  _erroConsulta != null ? 'Tentar novamente' : 'Consultar CEP',
                ),
              ),
              const SizedBox(height: 12),
              if (_consultando)
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(),
                    SizedBox(height: 8),
                    Text('Consultando o ViaCEP…'),
                  ],
                )
              else if (_erroConsulta != null)
                Text(
                  _erroConsulta!,
                  style: TextStyle(color: tema.colorScheme.error),
                )
              else if (_endereco != null)
                EnderecoResumo(endereco: _endereco!)
              else
                const Text('Consulte o CEP para preencher o endereço.'),
              if (_endereco != null) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: _numero,
                  enabled: !_salvando,
                  decoration: const InputDecoration(
                    labelText: 'Número (opcional)',
                  ),
                ),
              ],
              if (_erroAoSalvar) ...[
                const SizedBox(height: 12),
                Text(
                  'Não foi possível salvar o recurso. Tente novamente.',
                  style: TextStyle(color: tema.colorScheme.error),
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: bloqueado || _endereco == null ? null : _salvar,
                child: Text(_salvando ? 'Salvando…' : 'Salvar recurso'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
