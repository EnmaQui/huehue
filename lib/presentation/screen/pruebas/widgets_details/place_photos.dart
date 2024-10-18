import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../widgets_details/fullscreen_image.dart'; // Importamos el nuevo widget

class PlacePhotos extends StatelessWidget {
  final List<dynamic> photos;

  const PlacePhotos({required this.photos, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(
            left: 12,
          ),
          child: Text(
            "Galería de fotos",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),

        // Carrusel de imágenes
        CarouselSlider.builder(
          options: CarouselOptions(
            height: 200,
            autoPlay: true,
            enlargeCenterPage: true,
            enableInfiniteScroll: true,
            aspectRatio: 16 / 9,
            viewportFraction: 0.8,
            autoPlayInterval: const Duration(seconds: 3),
          ),
          itemCount:
              photos.length > 20 ? 20 : photos.length, // Limita a 20 fotos
          itemBuilder: (BuildContext context, int index, int realIndex) {
            String imageUrl =
                'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${photos[index]['photo_reference']}&key=AIzaSyCNNLly_rF6NkMMgoFAl5dv8lfCmu00mnY';

            return GestureDetector(
              onTap: () {
                // Navega a la vista de pantalla completa
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullScreenImage(imageUrl: imageUrl),
                  ),
                );
              },
              child: Hero(
                tag: imageUrl,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4), // Sombra debajo de la imagen
                      ),
                    ],
                    borderRadius:
                        BorderRadius.circular(15), // Bordes redondeados
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 10),
      ],
    );
  }
}
