import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ClimaScreen extends StatefulWidget {
  const ClimaScreen({super.key});

  @override
  State<ClimaScreen> createState() => _ClimaScreenState();
}

class _ClimaScreenState extends State<ClimaScreen> {
  // Santo Domingo, República Dominicana (Open-Meteo, sin API key)
  static const _url =
      'https://api.open-meteo.com/v1/forecast?latitude=18.4861&longitude=-69.9312'
      '&current=temperature_2m'
      '&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max'
      '&timezone=America%2FSanto_Domingo&forecast_days=1';

  Map<String, dynamic>? _data;
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    try {
      final res = await http.get(Uri.parse(_url));
      setState(() => _data = jsonDecode(res.body));
    } catch (e) {
      setState(() => _error = 'No se pudo cargar el clima');
    } finally {
      setState(() => _cargando = false);
    }
  }

  String _descripcion(int code) {
    if (code == 0) return 'Despejado';
    if (code <= 3) return 'Parcialmente nublado';
    if (code <= 48) return 'Niebla';
    if (code <= 57) return 'Llovizna';
    if (code <= 67) return 'Lluvia';
    if (code <= 77) return 'Nieve';
    if (code <= 82) return 'Chubascos';
    if (code <= 99) return 'Tormenta eléctrica';
    return 'Desconocido';
  }

  IconData _icono(int code) {
    if (code == 0) return Icons.wb_sunny;
    if (code <= 3) return Icons.wb_cloudy;
    if (code <= 67) return Icons.grain;
    if (code <= 82) return Icons.water_drop;
    return Icons.thunderstorm;
  }

  @override
  Widget build(BuildContext context) {
    Widget cuerpo;
    if (_cargando) {
      cuerpo = const Center(child: CircularProgressIndicator());
    } else if (_error != null || _data == null) {
      cuerpo = Center(child: Text(_error ?? 'Sin datos'));
    } else {
      final d = _data!['daily'];
      final code = (d['weather_code'][0] as num).toInt();
      cuerpo = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Santo Domingo, RD', style: TextStyle(fontSize: 22)),
            Text(DateFormat('dd/MM/yyyy').format(DateTime.now())),
            const SizedBox(height: 16),
            Icon(_icono(code), size: 100, color: Colors.orange),
            Text(_descripcion(code), style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            Text('Ahora: ${_data!['current']['temperature_2m']} °C',
                style: const TextStyle(fontSize: 20)),
            Text('Máx: ${d['temperature_2m_max'][0]} °C   '
                'Mín: ${d['temperature_2m_min'][0]} °C'),
            Text(
                'Prob. de lluvia: ${d['precipitation_probability_max'][0]} %'),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Clima en RD')),
      body: cuerpo,
    );
  }
}
