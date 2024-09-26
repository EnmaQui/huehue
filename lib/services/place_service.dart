import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class PlacesService {
  static Future<List<Map<String, dynamic>>> fetchNearbyPlaces(LatLng userLocation) async {
    const String apiKey = 'AIzaSyCNNLly_rF6NkMMgoFAl5dv8lfCmu00mnY'; // Añade tu clave API de Google
    final String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${userLocation.latitude},${userLocation.longitude}&radius=5000&type=tourist_attraction|church|museum|park&key=$apiKey&language=es';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> places = data['results'];

      // Mapeamos los lugares para obtener solo la información básica
      List<Map<String, dynamic>> placesList = places.map((place) {
        return {
          'place_id': place['place_id'],
          'name': place['name'],
          'coordinates': LatLng(
            place['geometry']['location']['lat'],
            place['geometry']['location']['lng'],
          ),
          'types': place['types'],
        };
      }).toList();

      return placesList;
    } else {
      throw Exception('Error al cargar lugares cercanos: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> fetchPlaceDetails(String placeId, String apiKey) async {
    final String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey&language=es';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['result'] == null) {
        throw Exception('No se encontraron detalles para este lugar.');
      }

      final placeDetails = data['result'];

      // Modificado para devolver opening_hours como un mapa
      Map<String, String> openingHours = {};
      if (placeDetails['opening_hours'] != null && placeDetails['opening_hours']['weekday_text'] != null) {
        for (var entry in placeDetails['opening_hours']['weekday_text']) {
          var splitEntry = entry.split(': '); // Divide en día y horario
          if (splitEntry.length == 2) {
            openingHours[splitEntry[0]] = splitEntry[1];
          }
        }
      }

      return {
        'name': placeDetails['name'] ?? 'Nombre no disponible',
        'description': placeDetails['formatted_address'] ?? 'Descripción no disponible',
        'address': placeDetails['formatted_address'] ?? 'Dirección no disponible',
        'phone': placeDetails['formatted_phone_number'] ?? 'Teléfono no disponible',
        'website': placeDetails['website'] ?? 'Sitio web no disponible',
        'opening_hours': openingHours, // Ahora es un mapa
        'rating': placeDetails['rating']?.toString() ?? 'Sin calificación',
        'reviews_count': placeDetails['user_ratings_total']?.toString() ?? 'Sin reseñas',
        'location': placeDetails['geometry']['location'],
      };
    } else {
      throw Exception('Error al cargar detalles del lugar: ${response.body}');
    }
  }

  static Future<List<String>> fetchPlacePhotos(String placeId, String apiKey) async {
    final String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey&language=es';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['result'] == null) {
        throw Exception('No se encontraron fotos para este lugar.');
      }

      final placeDetails = data['result'];

      return placeDetails['photos'] != null
          ? List<String>.from(placeDetails['photos'].map((photo) =>
      'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${photo['photo_reference']}&key=$apiKey'))
          : [];
    } else {
      throw Exception('Error al cargar fotos del lugar: ${response.body}');
    }
  }
  // Nuevo método para obtener reseñas
  static Future<List<Map<String, dynamic>>> fetchPlaceReviews(String placeId, String apiKey) async {
    final String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey&language=es';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['result'] == null) {
        throw Exception('No se encontraron reseñas para este lugar.');
      }

      final placeDetails = data['result'];

      // Asegúrate de que `reviews` esté disponible en la respuesta y devuelve la lista de reseñas con la estructura correcta
      return placeDetails['reviews'] != null
          ? List<Map<String, dynamic>>.from(placeDetails['reviews'].map((review) {
        return {
          'reviewer_name': review['author_name'],
          'review_text': review['text'],
          'rating': review['rating'].toDouble(),
          'photos': review['profile_photo_url'] != null ? [review['profile_photo_url']] : [],
        };
      }))
          : [];
    } else {
      throw Exception('Error al cargar reseñas del lugar: ${response.body}');
    }
  }

  static Future<List<LatLng>> fetchRoute(LatLng origin, LatLng destination, String apiKey) async {
    final String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['routes'] == null || data['routes'].isEmpty) {
        throw Exception('No se encontraron rutas disponibles.');
      }

      // Obtiene la lista de puntos codificados de la primera ruta
      final List<dynamic> steps = data['routes'][0]['legs'][0]['steps'];

      // Decodifica los puntos y los convierte en una lista de LatLng
      List<LatLng> routePoints = [];

      for (var step in steps) {
        final startLatLng = LatLng(step['start_location']['lat'], step['start_location']['lng']);
        final endLatLng = LatLng(step['end_location']['lat'], step['end_location']['lng']);
        routePoints.add(startLatLng);
        routePoints.add(endLatLng);
      }

      return routePoints;
    } else {
      throw Exception('Error al obtener la ruta: ${response.body}');
    }
  }
}
