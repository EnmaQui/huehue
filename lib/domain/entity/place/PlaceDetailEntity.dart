import 'package:huehue/domain/entity/place/PlaceOpeningEntity.dart';
import 'package:huehue/domain/entity/place/PlaceReviewEntity.dart';

class PlaceDetailEntity {
  String name;
  String address;
  String phone;
  String description;
  String website;
  PlaceOpeningEntity? openingHours;
  double rating;
  int reviewsCount;
  List<String>? photos;
  List<PlaceReviewEntity> reviews;

  PlaceDetailEntity({
    required this.name,
    required this.address,
    required this.phone,
    required this.description,
    required this.website,
    required this.openingHours,
    required this.rating,
    required this.reviewsCount,
    this.photos,
    required this.reviews,
  });
}