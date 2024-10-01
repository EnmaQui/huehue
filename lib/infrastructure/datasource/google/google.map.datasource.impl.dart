import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:huehue/const/data.const.dart';
import 'package:huehue/domain/datasource/google/google.map.datasource.dart';
import 'package:huehue/infrastructure/models/DirectionsModel.dart';
import 'package:huehue/infrastructure/models/Place/PlaceDetailModel.dart';
import 'package:huehue/infrastructure/models/Place/PlaceModel.dart';
import 'package:huehue/utils/service.locator.utils.dart';

class GoogleMapDataSourceImpl extends GoogleMapDataSource {

  final _dio = serviceLocator<Dio>();

  @override
  Future<List<LatLng>> getRoutes(LatLng origin, LatLng destination) async {
    
    final response = await _dio.get(
      'directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=${DataConst.googleApiKey}'
    );

    if(response.statusCode == 200 || response.statusCode == 201) {
      final modelData = DirectionsModel.fromJson(response.data);
      List<LatLng> routePoints = [];

      for (var step in modelData.routes[0].legs[0].steps) {
        routePoints.add(step.startLocation);
        routePoints.add(step.endLocation);
      }

      return routePoints;
    }

    return [];
  }
  
  @override
  Future<List<PlaceModel>> getNearbyPlaces(LatLng userLocation) async {
    final response = await _dio.get(
      'place/nearbysearch/json?location=${userLocation.latitude},${userLocation.longitude}&radius=5000&type=tourist_attraction|church|museum|park&key=${DataConst.googleApiKey}&language=es'
    );

    if(response.statusCode == 200 || response.statusCode == 201) {
      return (response.data['results'] as List)
          .map((element) => PlaceModel.fromJson(element))
          .toList();
    }

    return [];
  }
  
  @override
  Future<PlaceDetailModel?> getPlaceDetails(String placeId) async {
    final response = await _dio.get(
      'place/details/json?place_id=$placeId&key=${DataConst.googleApiKey}&language=es'
    );

    if(response.statusCode == 200 || response.statusCode == 201) {
      return PlaceDetailModel.fromJson(response.data['result']);
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