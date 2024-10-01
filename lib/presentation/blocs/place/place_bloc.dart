import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  }

  Future<void> _initPlace(
      InitPlaceEvent event, Emitter<PlaceState> emit) async {
    try {
      emit(state.copyWith(
        statusRequestPlace: StatusRequestEnum.pending,
      ));
      var granted = await LocationUtils.geolocationIsAvailable();
      if (!granted) {
        granted = await LocationUtils.checkGeolocationPermission();
      }

      emit(state.copyWith(
        statusRequestPlace: StatusRequestEnum.success,
        isPermissionLocationGranted: granted,
      ));

      if (granted) {
        emit(state.copyWith(statusRequestPlace: StatusRequestEnum.pending));

        final position = await LocationUtils.getCurrentLocation();
        if (position != null) {
          final response = await googleMapRepository.getNearbyPlaces(LatLng(
            position.latitude,
            position.longitude,
          ));

          emit(state.copyWith(
            statusRequestPlace: StatusRequestEnum.success,
            userLocation: position,
            nearbyPlaces: response,
          ));
        } else {
          emit(state.copyWith(statusRequestPlace: StatusRequestEnum.success));
        }
      }
    } catch (e) {}
  }
}
