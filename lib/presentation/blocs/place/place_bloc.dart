import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:huehue/domain/repository/google/google.map.repository.dart';
import 'package:huehue/enum/StatusRequestEnum.dart';

part 'place_event.dart';
part 'place_state.dart';

class PlaceBloc extends Bloc<PlaceEvent, PlaceState> {
  final GoogleMapRepository googleMapRepository;

  PlaceBloc({
    required this.googleMapRepository,
  }) : super(const PlaceState()) {
    on<InitPlaceEvent>(_initPlace);
  }

  Future<void> _initPlace(InitPlaceEvent event, Emitter<PlaceState> emit) async {
    // emit(state.copyWith(statusRequestPlace: StatusRequestEnum.loading));
  }
}
