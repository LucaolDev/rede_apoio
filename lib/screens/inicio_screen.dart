import 'package:flutter/material.dart';

import '../data/dados_locais.dart';
import '../widgets/componentes.dart';
import 'recursos_screen.dart';

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key, required this.dados});

  final DadosLocais dados;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Início')),
      body: ConteudoCentralizado(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: MarcaApp(tamanho: 68),
            ),
            const SizedBox(height: 20),
            Text('Rede de Apoio', style: tema.textTheme.headlineLarge),
            const SizedBox(height: 8),
            Text(
              'Organize os recursos da sua comunidade para situações de emergência.',
              style: tema.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Painel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Recursos comunitários',
                    style: tema.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Consulte ou cadastre um local e descreva o apoio que ele pode oferecer.',
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => RecursosScreen(dados: dados),
                      ),
                    ),
                    icon: const Icon(Icons.list_alt_outlined),
                    label: const Text('Abrir lista de recursos'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
