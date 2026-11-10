import 'package:flutter/material.dart';

import 'data/dados_locais.dart';
import 'screens/splash_screen.dart';

void main() => runApp(const RedeApoioApp());

class RedeApoioApp extends StatelessWidget {
  const RedeApoioApp({super.key});

  @override
  Widget build(BuildContext context) {
    const fundo = Color(0xFFF4F7F2);
    final cores = ColorScheme.fromSeed(seedColor: const Color(0xFF245849));

    return MaterialApp(
      title: 'Rede de Apoio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: cores,
        scaffoldBackgroundColor: fundo,
        appBarTheme: const AppBarTheme(
          backgroundColor: fundo,
          scrolledUnderElevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: cores.surface,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: cores.primary,
            foregroundColor: cores.onPrimary,
            minimumSize: const Size(0, 48),
          ),
        ),
      ),
      home: SplashScreen(dados: DadosLocais()),
    );
  }
}
