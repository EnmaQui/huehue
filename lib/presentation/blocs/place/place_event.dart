part of 'place_bloc.dart';

abstract class PlaceEvent {
  const PlaceEvent();
}

class InitPlaceEvent extends PlaceEvent {
  const InitPlaceEvent();
}

class FilterPlaceByTypeEvent extends PlaceEvent {
  final String type;
  final LatLng location;
  
  const FilterPlaceByTypeEvent({
    required this.type,
    required this.location
  });
}

class GetPlaceDetailEvent extends PlaceEvent {
  final String place;
  const GetPlaceDetailEvent({
    required this.place,
  });
}

class GetPlaceRating extends PlaceEvent {
  final List<String> placeIds;


  const GetPlaceRating({
    required this.placeIds
  });
}

class SetSelectedCategory extends PlaceEvent {
  final String category;
  const SetSelectedCategory({
    required this.category
  });
}

class SetSelectedDepartment extends PlaceEvent {
  final Map<String, String> department;
  const SetSelectedDepartment({
    required this.department
  });
}