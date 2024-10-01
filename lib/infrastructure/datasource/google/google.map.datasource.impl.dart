import 'package:dio/dio.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:huehue/const/data.const.dart';
import 'package:huehue/domain/datasource/google/google.map.datasource.dart';
import 'package:huehue/infrastructure/models/DirectionsModel.dart';
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

}