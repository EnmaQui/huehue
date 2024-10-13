import 'package:flutter/material.dart';

class CategorySlider extends StatelessWidget {
  final String title;
  final int colorIndex;

  const CategorySlider({required this.title, required this.colorIndex, super.key});

  @override
  Widget build(BuildContext context) {
    final List<Color> sliderColors = [
      const Color(0xFFff6f61), // Color 1
      const Color(0xFF6b5b95), // Color 2
      const Color(0xFF88b04b), // Color 3
    ];

    // Lista de categorías y sus íconos correspondientes
    final List<Map<String, dynamic>> categories = [
      {'name': 'Iglesias', 'icon': Icons.church},
      {'name': 'Restaurantes', 'icon': Icons.restaurant},
      {'name': 'Monumentos', 'icon': Icons.museum},
      {'name': 'Edificios históricos', 'icon': Icons.history_edu},
      {'name': 'Playas', 'icon': Icons.beach_access},
      {'name': 'Reservas Naturales', 'icon': Icons.nature},
      {'name': 'Parques', 'icon': Icons.park},
      {'name': 'Tiendas de conveniencia', 'icon': Icons.shopping_cart},
      {'name': 'Centros comerciales', 'icon': Icons.shopping_basket},
      {'name': 'Volcanes', 'icon': Icons.explore},
      {'name': 'Montañas', 'icon': Icons.landscape},
      {'name': 'Islas', 'icon': Icons.landscape},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: sliderColors[colorIndex],
            ),
          ),
        ),
        SizedBox(
          height: 100, // Mantén la altura del slider
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length, // Cambia a la longitud de la lista de categorías
            itemBuilder: (context, index) {
              return Container(
                width: 80, // Ancho más amplio para un diseño más atractivo
                height: 120, // Altura más grande para la elipse vertical
                margin: const EdgeInsets.symmetric(horizontal: 8), // Mayor separación entre íconos
                decoration: BoxDecoration(
                  color: sliderColors[colorIndex],
                  borderRadius: BorderRadius.circular(20), // Radio moderado para suavizar los bordes
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // Sombra para profundidad
                      blurRadius: 6,
                      spreadRadius: 2,
                      offset: const Offset(2, 2), 
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      categories[index]['icon'], // Usa el icono correspondiente
                      color: Colors.white,
                      size: 45, // Tamaño del icono un poco más grande
                    ),
                    const SizedBox(height: 5), // Espacio entre el icono y el texto
                    Text(
                      categories[index]['name'], // Muestra el nombre de la categoría
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.center, // Centra el texto
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
