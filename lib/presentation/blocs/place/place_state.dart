part of 'place_bloc.dart';

class PlaceState extends Equatable {
  final StatusRequestEnum statusRequestPlace;
  final StatusRequestEnum statusRequestLocation;
  final StatusRequestEnum statusRequestPlaceDetail;


  final PlaceEntity? placeSelected;
  final PlaceDetailEntity? placeDetail;

  final Position? userLocation;
  final bool isPermissionLocationGranted;
  final List<PlaceEntity> nearbyPlaces;

  final List<String> imageUrlsByPlace;
  final StatusRequestEnum statusRequestImageUrlsByPlace;
  
  const PlaceState({
    this.statusRequestPlace = StatusRequestEnum.idle,
    this.userLocation,
    this.isPermissionLocationGranted = false,
    this.statusRequestLocation = StatusRequestEnum.idle,
    this.nearbyPlaces = const [],
    this.placeSelected,
    this.placeDetail,
    this.statusRequestPlaceDetail = StatusRequestEnum.idle,
    this.imageUrlsByPlace = const [],
    this.statusRequestImageUrlsByPlace = StatusRequestEnum.idle
  });

  PlaceState copyWith({
    StatusRequestEnum? statusRequestPlace,
    Position? userLocation,
    bool? isPermissionLocationGranted,
    StatusRequestEnum? statusRequestLocation,
    List<PlaceEntity>? nearbyPlaces,
    PlaceEntity? placeSelected,
    PlaceDetailEntity? placeDetail,
    StatusRequestEnum? statusRequestPlaceDetail,
    List<String>? imageUrlsByPlace,
    StatusRequestEnum? statusRequestImageUrlsByPlace
  }) {
    return PlaceState(
      statusRequestPlace: statusRequestPlace ?? this.statusRequestPlace,
      userLocation: userLocation ?? this.userLocation,
      isPermissionLocationGranted: isPermissionLocationGranted ?? this.isPermissionLocationGranted,
      statusRequestLocation: statusRequestLocation ?? this.statusRequestLocation,
      nearbyPlaces: nearbyPlaces ?? this.nearbyPlaces,
      placeSelected: placeSelected ?? this.placeSelected,
      placeDetail: placeDetail ?? this.placeDetail,
      statusRequestPlaceDetail: statusRequestPlaceDetail ?? this.statusRequestPlaceDetail,
      imageUrlsByPlace: imageUrlsByPlace ?? this.imageUrlsByPlace,
      statusRequestImageUrlsByPlace: statusRequestImageUrlsByPlace ?? this.statusRequestImageUrlsByPlace
    );
  }


  @override
  List<Object> get props => [
    statusRequestPlace,
    isPermissionLocationGranted,
    statusRequestLocation,
    nearbyPlaces,
    statusRequestPlaceDetail,
    imageUrlsByPlace,
    statusRequestImageUrlsByPlace
  ];
}
