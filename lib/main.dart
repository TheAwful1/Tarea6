import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() => runApp(const HerramientasApp());

class HerramientasApp extends StatelessWidget {
  const HerramientasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caja de Herramientas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.orange,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
