import 'package:huehue/domain/entity/place/PlaceOpeningEntity.dart';

class PlaceDetailEntity {
  String name;
  String address;
  String phone;
  String description;
  String website;
  PlaceOpeningEntity openingHours;
  String rating;
  int reviewsCount;

  PlaceDetailEntity({
    required this.name,
    required this.address,
    required this.phone,
    required this.description,
    required this.website,
    required this.openingHours,
    required this.rating,
    required this.reviewsCount,
  });
}