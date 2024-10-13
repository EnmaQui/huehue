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
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late GoogleMapController mapController;
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    if (widget.markers.isNotEmpty) {
      Marker destinationMarker = widget.markers.first;
      _getDirections(
        LatLng(widget.latitude, widget.longitude),
        destinationMarker.position,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
            widget.onMapCreated(controller);
            // Centrar el mapa en la ubicación inicial
            mapController.animateCamera(
              CameraUpdate.newLatLng(LatLng(widget.latitude, widget.longitude)),
            );
          },
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.latitude, widget.longitude),
            zoom: 15,
          ),
          markers: widget.markers,
          polylines: _polylines,
          onTap: (LatLng position) {
            widget.onPlaceSelected(position);
          },
          myLocationEnabled: true,
          mapType: MapType.normal,
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () async {
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

  Future<void> _getDirections(LatLng origin, LatLng destination) async {
    const String apiKey = 'AIzaSyCNNLly_rF6NkMMgoFAl5dv8lfCmu00mnY'; // Reemplaza con tu API Key
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey&alternatives=true&departure_time=now&traffic_model=best_guess';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> routes = data['routes'];

        setState(() {
          _polylines.clear(); 

          // Usar la primera ruta como la mejor ruta
          if (routes.isNotEmpty) {
            // Mejor ruta (verde)
            String bestRoutePolyline = routes[0]['overview_polyline']['points'];
            List<LatLng> bestRouteCoordinates = decodePolyline(bestRoutePolyline);
            _polylines.add(
              Polyline(
                polylineId: PolylineId('best_route'),
                points: bestRouteCoordinates,
                color: Colors.green, // Mejor ruta en verde
                width: 5,
              ),
            );

            // Alternativas (gris)
            for (var i = 1; i < routes.length; i++) {
              String alternativePolyline = routes[i]['overview_polyline']['points'];
              List<LatLng> alternativeCoordinates = decodePolyline(alternativePolyline);
              _polylines.add(
                Polyline(
                  polylineId: PolylineId('alternative_route_$i'),
                  points: alternativeCoordinates,
                  color: Colors.grey, // Alternativas en gris
                  width: 3,
                ),
              );
            }
          }
        });

        // Centrar el mapa en la mejor ruta
        if (routes.isNotEmpty) {
          List<LatLng> firstRouteCoordinates = decodePolyline(routes[0]['overview_polyline']['points']);
          mapController.animateCamera(
            CameraUpdate.newLatLngBounds(
              _boundsFromLatLngList(firstRouteCoordinates),
              50.0,
            ),
          );
        }
      } else {
        print('Error al obtener la dirección: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción al obtener direcciones: $e');
    }
  }

  List<LatLng> decodePolyline(String poly) {
    List<LatLng> polyline = [];
    int index = 0, len = poly.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = poly.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result >> 1) ^ -(result & 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = poly.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result >> 1) ^ -(result & 1));
      lng += dlng;

      polyline.add(LatLng((lat / 1E5), (lng / 1E5)));
    }
    return polyline;
  }

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
