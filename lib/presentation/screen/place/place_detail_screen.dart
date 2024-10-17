import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:huehue/enum/StatusRequestEnum.dart';
import 'package:huehue/presentation/blocs/place/place_bloc.dart';
import 'package:huehue/presentation/widgets/list/BaseListWidget.dart';
import 'package:url_launcher/url_launcher.dart'; // Asegúrate de importar el paquete
import '../../widgets/photo_gallery.dart'; // Importa el nuevo widget de galería de fotos
import '../../widgets/review_widget.dart'; // Asegúrate de importar tu widget de reseñas

class PlaceDetailScreen extends StatefulWidget {
  const PlaceDetailScreen({
    super.key,
  });

  static String routeName = '/place-detail';

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
    ); // Tres pestañas: Imágenes, Reseñas y Horarios
  }


  // Color _getOpenCloseColor(String status) {
  //   return status.toLowerCase().contains('cerrado') ? Colors.red : Colors.green;
  // }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaceBloc, PlaceState>(
      builder: (context, state) {
      final review = (state.placeDetail?.reviews ?? []);
        return Scaffold(
          appBar: AppBar(
            title: BlocBuilder<PlaceBloc, PlaceState>(
              buildWhen: (previus, state) => previus.placeSelected != state.placeSelected,
              builder: (context, state) {
                return Text(
                  state.placeSelected?.name ?? '',
                  style: const TextStyle(color: Colors.white),
                );
              },
            ),
            backgroundColor: const Color(0xFF073B4C),
            foregroundColor: Colors.white,
          ),
          body: BlocBuilder<PlaceBloc, PlaceState>(
            builder: (context, state) {
              if (state.statusRequestPlaceDetail == StatusRequestEnum.pending) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.placeSelected?.name ?? 'No disponible',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF073B4C),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              state.placeDetail?.description ?? 'No disponible',
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black87),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.location_pin,
                                    color: Color(0xFFEF476F)),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    state.placeDetail?.address ?? 'No disponible',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black54),
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(Icons.phone,
                                    color: Color(0xFFF78C68)),
                                const SizedBox(width: 5),
                                Text(
                                    state.placeDetail?.phone ?? 'No disponible',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black54),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            GestureDetector(
                              onTap: () async {
                                final Uri url = Uri.parse(state.placeDetail?.website ?? '');
                                if (await canLaunchUrl(url)) {
                                  // Cambia canLaunch por canLaunchUrl
                                  await launchUrl(url,
                                      mode: LaunchMode
                                          .externalApplication,); // Cambia launch por launchUrl
                                }
                              },
                              child: Row(
                                children: [
                                  const Icon(Icons.web,
                                      color: Color(0xFF118AB2)),
                                  const SizedBox(width: 5),
                                  Flexible(
                                    child: Text(
                                      state.placeDetail?.website ?? 'No disponible',
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black54),
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Color(0xFFFFD166)),
                                const SizedBox(width: 5),
                                Text(
                                  'Calificación: ${state.placeDetail?.rating ?? 'No disponible'}',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black87),
                                ),
                              ],
                            ),
                            Text(
                              'Número de Reseñas: ${state.placeDetail?.reviewsCount ?? 'No disponible'}',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: const Color(0xFF118AB2),
                      labelColor: const Color(0xFF073B4C),
                      tabs: const [
                        Tab(text: 'Imágenes'),
                        Tab(text: 'Reseñas'),
                        Tab(text: 'Horarios'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        PhotoGallery(images: (state.placeDetail?.photos ?? [])),
                        NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scrollInfo) {
                            if (scrollInfo.metrics.axis == Axis.horizontal) {
                              return true; // Detener el evento si se desliza horizontalmente
                            }
                            return false; // Permitir el desplazamiento vertical
                          },
                          child: review.isNotEmpty
                              ? BaseListWidget(
                                  itemCount: review.length,
                                  itemBuilder: (context, index) {
                                    return ReviewWidget(
                                      reviewerName: review[index].reviewerName,
                                      reviewText: review[index].reviewText,
                                      rating: review[index].rating,
                                      photos: (review[index].photos),
                                    );
                                  },
                                )
                              : const Center(
                                  child: Text('No hay reseñas disponibles'),),
                        ),
                          const SizedBox()
                        // if ((state.placeDetail?.openingHours.periods ?? []).isNotEmpty)
                          // SingleChildScrollView(
                          //   child: Container(
                          //     decoration: BoxDecoration(
                          //       color: Colors.white,
                          //       boxShadow: [
                          //         BoxShadow(
                          //           color: Colors.grey.withOpacity(0.5),
                          //           spreadRadius: 2,
                          //           blurRadius: 5,
                          //           offset: const Offset(0, 3),
                          //         ),
                          //       ],
                          //       borderRadius: BorderRadius.circular(10),
                          //     ),
                          //     child: DataTable(
                          //       columns: const [
                          //         DataColumn(
                          //           label: Text('Día',
                          //               style: TextStyle(
                          //                   fontWeight: FontWeight.bold)),
                          //         ),
                          //         DataColumn(
                          //           label: Text('Horario',
                          //               style: TextStyle(
                          //                   fontWeight: FontWeight.bold)),
                          //         ),
                          //         DataColumn(
                          //           label: Text('Estado',
                          //               style: TextStyle(
                          //                   fontWeight: FontWeight.bold)),
                          //         ),
                          //       ],
                          //       // rows: (state.placeDetail?.openingHours.periods ?? []).map((entry) {
                          //       //   return DataRow(cells: [
                          //       //     DataCell(Text(entry.key)),
                          //       //     DataCell(Text(entry.value)),
                          //       //     DataCell(
                          //       //       Text(
                          //       //         entry..contains('cerrado')
                          //       //             ? 'Cerrado'
                          //       //             : 'Abierto',
                          //       //         style: TextStyle(
                          //       //             color: _getOpenCloseColor(
                          //       //                 entry.value)),
                          //       //       ),
                          //       //     ),
                          //       //   ]);
                          //       // }).toList(),
                          //     ),
                          //   ),
                          // )
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
