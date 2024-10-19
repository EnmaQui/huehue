import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceModel {
  final String placeId;
  final String name;
  final LatLng coordinates;
  final List<String> types;
  final dynamic rating;
  final String vicinity;
  final List<String> photos;
  final int? priceLevel;

  PlaceModel({
    required this.placeId,
    required this.name,
    required this.coordinates,
    required this.types,
    required this.rating,
    required this.vicinity,
    required this.photos,
    this.priceLevel,
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
      rating: json['rating'],
      vicinity: json['vicinity'],
      photos: json['photos'] != null ? List<String>.from(json['photos'].map((photo) => photo['photo_reference'])) : [],
      priceLevel: json['price_level'],
    );
  }
}