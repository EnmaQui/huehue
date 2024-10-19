import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:huehue/domain/entity/place/PlaceEntity.dart';
import 'package:huehue/presentation/blocs/place/place_bloc.dart';
import 'package:huehue/presentation/screen/pruebas/modal/MapDetailsPlace.dart';

import '../pruebas/widgets_maps/categorias_widget.dart';
import '../pruebas/widgets_maps/detalles_widget.dart';

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
    final placeBloc = context.read<PlaceBloc>();
    placeBloc.add(FilterPlaceByTypeEvent(
      type: _getTypeFromCategory(placeBloc.state.selectedCategory),
      location: LatLng(widget.latitude, widget.longitude),
    ));
    _getUserLocation(); // Obtener la ubicación del usuario
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  // Método para obtener la ubicación del usuario
  Future<void> _getUserLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Manejar el caso en que el permiso es denegado
      return;
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      userLatitude = position.latitude;
      userLongitude = position.longitude;
    });
    fetchNearbyPlaces(); // Llama a la función para obtener lugares cercanos
  }

  Future<void> fetchNearbyPlaces() async {
    const String apiKey = 'AIzaSyCNNLly_rF6NkMMgoFAl5dv8lfCmu00mnY';
    final String type = _getTypeFromCategory(
        selectedCategory); // Función para obtener el tipo correcto
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

  Future<void> _onPlaceSelected(PlaceEntity place, Object? position) async {
    const String apiKey =
        'AIzaSyCNNLly_rF6NkMMgoFAl5dv8lfCmu00mnY'; // Asegúrate de usar tu API Key
    final String placeId = place.placeId;

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['result'] != null) {
          // Verificar si se encontraron detalles
          setState(() {
            // Actualizar los detalles del lugar seleccionado
            selectedPlace = {
              'name': data['result']['name'],
              'rating': data['result']['rating'],
              'opening_hours': data['result']['opening_hours'],
              'photos': data['result']['photos']?.map((photo) {
                    return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${photo['photo_reference']}&key=$apiKey';
                  }).toList() ??
                  [],
            };

            // Limpiar los marcadores anteriores
            markers.clear();

            // Agregar el nuevo marcador
            markers.add(
              Marker(
                markerId: MarkerId(placeId),
                position: place.coordinates,
                infoWindow: InfoWindow(title:place.name),
              ),
            );

            // Limpiar las polilíneas existentes
            polylines.clear();

            // Crear una nueva polilínea desde la ubicación del usuario al lugar seleccionado
            if (userLatitude != null && userLongitude != null) {
              polylines.add(
                Polyline(
                  polylineId: const PolylineId(
                      'route'), // Un ID único para la polilínea
                  points: [
                    LatLng(userLatitude!,
                        userLongitude!), // Punto de inicio (ubicación del usuario)
                    place.coordinates// Punto de destino (lugar seleccionado)
                  ],
                  color: Colors.blue, // Color de la polilínea
                  width: 5, // Ancho de la polilínea
                ),
              );
            }

            // Centrar el mapa en el lugar seleccionado
            mapController.animateCamera(
              CameraUpdate.newLatLng(
                place.coordinates
              ),
            );

            // Mostrar los detalles del lugar
            _showPlaceDetails();
          });
        } else {
          throw Exception(
              'No se encontraron detalles para el lugar seleccionado');
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
    if (selectedPlace == null) {
      // Manejo de error si selectedPlace es null
      print('selectedPlace es null');
      return; // O puedes mostrar un mensaje de error al usuario
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return PlaceDetailsWidget(
          name: selectedPlace['name'] ??
              'Nombre no disponible', // Valor por defecto
          rating: (selectedPlace['rating'] is int)
              ? (selectedPlace['rating'] as int).toDouble()
              : (selectedPlace['rating'] ?? 0.0), // Valor por defecto

          openNow: selectedPlace['opening_hours'] != null &&
                  selectedPlace['opening_hours']['open_now'] != null
              ? selectedPlace['opening_hours']['open_now']
              : false, // Manejo de null

          photos: (selectedPlace['photos'] != null)
              ? (selectedPlace['photos'] as List<dynamic>).cast<String>()
              : <String>[],

          reviews: (selectedPlace['reviews'] != null &&
                  selectedPlace['reviews'] is List)
              ? (selectedPlace['reviews'] as List<dynamic>).cast<String>()
              : <String>[], // Inicializa como lista vacía de strings

          openingHours: selectedPlace['opening_hours'] ?? {}, // Nueva adición
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final placeBloc = context.read<PlaceBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubicado en el mapa'),
      ),
      body: Stack(children: [
        Positioned.fill(
          child: GoogleMap(
            // mapType: state.mapType,
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.latitude, widget.longitude),
              zoom: 15,
            ),
             markers: markers,
            zoomControlsEnabled: false,
            compassEnabled: false,
            myLocationEnabled: true,
            tiltGesturesEnabled: false,
            // style: MapConfig.whiteMap,
            onMapCreated: (controller) async {
              // _mapController = controller;
              mapController = controller;
              controller.animateCamera(
                CameraUpdate.newLatLng(
                  LatLng(widget.latitude, widget.longitude),
                ),
              );
              // await Future.delayed(const Duration(seconds: 2));
              // goToMyPosition();
            },
          ),
        ),
        Positioned(
          top: 40,
          child: SizedBox(
            width: size.width,
            height: size.height * 0.07,
            child: BlocBuilder<PlaceBloc, PlaceState>(
              builder: (context, state) {
                return CategorySelectorWidget(
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
                  selectedCategory: state.selectedCategory,
                  onCategoryChanged: (category) {
                    placeBloc.add(SetSelectedCategory(category: category));
                    placeBloc.add(FilterPlaceByTypeEvent(
                      type: _getTypeFromCategory(category),
                      location: LatLng(widget.latitude, widget.longitude),
                    ));
                  },
                );
              },
            ),
          ),
        ),
          MapDetailsPlace(
          onTap: (place, location) {
            _onPlaceSelected(place, location);
            mapController.animateCamera(CameraUpdate.newLatLng(location));

          }
        ),
      ]),
    );
  }
}
