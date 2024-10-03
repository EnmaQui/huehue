import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:huehue/const/data.const.dart';
import 'package:huehue/domain/datasource/google/google.map.datasource.dart';
import 'package:huehue/infrastructure/models/DirectionsModel.dart';
import 'package:huehue/infrastructure/models/Place/PlaceDetailModel.dart';
import 'package:huehue/infrastructure/models/Place/PlaceModel.dart';
import 'package:huehue/infrastructure/models/Place/PlaceReviewerModel.dart';
import 'package:huehue/utils/service.locator.utils.dart';

class GoogleMapDataSourceImpl extends GoogleMapDataSource {
  final _dio = serviceLocator<Dio>();

  @override
  Future<List<LatLng>> getRoutes(LatLng origin, LatLng destination) async {
    final response = await _dio.get(
        'directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=${DataConst.googleApiKey}');

    if (response.statusCode == 200 || response.statusCode == 201) {
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
        '/place/nearbysearch/json?location=${userLocation.latitude},${userLocation.longitude}&radius=5000&type=tourist_attraction|church|museum|park&key=${DataConst.googleApiKey}&language=es');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return (response.data['results'] as List)
          .map((element) => PlaceModel.fromJson(element))
          .toList();
    }

    return [];
  }

  @override
  Future<PlaceDetailModel?> getPlaceDetails(String placeId) async {
    final response = await _dio.get(
        '/place/details/json?place_id=$placeId&key=${DataConst.googleApiKey}&language=es');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return PlaceDetailModel.fromJson(response.data['result']);
    }

    return null;
  }

  @override
  Future<List<String>> getPlacePhotos(String placeId) async {
    try {
      final response = await _dio.get(
          '/place/details/json?place_id=$placeId&key=${DataConst.googleApiKey}&language=es');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return (List<String>.from(
          response.data['result']['photos'].map((photo) =>
              'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${photo['photo_reference']}&key=${DataConst.googleApiKey}'),
        ));
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PlaceReviewModel>> gethPlaceReviews(String placeId) async {
    try {
      final response = await _dio.get(
          '/place/details/json?place_id=$placeId&key=${DataConst.googleApiKey}&language=es');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return (response.data['result']['reviews'] as List)
            .map((element) => PlaceReviewModel.fromJson(element))
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }
}
