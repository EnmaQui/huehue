import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:huehue/const/data.const.dart';
import 'package:huehue/enum/PriceLevelEnum.dart';
import 'package:huehue/presentation/blocs/calculator/calculator_bloc.dart';
import 'package:huehue/presentation/widgets/list/BaseListWidget.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  static String routeName = '/calculator';

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Calculadora'),
      // ),
      body: SafeArea(
        child: SizedBox(
          child: BlocBuilder<CalculatorBloc, CalculatorState>(
            builder: (context, state) {
              if (state.placesCalculates.isEmpty) {
                return const Center(
                  child: Text('No places to calculate'),
                );
              }

              return BaseListWidget(
                itemCount: state.placesCalculates.length,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12,
                ),
                itemBuilder: (context, index) {
                  final place = state.placesCalculates[index];

                  return Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      title: Text(
                        place.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: place.priceLevel != null ? Container(
                        decoration: BoxDecoration(
                          color: getPriceColor(place.priceLevel!),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            getPriceTitle(place.priceLevel!),
                          ),
                        ),
                      ) : null,
                       leading: place.photos.isNotEmpty
                                        ? ClipOval(
                                            child: Image.network(
                                              'https://maps.googleapis.com/maps/api/place/photo?maxwidth=100&photoreference=${place.photos[0]}&key=${DataConst.googleApiKey}',
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : const CircleAvatar(
                                            backgroundColor: Colors.grey,
                                            child: Icon(Icons.place,
                                                color: Colors.white),
                                          ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Color getPriceColor(PriceLevelEnum priceLevel) {
    switch (priceLevel) {
      case PriceLevelEnum.free:
        return Colors.green;
      case PriceLevelEnum.cheap:
        return Colors.yellow;
      case PriceLevelEnum.moderate:
        return Colors.orange;
      case PriceLevelEnum.expensive:
        return Colors.red;
      case PriceLevelEnum.veryExpensive:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String getPriceTitle(PriceLevelEnum priceLevel) {
    switch (priceLevel) {
      case PriceLevelEnum.free:
        return 'Gratis';
      case PriceLevelEnum.cheap:
        return 'Barato';
      case PriceLevelEnum.moderate:
        return 'Moderado';
      case PriceLevelEnum.expensive:
        return 'Caro';
      case PriceLevelEnum.veryExpensive:
        return 'Muy caro';
      default:
        return '';
    }
  }

  @override
  bool get wantKeepAlive => true;
}
