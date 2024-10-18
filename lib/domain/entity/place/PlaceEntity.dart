import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceEntity {
  String placeId;
  String name;
  LatLng coordinates;
  List<String> types;
  dynamic rating;
  String vicinity;
  List<String> photos;


  PlaceEntity({
    required this.placeId,
    required this.name,
    required this.coordinates,
    required this.types,
    this.rating,
    required this.vicinity,
    required this.photos,
  });
}
