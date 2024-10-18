import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../pruebas/maps_screen.dart'; // Importa la nueva pantalla
import '../pruebas/widgets_details/place_adress.dart';
import '../pruebas/widgets_details/place_bussines.dart';
import '../pruebas/widgets_details/place_geometry.dart';
import '../pruebas/widgets_details/place_name.dart';
import '../pruebas/widgets_details/place_phonenumber.dart';
import '../pruebas/widgets_details/place_photos.dart';
import '../pruebas/widgets_details/place_website.dart';

class PlaceDetailsScreen extends StatefulWidget {
  final String placeId;

  const PlaceDetailsScreen({required this.placeId, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PlaceDetailsScreenState createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  Map<String, dynamic>? placeDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPlaceDetails();
  }

  Future<void> fetchPlaceDetails() async {
    final response = await http.get(Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json?place_id=${widget.placeId}&fields=address_components,adr_address,business_status,formatted_address,geometry,icon,icon_mask_base_uri,icon_background_color,name,permanently_closed,photo,place_id,plus_code,type,url,utc_offset,vicinity,wheelchair_accessible_entrance,formatted_phone_number,international_phone_number,opening_hours,website,price_level,rating,user_ratings_total&key=AIzaSyCNNLly_rF6NkMMgoFAl5dv8lfCmu00mnY'));

    if (response.statusCode == 200) {
      setState(() {
        placeDetails = json.decode(response.body)['result'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del lugar'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : placeDetails != null
              ? ListView(
                  // padding: const EdgeInsets.all(16),
                  children: [
                    if (placeDetails!['name'] != null)
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 12,
                        ),
                        child: PlaceName(name: placeDetails!['name']),
                      ),
                    const SizedBox(height: 10),

                    if (placeDetails!['formatted_address'] != null)
                      Padding(
 padding: const EdgeInsets.only(
                          left: 12,
                        ),                        child: PlaceAddress(address: placeDetails!['formatted_address']),
                      ),
                    const SizedBox(height: 10),

                    if (placeDetails!['formatted_phone_number'] != null)
                      Padding(
 padding: const EdgeInsets.only(
                          left: 12,
                        ),                        child: PlacePhoneNumber(phoneNumber: placeDetails!['formatted_phone_number']),
                      ),
                    const SizedBox(height: 10),

                    if (placeDetails!['website'] != null)
                      Padding(
 padding: const EdgeInsets.only(
                          left: 12,
                        ),                        child: PlaceWebsite(website: placeDetails!['website']),
                      ),
                    const SizedBox(height: 10),

                    if (placeDetails!['business_status'] != null)
                      Padding(
 padding: const EdgeInsets.only(
                          left: 12,
                        ),                        child: BusinessStatus(status: placeDetails!['business_status']),
                      ),
                    const SizedBox(height: 20),

                    if (placeDetails!['photos'] != null && placeDetails!['photos'].isNotEmpty)
                      PlacePhotos(photos: placeDetails!['photos']),
                    const SizedBox(height: 20),

                    if (placeDetails!['geometry'] != null)
                      Padding(
 padding: const EdgeInsets.only(
                          left: 12,
                        ),                        child: PlaceGeometry(location: placeDetails!['geometry']['location']),
                      ),
                    const SizedBox(height: 20),

                  // Botón para ver ubicación en el mapa
                  ElevatedButton(
                    onPressed: () {
                      final location = placeDetails!['geometry']['location'];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapScreen(
                            latitude: location['lat'],
                            longitude: location['lng'],
                            placeId: placeDetails!['place_id'], // Asegúrate de pasar el placeId
                          ),
                        ),
                      );
                    },
                      child: const Text('Ver en el mapa'),
                    ),
                  ],
                )
              : const Center(child: Text('No se pudieron cargar los detalles del lugar')),
    );
  }
}
