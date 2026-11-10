import 'package:flutter/material.dart';

import '../data/dados_locais.dart';
import '../widgets/componentes.dart';
import 'inicio_screen.dart';
import 'introducao_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.dados});

  final DadosLocais dados;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _erro = false;

  @override
  void initState() {
    super.initState();
    _iniciar();
  }

  Future<void> _iniciar() async {
    if (_erro) setState(() => _erro = false);
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;

    try {
      final pular = await widget.dados.lerPreferenciaIntroducao();
      if (!mounted) return;
      final proximaTela = pular == true
          ? InicioScreen(dados: widget.dados)
          : IntroducaoScreen(dados: widget.dados);
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute<void>(builder: (_) => proximaTela));
    } catch (_) {
      if (mounted) setState(() => _erro = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const MarcaApp(tamanho: 100),
              const SizedBox(height: 16),
              Text(
                'Rede de Apoio',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              if (_erro) ...[
                const Text('Não foi possível ler a preferência de introdução.'),
                TextButton(
                  onPressed: _iniciar,
                  child: const Text('Tentar novamente'),
                ),
              ] else
                const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
