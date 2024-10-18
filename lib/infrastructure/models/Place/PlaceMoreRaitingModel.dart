class PlaceMoreRaitingModel {
  String? name;
  List<String>? photos;
  double? rating;

  PlaceMoreRaitingModel({this.name, this.photos, this.rating});

  PlaceMoreRaitingModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    photos = ((json['photos'] as List?) ?? [])
        .map((v) => v['photo_reference'] as String)
        .toList();
    rating = json['rating'];
  }
}