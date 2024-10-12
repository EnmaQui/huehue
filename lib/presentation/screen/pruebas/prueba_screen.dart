import 'package:flutter/material.dart';

import '../pruebas/widgets/category_slider.dart';
import '../pruebas/widgets/departments_slider.dart';
import '../pruebas/widgets/image_list.dart';
import '../pruebas/widgets/top_image_widget.dart';  // Importamos los widgets

class PruebasScreen extends StatelessWidget {
  const PruebasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopImageWidget(imagePath: 'assets/catedral.jpg'),  // Imagen superior
            SizedBox(height: 20),
            CategorySlider(title: "Categorías", colorIndex: 0),  // Slider 1
            SizedBox(height: 20),
            DepartmentsSlider(title: "Departamentos", colorIndex: 1),  // Slider 2
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Lugares más visitados',
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0e647e),
                ),
              ),
            ),
            ImageList(),  // Lista de imágenes
          ],
        ),
      ),
    );
  }
}
