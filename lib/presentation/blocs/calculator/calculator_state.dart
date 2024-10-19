part of 'calculator_bloc.dart';

class CalculatorState extends Equatable {
  final List<PlaceEntity> placesCalculates;

  const CalculatorState({
    this.placesCalculates = const []
  });

  CalculatorState copyWith({
    List<PlaceEntity>? placesCalculates
  }) =>  CalculatorState(
      placesCalculates: placesCalculates ?? this.placesCalculates
    );

  @override
  List<Object?> get props => [
    placesCalculates
  ];

}