import 'package:huehue/infrastructure/models/Place/PlaceOpenCloseModel.dart';

class PlaceOpeningModel {
  bool openNow;
  List<PlaceOpenCloseModel> periods;

  PlaceOpeningModel({
    required this.openNow,
    required this.periods
  });

  factory PlaceOpeningModel.fromJson(Map<String, dynamic> json) {
    return PlaceOpeningModel(
      openNow: json['open_now'],
      periods: (json['periods'] as List).map((e) => PlaceOpenCloseModel.fromJson(e)).toList()
    );
  }

  Map<String, dynamic> toJson() => {
    'open_now': openNow,
    'periods': periods
  };
}