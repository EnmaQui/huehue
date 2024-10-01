import 'package:huehue/infrastructure/models/Place/PlaceDayTimeModel.dart';

class PlaceOpenCloseModel {
  PlaceDayTimeModel open;
  PlaceDayTimeModel close;

  PlaceOpenCloseModel({
    required this.open,
    required this.close,
  });

  factory PlaceOpenCloseModel.fromJson(Map<String, dynamic> json) {
    return PlaceOpenCloseModel(
      open: PlaceDayTimeModel.fromJson(json['open']),
      close: PlaceDayTimeModel.fromJson(json['close']),
    );
  }

  Map<String, dynamic> toJson() => {
    'open': open.toJson(),
    'close': close.toJson(),
  };
}