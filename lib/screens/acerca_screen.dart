import 'package:flutter/material.dart';

class AcercaScreen extends StatelessWidget {
  const AcercaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Agrega tu foto en assets/images/tu_foto.png
            CircleAvatar(
              radius: 80,
              backgroundColor: Colors.orange.shade100,
              backgroundImage: const AssetImage('assets/images/tu_foto.png'),
              onBackgroundImageError: (_, __) {},
              child: const Icon(Icons.person, size: 60),
            ),
            const SizedBox(height: 16),
            const Text('Edwin Felipe De La Cruz Montero',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Desarrollador de software'),
            const SizedBox(height: 24),
            const Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.email),
                    title: Text('feliudd04@gmail.com'),
                  ),
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: Text('+1 (000) 000-0000'), // pon tu teléfono
                  ),
                  ListTile(
                    leading: Icon(Icons.link),
                    title: Text('github.com/tu-usuario'), // pon tu GitHub
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text('Disponible para posibles trabajos'),
          ],
        ),
      ),
    );
  }
}
