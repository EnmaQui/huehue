import 'package:google_maps_flutter/google_maps_flutter.dart';

class StepModel {
  final LatLng startLocation;
  final LatLng endLocation;

  StepModel({required this.startLocation, required this.endLocation});

  factory StepModel.fromJson(Map<String, dynamic> json) {
    return StepModel(
      startLocation: LatLng(
        json['start_location']['lat'],
        json['start_location']['lng'],
      ),
      endLocation: LatLng(
        json['end_location']['lat'],
        json['end_location']['lng'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start_location': {
        'lat': startLocation.latitude,
        'lng': startLocation.longitude,
      },
      'end_location': {
        'lat': endLocation.latitude,
        'lng': endLocation.longitude,
      },
    };
  }
}