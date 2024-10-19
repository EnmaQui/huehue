import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  LatLng location;

  PlaceDetailModel({
    required this.name,
    required this.address,
    required this.phone,
    required this.description,
    required this.website,
    required this.openingHours,
    required this.rating,
    required this.reviewsCount,
    this.photos,
    required this.location,
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
      photos: json['photos'] == null ? null : List<String>.from(json['photos'].map((e) => e['photo_reference'])),
      location: LatLng(json['geometry']['location']['lat'], json['geometry']['location']['lng']),
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
