import 'package:huehue/infrastructure/models/Place/PlaceOpeningModel.dart';
import 'package:huehue/infrastructure/models/Place/PlaceReviewerModel.dart';

class PlaceDetailModel {
  String name;
  String? address;
  String? phone;
  String? description;
  String? website;
  PlaceOpeningModel? openingHours;
  double? rating;
  int? reviewsCount;
  List<PlaceReviewModel>? reviews;
  List<String>? photos;

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
      address: json['formatted_address'],
      phone: json['formatted_phone_number'],
      description: json['description'] ?? json['vicinity'],
      website: json['website'],
      openingHours: json['opening_hours'] == null ? null : PlaceOpeningModel.fromJson(json['opening_hours']),
      rating: json['rating'],
      reviewsCount:  json['user_ratings_total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'address': address,
    'phone': phone,
    'description': description,
    'website': website,
    'opening_hours': openingHours?.toJson(),
    'rating': rating,
    'reviews_count': reviewsCount,
  };
}
