import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class UniversidadesScreen extends StatefulWidget {
  const UniversidadesScreen({super.key});

  @override
  State<UniversidadesScreen> createState() => _UniversidadesScreenState();
}

class _UniversidadesScreenState extends State<UniversidadesScreen> {
  final _controller = TextEditingController(text: 'Dominican Republic');
  List<dynamic> _universidades = [];
  bool _cargando = false;
  String? _error;

  Future<void> _buscar() async {
    final pais = _controller.text.trim();
    if (pais.isEmpty) return;
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final uri =
          Uri.https('adamix.net', '/proxy.php', {'country': pais});
      final res = await http.get(uri);
      final data = jsonDecode(res.body);
      setState(() => _universidades = data is List ? data : []);
      if (_universidades.isEmpty) {
        setState(() => _error = 'No se encontraron universidades');
      }
    } catch (e) {
      setState(() => _error = 'Error de conexión');
    } finally {
      setState(() => _cargando = false);
    }
  }

  Future<void> _abrir(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Universidades')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'País (en inglés)',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _buscar(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(onPressed: _buscar, child: const Text('Buscar')),
              ],
            ),
          ),
          if (_cargando) const LinearProgressIndicator(),
          if (_error != null) Text(_error!),
          Expanded(
            child: ListView.builder(
              itemCount: _universidades.length,
              itemBuilder: (_, i) {
                final u = _universidades[i];
                final dominios = (u['domains'] as List?)?.join(', ') ?? '';
                final webs = (u['web_pages'] as List?) ?? [];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    title: Text(u['name'] ?? ''),
                    subtitle: Text('Dominio: $dominios'),
                    trailing: webs.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.open_in_new),
                            tooltip: webs.first.toString(),
                            onPressed: () => _abrir(webs.first.toString()),
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
