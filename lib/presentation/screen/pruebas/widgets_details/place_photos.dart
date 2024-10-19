import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huehue/const/data.const.dart';

import '../widgets_details/fullscreen_image.dart'; // Importamos el nuevo widget

class PlacePhotos extends StatelessWidget {
  final List<dynamic> photos;

  const PlacePhotos({required this.photos, super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CarouselSlider.builder(
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        autoPlayInterval: const Duration(seconds: 3),
      ),
      itemCount: photos.length > 20 ? 20 : photos.length, // Limita a 20 fotos
      itemBuilder: (BuildContext context, int index, int realIndex) {
        String imageUrl =
            'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${photos[index]}&key=${DataConst.googleApiKey}';

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
              decoration: const BoxDecoration(
                boxShadow:  [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4), // Sombra debajo de la imagen
                  ),
                ],
              ),
              child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: CachedNetworkImage(
                                          width: double.infinity,
                                          height: size.height * 0.20,
                                          imageUrl: imageUrl,
                                          fit: BoxFit.cover,
                                          progressIndicatorBuilder:
                                              (context, url, progress) =>
                                                  const Center(
                                            child: CupertinoActivityIndicator(),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Center(
                                            child: Icon(Icons.error),
                                          ),
                                        ),
                                      ),
            ),
          ),
        );
      },
    );
  }
}
