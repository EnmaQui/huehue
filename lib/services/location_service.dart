import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  static Future<LatLng?> getCurrentLocation() async {
    // Solicitar permisos de ubicación
    LocationPermission permission = await Geolocator.requestPermission();

    // Verificar el estado del permiso
    if (permission == LocationPermission.denied) {
      print('Permiso de ubicación denegado');
      return null;
    } else if (permission == LocationPermission.deniedForever) {
      print('Permiso de ubicación denegado de forma permanente');
      return null;
    }

    try {
      // Obtener la posición actual con alta precisión
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      print('Error al obtener la ubicación: $e');
      return null;
    }
  }



}
