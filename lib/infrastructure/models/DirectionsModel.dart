import 'package:huehue/infrastructure/models/RouteModel.dart';

class DirectionsModel {
  final List<RouteModel> routes;

  DirectionsModel({required this.routes});

  factory DirectionsModel.fromJson(Map<String, dynamic> json) {
    var routesList = json['routes'] as List;
    List<RouteModel> routes = routesList.map((routeJson) => RouteModel.fromJson(routeJson)).toList();

    return DirectionsModel(routes: routes);
  }
}