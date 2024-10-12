import 'dart:convert'; // Para el manejo de JSON

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:huehue/const/data.const.dart';

import '../../controladores/map_controller.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  MapWidgetState createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  late GoogleMapController mapController;
  LatLng _currentPosition = const LatLng(12.115, -86.236); // Posición inicial por defecto
  final Set<Polyline> _polylines = {}; // Para almacenar las polilíneas de la ruta

  @override
  void initState() {
    super.initState();
    _determinePosition(); // Obtener la ubicación actual al iniciar
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Los servicios de ubicación están deshabilitados.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Los permisos de ubicación fueron denegados.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Los permisos de ubicación están denegados permanentemente.');
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude); // Actualiza con la ubicación actual
    });

    // Mueve la cámara a la ubicación actual
    mapController.animateCamera(
      CameraUpdate.newLatLng(_currentPosition),
    );
    }

  void _initializeRoute(LatLng destination) {
    _getDirections(destination); // Obtener dirección al inicializar la ruta
  }

  Future<void> _getDirections(LatLng destination) async {
    final String googleApiKey = DataConst.googleApiKey; // Reemplaza con tu API Key
    final String url =
        '${DataConst.googleMapApi}/directions/json?origin=${_currentPosition.latitude},${_currentPosition.longitude}&destination=${destination.latitude},${destination.longitude}&key=$googleApiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['routes'].isNotEmpty) {
        _createPolyline(data['routes'][0]);
      } else {
        print('No se encontraron rutas.');
      }
    } else {
      throw Exception('Error al obtener las direcciones.');
    }
  }

  void _createPolyline(Map<String, dynamic> route) {
    final List<LatLng> polylineCoordinates = [];
    for (var step in route['legs'][0]['steps']) {
      final LatLng point = LatLng(
        step['end_location']['lat'],
        step['end_location']['lng'],
      );
      polylineCoordinates.add(point);
    }

    setState(() {
      _polylines.clear(); // Limpiar polilíneas anteriores
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          color: Colors.blue,
          points: polylineCoordinates,
          width: 5,
        ),
      );
    });

    // Mueve la cámara a la ruta
    mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(
            polylineCoordinates.map((point) => point.latitude).reduce((a, b) => a < b ? a : b),
            polylineCoordinates.map((point) => point.longitude).reduce((a, b) => a < b ? a : b),
          ),
          northeast: LatLng(
            polylineCoordinates.map((point) => point.latitude).reduce((a, b) => a > b ? a : b),
            polylineCoordinates.map((point) => point.longitude).reduce((a, b) => a > b ? a : b),
          ),
        ),
        100,
      ),
    );
    }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        mapController = controller;
        MapController.onMapCreated(controller);
        _initializeRoute(_currentPosition); // Inicializa la ruta aquí
      },
      initialCameraPosition: CameraPosition(
        target: _currentPosition,
        zoom: 14.0, // Nivel de zoom inicial
      ),
      mapType: MapType.normal,
      myLocationEnabled: true, // Habilitar la ubicación actual
      myLocationButtonEnabled: true, // Botón para centrar en la ubicación
      polylines: _polylines, // Mostrar las polilíneas en el mapa
      onTap: (LatLng destination) {
        _getDirections(destination); // Obtener dirección al tocar el mapa
      },
    );
  }
}
