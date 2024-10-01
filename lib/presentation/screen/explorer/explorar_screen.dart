import 'package:flutter/material.dart';
import '../../../widgets/map_widget.dart'; // Ajusta el path según la estructura de tu proyecto

class ExplorarScreen extends StatefulWidget {
  const ExplorarScreen({super.key});

  @override
  State<ExplorarScreen> createState() => _ExplorarScreenState();
}

class _ExplorarScreenState extends State<ExplorarScreen> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa Detallado'),
      ),
      body: const MapWidget(), // Usamos el widget del mapa modularizado
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}
