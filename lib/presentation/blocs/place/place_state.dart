part of 'place_bloc.dart';

class PlaceState extends Equatable {
  final StatusRequestEnum statusRequestPlace;
  final StatusRequestEnum statusRequestLocation;
  final Position? userLocation;
  final bool isPermissionLocationGranted;
  final List<PlaceEntity> nearbyPlaces;
  
  const PlaceState({
    this.statusRequestPlace = StatusRequestEnum.idle,
    this.userLocation,
    this.isPermissionLocationGranted = false,
    this.statusRequestLocation = StatusRequestEnum.idle,
    this.nearbyPlaces = const [],
  });

  PlaceState copyWith({
    StatusRequestEnum? statusRequestPlace,
    Position? userLocation,
    bool? isPermissionLocationGranted,
    StatusRequestEnum? statusRequestLocation,
    List<PlaceEntity>? nearbyPlaces
  }) {
    return PlaceState(
      statusRequestPlace: statusRequestPlace ?? this.statusRequestPlace,
      userLocation: userLocation ?? this.userLocation,
      isPermissionLocationGranted: isPermissionLocationGranted ?? this.isPermissionLocationGranted,
      statusRequestLocation: statusRequestLocation ?? this.statusRequestLocation,
      nearbyPlaces: nearbyPlaces ?? this.nearbyPlaces
    );
  }


  @override
  List<Object> get props => [
    statusRequestPlace,
    isPermissionLocationGranted,
    statusRequestLocation,
    nearbyPlaces
  ];
}
