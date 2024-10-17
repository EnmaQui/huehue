import 'package:flutter/material.dart';

import '../pruebas/widgets/category_slider.dart';
import '../pruebas/widgets/departments_slider.dart';
import '../pruebas/widgets/image_list.dart';
import '../pruebas/widgets/top_image_widget.dart'; // Importamos los widgets

class PruebasScreen extends StatelessWidget {
  const PruebasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            pinned: true,
            expandedHeight: 200,
            elevation: 0,
            centerTitle: false,
            stretch: true,
            title: const Text('Catedral de Leon'),
            titleTextStyle: Theme.of(context).textTheme.headlineSmall,
            flexibleSpace: const FlexibleSpaceBar(
              background: Image(
                image: AssetImage('assets/catedral.jpg'),
                fit: BoxFit.cover,
              ), // Usamos TopImageWidget
            ),
          ),
          SliverAppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            pinned: true,
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(50), child: SizedBox(),
            ),
            flexibleSpace: const CategorySlider(title: "Categorías", colorIndex: 0),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              DepartmentsSlider(title: "Departamentos", colorIndex: 1),  // Slider 2
              // SizedBox(height: 20),
              // Padding(
              //   padding: EdgeInsets.all(8.0),
              //   child: Text(
              //     'Lugares más visitados',
              //     style: TextStyle(
              //       fontSize: 18,
              //       fontWeight: FontWeight.bold,
              //       color: Color(0xFF0e647e),
              //     ),
              //   ),
              // ),
              // ImageList(),  // Lista de imágenes
            ],),
          )
        ],
      ),
    );
  }
}
