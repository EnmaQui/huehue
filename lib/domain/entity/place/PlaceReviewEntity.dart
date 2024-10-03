class PlaceReviewEntity {
  String reviewerName;
  String reviewText;
  double rating;
  List<String> photos;

  PlaceReviewEntity({
    required this.reviewerName,
    required this.reviewText,
    required this.rating,
    required this.photos,
  });
}
