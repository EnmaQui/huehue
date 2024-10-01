import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Bienvenido a la aplicación Mapa Interactivo de Nicaragua',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.teal[700], // Color del texto
      ),
      textAlign: TextAlign.center,
    );
  }
}
