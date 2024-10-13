import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../pruebas/widgets_maps/categorias_widget.dart';
import '../pruebas/widgets_maps/detalles_widget.dart';
import '../pruebas/widgets_maps/lista_lugares.dart';
import '../pruebas/widgets_maps/map_widget.dart';

class MapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String placeId;

  const MapScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.placeId,
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}
class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  List<Polyline> polylines = [];
  Set<Marker> markers = {};
  String selectedCategory = 'Iglesias';
  List<dynamic> places = [];
  bool isLoadingPlaces = true;
  dynamic selectedPlace;
  double? userLatitude; // Para almacenar la latitud del usuario
  double? userLongitude; // Para almacenar la longitud del usuario

  @override
  void initState() {
    super.initState();
    _getUserLocation(); // Obtener la ubicación del usuario
  }


  // Método para obtener la ubicación del usuario
  Future<void> _getUserLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Manejar el caso en que el permiso es denegado
      return;
    }
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      userLatitude = position.latitude;
      userLongitude = position.longitude;
    });
    fetchNearbyPlaces(); // Llama a la función para obtener lugares cercanos
  }




Future<void> fetchNearbyPlaces() async {
  const String apiKey = 'AIzaSyCNNLly_rF6NkMMgoFAl5dv8lfCmu00mnY';
  final String type = _getTypeFromCategory(selectedCategory); // Función para obtener el tipo correcto
  final double latitude = widget.latitude;
  final double longitude = widget.longitude;

  final url = Uri.parse(
    'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=1500&type=$type&key=$apiKey',
  );

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        places = data['results'];
        isLoadingPlaces = false;
      });
    } else {
      throw Exception('Error al obtener lugares cercanos');
    }
  } catch (error) {
    setState(() {
      isLoadingPlaces = false;
    });
    print('Error en fetchNearbyPlaces: $error');
  }
}

String _getTypeFromCategory(String category) {
  switch (category) {
    case 'Iglesias':
      return 'church'; // Tipo correspondiente a Iglesias
    case 'Restaurantes':
      return 'restaurant'; // Tipo correspondiente a Restaurantes
    case 'Monumentos':
      return 'museum'; // Tipo correspondiente a Monumentos
    case 'Edificios históricos':
      return 'point_of_interest'; // Tipo para Edificios históricos
    case 'Playas':
      return 'beach'; // Tipo para Playas
    case 'Reservas Naturales':
      return 'natural_feature'; // Tipo para Reservas Naturales
    case 'Parques':
      return 'park'; // Tipo para Parques
    case 'Tiendas de conveniencia':
      return 'convenience_store'; // Tipo para Tiendas de conveniencia
    case 'Centros comerciales':
      return 'shopping_mall'; // Tipo para Centros comerciales
    case 'Volcanes':
      return 'geological_feature'; // Tipo para Volcanes
    case 'Montañas':
      return 'mountain'; // Tipo para Montañas
    case 'Islas':
      return 'island'; // Tipo para Islas
    default:
      return 'establishment'; // Valor por defecto si no coincide con ninguna categoría
  }
}


  Future<void> _onPlaceSelected(dynamic place) async {
    const String apiKey = 'AIzaSyCNNLly_rF6NkMMgoFAl5dv8lfCmu00mnY'; // Asegúrate de usar tu API Key
    final String placeId = place['place_id'];

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['result'] != null) { // Verificar si se encontraron detalles
          setState(() {
            selectedPlace = {
              'name': data['result']['name'],
              'rating': data['result']['rating'],
              'opening_hours': data['result']['opening_hours'],
              'photos': data['result']['photos']?.map((photo) {
                return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${photo['photo_reference']}&key=$apiKey';
              }).toList() ?? [],
            };

            // Actualizar los marcadores para mostrar solo el lugar seleccionado
            markers = {
              Marker(
                markerId: MarkerId(placeId),
                position: LatLng(
                  place['geometry']['location']['lat'],
                  place['geometry']['location']['lng'],
                ),
                infoWindow: InfoWindow(title: place['name']),
              ),
            };

            // Centrar el mapa en el lugar seleccionado
            mapController.animateCamera(
              CameraUpdate.newLatLng(
                LatLng(
                  place['geometry']['location']['lat'],
                  place['geometry']['location']['lng'],
                ),
              ),
            );

            // Mostrar los detalles del lugar
            _showPlaceDetails();
          });
        } else {
          throw Exception('No se encontraron detalles para el lugar seleccionado');
        }
      } else {
        throw Exception('Error al obtener detalles del lugar');
      }
    } catch (error) {
      print('Error en _onPlaceSelected: $error');
      // Aquí puedes mostrar un mensaje al usuario
    }
  }

  void _showPlaceDetails() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return PlaceDetailsWidget(
          name: selectedPlace['name'],
          rating: (selectedPlace['rating'] is int)
              ? (selectedPlace['rating'] as int).toDouble()
              : selectedPlace['rating'] ?? 0.0,
          openNow: selectedPlace['opening_hours']?['open_now'] ?? false,
          photos: (selectedPlace['photos'] != null)
              ? (selectedPlace['photos'] as List<dynamic>).cast<String>()
              : <String>[], // Lista vacía si no hay fotos
          reviews: (selectedPlace['reviews'] != null)
              ? (selectedPlace['reviews'] as List<dynamic>)
              : <dynamic>[], // Lista vacía si no hay reseñas
        );
      },
    );
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubicación en el Mapa'),
      ),
      body: Column(
        children: [
          // Mapa
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: MapWidget(
              latitude: userLatitude ?? 0.0, // Usa la latitud del usuario
              longitude: userLongitude ?? 0.0, // Usa la longitud del usuario
              markers: markers,
              onMapCreated: (controller) {
                mapController = controller;
                // Centrar el mapa en la ubicación del usuario
                if (userLatitude != null && userLongitude != null) {
                  mapController.animateCamera(
                    CameraUpdate.newLatLng(
                      LatLng(userLatitude!, userLongitude!),
                    ),
                  );
                }
              },
              onPlaceSelected: (LatLng position) {
                // Puedes manejar la selección adicional si es necesario
              },
            ),
          ),
          // Categorías
          CategorySelectorWidget(
            categories: const [
              'Iglesias',
              'Restaurantes',
              'Monumentos',
              'Edificios históricos',
              'Playas',
              'Reservas Naturales',
              'Parques',
              'Tiendas de conveniencia',
              'Centros comerciales',
              'Volcanes',
              'Montañas',
              'Islas',
            ],
            selectedCategory: selectedCategory,
            onCategoryChanged: (category) {
              setState(() {
                selectedCategory = category;
                isLoadingPlaces = true;
              });
              fetchNearbyPlaces();
            },
          ),

          // Lista de Lugares
          isLoadingPlaces
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: PlaceListWidget(
                    places: places,
                    onPlaceSelected: _onPlaceSelected,
                  ),
                ),
        ],
      ),
    );
  }
}