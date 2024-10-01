import 'package:huehue/domain/entity/place/PlaceDayTimeEntity.dart';
import 'package:huehue/domain/entity/place/PlaceDetailEntity.dart';
import 'package:huehue/domain/entity/place/PlaceEntity.dart';
import 'package:huehue/domain/entity/place/PlaceOpenCloseEntity.dart';
import 'package:huehue/domain/entity/place/PlaceOpeningEntity.dart';
import 'package:huehue/infrastructure/models/Place/PlaceDetailModel.dart';
import 'package:huehue/infrastructure/models/Place/PlaceModel.dart';

class GoogleMapper {
  
  static PlaceEntity placeModeltoEntity(PlaceModel placeModel) {
    return PlaceEntity(
      placeId: placeModel.placeId,
      name: placeModel.name,
      coordinates: placeModel.coordinates,
      types: placeModel.types,
    );
  }

  static PlaceDetailEntity placeDetailModeltoEntity(PlaceDetailModel placeDetailModel) {
    return PlaceDetailEntity(
      name: placeDetailModel.name,
      address: placeDetailModel.address,
      phone: placeDetailModel.phone,
      description: placeDetailModel.description,
      website: placeDetailModel.website,
      rating: placeDetailModel.rating,
      openingHours: PlaceOpeningEntity(
        openNow: placeDetailModel.openingHours.openNow,
        periods: placeDetailModel.openingHours.periods.map((e) => PlaceOpenCloseEntity(
          close: PlaceDayTimeEntity(
            day: e.close.day,
            time: e.close.time
          ),
          open: PlaceDayTimeEntity(
            day: e.open.day,
            time: e.open.time
          )
        )).toList()
      ),
      reviewsCount: placeDetailModel.reviewsCount,
    );
  }
}