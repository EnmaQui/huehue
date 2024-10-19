part of 'calculator_bloc.dart';

abstract class CalculatorEvent {
  const CalculatorEvent();
}

class TogglePlaceToCalculator extends CalculatorEvent {
  final PlaceEntity place;
  const TogglePlaceToCalculator({
    required this.place,
  });
}