part of 'place_bloc.dart';

abstract class PlaceEvent {
  const PlaceEvent();
}

class InitPlaceEvent extends PlaceEvent {
  const InitPlaceEvent();
}