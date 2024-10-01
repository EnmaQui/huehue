import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart'; // Asegúrate de importar el paquete
import '../../../services/place_service.dart'; // Asegúrate de que la ruta sea correcta
import '../../widgets/photo_gallery.dart'; // Importa el nuevo widget de galería de fotos
import '../../widgets/review_widget.dart'; // Asegúrate de importar tu widget de reseñas

class PlaceDetailScreen extends StatefulWidget {
  final LatLng coordinates;
  final String placeId;

  const PlaceDetailScreen({
    super.key,
    required this.coordinates,
    required this.placeId,
  });

  @override
  _PlaceDetailScreenState createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen>
    with SingleTickerProviderStateMixin {
  String name = '';
  String description = 'Cargando...';
  String address = 'Cargando...';
  String phone = 'Cargando...';
  String website = 'Cargando...';
  Map<String, String> openingHours = {};
  String rating = 'Cargando...';
  String reviewsCount = 'Cargando...';
  List<String> images = [];
  List<Map<String, dynamic>> reviews = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _fetchPlaceDetails();
    _fetchPlacePhotos();
    _fetchPlaceReviews();
    _tabController = TabController(length: 3, vsync: this); // Tres pestañas: Imágenes, Reseñas y Horarios
  }

  Future<void> _fetchPlaceDetails() async {
    try {
      final details = await PlacesService.fetchPlaceDetails(
          widget.placeId, 'AIzaSyCNNLly_rF6NkMMgoFAl5dv8lfCmu00mnY');
      setState(() {
        name = details['name'] ?? 'Nombre no disponible';
        description = details['description'] ?? 'Descripción no disponible';
        address = details['address'] ?? 'Dirección no disponible';
        phone = details['phone'] ?? 'Teléfono no disponible';
        website = details['website'] ?? 'Sitio web no disponible';
        openingHours = Map<String, String>.from(details['opening_hours'] ?? {});
        rating = details['rating'] ?? 'Sin calificación';
        reviewsCount = details['reviews_count'] ?? 'Sin reseñas';
      });
    } catch (e) {
      setState(() {
        description = 'Error al cargar detalles del lugar';
      });
    }
  }

  Future<void> _fetchPlacePhotos() async {
    try {
      final photoUrls = await PlacesService.fetchPlacePhotos(
          widget.placeId, 'AIzaSyCNNLly_rF6NkMMgoFAl5dv8lfCmu00mnY');
      setState(() {
        images = photoUrls.isNotEmpty ? List<String>.from(photoUrls) : [];
      });
    } catch (e) {
      // Manejar errores específicos si lo deseas
    }
  }

  Future<void> _fetchPlaceReviews() async {
    try {
      final reviewData = await PlacesService.fetchPlaceReviews(
          widget.placeId, 'AIzaSyCNNLly_rF6NkMMgoFAl5dv8lfCmu00mnY');
      setState(() {
        reviews = List<Map<String, dynamic>>.from(reviewData);
      });
    } catch (e) {
      // Manejar errores de obtención de reseñas
    }
  }

  Future<void> _launchURL() async {
    final Uri url = Uri.parse(website);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  Color _getOpenCloseColor(String status) {
    return status.toLowerCase().contains('cerrado') ? Colors.red : Colors.green;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          name.isNotEmpty ? name : 'Cargando...',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF073B4C),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.isNotEmpty ? name : 'Cargando...',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF073B4C),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.location_pin, color: Color(0xFFEF476F)),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            address,
                            style: const TextStyle(fontSize: 16, color: Colors.black54),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.phone, color: Color(0xFFF78C68)),
                        const SizedBox(width: 5),
                        Text(
                          phone,
                          style: const TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: () async {
                        final Uri url = Uri.parse(website);
                        if (await canLaunchUrl(url)) { // Cambia canLaunch por canLaunchUrl
                          await launchUrl(url, mode: LaunchMode.externalApplication); // Cambia launch por launchUrl
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('No se pudo abrir el sitio web: $website')),
                          );
                        }
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.web, color: Color(0xFF118AB2)),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              website,
                              style: const TextStyle(fontSize: 16, color: Colors.black54),
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
                        const Icon(Icons.star, color: Color(0xFFFFD166)),
                        const SizedBox(width: 5),
                        Text(
                          'Calificación: $rating',
                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ],
                    ),
                    Text(
                      'Número de Reseñas: $reviewsCount',
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
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
                PhotoGallery(images: images),
                NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.axis == Axis.horizontal) {
                      return true; // Detener el evento si se desliza horizontalmente
                    }
                    return false; // Permitir el desplazamiento vertical
                  },
                  child: reviews.isNotEmpty
                      ? ListView.builder(
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      return ReviewWidget(
                        reviewerName: reviews[index]['reviewer_name'],
                        reviewText: reviews[index]['review_text'],
                        rating: reviews[index]['rating'],
                        photos: List<String>.from(reviews[index]['photos'] ?? []),
                      );
                    },
                  )
                      : const Center(child: Text('No hay reseñas disponibles')),
                ),
                if (openingHours.isNotEmpty)
                  SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DataTable(
                        columns: const [
                          DataColumn(
                            label: Text('Día', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          DataColumn(
                            label: Text('Horario', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          DataColumn(
                            label: Text('Estado', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                        rows: openingHours.entries.map((entry) {
                          return DataRow(cells: [
                            DataCell(Text(entry.key)),
                            DataCell(Text(entry.value)),
                            DataCell(
                              Text(
                                entry.value.contains('cerrado') ? 'Cerrado' : 'Abierto',
                                style: TextStyle(color: _getOpenCloseColor(entry.value)),
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  )
                else
                  const Center(child: Text('Horarios no disponibles')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
