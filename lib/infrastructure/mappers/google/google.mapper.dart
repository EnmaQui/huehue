import 'package:huehue/domain/entity/place/PlaceDayTimeEntity.dart';
import 'package:huehue/domain/entity/place/PlaceDetailEntity.dart';
import 'package:huehue/domain/entity/place/PlaceEntity.dart';
import 'package:huehue/domain/entity/place/PlaceOpenCloseEntity.dart';
import 'package:huehue/domain/entity/place/PlaceOpeningEntity.dart';
import 'package:huehue/domain/entity/place/PlaceReviewEntity.dart';
import 'package:huehue/enum/PriceLevelEnum.dart';
import 'package:huehue/infrastructure/models/Place/PlaceDetailModel.dart';
import 'package:huehue/infrastructure/models/Place/PlaceModel.dart';
import 'package:huehue/infrastructure/models/Place/PlaceReviewerModel.dart';

class GoogleMapper {

  static PlaceReviewEntity placeReviewModelToEntity(PlaceReviewModel placeReviewerModel) {
    return PlaceReviewEntity(
      reviewerName: placeReviewerModel.reviewerName,
      reviewText: placeReviewerModel.reviewText,
      rating: placeReviewerModel.rating,
      photos: placeReviewerModel.photos,
    );
  }
  
  static PlaceEntity placeModeltoEntity(PlaceModel placeModel) {
    return PlaceEntity(
      placeId: placeModel.placeId,
      name: placeModel.name,
      coordinates: placeModel.coordinates,
      types: placeModel.types,
      rating: placeModel.rating,
      vicinity: placeModel.vicinity,
      photos: placeModel.photos,
      priceLevel: placeModel.priceLevel == null ? null : PriceLevelExtension.fromValue(placeModel.priceLevel!)
    );
  }

  static PlaceDetailEntity placeDetailModeltoEntity(PlaceDetailModel placeDetailModel) {
    return PlaceDetailEntity(
      name: placeDetailModel.name,
      address: placeDetailModel.address ?? '',
      phone: placeDetailModel.phone ?? '',
      description: placeDetailModel.description ?? '',
      website: placeDetailModel.website ?? '',
      rating: placeDetailModel.rating ?? 0.0,
      photos: placeDetailModel.photos ?? [],
      location: placeDetailModel.location,
      reviews: [],
      openingHours: placeDetailModel.openingHours == null ? null : PlaceOpeningEntity(
        openNow: placeDetailModel.openingHours?.openNow ?? false,
        periods:( placeDetailModel.openingHours?.periods ?? []).map((e) => PlaceOpenCloseEntity(
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
      reviewsCount: placeDetailModel.reviewsCount ?? 0,
    );
  }
}