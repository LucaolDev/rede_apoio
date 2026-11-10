import 'package:flutter/material.dart';

import '../models/recurso.dart';
import '../widgets/componentes.dart';
import '../widgets/endereco_resumo.dart';

class DetalheScreen extends StatelessWidget {
  const DetalheScreen({super.key, required this.recurso});

  final Recurso recurso;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhe do recurso')),
      body: ConteudoCentralizado(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(recurso.nome, style: tema.textTheme.headlineMedium),
            const SizedBox(height: 20),
            Painel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Apoio oferecido', style: tema.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(recurso.descricao),
                ],
              ),
            ),
            const SizedBox(height: 12),
            EnderecoResumo(endereco: recurso.endereco, numero: recurso.numero),
          ],
        ),
      ),
    );
  }
}
