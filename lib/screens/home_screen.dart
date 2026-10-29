import 'package:flutter/material.dart';

import 'acerca_screen.dart';
import 'clima_screen.dart';
import 'genero_screen.dart';
import 'persona_screen.dart';
import 'pokemon_screen.dart';
import 'universidades_screen.dart';
import 'wordpress_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_Opcion>[
      _Opcion('Género', Icons.wc, const GeneroScreen()),
      _Opcion('Persona', Icons.person, const PersonaScreen()),
      _Opcion('Universidades', Icons.school, const UniversidadesScreen()),
      _Opcion('Clima RD', Icons.wb_sunny, const ClimaScreen()),
      _Opcion('Pokémon', Icons.catching_pokemon, const PokemonScreen()),
      _Opcion('Noticias WP', Icons.article, const WordPressScreen()),
      _Opcion('Acerca de', Icons.info, const AcercaScreen()),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Caja de Herramientas')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Foto de la caja de herramientas (agrega assets/images/caja_herramientas.png)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/caja_herramientas.png',
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.orange.shade100,
                  child: const Icon(Icons.handyman, size: 100),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                for (final o in items)
                  Card(
                    child: InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => o.pantalla),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(o.icono, size: 48),
                          const SizedBox(height: 8),
                          Text(o.titulo),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Opcion {
  final String titulo;
  final IconData icono;
  final Widget pantalla;
  _Opcion(this.titulo, this.icono, this.pantalla);
}
