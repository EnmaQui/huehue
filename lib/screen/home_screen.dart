import 'package:flutter/material.dart';

import '../widgets/map_image_widget.dart';
import '../widgets/random_phrase_widget.dart';
import '../widgets/title_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inicio',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Permite el desplazamiento si es necesario
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              TitleWidget(), // Añadir const aquí si TitleWidget es inmutable
              SizedBox(height: 20),
              MapImageWidget(), // Añadir const si es posible
              SizedBox(height: 20),
              RandomPhraseWidget(), // const ya presente
            ],
          ),
        ),
      ),
      backgroundColor: Colors.lightGreen[50],
    );
  }
}
