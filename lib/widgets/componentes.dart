import 'package:flutter/material.dart';

class ConteudoCentralizado extends StatelessWidget {
  const ConteudoCentralizado({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 580),
          child: child,
        ),
      ),
    );
  }
}

class Painel extends StatelessWidget {
  const Painel({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: cores.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: cores.outlineVariant),
      ),
      child: Padding(padding: const EdgeInsets.all(20), child: child),
    );
  }
}

class MarcaApp extends StatelessWidget {
  const MarcaApp({super.key, required this.tamanho});

  final double tamanho;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/rede_apoio.png',
      width: tamanho,
      height: tamanho,
      excludeFromSemantics: true,
    );
  }
}
