import 'package:huehue/infrastructure/models/LegModel.dart';

class RouteModel {
  final List<LegModel> legs;

  RouteModel({required this.legs});

  // Método para decodificar un JSON en un objeto Route
  factory RouteModel.fromJson(Map<String, dynamic> json) {
    var legsList = json['legs'] as List;
    List<LegModel> legs = legsList.map((legJson) => LegModel.fromJson(legJson)).toList();

    return RouteModel(legs: legs);
  }
}