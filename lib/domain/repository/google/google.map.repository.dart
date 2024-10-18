import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:huehue/domain/entity/place/PlaceDetailEntity.dart';
import 'package:huehue/domain/entity/place/PlaceEntity.dart';

abstract class GoogleMapRepository {
  Future<List<LatLng>> getRoutes(LatLng origin, LatLng destination);
  Future<List<PlaceEntity>> getNearbyPlaces(LatLng userLocation);
  Future<PlaceDetailEntity?> getPlaceDetails(String placeId);
  Future<List<String>> fetchImageUrls(List<String> placeIds);
}