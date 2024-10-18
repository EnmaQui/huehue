// ignore_for_file: library_private_types_in_public_api


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:huehue/enum/StatusRequestEnum.dart';
import 'package:huehue/presentation/blocs/place/place_bloc.dart';
import 'package:huehue/presentation/widgets/list/BaseListWidget.dart';

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

  @override
  void initState() {
    final placeBloc = context.read<PlaceBloc>();

    placeBloc.add(GetPlaceRating(placeIds: departamentos.map((e) => e['placeId'] as String).toList()));

    super.initState();
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
          child: BlocBuilder<PlaceBloc, PlaceState>(
            builder: (context, state) {
              if(state.statusRequestImageUrlsByPlace == StatusRequestEnum.pending) {
                return const Center(child: CircularProgressIndicator.adaptive());
              }

              if(state.imageUrlsByPlace.isEmpty) {
                return const Text('No hay imagenes');
              }

              // if(state.statusRequestImageUrlsByPlace == StatusRequestEnum.error) {
              //   return const Text('Error');
              // }

              return SizedBox(
                  child: BaseListWidget(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: state.imageUrlsByPlace.length,
                    itemBuilder: (context, index) {
                      final departamento = departamentos[index];
                      final imageUrl = state.imageUrlsByPlace[index];
                  
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
                          // margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            // color: sliderColors[widget.colorIndex],
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage(imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                            children: [
                              const AspectRatio(
                                aspectRatio: 16 / 9, 
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
                  ),
                );
            },
          ),
        ),
      ],
    );
  }
}