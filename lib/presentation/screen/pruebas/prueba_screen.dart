import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:huehue/const/assent.const.dart';
import 'package:huehue/const/data.const.dart';
import 'package:huehue/const/departaments.const.dart';
import 'package:huehue/enum/StatusRequestEnum.dart';
import 'package:huehue/presentation/blocs/place/place_bloc.dart';
import 'package:huehue/presentation/screen/pruebas/departament_detail_screen.dart';
import 'package:huehue/presentation/screen/pruebas/widgets/principal_departament.dart';
import 'package:huehue/presentation/screen/pruebas/widgets/search_bar_widget.dart';
import 'package:huehue/presentation/widgets/list/BaseListWidget.dart';

class PruebasScreen extends StatefulWidget {
  const PruebasScreen({super.key});

  @override
  State<PruebasScreen> createState() => _PruebasScreenState();
}

class _PruebasScreenState extends State<PruebasScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    final placeBloc = context.read<PlaceBloc>();

    placeBloc.add(
      GetPlaceRating(
        placeIds: departamentos.map((e) => e['placeId'] as String).toList(),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = MediaQuery.of(context).size;
    final placeBloc = context.read<PlaceBloc>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            centerTitle: false,
            // stretch: true,
            title: Row(
              children: [
                Image.asset(
                  AsssentConst.logo,
                  width: 35,
                  height: 35,
                ),
                const SizedBox(width: 10),
                const Text(
                  'Huehue',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SliverAppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            pinned: true,
            flexibleSpace: const SafeArea(child: SearchBarWidget()),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 30),
                BlocBuilder<PlaceBloc, PlaceState>(
                  builder: (context, state) {
                    if (state.statusRequestImageUrlsByPlace ==
                        StatusRequestEnum.pending) {
                      return SizedBox(
                        height: size.height * 0.30,
                        child: const Center(
                            child: CircularProgressIndicator.adaptive()),
                      );
                    }

                    if (state.imageUrlsByPlace.isEmpty) {
                      return const SizedBox();
                    }

                    final image = state.imageUrlsByPlace[0];
                    return Center(
                      child: PrincipalDepartament(
                        image: image,
                        title: departamentos[0]['name'] as String,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Text(
                    'Departamentos',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: size.height * 0.30,
                  child: BlocBuilder<PlaceBloc, PlaceState>(
                    builder: (context, state) {
                      if (state.statusRequestImageUrlsByPlace ==
                          StatusRequestEnum.pending) {
                        return SizedBox(
                          height: size.height * 0.30,
                          child: const Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        );
                      }

                      if (state.imageUrlsByPlace.isEmpty) {
                        return const SizedBox();
                      }

                      return SizedBox(
                        child: BaseListWidget(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          scrollDirection: Axis.horizontal,
                          itemCount: state.imageUrlsByPlace.length,
                          itemBuilder: (context, index) {
                            final nameDepartament =
                                departamentos[index]['name'] as String;
                            final image = state.imageUrlsByPlace[index];
                            return GestureDetector(
                              onTap: () {
                                placeBloc.add(
                                  SetSelectedDepartment(
                                    department: departamentos[index],
                                  )
                                );
                                Navigator.of(context).pushNamed(DepartamentDetailScreen.routeName);
                              },
                              child: Center(
                                child: SizedBox(
                                  width: size.width * 0.5,
                                  height: size.height * 0.3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: CachedNetworkImage(
                                          width: double.infinity,
                                          height: size.height * 0.20,
                                          imageUrl: image,
                                          fit: BoxFit.cover,
                                          progressIndicatorBuilder:
                                              (context, url, progress) =>
                                                  const Center(
                                            child: CupertinoActivityIndicator(),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Center(
                                            child: Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        nameDepartament,
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
