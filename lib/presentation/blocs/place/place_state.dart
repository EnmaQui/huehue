part of 'place_bloc.dart';

class PlaceState extends Equatable {
  final StatusRequestEnum statusRequestPlace;
  
  const PlaceState({
    this.statusRequestPlace = StatusRequestEnum.idle,
  });

  PlaceState copyWith({
    StatusRequestEnum? statusRequestPlace,
  }) {
    return PlaceState(
      statusRequestPlace: statusRequestPlace ?? this.statusRequestPlace,
    );
  }


  @override
  List<Object> get props => [
    statusRequestPlace
  ];
}
