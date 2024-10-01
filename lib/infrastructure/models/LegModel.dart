import 'package:huehue/infrastructure/models/StepModel.dart';

class LegModel {
  final List<StepModel> steps;

  LegModel({required this.steps});

  // Método para decodificar un JSON en un objeto Leg
  factory LegModel.fromJson(Map<String, dynamic> json) {
    var stepsList = json['steps'] as List;
    List<StepModel> steps = stepsList.map((stepJson) => StepModel.fromJson(stepJson)).toList();

    return LegModel(steps: steps);
  }
}
