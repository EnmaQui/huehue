import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageList extends StatefulWidget {
  const ImageList({super.key});

  @override
  _ImageListState createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  final String apiKey = 'AIzaSyCNNLly_rF6NkMMgoFAl5dv8lfCmu00mnY'; // Reemplaza con tu clave de API
  late Future<List<Place>> _places;

  @override
  void initState() {
    super.initState();
    _places = fetchPopularPlaces();
  }

  Future<List<Place>> fetchPopularPlaces() async {
    final response = await http.get(Uri.parse(
      'https://maps.googleapis.com/maps/api/place/textsearch/json?query=tourist+attractions+in+Nicaragua&key=$apiKey',
    ));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Place> places = [];
      for (var result in data['results']) {
        places.add(Place.fromJson(result));
      }
      return places;
    } else {
      throw Exception('Failed to load places');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Place>>(
      future: _places,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error al cargar lugares'));
        } else {
          final places = snapshot.data!;

          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: places.length,
            itemBuilder: (context, index) {
              return Container(
                height: 150,
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // Aquí se utiliza la imagen de fondo
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${places[index].photoReference}&key=$apiKey',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black54, // Fondo negro semi-transparente
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          places[index].name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            buildStarRating(places[index].rating),
                            const SizedBox(width: 8),
                            Text(
                              '${places[index].rating?.toStringAsFixed(1) ?? 'N/A'}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  // Método para construir estrellas
  Widget buildStarRating(double? rating) {
    if (rating == null) return Container(); // No mostrar nada si no hay rating
    List<Widget> stars = [];
    for (var i = 0; i < 5; i++) {
      if (i < rating.floor()) {
        stars.add(const Icon(Icons.star, color: Colors.yellow));
      } else if (i < rating) {
        stars.add(const Icon(Icons.star_half, color: Colors.yellow));
      } else {
        stars.add(const Icon(Icons.star_border, color: Colors.yellow));
      }
    }
    return Row(children: stars);
  }
}

class Place {
  final String name;
  final String photoReference;
  final double? rating;

  Place({required this.name, required this.photoReference, this.rating});

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      name: json['name'],
      photoReference: json['photos'] != null ? json['photos'][0]['photo_reference'] : '',
      rating: json['rating']?.toDouble(),
    );
  }
}
