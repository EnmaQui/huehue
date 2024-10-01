import 'package:huehue/domain/entity/place/PlaceOpenCloseEntity.dart';

class PlaceOpeningEntity {
  bool openNow;
  List<PlaceOpenCloseEntity> periods;

  PlaceOpeningEntity({
    required this.openNow,
    required this.periods
  });
}