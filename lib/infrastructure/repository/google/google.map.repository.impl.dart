import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:huehue/domain/repository/google/google.map.repository.dart';

class GoogleMapRepositoryImpl extends GoogleMapRepository {
  @override
  Future<List<LatLng>> getRoutes(LatLng origin, LatLng destination) {
    // TODO: implement getRoutes
    throw UnimplementedError();
  }
  
  @override
  Future getNearbyPlaces(LatLng userLocation) {
    // TODO: implement getNearbyPlaces
    throw UnimplementedError();
  }
  
  @override
  Future getPlaceDetails(String placeId) {
    // TODO: implement getPlaceDetails
    throw UnimplementedError();
  }
  
  @override
  Future getPlacePhotos(String placeId) {
    // TODO: implement getPlacePhotos
    throw UnimplementedError();
  }
  
  @override
  Future gethPlaceReviews(String placeId) {
    // TODO: implement gethPlaceReviews
    throw UnimplementedError();
  }
}