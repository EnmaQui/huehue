import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:huehue/const/data.const.dart';
import 'package:huehue/domain/datasource/google/google.map.datasource.dart';
import 'package:huehue/domain/entity/place/PlaceDetailEntity.dart';
import 'package:huehue/domain/entity/place/PlaceEntity.dart';
import 'package:huehue/domain/repository/google/google.map.repository.dart';
import 'package:huehue/infrastructure/mappers/google/google.mapper.dart';
import 'package:huehue/infrastructure/models/Place/PlaceDetailModel.dart';
import 'package:huehue/infrastructure/models/Place/PlaceReviewerModel.dart';

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
  Future<List<PlaceEntity>> getNearbyPlaces(LatLng userLocation,  int radius, String type) async {
     final response = await googleMapDataSource.getNearbyPlaces(userLocation, radius, type);

    if(response.isNotEmpty) {
      return response.map((e) => GoogleMapper.placeModeltoEntity(e)).toList();
    }

    return [];
  }
  
  @override
  Future<PlaceDetailEntity?> getPlaceDetails(String placeId) async {
    final results = await Future.wait([
      googleMapDataSource.getPlaceDetails(placeId),
      googleMapDataSource.getPlacePhotos(placeId),
      googleMapDataSource.gethPlaceReviews(placeId),
    ]);

    final reponse = results[0] as PlaceDetailModel?;
    final placePhotos = results[1] as List<String>;
    final placeReview = results[2] as List<PlaceReviewModel>;

    if(reponse != null) { 
      var convert =  GoogleMapper.placeDetailModeltoEntity(reponse);
      convert.photos = placePhotos;
      convert.reviews = (placeReview).map((elment) => GoogleMapper.placeReviewModelToEntity(
        elment
      )).toList();

      return convert;
    }

    return null;
  }
  
  @override
  Future<List<String>> fetchImageUrls(List<String> placeIds) async {
    try {
      List<String> photos = [];
      for(final placeId in placeIds) {
        final reponsePlace = await googleMapDataSource.getPlaceRatings(placeId);
        // final photo = await googleMapDataSource.getPlacePhotoByReference(reponsePlace.photos?[5] ?? '');
        photos.add('${DataConst.googleMapApi}/place/photo?maxwidth=1280&maxheight=720&photoreference=${reponsePlace.photos?[5]}&key=${DataConst.googleApiKey}');
      }
      return photos;
    } catch (e) {
      rethrow;
    }
  }
}