import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceModel {
  final String placeId;
  final String name;
  final LatLng coordinates;
  final List<String> types;

  PlaceModel({
    required this.placeId,
    required this.name,
    required this.coordinates,
    required this.types,
  });

  // Método para decodificar un JSON en un objeto PlaceModel
  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      placeId: json['place_id'],
      name: json['name'],
      coordinates: LatLng(
        json['geometry']['location']['lat'],
        json['geometry']['location']['lng'],
      ),
      types: List<String>.from(json['types']),
    );
  }
}