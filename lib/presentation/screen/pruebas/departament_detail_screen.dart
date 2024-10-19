import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:huehue/enum/StatusRequestEnum.dart';
import 'package:huehue/presentation/blocs/place/place_bloc.dart';
import 'package:huehue/presentation/screen/pruebas/widgets_details/place_photos.dart';
import 'package:huehue/presentation/screen/pruebas/widgets_maps/categorias_widget.dart';

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
      body: CustomScrollView(
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
              child: const CategorySelectorWidget(
                categories: [
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
