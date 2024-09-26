import 'package:flutter/material.dart';
import '../widgets/title_widget.dart';
import '../widgets/map_image_widget.dart';
import '../widgets/random_phrase_widget.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inicio',
          style: TextStyle(
            color: Colors.white, // Color del texto
            fontWeight: FontWeight.bold, // Hacer el texto más grueso
            fontSize: 20, // Tamaño de la fuente (ajusta según lo que necesites)
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal, // Color de fondo del AppBar
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TitleWidget(),
            SizedBox(height: 20),
            MapImageWidget(),
            SizedBox(height: 20),
            RandomPhraseWidget(),
          ],
        ),
      ),
      // Estilo del fondo
      backgroundColor: Colors.lightGreen[50],
    );
  }
}
