part of 'place_bloc.dart';

abstract class PlaceEvent {
  const PlaceEvent();
}

class InitPlaceEvent extends PlaceEvent {
  const InitPlaceEvent();
}

class FilterPlaceByTypeEvent extends PlaceEvent {
  final String type;
  const FilterPlaceByTypeEvent({
    required this.type,
  });
}

class GetPlaceDetailEvent extends PlaceEvent {
  final PlaceEntity place;
  const GetPlaceDetailEvent({
    required this.place,
  });
}