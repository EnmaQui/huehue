import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../services/directions_service.dart'; // Importa un servicio para obtener la ruta
//import '../services/location_service.dart';
import '../services/place_service.dart';
import '../widgets/drawer.dart';
import 'place_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final Set<Marker> markers = {};
  LatLng? userLocation;
  Polyline? routePolyline;
  StreamSubscription<LatLng>? locationSubscription; // Subscripción a cambios de ubicación

  @override
  void initState() {
    super.initState();
   // _startLocationUpdates();
  }

  @override
  void dispose() {
    locationSubscription?.cancel(); // Cancelar la suscripción cuando se cierre la pantalla
    super.dispose();
  }

  /* Iniciar las actualizaciones en tiempo real de la ubicación del usuario
  Future<void> _startLocationUpdates() async {
    locationSubscription = LocationService.getLocationStream().listen((newLocation) {
      setState(() {
        userLocation = newLocation;
      });
      _updateUserLocationMarker();
    });
  }*/

  // Actualiza el marcador de la ubicación del usuario en tiempo real
  void _updateUserLocationMarker() {
    if (userLocation != null) {
      markers.removeWhere((marker) => marker.markerId.value == 'user_location');
      markers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: userLocation!,
          infoWindow: const InfoWindow(title: 'Tu ubicación'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
      mapController.animateCamera(CameraUpdate.newLatLng(userLocation!));
    }
  }

  // Trazar la ruta entre la ubicación del usuario y el lugar seleccionado
  Future<void> _createRoute(LatLng destination) async {
    if (userLocation == null) return;

    final directions = await DirectionsService.getDirections(userLocation!, destination);
    setState(() {
      routePolyline = Polyline(
        polylineId: const PolylineId('route'),
        points: directions, // La lista de puntos LatLng para la ruta
        color: Colors.blue,
        width: 5,
      );
    });
  }

  // Manejar el marcador presionado para trazar la ruta
  void _onMarkerPressed(LatLng destination) {
    _createRoute(destination);
  }

  BitmapDescriptor _getMarkerIcon(String type) {
    switch (type) {
      case 'church':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      case 'museum':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case 'park':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case 'beach':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
      case 'art_gallery':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
      case 'stadium':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      default:
        return BitmapDescriptor.defaultMarker;
    }
  }

  void _createMarkers(List<Map<String, dynamic>> places) {
    setState(() {
      markers.clear();
      markers.addAll(places.map((place) {
        return Marker(
          markerId: MarkerId(place['place_id']), // Usar place_id como ID del marcador
          position: place['coordinates'], // Asegúrate de que coordinates sea del tipo LatLng
          infoWindow: InfoWindow(
            title: place['name'],
            snippet: place['types'].join(', '),
          ),
          icon: _getMarkerIcon(place['types'].first), // Obtener ícono según el tipo
          onTap: () => _navigateToPlaceDetail(place['place_id'], place['coordinates']),
        );
      }).toList());
    });
  }

  void _navigateToPlaceDetail(String placeId, LatLng coordinates) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlaceDetailScreen(
          placeId: placeId,
          coordinates: coordinates,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa de Nicaragua')),
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(12.1364, -86.2514),
              zoom: 6,
            ),
            markers: markers,
            onMapCreated: (controller) {
              mapController = controller;
              if (userLocation != null) _updateUserLocationMarker();
            },
            polylines: routePolyline != null ? {routePolyline!} : {},
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              onPressed: () {
                if (userLocation != null) {
                  mapController.animateCamera(CameraUpdate.newLatLngZoom(userLocation!, 14));
                }
              },
              tooltip: 'Centrar en mi ubicación',
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return CustomDrawer(
      onFilterSelected: (type) {
        _filterPlaces(type);
      },
    );
  }

  Future<void> _filterPlaces(String type) async {
    final nearbyPlaces = await PlacesService.fetchNearbyPlaces(userLocation!);
    final filteredPlaces = nearbyPlaces.where((place) => place['types'].contains(type)).toList();
    _createMarkers(filteredPlaces);
  }
}
