import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:huehue/domain/datasource/google/google.map.datasource.dart';
import 'package:huehue/domain/entity/place/PlaceDetailEntity.dart';
import 'package:huehue/domain/entity/place/PlaceEntity.dart';
import 'package:huehue/domain/repository/google/google.map.repository.dart';
import 'package:huehue/infrastructure/mappers/google/google.mapper.dart';

class GoogleMapRepositoryImpl extends GoogleMapRepository {
  final GoogleMapDataSource googleMapDataSource;

  GoogleMapRepositoryImpl({
    required this.googleMapDataSource
  });

  @override
  Future<List<LatLng>> getRoutes(LatLng origin, LatLng destination) async {
    return await googleMapDataSource.getRoutes(origin, destination);
  }
  
  @override
  Future<List<PlaceEntity>> getNearbyPlaces(LatLng userLocation) async {
     final response = await googleMapDataSource.getNearbyPlaces(userLocation);

    if(response.isNotEmpty) {
      return response.map((e) => GoogleMapper.placeModeltoEntity(e)).toList();
    }

    return [];
  }
  
  @override
  Future<PlaceDetailEntity?> getPlaceDetails(String placeId) async {
    final reponse = await googleMapDataSource.getPlaceDetails(placeId);

    if(reponse != null) {
      return GoogleMapper.placeDetailModeltoEntity(reponse);
    }

    return null;
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