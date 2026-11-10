import 'package:flutter/material.dart';

import '../models/endereco.dart';
import 'componentes.dart';

class EnderecoResumo extends StatelessWidget {
  const EnderecoResumo({super.key, required this.endereco, this.numero = ''});

  final Endereco endereco;
  final String numero;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final linha = [
      endereco.logradouro,
      numero,
    ].where((parte) => parte.isNotEmpty).join(', ');

    return Painel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.place_outlined, color: tema.colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Endereço', style: tema.textTheme.titleMedium),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (linha.isNotEmpty) Text(linha),
          if (endereco.bairro.isNotEmpty) Text(endereco.bairro),
          Text(endereco.municipio),
          Text('CEP ${endereco.cep}'),
        ],
      ),
    );
  }
}
