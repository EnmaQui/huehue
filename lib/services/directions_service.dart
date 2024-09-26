import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionsService {
  static const String _apiKey = 'YOUR_API_KEY'; // Asegúrate de reemplazar con tu clave de API

  // Método para obtener direcciones entre dos ubicaciones
  static Future<List<LatLng>> getDirections(LatLng origin, LatLng destination) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&mode=driving&key=$_apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['routes'] == null || data['routes'].isEmpty) {
        throw Exception('No se encontraron rutas.');
      }

      final route = data['routes'][0];
      final List<dynamic> steps = route['legs'][0]['steps'];

      // Convertimos cada paso en coordenadas de LatLng
      List<LatLng> polylinePoints = [];
      for (var step in steps) {
        polylinePoints.add(LatLng(
          step['start_location']['lat'],
          step['start_location']['lng'],
        ));
        polylinePoints.add(LatLng(
          step['end_location']['lat'],
          step['end_location']['lng'],
        ));
      }

      return polylinePoints;
    } else {
      throw Exception('Error al cargar direcciones: ${response.statusCode}');
    }
  }
}
