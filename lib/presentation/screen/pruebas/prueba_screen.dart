import 'package:flutter/material.dart';
import 'package:huehue/const/assent.const.dart';

import '../pruebas/widgets/category_slider.dart';
import '../pruebas/widgets/departments_slider.dart';
import '../pruebas/widgets/image_list.dart';
import '../pruebas/widgets/top_image_widget.dart'; // Importamos los widgets

class PruebasScreen extends StatefulWidget  {
  const PruebasScreen({super.key});

  @override
  State<PruebasScreen> createState() => _PruebasScreenState();
}

class _PruebasScreenState extends State<PruebasScreen>  with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    
    super.build(context);

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
                image: AssetImage(AsssentConst.catedral),
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
              const DepartmentsSlider(title: "Departamentos", colorIndex: 1),  // Slider 2
              const SizedBox(height: 20),
              const Padding(
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
              const ImageList(),  // Lista de imágenes
            ],),
          )
        ],
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}
