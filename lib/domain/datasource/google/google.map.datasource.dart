import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:huehue/infrastructure/models/PlaceModel.dart';

abstract class GoogleMapDataSource {
  Future<List<LatLng>> getRoutes(LatLng origin, LatLng destination);
  Future<List<PlaceModel>> getNearbyPlaces(LatLng userLocation);
  Future<dynamic> getPlaceDetails(String placeId);
  Future<dynamic> getPlacePhotos(String placeId);
  Future<dynamic> gethPlaceReviews(String placeId);
}