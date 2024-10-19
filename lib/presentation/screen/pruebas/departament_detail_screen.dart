import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:huehue/const/data.const.dart';
import 'package:huehue/enum/StatusRequestEnum.dart';
import 'package:huehue/presentation/blocs/place/place_bloc.dart';
import 'package:huehue/presentation/screen/pruebas/widgets_details/place_photos.dart';
import 'package:huehue/presentation/screen/pruebas/widgets_maps/categorias_widget.dart';
import 'package:huehue/utils/place.utils.dart';
import 'package:iconsax/iconsax.dart';

class DepartamentDetailScreen extends StatefulWidget {
  const DepartamentDetailScreen({super.key});

  static String routeName = '/departament_detail';

  @override
  State<DepartamentDetailScreen> createState() =>
      _DepartamentDetailScreenState();
}

class _DepartamentDetailScreenState extends State<DepartamentDetailScreen> {
  @override
  void initState() {
    super.initState();
    final placeBloc = context.read<PlaceBloc>();

    placeBloc.add(
      GetPlaceDetailEvent(
          place: placeBloc.state.departamenSelected['placeId'] as String),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final placeBloc = context.read<PlaceBloc>();

    return Scaffold(
      // appBar: AppBar(
      //   title: BlocBuilder<PlaceBloc, PlaceState>(
      //     builder: (context, state) {
      //       return Text(state.departamenSelected['name'] ?? '',
      //           style: const TextStyle(color: Colors.white));
      //     },
      //   ),
      //   centerTitle: true,
      // ),
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 0,
                  pinned: true,
                  // expandedHeight: size.height * 0.08,
                  centerTitle: true,
                  title: BlocBuilder<PlaceBloc, PlaceState>(
                    builder: (context, state) {
                      return Text(
                        state.departamenSelected['name'] ?? '',
                        style: const TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ),
                SliverAppBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 0,
                  pinned: true,
                  expandedHeight: size.height * 0.08,
                  leading: const SizedBox(),
                  flexibleSpace: SizedBox(
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
                          type:
                              PlaceUtils.getTypeFromCategory(state.selectedCategory),
                        ));
                      },
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const SizedBox(height: 20),
                      BlocBuilder<PlaceBloc, PlaceState>(
                        builder: (context, state) {
                          if (state.statusRequestPlaceDetail ==
                              StatusRequestEnum.pending) {
                            return const Center(child: CircularProgressIndicator());
                          }
            
                          if ((state.placeDetail?.photos ?? []).isEmpty) {
                            return const SizedBox();
                          }
            
                          return PlacePhotos(photos: state.placeDetail?.photos ?? []);
                        },
                      ),
                      const SizedBox(height: 20),
                      BlocBuilder<PlaceBloc, PlaceState>(
                        builder: (context, state) => Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            state.departamenSelected['name'] ?? '',
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 32),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      BlocBuilder<PlaceBloc, PlaceState>(
                        builder: (context, state) {
                          if (state.statusRequestPlace == StatusRequestEnum.pending) {
                            return const Center(child: CircularProgressIndicator());
                          }
            
                          if (state.nearbyPlaces.isEmpty) {
                            return const Center(
                                child: Text('No hay lugares cercanos'));
                          }
            
                          return Column(
                            children: state.nearbyPlaces
                                .map(
                                  (place) => Card(
                                    color: Color(0xff0C2D57),
                                    elevation: 4,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 16),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(10),
                                      title: Text(
                                        place.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      subtitle: Text(
                                        place.vicinity,
                                        style: const TextStyle(color: Colors.grey),
                                      ),
                                      trailing: place.rating != null
                                          ? Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(Icons.star,
                                                    color: Colors.amber, size: 20),
                                                Text(place.rating.toString(),
                                                    style: const TextStyle(
                                                        fontSize: 16)),
                                              ],
                                            )
                                          : null,
                                      onTap: () {
                                        // onPlaceSelected(place, position); // Pasa la posición del lugar seleccionado
                                      },
                                      leading: place.photos.isNotEmpty
                                          ? ClipOval(
                                              child: Image.network(
                                                '${DataConst.googleMapApi}/place/photo?maxwidth=100&photoreference=${place.photos[0]}&key=${DataConst.googleApiKey}',
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
                                  ),
                                )
                                .toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: size.height * 0.08,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                      padding: const EdgeInsets.all(12),
                      width: size.width * 0.24,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6.0,
                spreadRadius: 1.0,
                offset: Offset(1, 1),
              ),
                        ],
                      ),
                      child: const Row(
                        children: [
              Icon(Iconsax.location),
              SizedBox(width: 10),
              Text("Mapa"),
                        ],
                      ),
                    ),
            ),
          )
        ],
      ),
        );
  }
}
