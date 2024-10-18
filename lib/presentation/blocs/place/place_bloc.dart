import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:huehue/domain/entity/place/PlaceDetailEntity.dart';
import 'package:huehue/domain/entity/place/PlaceEntity.dart';
import 'package:huehue/domain/repository/google/google.map.repository.dart';
import 'package:huehue/enum/StatusRequestEnum.dart';
import 'package:huehue/utils/location.utils.dart';

part 'place_event.dart';
part 'place_state.dart';

class PlaceBloc extends Bloc<PlaceEvent, PlaceState> {
  final GoogleMapRepository googleMapRepository;

  PlaceBloc({
    required this.googleMapRepository,
  }) : super(const PlaceState()) {
    on<InitPlaceEvent>(_initPlace);
    on<FilterPlaceByTypeEvent>(_filterPlaceByType);
    on<GetPlaceDetailEvent>(_getPlaceDetail);
    on<GetPlaceRating>(_getPlaceRating);
    on<SetSelectedCategory>(_setSelectedCategory);
  }

  void _setSelectedCategory(
    SetSelectedCategory event,
    Emitter<PlaceState> emit,
  ) {
    emit(state.copyWith(selectedCategory: event.category));
  }


  Future<void> _getPlaceRating(
    GetPlaceRating event,
    Emitter<PlaceState> emit,
  ) async {
    try {
      emit(state.copyWith(statusRequestImageUrlsByPlace: StatusRequestEnum.pending));

      final reponse = await googleMapRepository.fetchImageUrls(event.placeIds);

      emit(state.copyWith(
        statusRequestImageUrlsByPlace: StatusRequestEnum.success,
        imageUrlsByPlace: reponse
      ));

    } catch (e) {
      emit(state.copyWith(statusRequestImageUrlsByPlace: StatusRequestEnum.error));
    }
  }

  Future<void> _getPlaceDetail(
    GetPlaceDetailEvent event,
    Emitter<PlaceState> emit,
  ) async {
   try {
      emit(state.copyWith(
      statusRequestPlaceDetail: StatusRequestEnum.pending,
      placeSelected: event.place,
    ));

    final place = await googleMapRepository.getPlaceDetails(event.place.placeId);
    
    emit(state.copyWith(
      statusRequestPlaceDetail: StatusRequestEnum.success,
      placeDetail: place,
    ));
   } catch (e) {
     emit(state.copyWith(
       statusRequestPlaceDetail: StatusRequestEnum.error
     ));
   }
  }

  Future<void> _filterPlaceByType(
    FilterPlaceByTypeEvent event,
    Emitter<PlaceState> emit,
  ) async {
    // if(state.userLocation == null) return;

    emit(state.copyWith(statusRequestPlace: StatusRequestEnum.pending));
    final response = await googleMapRepository.getNearbyPlaces(event.location, 1500, event.type);

     final filteredPlaces =
          response.where((place) => place.types.contains(event.type)).toList();
    
    emit(state.copyWith(
      statusRequestPlace: StatusRequestEnum.success,
      nearbyPlaces: filteredPlaces,
    ));
  }

  Future<void> _initPlace(
      InitPlaceEvent event, Emitter<PlaceState> emit) async {
    try {
      emit(state.copyWith(
        statusRequestLocation: StatusRequestEnum.pending,
      ));
      var granted = await LocationUtils.geolocationIsAvailable();
      if (!granted) {
        granted = await LocationUtils.checkGeolocationPermission();
      }

      emit(state.copyWith(
        statusRequestLocation: StatusRequestEnum.success,
        isPermissionLocationGranted: granted,
      ));

      if (granted) {
        emit(state.copyWith(statusRequestPlace: StatusRequestEnum.pending));

        // final position = await LocationUtils.getCurrentLocation();
        // if (position != null) {
        //   final response = await googleMapRepository.getNearbyPlaces(LatLng(
        //     position.latitude,
        //     position.longitude,
        //   ));

        //   emit(state.copyWith(
        //     statusRequestPlace: StatusRequestEnum.success,
        //     userLocation: position,
        //     nearbyPlaces: response,
        //   ));
        // } else {
        //   emit(state.copyWith(statusRequestPlace: StatusRequestEnum.success));
        // }
      }
    } catch (e) {}
  }
}
