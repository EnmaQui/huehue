import 'package:flutter/material.dart';
import '../widgets/map_widget.dart'; // Ajusta el path según la estructura de tu proyecto

class ExplorarScreen extends StatelessWidget {
  const ExplorarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa Detallado'),
      ),
      body: const MapWidget(), // Usamos el widget del mapa modularizado
    );
  }
}
