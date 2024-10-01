import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class GoogleMapDataSource {
  Future<List<LatLng>> getRoutes(LatLng origin, LatLng destination);
}