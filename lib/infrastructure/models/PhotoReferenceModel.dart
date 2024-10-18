class PhotoReferenceModel {
  int? height;
  List<String>? htmlAttributions;
  String? photoReference;
  int? width;

  PhotoReferenceModel(
      {this.height, this.htmlAttributions, this.photoReference, this.width});

  PhotoReferenceModel.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    htmlAttributions = json['html_attributions'].cast<String>();
    photoReference = json['photo_reference'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() => {
        'height': height,
        'html_attributions': htmlAttributions,
        'photo_reference': photoReference,
        'width': width,
      };
}
