import 'package:huehue/domain/entity/place/PlaceDayTimeEntity.dart';

class PlaceOpenCloseEntity {
  PlaceDayTimeEntity open;
  PlaceDayTimeEntity close;

  PlaceOpenCloseEntity({
    required this.open,
    required this.close,
  });
}