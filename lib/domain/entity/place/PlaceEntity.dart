import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceEntity {
  String placeId;
  String name;
  LatLng coordinates;
  List<String> types;

  PlaceEntity({
    required this.placeId,
    required this.name,
    required this.coordinates,
    required this.types,
  });
}
