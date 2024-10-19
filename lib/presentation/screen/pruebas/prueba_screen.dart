import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:huehue/const/assent.const.dart';
import 'package:huehue/const/data.const.dart';
import 'package:huehue/const/departaments.const.dart';
import 'package:huehue/enum/StatusRequestEnum.dart';
import 'package:huehue/presentation/blocs/place/place_bloc.dart';
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
                    color: Color(0xFF0e647e),
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
                      return const Center(
                          child: CircularProgressIndicator.adaptive());
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
                      // color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: size.height * 0.30,
                  child: BaseListWidget(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Center(
                          child: Container(
                            width: size.width * 0.7,
                            height: size.height * 0.3,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      }),
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
