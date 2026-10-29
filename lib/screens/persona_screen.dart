import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PersonaScreen extends StatefulWidget {
  const PersonaScreen({super.key});

  @override
  State<PersonaScreen> createState() => _PersonaScreenState();
}

class _PersonaScreenState extends State<PersonaScreen> {
  Map<String, dynamic>? _persona;
  bool _cargando = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final res = await http
          .get(Uri.parse('https://randomuser.me/api/?results=1'));
      final data = jsonDecode(res.body);
      setState(() => _persona = data['results'][0]);
    } catch (e) {
      setState(() => _error = 'No se pudo cargar la persona');
    } finally {
      setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget cuerpo;
    if (_cargando) {
      cuerpo = const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      cuerpo = Center(child: Text(_error!));
    } else if (_persona == null) {
      cuerpo = const SizedBox();
    } else {
      final p = _persona!;
      final fecha = DateTime.parse(p['dob']['date']);
      cuerpo = Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 70,
              backgroundImage: NetworkImage(p['picture']['large']),
            ),
            const SizedBox(height: 16),
            Text('Nombre: ${p['name']['first']}',
                style: const TextStyle(fontSize: 20)),
            Text('Apellido: ${p['name']['last']}',
                style: const TextStyle(fontSize: 20)),
            Text('Nacimiento: ${DateFormat('dd/MM/yyyy').format(fecha)}',
                style: const TextStyle(fontSize: 20)),
            Text('Edad: ${p['dob']['age']} años',
                style: const TextStyle(fontSize: 20)),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Persona aleatoria')),
      body: cuerpo,
      floatingActionButton: FloatingActionButton(
        onPressed: _cargar,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
