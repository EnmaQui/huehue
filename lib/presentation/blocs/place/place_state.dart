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
  
  const PlaceState({
    this.statusRequestPlace = StatusRequestEnum.idle,
    this.userLocation,
    this.isPermissionLocationGranted = false,
    this.statusRequestLocation = StatusRequestEnum.idle,
    this.nearbyPlaces = const [],
    this.placeSelected,
    this.placeDetail,
    this.statusRequestPlaceDetail = StatusRequestEnum.idle
  });

  PlaceState copyWith({
    StatusRequestEnum? statusRequestPlace,
    Position? userLocation,
    bool? isPermissionLocationGranted,
    StatusRequestEnum? statusRequestLocation,
    List<PlaceEntity>? nearbyPlaces,
    PlaceEntity? placeSelected,
    PlaceDetailEntity? placeDetail,
    StatusRequestEnum? statusRequestPlaceDetail
  }) {
    return PlaceState(
      statusRequestPlace: statusRequestPlace ?? this.statusRequestPlace,
      userLocation: userLocation ?? this.userLocation,
      isPermissionLocationGranted: isPermissionLocationGranted ?? this.isPermissionLocationGranted,
      statusRequestLocation: statusRequestLocation ?? this.statusRequestLocation,
      nearbyPlaces: nearbyPlaces ?? this.nearbyPlaces,
      placeSelected: placeSelected ?? this.placeSelected,
      placeDetail: placeDetail ?? this.placeDetail,
      statusRequestPlaceDetail: statusRequestPlaceDetail ?? this.statusRequestPlaceDetail
    );
  }


  @override
  List<Object> get props => [
    statusRequestPlace,
    isPermissionLocationGranted,
    statusRequestLocation,
    nearbyPlaces,
    statusRequestPlaceDetail
  ];
}
