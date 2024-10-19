import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:huehue/const/data.const.dart';
import 'package:huehue/domain/entity/place/PlaceEntity.dart';
import 'package:huehue/enum/StatusRequestEnum.dart';
import 'package:huehue/presentation/blocs/place/place_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:responsive_grid/responsive_grid.dart';

class MapDetailsPlace extends StatelessWidget {
  const MapDetailsPlace({super.key, required this.onTap});

  final Function(PlaceEntity place, LatLng position) onTap;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      snap: true,
      snapSizes: const [0.4, 0.6],
      initialChildSize: 0.4,
      minChildSize: 0.4,
      maxChildSize: 0.6,
      builder: (context, scrollController) => Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 8,
            right: 8,
            bottom: 8,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                  ),
                  child: ResponsiveGridRow(
                    children: [
                      ResponsiveGridCol(
                        sm: 12,
                        child: Center(
                          child: Container(
                            width: 60,
                            height: 5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                      ),
                      ResponsiveGridCol(
                        child: BlocBuilder<PlaceBloc, PlaceState>(
                          buildWhen: (previous, current) => previous.statusRequestPlace != current.statusRequestPlace,
                          builder: (context, state) {
                            if (state.statusRequestPlace ==
                                StatusRequestEnum.pending) {
                              return const Center(
                                child: CircularProgressIndicator.adaptive(),
                              );
                            }

                            if (state.nearbyPlaces.isEmpty) {
                              return const Center(
                                child: Text('No places found'),
                              );
                            }

                            state.nearbyPlaces.sort((a, b) {
                              dynamic ratingA = a.rating ?? 0.0;
                              dynamic ratingB = b.rating ?? 0.0;

                              return ratingB.compareTo(ratingA);
                            });
                            return Column(
                              children: state.nearbyPlaces.map((element) {
                                return Card(
                                  elevation: 4,
                                  // margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(10),
                                    title: Text(
                                      element.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      element.vicinity,
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Iconsax.heart),
                                      onPressed: () {
                                        // onPlaceSelected(place, position); // Pasa la … del lugar seleccionado
                                      },
                                    ),
                                    onTap: () {
                                      // onPlaceSelected(place, position); // Pasa la posición del lugar seleccionado
                                      onTap(element, element.coordinates);
                                    },
                                    leading: element.photos.isNotEmpty
                                        ? ClipOval(
                                            child: Image.network(
                                              'https://maps.googleapis.com/maps/api/place/photo?maxwidth=100&photoreference=${element.photos[0]}&key=${DataConst.googleApiKey}',
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
                              }).toList(),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
