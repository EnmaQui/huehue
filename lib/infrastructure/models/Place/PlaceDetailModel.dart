import 'package:huehue/infrastructure/models/Place/PlaceOpeningModel.dart';

class PlaceDetailModel {
  String name;
  String address;
  String phone;
  String description;
  String website;
  PlaceOpeningModel openingHours;
  String rating;
  int reviewsCount;

  PlaceDetailModel({
    required this.name,
    required this.address,
    required this.phone,
    required this.description,
    required this.website,
    required this.openingHours,
    required this.rating,
    required this.reviewsCount,
  });

  factory PlaceDetailModel.fromJson(Map<String, dynamic> json) {
    return PlaceDetailModel(
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      description: json['description'],
      website: json['website'],
      openingHours: PlaceOpeningModel.fromJson(json['opening_hours']),
      rating: json['rating'].toString(),
      reviewsCount: json['user_ratings_total'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'address': address,
    'phone': phone,
    'description': description,
    'website': website,
    'opening_hours': openingHours.toJson(),
    'rating': rating,
    'user_ratings_total': reviewsCount,
  };
}
