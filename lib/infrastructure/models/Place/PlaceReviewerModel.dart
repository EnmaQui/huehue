class PlaceReviewModel {
  final String reviewerName;
  final String reviewText;
  final double rating;
  final List<String> photos;

  PlaceReviewModel({
    required this.reviewerName,
    required this.reviewText,
    required this.rating,
    required this.photos,
  });

  factory PlaceReviewModel.fromJson(Map<String, dynamic> json) {
    return PlaceReviewModel(
      reviewerName: json['author_name'],
      reviewText: json['text'],
      rating: json['rating'].toDouble(),
      photos: json['profile_photo_url'] != null ? [json['profile_photo_url']] : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'reviewer_name': reviewerName,
    'review_text': reviewText,
    'rating': rating,
    'photos': photos,
  };
}