import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapWidget extends StatefulWidget {
  final double latitude;
  final double longitude;
  final Set<Marker> markers;
  final Function(GoogleMapController) onMapCreated;
  final Function(LatLng) onPlaceSelected;

  const MapWidget({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.markers,
    required this.onMapCreated,
    required this.onPlaceSelected,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late GoogleMapController mapController;
  Set<Polyline> _polylines = {}; // Para dibujar la ruta

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
            widget.onMapCreated(controller);
          },
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.latitude, widget.longitude),
            zoom: 15,
          ),
          markers: widget.markers,
          polylines: _polylines, // Añadir la ruta al mapa
          onTap: (LatLng position) {
            // Llama a la función onPlaceSelected cuando se toca el mapa
            widget.onPlaceSelected(position);
          },
          myLocationEnabled: true,
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () async {
              // Traza la ruta desde la ubicación actual hasta la primera ubicación en los marcadores
              if (widget.markers.isNotEmpty) {
                Marker destinationMarker = widget.markers.first;
                await _getDirections(
                  LatLng(widget.latitude, widget.longitude),
                  destinationMarker.position,
                );
              }
            },
            child: const Icon(Icons.directions),
            tooltip: 'Cómo llegar',
          ),
        ),
      ],
    );
  }

  // Método para solicitar la ruta desde Google Directions API
  Future<void> _getDirections(LatLng origin, LatLng destination) async {
    const String apiKey = 'AIzaSyCNNLly_rF6NkMMgoFAl5dv8lfCmu00mnY'; // Reemplaza con tu API Key de Google Maps
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> steps = data['routes'][0]['legs'][0]['steps'];

      List<LatLng> polylineCoordinates = [];

      for (var step in steps) {
        polylineCoordinates.add(LatLng(
          step['start_location']['lat'],
          step['start_location']['lng'],
        ));
        polylineCoordinates.add(LatLng(
          step['end_location']['lat'],
          step['end_location']['lng'],
        ));
      }

      setState(() {
        // Limpiar las rutas anteriores antes de agregar la nueva
        _polylines.clear(); 

        _polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            points: polylineCoordinates,
            color: Colors.blue,
            width: 5,
          ),
        );
      });

      // Centrar el mapa en la ruta
      mapController.animateCamera(
        CameraUpdate.newLatLngBounds(
          _boundsFromLatLngList(polylineCoordinates),
          50.0, // Espaciado alrededor del límite
        ),
      );
    } else {
      print('Error al obtener la dirección: ${response.statusCode}');
    }
  }

  // Crear bounds para centrar el mapa
  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    final southwestLat = list.map((e) => e.latitude).reduce((value, element) => value < element ? value : element);
    final southwestLng = list.map((e) => e.longitude).reduce((value, element) => value < element ? value : element);
    final northeastLat = list.map((e) => e.latitude).reduce((value, element) => value > element ? value : element);
    final northeastLng = list.map((e) => e.longitude).reduce((value, element) => value > element ? value : element);

    return LatLngBounds(
      southwest: LatLng(southwestLat, southwestLng),
      northeast: LatLng(northeastLat, northeastLng),
    );
  }
}

