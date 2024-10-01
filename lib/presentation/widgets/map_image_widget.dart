import 'package:flutter/material.dart';

class MapImageWidget extends StatelessWidget {
  const MapImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Sombra detrás de la imagen
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                spreadRadius: 2.0,
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
        // Imagen recortada con borde redondeado
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            'assets/mapa-nicaragua.png', // Asegúrate de que la ruta sea correcta
            width: double.infinity, // Ajusta el ancho al 100% del espacio disponible
            fit: BoxFit.contain, // Mantiene la relación de aspecto de la imagen
          ),
        ),
      ],
    );
  }
}
