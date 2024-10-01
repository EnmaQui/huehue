import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class GoogleMapRepository {
  Future<List<LatLng>> getRoutes(LatLng origin, LatLng destination);
  Future<dynamic> getNearbyPlaces(LatLng userLocation);
  Future<dynamic> getPlaceDetails(String placeId);
  Future<dynamic> getPlacePhotos(String placeId);
  Future<dynamic> gethPlaceReviews(String placeId);

}