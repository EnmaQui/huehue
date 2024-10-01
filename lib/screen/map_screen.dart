import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/location_service.dart';
import '../services/directions_service.dart';
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
  StreamSubscription<LatLng>? locationSubscription;

  @override
  void initState() {
    super.initState();
    _getUserLocation(); // Obtener la ubicación inicial
  }

  @override
  void dispose() {
    locationSubscription?.cancel();
    super.dispose();
  }

  // Obtener la ubicación actual del usuario
  Future<void> _getUserLocation() async {
    userLocation = await LocationService.getCurrentLocation();
    if (userLocation != null) {
      _updateUserLocationMarker();
    } else {
      // Manejar el caso donde la ubicación no está disponible
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo obtener la ubicación')),
      );
    }
  }

  // Actualizar el marcador de la ubicación del usuario
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

  // Crear una ruta entre la ubicación del usuario y un destino
  Future<void> _createRoute(LatLng destination) async {
    if (userLocation == null) return;

    try {
      final directions = await DirectionsService.getDirections(userLocation!, destination);
      setState(() {
        routePolyline = Polyline(
          polylineId: const PolylineId('route'),
          points: directions,
          color: Colors.blue,
          width: 5,
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al crear la ruta')),
      );
    }
  }

  // Manejar el evento de marcador presionado para trazar una ruta
  void _onMarkerPressed(LatLng destination) {
    _createRoute(destination);
  }

  // Obtener el ícono del marcador según el tipo de lugar
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

  // Crear marcadores en el mapa para los lugares cercanos
  void _createMarkers(List<Map<String, dynamic>> places) {
    setState(() {
      markers.clear();
      markers.addAll(places.map((place) {
        return Marker(
          markerId: MarkerId(place['place_id']),
          position: place['coordinates'],
          infoWindow: InfoWindow(
            title: place['name'],
            snippet: place['types'].join(', '),
          ),
          icon: _getMarkerIcon(place['types'].first),
          onTap: () => _navigateToPlaceDetail(place['place_id'], place['coordinates']),
        );
      }).toList());
    });
  }

  // Navegar a la pantalla de detalles del lugar
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

  // Construir el Drawer personalizado
  Widget _buildDrawer() {
    return CustomDrawer(
      onFilterSelected: (type) {
        _filterPlaces(type);
      },
    );
  }

  // Filtrar lugares cercanos según el tipo
  Future<void> _filterPlaces(String type) async {
    if (userLocation != null) {
      final nearbyPlaces = await PlacesService.fetchNearbyPlaces(userLocation!);
      final filteredPlaces = nearbyPlaces.where((place) => place['types'].contains(type)).toList();
      _createMarkers(filteredPlaces);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ubicación no disponible')),
      );
    }
  }
}
