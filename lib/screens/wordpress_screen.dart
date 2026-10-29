import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class WordPressScreen extends StatefulWidget {
  const WordPressScreen({super.key});

  @override
  State<WordPressScreen> createState() => _WordPressScreenState();
}

class _WordPressScreenState extends State<WordPressScreen> {
  // API de WordPress usada (publícala en el foro):
  // https://wordpress.org/news/wp-json/wp/v2/posts?per_page=3
  static const _api = 'https://wordpress.org/news/wp-json/wp/v2/posts?per_page=3';
  static const _logo =
      'https://s.w.org/style/images/about/WordPress-logotype-standard.png';

  List<dynamic> _posts = [];
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    try {
      final res = await http.get(Uri.parse(_api));
      setState(() => _posts = jsonDecode(res.body));
    } catch (e) {
      setState(() => _error = 'No se pudieron cargar las noticias');
    } finally {
      setState(() => _cargando = false);
    }
  }

  // Quita etiquetas HTML y entidades básicas del resumen.
  String _limpiar(String html) => html
      .replaceAll(RegExp(r'<[^>]*>'), '')
      .replaceAll('&hellip;', '...')
      .replaceAll('&#8217;', "'")
      .replaceAll('&#8211;', '-')
      .replaceAll('&amp;', '&')
      .trim();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Noticias WordPress')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Image.network(_logo, height: 80),
          const SizedBox(height: 16),
          if (_cargando) const Center(child: CircularProgressIndicator()),
          if (_error != null) Text(_error!),
          for (final p in _posts)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_limpiar(p['title']['rendered']),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(_limpiar(p['excerpt']['rendered'])),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => launchUrl(Uri.parse(p['link']),
                            mode: LaunchMode.externalApplication),
                        child: const Text('Visitar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
