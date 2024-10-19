import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:huehue/domain/entity/place/PlaceEntity.dart';

part 'calculator_event.dart';
part 'calculator_state.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  CalculatorBloc() : super(const CalculatorState()) {
    on<TogglePlaceToCalculator>(_togglePlaceToCalculator);
  }

  List<String> currentPlacId = [];

  void _togglePlaceToCalculator(
    TogglePlaceToCalculator event,
    Emitter<CalculatorState> emit,
  ) {
    final placIds =
        state.placesCalculates.map((place) => place.placeId).toList();
    if (placIds.contains(event.place.placeId)) {
      emit(state.copyWith(
        placesCalculates: state.placesCalculates
            .where((place) => place.placeId != event.place.placeId)
            .toList(),
      ));
    } else {
      emit(
        state.copyWith(
          placesCalculates: [...state.placesCalculates, event.place],
        ),
      );
    }
    currentPlacId =
        state.placesCalculates.map((place) => place.placeId).toList();
  }
}
