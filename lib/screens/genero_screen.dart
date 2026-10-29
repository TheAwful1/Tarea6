import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GeneroScreen extends StatefulWidget {
  const GeneroScreen({super.key});

  @override
  State<GeneroScreen> createState() => _GeneroScreenState();
}

class _GeneroScreenState extends State<GeneroScreen> {
  final _controller = TextEditingController();
  Color _fondo = Colors.white;
  String _mensaje = 'Escribe un nombre y presiona Predecir';
  bool _cargando = false;

  Future<void> _predecir() async {
    final nombre = _controller.text.trim();
    if (nombre.isEmpty) return;
    setState(() => _cargando = true);
    try {
      final uri = Uri.https('api.genderize.io', '/', {'name': nombre});
      final res = await http.get(uri);
      final data = jsonDecode(res.body);
      final genero = data['gender'];
      setState(() {
        if (genero == 'male') {
          _fondo = Colors.blue.shade200;
          _mensaje = '$nombre: masculino';
        } else {
          _fondo = Colors.pink.shade200;
          _mensaje = genero == null
              ? '$nombre: no se pudo determinar (rosa por defecto)'
              : '$nombre: femenino';
        }
      });
    } catch (e) {
      setState(() => _mensaje = 'Error de conexión');
    } finally {
      setState(() => _cargando = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Predecir género')),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        color: _fondo,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              onSubmitted: (_) => _predecir(),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _cargando ? null : _predecir,
              child: const Text('Predecir'),
            ),
            const SizedBox(height: 24),
            if (_cargando) const CircularProgressIndicator(),
            Text(_mensaje, style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
