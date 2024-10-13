// map_screen.dart
// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String placeId;

  const MapScreen({required this.latitude, required this.longitude, required this.placeId, super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  List<String> categories = [
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
  ];
  String selectedCategory = 'Iglesias'; // Categoría seleccionada por defecto
  List<dynamic> places = []; // Lugares a mostrar
  bool isLoadingPlaces = true;

  @override
  void initState() {
    super.initState();
    fetchNearbyPlaces();
  }

  Future<void> fetchNearbyPlaces() async {
    // Aquí deberías reemplazar el API_KEY con tu clave de API real
    String apiKey = 'AIzaSyCNNLly_rF6NkMMgoFAl5dv8lfCmu00mnY';
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${widget.latitude},${widget.longitude}&radius=1500&type=${selectedCategory}&key=$apiKey'));

    if (response.statusCode == 200) {
      setState(() {
        places = json.decode(response.body)['results'];
        isLoadingPlaces = false;

        // Marcar los lugares en el mapa
        markers.clear();
        for (var place in places) {
          markers.add(Marker(
            markerId: MarkerId(place['place_id']),
            position: LatLng(place['geometry']['location']['lat'], place['geometry']['location']['lng']),
            infoWindow: InfoWindow(title: place['name']),
          ));
        }
      });
    } else {
      setState(() {
        isLoadingPlaces = false;
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onCategoryChanged(String? category) {
    if (category != null) {
      setState(() {
        selectedCategory = category;
        isLoadingPlaces = true; // Inicia la carga de nuevos lugares
      });
      fetchNearbyPlaces();
    }
  }

  void _showRoute(double lat, double lng) {
    // Aquí puedes usar la API de Google Directions para mostrar la ruta
    String url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';
    // Puedes usar un paquete como url_launcher para abrir el navegador
    launch(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubicación en el Mapa'),
      ),
      body: Column(
        children: [
          // Mapa ocupa el 40% de la pantalla
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.latitude, widget.longitude),
                zoom: 15,
              ),
              markers: markers,
            ),
          ),
          // Lista de categorías
          Expanded(
            child: Column(
              children: [
                // Filtros
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _onCategoryChanged(categories[index]),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: selectedCategory == categories[index] ? Colors.blue : Colors.grey[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            categories[index],
                            style: TextStyle(color: selectedCategory == categories[index] ? Colors.white : Colors.black),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Lista de lugares
                isLoadingPlaces
                    ? const Center(child: CircularProgressIndicator())
                    : Expanded(
                        child: ListView.builder(
                          itemCount: places.length,
                          itemBuilder: (context, index) {
                            final place = places[index];
                            return ListTile(
                              title: Text(place['name']),
                              subtitle: Text(place['vicinity'] ?? ''),
                              onTap: () {
                                // Marcar el lugar en el mapa
                                final location = place['geometry']['location'];
                                setState(() {
                                  markers.add(Marker(
                                    markerId: MarkerId(place['place_id']),
                                    position: LatLng(location['lat'], location['lng']),
                                    infoWindow: InfoWindow(title: place['name']),
                                  ));
                                });
                                mapController.animateCamera(CameraUpdate.newLatLng(LatLng(location['lat'], location['lng'])));
                              },
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
          // Botón flotante para mostrar ruta
          FloatingActionButton(
            onPressed: () {
              if (places.isNotEmpty) {
                final location = places[0]['geometry']['location'];
                _showRoute(location['lat'], location['lng']);
              }
            },
            child: const Icon(Icons.directions),
          ),
        ],
      ),
    );
  }
}
