// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../departments_details_screen.dart'; // Importamos la nueva vista
class DepartmentsSlider extends StatefulWidget {
  final String title;
  final int colorIndex;

  const DepartmentsSlider({required this.title, required this.colorIndex, super.key});

  @override
  _DepartmentsSliderState createState() => _DepartmentsSliderState();
}

class _DepartmentsSliderState extends State<DepartmentsSlider> {
  final List<Map<String, String>> departamentos = [
    {'name': 'Boaco', 'placeId': 'ChIJ2coa6RWhc48RYOiFRtjrwQw'},
    {'name': 'Carazo', 'placeId': 'ChIJXx8sSk8ddI8RU9GmileemrA'},
    {'name': 'Chinandega', 'placeId': 'ChIJP-zXMuzxcI8R7AKWj1Oh4FM'},
    {'name': 'Chontales', 'placeId': 'ChIJX1T9kOljc48RYZWF6uLkKl8'},
    {'name': 'Estelí', 'placeId': 'ChIJrcELwEKMcY8Rb0qVUrMa3pA'},
    {'name': 'Granada', 'placeId': 'ChIJkxVrcJEMdI8RjLTOyE2QjDs'},
    {'name': 'Jinotega', 'placeId': 'ChIJif9XzIg-co8RypZkVTUQu7k'},
    {'name': 'León', 'placeId': 'ChIJd3qPu5IfcY8RPDHqZG_AtTo'},
    {'name': 'Madriz', 'placeId': 'ChIJAWZ_HNXfcY8Rh2uztwRPfpU'},
    {'name': 'Managua', 'placeId': 'ChIJC4gH2Q1WcY8RakxPFKL0Xmw'},
    {'name': 'Masaya', 'placeId': 'ChIJKRUckR0GdI8R0moxUGHN1vI'},
    {'name': 'Matagalpa', 'placeId': 'ChIJLx1W-TBIco8RmdvMt22kkxc'},
    {'name': 'Nueva Segovia', 'placeId': 'ChIJI33IspbkbY8RjIUDRc8qzOE'},
    {'name': 'Rivas', 'placeId': 'ChIJUyYgT8FOdI8RkYf6J6WKeps'},
    {'name': 'Río San Juan', 'placeId': 'ChIJb7BGK67NCo8Rcq6oxf7JuP0'},
    {'name': 'RAAN', 'placeId': 'ChIJ828chdnkEI8RfB3WTR7D8Do'},
    {'name': 'RAAS', 'placeId': 'ChIJ6chW8QYIDI8RpB4DOlSmD1k'},
  ];
  
    late Future<List<String>> _imageUrls;

Future<List<String>> fetchImageUrls() async {
    List<String> imageUrls = [];
    
    for (var departamento in departamentos) {
      final response = await http.get(Uri.parse(
          'https://maps.googleapis.com/maps/api/place/details/json?fields=name,rating,photos&place_id=${departamento['placeId']}&key=AIzaSyCNNLly_rF6NkMMgoFAl5dv8lfCmu00mnY'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['result'] != null && data['result']['photos'] != null && data['result']['photos'].isNotEmpty) {
          // Solo añade la URL de la primera foto (si existe)
          String photoReference = data['result']['photos'][5]['photo_reference'];
          String imageUrl =
    'https://maps.googleapis.com/maps/api/place/photo?maxwidth=1280&maxheight=720&photoreference=$photoReference&key=AIzaSyCNNLly_rF6NkMMgoFAl5dv8lfCmu00mnY';
          imageUrls.add(imageUrl);
        } else {
          // Añadir una URL por defecto o manejar el caso sin fotos
          imageUrls.add('https://via.placeholder.com/1280'); // URL de imagen de placeholder
        }
      } else {
        // Manejo de error, agregar una URL por defecto
        imageUrls.add('https://via.placeholder.com/1280');
      }
    }
    
    return imageUrls;
  }
  // El método fetchImageUrls sigue igual...

  @override
  void initState() {
    super.initState();
    _imageUrls = fetchImageUrls();
  }

  @override
  Widget build(BuildContext context) {
        final List<Color> sliderColors = [
      const Color(0xFFf0436d),
      const Color(0xFFf37a6f),
      const Color(0xFFebd36e),
    ];

    final double screenWidth = MediaQuery.of(context).size.width;
    final double containerWidth = screenWidth * 0.8;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: sliderColors[widget.colorIndex],
            ),
          ),
        ),
        SizedBox(
          height: 177,
          child: FutureBuilder<List<String>>(
            future: _imageUrls,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error al cargar imágenes'));
              } else {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: departamentos.length,
                  itemBuilder: (context, index) {
                    final departamento = departamentos[index];
                    final imageUrl = snapshot.data![index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlaceDetailsScreen(placeId: departamento['placeId']!),
                          ),
                        );
                      },

                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        width: containerWidth,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: sliderColors[widget.colorIndex],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          children: [
                            AspectRatio(
                              aspectRatio: 16 / 9, 
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(child: Icon(Icons.error));
                                },
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4.0),
                                color: Colors.black54,
                                child: Text(
                                  departamento['name']!,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}