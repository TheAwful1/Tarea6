import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PokemonScreen extends StatefulWidget {
  const PokemonScreen({super.key});

  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  final _controller = TextEditingController();
  final _player = AudioPlayer();
  Map<String, dynamic>? _pokemon;
  bool _cargando = false;
  String? _error;

  Future<void> _buscar() async {
    final nombre = _controller.text.trim().toLowerCase();
    if (nombre.isEmpty) return;
    setState(() {
      _cargando = true;
      _error = null;
      _pokemon = null;
    });
    try {
      final res = await http
          .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$nombre'));
      if (res.statusCode != 200) {
        setState(() => _error = 'Pokémon no encontrado');
      } else {
        setState(() => _pokemon = jsonDecode(res.body));
      }
    } catch (e) {
      setState(() => _error = 'Error de conexión');
    } finally {
      setState(() => _cargando = false);
    }
  }

  Future<void> _sonido() async {
    final url = _pokemon?['cries']?['latest'];
    if (url == null) return;
    await _player.play(UrlSource(url));
  }

  @override
  void dispose() {
    _controller.dispose();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = _pokemon;
    return Scaffold(
      appBar: AppBar(title: const Text('Pokémon')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Nombre del Pokémon (ej. pikachu)',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _buscar(),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: _buscar, child: const Text('Buscar')),
            const SizedBox(height: 16),
            if (_cargando) const CircularProgressIndicator(),
            if (_error != null) Text(_error!),
            if (p != null) ...[
              Image.network(
                p['sprites']['other']?['official-artwork']
                        ?['front_default'] ??
                    p['sprites']['front_default'],
                height: 200,
              ),
              Text(p['name'].toString().toUpperCase(),
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold)),
              Text('Experiencia base: ${p['base_experience']}',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              const Text('Habilidades:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              for (final a in p['abilities'])
                Text('• ${a['ability']['name']}'),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _sonido,
                icon: const Icon(Icons.volume_up),
                label: const Text('Reproducir sonido'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
