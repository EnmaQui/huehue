import 'package:flutter/material.dart';

import '../../widgets/map_image_widget.dart';
import '../../widgets/random_phrase_widget.dart';
import '../../widgets/title_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
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
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Permite el desplazamiento si es necesario
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
  
  @override
  bool get wantKeepAlive => true;
}
