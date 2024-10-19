import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:huehue/const/map.style.const.dart';
import 'package:huehue/enum/StatusRequestEnum.dart';
import 'package:huehue/presentation/blocs/place/place_bloc.dart';
import 'package:huehue/presentation/screen/pruebas/widgets_maps/categorias_widget.dart';
import 'package:huehue/presentation/widgets/list/BaseListWidget.dart';
import 'package:huehue/utils/place.utils.dart';

class DepartamenDetailMapScreen extends StatefulWidget {
  const DepartamenDetailMapScreen({super.key});

  static String routeName = '/departament_detail_map_screen';

  @override
  State<DepartamenDetailMapScreen> createState() =>
      _DepartamenDetailMapScreenState();
}

class _DepartamenDetailMapScreenState extends State<DepartamenDetailMapScreen> {
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    final placeBloc = context.read<PlaceBloc>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<PlaceBloc, PlaceState>(
          builder: (context, state) {
            return Text(
              state.departamenSelected['name'] ?? '',
              style: const TextStyle(color: Colors.white),
            );
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            width: size.width,
            // height: size.height * 0.8,
            child: CategorySelectorWidget(
              categories: const [
                'Iglesias',
                'Restaurantes',
                'Monumentos',
                'Edificios históricos',
                'Playas',
                'Reservas Naturales',
                'Parques',
                'Tiendas de conveniencia',
                'Centros comerciales',
                'Volcanes',
                'Montañas',
                'Islas',
              ],
              onChange: () async {
                await Future.delayed(const Duration(seconds: 1));
                final state = context.read<PlaceBloc>().state;
                placeBloc.add(FilterPlaceByTypeEvent(
                  location: state.placeDetail!.location,
                  type: PlaceUtils.getTypeFromCategory(state.selectedCategory),
                ));
              },
            ),
          ),
          Expanded(
            child: SizedBox(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: BlocBuilder<PlaceBloc, PlaceState>(
                      builder: (context, state) {
                        return GoogleMap(
                          style: mapStyleConst,
                          myLocationEnabled: true,
                          zoomControlsEnabled: false,
                          polylines: state.polylines ?? {},
                          initialCameraPosition: const CameraPosition(
                            target: LatLng(12.1364, -86.2514),
                            zoom: 6,
                          ),
                          onMapCreated: (controller) {
                            final locationDepartament =
                                placeBloc.state.placeDetail!.location;
                            mapController = controller;
                            controller.animateCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(
                                  target: locationDepartament,
                                  zoom: 15,
                                ),
                              ),
                            );
                            // if (userLocation != null) _updateUserLocationMarker();
                          },
                          // polylines: routePolyline != null ? {routePolyline!} : {},
                        );
                      },
                    ),
                  ),
                  BlocBuilder<PlaceBloc, PlaceState>(
                    builder: (context, state) {
                      if(state.statusGetPolylines != StatusRequestEnum.pending) {
                        return Positioned(bottom: 0, child: const SizedBox());
                      }

                      return const Positioned.fill(
                        child: Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: size.height * 0.05,
                    child: SizedBox(
                      width: size.width,
                      height: size.height * 0.2,
                      // color: Colors.red,
                      child: BlocBuilder<PlaceBloc, PlaceState>(
                        builder: (context, state) {
                          if (state.statusRequestPlace ==
                              StatusRequestEnum.pending) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return BaseListWidget(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            scrollDirection: Axis.horizontal,
                            itemCount: state.nearbyPlaces.length,
                            itemBuilder: (context, index) {
                              final place = state.nearbyPlaces[index];

                              return GestureDetector(
                                onTap: () {
                                  placeBloc.add(GetPolilyesByLocation(
                                    location: place.coordinates,
                                  ));
                                },
                                child: Container(
                                  width: 250,
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 4.0,
                                        spreadRadius: 1.0,
                                        offset: Offset(1, 1),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 200,
                                        child: Text(
                                          place.name,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall
                                              ?.copyWith(color: Colors.white),
                                        ),
                                      ),
                                      const Spacer(),
                                      StarRating(
                                        rating: place.rating != null
                                            ? place.rating!.toDouble()
                                            : 0.0,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
